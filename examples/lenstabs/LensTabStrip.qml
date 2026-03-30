pragma ComponentBehavior: Bound

import QtQuick
import utils

Item {
    id: root

    property var  tabs:          ["Explore", "Library", "Signals", "Profile"]
    property int  currentIndex:  0
    property int  travelDuration: 320
    property real magnification:  1.6
    property real glowStrength:   0.30
    property real aberration:     0.012
    property real rimBrightness:  0.6
    property real lensWiden:      2.2    // ensanche horizontal (1.0=circular, 2.0=doble ancho)
    property real lensInset:      Style.resize(5)   // no usado visualmente; mantenido por compatibilidad API
    property color trackColor:    Style.surfaceColor
    property color tabTextColor:  Style.fontSecondaryColor

    readonly property int tabCount: Math.max(1, tabs.length)

    signal tabTriggered(int index, string label)

    implicitHeight: Style.resize(56)

    // ── Posición animada de la lente (centro X en píxeles dentro del track) ─
    property real lensTargetX: 0.0

    function syncLens() {
        if (track.width <= 0) return
        const tabW = track.width / root.tabCount
        root.lensTargetX = (root.currentIndex + 0.5) * tabW
    }

    onCurrentIndexChanged: Qt.callLater(syncLens)
    onWidthChanged:        Qt.callLater(syncLens)
    onTabsChanged:         Qt.callLater(syncLens)
    Component.onCompleted: Qt.callLater(syncLens)

    // ── Track ─────────────────────────────────────────────────────────────────
    Rectangle {
        id: track
        anchors.fill: parent
        radius: height / 2
        color: root.trackColor
        border.color: Qt.rgba(1, 1, 1, 0.06)
        border.width: 1
        clip: false

        // Gradiente interior de profundidad
        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: (height - 2) / 2
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.04) }
                GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.12) }
            }
        }

        // ── Contenido capturado como textura para el shader ────────────────
        // Este ítem se oculta via hideSource=true; el shader lo renderiza.
        Item {
            id: tabContent
            anchors.fill: parent

            // Fondo sólido (mismo color que el track) para que la textura
            // no sea transparente y la lente tenga contenido que ampliar.
            Rectangle {
                anchors.fill: parent
                radius: parent.height / 2
                color: root.trackColor
            }

            // Etiquetas de las tabs
            Row {
                anchors.fill: parent

                Repeater {
                    id: tabRepeater
                    model: root.tabs

                    delegate: Item {
                        id: tabDelegate
                        required property int  index
                        required property var  modelData

                        width:  tabContent.width  / root.tabCount
                        height: tabContent.height

                        Text {
                            anchors.centerIn: parent
                            text:             String(tabDelegate.modelData)
                            font.family:      Style.fontFamilyBold
                            font.pixelSize:   Style.resize(14)
                            font.letterSpacing: 0.4
                            color:            root.tabTextColor
                        }
                    }
                }
            }
        }

        // Textura fuente para el ShaderEffect
        ShaderEffectSource {
            id: tabSource
            sourceItem: tabContent
            hideSource:  true   // oculta tabContent; el shader lo muestra
            anchors.fill: parent
            visible:      false
        }

        // ── Lente circular GPU ─────────────────────────────────────────────
        // Cubre todo el track: fuera de la lente muestra el contenido normal
        // (pass-through del source); dentro aplica los efectos ópticos.
        LensCircleEffect {
            id: lensEffect
            anchors.fill: parent
            source:        tabSource
            lensX:         lensProxy.x / parent.width
            lensY:         0.5
            lensRadius:    0.54
            aspectRatio:   width / height
            magnification: root.magnification
            aberration:    root.aberration
            rimBrightness: root.rimBrightness
            lensWiden:     root.lensWiden
        }

        // ── Proxy de animación para la posición X de la lente ─────────────
        Item {
            id: lensProxy
            x: root.lensTargetX
            Behavior on x {
                NumberAnimation { duration: root.travelDuration; easing.type: Easing.InOutCubic }
            }
        }

        // ── Capa de MouseAreas (encima del shader, invisible) ──────────────
        Row {
            anchors.fill: parent

            Repeater {
                model: root.tabs

                delegate: Item {
                    id: mouseDelegate
                    required property int  index
                    required property var  modelData

                    width:  track.width / root.tabCount
                    height: track.height

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.currentIndex = mouseDelegate.index
                            root.tabTriggered(mouseDelegate.index,
                                              String(mouseDelegate.modelData))
                        }
                    }
                }
            }
        }
    }
}
