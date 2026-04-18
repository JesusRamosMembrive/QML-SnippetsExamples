pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

import utils
import qmlsnippetsstyle

Item {
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity { NumberAnimation { duration: 200 } }

    anchors.fill: parent

    // ── Datos de los tabs ──────────────────────────────────────────────────────
    property var tabItems: [
        { icon: "⌂", label: "Home",    eyebrow: "Inicio",     title: "El indicador sigue al fondo real",         body: "La lente no es un pill de color: es un círculo óptico que captura y amplifica exactamente el fondo que hay detrás de la barra en GPU." },
        { icon: "⊞", label: "View",    eyebrow: "Vista",      title: "Frost glass con blur gaussiano real",       body: "La barra captura el ítem de fondo como textura, aplica MultiEffect blur y superpone tinte blanco + gradiente de profundidad + borde." },
        { icon: "◉", label: "Radio",   eyebrow: "Señal",      title: "Aberración cromática en el borde",         body: "El shader separa los canales R, G y B al amplificar, produciendo el fringing cromático propio del cristal real en los bordes de la lente." },
        { icon: "♪", label: "Library", eyebrow: "Biblioteca", title: "Transparent fuera, óptico dentro",         body: "El shader devuelve alpha = 0 fuera del círculo de la lente. El frost glass y los labels del track son visibles a través de esa área." }
    ]

    property int  currentTabIndex:   0
    property int  travelDuration:    320
    property real magnification:     0.6
    property real aberration:        0.016
    property real rimBrightness:     0.0
    property real lensRadius:        0.46
    property real blurRadius:        28
    property real tintOpacity:       0.14
    property real borderOpacity:     0.30
    property bool frostEnabled:      true
    property bool lightMode:         false

    // Efectos de vidrio (todos a 0 por defecto)
    property real tintStrength:         0.0
    property real noiseStrength:        0.0
    property real vignetteStrength:     0.0
    property real causticStrength:      0.0
    property real bottomShadowStrength: 0.0

    readonly property var currentTab: tabItems[Math.max(0, Math.min(currentTabIndex, tabItems.length - 1))]

    // ── Fondo oscuro de página ─────────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        Rectangle {
            anchors.top:   parent.top
            anchors.left:  parent.left
            anchors.right: parent.right
            height: Style.resize(280)
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(0.0, 0.82, 0.66, 0.10) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(28)

                // ── Cabecera ───────────────────────────────────────────────────
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Style.resize(10)

                    Text {
                        text: "Lens Tabs"
                        font.family:    Style.fontFamilyBold
                        font.pixelSize: Style.resize(34)
                        font.bold:      true
                        color:          Style.mainColor
                    }

                    Text {
                        Layout.fillWidth: true
                        wrapMode:       Text.WordWrap
                        font.pixelSize: Style.fontSizeS
                        color:          Style.fontSecondaryColor
                        text: "La barra es cristal esmerilado (frost glass) y el indicador de tab es una lente óptica circular que amplifica el fondo real mediante shader GPU con barrel distortion y aberración cromática."
                    }
                }

                // ── Card principal — escena de demostración ────────────────────
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: implicitHeight
                    implicitHeight: demoContent.implicitHeight + Style.resize(52)
                    color:        Style.cardColor
                    radius:       Style.resize(18)
                    border.color: "#343842"
                    border.width: 1

                    ColumnLayout {
                        id: demoContent
                        anchors.fill: parent
                        anchors.margins: Style.resize(26)
                        spacing: Style.resize(22)

                        // Etiqueta superior
                        RowLayout {
                            Layout.fillWidth: true

                            Text {
                                text:           "Frost Glass + Lens"
                                font.pixelSize: Style.resize(22)
                                font.bold:      true
                                color:          Style.fontPrimaryColor
                            }

                            Item { Layout.fillWidth: true }

                            Rectangle {
                                radius: height / 2
                                color:        Qt.rgba(0, 0.82, 0.66, 0.12)
                                border.color: Qt.rgba(0, 0.82, 0.66, 0.24)
                                border.width: 1
                                Layout.preferredHeight: Style.resize(28)
                                Layout.preferredWidth: badgeText.implicitWidth + Style.resize(20)

                                Text {
                                    id: badgeText
                                    anchors.centerIn: parent
                                    text:           "ShaderEffect + MultiEffect"
                                    font.pixelSize: Style.resize(12)
                                    color:          Style.mainColor
                                }
                            }
                        }

                        // ── Escena de demostración ────────────────────────────────
                        // demoArea contiene demoBackground (fuente del blur y la lente)
                        // y la LensTabStrip como hermano directo.
                        Item {
                            id: demoArea
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(220)

                            // Fondo real capturado por LensTabStrip para frost glass y lente
                            Item {
                                id: demoBackground
                                anchors.fill: parent

                                // Base (oscura o blanca según lightMode)
                                Rectangle {
                                    anchors.fill: parent
                                    color: root.lightMode ? "#ffffff" : "#0a0d1a"
                                }

                                // Blob magenta — arriba a la izquierda
                                Rectangle {
                                    x: -Style.resize(40)
                                    y: -Style.resize(30)
                                    width:  Style.resize(240)
                                    height: Style.resize(240)
                                    radius: width / 2
                                    color:  Qt.rgba(0.85, 0.10, 0.50, 0.80)
                                    layer.enabled: root.opacity > 0.0
                                    layer.effect: MultiEffect {
                                        blurEnabled: true; blur: 1.0; blurMax: 60
                                    }
                                }

                                // Blob violeta — arriba a la derecha
                                Rectangle {
                                    x: demoArea.width - Style.resize(160)
                                    y: -Style.resize(20)
                                    width:  Style.resize(220)
                                    height: Style.resize(200)
                                    radius: width / 2
                                    color:  Qt.rgba(0.35, 0.08, 0.90, 0.70)
                                    layer.enabled: root.opacity > 0.0
                                    layer.effect: MultiEffect {
                                        blurEnabled: true; blur: 1.0; blurMax: 60
                                    }
                                }

                                // Blob teal — parte baja, cruza el tab strip
                                Rectangle {
                                    x: demoArea.width / 2 - Style.resize(100)
                                    y: demoArea.height - Style.resize(110)
                                    width:  Style.resize(220)
                                    height: Style.resize(160)
                                    radius: width / 2
                                    color:  Qt.rgba(0.0, 0.80, 0.65, 0.55)
                                    layer.enabled: root.opacity > 0.0
                                    layer.effect: MultiEffect {
                                        blurEnabled: true; blur: 1.0; blurMax: 50
                                    }
                                }

                                // Banda naranja horizontal — cruza el centro del track
                                Rectangle {
                                    x: Style.resize(20)
                                    y: demoArea.height - Style.resize(84)
                                    width:  demoArea.width - Style.resize(40)
                                    height: Style.resize(18)
                                    radius: height / 2
                                    color:  Qt.rgba(1.0, 0.50, 0.05, 0.60)
                                    layer.enabled: root.opacity > 0.0
                                    layer.effect: MultiEffect {
                                        blurEnabled: true; blur: 1.0; blurMax: 16
                                    }
                                }
                            }

                            // ── Tab strip como bottom nav bar ─────────────────────
                            LensTabStrip {
                                id: mainTabStrip
                                anchors.bottom:       parent.bottom
                                anchors.left:         parent.left
                                anchors.right:        parent.right
                                anchors.bottomMargin: Style.resize(16)
                                anchors.leftMargin:   Style.resize(16)
                                anchors.rightMargin:  Style.resize(16)

                                tabs:           root.tabItems
                                currentIndex:   root.currentTabIndex
                                backgroundItem: demoBackground

                                travelDuration: root.travelDuration
                                magnification:  root.magnification
                                aberration:     root.aberration
                                rimBrightness:  root.rimBrightness
                                lensRadius:     root.lensRadius
                                blurRadius:     root.blurRadius
                                tintOpacity:          root.tintOpacity
                                borderOpacity:        root.borderOpacity
                                frostEnabled:         root.frostEnabled
                                tabTextColor:         root.lightMode ? Qt.rgba(0,0,0,0.75) : Qt.rgba(1,1,1,0.70)
                                tintStrength:         root.tintStrength
                                noiseStrength:        root.noiseStrength
                                vignetteStrength:     root.vignetteStrength
                                causticStrength:      root.causticStrength
                                bottomShadowStrength: root.bottomShadowStrength

                                onTabTriggered: function(index) {
                                    root.currentTabIndex = index
                                }
                            }
                        }

                        // ── Área de contenido del tab seleccionado ────────────────
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(160)
                            radius: Style.resize(14)
                            color:  Style.surfaceColor
                            border.color: "#323641"
                            border.width: 1

                            // Decoración de fondo
                            Rectangle {
                                width:  parent.width * 0.45
                                height: parent.height * 0.85
                                radius: width / 2
                                anchors.right:           parent.right
                                anchors.rightMargin:     Style.resize(-50)
                                anchors.verticalCenter:  parent.verticalCenter
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: Qt.rgba(0.0, 0.80, 0.65, 0.14) }
                                    GradientStop { position: 1.0; color: "transparent" }
                                }
                            }

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: Style.resize(22)
                                spacing: Style.resize(10)

                                Text {
                                    text:              root.currentTab.eyebrow
                                    font.pixelSize:    Style.resize(12)
                                    font.bold:         true
                                    font.letterSpacing: 1.2
                                    color:             Style.mainColor
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text:           root.currentTab.title
                                    wrapMode:       Text.WordWrap
                                    font.pixelSize: Style.resize(20)
                                    font.family:    Style.fontFamilyBold
                                    font.bold:      true
                                    color:          Style.fontPrimaryColor
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text:           root.currentTab.body
                                    wrapMode:       Text.WordWrap
                                    font.pixelSize: Style.resize(13)
                                    color:          Style.fontSecondaryColor
                                    lineHeight:     1.45
                                }

                                Item { Layout.fillHeight: true }
                            }
                        }
                    }
                }

                // ── Panel de tuning ────────────────────────────────────────────
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: implicitHeight
                    implicitHeight: tuningContent.implicitHeight + Style.resize(52)
                    color:        Style.cardColor
                    radius:       Style.resize(18)
                    border.color: "#343842"
                    border.width: 1

                    ColumnLayout {
                        id: tuningContent
                        anchors.fill: parent
                        anchors.margins: Style.resize(26)
                        spacing: Style.resize(18)

                        Text {
                            text:           "Tuning Panel"
                            font.pixelSize: Style.resize(22)
                            font.bold:      true
                            color:          Style.fontPrimaryColor
                        }

                        GridLayout {
                            Layout.fillWidth: true
                            columns: 2
                            columnSpacing: Style.resize(24)
                            rowSpacing:    Style.resize(18)

                            // Blur radius
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(6)
                                RowLayout {
                                    Text { text: "Blur radius";  font.pixelSize: Style.resize(14); color: Style.fontPrimaryColor }
                                    Item { Layout.fillWidth: true }
                                    Text { text: Math.round(root.blurRadius); font.pixelSize: Style.resize(13); color: Style.mainColor }
                                }
                                Slider {
                                    Layout.fillWidth: true
                                    from: 0; to: 60; stepSize: 1
                                    value: root.blurRadius
                                    onValueChanged: root.blurRadius = value
                                }
                            }

                            // Tint opacity
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(6)
                                RowLayout {
                                    Text { text: "Tint opacity"; font.pixelSize: Style.resize(14); color: Style.fontPrimaryColor }
                                    Item { Layout.fillWidth: true }
                                    Text { text: root.tintOpacity.toFixed(2); font.pixelSize: Style.resize(13); color: Style.mainColor }
                                }
                                Slider {
                                    Layout.fillWidth: true
                                    from: 0.0; to: 0.50; stepSize: 0.01
                                    value: root.tintOpacity
                                    onValueChanged: root.tintOpacity = value
                                }
                            }

                            // Edge distortion
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(6)
                                RowLayout {
                                    Text { text: "Distorsión borde"; font.pixelSize: Style.resize(14); color: Style.fontPrimaryColor }
                                    Item { Layout.fillWidth: true }
                                    Text { text: root.magnification.toFixed(2); font.pixelSize: Style.resize(13); color: Style.mainColor }
                                }
                                Slider {
                                    Layout.fillWidth: true
                                    from: 0.0; to: 2.0; stepSize: 0.05
                                    value: root.magnification
                                    onValueChanged: root.magnification = value
                                }
                            }

                            // Travel duration
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(6)
                                RowLayout {
                                    Text { text: "Travel"; font.pixelSize: Style.resize(14); color: Style.fontPrimaryColor }
                                    Item { Layout.fillWidth: true }
                                    Text { text: root.travelDuration + " ms"; font.pixelSize: Style.resize(13); color: Style.mainColor }
                                }
                                Slider {
                                    Layout.fillWidth: true
                                    from: 100; to: 600; stepSize: 10
                                    value: root.travelDuration
                                    onValueChanged: root.travelDuration = Math.round(value)
                                }
                            }

                            // Lens radius
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(6)
                                RowLayout {
                                    Text { text: "Radio de lente"; font.pixelSize: Style.resize(14); color: Style.fontPrimaryColor }
                                    Item { Layout.fillWidth: true }
                                    Text { text: root.lensRadius.toFixed(2); font.pixelSize: Style.resize(13); color: Style.mainColor }
                                }
                                Slider {
                                    Layout.fillWidth: true
                                    from: 0.20; to: 0.50; stepSize: 0.01
                                    value: root.lensRadius
                                    onValueChanged: root.lensRadius = value
                                }
                            }

                            // Rim brightness (sheen suave)
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(6)
                                RowLayout {
                                    Text { text: "Sheen"; font.pixelSize: Style.resize(14); color: Style.fontPrimaryColor }
                                    Item { Layout.fillWidth: true }
                                    Text { text: root.rimBrightness.toFixed(2); font.pixelSize: Style.resize(13); color: Style.mainColor }
                                }
                                Slider {
                                    Layout.fillWidth: true
                                    from: 0.0; to: 1.0; stepSize: 0.05
                                    value: root.rimBrightness
                                    onValueChanged: root.rimBrightness = value
                                }
                            }

                            // Frost glass toggle
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(6)
                                RowLayout {
                                    Text { text: "Frost glass"; font.pixelSize: Style.resize(14); color: Style.fontPrimaryColor }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: root.frostEnabled
                                        onToggled: root.frostEnabled = checked
                                    }
                                }
                            }

                            // Light mode toggle
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(6)
                                RowLayout {
                                    Text { text: "Fondo blanco"; font.pixelSize: Style.resize(14); color: Style.fontPrimaryColor }
                                    Item { Layout.fillWidth: true }
                                    Switch {
                                        checked: root.lightMode
                                        onToggled: root.lightMode = checked
                                    }
                                }
                            }

                            // Tinte de cristal
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(6)
                                RowLayout {
                                    Text { text: "Tinte cristal"; font.pixelSize: Style.resize(14); color: Style.fontPrimaryColor }
                                    Item { Layout.fillWidth: true }
                                    Text { text: root.tintStrength.toFixed(2); font.pixelSize: Style.resize(13); color: Style.mainColor }
                                }
                                Slider {
                                    Layout.fillWidth: true
                                    from: 0.0; to: 0.30; stepSize: 0.01
                                    value: root.tintStrength
                                    onValueChanged: root.tintStrength = value
                                }
                            }

                            // Micro-textura
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(6)
                                RowLayout {
                                    Text { text: "Micro-textura"; font.pixelSize: Style.resize(14); color: Style.fontPrimaryColor }
                                    Item { Layout.fillWidth: true }
                                    Text { text: root.noiseStrength.toFixed(2); font.pixelSize: Style.resize(13); color: Style.mainColor }
                                }
                                Slider {
                                    Layout.fillWidth: true
                                    from: 0.0; to: 0.40; stepSize: 0.01
                                    value: root.noiseStrength
                                    onValueChanged: root.noiseStrength = value
                                }
                            }

                            // Viñeta lateral
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(6)
                                RowLayout {
                                    Text { text: "Viñeta"; font.pixelSize: Style.resize(14); color: Style.fontPrimaryColor }
                                    Item { Layout.fillWidth: true }
                                    Text { text: root.vignetteStrength.toFixed(2); font.pixelSize: Style.resize(13); color: Style.mainColor }
                                }
                                Slider {
                                    Layout.fillWidth: true
                                    from: 0.0; to: 0.50; stepSize: 0.01
                                    value: root.vignetteStrength
                                    onValueChanged: root.vignetteStrength = value
                                }
                            }

                            // Caustics caps
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(6)
                                RowLayout {
                                    Text { text: "Caustics"; font.pixelSize: Style.resize(14); color: Style.fontPrimaryColor }
                                    Item { Layout.fillWidth: true }
                                    Text { text: root.causticStrength.toFixed(2); font.pixelSize: Style.resize(13); color: Style.mainColor }
                                }
                                Slider {
                                    Layout.fillWidth: true
                                    from: 0.0; to: 1.0; stepSize: 0.05
                                    value: root.causticStrength
                                    onValueChanged: root.causticStrength = value
                                }
                            }

                            // Sombra inferior / grosor
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(6)
                                RowLayout {
                                    Text { text: "Grosor / sombra"; font.pixelSize: Style.resize(14); color: Style.fontPrimaryColor }
                                    Item { Layout.fillWidth: true }
                                    Text { text: root.bottomShadowStrength.toFixed(2); font.pixelSize: Style.resize(13); color: Style.mainColor }
                                }
                                Slider {
                                    Layout.fillWidth: true
                                    from: 0.0; to: 0.60; stepSize: 0.01
                                    value: root.bottomShadowStrength
                                    onValueChanged: root.bottomShadowStrength = value
                                }
                            }
                        }

                        // ── Chips de estado ────────────────────────────────────
                        RowLayout {
                            spacing: Style.resize(10)

                            Repeater {
                                model: [
                                    "blur " + Math.round(root.blurRadius) + "px",
                                    "mag "  + root.magnification.toFixed(1) + "x",
                                    "travel " + root.travelDuration + "ms",
                                    "r=" + root.lensRadius.toFixed(2)
                                ]

                                Rectangle {
                                    required property string modelData
                                    radius: height / 2
                                    color:        Qt.rgba(1, 1, 1, 0.05)
                                    border.color: Qt.rgba(1, 1, 1, 0.08)
                                    border.width: 1
                                    Layout.preferredHeight: Style.resize(26)
                                    Layout.preferredWidth: chipTxt.implicitWidth + Style.resize(16)

                                    Text {
                                        id: chipTxt
                                        anchors.centerIn: parent
                                        text:           parent.modelData
                                        font.pixelSize: Style.resize(11)
                                        color:          Style.fontSecondaryColor
                                    }
                                }
                            }
                        }
                    }
                }

                Item { Layout.preferredHeight: Style.resize(20) }
            }
        }
    }
}
