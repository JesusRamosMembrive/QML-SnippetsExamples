// =============================================================================
// ArtificialHorizonCard.qml — Horizonte Artificial (ADI)
// =============================================================================
// El ADI (Attitude Director Indicator) es el instrumento central del PFD.
// Muestra la actitud del avion: pitch (cabeceo) y roll (alabeo).
//
// Tecnicas Canvas 2D utilizadas:
//   - Clipping circular: ctx.arc() + ctx.clip() para limitar el dibujo al disco
//   - Transformacion de coordenadas: translate + rotate para rotar cielo/tierra
//   - Gradientes lineales: createLinearGradient para cielo azul y tierra marron
//   - Escalera de pitch (pitch ladder): marcas a intervalos de 5 grados
//   - Arco de roll: marcas fijas con puntero triangular que rota
//   - Simbolo del avion: referencia fija en el centro (amarillo)
//
// Trigonometria clave:
//   - ppd (pixels per degree): convierte grados de pitch a pixeles
//   - roll se aplica como rotacion del contexto en radianes: deg * PI / 180
//   - Las marcas de roll usan coordenadas polares: cos(angulo)*radio, sin(angulo)*radio
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import utils

Rectangle {
    color: Style.cardColor
    radius: Style.resize(8)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Style.resize(20)
        spacing: Style.resize(10)

        Label {
            text: "Artificial Horizon (ADI)"
            font.pixelSize: Style.resize(20)
            font.bold: true
            color: Style.mainColor
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Canvas {
                id: adiCanvas
                onAvailableChanged: if (available) requestPaint()
                anchors.centerIn: parent
                width: Math.min(parent.width, parent.height) - Style.resize(10)
                height: width

                // Propiedades reactivas: cualquier cambio dispara requestPaint()
                // para redibujar el Canvas completo. Este es el patron estandar
                // de animacion interactiva con Canvas 2D en QML.
                property real pitch: pitchSlider.value
                property real roll: rollSlider.value

                onPitchChanged: requestPaint()
                onRollChanged: requestPaint()

                onPaint: {
                    var ctx = getContext("2d");
                    var w = width;
                    var h = height;
                    var cx = w / 2;
                    var cy = h / 2;
                    var r = Math.min(cx, cy) - 4;

                    ctx.clearRect(0, 0, w, h);
                    ctx.save();

                    // ---------------------------------------------------------
                    // Clipping circular: todo el dibujo del horizonte se limita
                    // a un circulo. Esto simula la ventana redonda del instrumento
                    // real y evita que cielo/tierra se dibujen fuera del disco.
                    // ---------------------------------------------------------
                    ctx.beginPath();
                    ctx.arc(cx, cy, r, 0, 2 * Math.PI);
                    ctx.clip();

                    // ---------------------------------------------------------
                    // Transformacion de coordenadas para roll:
                    // 1. translate(cx, cy) mueve el origen al centro del canvas
                    // 2. rotate(-roll * PI/180) rota todo el contenido
                    //    (negativo porque roll positivo = inclinacion derecha = rotacion
                    //     antihoraria visual del horizonte)
                    // Despues de esto, el pitch simplemente desplaza verticalmente.
                    // ---------------------------------------------------------
                    ctx.translate(cx, cy);
                    ctx.rotate(-roll * Math.PI / 180);

                    // ppd = pixels per degree: cuantos pixeles equivalen a 1 grado
                    // de pitch. El rango visible es +-30 grados dentro del radio r.
                    var ppd = r / 30;
                    var pitchOffset = pitch * ppd;

                    // ---------------------------------------------------------
                    // Gradientes de cielo y tierra:
                    // El cielo usa un degradado azul oscuro (horizonte lejano) a
                    // azul claro (cerca del horizonte). La tierra va de marron
                    // claro a oscuro. pitchOffset desplaza la linea divisoria
                    // verticalmente segun el angulo de cabeceo.
                    // ---------------------------------------------------------
                    var skyGrad = ctx.createLinearGradient(0, -r * 2, 0, pitchOffset);
                    skyGrad.addColorStop(0, "#0a1e5e");
                    skyGrad.addColorStop(0.6, "#1565C0");
                    skyGrad.addColorStop(1, "#64B5F6");
                    ctx.fillStyle = skyGrad;
                    ctx.fillRect(-r * 2, -r * 2, r * 4, r * 2 + pitchOffset);

                    var gndGrad = ctx.createLinearGradient(0, pitchOffset, 0, r * 2);
                    gndGrad.addColorStop(0, "#8B6914");
                    gndGrad.addColorStop(0.4, "#6B4400");
                    gndGrad.addColorStop(1, "#3E2723");
                    ctx.fillStyle = gndGrad;
                    ctx.fillRect(-r * 2, pitchOffset, r * 4, r * 2);

                    // Linea del horizonte: separacion visual entre cielo y tierra
                    ctx.strokeStyle = "#FFFFFF";
                    ctx.lineWidth = 2;
                    ctx.beginPath();
                    ctx.moveTo(-r * 2, pitchOffset);
                    ctx.lineTo(r * 2, pitchOffset);
                    ctx.stroke();

                    // ---------------------------------------------------------
                    // Escalera de pitch (pitch ladder):
                    // Lineas horizontales a intervalos de 5 grados que permiten
                    // al piloto estimar visualmente el angulo de cabeceo.
                    // Las marcas de 10 grados son mas largas y llevan etiqueta
                    // numerica a ambos lados. La posicion Y de cada marca se
                    // calcula como: pitchOffset - grados * ppd
                    // (resta porque pitch positivo = nariz arriba = desplazamiento
                    // hacia abajo del horizonte en pantalla)
                    // ---------------------------------------------------------
                    ctx.fillStyle = "#FFFFFF";
                    ctx.strokeStyle = "#FFFFFF";
                    ctx.lineWidth = 1.5;
                    ctx.textAlign = "center";
                    ctx.textBaseline = "middle";
                    ctx.font = (r * 0.08) + "px sans-serif";

                    var pitchMarks = [-20, -15, -10, -5, 5, 10, 15, 20];
                    for (var i = 0; i < pitchMarks.length; i++) {
                        var deg = pitchMarks[i];
                        var y = pitchOffset - deg * ppd;
                        var halfW = (Math.abs(deg) % 10 === 0) ? r * 0.25 : r * 0.12;

                        ctx.beginPath();
                        ctx.moveTo(-halfW, y);
                        ctx.lineTo(halfW, y);
                        ctx.stroke();

                        if (Math.abs(deg) % 10 === 0) {
                            ctx.fillText(Math.abs(deg).toString(), -halfW - r * 0.1, y);
                            ctx.fillText(Math.abs(deg).toString(), halfW + r * 0.1, y);
                        }
                    }

                    ctx.restore();
                    ctx.save();

                    // ---------------------------------------------------------
                    // Arco de roll (fijo, no rota con pitch/roll):
                    // Semicirculo superior con marcas a angulos estandar de aviacion
                    // (-60, -45, -30, -20, -10, 0, 10, 20, 30, 45, 60 grados).
                    // Las marcas de 30 grados son mas largas para mayor visibilidad.
                    //
                    // La conversion angulo -> posicion usa coordenadas polares:
                    //   x = cos(angulo) * radio
                    //   y = sin(angulo) * radio
                    // donde angulo se mide desde el eje horizontal y se ajusta
                    // restando 90 grados para que 0 quede arriba.
                    // ---------------------------------------------------------
                    ctx.translate(cx, cy);
                    ctx.strokeStyle = "#FFFFFF";
                    ctx.lineWidth = 2;
                    ctx.beginPath();
                    ctx.arc(0, 0, r * 0.85, -Math.PI * 5/6, -Math.PI * 1/6);
                    ctx.stroke();

                    var rollMarks = [-60, -45, -30, -20, -10, 0, 10, 20, 30, 45, 60];
                    for (var j = 0; j < rollMarks.length; j++) {
                        var angle = (-90 + rollMarks[j]) * Math.PI / 180;
                        var innerR = (Math.abs(rollMarks[j]) % 30 === 0) ? r * 0.78 : r * 0.82;
                        ctx.beginPath();
                        ctx.moveTo(Math.cos(angle) * innerR, Math.sin(angle) * innerR);
                        ctx.lineTo(Math.cos(angle) * r * 0.85, Math.sin(angle) * r * 0.85);
                        ctx.stroke();
                    }

                    // ---------------------------------------------------------
                    // Puntero de roll: triangulo blanco que rota con el alabeo.
                    // Se dibuja en la posicion -90 grados (arriba) y se rota
                    // con ctx.rotate(-roll) para que apunte al angulo actual.
                    // ---------------------------------------------------------
                    ctx.save();
                    ctx.rotate(-roll * Math.PI / 180);
                    ctx.fillStyle = "#FFFFFF";
                    ctx.beginPath();
                    ctx.moveTo(0, -r * 0.85);
                    ctx.lineTo(-r * 0.04, -r * 0.78);
                    ctx.lineTo(r * 0.04, -r * 0.78);
                    ctx.closePath();
                    ctx.fill();
                    ctx.restore();

                    // ---------------------------------------------------------
                    // Simbolo fijo del avion (amarillo):
                    // Dos "alas" horizontales y un punto central que representan
                    // la referencia de la aeronave. Este simbolo NO rota —
                    // permanece fijo mientras el horizonte se mueve detras.
                    // Esto simula lo que el piloto ve: el avion esta fijo,
                    // el mundo se mueve.
                    // ---------------------------------------------------------
                    ctx.strokeStyle = "#FFD600";
                    ctx.fillStyle = "#FFD600";
                    ctx.lineWidth = 3;

                    // Ala izquierda
                    ctx.beginPath();
                    ctx.moveTo(-r * 0.4, 0);
                    ctx.lineTo(-r * 0.15, 0);
                    ctx.lineTo(-r * 0.15, r * 0.05);
                    ctx.stroke();

                    // Ala derecha
                    ctx.beginPath();
                    ctx.moveTo(r * 0.4, 0);
                    ctx.lineTo(r * 0.15, 0);
                    ctx.lineTo(r * 0.15, r * 0.05);
                    ctx.stroke();

                    // Punto central
                    ctx.beginPath();
                    ctx.arc(0, 0, r * 0.03, 0, 2 * Math.PI);
                    ctx.fill();

                    ctx.restore();

                    // Anillo exterior: borde estetico del instrumento
                    ctx.strokeStyle = "#333";
                    ctx.lineWidth = 3;
                    ctx.beginPath();
                    ctx.arc(cx, cy, r, 0, 2 * Math.PI);
                    ctx.stroke();
                }
            }
        }

        // ---------------------------------------------------------------------
        // Controles interactivos: sliders para pitch y roll.
        // Los valores se vinculan a las propiedades del Canvas, que disparan
        // requestPaint() en cada cambio. Esto demuestra el ciclo reactivo:
        // Slider -> property -> onChanged -> requestPaint() -> onPaint
        // ---------------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(15)

            Label {
                text: "Pitch"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }
            Slider {
                id: pitchSlider
                Layout.fillWidth: true
                from: -30
                to: 30
                value: 0
            }
            Label {
                text: pitchSlider.value.toFixed(0) + "°"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(35)
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Style.resize(15)

            Label {
                text: "Roll"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
            }
            Slider {
                id: rollSlider
                Layout.fillWidth: true
                from: -60
                to: 60
                value: 0
            }
            Label {
                text: rollSlider.value.toFixed(0) + "°"
                font.pixelSize: Style.resize(12)
                color: Style.fontSecondaryColor
                Layout.preferredWidth: Style.resize(35)
            }
        }

        Label {
            text: "Canvas-drawn sky/ground, pitch ladder, roll arc. Airbus PFD core instrument."
            font.pixelSize: Style.resize(12)
            color: Style.fontSecondaryColor
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }
}
