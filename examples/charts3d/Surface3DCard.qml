// =============================================================================
// Surface3DCard.qml — Superficie 3D con función matemática interactiva
// =============================================================================
// Genera una malla de superficie 3D evaluando f(x, z) en una rejilla regular.
// El usuario puede cambiar la función con un ComboBox, alternar el modo de
// dibujado (superficie/malla) y ajustar la resolución con un Slider.
//
// Funciones disponibles:
//   1. sinc 2D  — sin(πr)/(πr), el "sombrero mexicano"
//   2. sin(x)·cos(z) — producto de ondas ortogonales
//   3. Paraboloide — -(x²+z²)
//   4. Ripple — sin(sqrt(x²+z²))
//
// Conceptos clave:
// - ItemModelSurfaceDataProxy conecta un ListModel (rejilla plana) con Surface3D.
//   Los roles rowRole/columnRole agrupan los items en filas y columnas.
//   xPosRole/yPosRole/zPosRole dan la posición real en 3D.
// - Los ejes se configuran inline (axisX.min, axisY.title, etc.) porque
//   ValueAxis3D no es un tipo QML en Qt 6.8+.
// - Surface3DSeries.DrawSurface, DrawWireframe, DrawSurfaceAndWireframe son
//   flags (no enums con scope) accesibles directamente en la serie.
// - GraphsTheme reemplaza Theme3D desde Qt 6.8+.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtGraphs
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    property int resolution: 30
    property int funcIndex: 0
    property int drawModeIndex: 0
    readonly property var drawModeValues: [
        Surface3DSeries.DrawSurface,
        Surface3DSeries.DrawWireframe,
        Surface3DSeries.DrawSurfaceAndWireframe
    ]
    readonly property var drawModeNames: ["Superficie", "Malla", "Superficie + Malla"]

    // Modelo plano que sirve como rejilla resolution×resolution.
    // Cada item tiene: row (índice Z), col (índice X), xval, yval, zval.
    ListModel { id: surfaceModel }

    function evalFunc(x, z) {
        switch (root.funcIndex) {
        case 0: {
            var r = Math.sqrt(x * x + z * z)
            return r < 0.001 ? 1.0 : Math.sin(r * Math.PI) / (r * Math.PI)
        }
        case 1: return Math.sin(x) * Math.cos(z)
        case 2: return -(x * x + z * z) * 0.12
        case 3: return Math.sin(Math.sqrt(x * x + z * z) * 2.5) * 0.7
        default: return 0
        }
    }

    function buildSurface() {
        surfaceModel.clear()
        var n = root.resolution
        var range = 4.0
        for (var iz = 0; iz < n; iz++) {
            var z = -range + (2 * range * iz) / (n - 1)
            for (var ix = 0; ix < n; ix++) {
                var x = -range + (2 * range * ix) / (n - 1)
                var y = root.evalFunc(x, z)
                surfaceModel.append({ "row": iz, "col": ix, "xval": x, "yval": y, "zval": z })
            }
        }
    }

    Component.onCompleted: buildSurface()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(16)
        spacing: Style.resize(10)

        // --- Cabecera ---
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Style.resize(2)
                Label {
                    text: "Surface 3D — Función Matemática"
                    font.pixelSize: Style.resize(16)
                    font.bold: true
                    color: Style.mainColor
                }
                Label {
                    text: "Rejilla " + root.resolution + "×" + root.resolution + " puntos"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                }
            }
        }

        // --- Controles ---
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label { text: "Función:"; font.pixelSize: Style.resize(12); color: Style.fontPrimaryColor }
            ComboBox {
                model: ["sinc 2D (sombrero)", "sin(x)·cos(z)", "Paraboloide", "Ripple"]
                Layout.preferredWidth: Style.resize(170)
                onCurrentIndexChanged: { root.funcIndex = currentIndex; root.buildSurface() }
            }

            Label { text: "Modo:"; font.pixelSize: Style.resize(12); color: Style.fontPrimaryColor }
            Button {
                text: root.drawModeNames[root.drawModeIndex]
                Layout.preferredWidth: Style.resize(140)
                onClicked: {
                    root.drawModeIndex = (root.drawModeIndex + 1) % root.drawModeValues.length
                    surfaceSeries.drawMode = root.drawModeValues[root.drawModeIndex]
                }
            }

            Label { text: "Res:"; font.pixelSize: Style.resize(12); color: Style.fontPrimaryColor }
            Slider {
                id: resSlider
                from: 10; to: 60; value: root.resolution; stepSize: 5
                Layout.preferredWidth: Style.resize(90)
                onValueChanged: { root.resolution = Math.round(value); root.buildSurface() }
            }
            Label {
                text: root.resolution
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(24)
            }
        }

        // --- Gráfico 3D ---
        Surface3D {
            id: surface3d
            Layout.fillWidth: true
            Layout.fillHeight: true

            cameraPreset: Graphs3D.CameraPreset.IsometricLeftHigh
            shadowQuality: Graphs3D.ShadowQuality.None
            msaaSamples: 4

            // Ejes configurados inline (Qt 6.8+).
            axisX.title: "X"
            axisX.titleVisible: true
            axisX.min: -4; axisX.max: 4
            axisX.segmentCount: 4
            axisX.labelFormat: "%.1f"

            axisY.title: "Y = f(x,z)"
            axisY.titleVisible: true
            axisY.min: -1.5; axisY.max: 1.5
            axisY.segmentCount: 4
            axisY.labelFormat: "%.2f"

            axisZ.title: "Z"
            axisZ.titleVisible: true
            axisZ.min: -4; axisZ.max: 4
            axisZ.segmentCount: 4
            axisZ.labelFormat: "%.1f"

            theme: GraphsTheme {
                plotAreaBackgroundVisible: false
                backgroundVisible: false
                colorScheme: GraphsTheme.ColorScheme.Dark
                theme: GraphsTheme.Theme.BlueSeries
                labelTextColor: "#cccccc"
                grid.mainColor: Qt.rgba(1, 1, 1, 0.1)
            }

            Surface3DSeries {
                id: surfaceSeries
                // DrawSurface, DrawWireframe, DrawSurfaceAndWireframe son flags (no scoped).
                drawMode: Surface3DSeries.DrawSurface
                baseColor: Style.mainColor

                // ItemModelSurfaceDataProxy: rowRole/columnRole agrupan los items,
                // xPosRole/yPosRole/zPosRole dan la posición real en 3D.
                ItemModelSurfaceDataProxy {
                    itemModel: surfaceModel
                    rowRole: "row"
                    columnRole: "col"
                    xPosRole: "xval"
                    yPosRole: "yval"
                    zPosRole: "zval"
                }
            }
        }

        Label {
            text: "Surface3DSeries + ItemModelSurfaceDataProxy · drawMode Superficie/Malla · axisX/Y/Z inline"
            font.pixelSize: Style.resize(11)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
        }
    }
}
