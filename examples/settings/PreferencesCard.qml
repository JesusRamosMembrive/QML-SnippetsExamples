// =============================================================================
// PreferencesCard.qml — Preferencias con Q_PROPERTY respaldadas por QSettings
// =============================================================================
// Demuestra el patrón más robusto para settings en Qt: Q_PROPERTY en C++ con
// lectura/escritura automática a QSettings. Cada propiedad (theme, fontSize,
// userName, notifications, volume) persiste entre reinicios de la app.
//
// La ventaja de este enfoque sobre setValue/getValue directo es que:
// 1. Los bindings QML funcionan nativamente (no se necesita refresh manual)
// 2. Se tiene validación de tipos en tiempo de compilación
// 3. Se pueden definir valores por defecto en el constructor C++
//
// El preview en la parte inferior refleja los cambios en tiempo real,
// mostrando la reactividad del sistema de bindings de QML.
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import settingsmgr
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    SettingsManager { id: settings }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Preferences"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "Q_PROPERTY backed by QSettings — changes persist across restarts"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // ---- Selector de tema ----
        // ComboBox vinculado a settings.theme (Q_PROPERTY QString).
        // currentIndex se inicializa buscando el valor actual en el modelo,
        // y onCurrentTextChanged lo escribe de vuelta al C++.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Theme:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(90)
            }

            ComboBox {
                Layout.fillWidth: true
                model: ["Dark", "Light", "System"]
                currentIndex: model.indexOf(settings.theme)
                onCurrentTextChanged: settings.theme = currentText
            }
        }

        // ---- Tamaño de fuente ----
        // Slider con stepSize: 1 para valores enteros. Se usa onMoved en vez
        // de onValueChanged para evitar escrituras durante la inicialización
        // (onMoved solo se emite por interacción del usuario).
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Font size:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(90)
            }

            Slider {
                Layout.fillWidth: true
                from: 8; to: 24; value: settings.fontSize; stepSize: 1
                onMoved: settings.fontSize = value
            }

            Label {
                text: settings.fontSize + " px"
                font.pixelSize: Style.resize(11)
                color: Style.mainColor
                Layout.preferredWidth: Style.resize(40)
            }
        }

        // ---- Nombre de usuario ----
        // TextField vinculado bidireccionalmente: lee de settings.userName
        // y escribe en cada cambio. En producción se usaría un debounce
        // para no escribir a disco en cada tecla.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Username:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(90)
            }

            TextField {
                Layout.fillWidth: true
                text: settings.userName
                font.pixelSize: Style.resize(11)
                onTextChanged: settings.userName = text
            }
        }

        // ---- Notificaciones ----
        // Switch con indicador visual de estado (color verde/rojo).
        // El binding bidireccional checked <-> settings.notifications
        // demuestra cómo un bool Q_PROPERTY se mapea naturalmente a Switch.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Notifications:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(90)
            }

            Switch {
                checked: settings.notifications
                onCheckedChanged: settings.notifications = checked
            }

            Label {
                text: settings.notifications ? "Enabled" : "Disabled"
                font.pixelSize: Style.resize(11)
                color: settings.notifications ? "#00D1A9" : "#FF6B6B"
            }
        }

        // ---- Volumen ----
        // Slider continuo (0.0–1.0) mostrado como porcentaje.
        // toFixed(0) elimina decimales para la presentación al usuario.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Volume:"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(90)
            }

            Slider {
                Layout.fillWidth: true
                from: 0; to: 1; value: settings.volume
                onMoved: settings.volume = value
            }

            Label {
                text: (settings.volume * 100).toFixed(0) + "%"
                font.pixelSize: Style.resize(11)
                color: Style.mainColor
                Layout.preferredWidth: Style.resize(40)
            }
        }

        // Spacer flexible para empujar el preview hacia abajo
        Item { Layout.fillHeight: true }

        // ---- Vista previa en tiempo real ----
        // Muestra el efecto combinado de todas las preferencias: el nombre,
        // el tema (que cambia colores de fondo/texto) y el tamaño de fuente
        // (font.pixelSize lee directamente settings.fontSize). Esto demuestra
        // la potencia de los bindings reactivos de QML.
        Rectangle {
            Layout.fillWidth: true
            height: Style.resize(50)
            radius: Style.resize(6)
            color: settings.theme === "Light" ? "#E8E8E8" : Style.surfaceColor

            Label {
                anchors.centerIn: parent
                text: "Preview: " + settings.userName + " (" + settings.theme + " theme)"
                font.pixelSize: settings.fontSize
                color: settings.theme === "Light" ? "#333333" : Style.fontPrimaryColor
            }
        }
    }
}
