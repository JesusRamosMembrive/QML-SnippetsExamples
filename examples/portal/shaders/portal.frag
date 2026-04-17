#version 440

layout(location = 0) in  vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4  qt_Matrix;
    float qt_Opacity;
    float time;
    float glowIntensity;   // 0.0–1.0, controlado por slider
    float aspectRatio;     // width / height del item
};

#define PI 3.14159265358979323846

// Hash y noise suave para turbulencia
float hash(float n) { return fract(sin(n) * 43758.5453123); }
float smoothNoise(float x) {
    float i = floor(x);
    float f = fract(x);
    float u = f * f * (3.0 - 2.0 * f);
    return mix(hash(i), hash(i + 1.0), u);
}

void main()
{
    // UV centrados en (0,0), rango -0.5..0.5
    vec2 uv = qt_TexCoord0 - 0.5;

    // ── Máscara ovalada que rellena el item ───────────────────────────────
    // Dividir por 0.465 normaliza el semi-eje a 1.0; suavizado 8% del radio.
    float ellipseDist = length(vec2(uv.x / 0.465, uv.y / 0.465));
    float mask = 1.0 - smoothstep(0.92, 1.04, ellipseDist);

    if (mask < 0.001) {
        fragColor = vec4(0.0);
        return;
    }

    // ── Coordenadas polares en espacio de pantalla (isótropo) ─────────────
    vec2  p     = vec2(uv.x * aspectRatio, uv.y);
    float dist  = length(p);
    float angle = atan(p.y, p.x);

    // norm: 0 = centro, 1 = borde horizontal del portal
    float portalR = 0.465 * aspectRatio;
    float norm    = clamp(dist / portalR, 0.0, 1.0);

    // ── Patrón de vórtice espiral ─────────────────────────────────────────
    // 3 brazos que rotan con el tiempo; se aprietan hacia el centro
    float spiral = fract(
        angle / (2.0 * PI) * 3.0
        + norm * 2.8
        - time * 0.65
    );

    // ── Ondas concéntricas ─────────────────────────────────────────────────
    float ripple = 0.5 + 0.5 * sin(
        fract(norm * 7.0 - time * 0.4) * 2.0 * PI
    );

    // ── Turbulencia angular para romper simetría ──────────────────────────
    float turb = smoothNoise(angle * 3.5 + time * 0.25) * 0.18;

    // ── Patrón combinado ──────────────────────────────────────────────────
    float band = clamp(mix(spiral, ripple, 0.22) + turb, 0.0, 1.0);

    // ── Paleta de color ───────────────────────────────────────────────────
    // 0.00–0.18 : vacío (negro profundo)
    // 0.18–0.55 : verde oscuro
    // 0.55–0.85 : verde medio brillante
    // 0.85–1.00 : chartreuse neón (borde)
    vec3 c0 = vec3(0.00, 0.00, 0.00);  // vacío
    vec3 c1 = vec3(0.01, 0.22, 0.03);  // verde oscuro
    vec3 c2 = vec3(0.04, 0.72, 0.05);  // verde medio
    vec3 c3 = vec3(0.35, 1.00, 0.00);  // chartreuse neón

    vec3 baseColor;
    if (norm < 0.18) {
        baseColor = mix(c0, c1, norm / 0.18);
    } else if (norm < 0.55) {
        baseColor = mix(c1, c2, (norm - 0.18) / 0.37);
    } else {
        baseColor = mix(c2, c3, (norm - 0.55) / 0.45);
    }

    // ── Brillo modulado por patrón y slider ───────────────────────────────
    float brightness = (0.45 + band * 0.75) * (0.65 + glowIntensity * 0.65);
    vec3 color = baseColor * brightness;

    // ── Vacío central (máscara suave de 0 a norm=0.18) ────────────────────
    color *= smoothstep(0.0, 0.18, norm);

    // ── Anillo interior brillante (rimlight) ──────────────────────────────
    float rim = smoothstep(0.70, 0.88, norm) * smoothstep(1.02, 0.88, norm);
    color += vec3(0.12, 0.55, 0.0) * rim * (0.55 + glowIntensity * 0.65);

    // ── Composición final ─────────────────────────────────────────────────
    color *= mask;

    fragColor = vec4(color, mask) * qt_Opacity;
}
