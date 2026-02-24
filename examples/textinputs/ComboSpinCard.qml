// =============================================================================
// ComboSpinCard.qml — ComboBox y SpinBox con preview visual reactivo
// =============================================================================
// Demuestra ComboBox (seleccion de lista desplegable) y SpinBox (entrada
// numerica acotada con botones +/-), ambos controles nativos de Qt Quick
// Controls 2. Lo mas interesante de este ejemplo es la preview reactiva:
// un rectangulo que cambia de color, tamano y radio en tiempo real segun
// los valores seleccionados por el usuario.
//
// Patrones educativos:
//   - `Behavior on <propiedad>`: anima automaticamente cualquier cambio de
//     esa propiedad. Aqui se usan 4 Behaviors distintos (width, height,
//     radius, color) para que la transicion visual sea suave.
//   - Binding con `switch/case` en la propiedad `color`: mapea el indice
//     del ComboBox a un color hexadecimal. Es una alternativa a usar un
//     modelo mas complejo con roles.
//   - `toFixed(0)` para formatear numeros sin decimales en el Label interno.
// =============================================================================
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "ComboBox & SpinBox"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // -----------------------------------------------------------------
        // ComboBox: el modelo mas simple es un array de strings. El valor
        // seleccionado se accede con currentText (texto) o currentIndex
        // (indice numerico, usado abajo para mapear al color).
        // -----------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Style.resize(5)

            Label {
                text: "Color (ComboBox):"
                font.pixelSize: Style.resize(13)
                color: Style.fontSecondaryColor
            }

            ComboBox {
                id: colorCombo
                Layout.fillWidth: true
                model: ["Red", "Green", "Blue", "Orange", "Purple"]
            }
        }

        // -----------------------------------------------------------------
        // Dos SpinBox en fila: controlan radio y tamano del rectangulo
        // de preview. `from`/`to` definen el rango, `stepSize` el
        // incremento por click. El valor actual se lee con `.value`.
        // -----------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(15)

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Style.resize(5)

                Label {
                    text: "Radius (SpinBox):"
                    font.pixelSize: Style.resize(13)
                    color: Style.fontSecondaryColor
                }

                SpinBox {
                    id: radiusSpin
                    from: 0
                    to: 50
                    stepSize: 5
                    value: 10
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Style.resize(5)

                Label {
                    text: "Size (SpinBox):"
                    font.pixelSize: Style.resize(13)
                    color: Style.fontSecondaryColor
                }

                SpinBox {
                    id: sizeSpin
                    from: 50
                    to: 200
                    stepSize: 10
                    value: 100
                }
            }
        }

        // -----------------------------------------------------------------
        // Preview reactiva: el rectangulo se actualiza automaticamente
        // gracias a los bindings directos a las propiedades de los SpinBox
        // y ComboBox. Los Behavior on <prop> generan animaciones suaves
        // sin necesidad de controlar estados ni transiciones manualmente.
        // Es la forma mas elegante de animar cambios en QML.
        // -----------------------------------------------------------------
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: Style.resize(100)

            Rectangle {
                id: previewRect
                anchors.centerIn: parent
                width: sizeSpin.value
                height: sizeSpin.value
                radius: radiusSpin.value
                color: {
                    switch (colorCombo.currentIndex) {
                        case 0: return "#E74C3C";
                        case 1: return "#2ECC71";
                        case 2: return "#3498DB";
                        case 3: return "#E67E22";
                        case 4: return "#9B59B6";
                        default: return "#E74C3C";
                    }
                }

                Behavior on width { NumberAnimation { duration: 200 } }
                Behavior on height { NumberAnimation { duration: 200 } }
                Behavior on radius { NumberAnimation { duration: 200 } }
                Behavior on color { ColorAnimation { duration: 200 } }

                Label {
                    anchors.centerIn: parent
                    text: previewRect.width.toFixed(0) + "x" + previewRect.height.toFixed(0)
                          + " r:" + previewRect.radius.toFixed(0)
                    color: "white"
                    font.pixelSize: Style.resize(11)
                    font.bold: true
                }
            }
        }

        Label {
            text: "ComboBox provides dropdown selection, SpinBox provides bounded numeric input"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
