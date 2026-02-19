qt_add_library(chatuiplugin STATIC)
qt_add_qml_module(chatuiplugin
    URI "chatui"
    VERSION 1.0
    QML_FILES
        Main.qml
        ChatBubblesCard.qml
        TypingIndicatorCard.qml
        EmojiPickerCard.qml
        InteractiveChatCard.qml
)
