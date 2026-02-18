qt_add_library(listsplugin STATIC)
qt_add_qml_module(listsplugin
    URI "lists"
    VERSION 1.0
    QML_FILES
        Main.qml
        ListViewCard.qml
        GridViewCard.qml
        DynamicListCard.qml
        SectionsCard.qml
        SwipeToActionList.qml
        ExpandableAccordion.qml
        ChatBubbles.qml
        Timeline.qml
        CardCarousel.qml
        KanbanBoard.qml
)
