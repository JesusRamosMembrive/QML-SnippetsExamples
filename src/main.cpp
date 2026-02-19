// =============================================================================
// main.cpp — Punto de entrada de la aplicación
// =============================================================================
// Este archivo inicializa la aplicación Qt, configura el motor QML y carga
// la interfaz. Es intencionalmente minimalista: toda la lógica de UI está
// en QML, y los backends C++ se registran desde sus propios módulos.
// =============================================================================

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

// Cabeceras auto-generadas por Qt durante la compilación:
// - app_environment.h: define set_qt_environment() que configura variables
//   de entorno antes de crear la aplicación (ej: QT_QUICK_CONTROLS_CONF).
// - import_qml_plugins.h: contiene macros Q_IMPORT_QML_PLUGIN(...) que
//   fuerzan al enlazador a incluir los plugins QML estáticos. Sin esto,
//   el enlazador podría "optimizar" y eliminar los plugins que no ve
//   referenciados directamente desde C++, causando errores "module not found".
#include "app_environment.h"
#include "import_qml_plugins.h"

int main(int argc, char *argv[])
{
    // Configura variables de entorno de Qt antes de crear QGuiApplication.
    // Debe llamarse ANTES del constructor porque algunas variables (como el
    // backend de renderizado) solo se leen durante la inicialización.
    set_qt_environment();

    // QGuiApplication (no QApplication) porque usamos Qt Quick, no Qt Widgets.
    // Qt Quick tiene su propio sistema de renderizado basado en Scene Graph,
    // que no necesita el sistema de widgets tradicional.
    QGuiApplication app(argc, argv);

    // El motor QML: interpreta archivos QML, gestiona el árbol de objetos
    // y conecta la UI con los backends C++.
    QQmlApplicationEngine engine;

    // Exponemos la ruta del ejecutable como propiedad global "appDirPath"
    // accesible desde cualquier archivo QML. Esto permite a QML localizar
    // archivos externos (como PDFs) que están junto al ejecutable, ya que
    // QML no tiene acceso directo al filesystem sin ayuda de C++.
    // Ejemplo de uso en QML: Qt.resolvedUrl(appDirPath + "/pdf_files/doc.pdf")
    engine.rootContext()->setContextProperty("appDirPath",
        QGuiApplication::applicationDirPath());

    // Conecta la señal quit del motor QML con el cierre de la aplicación.
    // Esto permite que desde QML se pueda llamar a Qt.quit() y la app
    // se cierre limpiamente. Sin esta conexión, Qt.quit() no haría nada.
    QObject::connect(&engine, &QQmlApplicationEngine::quit, &app, &QGuiApplication::quit);

    // Carga el componente principal desde el módulo QML "Main".
    // loadFromModule("Main", "Main") busca el módulo con URI "Main" y dentro
    // de él el tipo "Main" (que corresponde a Main.qml en mainui/).
    // Esta es la forma moderna (Qt 6.5+) de cargar QML, reemplazando al
    // antiguo engine.load(QUrl("qrc:/main.qml")). La ventaja es que el
    // sistema de módulos gestiona automáticamente las dependencias.
    engine.loadFromModule("Main", "Main");

    // Inicia el bucle de eventos de Qt. La aplicación queda aquí hasta que
    // se cierre la ventana o se llame a Qt.quit(). Retorna 0 si todo fue
    // bien, o un código de error si hubo problemas.
    return app.exec();
}
