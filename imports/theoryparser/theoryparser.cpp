#include "theoryparser.h"
#include <QDir>
#include <QFile>
#include <QTextStream>
#include <QVariantMap>
#include <algorithm>

TheoryParser::TheoryParser(QObject *parent)
    : QObject(parent)
{
    scanChapters();
}

void TheoryParser::scanChapters()
{
    QDir theoryDir(QStringLiteral(":/theory"));
    QStringList chapterDirs = theoryDir.entryList(QDir::Dirs | QDir::NoDotAndDotDot);

    std::sort(chapterDirs.begin(), chapterDirs.end(),
              [](const QString &a, const QString &b) {
                  int numA = a.left(a.indexOf('-')).toInt();
                  int numB = b.left(b.indexOf('-')).toInt();
                  return numA < numB;
              });

    for (const QString &chapterDir : chapterDirs) {
        QVariantMap chapter;
        chapter[QStringLiteral("name")] = chapterDir;

        int dashIndex = chapterDir.indexOf('-');
        chapter[QStringLiteral("displayName")] =
            (dashIndex >= 0) ? chapterDir.mid(dashIndex + 1) : chapterDir;

        QDir topicDir(theoryDir.filePath(chapterDir));
        QStringList filters;
        filters << QStringLiteral("*.txt") << QStringLiteral("*.cpp");
        QStringList topicFiles = topicDir.entryList(filters, QDir::Files);
        topicFiles.sort();

        QVariantList topics;
        for (const QString &topicFile : topicFiles) {
            QVariantMap topic;
            topic[QStringLiteral("fileName")] = topicFile;
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

TheoryParser::ParsedContent TheoryParser::parseFile(const QString &resourcePath) const
{
    ParsedContent result;

    QFile file(resourcePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return result;

    QTextStream in(&file);
    QString content = in.readAll();
    file.close();

    const QString explMarker = QStringLiteral("<---EXPLANATION--->");
    const QString filesMarker = QStringLiteral("<---FILES--->");

    int explStart = content.indexOf(explMarker);
    if (explStart < 0) {
        // No EXPLANATION marker — treat whole file as content (e.g. .cpp files)
        result.explanation = content;
        return result;
    }

    explStart += explMarker.length();
    int filesStart = content.indexOf(filesMarker, explStart);

    if (filesStart < 0) {
        // No FILES section — everything after EXPLANATION is the explanation
        result.explanation = content.mid(explStart).trimmed();
        return result;
    }

    result.explanation = content.mid(explStart, filesStart - explStart).trimmed();

    // Extract FILES index
    int filesContentStart = filesStart + filesMarker.length();
    int nextMarkerAfterFiles = content.indexOf(QStringLiteral("<---"), filesContentStart);
    QString filesSection;
    if (nextMarkerAfterFiles >= 0)
        filesSection = content.mid(filesContentStart, nextMarkerAfterFiles - filesContentStart).trimmed();
    else
        filesSection = content.mid(filesContentStart).trimmed();

    // Collect section names (skip "Result" entries)
    const QStringList fileNames = filesSection.split('\n', Qt::SkipEmptyParts);
    QStringList sectionNames;
    for (const QString &name : fileNames) {
        QString trimmed = name.trimmed();
        if (!trimmed.isEmpty() && !trimmed.endsWith(QStringLiteral("Result")))
            sectionNames.append(trimmed);
    }

    // Extract code sections
    for (const QString &sectionName : sectionNames) {
        QString startTag = QStringLiteral("<---") + sectionName + QStringLiteral("--->");
        QString resultTag = QStringLiteral("<---") + sectionName + QStringLiteral(" Result--->");

        int codeStart = content.indexOf(startTag);
        if (codeStart < 0)
            continue;
        codeStart += startTag.length();

        // Find end — either the Result tag or the next <--- marker
        int codeEnd = content.indexOf(resultTag, codeStart);
        if (codeEnd < 0)
            codeEnd = content.indexOf(QStringLiteral("<---"), codeStart);

        QString code;
        if (codeEnd >= 0)
            code = content.mid(codeStart, codeEnd - codeStart).trimmed();
        else
            code = content.mid(codeStart).trimmed();

        // Extract result if available
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

QString TheoryParser::getExplanation(const QString &chapterDir, const QString &topicFile) const
{
    QString path = QStringLiteral(":/theory/%1/%2").arg(chapterDir, topicFile);

    if (!m_cache.contains(path))
        m_cache[path] = parseFile(path);

    return m_cache[path].explanation;
}

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
