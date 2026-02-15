#!/bin/bash

# Script para hacer un rebuild completo del proyecto
# Usar cuando cambies nombres de bibliotecas, módulos QML o estructura de plugins

# Detectar la ruta de Qt automáticamente
QT_PATH=""
if [ -d "$HOME/Qt/6.10.2/gcc_64" ]; then
    QT_PATH="$HOME/Qt/6.10.2/gcc_64"
elif [ -d "$HOME/Qt/6.10.0/gcc_64" ]; then
    QT_PATH="$HOME/Qt/6.10.0/gcc_64"
elif [ -d "/opt/Qt/6.10.2/gcc_64" ]; then
    QT_PATH="/opt/Qt/6.10.2/gcc_64"
fi

if [ -z "$QT_PATH" ]; then
    echo "❌ No se pudo encontrar la instalación de Qt"
    echo "Por favor, especifica la ruta manualmente:"
    echo "  export CMAKE_PREFIX_PATH=/ruta/a/Qt/6.x.x/gcc_64"
    echo "  ./rebuild.sh"
    exit 1
fi

echo "📍 Usando Qt en: $QT_PATH"
echo ""

echo "🗑️  Eliminando directorio build..."
rm -rf build

echo ""
echo "🔧 Configurando CMake..."
cmake -B build -S . -DCMAKE_PREFIX_PATH="$QT_PATH"

if [ $? -ne 0 ]; then
    echo "❌ Error en la configuración de CMake"
    exit 1
fi

echo ""
echo "🔨 Compilando proyecto..."
cmake --build build

if [ $? -ne 0 ]; then
    echo "❌ Error en la compilación"
    exit 1
fi

echo ""
echo "✅ Rebuild completo terminado exitosamente"
echo ""
echo "Puedes ejecutar la aplicación con:"
echo "  ./build/Desktop_Qt_6_10_2-Debug/QDashboardApp"
echo ""
echo "O desde Qt Creator con el botón Run"
