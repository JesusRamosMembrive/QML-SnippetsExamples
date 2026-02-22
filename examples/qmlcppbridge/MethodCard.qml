// =============================================================================
// MethodCard.qml — Llamadas a metodos C++ con Q_INVOKABLE y Q_ENUM
// =============================================================================
// Demuestra como QML puede llamar funciones definidas en C++ y usar enums
// de C++ para pasar parametros tipados. Cada funcion retorna un valor que
// QML puede usar directamente gracias a la conversion automatica de tipos.
//
// Integracion C++ <-> QML:
//   - MethodBridge { id: methods } crea una instancia del QObject C++.
//   - Q_INVOKABLE: marca un metodo C++ como invocable desde QML/JavaScript.
//     Sin esta macro, QML no puede llamar al metodo (seria invisible).
//   - Q_ENUM(TextTransform): registra un enum C++ con el sistema de
//     meta-objetos de Qt. QML puede usar los valores como enteros (0, 1, 2, 3)
//     o como MethodBridge.Uppercase, MethodBridge.Lowercase, etc.
//
// Funciones demostradas:
//   - transformText(text, mode): recibe un string y un enum, retorna
//     el texto transformado. Qt convierte automaticamente entre tipos:
//     QString <-> string, TextTransform <-> int.
//   - fibonacci(n): calculo puro en C++. Demuestra que operaciones
//     computacionales pesadas deben vivir en C++, no en JavaScript QML.
//   - validateEmail(text): retorna bool. QML usa el resultado directamente
//     en bindings condicionales (color, texto) sin variables intermedias.
//   - analyzeText(text): retorna QVariantMap, que QML recibe como un
//     objeto JavaScript {}. Permite retornar multiples valores con claves.
//
// Aprendizaje: Q_INVOKABLE es ideal para logica de negocio que necesita
// la velocidad de C++ o acceso a APIs de C++ que QML no tiene.
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

    property string resultText: ""

    // -- Instancia del QObject C++ con los metodos Q_INVOKABLE.
    MethodBridge { id: methods }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Q_INVOKABLE + Q_ENUM"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Call C++ methods from QML, use C++ enums"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // -- Seccion 1: Transformacion de texto con Q_ENUM.
        //    ComboBox.currentIndex corresponde directamente al valor
        //    del enum C++ TextTransform (0=Uppercase, 1=Lowercase, etc.).
        //    QML pasa el entero y C++ lo interpreta como el enum.
        Label {
            text: "Text Transform (Q_ENUM)"
            font.pixelSize: Style.resize(13)
            font.bold: true
            color: Style.fontPrimaryColor
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            TextField {
                id: transformInput
                Layout.fillWidth: true
                text: "hello world from qt"
                font.pixelSize: Style.resize(11)
            }

            ComboBox {
                id: transformCombo
                model: ["Uppercase", "Lowercase", "TitleCase", "Reverse"]
                implicitWidth: Style.resize(110)

                // -- Llamada a Q_INVOKABLE: methods.transformText() llama
                //    al metodo C++ y retorna un QString que QML recibe
                //    como string. La conversion es automatica.
                onActivated: {
                    root.resultText = methods.transformText(
                        transformInput.text, currentIndex)
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(28)
            radius: Style.resize(4)
            color: Style.surfaceColor

            Label {
                anchors.centerIn: parent
                text: root.resultText || "Select a transform"
                font.pixelSize: Style.resize(11)
                color: Style.mainColor
            }
        }

        // -- Seccion 2: Fibonacci — demuestra calculo numerico en C++.
        //    El binding methods.fibonacci(fibSlider.value) se re-evalua
        //    cada vez que el Slider cambia. Es un binding declarativo
        //    que llama a C++ de forma reactiva.
        Label {
            text: "Fibonacci (Q_INVOKABLE)"
            font.pixelSize: Style.resize(13)
            font.bold: true
            color: Style.fontPrimaryColor
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Label {
                text: "n ="
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }

            Slider {
                id: fibSlider
                Layout.fillWidth: true
                from: 0; to: 30; value: 10; stepSize: 1
            }

            Label {
                text: fibSlider.value.toFixed(0)
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(25)
            }

            Label {
                text: "= " + methods.fibonacci(fibSlider.value)
                font.pixelSize: Style.resize(14)
                font.bold: true
                color: Style.mainColor
                Layout.preferredWidth: Style.resize(90)
            }
        }

        // -- Seccion 3: Validacion de email — retorna bool.
        //    El resultado se usa directamente en bindings condicionales
        //    sin almacenar en variable: methods.validateEmail(emailInput.text)
        //    se evalua cada vez que el texto cambia.
        Label {
            text: "Email Validator"
            font.pixelSize: Style.resize(13)
            font.bold: true
            color: Style.fontPrimaryColor
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            TextField {
                id: emailInput
                Layout.fillWidth: true
                placeholderText: "Enter email..."
                text: "user@example.com"
                font.pixelSize: Style.resize(11)
            }

            Rectangle {
                width: Style.resize(60)
                height: Style.resize(28)
                radius: Style.resize(4)
                color: methods.validateEmail(emailInput.text) ? "#1A00D1A9" : "#1AFF6B6B"

                Label {
                    anchors.centerIn: parent
                    text: methods.validateEmail(emailInput.text) ? "Valid" : "Invalid"
                    font.pixelSize: Style.resize(11)
                    color: methods.validateEmail(emailInput.text) ? "#00D1A9" : "#FF6B6B"
                }
            }
        }

        // -- Seccion 4: Analisis de texto — retorna QVariantMap.
        //    QVariantMap en C++ se convierte en un objeto JavaScript en QML.
        //    El Repeater genera badges para cada estadistica (length, words,
        //    vowels, digits) accediendo a las propiedades del objeto retornado.
        Label {
            text: "Text Analyzer (returns QVariantMap)"
            font.pixelSize: Style.resize(13)
            font.bold: true
            color: Style.fontPrimaryColor
        }

        TextField {
            id: analyzeInput
            Layout.fillWidth: true
            text: "Qt Quick Controls 2 has 42 components!"
            font.pixelSize: Style.resize(11)
        }

        // -- Flow + Repeater: el modelo es un array JS construido a partir
        //    del QVariantMap retornado por analyzeText(). Cada badge
        //    muestra una estadistica con su clave y valor.
        Flow {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Repeater {
                model: {
                    var r = methods.analyzeText(analyzeInput.text)
                    return [
                        { key: "length", val: r.length },
                        { key: "words", val: r.words },
                        { key: "vowels", val: r.vowels },
                        { key: "digits", val: r.digits }
                    ]
                }

                Rectangle {
                    required property var modelData
                    width: Style.resize(80)
                    height: Style.resize(36)
                    radius: Style.resize(4)
                    color: Style.surfaceColor

                    Column {
                        anchors.centerIn: parent
                        Label {
                            text: modelData.val.toString()
                            font.pixelSize: Style.resize(14)
                            font.bold: true
                            color: Style.mainColor
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Label {
                            text: modelData.key
                            font.pixelSize: Style.resize(9)
                            color: Style.fontSecondaryColor
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }
        }
    }
}
