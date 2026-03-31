// =============================================================================
// LensTabStrip.qml — Barra de tabs con fondo frost glass y lente óptica
// =============================================================================
// El track es un cristal esmerilado (ShaderEffectSource + MultiEffect blur +
// tinte blanco + borde luminoso). El indicador de tab es un LensCircleEffect
// circular que muestra el fondo crudo amplificado con óptica real de cristal.
//
// Propiedad `tabs`: array de strings o de objetos {icon, label}.
// Propiedad `backgroundItem`: Item del fondo real (del que se captura el blur
//   y la fuente de la lente). Si es null, se usa un color sólido de fallback.
// =============================================================================
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import utils

Item {
    id: root

    // ── API pública ────────────────────────────────────────────────────────────
    // Cada elemento puede ser un string o {icon: "⌂", label: "Home"}
    property var  tabs:           ["Explore", "Library", "Signals", "Profile"]
    property int  currentIndex:   0
    property int  travelDuration: 320

    // Fondo real para frost glass y fuente óptica de la lente
    property Item backgroundItem: null

    // Frost glass
    property real blurRadius:     28
    property real tintOpacity:    0.14
    property real borderOpacity:  0.30

    // Óptica de la lente
    property real magnification:  1.9
    property real aberration:     0.016
    property real rimBrightness:  0.75
    property real lensRadius:     0.48   // en UV-Y (0.5 = toca los bordes)

    readonly property int tabCount: Math.max(1, tabs.length)

    signal tabTriggered(int index, string label)

    implicitHeight: Style.resize(72)

    // ── Helpers para extraer icon y label ─────────────────────────────────────
    function tabLabel(t) {
        return (typeof t === "object" && t !== null) ? String(t.label ?? "") : String(t ?? "")
    }
    function tabIcon(t) {
        return (typeof t === "object" && t !== null) ? String(t.icon ?? "") : ""
    }

    // ── Posición animada de la lente ──────────────────────────────────────────
    property real lensTargetX: 0.0

    function syncLens() {
        if (track.width <= 0) return
        root.lensTargetX = (root.currentIndex + 0.5) * (track.width / root.tabCount)
    }

    onCurrentIndexChanged: Qt.callLater(syncLens)
    onWidthChanged:        Qt.callLater(syncLens)
    onTabsChanged:         Qt.callLater(syncLens)
    Component.onCompleted: Qt.callLater(syncLens)

    // ═══════════════════════════════════════════════════════════════════════════
    // Track — píldora de cristal esmerilado
    // ═══════════════════════════════════════════════════════════════════════════
    Rectangle {
        id: track
        anchors.fill: parent
        radius: height / 2
        clip:   true
        color:  "transparent"

        // ── Fallback sin backgroundItem ────────────────────────────────────
        Rectangle {
            anchors.fill: parent
            radius:       parent.radius
            color:        Style.surfaceColor
            visible:      root.backgroundItem === null || root.backgroundItem === undefined
        }

        // ── Capa 1: captura del fondo + blur ───────────────────────────────
        // Desplazado en (-root.x, -root.y) para que el clip muestre
        // exactamente la región del fondo que queda detrás del track.
        ShaderEffectSource {
            id: bgCapture
            sourceItem: root.backgroundItem
            x: root.backgroundItem ? -root.x : 0
            y: root.backgroundItem ? -root.y : 0
            width:      root.backgroundItem ? root.backgroundItem.width  : track.width
            height:     root.backgroundItem ? root.backgroundItem.height : track.height
            hideSource: false
            live:       true
            visible:    false   // MultiEffect lo renderiza
        }

        MultiEffect {
            source:  bgCapture
            x:       bgCapture.x
            y:       bgCapture.y
            width:   bgCapture.width
            height:  bgCapture.height
            blurEnabled:    root.backgroundItem !== null && root.backgroundItem !== undefined
            blur:           1.0
            blurMax:        Math.max(4, Math.round(root.blurRadius))
            blurMultiplier: 0.5
        }

        // ── Capa 2: tinte blanco ───────────────────────────────────────────
        Rectangle {
            anchors.fill: parent
            radius:       parent.radius
            color:        Qt.rgba(1, 1, 1, root.tintOpacity)
        }

        // ── Capa 3: gradiente de profundidad ───────────────────────────────
        Rectangle {
            anchors.fill: parent
            radius:       parent.radius
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.12) }
                GradientStop { position: 0.4; color: Qt.rgba(1, 1, 1, 0.02) }
                GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.12) }
            }
        }

        // ── Capa 4: borde luminoso ─────────────────────────────────────────
        Rectangle {
            anchors.fill: parent
            radius:       parent.radius
            color:        "transparent"
            border.color: Qt.rgba(1, 1, 1, root.borderOpacity)
            border.width: 1
        }

        // ── Tabs no seleccionadas (icon + label, dimmer) ───────────────────
        Row {
            anchors.fill: parent

            Repeater {
                model: root.tabs

                delegate: Item {
                    id: tabDel
                    required property int index
                    required property var modelData

                    width:  track.width / root.tabCount
                    height: track.height

                    // Ocultar la tab seleccionada (la renderiza el indicator)
                    opacity: tabDel.index === root.currentIndex ? 0.0 : 1.0
                    Behavior on opacity { NumberAnimation { duration: 150 } }

                    Column {
                        anchors.centerIn: parent
                        spacing: Style.resize(3)

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text:           root.tabIcon(tabDel.modelData)
                            font.pixelSize: Style.resize(20)
                            color:          Qt.rgba(1, 1, 1, 0.65)
                            visible:        text !== ""
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text:           root.tabLabel(tabDel.modelData)
                            font.family:    Style.fontFamilyBold
                            font.pixelSize: Style.resize(13)
                            color:          Qt.rgba(1, 1, 1, 0.60)
                        }
                    }
                }
            }
        }

        // ── Proxy de animación (centro de la lente en píxeles del track) ───
        Item {
            id: lensProxy
            x: root.lensTargetX
            Behavior on x {
                NumberAnimation { duration: root.travelDuration; easing.type: Easing.InOutCubic }
            }
        }

        // ── Contenido del tab seleccionado (encima del frost glass, debajo
        //    de la lente; visible dentro del círculo óptico) ─────────────────
        Item {
            x: lensProxy.x - track.width / root.tabCount / 2
            y: 0
            width:  track.width / root.tabCount
            height: track.height

            Column {
                anchors.centerIn: parent
                spacing: Style.resize(3)

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.tabs.length > root.currentIndex
                          ? root.tabIcon(root.tabs[root.currentIndex]) : ""
                    font.pixelSize: Style.resize(22)
                    color:          Qt.rgba(1, 1, 1, 0.92)
                    visible:        text !== ""
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.tabs.length > root.currentIndex
                          ? root.tabLabel(root.tabs[root.currentIndex]) : ""
                    font.family:    Style.fontFamilyBold
                    font.pixelSize: Style.resize(14)
                    color:          Qt.rgba(1, 1, 1, 0.92)
                }
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // Captura del track completo (frost glass + labels) como fuente de la lente.
    // hideSource: true retira el track del scene graph; LensCircleEffect lo
    // reemplaza: fuera del círculo muestra el frost glass en pass-through, y
    // dentro amplifica el cristal esmerilado con óptica GPU real.
    // ═══════════════════════════════════════════════════════════════════════════
    ShaderEffectSource {
        id: trackCapture
        sourceItem: track
        hideSource:  true
        visible:     false
        live:        true
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // Lente circular GPU
    // Fuera del círculo → pass-through del frost glass (idéntico al track).
    // Dentro del círculo → frost glass magnificado + aberración + cristal.
    // ═══════════════════════════════════════════════════════════════════════════
    LensCircleEffect {
        id: lensEffect
        anchors.fill: track
        source:        trackCapture
        lensX:         lensProxy.x / track.width
        lensY:         0.5
        lensRadius:    root.lensRadius
        aspectRatio:   track.width / track.height
        magnification: root.magnification
        aberration:    root.aberration
        rimBrightness: root.rimBrightness
        lensWiden:     1.6   // pill: 60% más ancha que alta
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // MouseAreas (encima de todo)
    // ═══════════════════════════════════════════════════════════════════════════
    Row {
        anchors.fill: track

        Repeater {
            model: root.tabs

            delegate: Item {
                id: mouseDel
                required property int index
                required property var modelData

                width:  track.width / root.tabCount
                height: track.height

                MouseArea {
                    anchors.fill: parent
                    cursorShape:  Qt.PointingHandCursor
                    onClicked: {
                        root.currentIndex = mouseDel.index
                        root.tabTriggered(mouseDel.index,
                                          root.tabLabel(mouseDel.modelData))
                    }
                }
            }
        }
    }
}
