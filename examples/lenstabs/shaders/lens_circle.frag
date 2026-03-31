#version 440

layout(location = 0) in  vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4  qt_Matrix;
    float qt_Opacity;
    float lensX;          // Centro X de la lente en UV (0..1)
    float lensY;          // Centro Y de la lente en UV (0..1)
    float lensRadius;     // Radio de las semicircunferencias de la cápsula (UV-Y)
    float aspectRatio;    // itemWidth / itemHeight
    float magnification;  // Fuerza de distorsión en el borde (0=plana, 0.6=media, 1.5=fuerte)
    float aberration;     // Intensidad de aberración cromática (0..0.04)
    float rimBrightness;  // Intensidad del highlight en el borde (0..1)
    float lensWiden;      // Forma: 1.0 = círculo, >1 = cápsula (pill) más ancha
};

layout(binding = 1) uniform sampler2D source;

void main()
{
    vec2  uv     = qt_TexCoord0;
    vec2  center = vec2(lensX, lensY);

    // ── Delta en espacio corregido por aspecto ─────────────────────────────
    // Ambas componentes están en "unidades de altura", lo que permite que
    // el SDF opere en espacio isótropo independientemente del aspect ratio.
    vec2  delta = vec2((uv.x - lensX) * aspectRatio, uv.y - lensY);
    float dist  = length(delta);

    // ── SDF de cápsula (pill) ──────────────────────────────────────────────
    // halfLen: extensión horizontal del segmento central plano.
    // lensWiden = 1.0 → círculo; lensWiden = 1.6 → pill 60% más ancha que alta.
    float halfLen  = max(0.0, lensWiden - 1.0) * lensRadius;
    float closestX = clamp(delta.x, -halfLen, halfLen);
    float normDist = length(vec2(delta.x - closestX, delta.y)) / lensRadius;

    // ── Fuera de la cápsula: pass-through del track (frost glass normal) ────
    vec4 outside = texture(source, uv);
    if (normDist >= 1.0) {
        fragColor = outside * qt_Opacity;
        return;
    }

    // ── r2 radial desde el centro geométrico (para aberración cromática) ─────
    float r2 = min((delta.x * delta.x + delta.y * delta.y)
                   / (lensRadius * lensRadius * max(1.0, lensWiden * lensWiden * 0.25)),
                   1.0);

    // ── Distorsión sólo en los caps horizontales ──────────────────────────
    // capOffset = 0 en la zona recta del pill (arriba/abajo) → sin distorsión.
    // capOffset > 0 en los semicírculos izquierdo/derecho → distorsión creciente.
    // Así las aristas superiores/inferiores son planas y la refracción sólo
    // aparece en los extremos laterales (visible al pasar por encima en tránsito).
    float capOffset  = abs(delta.x - closestX);          // 0 en zona recta, >0 en caps
    float capWeight  = capOffset / lensRadius;            // 0..1 normalizado al radio
    float edgeFactor = normDist * normDist * capWeight;
    vec2 warped = delta * (1.0 + magnification * edgeFactor);
    vec2 lensUV = clamp(center + vec2(warped.x / aspectRatio, warped.y),
                        vec2(0.0), vec2(1.0));

    // ── Aberración cromática (también concentrada en los caps horizontales) ──
    vec2 cDir = (dist > 0.0001) ? normalize(delta) : vec2(0.0);
    vec2 cOff = vec2(cDir.x / aspectRatio, cDir.y) * aberration * r2 * capWeight;

    float R = texture(source, clamp(lensUV + cOff, vec2(0.0), vec2(1.0))).r;
    float G = texture(source, lensUV).g;
    float B = texture(source, clamp(lensUV - cOff, vec2(0.0), vec2(1.0))).b;
    float A = texture(source, lensUV).a;

    vec4 col = vec4(R, G, B, A);

    // ── Viñeta interior suave ──────────────────────────────────────────────
    col.rgb *= 1.0 - smoothstep(0.40, 1.0, normDist) * 0.28;

    // ── Tinte de cristal muy sutil ─────────────────────────────────────────
    col.rgb = mix(col.rgb, vec3(0.72, 0.97, 0.90), 0.07);

    // ── Specular superior (reflejo cenital) ────────────────────────────────
    float upperSpec = smoothstep(0.0, -0.18, delta.y / lensRadius)
                    * smoothstep(0.78, 0.96, normDist)
                    * smoothstep(1.0,  0.78, normDist);
    col.rgb = mix(col.rgb, vec3(1.0), upperSpec * rimBrightness * 0.85);

    // ── Brillo central suave ───────────────────────────────────────────────
    float center_glow = (1.0 - r2) * 0.06;
    col.rgb += vec3(center_glow * 0.6, center_glow, center_glow * 0.95);

    // ── Anti-alias del borde ───────────────────────────────────────────────
    float edgeMask = 1.0 - smoothstep(0.86, 1.0, normDist);

    // ── Composición ────────────────────────────────────────────────────────
    fragColor = mix(outside, col, edgeMask) * qt_Opacity;
}
