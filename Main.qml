// =============================================================================
// Main.qml — Ventana raíz de la aplicación
// =============================================================================
// Este es el primer archivo QML que se carga (desde main.cpp con
// engine.loadFromModule("Main", "Main")). Su responsabilidad es:
//   1. Crear la ventana principal de la aplicación
//   2. Mostrar un splash screen mientras se carga el contenido pesado
//   3. Hacer la transición animada del splash al contenido real
//
// Patrón de carga diferida (Deferred Loading):
// La app tiene muchas páginas de ejemplo, y cargarlas todas al inicio
// bloquearía la UI varios segundos. Para evitarlo:
//   - Se muestra primero el SplashScreen (ligero, se renderiza al instante)
//   - Se usa un Loader asíncrono para cargar HomePage en segundo plano
//   - Cuando termina la carga, se anima la transición splash → contenido
// =============================================================================

import QtQuick
import QtQuick.Controls

import utils      // Para acceder a Style (colores, dimensiones)
import mainui     // Para acceder a HomePage (el shell principal)

// ApplicationWindow es el tipo raíz para apps de Qt Quick Controls 2.
// A diferencia de Window (de QtQuick), ApplicationWindow integra soporte
// para menuBar, header, footer y el sistema de estilos de Controls 2.
// Si usaras Window en vez de ApplicationWindow, los controles estilizados
// (Button, Slider, etc.) podrían no aplicar el estilo correctamente.
ApplicationWindow {
    id: root
    visible: true
    color: Style.bgColor
    title: qsTr("QML Snippets Examples")  // qsTr() marca el texto para traducción (i18n)
    width: Style.screenWidth
    height: Style.screenHeight

    // --- Loader: carga asíncrona del contenido principal ---
    // Loader es un componente que instancia otro componente bajo demanda.
    // Ventajas sobre poner HomePage directamente:
    //   - asynchronous: true → carga en un hilo secundario del motor QML,
    //     sin bloquear el renderizado del splash screen
    //   - active: false → no empieza a cargar inmediatamente (ver Timer abajo)
    //   - Permite controlar cuándo se crea y destruye el contenido
    //
    // sourceComponent vs source:
    //   - sourceComponent: Component {} → el tipo ya está compilado, más rápido
    //   - source: "HomePage.qml" → carga desde URL, útil para carga dinámica
    //   Aquí usamos sourceComponent porque HomePage ya está disponible vía import.
    //
    // Empieza invisible y transparente; se hará visible cuando termine de cargar.
    Loader {
        id: homePageLoader
        anchors.fill: parent
        asynchronous: true
        active: false
        sourceComponent: HomePage {}
        opacity: 0.0
        visible: false
    }

    // --- Splash Screen ---
    // Se muestra inmediatamente sobre todo (z: 1000 garantiza que esté encima).
    // Es un componente ligero (solo textos y un spinner animado) que se
    // renderiza en el primer frame mientras el Loader trabaja en segundo plano.
    SplashScreen {
        id: splashScreen
        anchors.fill: parent
        z: 1000
    }

    // --- Timer de retardo inicial ---
    // ¿Por qué no activar el Loader directamente al inicio?
    // Porque el motor QML necesita al menos un frame para renderizar el splash.
    // Si activamos el Loader inmediatamente, la carga asíncrona compite con el
    // primer renderizado y el usuario vería una pantalla en blanco.
    // Con 100ms de retardo, garantizamos que el splash se pinte primero.
    Timer {
        id: loadDelay
        interval: 100
        running: true
        onTriggered: homePageLoader.active = true
    }

    // --- Animaciones de transición ---
    // Se definen como objetos independientes (no inline con "Behavior on") para
    // poder controlar exactamente cuándo se disparan con .start().
    // Ambas duran 400ms con easing InOutQuad (aceleración suave al inicio y final).

    // Desvanece el splash screen y lo destruye al terminar.
    // destroy() libera la memoria del splash, ya que no se vuelve a necesitar.
    NumberAnimation {
        id: splashFadeOut
        target: splashScreen
        property: "opacity"
        from: 1.0
        to: 0.0
        duration: 400
        easing.type: Easing.InOutQuad
        onFinished: splashScreen.destroy()
    }

    // Hace aparecer el contenido real con fade-in.
    NumberAnimation {
        id: contentFadeIn
        target: homePageLoader
        property: "opacity"
        from: 0.0
        to: 1.0
        duration: 400
        easing.type: Easing.InOutQuad
    }

    // --- Conexión al estado del Loader ---
    // Connections escucha señales de otro objeto (en este caso homePageLoader).
    // Cuando el Loader termina de instanciar el componente (status === Loader.Ready),
    // hacemos visible el contenido y arrancamos ambas animaciones en paralelo:
    // el splash desaparece mientras el contenido aparece, creando un crossfade.
    //
    // Otros estados posibles del Loader:
    //   - Loader.Null: no tiene source/sourceComponent asignado
    //   - Loader.Loading: está cargando (solo relevante con source: URL)
    //   - Loader.Error: hubo un error al cargar el componente
    Connections {
        target: homePageLoader
        function onStatusChanged() {
            if (homePageLoader.status === Loader.Ready) {
                homePageLoader.visible = true
                splashFadeOut.start()
                contentFadeIn.start()
            }
        }
    }
}
