// =============================================================================
// Scatter3DCard.qml — Scatter plot 3D multi-eje con dos series superpuestas
// =============================================================================
// Muestra dos Scatter3DSeries en el mismo Scatter3D:
//   - Serie A: nube de puntos con distribución gaussiana (Box-Muller)
//   - Serie B: hélice paramétrica (espiral 3D)
//
// Conceptos clave:
// - Scatter3D usa tres ejes independientes (axisX, axisY, axisZ) configurados
//   con propiedades inline: axisX.min, axisX.title, etc.
// - Los datos se cargan via ItemModelScatterDataProxy + ListModel, que es el
//   patrón recomendado en Qt 6.8+ para alimentar series 3D desde QML.
// - Cada serie tiene su propio color, tamaño y forma de punto (mesh).
// - shadowQuality activa sombras en tiempo real para dar profundidad visual.
// - Abstract3DSeries.Mesh.Sphere: enum con scope (Qt 6.8+ enforce scoped enums).
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

    readonly property int pointCount: 120

    // --- Modelos de datos ---
    ListModel { id: cloudModel }
    ListModel { id: helixModel }

    // Genera un valor con distribución normal aproximada (Box-Muller).
    function randNormal(center, stddev) {
        var u = Math.random(), v = Math.random()
        return center + stddev * Math.sqrt(-2 * Math.log(u)) * Math.cos(2 * Math.PI * v)
    }

    function generateCloud() {
        cloudModel.clear()
        for (var i = 0; i < root.pointCount; i++) {
            cloudModel.append({
                "xv": root.randNormal(0, 1.8),
                "yv": root.randNormal(0, 1.8),
                "zv": root.randNormal(0, 1.8)
            })
        }
    }

    function generateHelix() {
        helixModel.clear()
        var n = root.pointCount
        for (var i = 0; i < n; i++) {
            var t = (i / n) * Math.PI * 6   // 3 vueltas completas
            helixModel.append({
                "xv": 3.0 * Math.cos(t),
                "yv": (i / n) * 8 - 4,      // desplazamiento lineal −4 a 4
                "zv": 3.0 * Math.sin(t)
            })
        }
    }

    function regenerate() {
        generateCloud()
        generateHelix()
    }

    Component.onCompleted: regenerate()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(16)
        spacing: Style.resize(10)

        // --- Cabecera ---
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Style.resize(2)

                Label {
                    text: "Scatter 3D — Nube Gaussiana + Hélice"
                    font.pixelSize: Style.resize(16)
                    font.bold: true
                    color: Style.mainColor
                }
                Label {
                    text: "Dos series: distribución gaussiana y espiral paramétrica"
                    font.pixelSize: Style.resize(11)
                    color: Style.fontSecondaryColor
                }
            }

            RowLayout {
                spacing: Style.resize(12)
                RowLayout {
                    spacing: Style.resize(4)
                    Rectangle { width: Style.resize(10); height: Style.resize(10); radius: 5; color: Style.mainColor }
                    Label { text: "Nube"; font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
                }
                RowLayout {
                    spacing: Style.resize(4)
                    Rectangle { width: Style.resize(10); height: Style.resize(10); radius: 5; color: "#FEA601" }
                    Label { text: "Hélice"; font.pixelSize: Style.resize(11); color: Style.fontSecondaryColor }
                }
            }

            Button {
                text: "Regenerar"
                onClicked: root.regenerate()
            }
        }

        // --- Gráfico 3D ---
        Scatter3D {
            id: scatter3d
            Layout.fillWidth: true
            Layout.fillHeight: true

            cameraPreset: Graphs3D.CameraPreset.IsometricLeft
            shadowQuality: Graphs3D.ShadowQuality.Low
            msaaSamples: 4

            // Ejes configurados inline (Qt 6.8+ elimina ValueAxis3D como tipo QML).
            axisX.title: "Eje X"
            axisX.titleVisible: true
            axisX.min: -5
            axisX.max: 5
            axisX.segmentCount: 5
            axisX.labelFormat: "%.1f"

            axisY.title: "Eje Y"
            axisY.titleVisible: true
            axisY.min: -5
            axisY.max: 5
            axisY.segmentCount: 5
            axisY.labelFormat: "%.1f"

            axisZ.title: "Eje Z"
            axisZ.titleVisible: true
            axisZ.min: -5
            axisZ.max: 5
            axisZ.segmentCount: 5
            axisZ.labelFormat: "%.1f"

            theme: GraphsTheme {
                plotAreaBackgroundVisible: false
                backgroundVisible: false
                colorScheme: GraphsTheme.ColorScheme.Dark
                theme: GraphsTheme.Theme.BlueSeries
                labelTextColor: "#cccccc"
                grid.mainColor: Qt.rgba(1, 1, 1, 0.1)
            }

            // Serie A: nube gaussiana
            Scatter3DSeries {
                id: cloudSeries
                baseColor: Style.mainColor
                itemSize: 0.06
                // Abstract3DSeries.Mesh.Sphere: enum con scope en Qt 6.8+
                mesh: Abstract3DSeries.Mesh.Sphere

                ItemModelScatterDataProxy {
                    itemModel: cloudModel
                    xPosRole: "xv"
                    yPosRole: "yv"
                    zPosRole: "zv"
                }
            }

            // Serie B: hélice paramétrica
            Scatter3DSeries {
                id: helixSeries
                baseColor: "#FEA601"
                itemSize: 0.07
                mesh: Abstract3DSeries.Mesh.Sphere

                ItemModelScatterDataProxy {
                    itemModel: helixModel
                    xPosRole: "xv"
                    yPosRole: "yv"
                    zPosRole: "zv"
                }
            }
        }

        Label {
            text: "Scatter3DSeries · ItemModelScatterDataProxy · axisX / axisY / axisZ independientes"
            font.pixelSize: Style.resize(11)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
        }
    }
}
