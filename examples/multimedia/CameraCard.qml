import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property bool cameraActive: false
    property string lastCapture: ""

    MediaDevices { id: mediaDevices }

    CaptureSession {
        id: captureSession
        camera: Camera {
            id: camera
            active: root.cameraActive
        }
        imageCapture: ImageCapture {
            id: imageCapture
            onImageCaptured: function(requestId, preview) {
                root.lastCapture = preview
            }
        }
        videoOutput: cameraOutput
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Camera"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "CaptureSession + Camera + ImageCapture"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // Camera / captured image display
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(6)
            clip: true

            VideoOutput {
                id: cameraOutput
                anchors.fill: parent
                visible: root.cameraActive && root.lastCapture === ""
            }

            Image {
                anchors.fill: parent
                source: root.lastCapture
                fillMode: Image.PreserveAspectFit
                visible: root.lastCapture !== ""
            }

            Label {
                anchors.centerIn: parent
                text: {
                    if (mediaDevices.videoInputs.length === 0)
                        return "No camera detected"
                    if (!root.cameraActive)
                        return "Press Start to activate camera"
                    return ""
                }
                visible: text !== "" && root.lastCapture === ""
                font.pixelSize: Style.resize(14)
                color: "#FFFFFF60"
            }
        }

        // Controls
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Button {
                text: root.cameraActive ? "Stop" : "Start"
                implicitHeight: Style.resize(34)
                enabled: mediaDevices.videoInputs.length > 0
                onClicked: {
                    root.lastCapture = ""
                    root.cameraActive = !root.cameraActive
                }
            }

            Button {
                text: "Capture"
                implicitHeight: Style.resize(34)
                enabled: root.cameraActive
                onClicked: imageCapture.capture()
            }

            Button {
                text: "Clear"
                implicitHeight: Style.resize(34)
                enabled: root.lastCapture !== ""
                onClicked: root.lastCapture = ""
            }

            Item { Layout.fillWidth: true }

            Label {
                text: mediaDevices.videoInputs.length + " camera(s) found"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
            }
        }
    }
}
