// =============================================================================
// WarningPanelCard.qml — Panel de Alertas ECAM (Warning/Caution)
// =============================================================================
// Simula el sistema de alertas del ECAM con dos niveles de prioridad:
//
// 1. MASTER WARNING (rojo): emergencias que requieren accion inmediata
//    (fuego, falla de motor, despresurización). Parpadea a 400ms.
//
// 2. MASTER CAUTION (ambar): precauciones que requieren atencion pero no
//    son emergencias inmediatas (nivel bajo de combustible, falla de bleed).
//    Parpadea a 500ms (ritmo mas lento que warning).
//
// En un avion real, el piloto presiona el boton Master Warning/Caution para
// reconocer la alerta y detener el parpadeo. Aqui se simula con MouseArea.
//
// Tecnicas QML utilizadas (sin Canvas, todo declarativo):
//   - ListModel dinamico: se agregan/eliminan mensajes en runtime con
//     append() y clear(). Esto demuestra modelos mutables.
//   - SequentialAnimation on opacity: crea el efecto de parpadeo alternando
//     entre dos valores de opacidad en bucle infinito
//   - Repeater con ListModel: renderiza los mensajes de alerta dinamicamente
//   - required property var model: acceso tipado al modelo en delegates
//     (patron de Qt 6 con ComponentBehavior: Bound)
//
// Patron de interaccion:
//   - Botones "+ Warning" / "+ Caution" agregan alertas al modelo
//   - Click en Master Warning/Caution limpia sus respectivas listas
//   - "Clear All" limpia ambas listas
//   - Los botones master solo estan activos (brillantes) cuando hay alertas
//     en su modelo. Sin alertas, se muestran atenuados.
// =============================================================================
pragma ComponentBehavior: Bound
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
        spacing: Style.resize(10)

        Label {
            text: "Warning Panel"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        // =====================================================================
        // Botones Master WARNING y CAUTION:
        // - El color de fondo depende de si hay alertas (model.count > 0):
        //   con alertas = color brillante, sin alertas = color apagado
        // - SequentialAnimation crea el parpadeo cuando running = true
        //   (solo cuando hay alertas). Alterna opacity entre 0.5 y 1.0
        //   en un bucle infinito, imitando las luces reales del cockpit.
        // - MouseArea: click para "reconocer" y limpiar las alertas
        // =====================================================================
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(10)

            // MASTER WARNING (rojo)
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(50)
                color: warningModel.count > 0 ? "#F44336" : "#5a1a1a"
                radius: Style.resize(4)
                border.color: "#F44336"
                border.width: 2

                // Parpadeo: alterna opacidad a 400ms por ciclo
                SequentialAnimation on opacity {
                    running: warningModel.count > 0
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.5; duration: 400 }
                    NumberAnimation { to: 1.0; duration: 400 }
                }

                Label {
                    anchors.centerIn: parent
                    text: "MASTER\nWARNING"
                    font.pixelSize: Style.resize(12)
                    font.bold: true
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: warningModel.clear()
                }
            }

            // MASTER CAUTION (ambar)
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.resize(50)
                color: cautionModel.count > 0 ? "#FF9800" : "#4a3a0a"
                radius: Style.resize(4)
                border.color: "#FF9800"
                border.width: 2

                // Parpadeo mas lento que warning (500ms vs 400ms)
                SequentialAnimation on opacity {
                    running: cautionModel.count > 0
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.6; duration: 500 }
                    NumberAnimation { to: 1.0; duration: 500 }
                }

                Label {
                    anchors.centerIn: parent
                    text: "MASTER\nCAUTION"
                    font.pixelSize: Style.resize(12)
                    font.bold: true
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: cautionModel.clear()
                }
            }
        }

        // =====================================================================
        // Modelos de datos dinamicos:
        // ListModel permite agregar y eliminar elementos en runtime.
        // Cada elemento tiene una propiedad "msg" con el texto de la alerta.
        // Los Repeaters de abajo se vinculan a estos modelos y se actualizan
        // automaticamente cuando cambia el modelo (binding reactivo de QML).
        // =====================================================================
        ListModel { id: warningModel }
        ListModel { id: cautionModel }

        // Lista de mensajes activos
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#1a1a1a"
            radius: Style.resize(4)

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Style.resize(8)
                spacing: Style.resize(2)

                // ---------------------------------------------------------
                // Mensajes de WARNING (rojo, con icono de peligro):
                // \u26A0 es el unicode del triangulo de advertencia.
                // Los mensajes usan required property var model para
                // acceder a los datos del ListModel de forma tipada.
                // ---------------------------------------------------------
                Repeater {
                    model: warningModel
                    Label {
                        required property var model
                        text: "\u26A0 " + model.msg
                        font.pixelSize: Style.resize(13)
                        font.bold: true
                        color: "#F44336"
                        Layout.fillWidth: true
                    }
                }

                // ---------------------------------------------------------
                // Mensajes de CAUTION (ambar, con icono de triangulo):
                // \u25B3 es un triangulo sin relleno, mas sutil que \u26A0.
                // ---------------------------------------------------------
                Repeater {
                    model: cautionModel
                    Label {
                        required property var model
                        text: "\u25B3 " + model.msg
                        font.pixelSize: Style.resize(13)
                        color: "#FF9800"
                        Layout.fillWidth: true
                    }
                }

                // Mensajes de estado fijos (informativos, verde)
                Label {
                    text: "\u2022 SLATS RETRACTED"
                    font.pixelSize: Style.resize(12)
                    color: "#4CAF50"
                    Layout.fillWidth: true
                }
                Label {
                    text: "\u2022 AUTO BRK: MED"
                    font.pixelSize: Style.resize(12)
                    color: "#4CAF50"
                    Layout.fillWidth: true
                }

                Item { Layout.fillHeight: true }
            }
        }

        // =====================================================================
        // Botones para simular alertas:
        // Cada click agrega un mensaje diferente al modelo correspondiente.
        // Se usa modulo (%) para ciclar entre los mensajes predefinidos.
        // Mensajes realistas de aviacion:
        //   Warning: ENG FIRE, ENG FAIL, CABIN PRESS, etc.
        //   Caution: FUEL LO LVL, BLEED FAULT, AIR PACK OFF, etc.
        // =====================================================================
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Button {
                text: "+ Warning"
                onClicked: {
                    var warnings = ["ENG 1 FIRE", "ENG 2 FAIL", "CABIN PRESS", "HYD G SYS LO PR", "ELEC GEN 1 FAULT"];
                    warningModel.append({ msg: warnings[warningModel.count % warnings.length] });
                }
            }
            Button {
                text: "+ Caution"
                onClicked: {
                    var cautions = ["FUEL L TK LO LVL", "BLEED 1 FAULT", "AIR PACK 1 OFF", "APU FAULT", "F/CTL ALTN LAW"];
                    cautionModel.append({ msg: cautions[cautionModel.count % cautions.length] });
                }
            }
            Item { Layout.fillWidth: true }
            Button {
                text: "Clear All"
                onClicked: {
                    warningModel.clear();
                    cautionModel.clear();
                }
            }
        }

        Label {
            text: "Master WARNING (red) / CAUTION (amber) with blinking. Click master buttons or Clear to dismiss."
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
