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
        audioOutput: AudioOutput { volume: volSlider.value }
        videoOutput: videoPreview
        loops: loopSwitch.checked ? MediaPlayer.Infinite : 1
        playbackRate: rateSlider.value

        onMediaStatusChanged: statusLabel.text = root.statusString(mediaStatus)
        onPlaybackStateChanged: stateLabel.text = root.stateString(playbackState)
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Interactive Media"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Custom URL, playback rate, loop and volume"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // URL input
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(6)

            TextField {
                id: urlField
                Layout.fillWidth: true
                placeholderText: "Enter media URL..."
                text: "https://www.w3schools.com/html/mov_bbb.mp4"
                font.pixelSize: Style.resize(11)
            }

            Button {
                text: "Load"
                implicitHeight: Style.resize(34)
                onClicked: {
                    player.source = urlField.text
                    player.play()
                }
            }
        }

        // Video preview
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#000000"
            radius: Style.resize(6)
            clip: true

            VideoOutput {
                id: videoPreview
                anchors.fill: parent
            }

            Label {
                anchors.centerIn: parent
                text: player.mediaStatus === MediaPlayer.InvalidMedia
                      ? "Invalid media" : ""
                visible: text !== ""
                font.pixelSize: Style.resize(14)
                color: "#FFFFFF80"
            }
        }

        // Seek
        Slider {
            Layout.fillWidth: true
            from: 0
            to: player.duration > 0 ? player.duration : 1
            value: player.position
            onMoved: player.position = value
        }

        // Playback rate
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Speed:"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
            }

            Slider {
                id: rateSlider
                Layout.fillWidth: true
                from: 0.25; to: 2.0; value: 1.0; stepSize: 0.25
            }

            Label {
                text: rateSlider.value.toFixed(2) + "x"
                font.pixelSize: Style.resize(11)
                color: Style.mainColor
                Layout.preferredWidth: Style.resize(40)
            }
        }

        // Controls row
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Button {
                text: player.playbackState === MediaPlayer.PlayingState
                      ? "Pause" : "Play"
                implicitHeight: Style.resize(34)
                onClicked: {
                    if (player.playbackState === MediaPlayer.PlayingState)
                        player.pause()
                    else
                        player.play()
                }
            }

            Button {
                text: "Stop"
                implicitHeight: Style.resize(34)
                onClicked: player.stop()
            }

            Label {
                text: "Loop:"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
            }

            Switch {
                id: loopSwitch
            }

            Item { Layout.fillWidth: true }

            Label {
                text: "Vol:"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
            }

            Slider {
                id: volSlider
                Layout.preferredWidth: Style.resize(80)
                from: 0; to: 1; value: 0.8
            }
        }

        // Status info
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(15)

            Label {
                id: stateLabel
                text: "Stopped"
                font.pixelSize: Style.resize(10)
                color: Style.fontSecondaryColor
            }
            Label {
                id: statusLabel
                text: "No media"
                font.pixelSize: Style.resize(10)
                color: Style.fontSecondaryColor
            }
            Item { Layout.fillWidth: true }
            Label {
                text: root.formatTime(player.position) + " / " + root.formatTime(player.duration)
                font.pixelSize: Style.resize(10)
                color: Style.mainColor
            }
        }
    }

    function formatTime(ms) {
        var s = Math.floor(ms / 1000)
        var m = Math.floor(s / 60)
        s = s % 60
        return m + ":" + (s < 10 ? "0" : "") + s
    }

    function statusString(status) {
        switch (status) {
        case MediaPlayer.NoMedia: return "No media"
        case MediaPlayer.Loading: return "Loading..."
        case MediaPlayer.Loaded: return "Loaded"
        case MediaPlayer.Buffered: return "Buffered"
        case MediaPlayer.Buffering: return "Buffering..."
        case MediaPlayer.Stalled: return "Stalled"
        case MediaPlayer.EndOfMedia: return "End of media"
        case MediaPlayer.InvalidMedia: return "Invalid media"
        default: return "Unknown"
        }
    }

    function stateString(state) {
        switch (state) {
        case MediaPlayer.PlayingState: return "Playing"
        case MediaPlayer.PausedState: return "Paused"
        case MediaPlayer.StoppedState: return "Stopped"
        default: return "Unknown"
        }
    }
}
