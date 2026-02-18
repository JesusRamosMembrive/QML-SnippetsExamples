qt_add_library(layoutsplugin STATIC)
qt_add_qml_module(layoutsplugin
    URI "layouts"
    VERSION 1.0
    QML_FILES
        Main.qml
        RowColumnLayoutCard.qml
        GridLayoutCard.qml
        FlowCard.qml
        StackLayoutCard.qml
        CollapsibleSidebar.qml
        DraggableSplitPane.qml
        MasonryGrid.qml
        HolyGrailLayout.qml
        ResponsiveBreakpoints.qml
        NestedDashboard.qml
)
