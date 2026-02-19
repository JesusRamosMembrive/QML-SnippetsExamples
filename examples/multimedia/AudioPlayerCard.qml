// =============================================================================
// AudioPlayerCard.qml — Tarjeta de ejemplo: reproductor de audio con espectro
// =============================================================================
// Reproductor de audio que combina MediaPlayer (solo AudioOutput, sin video)
// con una visualizacion de espectro simulada usando Canvas.
//
// Patrones clave para el aprendiz:
// - MediaPlayer sin videoOutput: demuestra que MediaPlayer sirve tanto para
//   audio como video; basta con no asignar videoOutput.
// - Canvas (QML) para dibujo imperativo: el handler onPaint recibe un
//   contexto 2D similar al de HTML5 Canvas, ideal para graficos dinamicos.
// - Timer + requestPaint(): el Canvas no se repinta automaticamente; hay que
//   llamar requestPaint() cada vez que los datos cambian. El Timer a 80ms
//   (~12.5 fps) genera valores aleatorios suavizados para simular el espectro.
// - Suavizado de valores: prev * 0.3 + target * 0.7 interpola entre el
//   valor anterior y uno nuevo aleatorio, evitando saltos bruscos.
// - Gradiente vertical en cada barra: createLinearGradient da profundidad
//   visual al espectro con transicion de color teal claro a oscuro.
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

    // Array de alturas normalizadas (0.0-1.0) para las barras del espectro.
    // Se inicializa con valores bajos y se actualiza con el Timer.
    property var barHeights: []
    property int barCount: 32

    Component.onCompleted: {
        var arr = []
        for (var i = 0; i < barCount; i++) arr.push(0.1)
        barHeights = arr
    }

    // MediaPlayer solo con AudioOutput (sin videoOutput).
    // Demuestra que el reproductor multimedia es versatil.
    MediaPlayer {
        id: audioPlayer
        source: "https://www.w3schools.com/html/horse.ogg"
        audioOutput: AudioOutput {
            volume: audioVolSlider.value
        }
    }

    // -------------------------------------------------------------------------
    // Timer de visualizacion: genera datos simulados del espectro cada 80ms.
    // Solo corre cuando el audio esta reproduciendose (running vinculado
    // a playbackState). Al detenerse, reinicia las barras a su altura minima.
    // Nota: Qt 6 no expone datos FFT reales del audio en QML, por lo que
    // se simulan con Math.random() suavizado.
    // -------------------------------------------------------------------------
    Timer {
        id: vizTimer
        interval: 80
        repeat: true
        running: audioPlayer.playbackState === MediaPlayer.PlayingState

        onTriggered: {
            var arr = []
            for (var i = 0; i < root.barCount; i++) {
                var prev = root.barHeights[i] || 0.1
                var target = 0.1 + Math.random() * 0.8
                arr.push(prev * 0.3 + target * 0.7)
            }
            root.barHeights = arr
            spectrumCanvas.requestPaint()
        }

        onRunningChanged: {
            if (!running) {
                var arr = []
                for (var i = 0; i < root.barCount; i++) arr.push(0.1)
                root.barHeights = arr
                spectrumCanvas.requestPaint()
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Audio Player"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "MediaPlayer + AudioOutput with spectrum visualization"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // -----------------------------------------------------------------
        // Visualizador de espectro: Canvas con dibujo imperativo.
        // Cada barra se dibuja como un rectangulo con gradiente vertical.
        // El ancho de cada barra se calcula dividiendo el ancho total
        // entre barCount, descontando los gaps entre barras.
        // -----------------------------------------------------------------
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.surfaceColor
            radius: Style.resize(6)
            clip: true

            Canvas {
                id: spectrumCanvas
                anchors.fill: parent
                anchors.margins: Style.resize(10)

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)

                    var gap = 2
                    var barW = (width - (root.barCount - 1) * gap) / root.barCount
                    var bars = root.barHeights

                    for (var i = 0; i < root.barCount; i++) {
                        var h = bars[i] * height
                        var x = i * (barW + gap)
                        var y = height - h

                        var gradient = ctx.createLinearGradient(x, y, x, height)
                        gradient.addColorStop(0, "#00D1A9")
                        gradient.addColorStop(1, "#006B56")
                        ctx.fillStyle = gradient
                        ctx.fillRect(x, y, barW, h)
                    }
                }
            }

            Label {
                anchors.centerIn: parent
                text: audioPlayer.mediaStatus === MediaPlayer.InvalidMedia
                      ? "Could not load audio" : ""
                visible: text !== ""
                font.pixelSize: Style.resize(14)
                color: "#FFFFFF80"
            }
        }

        // Barra de busqueda: misma tecnica que en VideoPlayerCard (onMoved).
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Label {
                text: root.formatTime(audioPlayer.position)
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(40)
            }

            Slider {
                Layout.fillWidth: true
                from: 0
                to: audioPlayer.duration > 0 ? audioPlayer.duration : 1
                value: audioPlayer.position
                onMoved: audioPlayer.position = value
            }

            Label {
                text: root.formatTime(audioPlayer.duration)
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(40)
            }
        }

        // Controles: Play/Pause, Stop y volumen.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Button {
                text: audioPlayer.playbackState === MediaPlayer.PlayingState
                      ? "Pause" : "Play"
                implicitWidth: Style.resize(70)
                implicitHeight: Style.resize(34)
                onClicked: {
                    if (audioPlayer.playbackState === MediaPlayer.PlayingState)
                        audioPlayer.pause()
                    else
                        audioPlayer.play()
                }
            }

            Button {
                text: "Stop"
                implicitWidth: Style.resize(50)
                implicitHeight: Style.resize(34)
                onClicked: audioPlayer.stop()
            }

            Item { Layout.fillWidth: true }

            Label {
                text: "Vol:"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
            }

            Slider {
                id: audioVolSlider
                Layout.preferredWidth: Style.resize(80)
                from: 0; to: 1; value: 0.8
            }
        }
    }

    // Funcion auxiliar para convertir milisegundos a formato m:ss.
    function formatTime(ms) {
        var s = Math.floor(ms / 1000)
        var m = Math.floor(s / 60)
        s = s % 60
        return m + ":" + (s < 10 ? "0" : "") + s
    }
}
