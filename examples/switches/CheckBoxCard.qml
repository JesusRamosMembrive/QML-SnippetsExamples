import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(15)

        Label {
            text: "CheckBox"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        CheckBox {
            id: selectAllCheckBox
            text: "Select All"
            tristate: true
            checkState: {
                var checked = 0;
                if (optionA.checked) checked++;
                if (optionB.checked) checked++;
                if (optionC.checked) checked++;
                if (checked === 3) return Qt.Checked;
                if (checked === 0) return Qt.Unchecked;
                return Qt.PartiallyChecked;
            }
            onClicked: {
                var newState = (checkState !== Qt.Checked);
                optionA.checked = newState;
                optionB.checked = newState;
                optionC.checked = newState;
            }
        }

        ColumnLayout {
            Layout.leftMargin: Style.resize(30)
            spacing: Style.resize(5)

            CheckBox {
                id: optionA
                text: "Option A"
                checked: true
            }

            CheckBox {
                id: optionB
                text: "Option B"
            }

            CheckBox {
                id: optionC
                text: "Option C"
                checked: true
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Style.resize(1)
            color: Style.bgColor
        }

        Label {
            text: {
                var selected = [];
                if (optionA.checked) selected.push("A");
                if (optionB.checked) selected.push("B");
                if (optionC.checked) selected.push("C");
                return "Selected: " + (selected.length > 0 ? selected.join(", ") : "none");
            }
            font.pixelSize: Style.resize(13)
            color: Style.fontSecondaryColor
        }

        Label {
            text: "CheckBox supports checked, unchecked, and partially checked (tristate) states"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Item { Layout.fillHeight: true }
    }
}
