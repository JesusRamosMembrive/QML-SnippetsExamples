// =============================================================================
// SettingsManager - Implementacion del wrapper de QSettings
// =============================================================================
//
// Patron de uso de QSettings en este wrapper:
//   - El constructor crea QSettings con organizacion y aplicacion:
//     QSettings("QMLSnippets", "Examples")
//     Esto determina la ubicacion del almacenamiento persistente.
//
//   - Las claves usan formato "Grupo/Clave" para organizacion jerarquica:
//     "Preferences/theme", "Preferences/fontSize", "RecentFiles/list"
//
//   - Cada getter proporciona un valor por defecto como segundo parametro
//     de m_settings.value(). Si la clave no existe, devuelve ese default.
//
//   - Cada setter compara el valor actual con el nuevo antes de escribir.
//     Solo escribe y emite signal si realmente cambio. Esto evita:
//       a) Escrituras innecesarias a disco/registro
//       b) Bucles infinitos de binding en QML
//
//   - qFuzzyCompare() se usa para comparar doubles porque la comparacion
//     directa con == puede fallar por errores de precision de punto flotante.
// =============================================================================

#include "settingsmanager.h"

// Constructor: inicializa QSettings con nombre de organizacion y aplicacion.
// Esto define donde se guardan los datos:
//   Windows: HKEY_CURRENT_USER\Software\QMLSnippets\Examples
//   Linux:   ~/.config/QMLSnippets/Examples.conf
//   macOS:   ~/Library/Preferences/com.QMLSnippets.Examples.plist
SettingsManager::SettingsManager(QObject *parent)
    : QObject(parent)
    , m_settings("QMLSnippets", "Examples")
{
}

// =============================================================================
// Propiedades tipadas - Cada par getter/setter opera sobre una clave especifica
// =============================================================================
//
// Patron repetido en cada propiedad:
//   Getter: return m_settings.value("Grupo/clave", valorDefault).toTipo();
//   Setter: if (valorActual != nuevoValor) { escribir; emit signal; }

QString SettingsManager::theme() const
{
    return m_settings.value("Preferences/theme", "Dark").toString();
}

void SettingsManager::setTheme(const QString &t)
{
    if (theme() != t) {
        m_settings.setValue("Preferences/theme", t);
        emit themeChanged();
    }
}

int SettingsManager::fontSize() const
{
    return m_settings.value("Preferences/fontSize", 14).toInt();
}

void SettingsManager::setFontSize(int s)
{
    if (fontSize() != s) {
        m_settings.setValue("Preferences/fontSize", s);
        emit fontSizeChanged();
    }
}

bool SettingsManager::notifications() const
{
    return m_settings.value("Preferences/notifications", true).toBool();
}

void SettingsManager::setNotifications(bool n)
{
    if (notifications() != n) {
        m_settings.setValue("Preferences/notifications", n);
        emit notificationsChanged();
    }
}

double SettingsManager::volume() const
{
    return m_settings.value("Preferences/volume", 0.8).toDouble();
}

// Para doubles usamos qFuzzyCompare() en vez de != porque los numeros
// de punto flotante pueden tener errores de precision minusculos.
// Ejemplo: 0.1 + 0.2 != 0.3 en IEEE 754, pero qFuzzyCompare los trata como iguales.
void SettingsManager::setVolume(double v)
{
    if (!qFuzzyCompare(volume(), v)) {
        m_settings.setValue("Preferences/volume", v);
        emit volumeChanged();
    }
}

QString SettingsManager::userName() const
{
    return m_settings.value("Preferences/userName", "User").toString();
}

void SettingsManager::setUserName(const QString &n)
{
    if (userName() != n) {
        m_settings.setValue("Preferences/userName", n);
        emit userNameChanged();
    }
}

// =============================================================================
// Archivos recientes - Lista limitada con deduplicacion
// =============================================================================

// QSettings puede almacenar QStringList directamente como valor.
// Internamente se serializa como una lista separada por comas o
// como multiples entradas indexadas, dependiendo del backend.
QStringList SettingsManager::recentFiles() const
{
    return m_settings.value("RecentFiles/list").toStringList();
}

// addRecentFile: agrega un archivo al principio de la lista.
// Si ya existia, lo mueve al principio (removeAll + prepend).
// Limita la lista a 10 elementos maximo para no crecer indefinidamente.
void SettingsManager::addRecentFile(const QString &file)
{
    QStringList files = recentFiles();
    files.removeAll(file);
    files.prepend(file);
    if (files.size() > 10)
        files = files.mid(0, 10);
    m_settings.setValue("RecentFiles/list", files);
    emit recentFilesChanged();
}

void SettingsManager::clearRecentFiles()
{
    m_settings.remove("RecentFiles/list");
    emit recentFilesChanged();
}

// =============================================================================
// API generica clave-valor
// =============================================================================
//
// Estos metodos Q_INVOKABLE dan a QML acceso completo a QSettings sin
// necesidad de definir nuevas Q_PROPERTY por cada configuracion.
// QVariant actua como contenedor universal: acepta QString, int, bool,
// double, QStringList, etc. QML convierte automaticamente entre
// tipos JavaScript y QVariant.

void SettingsManager::setValue(const QString &key, const QVariant &value)
{
    m_settings.setValue(key, value);
    emit keysChanged();
}

QVariant SettingsManager::getValue(const QString &key,
                                   const QVariant &defaultValue) const
{
    return m_settings.value(key, defaultValue);
}

void SettingsManager::removeKey(const QString &key)
{
    m_settings.remove(key);
    emit keysChanged();
}

QStringList SettingsManager::allKeys() const
{
    return m_settings.allKeys();
}

QStringList SettingsManager::childGroups() const
{
    return m_settings.childGroups();
}

// keysInGroup: usa beginGroup/endGroup para delimitar el scope.
// beginGroup("Preferences") hace que childKeys() solo devuelva las claves
// dentro de ese grupo (sin el prefijo "Preferences/").
// endGroup() restaura el scope original. Es como un "cd" temporal.
QStringList SettingsManager::keysInGroup(const QString &group) const
{
    m_settings.beginGroup(group);
    QStringList keys = m_settings.childKeys();
    m_settings.endGroup();
    return keys;
}

// clearAll: borra todas las configuraciones y emite TODAS las signals
// de cambio para que QML actualice todos los bindings a los valores
// por defecto (que se definen en cada getter).
void SettingsManager::clearAll()
{
    m_settings.clear();
    emit themeChanged();
    emit fontSizeChanged();
    emit notificationsChanged();
    emit volumeChanged();
    emit userNameChanged();
    emit recentFilesChanged();
    emit keysChanged();
}

// settingsPath: devuelve la ruta fisica del archivo de configuracion.
// Util para depuracion: el usuario puede verificar donde se guardan
// los datos y editarlos manualmente si es necesario.
QString SettingsManager::settingsPath() const
{
    return m_settings.fileName();
}
