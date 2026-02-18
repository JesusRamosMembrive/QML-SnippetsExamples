pragma Singleton
import QtQuick

QtObject {
    id: root

    property int screenWidth: 1920
    property int screenHeight: 1080

    property string theme: "green"

    property string bgColor: "#1A1D23"
    property string bgColorDark: "#14171B"
    property string mainColor: (theme === "green") ? "#00D1A9" : "#FEA601"
    property string inactiveColor: "#999999"

    property color cardColor: "#252830"
    property color surfaceColor: "#2A2D35"

    property string iconPath: "/assets/icons/"
    property string imagePath: "/assets/images/"
    property string meshPath: "/assets/mesh/"

    function icon(name) {
        return Qt.resolvedUrl(iconPath + name + ".png");
    }

    function gfx(name) {
        return Qt.resolvedUrl(imagePath + name + ".png");
    }

    function mesh(name, format = ".obj") {
        return Qt.resolvedUrl(meshPath + name + format);
    }

    function resize(value) {
        return (value);
    }

    property color grey: "#2A2D35"
    property color fontContrastColor: "#FFFFFF"
    property color fontPrimaryColor: "#FFFFFF"
    property color fontSecondaryColor: "#CCCCCC"

    property int fontSizeS: root.resize(15)
    property int fontSizeM: root.resize(19)
    property int fontSizeL: root.resize(26)

    property string fontFamilyRegular: quicksandBook.name
    property string fontFamilyBold: quicksandBold.name

    property FontLoader quicksandBook: FontLoader {
        source: "/assets/fonts/Quicksand_Book.otf"
    }

    property FontLoader quicksandBold: FontLoader {
        source: "/assets/fonts/Quicksand_Bold.otf"
    }

    function setGreenTheme() {
        theme = "green";
    }
    function setOrangeTheme() {
        theme = "orange";
    }
}
