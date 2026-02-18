import QtQuick
import QtQuick.Controls

import utils
import mainui

ApplicationWindow {
    id: root
    visible: true
    color: Style.bgColor
    title: qsTr("QML Snippets Examples")
    width: Style.screenWidth
    height: Style.screenHeight

    Loader {
        id: homePageLoader
        anchors.fill: parent
        asynchronous: true
        active: false
        sourceComponent: HomePage {}
        opacity: 0.0
        visible: false
    }

    SplashScreen {
        id: splashScreen
        anchors.fill: parent
        z: 1000
    }

    Timer {
        id: loadDelay
        interval: 100
        running: true
        onTriggered: homePageLoader.active = true
    }

    NumberAnimation {
        id: splashFadeOut
        target: splashScreen
        property: "opacity"
        from: 1.0
        to: 0.0
        duration: 400
        easing.type: Easing.InOutQuad
        onFinished: splashScreen.destroy()
    }

    NumberAnimation {
        id: contentFadeIn
        target: homePageLoader
        property: "opacity"
        from: 0.0
        to: 1.0
        duration: 400
        easing.type: Easing.InOutQuad
    }

    Connections {
        target: homePageLoader
        function onStatusChanged() {
            if (homePageLoader.status === Loader.Ready) {
                homePageLoader.visible = true
                splashFadeOut.start()
                contentFadeIn.start()
            }
        }
    }
}
