// =============================================================================
// PropertyBindCard.qml — Binding bidireccional con Q_PROPERTY de C++
// =============================================================================
// Demuestra el mecanismo Q_PROPERTY: la forma principal de compartir datos
// entre C++ y QML. Cada Q_PROPERTY tiene READ (getter), WRITE (setter) y
// NOTIFY (signal de cambio). QML puede leer, escribir y hacer binding
// reactivo con estas propiedades como si fueran propiedades QML nativas.
//
// Integracion C++ <-> QML:
//   - "import qmlcppbridge" importa el modulo que contiene PropertyBridge.
//   - PropertyBridge { id: bridge } crea una instancia del QObject C++.
//     Cada propiedad (counter, userName, temperature, active, tags, summary)
//     es una Q_PROPERTY declarada en propertybridge.h.
//
// Tipos de propiedades demostradas:
//   - int counter: lectura/escritura. Botones +/- llaman Q_INVOKABLE
//     increment()/decrement() que modifican el valor en C++ y emiten
//     counterChanged. QML actualiza el Label automaticamente.
//   - QString userName: binding bidireccional con TextField. onTextEdited
//     escribe en C++; el binding de text lee de C++.
//   - double temperature: Slider vinculado con onMoved -> setter de C++.
//   - bool active: Switch vinculado al getter/setter de C++.
//   - QStringList tags: propiedad de solo lectura (sin WRITE). Los metodos
//     Q_INVOKABLE addTag()/removeTag() modifican la lista internamente.
//   - QString summary: propiedad computada de solo lectura. En C++ se
//     calcula a partir de las demas propiedades. Se actualiza cuando
//     cualquier dependencia cambia.
//
// Aprendizaje: Q_PROPERTY es la columna vertebral del data binding en Qt.
// Sin las signals NOTIFY, QML no detectaria cambios y la UI se quedaria
// desactualizada.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qmlcppbridge
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // -- Instancia del QObject C++. Todas las propiedades y metodos
    //    de PropertyBridge estan accesibles a traves de "bridge".
    PropertyBridge { id: bridge }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Q_PROPERTY Binding"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Two-way binding between C++ properties and QML"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // -- Counter (int): los botones llaman Q_INVOKABLE increment()/
        //    decrement() en C++. El Label lee bridge.counter, que se
        //    actualiza automaticamente gracias a la signal counterChanged.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "counter:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(80)
            }

            Button {
                text: "-"
                implicitWidth: Style.resize(34)
                implicitHeight: Style.resize(30)
                onClicked: bridge.decrement()
            }

            Label {
                text: bridge.counter.toString()
                font.pixelSize: Style.resize(16)
                font.bold: true
                color: Style.mainColor
                horizontalAlignment: Text.AlignHCenter
                Layout.preferredWidth: Style.resize(40)
            }

            Button {
                text: "+"
                implicitWidth: Style.resize(34)
                implicitHeight: Style.resize(30)
                onClicked: bridge.increment()
            }
        }

        // -- userName (QString): binding bidireccional.
        //    text: bridge.userName lee de C++ (via READ getter).
        //    onTextEdited: bridge.userName = text escribe en C++ (via WRITE setter).
        //    Esto crea un ciclo reactivo: C++ -> QML -> C++ -> QML...
        //    No hay loop infinito porque el setter en C++ solo emite la signal
        //    si el valor realmente cambio (patron guard: if (m_val == val) return).
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "userName:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(80)
            }

            TextField {
                Layout.fillWidth: true
                text: bridge.userName
                font.pixelSize: Style.resize(12)
                onTextEdited: bridge.userName = text
            }
        }

        // -- temperature (double): Slider con onMoved (no onValueChanged)
        //    para evitar loops de binding circular.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "temperature:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(80)
            }

            Slider {
                Layout.fillWidth: true
                from: -10; to: 45; value: bridge.temperature
                onMoved: bridge.temperature = value
            }

            Label {
                text: bridge.temperature.toFixed(1) + " C"
                font.pixelSize: Style.resize(11)
                color: Style.mainColor
                Layout.preferredWidth: Style.resize(50)
            }
        }

        // -- active (bool): Switch vinculado a Q_PROPERTY bool.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "active:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(80)
            }

            Switch {
                checked: bridge.active
                onToggled: bridge.active = checked
            }

            Label {
                text: bridge.active ? "ON" : "OFF"
                font.pixelSize: Style.resize(12)
                color: bridge.active ? "#00D1A9" : "#FF6B6B"
            }
        }

        // -- tags (QStringList): propiedad de solo lectura (sin WRITE).
        //    QML la lee para generar badges con Repeater. Los cambios
        //    llegan via la signal tagsChanged emitida por addTag/removeTag.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "tags:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(80)
            }

            Flow {
                Layout.fillWidth: true
                spacing: Style.resize(4)

                Repeater {
                    model: bridge.tags

                    Rectangle {
                        required property string modelData
                        required property int index
                        width: tagText.implicitWidth + Style.resize(20)
                        height: Style.resize(24)
                        radius: Style.resize(12)
                        color: Style.surfaceColor

                        RowLayout {
                            anchors.centerIn: parent
                            spacing: Style.resize(4)

                            Label {
                                id: tagText
                                text: modelData
                                font.pixelSize: Style.resize(10)
                                color: Style.mainColor
                            }

                            // -- Boton "x" que llama removeTag(index):
                            //    Q_INVOKABLE en C++ que elimina el tag
                            //    por indice y emite tagsChanged.
                            Label {
                                text: "x"
                                font.pixelSize: Style.resize(10)
                                color: "#FF6B6B"
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: bridge.removeTag(index)
                                }
                            }
                        }
                    }
                }
            }
        }

        // -- Agregar tag: TextField + boton que llaman addTag() (Q_INVOKABLE).
        //    onAccepted se dispara cuando el usuario presiona Enter.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Item { Layout.preferredWidth: Style.resize(80) }

            TextField {
                id: tagInput
                Layout.fillWidth: true
                placeholderText: "New tag..."
                font.pixelSize: Style.resize(11)
                onAccepted: {
                    bridge.addTag(text)
                    text = ""
                }
            }

            Button {
                text: "Add"
                implicitHeight: Style.resize(30)
                onClicked: {
                    bridge.addTag(tagInput.text)
                    tagInput.text = ""
                }
            }
        }

        // -- summary (QString): propiedad computada de solo lectura.
        //    En C++, summary() genera un resumen a partir de counter,
        //    userName, temperature, active y tags. Cuando cualquiera
        //    de estas cambia, C++ emite summaryChanged y QML actualiza
        //    este binding automaticamente.
        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(30)
            radius: Style.resize(4)
            color: Style.surfaceColor

            Label {
                anchors.centerIn: parent
                text: "summary: " + bridge.summary
                font.pixelSize: Style.resize(11)
                color: Style.fontPrimaryColor
            }
        }
    }
}
