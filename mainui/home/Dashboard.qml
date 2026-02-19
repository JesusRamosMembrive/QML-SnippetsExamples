import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCore

import utils
import qmlsnippetsstyle

Item {
    id: root
    state: "Dashboard"
    objectName: "Dashboard"

    // Mapa estado del menu → URI qrc del modulo
    readonly property var pageMap: ({
        "Buttons":      "qrc:/qt/qml/buttons/Main.qml",
        "Sliders":      "qrc:/qt/qml/sliders/Main.qml",
        "RangeSliders": "qrc:/qt/qml/rangesliders/Main.qml",
        "ComboBox":     "qrc:/qt/qml/combobox/Main.qml",
        "TabBar":       "qrc:/qt/qml/tabbar/Main.qml",
        "SwipeView":    "qrc:/qt/qml/swipeview/Main.qml",
        "SplitView":    "qrc:/qt/qml/splitview/Main.qml",
        "ToolBar":      "qrc:/qt/qml/toolbar/Main.qml",
        "ScrollView":   "qrc:/qt/qml/scrollview/Main.qml",
        "MenuBar":      "qrc:/qt/qml/menubar/Main.qml",
        "PathView":     "qrc:/qt/qml/pathview/Main.qml",
        "GridView":     "qrc:/qt/qml/gridview/Main.qml",
        "Flickable":    "qrc:/qt/qml/flickable/Main.qml",
        "Shaders":      "qrc:/qt/qml/shaders/Main.qml",
        "Loader":       "qrc:/qt/qml/loaderex/Main.qml",
        "Switches":     "qrc:/qt/qml/switches/Main.qml",
        "TextInputs":   "qrc:/qt/qml/textinputs/Main.qml",
        "Indicators":   "qrc:/qt/qml/indicators/Main.qml",
        "Animations":   "qrc:/qt/qml/animations/Main.qml",
        "Popups":       "qrc:/qt/qml/popups/Main.qml",
        "Lists":        "qrc:/qt/qml/lists/Main.qml",
        "Canvas":       "qrc:/qt/qml/canvas/Main.qml",
        "Layouts":      "qrc:/qt/qml/layouts/Main.qml",
        "Transforms":   "qrc:/qt/qml/transforms/Main.qml",
        "Particles":    "qrc:/qt/qml/particles/Main.qml",
        "Graphs":       "qrc:/qt/qml/graphs/Main.qml",
        "PFD":          "qrc:/qt/qml/pfd/Main.qml",
        "HUD":          "qrc:/qt/qml/hud/Main.qml",
        "WebSocket":    "qrc:/qt/qml/websocketex/Main.qml",
        "ECAM":         "qrc:/qt/qml/ecam/Main.qml",
        "NavDisplay":   "qrc:/qt/qml/navdisplay/Main.qml",
        "Teoria":       "qrc:/qt/qml/theorycpp/Main.qml",
        "Date":         "qrc:/qt/qml/date/Main.qml",
        "AircraftMap":  "qrc:/qt/qml/aircraftmap/Main.qml",
        "Shapes":       "qrc:/qt/qml/shapes/Main.qml",
        "Maps":         "qrc:/qt/qml/maps/Main.qml",
        "PdfReader":    "qrc:/qt/qml/pdfreader/Main.qml",
        "Threads":      "qrc:/qt/qml/threadsex/Main.qml",
        "TableView":    "qrc:/qt/qml/tableview/Main.qml",
        "TreeView":     "qrc:/qt/qml/treeview/Main.qml",
        "Database":     "qrc:/qt/qml/databaseex/Main.qml"
    })

    Timer {
        id: repaintTimer
        interval: 250
        onTriggered: forceRepaintCanvases(root)
    }

    function forceRepaintCanvases(item) {
        for (var i = 0; i < item.children.length; i++) {
            var child = item.children[i]
            if (typeof child.requestPaint === "function")
                child.requestPaint()
            forceRepaintCanvases(child)
        }
    }

    // Dashboard home content
    Item {
        anchors.fill: parent
        opacity: (root.state === "Dashboard") ? 1.0 : 0.0
        visible: opacity > 0.0
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }

        Rectangle {
            anchors.fill: parent
            color: Style.bgColor

            ScrollView {
                id: homeScrollView
                anchors.fill: parent
                anchors.margins: Style.resize(40)
                clip: true
                contentWidth: availableWidth

                ColumnLayout {
                    width: homeScrollView.availableWidth
                    spacing: Style.resize(20)

                    // Title
                    Label {
                        text: "QML Snippets & Examples"
                        font.pixelSize: Style.resize(36)
                        font.bold: true
                        color: Style.mainColor
                        Layout.fillWidth: true
                    }

                    Label {
                        text: "A collection of QML / Qt Quick patterns and components for learning and reference."
                        font.pixelSize: Style.resize(16)
                        color: Style.fontSecondaryColor
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }

                    Item { Layout.preferredHeight: Style.resize(10) }

                    // Tech stack section
                    Label {
                        text: "Built with"
                        font.pixelSize: Style.resize(20)
                        font.bold: true
                        color: Style.fontPrimaryColor
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.leftMargin: Style.resize(10)
                        spacing: Style.resize(6)

                        Repeater {
                            model: [
                                "Qt 6.10 / Qt Quick / QML",
                                "C++ backend with CMake build system",
                                "Qt Quick Controls, Shapes, Particles, Graphs"
                            ]
                            Label {
                                required property string modelData
                                text: "\u2022  " + modelData
                                font.pixelSize: Style.resize(14)
                                color: Style.fontSecondaryColor
                                Layout.fillWidth: true
                            }
                        }
                    }

                    Item { Layout.preferredHeight: Style.resize(10) }

                    // Examples section header
                    RowLayout {
                        Layout.fillWidth: true

                        Label {
                            text: "Examples"
                            font.pixelSize: Style.resize(20)
                            font.bold: true
                            color: Style.fontPrimaryColor
                            Layout.fillWidth: true
                        }

                        Label {
                            text: "41 pages"
                            font.pixelSize: Style.resize(14)
                            color: Style.inactiveColor
                        }
                    }

                    // Examples list
                    Rectangle {
                        Layout.fillWidth: true
                        color: Style.cardColor
                        radius: Style.resize(8)
                        implicitHeight: examplesList.implicitHeight + Style.resize(20)

                        ListModel {
                            id: examplesModel
                            ListElement { name: "Buttons";    desc: "Standard, icon, toggle, and styled buttons" }
                            ListElement { name: "Sliders";    desc: "Range sliders, styled tracks, custom handles" }
                            ListElement { name: "RangeSliders"; desc: "RangeSlider with formatted labels, vertical, interactive" }
                            ListElement { name: "ComboBox";   desc: "Editable, ListModel roles, validators, interactive demo" }
                            ListElement { name: "TabBar";     desc: "StackLayout, icons, dynamic closable tabs, interactive" }
                            ListElement { name: "SwipeView";  desc: "PageIndicator, card carousel, onboarding wizard" }
                            ListElement { name: "SplitView";  desc: "Horizontal, vertical, nested IDE layout, color mixer" }
                            ListElement { name: "ToolBar";    desc: "ToolButtons, actions, contextual toolbar, text editor" }
                            ListElement { name: "ScrollView"; desc: "Custom ScrollBar, 2D Flickable, infinite scroll" }
                            ListElement { name: "MenuBar";    desc: "MenuBar, context menus, checkable items, submenus" }
                            ListElement { name: "PathView";   desc: "Circular path, arc carousel, coverflow, configurable path" }
                            ListElement { name: "GridView";   desc: "Photo gallery, dynamic items, filterable grid, cell sizing" }
                            ListElement { name: "Flickable";  desc: "Scroll, pinch-to-zoom, snap pages, configurable physics" }
                            ListElement { name: "Shaders";    desc: "GaussianBlur, Glow, DropShadow, ColorOverlay, effect combiner" }
                            ListElement { name: "Loader";     desc: "Component switching, load/unload, dynamic creation, view switcher" }
                            ListElement { name: "Switches";   desc: "Toggle switches and check controls" }
                            ListElement { name: "TextInputs"; desc: "Text fields, validation, styled inputs" }
                            ListElement { name: "Indicators"; desc: "Progress bars, busy indicators, gauges" }
                            ListElement { name: "Animations"; desc: "Transitions, behaviors, state animations" }
                            ListElement { name: "Popups";     desc: "Dialogs, drawers, tooltips, menus" }
                            ListElement { name: "Lists";      desc: "ListView, delegates, sections" }
                            ListElement { name: "Canvas";     desc: "2D drawing, shapes, paths, pie charts" }
                            ListElement { name: "Layouts";    desc: "Row, Column, Grid, Flow layouts" }
                            ListElement { name: "Transforms"; desc: "Rotation, scale, translate, 3D effects" }
                            ListElement { name: "Particles";  desc: "Emitters, affectors, trails, interactive" }
                            ListElement { name: "Graphs";     desc: "Line series, bar charts, real-time plots" }
                            ListElement { name: "PFD";        desc: "Artificial horizon, speed/altitude tapes, heading" }
                            ListElement { name: "ECAM";       desc: "Engine gauges, warnings, fuel synoptic" }
                            ListElement { name: "HUD";        desc: "Head-up display, pitch ladder, flight path vector" }
                            ListElement { name: "WebSocket"; desc: "C++ class exposed to QML, live echo server" }
                            ListElement { name: "NavDisplay"; desc: "Moving map, compass rose, flight plan" }
                            ListElement { name: "Teoria";     desc: "C++ theory: fundamentals through advanced topics" }
                            ListElement { name: "Date";       desc: "Tumbler date picker, MonthGrid calendar" }
                            ListElement { name: "AircraftMap"; desc: "Interactive blueprint with zoomable markers" }
                            ListElement { name: "Shapes";      desc: "Bezier curves, arcs, SVG paths, gradients, morphing" }
                            ListElement { name: "Maps";        desc: "OSM map, compass overlay, animated GPS route" }
                            ListElement { name: "PdfReader";   desc: "Drag & drop PDF viewer with zoom and navigation" }
                            ListElement { name: "Threads";     desc: "C++ pipeline: QThread, moveToThread, cross-thread signals" }
                            ListElement { name: "TableView";   desc: "C++ QAbstractTableModel, sort/filter proxy, editable cells" }
                            ListElement { name: "TreeView";    desc: "C++ QAbstractItemModel, tree hierarchy, expand/collapse, add/remove" }
                            ListElement { name: "Database";    desc: "SQLite CRUD with QSqlTableModel, query explorer, data dashboard" }
                        }

                        ColumnLayout {
                            id: examplesList
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: Style.resize(10)
                            spacing: 0

                            Repeater {
                                model: examplesModel

                                Item {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: Style.resize(36)

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: Style.resize(10)
                                        anchors.rightMargin: Style.resize(10)
                                        spacing: Style.resize(15)

                                        Label {
                                            text: model.name
                                            font.pixelSize: Style.resize(14)
                                            font.bold: true
                                            color: Style.mainColor
                                            Layout.preferredWidth: Style.resize(110)
                                        }

                                        Label {
                                            text: model.desc
                                            font.pixelSize: Style.resize(13)
                                            color: Style.fontSecondaryColor
                                            Layout.fillWidth: true
                                            elide: Text.ElideRight
                                        }
                                    }

                                    // Separator line
                                    Rectangle {
                                        anchors.bottom: parent.bottom
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.leftMargin: Style.resize(10)
                                        anchors.rightMargin: Style.resize(10)
                                        height: 1
                                        color: "#3A3D45"
                                        visible: index < examplesModel.count - 1
                                    }
                                }
                            }
                        }
                    }

                    Item { Layout.preferredHeight: Style.resize(5) }

                    // Footer hint
                    Label {
                        text: "Select a page from the menu to explore examples."
                        font.pixelSize: Style.resize(14)
                        font.italic: true
                        color: Style.inactiveColor
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Item { Layout.preferredHeight: Style.resize(20) }
                }
            }
        }
    }

    // Lazy loader — solo carga la pagina activa
    Loader {
        id: pageLoader
        anchors.fill: parent
        source: root.pageMap[root.state] ?? ""
        onLoaded: {
            if (item) {
                item.fullSize = true
            }
            repaintTimer.restart()
        }
    }
}
