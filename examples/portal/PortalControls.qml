// =============================================================================
// PortalControls.qml — Panel de controles del portal
// =============================================================================
// Expone la propiedad de salida que Main.qml enlaza a PortalCanvas:
//   glowValue  — radio del halo Glow (0–60)
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    id: root

    property int glowValue: glowSlider.value

    color:  Style.cardColor
    radius: Style.resize(8)
    implicitHeight: controlsLayout.implicitHeight + Style.resize(32)

    ColumnLayout {
        id: controlsLayout
        anchors {
            left:   parent.left
            right:  parent.right
            top:    parent.top
            margins: Style.resize(16)
        }
        spacing: Style.resize(12)

        Label {
            text: "Intensidad del halo"
            font.pixelSize: Style.resize(13)
            color: Style.fontSecondaryColor
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(12)

            Slider {
                id: glowSlider
                Layout.fillWidth: true
                from:     0
                to:       60
                value:    30
                stepSize: 1
            }

            Label {
                text: glowSlider.value.toFixed(0) + " px"
                font.pixelSize: Style.resize(12)
                color: Style.mainColor
                Layout.minimumWidth: Style.resize(70)
            }
        }
    }
}
