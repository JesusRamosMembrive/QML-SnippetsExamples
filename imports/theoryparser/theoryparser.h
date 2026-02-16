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

    Q_PROPERTY(QVariantList chapters READ chapters CONSTANT)

public:
    explicit TheoryParser(QObject *parent = nullptr);

    QVariantList chapters() const;

    Q_INVOKABLE QString getExplanation(const QString &chapterDir, const QString &topicFile) const;
    Q_INVOKABLE QVariantList getCodeSections(const QString &chapterDir, const QString &topicFile) const;

private:
    struct CodeSection {
        QString title;
        QString code;
        QString result;
    };

    struct ParsedContent {
        QString explanation;
        QList<CodeSection> codeSections;
    };

    ParsedContent parseFile(const QString &resourcePath) const;
    void scanChapters();

    QVariantList m_chapters;
    mutable QHash<QString, ParsedContent> m_cache;
};

#endif // THEORYPARSER_H
