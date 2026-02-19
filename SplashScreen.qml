// =============================================================================
// SplashScreen.qml — Pantalla de carga inicial
// =============================================================================
// Se muestra mientras el Loader de Main.qml carga HomePage en segundo plano.
// Debe ser lo más ligero posible: solo elementos básicos (Rectangle, Text,
// Repeater) sin imports pesados que retrasen su propio renderizado.
//
// Componentes utilizados:
//   - Column: layout vertical para centrar título + spinner + texto
//   - Repeater + delegate: patrón model/view para crear los 8 puntos del spinner
//   - SequentialAnimation: animaciones encadenadas de opacidad y escala
// =============================================================================

// pragma ComponentBehavior: Bound
// Esta directiva (Qt 6.5+) activa el modo "bound" para los delegates de este
// archivo. En modo Bound, los delegates NO pueden acceder a propiedades del
// modelo de forma implícita (como "model.name" o simplemente "name").
// En su lugar, DEBEN declarar las propiedades con "required property".
//
// ¿Por qué usarlo?
//   1. Evita warnings del compilador QML (qmllint): "Unqualified access"
//   2. Hace el código más explícito y seguro: si olvidas declarar una
//      propiedad requerida, obtienes un error en compilación, no en ejecución
//   3. Permite optimizaciones del motor QML al saber exactamente qué
//      propiedades usa cada delegate
//
// Sin este pragma, el delegate podría acceder a "index" directamente sin
// declararlo, pero recibiríamos un warning de qmllint.
pragma ComponentBehavior: Bound
import QtQuick
import utils

Item {
    id: splash
    anchors.fill: parent

    // Fondo sólido que cubre toda la ventana. Necesario porque el Item raíz
    // es transparente por defecto (Item no tiene color, solo Rectangle).
    Rectangle {
        anchors.fill: parent
        color: Style.bgColor
    }

    // --- Layout principal ---
    // Column apila sus hijos verticalmente con el espaciado indicado.
    // anchors.centerIn centra todo el bloque en la pantalla.
    Column {
        anchors.centerIn: parent
        spacing: Style.resize(40)

        // Bloque de título: dos textos apilados verticalmente
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Style.resize(8)

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "QML Snippets"
                font.family: Style.fontFamilyBold
                font.pixelSize: Style.resize(42)
                font.bold: true
                color: Style.mainColor
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Examples"
                font.family: Style.fontFamilyBold
                font.pixelSize: Style.resize(28)
                color: Style.fontPrimaryColor
            }
        }

        // --- Spinner de carga: 8 puntos animados en círculo ---
        // Patrón Model/View/Delegate simplificado con Repeater:
        //   - Model: el número 8 (genera índices 0..7)
        //   - View: el Repeater (instancia el delegate 8 veces)
        //   - Delegate: Rectangle (un punto circular)
        //
        // Cuando el model de un Repeater es un número entero, Qt genera
        // automáticamente la propiedad "index" (0, 1, 2, ..., n-1) para
        // cada instancia del delegate.
        Item {
            id: spinner
            width: Style.resize(60)
            height: Style.resize(60)
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                model: 8
                delegate: Rectangle {
                    id: dot
                    // required property int index
                    // Declaración obligatoria por el pragma ComponentBehavior: Bound.
                    // El Repeater inyecta automáticamente "index" en cada delegate,
                    // pero con Bound debemos declararlo explícitamente para que el
                    // compilador QML sepa que existe y su tipo.
                    required property int index

                    // --- Posicionamiento circular con trigonometría ---
                    // Cada punto se ubica en un ángulo diferente alrededor del centro.
                    // angle: convierte el índice (0-7) en radianes.
                    //   Ej: index 0 → 0°, index 1 → 45°, index 2 → 90°, etc.
                    // dotRadius: distancia del centro al punto.
                    //
                    // La fórmula x = centro + radio * cos(ángulo) da la posición X
                    // en coordenadas polares convertidas a cartesianas.
                    // Se resta width/2 para centrar el punto en su posición.
                    //
                    // readonly: indica que estas propiedades no cambian después de
                    // la creación. El motor QML puede optimizar al no monitorearlas.
                    readonly property real angle: index * (360 / 8) * (Math.PI / 180)
                    readonly property real dotRadius: Style.resize(24)

                    x: spinner.width / 2 + dotRadius * Math.cos(angle) - width / 2
                    y: spinner.height / 2 + dotRadius * Math.sin(angle) - height / 2
                    width: Style.resize(8)
                    height: width
                    radius: width / 2          // radius = width/2 → círculo perfecto
                    color: Style.mainColor

                    // --- Animación de opacidad: efecto "onda" secuencial ---
                    // SequentialAnimation on <propiedad>: aplica la animación
                    // directamente sobre esa propiedad del componente padre.
                    //
                    // El efecto de "onda" se logra con las PauseAnimation:
                    //   - Pausa inicial: index * 100ms → cada punto empieza más tarde
                    //   - Pausa final: (7 - index) * 100ms → complementa para que
                    //     el ciclo total sea igual para todos (700ms de pausa total)
                    //
                    // Resultado: los puntos se iluminan uno tras otro en secuencia,
                    // creando la ilusión de un punto de luz que recorre el círculo.
                    SequentialAnimation on opacity {
                        loops: Animation.Infinite
                        PauseAnimation { duration: dot.index * 100 }
                        NumberAnimation { to: 1.0; duration: 400; easing.type: Easing.InOutQuad }
                        NumberAnimation { to: 0.3; duration: 400; easing.type: Easing.InOutQuad }
                        PauseAnimation { duration: (7 - dot.index) * 100 }
                    }

                    // Animación de escala: mismo patrón de onda que la opacidad.
                    // Combinar opacidad + escala da un efecto más orgánico que
                    // solo animar una propiedad. Los puntos "pulsan" a la vez
                    // que se iluminan.
                    SequentialAnimation on scale {
                        loops: Animation.Infinite
                        PauseAnimation { duration: dot.index * 100 }
                        NumberAnimation { to: 1.0; duration: 400; easing.type: Easing.InOutQuad }
                        NumberAnimation { to: 0.6; duration: 400; easing.type: Easing.InOutQuad }
                        PauseAnimation { duration: (7 - dot.index) * 100 }
                    }
                }
            }
        }

        // Texto de estado bajo el spinner
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Loading..."
            font.family: Style.fontFamilyRegular
            font.pixelSize: Style.resize(14)
            color: Style.inactiveColor
        }
    }
}
