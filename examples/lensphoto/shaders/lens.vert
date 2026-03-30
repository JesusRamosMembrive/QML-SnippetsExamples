#version 440

layout(location = 0) in vec4 qt_Vertex;
layout(location = 1) in vec2 qt_MultiTexCoord0;

// El UBO en binding=0 debe declarar TODOS los miembros en el mismo orden
// que el fragment shader para cumplir con el requisito std140 de GLSL.
// El vertex shader solo usa qt_Matrix, pero la estructura completa
// debe estar presente para que qsb pueda enlazar ambos shaders.
layout(std140, binding = 0) uniform buf {
    mat4  qt_Matrix;
    float qt_Opacity;
    float lensX;
    float lensY;
    float lensRadius;
    float aspectRatio;
    float magnification;
    float aberration;
    float rimBrightness;
};

layout(location = 0) out vec2 qt_TexCoord0;

void main()
{
    qt_TexCoord0 = qt_MultiTexCoord0;
    gl_Position  = qt_Matrix * qt_Vertex;
}
