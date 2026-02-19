// =============================================================================
// EDUCATIVO: Q_INVOKABLE y Q_ENUM — Llamar metodos C++ desde QML con
// parametros tipados
// =============================================================================
//
// Q_ENUM(TextTransform): registra un enum de C++ con QML. Esto permite que
// QML use: MethodBridge.Uppercase, MethodBridge.Lowercase, etc.
// Sin Q_ENUM, QML veria los valores del enum como enteros simples sin
// seguridad de tipos.
//
// Metodos Q_INVOKABLE: cada uno retorna un valor que QML puede usar
// directamente. Qt auto-convierte entre tipos C++ y QML:
//   QString  <-> string
//   int      <-> int
//   bool     <-> bool
//   QVariantMap <-> objeto JavaScript {}
//
// QVariantMap: el equivalente en C++ de un objeto JavaScript {}.
// Las claves son strings, los valores pueden ser cualquier tipo (int,
// string, bool, etc.). En QML se convierte en un objeto JS normal:
//   var resultado = bridge.analyzeText("hola");
//   resultado.words  -> 1
//   resultado.length -> 4
// =============================================================================

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
