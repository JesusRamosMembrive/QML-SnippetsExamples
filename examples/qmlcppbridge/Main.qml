// =============================================================================
// Main.qml — Pagina principal del ejemplo QML / C++ Bridge
// =============================================================================
// Pagina contenedora que organiza cuatro tarjetas que demuestran los tres
// mecanismos principales de comunicacion entre C++ y QML en Qt:
//
//   1. Q_PROPERTY (PropertyBindCard): binding bidireccional de propiedades.
//      QML puede leer, escribir y observar cambios en propiedades C++.
//
//   2. Q_INVOKABLE + Q_ENUM (MethodCard): llamar funciones C++ desde QML
//      con parametros tipados. Incluye enums que QML puede usar directamente.
//
//   3. Signals (SignalCard): C++ emite signals que QML escucha con handlers
//      on<NombreSignal>. Comunicacion asincrona de C++ hacia QML.
//
//   4. Combinado (InteractiveBridgeCard): los tres mecanismos trabajando
//      juntos en una sola tarjeta.
//
// A diferencia de customitem/ (que usa QQuickPaintedItem para dibujo 2D),
// este ejemplo usa QObject puro — no hay componente visual en C++. La
// logica de negocio vive en C++ y la presentacion vive en QML.
//
// Los tipos C++ (PropertyBridge, MethodBridge, SignalBridge) estan definidos
// en imports/qmlcppbridge/ y registrados con QML_ELEMENT para ser usados
// como componentes QML normales.
// =============================================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils
import qmlsnippetsstyle

Item {
    id: root

    // -- Patron de visibilidad del proyecto (ver Dashboard.qml).
    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        ScrollView {
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {
                width: scrollView.availableWidth
                spacing: Style.resize(40)

                Label {
                    text: "QML / C++ Bridge"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }

                // -- Cuatro tarjetas en grid 2x2, una por cada mecanismo
                //    de comunicacion C++ <-> QML.
                GridLayout {
                    columns: 2
                    rows: 2
                    columnSpacing: Style.resize(20)
                    rowSpacing: Style.resize(20)
                    Layout.fillWidth: true

                    PropertyBindCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }

                    MethodCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }

                    SignalCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }

                    InteractiveBridgeCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: Style.resize(480)
                    }
                }
            }
        }
    }
}
