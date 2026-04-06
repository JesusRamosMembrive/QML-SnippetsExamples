// =============================================================================
// portal_draw.js — Funciones de dibujo compartidas para el portal
// =============================================================================
// .pragma library: este archivo no tiene estado propio. Todas las funciones
// son puras (entrada → salida sin efectos secundarios en variables globales).
// Esto permite que múltiples Canvas lo importen de forma segura.
// =============================================================================
.pragma library

// -----------------------------------------------------------------------------
// drawPortal(ctx, w, h, angle, shadowBlur, opacity)
//
// Dibuja el portal completo: fondo oscuro dentro del óvalo, espiral verde
// giratoria con glow, y destellos blancos pulsantes.
//
// Parámetros:
//   ctx        — contexto 2D del Canvas
//   w, h       — dimensiones del Canvas en píxeles
//   angle      — ángulo actual de rotación de la espiral (en radianes)
//   shadowBlur — intensidad del glow interno (0–60)
//   opacity    — opacidad global del dibujo (1.0 para portal, 0.35 para reflejo)
// -----------------------------------------------------------------------------
function drawPortal(ctx, w, h, angle, shadowBlur, opacity) {
    ctx.save()
    ctx.globalAlpha = opacity

    var cx = w / 2
    var cy = h / 2
    var rx = w * 0.42          // radio horizontal del óvalo
    var ry = h * 0.48          // radio vertical del óvalo
    var tilt = -0.26           // ~-15 grados en radianes

    // ── 1. Clip al óvalo inclinado ──────────────────────────────────────────
    ctx.save()
    ctx.beginPath()
    ctx.ellipse(cx, cy, rx, ry, tilt, 0, Math.PI * 2)
    ctx.clip()

    // Fondo oscuro interior
    ctx.fillStyle = "#050F05"
    ctx.fillRect(0, 0, w, h)

    // ── 2. Espiral: escalar contexto para transformar círculos en óvalo ──────
    // Trasladamos al centro, rotamos el tilt, escalamos X para que los arcos
    // circulares queden aplanados como el óvalo.
    ctx.save()
    ctx.translate(cx, cy)
    ctx.rotate(tilt)
    ctx.scale(rx / ry, 1.0)    // ry es el eje sin escalar (vertical)

    ctx.shadowColor = "#7FFF00"
    ctx.shadowBlur  = shadowBlur

    // 8 arcos concéntricos con opacidad y grosor crecientes hacia el exterior.
    // La variación de startAngle + i*offset produce el efecto de espiral.
    for (var i = 0; i < 8; i++) {
        var r          = ry * (0.12 + i * 0.105)
        var startAngle = angle + i * (Math.PI / 3.5)
        var arcSpan    = Math.PI * 1.4
        var brightness = 80 + Math.round((i / 7) * 175)
        var alpha      = 0.35 + (i / 7) * 0.65
        var lw         = (2.5 + i * 0.7) * (ry / rx)   // compensar escala X

        ctx.beginPath()
        ctx.arc(0, 0, r, startAngle, startAngle + arcSpan)
        ctx.strokeStyle = "rgba(" + Math.round(brightness * 0.45) + ","
                                  + brightness + ",0," + alpha + ")"
        ctx.lineWidth   = lw
        ctx.stroke()
    }

    // Centro luminoso
    ctx.beginPath()
    ctx.arc(0, 0, ry * 0.08, 0, Math.PI * 2)
    ctx.fillStyle = "rgba(200,255,100,0.6)"
    ctx.fill()

    ctx.restore()   // quitar translate/rotate/scale, mantener clip

    // ── 3. Destellos blancos ─────────────────────────────────────────────────
    // Posiciones fijas en coordenadas polares (radio normalizado 0-1, ángulo).
    // La opacidad pulsa con sin(angle * velocidad + offset_individual).
    var sparkles = [
        { r: 0.32, a: 0.20 }, { r: 0.61, a: 1.10 }, { r: 0.78, a: 2.30 },
        { r: 0.44, a: 3.50 }, { r: 0.69, a: 4.20 }, { r: 0.53, a: 5.10 },
        { r: 0.87, a: 0.80 }, { r: 0.25, a: 2.70 }, { r: 0.65, a: 3.90 },
        { r: 0.48, a: 5.80 }, { r: 0.73, a: 1.50 }, { r: 0.38, a: 4.80 }
    ]

    ctx.shadowColor = "white"
    ctx.shadowBlur  = 8

    for (var s = 0; s < sparkles.length; s++) {
        var sp      = sparkles[s]
        var sa      = sp.a + angle * 0.4          // orbitan lentamente
        var sx      = cx + Math.cos(sa) * sp.r * rx * 0.88
        var sy      = cy + Math.sin(sa) * sp.r * ry * 0.88
        var pulse   = (Math.sin(angle * 3.0 + s * 1.3) + 1.0) / 2.0
        var sAlpha  = 0.35 + pulse * 0.65
        var sRadius = 1.5 + pulse * 2.0

        ctx.beginPath()
        ctx.arc(sx, sy, sRadius, 0, Math.PI * 2)
        ctx.fillStyle = "rgba(255,255,255," + sAlpha + ")"
        ctx.fill()
    }

    ctx.restore()   // quitar clip

    // ── 4. Borde exterior del óvalo ──────────────────────────────────────────
    ctx.shadowColor = "#7FFF00"
    ctx.shadowBlur  = shadowBlur * 0.6
    ctx.beginPath()
    ctx.ellipse(cx, cy, rx, ry, tilt, 0, Math.PI * 2)
    ctx.strokeStyle = "#ADFF2F"
    ctx.lineWidth   = 3
    ctx.stroke()

    ctx.restore()   // globalAlpha
}

// -----------------------------------------------------------------------------
// applyReflectionGradient(ctx, w, h)
//
// Superpone un degradado negro de arriba (transparente) a abajo (opaco)
// para que el reflejo se desvanezca hacia el suelo.
// Llamar DESPUÉS de haber dibujado el portal invertido.
// -----------------------------------------------------------------------------
function applyReflectionGradient(ctx, w, h) {
    var grad = ctx.createLinearGradient(0, 0, 0, h)
    grad.addColorStop(0.0, "rgba(0,0,0,0)")    // arriba: visible
    grad.addColorStop(1.0, "rgba(0,0,0,1)")    // abajo: oculto
    ctx.fillStyle = grad
    ctx.fillRect(0, 0, w, h)
}
