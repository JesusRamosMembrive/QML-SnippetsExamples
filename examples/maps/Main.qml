import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtLocation
import QtPositioning

import utils
import qmlsnippetsstyle

Item {
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    anchors.fill: parent

    // ── Simulation state ──────────────────────────────────────
    property bool playing: false
    property real simSpeed: 1.0
    property int currentSegment: 0
    property real segmentProgress: 0.0
    property bool followAircraft: true

    // Computed aircraft position / heading
    property real aircraftLat: waypoints[0].lat
    property real aircraftLon: waypoints[0].lon
    property real aircraftHeading: 0.0

    // Route over Madrid landmarks
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

    // ── Bearing calculation ───────────────────────────────────
    function calcBearing(lat1, lon1, lat2, lon2) {
        var toRad = Math.PI / 180
        var dLon = (lon2 - lon1) * toRad
        var y = Math.sin(dLon) * Math.cos(lat2 * toRad)
        var x = Math.cos(lat1 * toRad) * Math.sin(lat2 * toRad) -
                Math.sin(lat1 * toRad) * Math.cos(lat2 * toRad) * Math.cos(dLon)
        var brng = Math.atan2(y, x) * 180 / Math.PI
        return (brng + 360) % 360
    }

    // ── Simulation engine ─────────────────────────────────────
    Timer {
        id: simTimer
        interval: 50
        repeat: true
        running: root.playing && root.fullSize
        onTriggered: root.advanceSimulation()
    }

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

        aircraftLat = wp1.lat + (wp2.lat - wp1.lat) * t
        aircraftLon = wp1.lon + (wp2.lon - wp1.lon) * t
        aircraftHeading = calcBearing(wp1.lat, wp1.lon, wp2.lat, wp2.lon)

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

    // ── UI ────────────────────────────────────────────────────
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

            // Map container
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

                        // Route polyline
                        MapPolyline {
                            id: routeLine
                            line.width: 3
                            line.color: Style.mainColor
                        }

                        // Waypoint markers
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

                        // Aircraft marker
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

                                        // Aircraft arrow shape
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

                    // Interaction handlers
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

                    WheelHandler {
                        onWheel: function(event) {
                            var loc = map.toCoordinate(point.position)
                            map.zoomLevel = Math.max(map.minimumZoomLevel,
                                Math.min(map.maximumZoomLevel,
                                    map.zoomLevel + event.angleDelta.y / 120))
                            map.alignCoordinateToPoint(loc, point.position)
                        }
                    }

                    DragHandler {
                        target: null
                        grabPermissions: PointerHandler.TakeOverForbidden
                        onTranslationChanged: function(delta) {
                            map.pan(-delta.x, -delta.y)
                            root.followAircraft = false
                        }
                    }

                    // Overlays
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

    // Set route polyline path on load and initialize heading
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
