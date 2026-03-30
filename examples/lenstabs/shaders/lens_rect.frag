#version 440

layout(location = 0) in  vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4  qt_Matrix;
    float qt_Opacity;
    float lensUVX;         // Centro X de la píldora en UV (0..1)
    float lensUVY;         // Centro Y de la píldora en UV (0..1)
    float lensHalfWUV;     // Semiancho en UV
    float lensHalfHUV;     // Semialtura en UV
    float cornerRadiusUV;  // Radio de esquina en unidades Y-UV (=lensHalfHUV → píldora)
    float aspectRatio;     // itemWidth / itemHeight  — corrección de espacio no isótropo
    float aberration;      // Aberración cromática en el borde (0..0.02)
    float glowStrength;    // Halo teal exterior (0..1)
};

// ── Signed Distance Function: rectángulo con esquinas redondeadas ──────────
// p        : punto relativo al centro de la forma, en espacio corregido por aspecto
// halfSize : semidimensiones del rectángulo en el mismo espacio
// r        : radio de esquina en el mismo espacio
// Devuelve: negativo = interior, 0 = borde, positivo = exterior
float sdRoundRect(vec2 p, vec2 halfSize, float r)
{
    vec2 q = abs(p) - halfSize + r;
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - r;
}

void main()
{
    vec2  uv = qt_TexCoord0;

    // Posición relativa al centro de la píldora, corregida por aspecto
    // para que la forma sea correcta en pantalla (UV no es isótropo).
    vec2  p        = vec2((uv.x - lensUVX) * aspectRatio, uv.y - lensUVY);
    vec2  halfSize = vec2(lensHalfWUV * aspectRatio, lensHalfHUV);
    float cr       = cornerRadiusUV;  // unidad Y-UV = sin cambio por aspect ratio

    float sdf = sdRoundRect(p, halfSize, cr);

    // ── Halo exterior (glow teal) ──────────────────────────────────────────
    // Se renderiza ligeramente fuera de la píldora para simular emisión de luz.
    float glowRadius = lensHalfHUV * 0.28;
    float glowAlpha  = smoothstep(glowRadius, 0.0, sdf) * glowStrength * 0.30;

    // Retorno temprano: pixel claramente fuera del área de efecto
    if (sdf > glowRadius + 0.002) {
        fragColor = vec4(0.0);
        return;
    }

    // ── Posición vertical relativa dentro de la píldora (0=top, 1=bottom) ──
    float relY = clamp((uv.y - lensUVY + lensHalfHUV) / (lensHalfHUV * 2.0), 0.0, 1.0);

    // ── Gradiente del cuerpo de cristal ────────────────────────────────────
    // Blanco ligeramente frío arriba → menta suave abajo.
    vec3 topColor    = vec3(0.95, 1.00, 0.99);
    vec3 bottomColor = vec3(0.62, 0.93, 0.86);
    vec3 glassColor  = mix(topColor, bottomColor, relY);

    // ── Specular superior ──────────────────────────────────────────────────
    // Banda brillante en el cuarto superior de la píldora: simula el reflejo
    // de una fuente de luz cenital sobre la superficie convexa del cristal.
    float specRange = lensHalfHUV * 0.08;
    float spec = smoothstep(0.40, 0.15, relY)
               * smoothstep(specRange, -specRange * 2.0, sdf);
    glassColor = mix(glassColor, vec3(1.0), spec * 0.52);

    // ── Highlight del borde (rim) ──────────────────────────────────────────
    // Anillo fino y brillante justo en la frontera de la píldora: sugiere
    // el espesor y la curvatura del borde del cristal.
    float rimInner = -lensHalfHUV * 0.055;
    float rimOuter =  lensHalfHUV * 0.010;
    float rim = smoothstep(rimOuter, rimInner * 0.6, sdf)
              * smoothstep(rimInner,  rimOuter * 0.3, sdf);
    glassColor = mix(glassColor, vec3(1.0), rim * 0.72);

    // ── Aberración cromática en el borde ──────────────────────────────────
    // El canal rojo se desplaza hacia fuera y el azul hacia dentro,
    // imitando la dispersión de longitudes de onda de una lente real.
    if (aberration > 0.0001) {
        float fringeZone = lensHalfHUV * aberration * 5.0;
        float fringeT    = smoothstep(-fringeZone, fringeZone * 0.5, sdf);
        // Franja roja justo en/fuera del borde
        glassColor.r += fringeT * (1.0 - fringeT) * 4.0 * 0.28;
        // Franja azul justo dentro del borde
        float blueT = (1.0 - fringeT) * smoothstep(-fringeZone * 2.5, -fringeZone, sdf);
        glassColor.b += blueT * 0.24;
    }

    // ── Vignette inferior ──────────────────────────────────────────────────
    // Ligero oscurecimiento en la parte baja de la píldora: sugiere el
    // grosor del cristal y añade profundidad sin romper el gradiente.
    float vig = smoothstep(0.60, 1.0, relY)
              * smoothstep(-lensHalfHUV * 0.08, -lensHalfHUV * 0.25, sdf);
    glassColor -= vec3(vig * 0.07);

    // ── Alpha del cuerpo ───────────────────────────────────────────────────
    // La píldora es casi opaca (0.93): cubre el texto base difuminado que
    // hay debajo; la capa de texto oscuro QML se dibuja encima.
    float bodyAlpha = 0.93;

    // ── Anti-alias del borde ───────────────────────────────────────────────
    float edgeMask = 1.0 - smoothstep(-0.004, 0.004, sdf);

    // ── Composición ────────────────────────────────────────────────────────
    // Dentro de la píldora: color de cristal con alpha opaco.
    // Fuera de la píldora: halo teal translúcido que se desvanece.
    float inside   = clamp(-sdf * 200.0, 0.0, 1.0);  // 1 inside, 0 outside
    float alpha    = mix(glowAlpha, bodyAlpha * edgeMask, inside);
    vec3  color    = mix(vec3(0.0, 0.82, 0.66), glassColor, inside);

    fragColor = vec4(color, alpha) * qt_Opacity;
}
