// =============================================================================
// stanagcodec.cpp — Implementacion de la serializacion STANAG 4586
// =============================================================================
//
// Este archivo contiene la logica central de serializacion/deserializacion.
// Usa QDataStream para escribir/leer datos en formato BigEndian (network
// byte order), que es el estandar en protocolos de comunicacion.
//
// CONCEPTOS CLAVE:
//
// 1. BIGENDIAN vs LITTLEENDIAN
//    - BigEndian: el byte mas significativo va primero. Es el estandar de red
//      (tambien llamado "network byte order"). Ejemplo: 0x1234 se almacena
//      como [0x12, 0x34].
//    - LittleEndian: el byte menos significativo va primero. Es el formato
//      nativo de x86/x64. Ejemplo: 0x1234 se almacena como [0x34, 0x12].
//    - Los protocolos de red usan BigEndian por convencion historica (RFC 1700).
//
// 2. QDATASTREAM
//    - Clase de Qt para lectura/escritura binaria secuencial.
//    - setByteOrder(QDataStream::BigEndian) asegura que todos los operadores
//      << y >> hacen la conversion de byte order automaticamente.
//    - Maneja tipos primitivos (quint16, float, etc.) y tipos Qt (QString...).
//    - El "stream" avanza automaticamente al escribir/leer — no necesitamos
//      gestionar offsets manualmente.
//
// 3. BITMASK (MASCARA DE BITS)
//    - Un entero donde cada bit individual tiene significado propio.
//    - Para verificar si el bit N esta activo: (mask & (1 << N)) != 0
//    - Para activar el bit N: mask |= (1 << N)
//    - Patron muy comun en protocolos: indica presencia/ausencia de campos
//      opcionales sin desperdiciar bytes enteros por cada flag.
// =============================================================================

#include "stanagcodec.h"
#include <QDataStream>
#include <QIODevice>
#include <QtEndian>

// =============================================================================
// fieldDefinitions() — Tabla estatica de los 14 campos
// =============================================================================
// La variable "static const" se inicializa una sola vez y persiste durante
// toda la ejecucion del programa. Devolver una referencia evita copias.
//
// Los tamanos de campo (2 o 4 bytes) determinan cuantos bytes se leen/escriben
// del payload por cada campo presente.
// =============================================================================
const QList<FieldDef> &StanagCodec::fieldDefinitions()
{
    static const QList<FieldDef> defs = {
        { QStringLiteral("Latitude"),        4 },  // Bit 0:  float32  (-90 a 90)
        { QStringLiteral("Longitude"),       4 },  // Bit 1:  float32  (-180 a 180)
        { QStringLiteral("Altitude"),        2 },  // Bit 2:  int16    (metros)
        { QStringLiteral("Heading"),         2 },  // Bit 3:  uint16   (0-359 grados)
        { QStringLiteral("Speed"),           2 },  // Bit 4:  uint16   (km/h)
        { QStringLiteral("Roll"),            2 },  // Bit 5:  int16    (-180 a 180)
        { QStringLiteral("Pitch"),           2 },  // Bit 6:  int16    (-90 a 90)
        { QStringLiteral("Yaw"),             2 },  // Bit 7:  int16    (-180 a 180)
        { QStringLiteral("Fuel Level"),      2 },  // Bit 8:  uint16   (porcentaje)
        { QStringLiteral("Engine RPM"),      2 },  // Bit 9:  uint16   (RPM)
        { QStringLiteral("Battery Voltage"), 2 },  // Bit 10: uint16   (mV)
        { QStringLiteral("Sensor Status"),   2 },  // Bit 11: uint16   (flags)
        { QStringLiteral("Waypoint Index"),  2 },  // Bit 12: uint16   (indice)
        { QStringLiteral("Mission Time"),    4 },  // Bit 13: uint32   (segundos)
    };
    return defs;
}

// =============================================================================
// computeChecksum() — XOR acumulativo de todos los bytes
// =============================================================================
// Algoritmo:
//   1. Empezar con resultado = 0
//   2. Por cada byte del buffer: resultado ^= byte
//   3. El resultado final es el checksum
//
// Es el checksum mas simple posible. Detecta cualquier error de 1 bit,
// pero no detecta intercambios de bytes ni errores de cantidad par de bits.
//
// static_cast<quint8>: asegura que trabajamos con bytes sin signo (0-255).
// El tipo "char" de QByteArray puede ser signed en algunas plataformas,
// lo que causaria problemas con el XOR si no hacemos el cast.
// =============================================================================
quint8 StanagCodec::computeChecksum(const QByteArray &data)
{
    quint8 result = 0;
    for (char byte : data)
        result ^= static_cast<quint8>(byte);
    return result;
}

// =============================================================================
// encodePayload() — Empaquetar campos presentes en bytes BigEndian
// =============================================================================
// Recorre los 14 bits del presenceMask. Por cada bit activo, busca el campo
// correspondiente en msg.fields y escribe su valor en BigEndian.
//
// TIPOS DE CAMPO:
//   - 4 bytes: float (campos 0,1) o uint32 (campo 13)
//   - 2 bytes: int16 (campos 2,5,6,7) o uint16 (campos 3,4,8-12)
//
// La conversion de tipos se basa en el indice del campo:
//   - Indices 0,1 → float (latitud/longitud son punto flotante)
//   - Indice 13 → uint32 (mission time es un timestamp grande)
//   - Indices 2,5,6,7 → int16 (valores que pueden ser negativos)
//   - Resto → uint16 (valores siempre positivos)
//
// QDataStream::setFloatingPointPrecision(SinglePrecision):
//   Por defecto QDataStream escribe doubles (8 bytes). Necesitamos floats
//   (4 bytes) para Latitude y Longitude, asi que cambiamos la precision.
// =============================================================================
QByteArray StanagCodec::encodePayload(const StanagMessage &msg)
{
    QByteArray payload;
    QDataStream stream(&payload, QIODevice::WriteOnly);
    stream.setByteOrder(QDataStream::BigEndian);
    stream.setFloatingPointPrecision(QDataStream::SinglePrecision);

    const auto &defs = fieldDefinitions();

    for (int i = 0; i < kStanagMaxFields; ++i) {
        // --- Verificar si el bit i esta activo en el presenceMask ---
        // (1 << i) crea una mascara con solo el bit i encendido.
        // El AND (&) devuelve 0 si el bit esta apagado, o no-cero si esta activo.
        if (!(msg.presenceMask & (1 << i)))
            continue;  // Este campo no esta presente, saltar

        // Buscar el valor del campo en la lista de campos del mensaje
        double value = 0.0;
        for (const auto &field : msg.fields) {
            if (field.index == i) {
                value = field.value;
                break;
            }
        }

        // Escribir el valor segun el tipo de campo
        if (defs[i].sizeBytes == 4) {
            if (i == 0 || i == 1) {
                // Latitude/Longitude: float32
                stream << static_cast<float>(value);
            } else {
                // Mission Time: uint32
                stream << static_cast<quint32>(value);
            }
        } else {
            // Campos de 2 bytes
            if (i == 2 || i == 5 || i == 6 || i == 7) {
                // Altitude, Roll, Pitch, Yaw: int16 (pueden ser negativos)
                stream << static_cast<qint16>(value);
            } else {
                // Heading, Speed, Fuel, RPM, Battery, Sensor, Waypoint: uint16
                stream << static_cast<quint16>(value);
            }
        }
    }

    return payload;
}

// =============================================================================
// decodePayload() — Desempaquetar campos del payload BigEndian
// =============================================================================
// El proceso es el inverso de encodePayload():
//   1. Recorrer los 14 bits del presenceMask
//   2. Por cada bit activo, leer la cantidad de bytes correspondiente
//   3. Decodificar al tipo numerico apropiado
//   4. Guardar el campo decodificado con su nombre e indice
//
// IMPORTANTE: Los campos se leen en ORDEN de bit (0, 1, 2, ...).
// El emisor y el receptor deben usar la misma tabla de definiciones
// para que el payload se interprete correctamente.
// =============================================================================
QList<StanagField> StanagCodec::decodePayload(const QByteArray &payload,
                                              quint16 presenceMask)
{
    QList<StanagField> fields;
    QDataStream stream(payload);
    stream.setByteOrder(QDataStream::BigEndian);
    stream.setFloatingPointPrecision(QDataStream::SinglePrecision);

    const auto &defs = fieldDefinitions();

    for (int i = 0; i < kStanagMaxFields; ++i) {
        if (!(presenceMask & (1 << i)))
            continue;

        StanagField field;
        field.index = i;
        field.name = defs[i].name;

        // Extraer los bytes crudos para mostrar en el hex dump
        int fieldSize = defs[i].sizeBytes;
        int pos = stream.device()->pos();
        field.rawBytes = payload.mid(pos, fieldSize);

        // Decodificar el valor segun el tipo
        if (fieldSize == 4) {
            if (i == 0 || i == 1) {
                float fval = 0.0f;
                stream >> fval;
                field.value = static_cast<double>(fval);
            } else {
                quint32 u32 = 0;
                stream >> u32;
                field.value = static_cast<double>(u32);
            }
        } else {
            if (i == 2 || i == 5 || i == 6 || i == 7) {
                qint16 s16 = 0;
                stream >> s16;
                field.value = static_cast<double>(s16);
            } else {
                quint16 u16 = 0;
                stream >> u16;
                field.value = static_cast<double>(u16);
            }
        }

        fields.append(field);
    }

    return fields;
}

// =============================================================================
// encode() — Serializar un StanagMessage completo a bytes BigEndian
// =============================================================================
// Flujo de serializacion:
//   1. Crear un QByteArray vacio como buffer de salida
//   2. Abrir un QDataStream sobre el buffer en modo escritura
//   3. Configurar BigEndian (network byte order)
//   4. Escribir los 6 campos del header como quint16
//   5. Empaquetar el payload (solo campos presentes segun bitmask)
//   6. Actualizar payloadLen en el header con el tamano real del payload
//   7. Agregar el payload al buffer
//   8. Calcular el XOR checksum de todo lo anterior y agregarlo
//
// NOTA SOBRE payloadLen:
//   No sabemos el tamano del payload hasta despues de empaquetarlo,
//   porque depende de cuantos campos estan presentes. Por eso escribimos
//   un placeholder (0) en la posicion de payloadLen, empaquetamos el
//   payload, y luego sobrescribimos el placeholder con el valor real.
//
// QDataStream::device()->seek(): permite volver a una posicion anterior
// del stream para sobrescribir datos. Usamos esto para actualizar payloadLen.
// =============================================================================
QByteArray StanagCodec::encode(const StanagMessage &msg)
{
    QByteArray buffer;
    QDataStream stream(&buffer, QIODevice::WriteOnly);
    stream.setByteOrder(QDataStream::BigEndian);

    // --- Escribir header ---
    stream << msg.messageId;        // Bytes 0-1
    stream << msg.sourcePort;       // Bytes 2-3
    stream << msg.destPort;         // Bytes 4-5
    stream << msg.sequenceNum;      // Bytes 6-7
    // payloadLen se escribe como placeholder, se actualizara despues
    stream << quint16(0);           // Bytes 8-9 (placeholder)
    stream << msg.presenceMask;     // Bytes 10-11

    // --- Empaquetar payload ---
    QByteArray payload = encodePayload(msg);

    // --- Actualizar payloadLen en el header ---
    // Volver a la posicion del campo payloadLen (byte 8) y sobrescribir
    quint16 payloadLen = static_cast<quint16>(payload.size());
    stream.device()->seek(8);
    stream << payloadLen;

    // --- Agregar payload al final del buffer ---
    buffer.append(payload);

    // --- Calcular y agregar checksum ---
    quint8 checksum = computeChecksum(buffer);
    buffer.append(static_cast<char>(checksum));

    return buffer;
}

// =============================================================================
// decode() — Deserializar bytes BigEndian a un StanagMessage
// =============================================================================
// Flujo de deserializacion:
//   1. Verificar longitud minima (12 bytes header + 1 byte checksum = 13)
//   2. Verificar checksum ANTES de parsear (fail-fast si datos corruptos)
//   3. Leer header con QDataStream en BigEndian
//   4. Verificar que payloadLen coincide con el tamano real del payload
//   5. Extraer y decodificar los campos del payload segun presenceMask
//
// PATRON OUTPUT PARAMETER:
//   En vez de retornar un StanagMessage (que podria ser costoso de copiar
//   con rawFrame grande), recibimos una referencia y la llenamos. El bool
//   de retorno indica exito/fallo. Este patron es comun en APIs de C++
//   para funciones que pueden fallar.
//
// VALIDACION DEL CHECKSUM:
//   El checksum se calcula sobre todos los bytes EXCEPTO el ultimo
//   (que es el propio checksum). Si el XOR de todos los bytes precedentes
//   coincide con el byte de checksum, los datos no fueron corrompidos.
// =============================================================================
bool StanagCodec::decode(const QByteArray &data, StanagMessage &msg)
{
    // Longitud minima: 12 bytes header + 1 byte checksum
    if (data.size() < kStanagHeaderSize + 1)
        return false;

    // Guardar la trama cruda completa para hex dump
    msg.rawFrame = data;

    // --- Verificar checksum ---
    // El checksum cubre todos los bytes excepto el ultimo (que ES el checksum)
    QByteArray dataWithoutChecksum = data.left(data.size() - 1);
    quint8 computedChecksum = computeChecksum(dataWithoutChecksum);
    msg.checksum = static_cast<quint8>(data.back());
    msg.checksumValid = (computedChecksum == msg.checksum);

    // --- Leer header ---
    QDataStream stream(data);
    stream.setByteOrder(QDataStream::BigEndian);

    stream >> msg.messageId;
    stream >> msg.sourcePort;
    stream >> msg.destPort;
    stream >> msg.sequenceNum;
    stream >> msg.payloadLen;
    stream >> msg.presenceMask;

    // --- Verificar que hay suficientes bytes para el payload ---
    int expectedSize = kStanagHeaderSize + msg.payloadLen + 1;  // +1 checksum
    if (data.size() < expectedSize)
        return false;

    // --- Extraer y decodificar el payload ---
    QByteArray payload = data.mid(kStanagHeaderSize, msg.payloadLen);
    msg.fields = decodePayload(payload, msg.presenceMask);

    return true;
}
