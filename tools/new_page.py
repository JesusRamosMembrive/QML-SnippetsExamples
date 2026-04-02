#!/usr/bin/env python3
"""
new_page.py — CLI para crear y registrar una nueva página de ejemplo en QML Snippets Examples.

Uso:
    python tools/new_page.py <NombrePagina> [--uri <uri>] [--dry-run]

Ejemplos:
    python tools/new_page.py Calendario
    python tools/new_page.py WebSockets --uri websockets
    python tools/new_page.py NuevaPagina --dry-run

El script realiza automáticamente los 6 pasos manuales:
    1. Crea examples/<uri>/CMakeLists.txt
    2. Crea examples/<uri>/qmldir
    3. Crea examples/<uri>/Main.qml
    4. Añade add_subdirectory(<uri>) en examples/CMakeLists.txt
    5. Añade el target de enlace en qmlmodules
    6. Añade la entrada en Dashboard.qml (pageMap)
    7. Añade la entrada en MainMenuList.qml (menuModel)

Tras ejecutar el script, se requiere un clean rebuild:
    rm -rf build && cmake -B build -S . && cmake --build build
"""

import argparse
import re
import sys
from pathlib import Path

# ---------------------------------------------------------------------------
# Rutas relativas a la raíz del proyecto
# ---------------------------------------------------------------------------
SCRIPT_DIR  = Path(__file__).resolve().parent
PROJECT_DIR = SCRIPT_DIR.parent

EXAMPLES_CMAKE   = PROJECT_DIR / "examples" / "CMakeLists.txt"
QMLMODULES       = PROJECT_DIR / "qmlmodules"
DASHBOARD_QML    = PROJECT_DIR / "mainui" / "home" / "Dashboard.qml"
MAIN_MENU_QML    = PROJECT_DIR / "mainui" / "mainmenu" / "MainMenuList.qml"


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def to_uri(name: str) -> str:
    """Convierte 'MiPagina' → 'mipagina' (URI del módulo QML, siempre minúsculas)."""
    return name.lower()


def lib_name(uri: str) -> str:
    """Nombre de la biblioteca estática: <uri>plugin."""
    return f"{uri}plugin"


def link_target(uri: str) -> str:
    """Target de enlace CMake: <uri>pluginplugin (doble plugin)."""
    return f"{uri}pluginplugin"


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def write(path: Path, content: str, dry_run: bool) -> None:
    if dry_run:
        print(f"  [dry-run] Escribiría {path.relative_to(PROJECT_DIR)}")
    else:
        path.write_text(content, encoding="utf-8")
        print(f"  ✓ {path.relative_to(PROJECT_DIR)}")


def patch(path: Path, old: str, new: str, dry_run: bool) -> None:
    content = read(path)
    if old not in content:
        print(f"  ✗ No se encontró el marcador en {path.relative_to(PROJECT_DIR)}")
        print(f"    Buscado: {repr(old[:80])}")
        sys.exit(1)
    patched = content.replace(old, new, 1)
    write(path, patched, dry_run)


# ---------------------------------------------------------------------------
# Generadores de contenido de archivos
# ---------------------------------------------------------------------------

def gen_cmake(uri: str, name: str) -> str:
    lib = lib_name(uri)
    return f"""\
# =============================================================================
# CMakeLists.txt — Módulo de ejemplo "{name}"
# =============================================================================
qt_add_library({lib} STATIC)
qt_add_qml_module({lib}
    URI "{uri}"
    VERSION 1.0
    QML_FILES
        Main.qml
)
"""


def gen_qmldir(uri: str) -> str:
    return f"""\
# =============================================================================
# qmldir — Manifiesto del módulo de ejemplo "{uri}"
# =============================================================================
module {uri}
Main 1.0 Main.qml
"""


def gen_main_qml(name: str, uri: str) -> str:
    return f"""\
// =============================================================================
// Main.qml — Página de ejemplo "{name}"
// =============================================================================
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import utils 1.0
import qmlsnippetsstyle

Item {{
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity {{
        NumberAnimation {{ duration: 200 }}
    }}

    anchors.fill: parent

    Rectangle {{
        anchors.fill: parent
        color: Style.bgColor

        ScrollView {{
            id: scrollView
            anchors.fill: parent
            anchors.margins: Style.resize(40)
            clip: true
            contentWidth: availableWidth

            ColumnLayout {{
                width: scrollView.availableWidth
                spacing: Style.resize(40)

                Label {{
                    text: "{name} Examples"
                    font.pixelSize: Style.resize(32)
                    font.bold: true
                    color: Style.mainColor
                    Layout.fillWidth: true
                }}

                // TODO: añadir tarjetas de ejemplo aquí
            }}
        }}
    }}
}}
"""


# ---------------------------------------------------------------------------
# Pasos de registro
# ---------------------------------------------------------------------------

def step_create_files(uri: str, name: str, dry_run: bool) -> None:
    """Paso 1–3: Crea la carpeta y los tres archivos del módulo."""
    example_dir = PROJECT_DIR / "examples" / uri

    if example_dir.exists():
        print(f"\n  ✗ Ya existe el directorio: examples/{uri}/")
        sys.exit(1)

    print("\n[1/5] Creando archivos del módulo...")
    if not dry_run:
        example_dir.mkdir(parents=True)

    write(example_dir / "CMakeLists.txt", gen_cmake(uri, name), dry_run)
    write(example_dir / "qmldir",         gen_qmldir(uri),      dry_run)
    write(example_dir / "Main.qml",       gen_main_qml(name, uri), dry_run)


def step_examples_cmake(uri: str, dry_run: bool) -> None:
    """Paso 4: Añade add_subdirectory(<uri>) al final de examples/CMakeLists.txt."""
    print("\n[2/5] Registrando en examples/CMakeLists.txt...")
    content = read(EXAMPLES_CMAKE)
    # Busca el último add_subdirectory existente para insertar después
    matches = list(re.finditer(r"^add_subdirectory\(\w+\)", content, re.MULTILINE))
    if not matches:
        print("  ✗ No se encontraron entradas add_subdirectory en examples/CMakeLists.txt")
        sys.exit(1)
    last_end = matches[-1].end()
    new_line = f"\nadd_subdirectory({uri})"
    patched = content[:last_end] + new_line + content[last_end:]
    write(EXAMPLES_CMAKE, patched, dry_run)


def step_qmlmodules(uri: str, dry_run: bool) -> None:
    """Paso 5: Añade el link target en qmlmodules al final del bloque drawers (último entry)."""
    print("\n[3/5] Añadiendo link target en qmlmodules...")
    target = link_target(uri)
    content = read(QMLMODULES)

    # Busca el último target antes del cierre del target_link_libraries
    closing = ")"
    # Encuentra el último xxxpluginplugin antes del ")"
    matches = list(re.finditer(r"^\s+\w+pluginplugin\b", content, re.MULTILINE))
    if not matches:
        print("  ✗ No se encontraron targets pluginplugin en qmlmodules")
        sys.exit(1)
    last = matches[-1]
    indent = re.match(r"^\s+", last.group()).group()
    new_line = f"\n{indent}{target}"
    patched = content[:last.end()] + new_line + content[last.end():]
    write(QMLMODULES, patched, dry_run)


def step_dashboard(name: str, uri: str, dry_run: bool) -> None:
    """Paso 6: Añade la entrada en el pageMap de Dashboard.qml."""
    print("\n[4/5] Añadiendo entrada en Dashboard.qml (pageMap)...")
    content = read(DASHBOARD_QML)

    # Busca el último entry del pageMap: puede o no tener coma al final
    pattern = r'"[\w]+"\s*:\s*"qrc:/qt/qml/\w+/Main\.qml",?'
    matches = list(re.finditer(pattern, content))
    if not matches:
        print("  ✗ No se encontraron entradas en pageMap de Dashboard.qml")
        sys.exit(1)
    last = matches[-1]
    last_text = last.group()
    entry = f'"{name}":      "qrc:/qt/qml/{uri}/Main.qml"'

    # Asegura que el entry anterior tenga coma y añade el nuevo sin coma
    if not last_text.rstrip().endswith(","):
        replacement = last_text + f",\n        {entry}"
    else:
        replacement = last_text + f"\n        {entry}"
    patched = content[:last.start()] + replacement + content[last.end():]
    write(DASHBOARD_QML, patched, dry_run)


def step_main_menu(name: str, dry_run: bool) -> None:
    """Paso 7: Añade ListElement en MainMenuList.qml."""
    print("\n[5/5] Añadiendo entrada en MainMenuList.qml...")
    content = read(MAIN_MENU_QML)

    # Busca el último ListElement { name: "..." }
    pattern = r'ListElement \{ name: "[^"]*" \}'
    matches = list(re.finditer(pattern, content))
    if not matches:
        print("  ✗ No se encontraron ListElement en MainMenuList.qml")
        sys.exit(1)
    last = matches[-1]
    indent_match = re.match(r'^(\s*)', content[:last.start()].rsplit('\n', 1)[-1] + 'x')
    indent = indent_match.group(1) if indent_match else "        "
    new_entry = f'\n{indent}ListElement {{ name: "{name}" }}'
    patched = content[:last.end()] + new_entry + content[last.end():]
    write(MAIN_MENU_QML, patched, dry_run)


# ---------------------------------------------------------------------------
# Entrypoint
# ---------------------------------------------------------------------------

def main() -> None:
    parser = argparse.ArgumentParser(
        description="Crea y registra una nueva página de ejemplo en QML Snippets Examples."
    )
    parser.add_argument(
        "name",
        help="Nombre visible de la página (e.g. 'Calendario', 'WebSockets'). "
             "Debe coincidir exactamente con la clave del menú."
    )
    parser.add_argument(
        "--uri",
        help="URI/carpeta del módulo QML (default: name.lower()). "
             "Ejemplo: --uri websocketex"
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Muestra qué haría sin escribir nada."
    )
    args = parser.parse_args()

    name    = args.name
    uri     = args.uri if args.uri else to_uri(name)
    dry_run = args.dry_run

    print(f"Nueva página: '{name}'  |  URI: '{uri}'  |  lib: '{lib_name(uri)}'  |  target: '{link_target(uri)}'")
    if dry_run:
        print("(modo dry-run — no se escribe nada)\n")

    step_create_files(uri, name, dry_run)
    step_examples_cmake(uri, dry_run)
    step_qmlmodules(uri, dry_run)
    step_dashboard(name, uri, dry_run)
    step_main_menu(name, dry_run)

    print("\n✓ Listo. Ahora ejecuta un clean rebuild:")
    print("  rm -rf build && cmake -B build -S . && cmake --build build")
    print("  (o: ./rebuild.sh)\n")


if __name__ == "__main__":
    main()
