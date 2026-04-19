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

    // ── Liquid blob: deformacion organica del borde ───────────────────────
    // Suma de 4 sinusoides con frecuencias angulares distintas (3,5,7,2) y
    // velocidades temporales desacopladas: sintesis aditiva tipo Fourier.
    // Misma tecnica que el ejemplo LiquidBlob de la pagina Shapes.
    float uvAngle = atan(uv.y, uv.x);
    float wobble =
          0.15 * sin(3.0 * uvAngle + time * 1.2)
        + 0.10 * sin(5.0 * uvAngle - time * 0.8)
        + 0.08 * sin(7.0 * uvAngle + time * 1.5)
        + 0.12 * sin(2.0 * uvAngle - time * 0.6);

    // Amplitud total ~ ±0.45*factor. Factor 0.18 => borde oscila ~±8%.
    float wobbleScale = 0.18;
    float edgeR = 0.465 * (1.0 + wobble * wobbleScale);

    // ── Mascara con borde deformado ───────────────────────────────────────
    float ellipseDist = length(uv) / edgeR;
    float mask = 1.0 - smoothstep(0.92, 1.04, ellipseDist);

    if (mask < 0.001) {
        fragColor = vec4(0.0);
        return;
    }

    // ── Coordenadas polares en espacio de pantalla (isótropo) ─────────────
    vec2  p     = vec2(uv.x * aspectRatio, uv.y);
    float dist  = length(p);
    float angle = atan(p.y, p.x);

    // norm: 0 = centro, 1 = borde deformado. Escalamos portalR con el mismo
    // wobble para que la espiral, el rimlight y el borde acompañen la
    // deformacion de forma coherente.
    float portalR = 0.465 * aspectRatio * (1.0 + wobble * wobbleScale);
    float norm    = clamp(dist / portalR, 0.0, 1.0);

    // ── Warp "liquido" de las coordenadas de patron ───────────────────────
    // Perturbaciones sinusoidales aplicadas a angle/norm. El warp angular
    // depende del radio (norm) y viceversa: esto cruza las dependencias y
    // hace que los brazos de la espiral ondeen como si giraran en un
    // fluido turbulento, no como lineas rigidas.
    float angleWarp =
          0.10 * sin(2.5 * norm * PI + time * 0.9)
        + 0.05 * sin(5.0 * norm * PI - time * 1.3);
    float normWarp =
          0.05 * sin(3.0 * angle + time * 1.1)
        + 0.03 * sin(6.0 * angle - time * 0.7);

    float warpedAngle = angle + angleWarp;
    float warpedNorm  = norm  + normWarp;

    // ── Patrón de vórtice espiral ─────────────────────────────────────────
    // 3 brazos que rotan con el tiempo; se aprietan hacia el centro
    float spiral = fract(
        warpedAngle / (2.0 * PI) * 3.0
        + warpedNorm * 2.8
        - time * 0.65
    );

    // ── Ondas concéntricas ─────────────────────────────────────────────────
    float ripple = 0.5 + 0.5 * sin(
        fract(warpedNorm * 7.0 - time * 0.4) * 2.0 * PI
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

    // ── Motas blancas giratorias ──────────────────────────────────────────
    // Rejilla polar pseudoaleatoria (sectores x anillos) que rota junto a
    // la espiral. Cada celda tiene una probabilidad de contener una mota;
    // su posicion dentro de la celda y su tamaño se fijan por hash, por lo
    // que las motas viajan en circulo sin parpadear.
    const float sectors = 14.0;
    const float rings   = 7.0;
    float rotAngle = angle - time * 0.65;            // misma velocidad que spiral
    vec2 polar = vec2(
        fract(rotAngle / (2.0 * PI)) * sectors,
        norm * rings
    );
    vec2 cellId = floor(polar);
    cellId.x = mod(cellId.x, sectors);               // envolver en angular
    vec2 cellUV = fract(polar) - 0.5;

    float r1 = hash(cellId.x * 17.13 + cellId.y * 91.7);
    float r2 = hash(cellId.x * 53.1  + cellId.y * 41.3 + 7.3);
    float r3 = hash(cellId.x * 29.7  + cellId.y * 13.9 + 3.1);

    // Aparecen solo en ~40% de las celdas, y por encima de norm=0.25 para
    // que no invadan el vacio central.
    float visible = step(0.60, r1) * step(0.25, norm);
    vec2  speckCenter = (vec2(r2, r3) - 0.5) * 0.6;
    float dSpeck      = length(cellUV - speckCenter);
    float specSize    = 0.07 + r1 * 0.08;            // entre 0.07 y 0.15
    float speckAlpha  = (1.0 - smoothstep(specSize * 0.5, specSize, dSpeck)) * visible;

    color = mix(color, vec3(1.0), speckAlpha * 0.9);

    // ── Composición final ─────────────────────────────────────────────────
    color *= mask;

    fragColor = vec4(color, mask) * qt_Opacity;
}
