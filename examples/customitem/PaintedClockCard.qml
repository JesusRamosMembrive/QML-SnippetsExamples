// =============================================================================
// PaintedClockCard.qml — Reloj analogico usando QQuickPaintedItem (C++)
// =============================================================================
// Demuestra como usar un componente C++ personalizado (AnalogClock) en QML.
// AnalogClock hereda de QQuickPaintedItem y dibuja un reloj completo con
// QPainter: esfera, marcas de hora, manecillas y color de acento.
//
// Integracion C++ <-> QML:
//   - "import customitem" importa el modulo C++ que contiene AnalogClock.
//   - AnalogClock esta registrado con QML_ELEMENT en su header, lo que
//     permite usarlo como <AnalogClock { ... }> directamente en QML.
//   - Q_PROPERTY(int hours/minutes/seconds ...): QML puede leer y escribir
//     estas propiedades como si fueran propiedades QML nativas. Los setters
//     en C++ llaman update() que dispara un repintado del item.
//   - Q_PROPERTY(QColor accentColor): QML asigna un string de color ("#00D1A9")
//     y Qt lo convierte automaticamente a QColor en C++.
//
// El Timer de QML actualiza las propiedades cada segundo con la hora real.
// Cada vez que un setter en C++ detecta un cambio, llama update() para
// solicitar un repintado. Qt entonces llama paint() pasando un QPainter.
//
// Aprendizaje: la logica de dibujo complejo vive en C++ (paint()), pero
// la configuracion y la logica de la UI viven en QML (Timer, selector de
// color). Esto separa responsabilidades de manera eficiente.
// =============================================================================
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import customitem
import utils

Rectangle {
    id: root
    color: Style.cardColor
    radius: Style.resize(8)

    // -- Timer QML que actualiza las propiedades del reloj cada segundo.
    //    triggeredOnStart: true asegura que se dibuje inmediatamente al
    //    crear el componente, sin esperar el primer intervalo.
    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var now = new Date()
            clock.hours = now.getHours()
            clock.minutes = now.getMinutes()
            clock.seconds = now.getSeconds()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Analog Clock"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Label {
            text: "QQuickPaintedItem with QPainter — live clock"
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            Layout.fillWidth: true
        }

        // -- Area del reloj: AnalogClock es el componente C++.
        //    Se dimensiona como cuadrado (height: width) tomando el menor
        //    de ancho/alto del padre para mantener la proporcion circular.
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            AnalogClock {
                id: clock
                anchors.centerIn: parent
                width: Math.min(parent.width, parent.height) - Style.resize(20)
                height: width
            }
        }

        // -- Hora digital: lee las Q_PROPERTYs hours/minutes/seconds
        //    del AnalogClock C++. El binding se actualiza cada vez que
        //    las propiedades cambian (gracias a las signals NOTIFY).
        Label {
            text: {
                var h = clock.hours.toString().padStart(2, '0')
                var m = clock.minutes.toString().padStart(2, '0')
                var s = clock.seconds.toString().padStart(2, '0')
                return h + ":" + m + ":" + s
            }
            font.pixelSize: Style.resize(22)
            font.bold: true
            color: Style.fontPrimaryColor
            Layout.alignment: Qt.AlignHCenter
        }

        // -- Selector de color de acento: al hacer clic en un circulo,
        //    se asigna el color a clock.accentColor (Q_PROPERTY de C++).
        //    El setter en C++ llama update() -> se repinta el reloj
        //    con el nuevo color de manecilla de segundos.
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(8)

            Label {
                text: "Accent:"
                font.pixelSize: Style.resize(11)
                color: Style.fontSecondaryColor
            }

            Repeater {
                model: ["#00D1A9", "#FF6B6B", "#4FC3F7", "#FFD93D", "#C084FC"]

                Rectangle {
                    required property string modelData
                    required property int index
                    width: Style.resize(24)
                    height: Style.resize(24)
                    radius: Style.resize(12)
                    color: modelData
                    border.width: clock.accentColor == modelData ? 2 : 0
                    border.color: "#FFFFFF"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: clock.accentColor = parent.modelData
                    }
                }
            }
        }
    }
}
