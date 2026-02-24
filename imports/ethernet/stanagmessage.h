// =============================================================================
// stanagmessage.h — Estructura de datos del mensaje STANAG 4586 E4
// =============================================================================
//
// PATRON: Struct C++ plano (Plain Old Data) para modelar un mensaje de protocolo.
//
// ¿Por que un struct y no un QObject?
//   - QObject NO es copiable (copy constructor eliminado). Las senales de Qt
//     pasan argumentos por copia, asi que un QObject no puede ser argumento
//     de senal directamente.
//   - Un struct plano es copiable, ligero, y no tiene overhead de meta-objetos.
//   - No necesitamos signals, slots ni Q_PROPERTY — solo almacenar datos.
//   - Alternativa: Q_GADGET permite introspeccion sin herencia de QObject,
//     pero aqui no lo necesitamos porque la fachada (EthernetController)
//     convierte los datos a tipos simples antes de enviarlos a QML.
//
// FORMATO DE TRAMA (BigEndian / Network Byte Order):
//   +-------------------+-------------------+
//   |  Message ID (u16) |  Source Port (u16) |
//   +-------------------+-------------------+
//   |  Dest Port (u16)  | Sequence Num (u16) |
//   +-------------------+-------------------+
//   | Payload Len (u16) | Presence Mask (u16)|
//   +-------------------+-------------------+
//   |     Payload (longitud variable)        |
//   +-----------------------------------------+
//   |  Checksum (u8 XOR)|
//   +-------------------+
//
// La Presence Mask es un bitmask de 16 bits donde cada bit (0-13) indica
// si un campo de telemetria esta presente en el payload. Los campos
// ausentes no ocupan espacio — el payload es de longitud variable.
// =============================================================================

#ifndef STANAGMESSAGE_H
#define STANAGMESSAGE_H

#include <QByteArray>
#include <QList>
#include <QString>

// =============================================================================
// TAMANO DEL HEADER (en bytes)
// =============================================================================
// El header tiene 6 campos de 2 bytes cada uno = 12 bytes fijos.
// Despues del header viene el payload (variable) y al final 1 byte de checksum.
// =============================================================================
constexpr int kStanagHeaderSize = 12;  // 6 x quint16
constexpr int kStanagMaxFields  = 14;  // Bits 0-13 del presenceMask

// =============================================================================
// StanagField — Un campo individual decodificado del payload
// =============================================================================
// Cada campo tiene un indice (0-13), un nombre legible, los bytes crudos
// y un valor numerico decodificado. El tipo del valor depende de la
// definicion del campo (float, int16, uint16, uint32).
// =============================================================================
struct StanagField
{
    int index = 0;              // Posicion en el bitmask (0-13)
    QString name;               // Nombre legible: "Latitude", "Heading", etc.
    QByteArray rawBytes;        // Bytes crudos de este campo (2 o 4 bytes)
    double value = 0.0;         // Valor numerico decodificado
};

// =============================================================================
// StanagMessage — Mensaje completo STANAG 4586 E4
// =============================================================================
struct StanagMessage
{
    // --- Header (12 bytes, BigEndian) ---
    quint16 messageId    = 0;   // ID del tipo de mensaje STANAG 4586
    quint16 sourcePort   = 0;   // Puerto origen (identifica al emisor)
    quint16 destPort     = 0;   // Puerto destino (identifica al receptor)
    quint16 sequenceNum  = 0;   // Numero de secuencia (orden de mensajes)
    quint16 payloadLen   = 0;   // Longitud del payload en bytes
    quint16 presenceMask = 0;   // Bitmask: bit N = campo N presente

    // --- Payload decodificado ---
    QList<StanagField> fields;  // Solo los campos presentes (segun bitmask)

    // --- Checksum ---
    quint8 checksum      = 0;   // XOR de todos los bytes precedentes
    bool checksumValid   = false;

    // --- Trama cruda completa ---
    QByteArray rawFrame;        // Todos los bytes de la trama (para hex dump)

    // Helper: representacion hexadecimal de la trama completa
    QString hexDump() const
    {
        return QString::fromLatin1(rawFrame.toHex(' ')).toUpper();
    }
};

#endif // STANAGMESSAGE_H
