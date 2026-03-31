# Guía de sustitución de iconos SVG

Los iconos del menú lateral se sirven desde `imports/assets/icons/` como archivos SVG.
`Style.icon(name)` devuelve `qrc:/assets/icons/<name>.svg`.

## Requisitos del SVG

- Nombre: igual al `ListElement { name: "..." }` en `MainMenuList.qml`, en **minúsculas**.
  - Ejemplo: `name: "TreeView"` → archivo `treeview.svg`
- Tamaño del viewBox: cualquiera, Qt escala automáticamente sin pérdida de calidad.
- Color: el icono se tiñe en tiempo de ejecución con `ColorOverlay`, así que el color
  del SVG no importa. Usa blanco `#FFFFFF` o cualquier color sólido monocromático.
- Sin rellenos semitransparentes ni gradientes: el `ColorOverlay` los ignorará mal.

## Dónde buscar SVGs

- [Google Material Symbols](https://fonts.google.com/icons) — Licencia Apache 2.0
- [Phosphor Icons](https://phosphoricons.com/) — Licencia MIT
- Exportar en formato SVG, cualquier tamaño (recomendado 24×24 o 48×48).

## Pasos para añadir un icono

1. Guarda el `.svg` en `imports/assets/icons/<nombre>.svg`

2. En `imports/assets/CMakeLists.txt`, descomenta (o añade) la línea correspondiente
   dentro del bloque `qt_add_resources(... "icons_svg" ...)`.
   Si el bloque entero está comentado, descomenta primero las líneas del bloque:

   ```cmake
   qt_add_resources(QMLSnippetsExamples "icons_svg"
       PREFIX "/assets"
       FILES
           icons/treeview.svg   # ← descomenta o añade aquí
   )
   ```

3. Recompila. **No hace falta clean rebuild**, basta con:

   ```bash
   cmake --build build
   ```

4. Comprueba en la app que el icono aparece correctamente en el menú.

## Notas

- Mientras un icono SVG no esté registrado en CMakeLists, el menú mostrará
  el espacio vacío para ese item (advertencia en consola `Cannot open: ...`).
- Los PNGs originales siguen en `icons/` y en el bloque `assets` del CMakeLists
  como legado; no interfieren con los SVGs.
