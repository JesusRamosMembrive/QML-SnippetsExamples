#version 440

layout(location = 0) in  vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4  qt_Matrix;
    float qt_Opacity;
    float lensX;               // Centro X de la lente en UV (0..1)
    float lensY;               // Centro Y de la lente en UV (0..1)
    float lensRadius;          // Radio de las semicircunferencias de la cápsula (UV-Y)
    float aspectRatio;         // itemWidth / itemHeight
    float magnification;       // Fuerza de distorsión en el borde (0=plana, 0.6=media)
    float aberration;          // Aberración cromática en los caps (0..0.04)
    float rimBrightness;       // Sheen superior suave (0=off, 1=máximo)
    float lensWiden;           // Forma: 1.0=círculo, >1=cápsula más ancha
    float tintStrength;        // Tinte de cristal (0=transparente, 0.15=sutil)
    float noiseStrength;       // Micro-textura de superficie (0=off, 0.06=sutil)
    float vignetteStrength;    // Viñeta lateral hacia el borde (0=off, 0.25=sutil)
    float causticStrength;     // Destellos en los caps laterales (0=off, 0.6=fuerte)
    float bottomShadowStrength;// Sombra inferior / sensación de grosor (0=off, 0.4=fuerte)
};

layout(binding = 1) uniform sampler2D source;

void main()
{
    vec2  uv     = qt_TexCoord0;
    vec2  center = vec2(lensX, lensY);

    // ── Delta en espacio corregido por aspecto ────────────────────────────
    vec2  delta = vec2((uv.x - lensX) * aspectRatio, uv.y - lensY);
    float dist  = length(delta);

    // ── SDF de cápsula (pill) ─────────────────────────────────────────────
    float halfLen  = max(0.0, lensWiden - 1.0) * lensRadius;
    float closestX = clamp(delta.x, -halfLen, halfLen);
    float normDist = length(vec2(delta.x - closestX, delta.y)) / lensRadius;

    // ── Fuera de la cápsula: pass-through ─────────────────────────────────
    vec4 outside = texture(source, uv);
    if (normDist >= 1.0) {
        fragColor = outside * qt_Opacity;
        return;
    }

    // ── r2 radial desde el centro geométrico ─────────────────────────────
    float r2 = min((delta.x * delta.x + delta.y * delta.y)
                   / (lensRadius * lensRadius * max(1.0, lensWiden * lensWiden * 0.25)),
                   1.0);

    // ── Distorsión sólo en los caps horizontales ──────────────────────────
    // capWeight = 0 en la zona recta → centro e interior planos.
    // capWeight > 0 en los semicírculos → distorsión visible en los bordes.
    float capOffset  = abs(delta.x - closestX);
    float capWeight  = capOffset / lensRadius;
    float edgeFactor = normDist * normDist * capWeight;
    vec2 warped = delta * (1.0 + magnification * edgeFactor);
    vec2 lensUV = clamp(center + vec2(warped.x / aspectRatio, warped.y),
                        vec2(0.0), vec2(1.0));

    // ── Aberración cromática (caps horizontales) ──────────────────────────
    vec2 cDir = (dist > 0.0001) ? normalize(delta) : vec2(0.0);
    vec2 cOff = vec2(cDir.x / aspectRatio, cDir.y) * aberration * r2 * capWeight;

    float R = texture(source, clamp(lensUV + cOff, vec2(0.0), vec2(1.0))).r;
    float G = texture(source, lensUV).g;
    float B = texture(source, clamp(lensUV - cOff, vec2(0.0), vec2(1.0))).b;
    float A = texture(source, lensUV).a;

    vec4 col = vec4(R, G, B, A);

    // ── Micro-textura de superficie (ruido procedural) ────────────────────
    // Frecuencia baja (5×4) → ondulaciones suaves que el ojo lee como
    // micro-reflejos de luz en un vidrio curvo, sin grano visible.
    vec2  noiseUV = uv * vec2(aspectRatio * 5.0, 6.5);
    vec2  ni      = floor(noiseUV);
    vec2  nf      = fract(noiseUV);
    nf = nf * nf * (3.0 - 2.0 * nf);
    float n00 = fract(sin(dot(ni,             vec2(127.1, 311.7))) * 43758.5);
    float n10 = fract(sin(dot(ni + vec2(1,0), vec2(127.1, 311.7))) * 43758.5);
    float n01 = fract(sin(dot(ni + vec2(0,1), vec2(127.1, 311.7))) * 43758.5);
    float n11 = fract(sin(dot(ni + vec2(1,1), vec2(127.1, 311.7))) * 43758.5);
    float surfNoise = mix(mix(n00, n10, nf.x), mix(n01, n11, nf.x), nf.y);
    // Solo highlights (nunca oscurecer) → funciona sobre fondos claros y oscuros
    col.rgb += max(0.0, surfNoise - 0.5) * noiseStrength * 2.0 * smoothstep(0.2, 0.9, normDist);

    // ── Tinte de cristal ──────────────────────────────────────────────────
    col.rgb = mix(col.rgb, vec3(0.72, 0.97, 0.90), tintStrength);

    // ── Sombra inferior (grosor / Fresnel) ────────────────────────────────
    float yNorm      = delta.y / lensRadius;
    float botShadow  = smoothstep(-0.1, 0.75, yNorm)
                     * smoothstep(0.4,  1.0,  normDist);
    col.rgb *= 1.0 - botShadow * bottomShadowStrength;

    // ── Viñeta lateral ────────────────────────────────────────────────────
    col.rgb *= 1.0 - smoothstep(0.5, 1.0, normDist) * vignetteStrength;

    // ── Sheen superior suave ──────────────────────────────────────────────
    float topGradient = smoothstep(0.15, -0.85, yNorm);
    float sheen = topGradient * (1.0 - normDist * 0.5);
    col.rgb += vec3(sheen * rimBrightness * 0.12,
                    sheen * rimBrightness * 0.13,
                    sheen * rimBrightness * 0.14);

    // ── Caustics en los caps laterales ────────────────────────────────────
    float causticZone = smoothstep(0.55, 0.82, normDist)
                      * smoothstep(1.0,  0.76, normDist);
    float causticAmt  = causticZone * capWeight * capWeight;
    col.rgb = mix(col.rgb, vec3(0.80, 1.0, 0.90), causticAmt * causticStrength);

    // ── Brillo central suave ──────────────────────────────────────────────
    float center_glow = (1.0 - r2) * 0.05;
    col.rgb += vec3(center_glow * 0.55, center_glow, center_glow * 0.90);

    // ── Anti-alias del borde ──────────────────────────────────────────────
    float edgeMask = 1.0 - smoothstep(0.86, 1.0, normDist);

    // ── Composición ───────────────────────────────────────────────────────
    fragColor = mix(outside, col, edgeMask) * qt_Opacity;
}
