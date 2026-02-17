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
                color: "white"
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

                    // ── Compass overlay (bottom-left) ─────────────────
                    Rectangle {
                        id: compassContainer
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        anchors.leftMargin: Style.resize(15)
                        anchors.bottomMargin: Style.resize(65)
                        width: Style.resize(140)
                        height: width
                        radius: width / 2
                        color: Qt.rgba(0, 0, 0, 0.65)
                        border.color: Qt.rgba(1, 1, 1, 0.25)
                        border.width: 1

                        Canvas {
                            id: compassCanvas
                            anchors.fill: parent
                            anchors.margins: Style.resize(5)

                            property real hdg: root.aircraftHeading

                            onHdgChanged: requestPaint()

                            onPaint: {
                                var ctx = getContext("2d")
                                var w = width
                                var h = height
                                var cx = w / 2
                                var cy = h / 2
                                var r = Math.min(cx, cy) - 14

                                ctx.clearRect(0, 0, w, h)

                                var green = "#00FF00"
                                var white = "#FFFFFF"

                                // Outer ring
                                ctx.strokeStyle = "#666666"
                                ctx.lineWidth = 1.5
                                ctx.beginPath()
                                ctx.arc(cx, cy, r + 4, 0, 2 * Math.PI)
                                ctx.stroke()

                                // Rotating compass card
                                ctx.save()
                                ctx.translate(cx, cy)
                                ctx.rotate(-hdg * Math.PI / 180)

                                // Tick marks every 5 degrees
                                for (var deg = 0; deg < 360; deg += 5) {
                                    var rad = (deg - 90) * Math.PI / 180
                                    var isCardinal = (deg % 90 === 0)
                                    var isMajor = (deg % 10 === 0)
                                    var innerR
                                    if (isCardinal) innerR = r - 16
                                    else if (isMajor) innerR = r - 9
                                    else innerR = r - 5

                                    ctx.strokeStyle = isCardinal ? white : "#888888"
                                    ctx.lineWidth = isCardinal ? 2 : 1
                                    ctx.beginPath()
                                    ctx.moveTo(Math.cos(rad) * innerR, Math.sin(rad) * innerR)
                                    ctx.lineTo(Math.cos(rad) * r, Math.sin(rad) * r)
                                    ctx.stroke()
                                }

                                // Labels every 30 degrees
                                ctx.textAlign = "center"
                                ctx.textBaseline = "middle"
                                ctx.font = "bold " + (r * 0.13) + "px sans-serif"

                                var labels = [
                                    { deg: 0, text: "N", color: white },
                                    { deg: 30, text: "3", color: green },
                                    { deg: 60, text: "6", color: green },
                                    { deg: 90, text: "E", color: white },
                                    { deg: 120, text: "12", color: green },
                                    { deg: 150, text: "15", color: green },
                                    { deg: 180, text: "S", color: white },
                                    { deg: 210, text: "21", color: green },
                                    { deg: 240, text: "24", color: green },
                                    { deg: 270, text: "W", color: white },
                                    { deg: 300, text: "30", color: green },
                                    { deg: 330, text: "33", color: green }
                                ]

                                for (var i = 0; i < labels.length; i++) {
                                    var l = labels[i]
                                    var lrad = (l.deg - 90) * Math.PI / 180
                                    var labelR = r - 26
                                    ctx.fillStyle = l.color
                                    ctx.fillText(l.text,
                                        Math.cos(lrad) * labelR,
                                        Math.sin(lrad) * labelR)
                                }

                                // North arrow (red triangle)
                                ctx.fillStyle = "#FF4444"
                                var nRad = -Math.PI / 2
                                var nR = r + 1
                                ctx.beginPath()
                                ctx.moveTo(Math.cos(nRad) * nR, Math.sin(nRad) * nR)
                                ctx.lineTo(Math.cos(nRad - 0.08) * (nR - 12),
                                           Math.sin(nRad - 0.08) * (nR - 12))
                                ctx.lineTo(Math.cos(nRad + 0.08) * (nR - 12),
                                           Math.sin(nRad + 0.08) * (nR - 12))
                                ctx.closePath()
                                ctx.fill()

                                ctx.restore()

                                // Fixed lubber line (yellow triangle at top)
                                ctx.fillStyle = "#FFFF00"
                                ctx.beginPath()
                                ctx.moveTo(cx, cy - r - 6)
                                ctx.lineTo(cx - 6, cy - r + 4)
                                ctx.lineTo(cx + 6, cy - r + 4)
                                ctx.closePath()
                                ctx.fill()

                                // Center dot
                                ctx.fillStyle = white
                                ctx.beginPath()
                                ctx.arc(cx, cy, 2.5, 0, 2 * Math.PI)
                                ctx.fill()

                                // Heading readout box
                                var hdgStr = Math.round(hdg).toString().padStart(3, "0")
                                ctx.fillStyle = "#000000"
                                ctx.fillRect(cx - 20, 3, 40, 16)
                                ctx.strokeStyle = green
                                ctx.lineWidth = 1
                                ctx.strokeRect(cx - 20, 3, 40, 16)
                                ctx.fillStyle = green
                                ctx.font = "bold " + (r * 0.10) + "px sans-serif"
                                ctx.textAlign = "center"
                                ctx.textBaseline = "middle"
                                ctx.fillText(hdgStr + "\u00B0", cx, 11)
                            }
                        }
                    }

                    // ── Info panel (top-right) ────────────────────────
                    Rectangle {
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.margins: Style.resize(12)
                        width: Style.resize(190)
                        implicitHeight: infoColumn.implicitHeight + Style.resize(20)
                        color: Qt.rgba(0, 0, 0, 0.7)
                        radius: Style.resize(8)

                        ColumnLayout {
                            id: infoColumn
                            anchors.fill: parent
                            anchors.margins: Style.resize(10)
                            spacing: Style.resize(3)

                            Label {
                                text: "Flight Info"
                                font.pixelSize: Style.resize(14)
                                font.bold: true
                                color: Style.mainColor
                            }

                            Label {
                                text: "HDG  " + Math.round(root.aircraftHeading).toString().padStart(3, "0") + "\u00B0"
                                font.pixelSize: Style.resize(12)
                                font.family: "monospace"
                                color: "#00FF00"
                            }

                            Label {
                                text: "LAT  " + root.aircraftLat.toFixed(4)
                                font.pixelSize: Style.resize(12)
                                font.family: "monospace"
                                color: "white"
                            }

                            Label {
                                text: "LON  " + root.aircraftLon.toFixed(4)
                                font.pixelSize: Style.resize(12)
                                font.family: "monospace"
                                color: "white"
                            }

                            Label {
                                text: "WPT  " + (root.currentSegment < root.waypoints.length
                                    ? root.waypoints[root.currentSegment].name : "---")
                                font.pixelSize: Style.resize(12)
                                font.family: "monospace"
                                color: "#00FF00"
                            }

                            Label {
                                text: "SEG  " + (root.currentSegment + 1) + "/" + (root.waypoints.length - 1)
                                font.pixelSize: Style.resize(12)
                                font.family: "monospace"
                                color: "white"
                            }

                            Label {
                                text: "SPD  " + root.simSpeed.toFixed(0) + "x"
                                font.pixelSize: Style.resize(12)
                                font.family: "monospace"
                                color: "white"
                            }
                        }
                    }

                    // ── Controls bar (bottom-center) ──────────────────
                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottomMargin: Style.resize(15)
                        width: controlsRow.implicitWidth + Style.resize(30)
                        height: Style.resize(44)
                        radius: Style.resize(22)
                        color: Qt.rgba(0, 0, 0, 0.75)
                        border.color: Qt.rgba(1, 1, 1, 0.15)
                        border.width: 1

                        RowLayout {
                            id: controlsRow
                            anchors.centerIn: parent
                            spacing: Style.resize(8)

                            // Reset
                            Label {
                                text: "\u23EE"
                                font.pixelSize: Style.resize(20)
                                color: resetMa.containsMouse ? "white" : "#CCCCCC"

                                MouseArea {
                                    id: resetMa
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.resetSimulation()
                                }
                            }

                            // Play / Pause
                            Label {
                                text: root.playing ? "\u23F8" : "\u25B6"
                                font.pixelSize: Style.resize(22)
                                color: playMa.containsMouse ? Style.mainColor : "white"

                                MouseArea {
                                    id: playMa
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.playing = !root.playing
                                }
                            }

                            // Separator
                            Rectangle {
                                width: 1
                                height: Style.resize(20)
                                color: "#555555"
                            }

                            // Speed buttons
                            Repeater {
                                model: [1, 2, 4]

                                Label {
                                    required property real modelData

                                    text: modelData + "x"
                                    font.pixelSize: Style.resize(13)
                                    font.bold: root.simSpeed === modelData
                                    color: root.simSpeed === modelData
                                           ? Style.mainColor
                                           : (spdMa.containsMouse ? "white" : "#AAAAAA")

                                    MouseArea {
                                        id: spdMa
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: root.simSpeed = parent.modelData
                                    }
                                }
                            }

                            // Separator
                            Rectangle {
                                width: 1
                                height: Style.resize(20)
                                color: "#555555"
                            }

                            // Follow toggle
                            Label {
                                text: root.followAircraft ? "\uD83D\uDCCD Follow" : "\uD83D\uDD13 Free"
                                font.pixelSize: Style.resize(12)
                                color: followMa.containsMouse
                                       ? "white"
                                       : (root.followAircraft ? Style.mainColor : "#AAAAAA")

                                MouseArea {
                                    id: followMa
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        root.followAircraft = !root.followAircraft
                                        if (root.followAircraft) {
                                            map.center = QtPositioning.coordinate(
                                                root.aircraftLat, root.aircraftLon)
                                        }
                                    }
                                }
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
