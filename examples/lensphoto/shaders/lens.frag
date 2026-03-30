#version 440

layout(location = 0) in  vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4  qt_Matrix;
    float qt_Opacity;
    float lensX;
    float lensY;
    float lensRadius;   // radio normalizado: pixelRadius / itemHeight
    float aspectRatio;  // itemWidth / itemHeight  — corrige UV para lente circular
    float magnification;
    float aberration;
    float rimBrightness;
};

layout(binding = 1) uniform sampler2D source;

void main()
{
    vec2 uv = qt_TexCoord0;

    // Delta en espacio corregido por aspecto para que la lente sea circular
    // aunque el ítem QML no sea cuadrado (UV space no es isótropo).
    vec2  delta    = vec2((uv.x - lensX) * aspectRatio, uv.y - lensY);
    float dist     = length(delta);
    float normDist = dist / max(lensRadius, 0.001);

    vec4 outside = texture(source, uv);

    // Fuera de la lente: renderizar sin modificar
    if (normDist >= 1.0) {
        fragColor = outside * qt_Opacity;
        return;
    }

    // ── Distorsión barrel ─────────────────────────────────────────────────
    // k > 0 → líneas se arquean hacia fuera cerca del borde (efecto barril).
    // El valor 0.20 es sutil en el centro y notorio en normDist ≈ 0.8.
    float r2     = normDist * normDist;
    vec2  warped = delta * (1.0 + 0.20 * r2);

    // ── UV magnificada ────────────────────────────────────────────────────
    // Dividir el delta distorsionado entre magnification para hacer zoom.
    // Volvemos al espacio UV estándar (sin corrección de aspecto) antes
    // de sumar al centro.
    vec2 lensUV = clamp(
        vec2(lensX, lensY) + vec2(warped.x / aspectRatio, warped.y) / magnification,
        vec2(0.0), vec2(1.0)
    );

    // ── Aberración cromática ──────────────────────────────────────────────
    // Los canales R y B se muestrean a distintas posiciones radiales.
    // El desplazamiento crece cuadráticamente (es nulo en el centro,
    // máximo en el borde) imitando la dispersión real de un objetivo.
    vec2 cDir = (dist > 0.0001) ? normalize(delta) : vec2(0.0);
    vec2 cOff = vec2(cDir.x / aspectRatio, cDir.y) * aberration * r2;

    float R = texture(source, clamp(lensUV + cOff, vec2(0.0), vec2(1.0))).r;
    float G = texture(source, lensUV).g;
    float B = texture(source, clamp(lensUV - cOff, vec2(0.0), vec2(1.0))).b;

    vec4 col = vec4(R, G, B, texture(source, lensUV).a);

    // ── Viñetado de borde ─────────────────────────────────────────────────
    // Oscurecimiento progresivo desde normDist=0.65 hasta el borde.
    col.rgb *= 1.0 - smoothstep(0.65, 1.0, normDist) * 0.35;

    // ── Rim highlight especular ────────────────────────────────────────────
    // Banda brillante en el borde superior de la lente que simula el
    // reflejo especular de una superficie convexa de vidrio.
    // La condición "upper" restringe el highlight al semicírculo superior
    // (delta.y < 0 significa que el pixel está por encima del centro).
    float rim   = smoothstep(0.82, 0.91, normDist) * smoothstep(1.0, 0.91, normDist);
    float upper = smoothstep(0.0, -0.12, delta.y / lensRadius);
    col.rgb = mix(col.rgb, vec3(1.0), rim * upper * rimBrightness * 0.6);

    // ── Anti-alias en el borde ────────────────────────────────────────────
    // Transición suave entre el interior y el exterior para evitar
    // el dentado en el contorno circular de la lente.
    float edgeBlend = 1.0 - smoothstep(0.92, 1.0, normDist);
    fragColor = mix(outside, col, edgeBlend) * qt_Opacity;
}
