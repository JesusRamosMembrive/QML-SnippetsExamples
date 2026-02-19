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

        // Text transform (Q_ENUM demo)
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

                onCurrentIndexChanged: {
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

        // Fibonacci
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

        // Email validator
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

        // Text analyzer (returns QVariantMap)
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
