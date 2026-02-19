#ifndef METHODBRIDGE_H
#define METHODBRIDGE_H

#include <QObject>
#include <QVariantMap>
#include <QtQml/qqmlregistration.h>

class MethodBridge : public QObject
{
    Q_OBJECT
    QML_ELEMENT

public:
    enum TextTransform {
        Uppercase,
        Lowercase,
        TitleCase,
        Reverse
    };
    Q_ENUM(TextTransform)

    explicit MethodBridge(QObject *parent = nullptr);

    Q_INVOKABLE QString transformText(const QString &text, TextTransform mode);
    Q_INVOKABLE int fibonacci(int n);
    Q_INVOKABLE bool validateEmail(const QString &email);
    Q_INVOKABLE QVariantMap analyzeText(const QString &text);
};

#endif
