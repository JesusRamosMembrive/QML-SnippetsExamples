#include "methodbridge.h"
#include <QRegularExpression>

MethodBridge::MethodBridge(QObject *parent) : QObject(parent) {}

// transformText: usa switch de C++ sobre un enum. Desde QML se llama asi:
//   bridge.transformText("hola mundo", MethodBridge.TitleCase)
// Qt convierte automaticamente el enum de QML al valor C++ correspondiente.
QString MethodBridge::transformText(const QString &text, TextTransform mode)
{
    switch (mode) {
    case Uppercase: return text.toUpper();
    case Lowercase: return text.toLower();
    // TitleCase: split -> minusculas cada palabra -> capitalizar primera letra.
    // Demuestra la manipulacion de strings con Qt (split, join, toUpper).
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

// fibonacci: implementacion iterativa O(n), no recursiva O(2^n).
// Demuestra la ventaja de rendimiento de C++ sobre QML/JavaScript
// para computacion intensiva.
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

// validateEmail: usa QRegularExpression con string literal crudo R"(...)".
// El prefijo R permite usar caracteres especiales de regex sin doble escape.
// "static" significa que la regex se compila una sola vez y se reutiliza
// en cada llamada (optimizacion de rendimiento).
bool MethodBridge::validateEmail(const QString &email)
{
    static QRegularExpression re(
        QStringLiteral(R"(^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$)"));
    return re.match(email).hasMatch();
}

// analyzeText retorna QVariantMap: Qt lo auto-convierte a un objeto
// JavaScript en QML. Cada r["clave"] = valor se convierte en una
// propiedad del objeto:
//   var info = bridge.analyzeText("Hola 123");
//   info.length -> 8
//   info.words  -> 2
//   info.vowels -> 2
//   info.digits -> 3
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
