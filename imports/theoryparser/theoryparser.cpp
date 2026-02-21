// =============================================================================
// TheoryParser - Implementacion del parseador de teoria
// =============================================================================
//
// Flujo de uso:
//   1. Al instanciar TheoryParser, el constructor llama a scanChapters()
//   2. scanChapters() recorre :/theory/ y construye la lista de capitulos/temas
//   3. QML lee la propiedad 'chapters' para mostrar el indice de navegacion
//   4. Cuando el usuario selecciona un tema, QML llama a getExplanation()
//      y getCodeSections() para obtener el contenido parseado
//   5. El resultado se cachea para evitar re-parsear en lecturas sucesivas
//
// Sistema de recursos Qt (QRC):
//   Los archivos bajo ":/..." estan compilados dentro del ejecutable.
//   Se acceden con QFile(":/ruta") igual que archivos normales, pero:
//   - Siempre estan disponibles (no dependen del filesystem)
//   - Son de solo lectura
//   - Se comprimen automaticamente en el binario
//   QDir(":/theory") lista directorios dentro de los recursos.
//
// Formato de marcadores:
//   El parser busca etiquetas delimitadoras con formato <---NOMBRE--->.
//   Es un formato propio de esta aplicacion, no un estandar.
//   La seccion EXPLANATION contiene texto libre, FILES lista los nombres
//   de secciones de codigo, y cada seccion tiene opcionalmente un Result.
// =============================================================================

#include "theoryparser.h"
#include <QDir>
#include <QFile>
#include <QTextStream>
#include <QVariantMap>
#include <QRegularExpression>
#include <algorithm>

TheoryParser::TheoryParser(QObject *parent)
    : QObject(parent)
{
    scanChapters();
}

// scanChapters - Descubre la estructura de capitulos y temas
//
// Recorre :/theory/ buscando subdirectorios (capitulos) y dentro de cada
// uno, archivos .txt y .cpp (temas).
//
// Los directorios siguen la convencion "NN-Nombre" (ej: "01-Introduccion")
// donde NN es un numero para ordenacion. Se extrae el numero antes del
// primer guion para ordenar los capitulos numericamente.
//
// Cada capitulo se convierte en un QVariantMap con:
//   - name: nombre completo del directorio ("01-Introduccion")
//   - displayName: nombre sin el prefijo numerico ("Introduccion")
//   - topics: QVariantList de {fileName, displayName} para cada archivo
void TheoryParser::scanChapters()
{
    QDir theoryDir(QStringLiteral(":/theory"));
    QStringList chapterDirs = theoryDir.entryList(QDir::Dirs | QDir::NoDotAndDotDot);

    // Ordenar capitulos por el numero antes del guion (01-, 02-, etc.)
    std::sort(chapterDirs.begin(), chapterDirs.end(),
              [](const QString &a, const QString &b) {
                  int numA = a.left(a.indexOf('-')).toInt();
                  int numB = b.left(b.indexOf('-')).toInt();
                  return numA < numB;
              });

    for (const QString &chapterDir : chapterDirs) {
        QVariantMap chapter;
        chapter[QStringLiteral("name")] = chapterDir;

        // Extraer nombre legible: todo despues del primer guion
        int dashIndex = chapterDir.indexOf('-');
        chapter[QStringLiteral("displayName")] =
            (dashIndex >= 0) ? chapterDir.mid(dashIndex + 1) : chapterDir;

        // Listar archivos de temas (.txt y .cpp) dentro del capitulo
        QDir topicDir(theoryDir.filePath(chapterDir));
        QStringList filters;
        filters << QStringLiteral("*.txt") << QStringLiteral("*.cpp");
        QStringList topicFiles = topicDir.entryList(filters, QDir::Files);
        topicFiles.sort();

        QVariantList topics;
        for (const QString &topicFile : topicFiles) {
            QVariantMap topic;
            topic[QStringLiteral("fileName")] = topicFile;
            // displayName: quita la extension del archivo
            QString displayName = topicFile.left(topicFile.lastIndexOf('.'));
            topic[QStringLiteral("displayName")] = displayName;
            topics.append(topic);
        }

        chapter[QStringLiteral("topics")] = topics;
        m_chapters.append(chapter);
    }
}

QVariantList TheoryParser::chapters() const
{
    return m_chapters;
}

// parseFile - Parsea un archivo de teoria usando los marcadores delimitadores
//
// Formato esperado:
//   <---EXPLANATION--->    -> Inicio del texto explicativo
//   <---FILES--->          -> Lista de nombres de secciones de codigo
//   <---NombreSeccion--->  -> Inicio del codigo de esa seccion
//   <---NombreSeccion Result---> -> Resultado esperado de esa seccion
//
// El parser es tolerante:
//   - Si no hay marcador EXPLANATION, todo el archivo es "explicacion"
//     (util para archivos .cpp que son codigo puro)
//   - Si no hay marcador FILES, solo hay explicacion sin secciones de codigo
//   - Las entradas "NombreSeccion Result" en FILES se ignoran (se procesan
//     automaticamente al encontrar la seccion correspondiente)
TheoryParser::ParsedContent TheoryParser::parseFile(const QString &resourcePath) const
{
    ParsedContent result;

    QFile file(resourcePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return result;

    QTextStream in(&file);
    QString content = in.readAll();
    file.close();

    // Buscar marcadores principales
    const QString explMarker = QStringLiteral("<---EXPLANATION--->");
    const QString filesMarker = QStringLiteral("<---FILES--->");

    int explStart = content.indexOf(explMarker);
    if (explStart < 0) {
        // Sin marcador EXPLANATION: todo el contenido es la explicacion
        result.explanation = content;
        return result;
    }

    explStart += explMarker.length();
    int filesStart = content.indexOf(filesMarker, explStart);

    if (filesStart < 0) {
        // Sin seccion FILES: todo despues de EXPLANATION es explicacion
        result.explanation = content.mid(explStart).trimmed();
        return result;
    }

    // Extraer texto explicativo (entre EXPLANATION y FILES)
    result.explanation = content.mid(explStart, filesStart - explStart).trimmed();

    // --- Parsear indice de secciones de FILES ---
    int filesContentStart = filesStart + filesMarker.length();
    int nextMarkerAfterFiles = content.indexOf(QStringLiteral("<---"), filesContentStart);
    QString filesSection;
    if (nextMarkerAfterFiles >= 0)
        filesSection = content.mid(filesContentStart, nextMarkerAfterFiles - filesContentStart).trimmed();
    else
        filesSection = content.mid(filesContentStart).trimmed();

    // Filtrar nombres de secciones: ignorar las entradas "Result"
    // (se procesan automaticamente al buscar el codigo)
    const QStringList fileNames = filesSection.split('\n', Qt::SkipEmptyParts);
    QStringList sectionNames;
    for (const QString &name : fileNames) {
        QString trimmed = name.trimmed();
        if (!trimmed.isEmpty() && !trimmed.endsWith(QStringLiteral("Result")))
            sectionNames.append(trimmed);
    }

    // --- Extraer codigo y resultado de cada seccion ---
    for (const QString &sectionName : sectionNames) {
        // Construir etiquetas de busqueda dinamicamente
        QString startTag = QStringLiteral("<---") + sectionName + QStringLiteral("--->");
        QString resultTag = QStringLiteral("<---") + sectionName + QStringLiteral(" Result--->");

        int codeStart = content.indexOf(startTag);
        if (codeStart < 0)
            continue;
        codeStart += startTag.length();

        // El codigo termina donde empieza el Result o el siguiente marcador
        int codeEnd = content.indexOf(resultTag, codeStart);
        if (codeEnd < 0)
            codeEnd = content.indexOf(QStringLiteral("<---"), codeStart);

        QString code;
        if (codeEnd >= 0)
            code = content.mid(codeStart, codeEnd - codeStart).trimmed();
        else
            code = content.mid(codeStart).trimmed();

        // Extraer resultado si existe la etiqueta "NombreSeccion Result"
        QString resultText;
        int resultStart = content.indexOf(resultTag);
        if (resultStart >= 0) {
            resultStart += resultTag.length();
            int resultEnd = content.indexOf(QStringLiteral("<---"), resultStart);
            if (resultEnd >= 0)
                resultText = content.mid(resultStart, resultEnd - resultStart).trimmed();
            else
                resultText = content.mid(resultStart).trimmed();
        }

        result.codeSections.append({sectionName, code, resultText});
    }

    return result;
}

// getExplanation - Devuelve el texto explicativo de un tema
//
// Construye la ruta de recursos ":/theory/capitulo/tema.txt" y usa el cache.
// Si el archivo ya fue parseado, devuelve el resultado cacheado directamente.
// Si no, lo parsea y lo guarda en cache para futuras llamadas.
QString TheoryParser::getExplanation(const QString &chapterDir, const QString &topicFile) const
{
    QString path = QStringLiteral(":/theory/%1/%2").arg(chapterDir, topicFile);

    if (!m_cache.contains(path))
        m_cache[path] = parseFile(path);

    return m_cache[path].explanation;
}

// getCodeSections - Devuelve las secciones de codigo como QVariantList
//
// Convierte la lista interna de CodeSection a QVariantList de QVariantMap,
// que QML puede consumir directamente como un array de objetos JavaScript:
//   [{ title: "...", code: "...", result: "..." }, ...]
//
// Esta conversion es necesaria porque QML no puede acceder a structs C++
// directamente. QVariantMap es el tipo puente estandar.
QVariantList TheoryParser::getCodeSections(const QString &chapterDir, const QString &topicFile) const
{
    QString path = QStringLiteral(":/theory/%1/%2").arg(chapterDir, topicFile);

    if (!m_cache.contains(path))
        m_cache[path] = parseFile(path);

    QVariantList sections;
    for (const auto &section : m_cache[path].codeSections) {
        QVariantMap map;
        map[QStringLiteral("title")] = section.title;
        map[QStringLiteral("code")] = section.code;
        map[QStringLiteral("result")] = section.result;
        sections.append(map);
    }

    return sections;
}

// getExplanationHtml - Devuelve la explicacion como HTML estilizado
//
// Obtiene el markdown raw del cache y lo convierte a HTML con estilos
// inline. Los colores se reciben desde QML para respetar el tema activo.
QString TheoryParser::getExplanationHtml(const QString &chapterDir, const QString &topicFile,
                                         const QString &accentColor, const QString &textColor,
                                         const QString &secondaryColor, const QString &codeBgColor) const
{
    QString path = QStringLiteral(":/theory/%1/%2").arg(chapterDir, topicFile);

    if (!m_cache.contains(path))
        m_cache[path] = parseFile(path);

    return markdownToHtml(m_cache[path].explanation, accentColor, textColor,
                          secondaryColor, codeBgColor);
}

// processInlineFormatting - Procesa formato inline en una linea de texto
//
// Orden de procesamiento:
//   1. Escapar HTML (&, <, >) para que codigo C++ no rompa el HTML
//   2. Reemplazar `codigo` por <span> estilizado con fondo oscuro
//   3. Reemplazar **negrita** por <b>
QString TheoryParser::processInlineFormatting(const QString &text, const QString &codeBgColor) const
{
    QString result = text;

    // 1. Escapar entidades HTML (antes de insertar tags propios)
    result.replace(QLatin1Char('&'), QStringLiteral("&amp;"));
    result.replace(QLatin1Char('<'), QStringLiteral("&lt;"));
    result.replace(QLatin1Char('>'), QStringLiteral("&gt;"));

    // 2. Codigo inline: `texto` → <span> con fondo oscuro y fuente monospace
    static const QRegularExpression codeRe(QStringLiteral("`([^`]+)`"));
    result.replace(codeRe,
        QStringLiteral("<span style=\"background-color:%1; font-family:Consolas; "
                       "font-size:13px; color:#D4D4D4;\">\\1</span>")
            .arg(codeBgColor));

    // 3. Negrita: **texto** → <b>texto</b>
    static const QRegularExpression boldRe(QStringLiteral("\\*\\*(.+?)\\*\\*"));
    result.replace(boldRe, QStringLiteral("<b>\\1</b>"));

    return result;
}

// markdownToHtml - Convierte Markdown a HTML con estilos inline
//
// Recorre el texto linea por linea identificando:
//   - Bloques de codigo (```...```): se escapan literalmente, sin formato inline
//   - Headers (###, ####, #####): color accent, tamaños diferentes
//   - Listas (- item): bullet point en color accent con indentacion
//   - Blockquotes (> texto): borde izquierdo accent, texto en gris italica
//   - Parrafos normales: color texto primario
//
// Cada elemento recibe estilos CSS inline porque QTextDocument (usado por
// TextEdit.RichText en QML) no soporta CSS externo ni clases.
QString TheoryParser::markdownToHtml(const QString &markdown, const QString &accentColor,
                                     const QString &textColor, const QString &secondaryColor,
                                     const QString &codeBgColor) const
{
    const QStringList lines = markdown.split(QLatin1Char('\n'));
    QString html;
    bool inCodeBlock = false;
    QString codeBuffer;

    for (const QString &line : lines) {
        const QString trimmed = line.trimmed();

        // --- Bloques de codigo delimitados por ``` ---
        if (trimmed.startsWith(QStringLiteral("```"))) {
            if (inCodeBlock) {
                // Cerrar bloque: escapar HTML y envolver en <pre>
                QString escaped = codeBuffer;
                escaped.replace(QLatin1Char('&'), QStringLiteral("&amp;"));
                escaped.replace(QLatin1Char('<'), QStringLiteral("&lt;"));
                escaped.replace(QLatin1Char('>'), QStringLiteral("&gt;"));
                if (escaped.endsWith(QLatin1Char('\n')))
                    escaped.chop(1);

                html += QStringLiteral(
                    "<pre style=\"background-color:%1; padding:12px; "
                    "font-family:Consolas; font-size:13px; color:#D4D4D4; "
                    "margin-top:8px; margin-bottom:8px;\">%2</pre>")
                    .arg(codeBgColor, escaped);

                codeBuffer.clear();
                inCodeBlock = false;
            } else {
                inCodeBlock = true;
            }
            continue;
        }

        if (inCodeBlock) {
            codeBuffer += line + QLatin1Char('\n');
            continue;
        }

        // --- Linea vacia: espaciador ---
        if (trimmed.isEmpty()) {
            html += QStringLiteral("<br/>");
            continue;
        }

        // --- Headers (verificar prefijos largos primero) ---
        if (trimmed.startsWith(QStringLiteral("##### "))) {
            QString content = processInlineFormatting(trimmed.mid(6), codeBgColor);
            html += QStringLiteral(
                "<h5 style=\"color:%1; font-size:15px; "
                "margin-top:16px; margin-bottom:4px;\">%2</h5>")
                .arg(accentColor, content);
        }
        else if (trimmed.startsWith(QStringLiteral("#### "))) {
            QString content = processInlineFormatting(trimmed.mid(5), codeBgColor);
            html += QStringLiteral(
                "<h4 style=\"color:%1; font-size:17px; "
                "margin-top:20px; margin-bottom:6px;\">%2</h4>")
                .arg(accentColor, content);
        }
        else if (trimmed.startsWith(QStringLiteral("### "))) {
            QString content = processInlineFormatting(trimmed.mid(4), codeBgColor);
            html += QStringLiteral(
                "<h3 style=\"color:%1; font-size:20px; "
                "margin-top:24px; margin-bottom:8px;\">%2</h3>")
                .arg(accentColor, content);
        }
        // --- Blockquote ---
        else if (trimmed.startsWith(QStringLiteral("> "))) {
            QString content = processInlineFormatting(trimmed.mid(2), codeBgColor);
            html += QStringLiteral(
                "<p style=\"color:%1; font-style:italic; margin-left:16px; "
                "margin-top:4px; margin-bottom:4px; "
                "border-left-width:3px; border-left-style:solid; "
                "border-left-color:%2; padding-left:12px;\">%3</p>")
                .arg(secondaryColor, accentColor, content);
        }
        // --- Lista: lineas que empiezan con "- " (posible indentacion) ---
        else if (trimmed.startsWith(QStringLiteral("- "))) {
            // Calcular indentacion: posicion del '-' en la linea original
            int dashPos = line.indexOf(QLatin1Char('-'));
            int marginLeft = 16 + (dashPos / 2) * 16;
            QString content = processInlineFormatting(trimmed.mid(2), codeBgColor);
            html += QStringLiteral(
                "<p style=\"color:%1; margin-left:%2px; "
                "margin-top:2px; margin-bottom:2px;\">"
                "<span style=\"color:%3;\">&#8226; </span>%4</p>")
                .arg(textColor).arg(marginLeft).arg(accentColor, content);
        }
        // --- Parrafo regular ---
        else {
            QString content = processInlineFormatting(trimmed, codeBgColor);
            html += QStringLiteral(
                "<p style=\"color:%1; margin-top:4px; margin-bottom:4px;\">%2</p>")
                .arg(textColor, content);
        }
    }

    return html;
}
