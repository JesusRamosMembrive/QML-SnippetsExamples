import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import asynccpp
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    AsyncComputer { id: computer }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "QtConcurrent::run"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Run heavy computations off the main thread"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        GridLayout {
            Layout.fillWidth: true
            columns: 3
            columnSpacing: Style.resize(6)
            rowSpacing: Style.resize(6)

            Button {
                text: "Primes 100K"
                Layout.fillWidth: true
                implicitHeight: Style.resize(34)
                enabled: !computer.running
                onClicked: computer.countPrimes(100000)
            }
            Button {
                text: "Primes 1M"
                Layout.fillWidth: true
                implicitHeight: Style.resize(34)
                enabled: !computer.running
                onClicked: computer.countPrimes(1000000)
            }
            Button {
                text: "Primes 5M"
                Layout.fillWidth: true
                implicitHeight: Style.resize(34)
                enabled: !computer.running
                onClicked: computer.countPrimes(5000000)
            }
            Button {
                text: "Fib(40)"
                Layout.fillWidth: true
                implicitHeight: Style.resize(34)
                enabled: !computer.running
                onClicked: computer.computeFibonacci(40)
            }
            Button {
                text: "Sort 1M"
                Layout.fillWidth: true
                implicitHeight: Style.resize(34)
                enabled: !computer.running
                onClicked: computer.sortRandom(1000000)
            }
            Button {
                text: "Sort 10M"
                Layout.fillWidth: true
                implicitHeight: Style.resize(34)
                enabled: !computer.running
                onClicked: computer.sortRandom(10000000)
            }
        }

        BusyIndicator {
            running: computer.running
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: Style.resize(40)
            Layout.preferredHeight: Style.resize(40)
            visible: computer.running
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Style.resize(6)
            color: Style.surfaceColor

            ColumnLayout {
                anchors.centerIn: parent
                spacing: Style.resize(8)

                Label {
                    text: computer.result || "Click a button to start"
                    font.pixelSize: Style.resize(13)
                    color: computer.result !== "" ? Style.mainColor : "#FFFFFF30"
                    Layout.alignment: Qt.AlignHCenter
                    wrapMode: Text.WordWrap
                }

                Label {
                    text: computer.elapsedMs > 0
                          ? "Completed in " + computer.elapsedMs + " ms" : ""
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                    Layout.alignment: Qt.AlignHCenter
                    visible: computer.elapsedMs > 0
                }
            }
        }
    }
}
