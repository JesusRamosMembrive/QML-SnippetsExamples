// =============================================================================
// BorderImageCard.qml — Ejemplo de BorderImage (9-patch) en QML
// =============================================================================
// BorderImage divide una imagen en 9 regiones: 4 esquinas que no se escalan,
// 4 bordes que se estiran en una sola direccion, y un centro que se estira
// en ambas. Es el mismo concepto que "9-patch" en Android.
//
// Este ejemplo muestra la misma imagen 9-patch en tres tamanos diferentes
// (Original, Wide, Tall) para que el usuario vea como las esquinas se
// mantienen intactas mientras los bordes y el centro se adaptan.
// Un Slider permite ajustar el grosor del borde en tiempo real.
//
// Caso de uso real: marcos de botones, burbujas de chat, paneles que
// necesitan esquinas redondeadas que no se deformen al redimensionar.
// =============================================================================
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // Grosor del borde en pixeles. Controla cuanto de la imagen se
    // considera "esquina" (no escalable) vs "centro" (escalable).
    property int borderSize: 20
    readonly property int sourceImageSize: 90
    readonly property int minBorderSize: 2
    readonly property int maxBorderSize: 42
    readonly property int centerPatchSize: Math.max(0, sourceImageSize - borderSize * 2)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "BorderImage (9-patch)"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Move the cut lines: corners stay fixed while only the center patch stretches"
            font.pixelSize: Style.resize(14)
            color: Style.fontSecondaryColor
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Style.resize(18)

            Rectangle {
                Layout.preferredWidth: Style.resize(190)
                Layout.fillHeight: true
                radius: Style.resize(8)
                color: Style.surfaceColor

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(12)
                    spacing: Style.resize(10)

                    Label {
                        text: "Slice Guide"
                        font.pixelSize: Style.resize(13)
                        font.bold: true
                        color: Style.mainColor
                    }

                    Item {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: Style.resize(150)
                        Layout.preferredHeight: Style.resize(150)

                        Rectangle {
                            anchors.fill: parent
                            radius: Style.resize(6)
                            color: Style.cardColor
                            border.width: 1
                            border.color: "#3A3D45"
                        }

                        Image {
                            id: sourcePreview
                            anchors.fill: parent
                            anchors.margins: Style.resize(8)
                            source: "qrc:/assets/images/ninepatch.png"
                            fillMode: Image.PreserveAspectFit
                            smooth: false
                        }

                        Rectangle {
                            width: 2
                            color: Style.mainColor
                            anchors.top: sourcePreview.top
                            anchors.bottom: sourcePreview.bottom
                            x: sourcePreview.x + sourcePreview.width * root.borderSize / root.sourceImageSize
                        }
                        Rectangle {
                            width: 2
                            color: Style.mainColor
                            anchors.top: sourcePreview.top
                            anchors.bottom: sourcePreview.bottom
                            x: sourcePreview.x + sourcePreview.width * (root.sourceImageSize - root.borderSize) / root.sourceImageSize
                        }
                        Rectangle {
                            height: 2
                            color: Style.mainColor
                            anchors.left: sourcePreview.left
                            anchors.right: sourcePreview.right
                            y: sourcePreview.y + sourcePreview.height * root.borderSize / root.sourceImageSize
                        }
                        Rectangle {
                            height: 2
                            color: Style.mainColor
                            anchors.left: sourcePreview.left
                            anchors.right: sourcePreview.right
                            y: sourcePreview.y + sourcePreview.height * (root.sourceImageSize - root.borderSize) / root.sourceImageSize
                        }
                    }

                    Label {
                        Layout.fillWidth: true
                        text: "Border: " + root.borderSize + " px"
                        font.pixelSize: Style.resize(12)
                        color: Style.fontPrimaryColor
                    }

                    Label {
                        Layout.fillWidth: true
                        text: "Stretchable center: " + root.centerPatchSize + " x " + root.centerPatchSize + " px"
                        font.pixelSize: Style.resize(11)
                        color: Style.fontSecondaryColor
                        wrapMode: Text.WordWrap
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: Style.resize(8)
                color: Style.surfaceColor

                GridLayout {
                    anchors.fill: parent
                    anchors.margins: Style.resize(12)
                    columns: 2
                    columnSpacing: Style.resize(18)
                    rowSpacing: Style.resize(14)

                    Repeater {
                        model: [
                            { w: 90,  h: 90,  lbl: "Original" },
                            { w: 240, h: 90,  lbl: "Ultra Wide" },
                            { w: 90,  h: 220, lbl: "Ultra Tall" },
                            { w: 240, h: 180, lbl: "Large Panel" }
                        ]

                        ColumnLayout {
                            id: patchVariant
                            required property var modelData
                            Layout.fillWidth: true
                            spacing: Style.resize(6)

                            BorderImage {
                                source: "qrc:/assets/images/ninepatch.png"
                                width: Style.resize(patchVariant.modelData.w)
                                height: Style.resize(patchVariant.modelData.h)
                                border.left: root.borderSize
                                border.right: root.borderSize
                                border.top: root.borderSize
                                border.bottom: root.borderSize
                                horizontalTileMode: BorderImage.Stretch
                                verticalTileMode: BorderImage.Stretch
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Label {
                                text: patchVariant.modelData.lbl
                                font.pixelSize: Style.resize(11)
                                color: Style.fontSecondaryColor
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                }
            }
        }

        // Slider para experimentar: valores muy bajos deforman las esquinas,
        // valores muy altos hacen que casi toda la imagen sea "esquina".
        RowLayout {
            Layout.fillWidth: true
            Label {
                text: "Border: " + root.borderSize + "px"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(80)
            }
            Slider {
                Layout.fillWidth: true
                from: root.minBorderSize
                to: root.maxBorderSize
                value: root.borderSize
                stepSize: 1
                onValueChanged: root.borderSize = Math.round(value)
            }
        }
    }
}
