#version 440

layout(location = 0) in vec4 qt_Vertex;
layout(location = 1) in vec2 qt_MultiTexCoord0;

// El UBO en binding=0 debe declarar TODOS los miembros en el mismo orden
// que el fragment shader para satisfacer el requisito std140 de GLSL.
layout(std140, binding = 0) uniform buf {
    mat4  qt_Matrix;
    float qt_Opacity;
    float lensUVX;         // Centro X de la píldora en UV (0..1)
    float lensUVY;         // Centro Y de la píldora en UV (0..1)
    float lensHalfWUV;     // Semiancho en UV (= pillWidth/2 / itemWidth)
    float lensHalfHUV;     // Semialtlura en UV (= pillHeight/2 / itemHeight)
    float cornerRadiusUV;  // Radio de esquina en UV-Y (= lensHalfHUV → píldora)
    float aspectRatio;     // itemWidth / itemHeight
    float aberration;      // Intensidad de aberración cromática en el borde
    float glowStrength;    // Intensidad del halo teal exterior
};

layout(location = 0) out vec2 qt_TexCoord0;

void main()
{
    qt_TexCoord0 = qt_MultiTexCoord0;
    gl_Position  = qt_Matrix * qt_Vertex;
}
