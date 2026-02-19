import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    MediaPlayer {
        id: player
        source: "https://www.w3schools.com/html/mov_bbb.mp4"
        audioOutput: AudioOutput {
            volume: volumeSlider.value
        }
        videoOutput: videoOut
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Video Player"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "MediaPlayer + VideoOutput with custom transport controls"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // Video display
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#000000"
            radius: Style.resize(6)
            clip: true

            VideoOutput {
                id: videoOut
                anchors.fill: parent
            }

            Label {
                anchors.centerIn: parent
                text: {
                    switch (player.mediaStatus) {
                    case MediaPlayer.NoMedia: return "Click Play to load video"
                    case MediaPlayer.Loading: return "Loading..."
                    case MediaPlayer.Buffering: return "Buffering..."
                    case MediaPlayer.InvalidMedia: return "Could not load media"
                    default: return ""
                    }
                }
                visible: text !== "" && player.playbackState !== MediaPlayer.PlayingState
                font.pixelSize: Style.resize(14)
                color: "#FFFFFF80"
            }
        }

        // Seek bar
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            Label {
                text: root.formatTime(player.position)
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(40)
            }

            Slider {
                Layout.fillWidth: true
                from: 0
                to: player.duration > 0 ? player.duration : 1
                value: player.position
                onMoved: player.position = value
            }

            Label {
                text: root.formatTime(player.duration)
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(40)
            }
        }

        // Transport controls
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Button {
                text: "\u23EE"
                font.pixelSize: Style.resize(16)
                implicitWidth: Style.resize(34)
                implicitHeight: Style.resize(34)
                onClicked: player.position = 0
            }

            Button {
                text: player.playbackState === MediaPlayer.PlayingState
                      ? "\u23F8" : "\u25B6"
                font.pixelSize: Style.resize(18)
                implicitWidth: Style.resize(40)
                implicitHeight: Style.resize(40)
                onClicked: {
                    if (player.playbackState === MediaPlayer.PlayingState)
                        player.pause()
                    else
                        player.play()
                }
            }

            Button {
                text: "\u23F9"
                font.pixelSize: Style.resize(16)
                implicitWidth: Style.resize(34)
                implicitHeight: Style.resize(34)
                onClicked: player.stop()
            }

            Item { Layout.fillWidth: true }

            Label {
                text: "Vol:"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
            }

            Slider {
                id: volumeSlider
                Layout.preferredWidth: Style.resize(80)
                from: 0; to: 1; value: 0.8
            }
        }
    }

    function formatTime(ms) {
        var s = Math.floor(ms / 1000)
        var m = Math.floor(s / 60)
        s = s % 60
        return m + ":" + (s < 10 ? "0" : "") + s
    }
}
