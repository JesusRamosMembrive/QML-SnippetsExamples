// =============================================================================
// ToastHost.qml — Host reutilizable para notificaciones tipo toast
// =============================================================================
// Expone una API imperativa centrada en show()/success()/error(), inspirada en
// librerias de React donde un "toast host" vive cerca de la raiz y el resto de
// la app solo envia eventos. Internamente mantiene una cola reactiva basada en
// arrays JS y un Timer global para auto-dismiss.
// =============================================================================
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils

Item {
    id: root

    property var toasts: []
    property int maxVisible: 4
    property int nextId: 0
    property int tickInterval: 100
    property int toastWidth: Style.resize(320)
    property bool newestOnTop: true
    property string placement: "top-right"

    readonly property bool topPlacement: placement.indexOf("top") === 0
    readonly property bool rightPlacement: placement.indexOf("right") !== -1
    readonly property bool centerPlacement: placement.indexOf("center") !== -1

    signal actionInvoked(var toast)
    signal dismissed(var toast, string reason)

    function paletteFor(kind) {
        switch (kind) {
        case "success":
            return {
                badge: "OK",
                title: "Success",
                accent: "#34D399",
                background: "#183629"
            }
        case "error":
            return {
                badge: "ER",
                title: "Error",
                accent: "#F87171",
                background: "#3A1F25"
            }
        case "warning":
            return {
                badge: "!",
                title: "Warning",
                accent: "#FBBF24",
                background: "#3E2E12"
            }
        default:
            return {
                badge: "i",
                title: "Info",
                accent: "#60A5FA",
                background: "#182B45"
            }
        }
    }

    function cloneToast(toast) {
        return {
            id: toast.id,
            kind: toast.kind,
            badge: toast.badge,
            title: toast.title,
            message: toast.message,
            accent: toast.accent,
            background: toast.background,
            actionLabel: toast.actionLabel,
            durationMs: toast.durationMs,
            remainingMs: toast.remainingMs,
            sticky: toast.sticky,
            paused: toast.paused
        }
    }

    function normalizeText(value, fallback) {
        if (value === undefined || value === null)
            return fallback
        return String(value)
    }

    function show(options) {
        options = options || {}
        var kind = normalizeText(options.kind, "info")
        var palette = paletteFor(kind)
        var durationMs = Math.max(1200, Number(options.durationMs || 3600))
        var toast = {
            id: root.nextId++,
            kind: kind,
            badge: normalizeText(options.badge, palette.badge),
            title: normalizeText(options.title, palette.title),
            message: normalizeText(options.message, ""),
            accent: normalizeText(options.accent, palette.accent),
            background: normalizeText(options.background, palette.background),
            actionLabel: normalizeText(options.actionLabel, ""),
            durationMs: durationMs,
            remainingMs: durationMs,
            sticky: options.sticky === true,
            paused: false
        }

        var next = root.toasts.slice()
        if (root.newestOnTop)
            next.unshift(toast)
        else
            next.push(toast)

        while (next.length > root.maxVisible) {
            var overflow = root.newestOnTop ? next.pop() : next.shift()
            root.dismissed(overflow, "overflow")
        }

        root.toasts = next
        return toast.id
    }

    function success(message, detail) {
        return show({
            kind: "success",
            title: "Success",
            message: detail ? message + " " + detail : message
        })
    }

    function error(message, detail) {
        return show({
            kind: "error",
            title: "Error",
            message: detail ? message + " " + detail : message
        })
    }

    function warning(message, detail) {
        return show({
            kind: "warning",
            title: "Warning",
            message: detail ? message + " " + detail : message
        })
    }

    function info(message, detail) {
        return show({
            kind: "info",
            title: "Info",
            message: detail ? message + " " + detail : message
        })
    }

    function removeToast(id, reason) {
        var current = root.toasts.slice()
        var next = []

        for (var i = 0; i < current.length; ++i) {
            var toast = current[i]
            if (toast.id === id)
                root.dismissed(toast, reason || "manual")
            else
                next.push(toast)
        }

        root.toasts = next
    }

    function clearAll() {
        var current = root.toasts.slice()
        for (var i = 0; i < current.length; ++i)
            root.dismissed(current[i], "clear")
        root.toasts = []
    }

    function setPaused(id, paused) {
        var changed = false
        var next = []

        for (var i = 0; i < root.toasts.length; ++i) {
            var toast = cloneToast(root.toasts[i])
            if (toast.id === id && toast.paused !== paused) {
                toast.paused = paused
                changed = true
            }
            next.push(toast)
        }

        if (changed)
            root.toasts = next
    }

    anchors.fill: parent

    Timer {
        running: root.toasts.length > 0
        interval: root.tickInterval
        repeat: true
        onTriggered: {
            var expired = []
            var next = []

            for (var i = 0; i < root.toasts.length; ++i) {
                var toast = root.cloneToast(root.toasts[i])
                if (!toast.sticky && !toast.paused)
                    toast.remainingMs -= root.tickInterval

                if (toast.sticky || toast.remainingMs > 0)
                    next.push(toast)
                else
                    expired.push(toast)
            }

            root.toasts = next

            for (var j = 0; j < expired.length; ++j)
                root.dismissed(expired[j], "timeout")
        }
    }

    Item {
        anchors.fill: parent
        z: 50

        Column {
            id: stack
            width: Math.min(root.toastWidth, parent.width - Style.resize(24))
            spacing: Style.resize(10)
            anchors.top: root.topPlacement ? parent.top : undefined
            anchors.bottom: root.topPlacement ? undefined : parent.bottom
            anchors.right: root.rightPlacement ? parent.right : undefined
            anchors.horizontalCenter: root.centerPlacement ? parent.horizontalCenter : undefined
            anchors.margins: Style.resize(16)

            Repeater {
                model: root.toasts.length

                delegate: Rectangle {
                    id: toastFrame
                    required property int index

                    readonly property var toast: root.toasts[index] || ({})
                    property bool entered: false
                    property real hiddenYOffset: root.topPlacement ? -12 : 12
                    property real hiddenXOffset: root.rightPlacement ? 18 : 0

                    width: stack.width
                    implicitHeight: contentColumn.implicitHeight + Style.resize(18)
                    radius: Style.resize(14)
                    color: toast.background || Style.surfaceColor
                    border.color: toast.accent || Style.mainColor
                    border.width: Style.resize(1)
                    opacity: entered ? 1.0 : 0.0
                    x: entered ? 0 : hiddenXOffset
                    y: entered ? 0 : hiddenYOffset

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 180
                            easing.type: Easing.OutCubic
                        }
                    }

                    Behavior on x {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutCubic
                        }
                    }

                    Behavior on y {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutCubic
                        }
                    }

                    Component.onCompleted: entered = true

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.NoButton
                        hoverEnabled: true
                        onEntered: root.setPaused(toastFrame.toast.id, true)
                        onExited: root.setPaused(toastFrame.toast.id, false)
                    }

                    ColumnLayout {
                        id: contentColumn
                        anchors.fill: parent
                        anchors.margins: Style.resize(14)
                        spacing: Style.resize(10)

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Style.resize(10)

                            Rectangle {
                                Layout.preferredWidth: Style.resize(34)
                                Layout.preferredHeight: Style.resize(34)
                                radius: Style.resize(17)
                                color: Qt.rgba(1, 1, 1, 0.08)
                                border.color: toastFrame.toast.accent || "#FFFFFF"
                                border.width: Style.resize(1)

                                Label {
                                    anchors.centerIn: parent
                                    text: toastFrame.toast.badge || "i"
                                    font.pixelSize: Style.resize(12)
                                    font.bold: true
                                    color: toastFrame.toast.accent || "#FFFFFF"
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: Style.resize(2)

                                Label {
                                    text: toastFrame.toast.title || ""
                                    font.pixelSize: Style.resize(14)
                                    font.bold: true
                                    color: Style.fontPrimaryColor
                                    Layout.fillWidth: true
                                }

                                Label {
                                    text: toastFrame.toast.message || ""
                                    visible: text.length > 0
                                    wrapMode: Text.WordWrap
                                    font.pixelSize: Style.resize(12)
                                    color: Style.fontSecondaryColor
                                    Layout.fillWidth: true
                                }
                            }

                            ToolButton {
                                text: "x"
                                flat: true
                                onClicked: root.removeToast(toastFrame.toast.id, "manual")
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            visible: toastFrame.toast.actionLabel || toastFrame.toast.sticky

                            Button {
                                visible: (toastFrame.toast.actionLabel || "").length > 0
                                text: toastFrame.toast.actionLabel || ""
                                flat: true
                                onClicked: {
                                    root.actionInvoked(toastFrame.toast)
                                    root.removeToast(toastFrame.toast.id, "action")
                                }
                            }

                            Item {
                                Layout.fillWidth: true
                            }

                            Label {
                                text: toastFrame.toast.sticky ? "sticky" : (toastFrame.toast.paused ? "paused" : "auto")
                                font.pixelSize: Style.resize(11)
                                color: Style.inactiveColor
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Style.resize(4)
                            radius: Style.resize(2)
                            visible: !toastFrame.toast.sticky
                            color: Qt.rgba(1, 1, 1, 0.10)

                            Rectangle {
                                width: parent.width * Math.max(0, toastFrame.toast.remainingMs / Math.max(1, toastFrame.toast.durationMs))
                                height: parent.height
                                radius: parent.radius
                                color: toastFrame.toast.accent || Style.mainColor
                            }
                        }
                    }
                }
            }
        }
    }
}
