// =============================================================================
// CameraCard.qml — Tarjeta de ejemplo: acceso a camara y captura de imagen
// =============================================================================
// Demuestra el flujo completo de captura en Qt 6: CaptureSession conecta
// una Camera con un ImageCapture y un VideoOutput. El usuario puede iniciar
// la camara, capturar una foto y ver la preview.
//
// Patrones clave para el aprendiz:
// - CaptureSession: componente central que orquesta Camera, ImageCapture y
//   VideoOutput. En Qt 6 reemplaza al antiguo QCamera + QCameraViewfinder.
// - MediaDevices: consulta en tiempo real los dispositivos multimedia del
//   sistema. videoInputs.length indica cuantas camaras hay disponibles.
// - ImageCapture.onImageCaptured: devuelve una URL de preview en memoria
//   (no un archivo en disco), ideal para mostrar la foto inmediatamente.
// - Patron de visibilidad condicional: VideoOutput se muestra solo cuando
//   la camara esta activa y no hay captura; Image se muestra solo cuando
//   hay captura, creando una transicion fluida entre ambos estados.
// =============================================================================
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

    // MediaDevices enumera los dispositivos multimedia del sistema.
    // Se usa para saber si hay camaras disponibles antes de intentar activarlas.
    MediaDevices { id: mediaDevices }

    // -------------------------------------------------------------------------
    // CaptureSession: conecta los tres componentes del pipeline de captura.
    // - Camera: controla el hardware (on/off via `active`).
    // - ImageCapture: toma fotos y emite onImageCaptured con la preview.
    // - videoOutput: muestra el feed en vivo de la camara en la UI.
    // -------------------------------------------------------------------------
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

        // -----------------------------------------------------------------
        // Area de visualizacion: alterna entre el feed en vivo (VideoOutput)
        // y la imagen capturada (Image) segun el estado. Un Label central
        // muestra mensajes informativos cuando no hay camara o esta apagada.
        // -----------------------------------------------------------------
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

        // -----------------------------------------------------------------
        // Controles: Start/Stop alterna la camara, Capture toma una foto,
        // Clear descarta la preview. Los botones se habilitan/deshabilitan
        // segun el estado actual (hay camara, esta activa, hay captura).
        // -----------------------------------------------------------------
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
