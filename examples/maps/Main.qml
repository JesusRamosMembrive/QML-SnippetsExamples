// =============================================================================
// Main.qml — Demo de OpenStreetMap con simulacion de vuelo animada
// =============================================================================
// Ejemplo completo de integracion con QtLocation: muestra un mapa OSM real
// con una ruta de vuelo sobre Madrid, un avion animado que recorre la ruta,
// controles de simulacion (play/pause/reset/velocidad) y overlays informativos.
//
// Patrones y conceptos clave:
// - QtLocation.Map + Plugin "osm" para mapas OpenStreetMap sin API key.
// - MapPolyline, MapItemView y MapQuickItem para superponer graficos
//   vectoriales y widgets QML sobre el mapa.
// - Motor de simulacion con Timer: avanza la posicion del avion interpolando
//   entre waypoints. La velocidad es configurable (1x/2x/4x).
// - PinchHandler + WheelHandler + DragHandler para interaccion tactil
//   y de raton con el mapa (zoom, pan, pinch-to-zoom).
// - Calculo de bearing (rumbo) con formula de esfera usando atan2.
// - Componentes overlay (MapCompassOverlay, MapInfoPanel, MapControlsBar)
//   posicionados sobre el mapa con anchors.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtLocation
import QtPositioning

import utils
import qmlsnippetsstyle

Item {
    id: root

    // Patron de visibilidad del dashboard
    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    anchors.fill: parent

    // ── Estado de la simulacion ─────────────────────────────────
    // La simulacion interpola la posicion del avion entre segmentos
    // de waypoints. currentSegment indica que segmento se recorre,
    // segmentProgress (0.0-1.0) indica cuanto se ha avanzado en el.
    property bool playing: false
    property real simSpeed: 1.0
    property int currentSegment: 0
    property real segmentProgress: 0.0
    property bool followAircraft: true

    // Posicion y rumbo calculados del avion (actualizados por el timer)
    property real aircraftLat: waypoints[0].lat
    property real aircraftLon: waypoints[0].lon
    property real aircraftHeading: 0.0

    // Ruta sobre puntos de referencia de Madrid.
    // Cada waypoint tiene coordenadas reales (lat/lon) y un nombre.
    // La ruta empieza y termina en LEMD (aeropuerto de Barajas).
    property var waypoints: [
        { lat: 40.4936, lon: -3.5668, name: "LEMD" },
        { lat: 40.4530, lon: -3.6883, name: "CHAMARTIN" },
        { lat: 40.4232, lon: -3.7125, name: "RETIRO" },
        { lat: 40.4153, lon: -3.7074, name: "PRADO" },
        { lat: 40.4168, lon: -3.7038, name: "SOL" },
        { lat: 40.4065, lon: -3.6920, name: "ATOCHA" },
        { lat: 40.3920, lon: -3.7250, name: "SUR" },
        { lat: 40.4020, lon: -3.7540, name: "CASA CAMPO" },
        { lat: 40.4250, lon: -3.7145, name: "PALACIO" },
        { lat: 40.4530, lon: -3.6883, name: "CHAMARTIN" },
        { lat: 40.4936, lon: -3.5668, name: "LEMD" }
    ]

    // ── Calculo de rumbo (bearing) ──────────────────────────────
    // Formula de navegacion esferica: calcula el rumbo inicial desde
    // un punto a otro usando la formula de Haversine simplificada.
    // Retorna grados (0-360) donde 0=norte, 90=este, etc.
    function calcBearing(lat1, lon1, lat2, lon2) {
        var toRad = Math.PI / 180
        var dLon = (lon2 - lon1) * toRad
        var y = Math.sin(dLon) * Math.cos(lat2 * toRad)
        var x = Math.cos(lat1 * toRad) * Math.sin(lat2 * toRad) -
                Math.sin(lat1 * toRad) * Math.cos(lat2 * toRad) * Math.cos(dLon)
        var brng = Math.atan2(y, x) * 180 / Math.PI
        return (brng + 360) % 360
    }

    // ── Motor de simulacion ─────────────────────────────────────
    // Timer a 50ms (20 fps) que llama advanceSimulation() en cada tick.
    // Solo corre cuando playing=true Y la pagina esta visible (fullSize).
    // Esto evita consumir CPU cuando la pagina no esta activa.
    Timer {
        id: simTimer
        interval: 50
        repeat: true
        running: root.playing && root.fullSize
        onTriggered: root.advanceSimulation()
    }

    // Avanza la simulacion un paso. Interpola linealmente lat/lon entre
    // el waypoint actual y el siguiente. Cuando segmentProgress llega a 1.0,
    // pasa al siguiente segmento. Si es el ultimo, para la simulacion.
    function advanceSimulation() {
        if (currentSegment >= waypoints.length - 1) {
            playing = false
            return
        }

        var dt = simTimer.interval / 1000.0
        var segmentDuration = 5.0 / simSpeed

        segmentProgress += dt / segmentDuration

        if (segmentProgress >= 1.0) {
            segmentProgress = 0.0
            currentSegment++
            if (currentSegment >= waypoints.length - 1) {
                playing = false
                return
            }
        }

        var wp1 = waypoints[currentSegment]
        var wp2 = waypoints[currentSegment + 1]
        var t = segmentProgress

        // Interpolacion lineal entre waypoints
        aircraftLat = wp1.lat + (wp2.lat - wp1.lat) * t
        aircraftLon = wp1.lon + (wp2.lon - wp1.lon) * t
        aircraftHeading = calcBearing(wp1.lat, wp1.lon, wp2.lat, wp2.lon)

        // Si followAircraft esta activo, el mapa sigue al avion
        if (followAircraft) {
            map.center = QtPositioning.coordinate(aircraftLat, aircraftLon)
        }
    }

    function resetSimulation() {
        playing = false
        currentSegment = 0
        segmentProgress = 0.0
        aircraftLat = waypoints[0].lat
        aircraftLon = waypoints[0].lon
        aircraftHeading = calcBearing(waypoints[0].lat, waypoints[0].lon,
                                       waypoints[1].lat, waypoints[1].lon)
        followAircraft = true
        map.center = QtPositioning.coordinate(aircraftLat, aircraftLon)
        map.zoomLevel = 13
    }

    // ── Interfaz de usuario ─────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Style.resize(20)
            spacing: Style.resize(10)

            Label {
                text: "OpenStreetMap Demo"
                font.pixelSize: Style.resize(32)
                font.bold: true
                color: Style.mainColor
                Layout.fillWidth: true
            }

            // ── Contenedor del mapa ─────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Style.cardColor
                radius: Style.resize(8)
                clip: true

                Item {
                    id: mapContainer
                    anchors.fill: parent
                    anchors.margins: Style.resize(4)

                    // ── Mapa OSM ────────────────────────────────
                    // Plugin "osm" proporciona tiles de OpenStreetMap gratis.
                    // El parametro providersrepository.disabled evita consultas
                    // a repositorios de proveedores externos (solo usa el default).
                    Map {
                        id: map
                        anchors.fill: parent

                        plugin: Plugin {
                            name: "osm"
                            PluginParameter {
                                name: "osm.mapping.providersrepository.disabled"
                                value: "true"
                            }
                        }

                        center: QtPositioning.coordinate(40.4936, -3.5668)
                        zoomLevel: 13

                        // Linea de ruta: MapPolyline dibuja la ruta completa.
                        // El path se establece en Component.onCompleted.
                        MapPolyline {
                            id: routeLine
                            line.width: 3
                            line.color: Style.mainColor
                        }

                        // ── Marcadores de waypoints ─────────────
                        // MapItemView funciona como un Repeater para el mapa:
                        // genera un MapQuickItem por cada waypoint.
                        // Los waypoints ya visitados se muestran en mainColor,
                        // los pendientes en gris.
                        MapItemView {
                            model: root.waypoints.length

                            delegate: MapQuickItem {
                                required property int index

                                coordinate: QtPositioning.coordinate(
                                    root.waypoints[index].lat,
                                    root.waypoints[index].lon
                                )
                                anchorPoint.x: 8
                                anchorPoint.y: 8

                                sourceItem: Column {
                                    spacing: 2

                                    Rectangle {
                                        width: 16; height: 16; radius: 8
                                        color: index <= root.currentSegment
                                               ? Style.mainColor : "#AAAAAA"
                                        border.color: "white"
                                        border.width: 2
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }

                                    // Etiqueta del waypoint: solo visible con
                                    // zoom >= 12 para evitar solapamiento a niveles bajos
                                    Rectangle {
                                        color: Qt.rgba(0, 0, 0, 0.6)
                                        radius: 3
                                        width: wpLabel.implicitWidth + 6
                                        height: wpLabel.implicitHeight + 2
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        visible: map.zoomLevel >= 12

                                        Label {
                                            id: wpLabel
                                            anchors.centerIn: parent
                                            text: root.waypoints[index].name
                                            font.pixelSize: 10
                                            font.bold: true
                                            color: "white"
                                        }
                                    }
                                }
                            }
                        }

                        // ── Marcador del avion ──────────────────
                        // MapQuickItem posiciona un Canvas con forma de flecha
                        // en las coordenadas del avion. La propiedad rotation
                        // del Canvas se vincula al heading para que apunte
                        // en la direccion de vuelo.
                        MapQuickItem {
                            id: aircraftMarker
                            coordinate: QtPositioning.coordinate(root.aircraftLat, root.aircraftLon)
                            anchorPoint.x: 16
                            anchorPoint.y: 16

                            sourceItem: Item {
                                width: 32
                                height: 32

                                Canvas {
                                    id: aircraftIcon
                                    anchors.fill: parent
                                    rotation: root.aircraftHeading

                                    onPaint: {
                                        var ctx = getContext("2d")
                                        ctx.clearRect(0, 0, width, height)
                                        var cx = width / 2
                                        var cy = height / 2

                                        ctx.fillStyle = "#FF3333"
                                        ctx.beginPath()
                                        ctx.moveTo(cx, cy - 14)
                                        ctx.lineTo(cx - 9, cy + 10)
                                        ctx.lineTo(cx, cy + 5)
                                        ctx.lineTo(cx + 9, cy + 10)
                                        ctx.closePath()
                                        ctx.fill()

                                        ctx.strokeStyle = "white"
                                        ctx.lineWidth = 1.5
                                        ctx.stroke()
                                    }

                                    Component.onCompleted: requestPaint()
                                }
                            }
                        }
                    }

                    // ── Handlers de interaccion con el mapa ─────
                    // Estos handlers NO son hijos del Map, sino del mapContainer.
                    // Esto evita conflictos con los gestos internos del Map.

                    // PinchHandler: zoom con pellizco tactil.
                    // Guarda la coordenada central al inicio y la usa con
                    // alignCoordinateToPoint para mantener el punto de enfoque.
                    PinchHandler {
                        target: null
                        grabPermissions: PointerHandler.TakeOverForbidden

                        property var startCentroid

                        onActiveChanged: {
                            if (active) {
                                startCentroid = map.toCoordinate(centroid.position, false)
                                root.followAircraft = false
                            }
                        }
                        onScaleChanged: function(delta) {
                            map.zoomLevel += Math.log2(delta)
                            map.alignCoordinateToPoint(startCentroid, centroid.position)
                        }
                    }

                    // WheelHandler: zoom con rueda del raton centrado en el cursor
                    WheelHandler {
                        onWheel: function(event) {
                            var loc = map.toCoordinate(point.position)
                            map.zoomLevel = Math.max(map.minimumZoomLevel,
                                Math.min(map.maximumZoomLevel,
                                    map.zoomLevel + event.angleDelta.y / 120))
                            map.alignCoordinateToPoint(loc, point.position)
                        }
                    }

                    // DragHandler: panning con arrastre. Desactiva followAircraft
                    // cuando el usuario mueve el mapa manualmente.
                    DragHandler {
                        target: null
                        grabPermissions: PointerHandler.TakeOverForbidden
                        onTranslationChanged: function(delta) {
                            map.pan(-delta.x, -delta.y)
                            root.followAircraft = false
                        }
                    }

                    // ── Overlays sobre el mapa ──────────────────
                    // Componentes posicionados con anchors sobre el contenedor
                    // del mapa. Cada uno tiene su propio archivo QML.
                    MapCompassOverlay {
                        heading: root.aircraftHeading
                    }

                    MapInfoPanel {
                        aircraftHeading: root.aircraftHeading
                        aircraftLat: root.aircraftLat
                        aircraftLon: root.aircraftLon
                        currentSegment: root.currentSegment
                        waypoints: root.waypoints
                        simSpeed: root.simSpeed
                    }

                    MapControlsBar {
                        playing: root.playing
                        simSpeed: root.simSpeed
                        followAircraft: root.followAircraft
                        onPlayToggled: root.playing = !root.playing
                        onResetClicked: root.resetSimulation()
                        onSpeedSelected: (speed) => root.simSpeed = speed
                        onFollowClicked: {
                            root.followAircraft = !root.followAircraft
                            if (root.followAircraft) {
                                map.center = QtPositioning.coordinate(
                                    root.aircraftLat, root.aircraftLon)
                            }
                        }
                    }

                } // mapContainer
            } // map card
        }
    }

    // Inicializacion: construye el path de la ruta como array de coordenadas
    // QtPositioning y calcula el heading inicial del avion.
    Component.onCompleted: {
        var coords = []
        for (var i = 0; i < waypoints.length; i++) {
            coords.push(QtPositioning.coordinate(waypoints[i].lat, waypoints[i].lon))
        }
        routeLine.path = coords

        aircraftHeading = calcBearing(waypoints[0].lat, waypoints[0].lon,
                                       waypoints[1].lat, waypoints[1].lon)
    }
}
