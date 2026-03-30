#version 440

layout(location = 0) in  vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4  qt_Matrix;
    float qt_Opacity;
    float lensX;          // Centro X de la lente en UV (0..1)
    float lensY;          // Centro Y de la lente en UV (0..1)
    float lensRadius;     // Radio vertical de la lente en unidades UV-Y
    float aspectRatio;    // itemWidth / itemHeight
    float magnification;  // Factor de magnificación (1.0 = sin magnificación)
    float aberration;     // Intensidad de aberración cromática (0..0.04)
    float rimBrightness;  // Intensidad del highlight en el borde (0..1)
    float lensWiden;      // Ensanche horizontal de la lente (1.0=circular, 2.0=doble ancho)
};

layout(binding = 1) uniform sampler2D source;

void main()
{
    vec2  uv     = qt_TexCoord0;
    vec2  center = vec2(lensX, lensY);

    // ── Delta en espacio de pantalla (corregido por aspecto) ───────────────
    vec2  delta    = vec2((uv.x - lensX) * aspectRatio, uv.y - lensY);
    float dist     = length(delta);

    // ── Forma elíptica: dividir X por lensWiden antes de medir la distancia ─
    // lensWiden > 1  →  la lente es más ancha que alta en pantalla.
    vec2  shapeP   = vec2(delta.x / lensWiden, delta.y);
    float normDist = length(shapeP) / lensRadius;

    // ── Fuera de la lente: pass-through ────────────────────────────────────
    vec4 outside = texture(source, uv);
    if (normDist >= 1.0) {
        fragColor = outside * qt_Opacity;
        return;
    }

    float r2 = normDist * normDist;

    // ── Barrel distortion + magnificación ──────────────────────────────────
    vec2 warped = delta * (1.0 + 0.30 * r2);
    vec2 lensUV = clamp(center + vec2(warped.x / aspectRatio, warped.y) / magnification,
                        vec2(0.0), vec2(1.0));

    // ── Aberración cromática ────────────────────────────────────────────────
    vec2 cDir = (dist > 0.0001) ? normalize(delta) : vec2(0.0);
    vec2 cOff = vec2(cDir.x / aspectRatio, cDir.y) * aberration * r2;

    float R = texture(source, clamp(lensUV + cOff, vec2(0.0), vec2(1.0))).r;
    float G = texture(source, lensUV).g;
    float B = texture(source, clamp(lensUV - cOff, vec2(0.0), vec2(1.0))).b;
    float A = texture(source, lensUV).a;

    vec4 col = vec4(R, G, B, A);

    // ── Viñeta interior (más pronunciada) ─────────────────────────────────
    col.rgb *= 1.0 - smoothstep(0.40, 1.0, normDist) * 0.45;

    // ── Tinte de cristal (mint/teal) — más intenso ─────────────────────────
    col.rgb = mix(col.rgb, vec3(0.72, 0.97, 0.90), 0.38);

    // ── Specular superior (reflejo cenital) ────────────────────────────────
    float upperSpec = smoothstep(0.0, -0.18, delta.y / lensRadius)
                    * smoothstep(0.78, 0.96, normDist)
                    * smoothstep(1.0,  0.78, normDist);
    col.rgb = mix(col.rgb, vec3(1.0), upperSpec * rimBrightness * 0.85);

    // ── Rim highlight general ───────────────────────────────────────────────
    float rim = smoothstep(0.74, 0.88, normDist)
              * smoothstep(1.0,  0.84, normDist);
    col.rgb = mix(col.rgb, vec3(0.90, 1.0, 0.96), rim * 0.65);

    // ── Brillo central (lente convexa — centro más brillante) ──────────────
    float center_glow = (1.0 - normDist * normDist) * 0.18;
    col.rgb += vec3(center_glow * 0.6, center_glow, center_glow * 0.95);

    // ── Anti-alias del borde ───────────────────────────────────────────────
    float edgeMask = 1.0 - smoothstep(0.86, 1.0, normDist);

    // ── Composición ────────────────────────────────────────────────────────
    fragColor = mix(outside, col, edgeMask) * qt_Opacity;
}
