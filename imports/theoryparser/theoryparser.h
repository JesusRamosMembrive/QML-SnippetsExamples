// =============================================================================
// TheoryParser - Parseador de contenido teorico desde recursos Qt
// =============================================================================
//
// Esta clase lee archivos de teoria embebidos en los recursos de la aplicacion
// (directorio :/theory/) y los expone a QML de forma estructurada.
//
// Estructura de directorios en recursos:
//   :/theory/
//     01-Introduccion/
//       Variables.txt
//       Funciones.txt
//     02-POO/
//       Clases.cpp
//       Herencia.txt
//
// Formato de los archivos de teoria (marcadores):
//   <---EXPLANATION--->
//   Texto explicativo del tema...
//
//   <---FILES--->
//   NombreSeccion1
//   NombreSeccion1 Result
//   NombreSeccion2
//
//   <---NombreSeccion1--->
//   // codigo de ejemplo aqui...
//
//   <---NombreSeccion1 Result--->
//   // salida esperada del codigo...
//
// Si un archivo no tiene marcadores, todo el contenido se trata como
// explicacion (util para archivos .cpp que son codigo puro).
//
// Arquitectura:
//   - scanChapters(): en el constructor, escanea :/theory/ y construye
//     la lista de capitulos y temas (QVariantList para facil consumo en QML).
//   - parseFile(): parsea un archivo individual extrayendo explicacion,
//     secciones de codigo y resultados.
//   - Cache con QHash: evita parsear el mismo archivo multiples veces.
//     La primera lectura lo parsea y guarda en m_cache; las siguientes
//     devuelven el resultado cacheado.
//
// QVariantList/QVariantMap: tipos "puente" entre C++ y QML.
//   QVariantMap se convierte automaticamente a un objeto JavaScript en QML,
//   y QVariantList a un array JavaScript. Es la forma estandar de pasar
//   datos estructurados de C++ a QML sin definir modelos completos.
// =============================================================================

#ifndef THEORYPARSER_H
#define THEORYPARSER_H

#include <QObject>
#include <QtQml/qqmlregistration.h>
#include <QVariantList>
#include <QHash>

class TheoryParser : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    // CONSTANT: la lista de capitulos se genera una vez en el constructor
    // y no cambia despues. QML no necesita signal de cambio.
    Q_PROPERTY(QVariantList chapters READ chapters CONSTANT)

public:
    explicit TheoryParser(QObject *parent = nullptr);

    QVariantList chapters() const;

    // getExplanation: devuelve el texto explicativo de un tema especifico.
    // Parametros: directorio del capitulo + nombre del archivo del tema.
    Q_INVOKABLE QString getExplanation(const QString &chapterDir, const QString &topicFile) const;

    // getExplanationHtml: devuelve la explicacion convertida a HTML con
    // estilos inline. Los colores se pasan desde QML para respetar el tema.
    Q_INVOKABLE QString getExplanationHtml(const QString &chapterDir, const QString &topicFile,
                                           const QString &accentColor, const QString &textColor,
                                           const QString &secondaryColor, const QString &codeBgColor) const;

    // getCodeSections: devuelve las secciones de codigo como QVariantList
    // donde cada elemento es un QVariantMap con {title, code, result}.
    Q_INVOKABLE QVariantList getCodeSections(const QString &chapterDir, const QString &topicFile) const;

private:
    // Convierte markdown a HTML con estilos inline para renderizar en QML RichText
    QString markdownToHtml(const QString &markdown, const QString &accentColor,
                           const QString &textColor, const QString &secondaryColor,
                           const QString &codeBgColor) const;

    // Procesa formato inline: **bold**, `code`, escapa HTML
    QString processInlineFormatting(const QString &text, const QString &codeBgColor) const;
    // Estructura interna para una seccion de codigo parseada
    struct CodeSection {
        QString title;   // Nombre de la seccion (ej: "NombreSeccion1")
        QString code;    // Codigo fuente de ejemplo
        QString result;  // Resultado esperado (puede estar vacio)
    };

    // Contenido completo parseado de un archivo
    struct ParsedContent {
        QString explanation;          // Texto entre <---EXPLANATION---> y <---FILES--->
        QList<CodeSection> codeSections; // Lista de secciones de codigo
    };

    // Parsea un archivo desde la ruta de recursos y devuelve su contenido estructurado
    ParsedContent parseFile(const QString &resourcePath) const;

    // Escanea el directorio :/theory/ y construye m_chapters
    void scanChapters();

    // Lista de capitulos como QVariantList (cada uno: {name, displayName, topics})
    QVariantList m_chapters;

    // Cache de archivos ya parseados. 'mutable' porque se modifica desde
    // metodos const (getExplanation/getCodeSections). Es un patron comun
    // para caches: el metodo es logicamente const (no cambia el estado
    // observable del objeto) pero modifica el cache internamente.
    mutable QHash<QString, ParsedContent> m_cache;
};

#endif // THEORYPARSER_H
