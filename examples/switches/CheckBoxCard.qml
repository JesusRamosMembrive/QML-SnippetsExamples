// =============================================================================
// CheckBoxCard.qml — Tarjeta con ejemplo de CheckBox y patron "Select All"
// =============================================================================
// Demuestra el componente CheckBox de Qt Quick Controls 2 con una funcionalidad
// comun en interfaces reales: un checkbox padre "Select All" que controla
// multiples checkboxes hijos.
//
// Patron clave — tristate (tres estados):
//   - Qt.Checked: todos los hijos estan marcados
//   - Qt.Unchecked: ninguno esta marcado
//   - Qt.PartiallyChecked: algunos si, otros no (el indicador muestra un guion)
//
// El estado del padre se calcula reactivamente contando cuantos hijos estan
// checked. Cuando el usuario hace click en el padre, se fuerza el estado de
// todos los hijos a checked o unchecked segun la logica en onClicked.
// =============================================================================

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

        // -----------------------------------------------------------------
        // CheckBox padre con tristate: true — permite tres estados visuales.
        // checkState se calcula con un binding que cuenta los hijos activos.
        // onClicked alterna entre "todos seleccionados" y "ninguno".
        //
        // Nota: usamos onClicked (no onCheckStateChanged) porque queremos
        // reaccionar solo a clicks del usuario, no a cambios programaticos
        // que ocurren cuando los hijos cambian y recalculan checkState.
        // -----------------------------------------------------------------
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

        // -----------------------------------------------------------------
        // Checkboxes hijos — indentados con leftMargin para indicar jerarquia.
        // Cada uno es independiente: el usuario puede marcarlos individualmente
        // y el padre se recalcula automaticamente gracias al binding reactivo.
        // -----------------------------------------------------------------
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

        // -----------------------------------------------------------------
        // Etiqueta de resumen: usa un bloque JavaScript en el binding para
        // construir dinamicamente la lista de opciones seleccionadas.
        // Esto muestra que los bindings de QML pueden contener logica compleja.
        // -----------------------------------------------------------------
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
