// =============================================================================
// stanagcodec.h — Serializacion y deserializacion de mensajes STANAG 4586
// =============================================================================
//
// PATRON: Clase utilitaria con metodos estaticos puros (sin estado).
//
// Esta clase es el CORAZON EDUCATIVO del modulo. Demuestra:
//   1. Serializacion BigEndian con QDataStream
//   2. Parsing de bitmask para payload de longitud variable
//   3. XOR checksum
//   4. Separacion de responsabilidades: el codec no sabe nada de red ni de UI
//
// ¿Por que metodos estaticos en vez de un objeto?
//   - No hay estado interno — cada operacion es una funcion pura.
//   - No necesitamos herencia ni polimorfismo.
//   - Se pueden llamar desde cualquier parte sin instanciar:
//       QByteArray data = StanagCodec::encode(msg);
//   - Es el patron mas simple y directo para utilidades de conversion.
//
// QDATASTREAM Y BIGENDIAN:
//   QDataStream es la forma idiomatica de Qt para serializar datos binarios.
//   Por defecto usa BigEndian (network byte order), que es exactamente lo
//   que necesitamos para protocolos de comunicacion.
//
//   Alternativa manual: qToBigEndian() / qFromBigEndian() de <QtEndian>.
//   QDataStream es preferible porque:
//     - Maneja el byte order automaticamente
//     - Soporta tipos Qt nativos (QString, QByteArray, etc.)
//     - El codigo resultante es mas legible: stream << value;
// =============================================================================

#ifndef STANAGCODEC_H
#define STANAGCODEC_H

#include "stanagmessage.h"

// =============================================================================
// FieldDef — Definicion de un campo del protocolo
// =============================================================================
// Cada campo tiene un nombre legible y un tamano en bytes.
// Esta tabla define los 14 campos posibles del STANAG 4586.
// =============================================================================
struct FieldDef
{
    QString name;       // Nombre legible: "Latitude", "Heading", etc.
    int sizeBytes;      // Tamano del campo en bytes (2 o 4)
};

class StanagCodec
{
public:
    // =========================================================================
    // encode() — Serializar un StanagMessage a bytes BigEndian
    // =========================================================================
    // Flujo:
    //   1. Escribir header (6 x quint16) con QDataStream en BigEndian
    //   2. Iterar el presenceMask, empaquetando solo los campos presentes
    //   3. Calcular payloadLen y escribirlo en la posicion correcta
    //   4. Calcular XOR checksum de todos los bytes y agregarlo al final
    //
    // Retorna: QByteArray con la trama completa lista para enviar por UDP
    // =========================================================================
    static QByteArray encode(const StanagMessage &msg);

    // =========================================================================
    // decode() — Deserializar bytes BigEndian a un StanagMessage
    // =========================================================================
    // Flujo:
    //   1. Verificar longitud minima (header + checksum = 13 bytes)
    //   2. Leer header con QDataStream en BigEndian
    //   3. Iterar presenceMask para extraer los campos presentes del payload
    //   4. Verificar checksum XOR
    //
    // Retorna: true si el decode fue exitoso, false si los datos son invalidos
    // El StanagMessage se llena por referencia (patron output parameter).
    // =========================================================================
    static bool decode(const QByteArray &data, StanagMessage &msg);

    // =========================================================================
    // computeChecksum() — Calcular XOR de todos los bytes
    // =========================================================================
    // El checksum XOR es el mas simple posible: se hace XOR acumulativo
    // de cada byte del buffer. Detecta errores de un solo bit pero no
    // errores de reordenamiento. Para este ejemplo didactico es suficiente.
    //
    // Alternativas mas robustas: CRC-16 (comun en STANAG), CRC-32 (Ethernet).
    // =========================================================================
    static quint8 computeChecksum(const QByteArray &data);

    // =========================================================================
    // fieldDefinitions() — Tabla de los 14 campos del protocolo
    // =========================================================================
    // Devuelve una referencia constante a la tabla estatica de definiciones.
    // Cada entrada tiene {nombre, tamano_en_bytes}.
    //
    // Los campos estan inspirados en telemetria UAV de STANAG 4586:
    //   Bit 0:  Latitude        (4B float32)
    //   Bit 1:  Longitude       (4B float32)
    //   Bit 2:  Altitude        (2B int16)
    //   Bit 3:  Heading         (2B uint16)
    //   Bit 4:  Speed           (2B uint16)
    //   Bit 5:  Roll            (2B int16)
    //   Bit 6:  Pitch           (2B int16)
    //   Bit 7:  Yaw             (2B int16)
    //   Bit 8:  Fuel Level      (2B uint16)
    //   Bit 9:  Engine RPM      (2B uint16)
    //   Bit 10: Battery Voltage (2B uint16)
    //   Bit 11: Sensor Status   (2B uint16)
    //   Bit 12: Waypoint Index  (2B uint16)
    //   Bit 13: Mission Time    (4B uint32)
    // =========================================================================
    static const QList<FieldDef> &fieldDefinitions();

private:
    // =========================================================================
    // encodePayload() — Empaquetar solo los campos presentes
    // =========================================================================
    // Recorre los bits del presenceMask (0-13). Por cada bit activo,
    // busca el campo correspondiente en msg.fields y escribe sus bytes
    // en BigEndian. Los campos no presentes se saltan completamente.
    // =========================================================================
    static QByteArray encodePayload(const StanagMessage &msg);

    // =========================================================================
    // decodePayload() — Desempaquetar los campos del payload
    // =========================================================================
    // Lee el payload secuencialmente. Por cada bit activo en presenceMask,
    // extrae los bytes correspondientes segun la tabla de fieldDefinitions()
    // y los decodifica al valor numerico apropiado (float, int16, uint16, etc.)
    // =========================================================================
    static QList<StanagField> decodePayload(const QByteArray &payload,
                                            quint16 presenceMask);
};

#endif // STANAGCODEC_H
