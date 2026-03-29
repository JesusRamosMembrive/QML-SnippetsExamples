// =============================================================================
// Main.qml — Página de ejemplo: Sprite Stacking 2.5D
// =============================================================================
// Demuestra la técnica "Sprite Stacking": ilusión de volumen 3D conseguida
// dibujando el mismo sprite 2D múltiples veces, apilado hacia arriba.
//
// CLAVE del efecto:
//   Todas las rodajas reciben EXACTAMENTE el mismo ángulo de rotación.
//   El ojo interpreta la secuencia de formas 2D como un objeto 3D rotando.
//
// FEATURE EDUCATIVA:
//   El slider "Separación" aleja las rodajas entre sí (efecto "explosión").
//   Al máximo, se ven claramente los discos 2D individuales que componen
//   cada figura. Al mínimo, la ilusión 3D es perfecta.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Item {
    id: root

    // ── Patrón estándar de visibilidad animada ─────────────────────────────
    property bool fullSize: false
    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity { NumberAnimation { duration: 200 } }

    // ── Estado de la animación ─────────────────────────────────────────────
    property real  sharedRotation: 0.0
    property bool  paused:         false
    property real  rotSpeed:       1.2     // °/frame
    property int   sharedSlices:   20
    property real  sharedSpacing:  4.0

    // ── Timer único que impulsa todos los objetos ──────────────────────────
    // El mismo ángulo llega a los 6 SpriteStack: todos giran sincronizados,
    // lo que hace que el efecto sea visualmente más llamativo.
    Timer {
        id: animTimer
        interval: 16
        repeat:   true
        running:  root.fullSize && !root.paused
        onTriggered: root.sharedRotation = (root.sharedRotation + root.rotSpeed) % 360.0
    }

    // ── Layout principal ───────────────────────────────────────────────────
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(16)
        spacing: Style.resize(10)

        // ── Encabezado ─────────────────────────────────────────────────────
        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "Sprite Stacking"
                font.pixelSize: Style.fontSizeL
                font.family:    Style.fontFamilyBold
                color:          Style.fontPrimaryColor
            }
            Label {
                text: "— volumen 3D con capas 2D apiladas"
                font.pixelSize: Style.fontSizeS
                color:          Style.inactiveColor
                Layout.alignment: Qt.AlignVCenter
            }
            Item { Layout.fillWidth: true }
        }

        // ── Panel de controles ─────────────────────────────────────────────
        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(88)
            color:  Style.cardColor
            radius: Style.resize(8)

            RowLayout {
                anchors.fill:    parent
                anchors.margins: Style.resize(12)
                spacing:         Style.resize(18)

                // Velocidad
                ColumnLayout {
                    spacing: Style.resize(2)
                    Label {
                        text: "Velocidad:  " + speedSlider.value.toFixed(1) + " °/frame"
                        font.pixelSize: Style.fontSizeS
                        color: Style.fontSecondaryColor
                    }
                    Slider {
                        id: speedSlider
                        from:     0.1;  to: 5.0;  value: 1.2;  stepSize: 0.1
                        Layout.preferredWidth: Style.resize(160)
                        onMoved: root.rotSpeed = value
                    }
                }

                // Número de rodajas
                ColumnLayout {
                    spacing: Style.resize(2)
                    Label {
                        text: "Rodajas:  " + slicesSlider.value
                        font.pixelSize: Style.fontSizeS
                        color: Style.fontSecondaryColor
                    }
                    Slider {
                        id: slicesSlider
                        from: 8;  to: 32;  value: 20;  stepSize: 1
                        Layout.preferredWidth: Style.resize(160)
                        onMoved: root.sharedSlices = Math.round(value)
                    }
                }

                // Separación / Explode
                ColumnLayout {
                    spacing: Style.resize(2)
                    Label {
                        text: "Separación:  " + explodeSlider.value.toFixed(1) + " px"
                        font.pixelSize: Style.fontSizeS
                        color: Style.fontSecondaryColor
                    }
                    Slider {
                        id: explodeSlider
                        from: 2.0;  to: 20.0;  value: 4.0;  stepSize: 0.5
                        Layout.preferredWidth: Style.resize(160)
                        onMoved: root.sharedSpacing = value
                    }
                }

                Item { Layout.fillWidth: true }

                // Botón Pause / Play
                Button {
                    text:        root.paused ? "▶  Play" : "⏸  Pause"
                    highlighted: root.paused
                    Layout.preferredWidth: Style.resize(100)
                    onClicked: root.paused = !root.paused
                }
            }
        }

        // ── Área de los 6 objetos ──────────────────────────────────────────
        // ScrollView para que no se recorte si la ventana es muy pequeña
        ScrollView {
            Layout.fillWidth:  true
            Layout.fillHeight: true
            clip: true
            contentWidth: -1   // horizontal: adaptar al contenido

            // Fondo oscuro para que resalten los objetos
            Rectangle {
                width:  Math.max(stackGrid.implicitWidth  + Style.resize(32), scrollView_anchor.width)
                height: Math.max(stackGrid.implicitHeight + Style.resize(32), scrollView_anchor.height)
                color: Style.bgColorDark
                radius: Style.resize(8)

                // Ancla auxiliar para acceder al tamaño del ScrollView
                Item { id: scrollView_anchor; anchors.fill: parent }

                // Grid 3 columnas × 2 filas
                GridLayout {
                    id: stackGrid
                    anchors.centerIn: parent
                    columns:      3
                    columnSpacing: Style.resize(40)
                    rowSpacing:    Style.resize(24)

                    // ── Sphere ────────────────────────────────────────────
                    ColumnLayout {
                        spacing: Style.resize(6)
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        SpriteStack {
                            Layout.alignment:  Qt.AlignHCenter
                            stackRotation:  root.sharedRotation
                            sliceCount:     root.sharedSlices
                            sliceSpacing:   root.sharedSpacing
                            shapeType:      "sphere"
                            primaryColor:   Style.mainColor
                        }
                        Label {
                            text:           "Esfera"
                            font.pixelSize: Style.fontSizeS
                            color:          Style.fontSecondaryColor
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }

                    // ── Cube ──────────────────────────────────────────────
                    ColumnLayout {
                        spacing: Style.resize(6)
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        SpriteStack {
                            Layout.alignment:  Qt.AlignHCenter
                            stackRotation:  root.sharedRotation
                            sliceCount:     root.sharedSlices
                            sliceSpacing:   root.sharedSpacing
                            shapeType:      "cube"
                            primaryColor:   "#4488FF"
                        }
                        Label {
                            text:           "Cubo"
                            font.pixelSize: Style.fontSizeS
                            color:          Style.fontSecondaryColor
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }

                    // ── Cylinder ──────────────────────────────────────────
                    ColumnLayout {
                        spacing: Style.resize(6)
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        SpriteStack {
                            Layout.alignment:  Qt.AlignHCenter
                            stackRotation:  root.sharedRotation
                            sliceCount:     root.sharedSlices
                            sliceSpacing:   root.sharedSpacing
                            shapeType:      "cylinder"
                            primaryColor:   "#AA44FF"
                        }
                        Label {
                            text:           "Cilindro"
                            font.pixelSize: Style.fontSizeS
                            color:          Style.fontSecondaryColor
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }

                    // ── Cone ──────────────────────────────────────────────
                    ColumnLayout {
                        spacing: Style.resize(6)
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        SpriteStack {
                            Layout.alignment:  Qt.AlignHCenter
                            stackRotation:  root.sharedRotation
                            sliceCount:     root.sharedSlices
                            sliceSpacing:   root.sharedSpacing
                            shapeType:      "cone"
                            primaryColor:   Style.theme === "green" ? "#FEA601" : "#E74C3C"
                        }
                        Label {
                            text:           "Cono"
                            font.pixelSize: Style.fontSizeS
                            color:          Style.fontSecondaryColor
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }

                    // ── Diamond ───────────────────────────────────────────
                    ColumnLayout {
                        spacing: Style.resize(6)
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        SpriteStack {
                            Layout.alignment:  Qt.AlignHCenter
                            stackRotation:  root.sharedRotation
                            sliceCount:     root.sharedSlices
                            sliceSpacing:   root.sharedSpacing
                            shapeType:      "diamond"
                            primaryColor:   "#FF4488"
                        }
                        Label {
                            text:           "Diamante"
                            font.pixelSize: Style.fontSizeS
                            color:          Style.fontSecondaryColor
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }

                    // ── Gem ───────────────────────────────────────────────
                    ColumnLayout {
                        spacing: Style.resize(6)
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        SpriteStack {
                            Layout.alignment:  Qt.AlignHCenter
                            stackRotation:  root.sharedRotation
                            sliceCount:     root.sharedSlices
                            sliceSpacing:   root.sharedSpacing
                            shapeType:      "gem"
                            primaryColor:   "#FFD700"
                        }
                        Label {
                            text:           "Gema"
                            font.pixelSize: Style.fontSizeS
                            color:          Style.fontSecondaryColor
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
        }

        // ── Sección de explicación matemática (colapsable) ─────────────────
        Rectangle {
            id: mathPanel
            Layout.fillWidth: true
            height: mathVisible ? mathContent.implicitHeight + Style.resize(24) : Style.resize(36)
            color:  Style.cardColor
            radius: Style.resize(8)
            clip:   true

            property bool mathVisible: false
            Behavior on height { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }

            RowLayout {
                x: Style.resize(12); y: Style.resize(10)
                width: parent.width - Style.resize(24)
                spacing: Style.resize(8)
                Label {
                    text:            mathPanel.mathVisible ? "▾" : "▸"
                    color:           Style.mainColor
                    font.pixelSize:  Style.fontSizeS
                }
                Label {
                    text:            "Matemáticas del efecto"
                    color:           Style.mainColor
                    font.pixelSize:  Style.fontSizeS
                    font.family:     Style.fontFamilyBold
                }
                Item { Layout.fillWidth: true }
            }
            MouseArea {
                anchors.fill: parent
                onClicked:    mathPanel.mathVisible = !mathPanel.mathVisible
                cursorShape:  Qt.PointingHandCursor
            }

            Column {
                id: mathContent
                x:       Style.resize(12)
                y:       Style.resize(36)
                width:   parent.width - Style.resize(24)
                spacing: Style.resize(4)
                opacity: mathPanel.mathVisible ? 1.0 : 0.0
                Behavior on opacity { NumberAnimation { duration: 120 } }

                Label {
                    width: parent.width; wrapMode: Text.Wrap
                    font.pixelSize: Style.fontSizeS; color: Style.fontSecondaryColor
                    text: "Cada objeto se compone de <b>N rodajas 2D</b> apiladas verticalmente con separación <i>sliceSpacing</i> px. Todas comparten exactamente el mismo <b>ángulo de rotación</b> — ese es el único cambio entre rodajas."
                }
                Label {
                    width: parent.width; wrapMode: Text.Wrap
                    font.pixelSize: Style.fontSizeS; color: Style.fontSecondaryColor
                    font.family: Style.fontFamilyBold
                    text: "Posición:   sliceY = baseCenterY − i × sliceSpacing"
                }
                Label {
                    width: parent.width; wrapMode: Text.Wrap
                    font.pixelSize: Style.fontSizeS; color: Style.fontSecondaryColor
                    font.family: Style.fontFamilyBold
                    text: "Escala Y:   ctx.scale(1.0,  0.55)  →  simula vista desde ~35° de elevación"
                }
                Label {
                    width: parent.width; wrapMode: Text.Wrap
                    font.pixelSize: Style.fontSizeS; color: Style.fontSecondaryColor
                    text: "El sombreado por altura (oscuro↓ → color↔ → claro↑) imita la iluminación sin ningún cálculo de luz real."
                }
                Label {
                    width: parent.width; wrapMode: Text.Wrap
                    font.pixelSize: Style.fontSizeS; color: Style.fontSecondaryColor
                    text: "<b>Prueba el slider 'Separación' al máximo</b>: verás los discos 2D individuales. Vuelve al mínimo y la ilusión 3D se restaura al instante."
                }
                Label {
                    width: parent.width; wrapMode: Text.Wrap
                    font.pixelSize: Style.fontSizeS; color: Style.fontSecondaryColor
                    text: "Radios por forma: Esfera r=√(1−(2t−1)²)·R · Cono r=(1−t)·R · Diamante r=(1−|2t−1|)·R · Cubo/Cilindro r=R (constante)"
                }
                Item { height: Style.resize(8) }
            }
        }
    }
}
