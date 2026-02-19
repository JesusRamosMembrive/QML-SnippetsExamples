// =============================================================================
// SettingsManager - Wrapper C++ sobre QSettings para QML
// =============================================================================
//
// QSettings es el sistema de almacenamiento persistente de Qt. Guarda pares
// clave-valor en la ubicacion nativa de cada plataforma:
//   - Windows: Registro (HKEY_CURRENT_USER\Software\QMLSnippets\Examples)
//   - macOS: ~/Library/Preferences/com.QMLSnippets.Examples.plist
//   - Linux: ~/.config/QMLSnippets/Examples.conf
//
// Este wrapper proporciona dos APIs complementarias:
//
// 1. Propiedades tipadas (Q_PROPERTY):
//    - theme (QString), fontSize (int), notifications (bool), volume (double)...
//    - QML puede hacer binding directo: text: settings.theme
//    - Cada setter verifica si el valor cambio antes de emitir la signal,
//      evitando bucles infinitos de binding.
//
// 2. API generica (Q_INVOKABLE):
//    - setValue("clave", valor) / getValue("clave", valorDefault)
//    - removeKey(), allKeys(), childGroups(), keysInGroup()
//    - Da a QML acceso completo a QSettings sin necesidad de agregar
//      nuevas propiedades por cada configuracion.
//
// Grupos jerarquicos en QSettings:
//   Las claves pueden contener "/" para crear jerarquia:
//     "Preferences/theme"   ->  grupo "Preferences", clave "theme"
//     "RecentFiles/list"    ->  grupo "RecentFiles", clave "list"
//   beginGroup("Preferences") / endGroup() permite operar dentro de un grupo.
//
// QML_ELEMENT: registra la clase automaticamente en el sistema de tipos QML.
// Desde QML se instancia con: SettingsManager { id: settings }
// =============================================================================

#ifndef SETTINGSMANAGER_H
#define SETTINGSMANAGER_H

#include <QObject>
#include <QSettings>
#include <QStringList>
#include <QVariant>
#include <QtQml/qqmlregistration.h>

class SettingsManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    // --- Propiedades tipadas ---
    // Cada una lee/escribe directamente en QSettings con una clave especifica.
    // El valor por defecto se define en el getter (no en QSettings).
    Q_PROPERTY(QString theme READ theme WRITE setTheme NOTIFY themeChanged)
    Q_PROPERTY(int fontSize READ fontSize WRITE setFontSize NOTIFY fontSizeChanged)
    Q_PROPERTY(bool notifications READ notifications WRITE setNotifications NOTIFY notificationsChanged)
    Q_PROPERTY(double volume READ volume WRITE setVolume NOTIFY volumeChanged)
    Q_PROPERTY(QString userName READ userName WRITE setUserName NOTIFY userNameChanged)
    Q_PROPERTY(QStringList recentFiles READ recentFiles NOTIFY recentFilesChanged)

public:
    explicit SettingsManager(QObject *parent = nullptr);

    // Typed property accessors — read/write QSettings directly
    QString theme() const;
    void setTheme(const QString &t);
    int fontSize() const;
    void setFontSize(int s);
    bool notifications() const;
    void setNotifications(bool n);
    double volume() const;
    void setVolume(double v);
    QString userName() const;
    void setUserName(const QString &n);
    QStringList recentFiles() const;

    // --- Helpers para archivos recientes ---
    // Patron tipico: mantener una lista limitada (max 10) con el mas
    // reciente al principio, sin duplicados.
    Q_INVOKABLE void addRecentFile(const QString &file);
    Q_INVOKABLE void clearRecentFiles();

    // --- API generica clave-valor ---
    // Q_INVOKABLE permite llamar estos metodos directamente desde QML:
    //   settings.setValue("miClave", "miValor")
    //   var v = settings.getValue("miClave", "default")
    Q_INVOKABLE void setValue(const QString &key, const QVariant &value);
    Q_INVOKABLE QVariant getValue(const QString &key,
                                  const QVariant &defaultValue = {}) const;
    Q_INVOKABLE void removeKey(const QString &key);

    // allKeys(): devuelve todas las claves almacenadas (con ruta completa)
    Q_INVOKABLE QStringList allKeys() const;

    // childGroups(): devuelve los nombres de los grupos de primer nivel
    // Ejemplo: si hay "Preferences/theme" y "RecentFiles/list",
    // devuelve ["Preferences", "RecentFiles"]
    Q_INVOKABLE QStringList childGroups() const;

    // keysInGroup(): lista las claves dentro de un grupo especifico.
    // Usa beginGroup/endGroup internamente para delimitar el scope.
    Q_INVOKABLE QStringList keysInGroup(const QString &group) const;

    // clearAll(): borra TODAS las configuraciones. Util para "restaurar
    // valores por defecto" en la UI.
    Q_INVOKABLE void clearAll();

    // settingsPath(): devuelve la ruta del archivo donde QSettings guarda los datos.
    // Util para depuracion (saber donde se almacenan fisicamente).
    Q_INVOKABLE QString settingsPath() const;

signals:
    void themeChanged();
    void fontSizeChanged();
    void notificationsChanged();
    void volumeChanged();
    void userNameChanged();
    void recentFilesChanged();
    void keysChanged();

private:
    // 'mutable' porque QSettings::value() no es const en Qt, pero nuestros
    // getters si lo son logicamente. Es un patron comun con QSettings.
    mutable QSettings m_settings;
};

#endif
