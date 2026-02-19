#include "methodbridge.h"
#include <QRegularExpression>

MethodBridge::MethodBridge(QObject *parent) : QObject(parent) {}

QString MethodBridge::transformText(const QString &text, TextTransform mode)
{
    switch (mode) {
    case Uppercase: return text.toUpper();
    case Lowercase: return text.toLower();
    case TitleCase: {
        QStringList words = text.toLower().split(' ');
        for (auto &w : words)
            if (!w.isEmpty()) w[0] = w[0].toUpper();
        return words.join(' ');
    }
    case Reverse: {
        QString r;
        r.reserve(text.size());
        for (int i = text.size() - 1; i >= 0; --i)
            r.append(text[i]);
        return r;
    }
    }
    return text;
}

int MethodBridge::fibonacci(int n)
{
    if (n <= 0) return 0;
    if (n == 1) return 1;
    int a = 0, b = 1;
    for (int i = 2; i <= n; i++) {
        int c = a + b;
        a = b;
        b = c;
    }
    return b;
}

bool MethodBridge::validateEmail(const QString &email)
{
    static QRegularExpression re(
        QStringLiteral(R"(^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$)"));
    return re.match(email).hasMatch();
}

QVariantMap MethodBridge::analyzeText(const QString &text)
{
    QVariantMap r;
    r["length"] = text.length();
    r["words"] = text.split(QRegularExpression("\\s+"), Qt::SkipEmptyParts).count();

    int vowels = 0, digits = 0;
    for (const QChar &ch : text) {
        if (QString("aeiouAEIOU").contains(ch)) vowels++;
        if (ch.isDigit()) digits++;
    }
    r["vowels"] = vowels;
    r["digits"] = digits;
    return r;
}
