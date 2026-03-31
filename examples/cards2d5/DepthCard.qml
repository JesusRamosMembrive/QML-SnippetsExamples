// =============================================================================
// DepthCard.qml — Tarjeta interactiva con ilusión de profundidad 2.5D
// =============================================================================
// ARQUITECTURA DE CAPAS:
//
//   root (Item)
//   ├── cardBody (Rectangle)        ← superficie de la tarjeta
//   │   ├── accentStrip             ← franja de color
//   │   ├── círculos decorativos    ← fondo
//   │   ├── borde de acento         ← ring en hover
//   │   └── glare (OpacityMask)     ← reflejo especular
//   ├── textLayer (Item)            ← FUERA de cardBody — puede desbordarse
//   │   ├── tagBadge, iconCircle
//   │   ├── titleText, subtitleText
//   │   └── separator, metricRow
//   └── MouseArea
//
// POR QUÉ textLayer ES HERMANO (no hijo) de cardBody:
//   cardBody tiene layer.enabled:true para el DropShadow. Eso renderiza
//   cardBody y sus hijos en una textura offscreen del tamaño de cardBody,
//   recortando cualquier contenido que desborde. Al mover textLayer fuera,
//   puede sobrepasar los bordes de la tarjeta y crear la sensación de que
//   el texto "flota" visualmente por encima de la superficie.
//
// MODELO DE MOVIMIENTO:
//   - cardBody: Rotation X/Y + Translate Y (lift)
//   - textLayer: MISMA rotación que cardBody + parallax perspectivo + scale zoom
//   La rotación compartida mantiene el texto sobre el plano de la tarjeta;
//   el parallax adicional lo eleva perceptualmente a un plano distinto.
//
//   Perspectiva correcta (reproduce CSS preserve-3d):
//     shiftX = sin(tiltY_rad) * textZDepth
//     shiftY = -sin(tiltX_rad) * textZDepth
//   Scale en hover: P/(P−Z) = zoom perspectivo de estar más cerca del espectador.
// =============================================================================

import QtQuick
import Qt5Compat.GraphicalEffects
import utils

Item {
    id: root

    // ── API de contenido ──────────────────────────────────────────────────────
    property string title:    "Title"
    property string subtitle: "Subtitle"
    property string tagLabel: ""
    property color  accentColor: Style.mainColor
    property color  bgColor:     Style.cardColor

    // ── Parámetros de movimiento — tarjeta ────────────────────────────────────
    property real cardTiltStrength: 18
    property real cardLiftStrength: 10
    property real cardSpring:       5.0
    property real cardDamping:      0.65

    // ── Parámetros de profundidad — texto ─────────────────────────────────────
    property real textZDepth:      60    // profundidad virtual del texto (px)
    property real perspectiveDist: 800   // distancia de perspectiva simulada (px)
    property real textSpring:      2.0
    property real textDamping:     0.85
    property real textDetachLift:  12    // lift extra del contenido al despegarse

    // ── Visual ────────────────────────────────────────────────────────────────
    property real shadowIntensity: 0.4
    property bool glareEnabled:    true

    // ── Estado interno ────────────────────────────────────────────────────────
    property bool hovered: mouseArea.containsMouse
    readonly property real degToRad: Math.PI / 180
    readonly property real pointerNormX: root.hovered
                                       ? root.clamp((mouseArea.mouseX - root.width  / 2) / (root.width  / 2), -1, 1)
                                       : 0.0
    readonly property real pointerNormY: root.hovered
                                       ? root.clamp((mouseArea.mouseY - root.height / 2) / (root.height / 2), -1, 1)
                                       : 0.0
    readonly property real tiltTargetX: root.pointerNormY * root.cardTiltStrength
    readonly property real tiltTargetY: -root.pointerNormX * root.cardTiltStrength
    property real textDepthProgress: root.hovered ? 1.0 : 0.0
    readonly property real effectiveTextZDepth: root.textZDepth * root.textDepthProgress
    property real cardTiltX: root.tiltTargetX
    property real cardTiltY: root.tiltTargetY
    property real cardLiftY: root.hovered ? -root.cardLiftStrength : 0.0
    property real textParallaxX: root.hovered ? Math.sin(root.tiltTargetY * root.degToRad) * root.effectiveTextZDepth : 0.0
    property real textParallaxY: root.hovered ? -Math.sin(root.tiltTargetX * root.degToRad) * root.effectiveTextZDepth : 0.0
    property real textScale: root.perspectiveDist / (root.perspectiveDist - root.effectiveTextZDepth)
    property real textDetachY: -Style.resize(root.textDetachLift) * root.textDepthProgress

    // ── Behaviors ─────────────────────────────────────────────────────────────
    // Mientras hay hover, el tilt sigue al puntero sin interpolación temporal,
    // igual que en el patrón de Aceternity. El resorte se usa solo al salir.
    Behavior on cardTiltX  { enabled: !root.hovered; SpringAnimation { spring: root.cardSpring; damping: root.cardDamping } }
    Behavior on cardTiltY  { enabled: !root.hovered; SpringAnimation { spring: root.cardSpring; damping: root.cardDamping } }
    Behavior on cardLiftY  { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
    Behavior on textDepthProgress { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
    Behavior on textParallaxX { enabled: !root.hovered; SpringAnimation { spring: root.textSpring; damping: root.textDamping } }
    Behavior on textParallaxY { enabled: !root.hovered; SpringAnimation { spring: root.textSpring; damping: root.textDamping } }

    function clamp(value, minValue, maxValue) {
        return Math.max(minValue, Math.min(maxValue, value))
    }

    // =========================================================================
    // CAPA 1: Superficie de la tarjeta
    // =========================================================================
    Rectangle {
        id: cardBody
        anchors.fill: parent
        color:  root.bgColor
        radius: Style.resize(16)

        // Sombra: el offset horizontal sigue la inclinación Y para dar sensación
        // de fuente de luz fija arriba. El radio crece con la elevación.
        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: root.cardTiltY * 0.5
            verticalOffset:   Style.resize(6) + root.cardLiftY * 0.7 - root.cardTiltX * 0.4
            radius:           Style.resize(20) + root.cardLiftY * 1.5
            samples:          17
            color:            Qt.rgba(0, 0, 0,
                                      root.shadowIntensity
                                      + (root.cardLiftY / root.cardLiftStrength) * 0.18)
        }

        transform: [
            Rotation {
                origin.x: cardBody.width  / 2
                origin.y: cardBody.height / 2
                axis { x: 1; y: 0; z: 0 }
                angle: root.cardTiltX
            },
            Rotation {
                origin.x: cardBody.width  / 2
                origin.y: cardBody.height / 2
                axis { x: 0; y: 1; z: 0 }
                angle: root.cardTiltY
            },
            Translate { y: root.cardLiftY }
        ]

        // Franja de acento superior
        Rectangle {
            id: accentStrip
            anchors.top:   parent.top
            anchors.left:  parent.left
            anchors.right: parent.right
            height: Style.resize(4)
            color:  root.accentColor
            radius: Style.resize(16)
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left:   parent.left
                anchors.right:  parent.right
                height: parent.height / 2
                color:  root.accentColor
            }
        }

        // Círculo decorativo grande
        Rectangle {
            anchors.right:        parent.right
            anchors.bottom:       parent.bottom
            anchors.rightMargin:  Style.resize(-30)
            anchors.bottomMargin: Style.resize(-30)
            width:  Style.resize(160)
            height: Style.resize(160)
            radius: width / 2
            color:  root.accentColor
            opacity: 0.07
        }

        // Círculo decorativo pequeño
        Rectangle {
            anchors.right:       parent.right
            anchors.top:         parent.top
            anchors.rightMargin: Style.resize(20)
            anchors.topMargin:   Style.resize(60)
            width:  Style.resize(80)
            height: Style.resize(80)
            radius: width / 2
            color:  root.accentColor
            opacity: 0.05
        }

        // Borde de acento: se intensifica en hover
        Rectangle {
            anchors.fill: parent
            radius:       parent.radius
            color:        "transparent"
            border.width: Style.resize(1)
            border.color: Qt.rgba(root.accentColor.r, root.accentColor.g,
                                  root.accentColor.b, root.hovered ? 0.55 : 0.15)
            Behavior on border.color { ColorAnimation { duration: 250 } }
        }

        // Glare especular
        Item {
            id: glareContainer
            anchors.fill: parent
            visible:  root.glareEnabled && opacity > 0.01
            opacity:  root.hovered ? 1.0 : 0.0
            Behavior on opacity { NumberAnimation { duration: 400 } }

            layer.enabled: visible
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width:  glareContainer.width
                    height: glareContainer.height
                    radius: cardBody.radius
                }
            }

            Rectangle {
                width:    glareContainer.width  * 2.5
                height:   glareContainer.height * 2.5
                // Posición se bindea a valores ya animados por SpringAnimation
                x: glareContainer.width  / 2 - width  / 2 - root.cardTiltY * 5
                y: glareContainer.height / 2 - height / 2 + root.cardTiltX * 5
                rotation: -35
                gradient: Gradient {
                    GradientStop { position: 0.00; color: "transparent" }
                    GradientStop { position: 0.35; color: "transparent" }
                    GradientStop { position: 0.43; color: Qt.rgba(1, 1, 1, 0.03) }
                    GradientStop { position: 0.48; color: Qt.rgba(1, 1, 1, 0.09) }
                    GradientStop { position: 0.50; color: Qt.rgba(1, 1, 1, 0.13) }
                    GradientStop { position: 0.52; color: Qt.rgba(1, 1, 1, 0.09) }
                    GradientStop { position: 0.57; color: Qt.rgba(1, 1, 1, 0.03) }
                    GradientStop { position: 0.65; color: "transparent" }
                    GradientStop { position: 1.00; color: "transparent" }
                }
            }
        }
    }

    // =========================================================================
    // CAPA 2: Texto flotante
    // =========================================================================
    // textLayer es HERMANO de cardBody, no hijo.
    // Comparte la misma rotación 3D (para estar sobre el plano de la tarjeta)
    // más el desplazamiento de paralaje perspectivo y el zoom.
    // Al estar fuera de layer.enabled, puede desbordarse libremente:
    // el iconCircle o el badge pueden sobrepasar el borde de la tarjeta,
    // creando la sensación de que hay un elemento delante de otro.
    Item {
        id: textLayer
        anchors.fill: parent

        transform: [
            // Misma rotación que cardBody para que el texto esté sobre el plano
            Rotation {
                origin.x: textLayer.width  / 2
                origin.y: textLayer.height / 2
                axis { x: 1; y: 0; z: 0 }
                angle: root.cardTiltX
            },
            Rotation {
                origin.x: textLayer.width  / 2
                origin.y: textLayer.height / 2
                axis { x: 0; y: 1; z: 0 }
                angle: root.cardTiltY
            },
            // Zoom perspectivo (P/(P-Z)) centrado en el ítem
            Scale {
                origin.x: textLayer.width  / 2
                origin.y: textLayer.height / 2
                xScale: root.textScale
                yScale: root.textScale
            },
            // Parallax perspectivo + lift compartido con cardBody
            Translate {
                x: root.textParallaxX
                y: root.textParallaxY + root.cardLiftY + root.textDetachY
            }
        ]

        // Badge
        Rectangle {
            id: tagBadge
            visible: root.tagLabel.length > 0
            anchors.top:         parent.top
            anchors.right:       parent.right
            anchors.topMargin:   Style.resize(20)
            anchors.rightMargin: Style.resize(20)
            width:  tagText.implicitWidth + Style.resize(16)
            height: Style.resize(22)
            radius: Style.resize(11)
            color:  root.accentColor
            opacity: 0.9
            Text {
                id: tagText
                anchors.centerIn: parent
                text:           root.tagLabel
                font.pixelSize: Style.resize(11)
                font.bold:      true
                color:          "#FFFFFF"
            }
        }

        // Avatar con inicial del título
        // Cuando el parallax es pronunciado este círculo puede sobrepasar
        // el borde superior de la tarjeta, reforzando la ilusión de profundidad.
        Rectangle {
            id: iconCircle
            anchors.top:        parent.top
            anchors.left:       parent.left
            // accentStrip mide Style.resize(4), de ahí los 4+28 = 32 de margen
            anchors.topMargin:  Style.resize(32)
            anchors.leftMargin: Style.resize(24)
            width:  Style.resize(44)
            height: Style.resize(44)
            radius: width / 2
            color:  Qt.rgba(root.accentColor.r, root.accentColor.g,
                            root.accentColor.b, 0.18)
            border.color: root.accentColor
            border.width: Style.resize(1)
            Text {
                anchors.centerIn: parent
                text:           root.title.length > 0 ? root.title[0] : "?"
                font.pixelSize: Style.resize(20)
                font.bold:      true
                color:          root.accentColor
            }
        }

        // Título principal
        Text {
            id: titleText
            anchors.top:         iconCircle.bottom
            anchors.left:        parent.left
            anchors.right:       parent.right
            anchors.topMargin:   Style.resize(18)
            anchors.leftMargin:  Style.resize(24)
            anchors.rightMargin: Style.resize(24)
            text:           root.title
            font.pixelSize: Style.fontSizeL
            font.bold:      true
            color:          Style.fontPrimaryColor
            elide:          Text.ElideRight
        }

        // Subtítulo
        Text {
            id: subtitleText
            anchors.top:         titleText.bottom
            anchors.left:        parent.left
            anchors.right:       parent.right
            anchors.topMargin:   Style.resize(8)
            anchors.leftMargin:  Style.resize(24)
            anchors.rightMargin: Style.resize(24)
            text:           root.subtitle
            font.pixelSize: Style.fontSizeS
            color:          Style.fontSecondaryColor
            wrapMode:       Text.WordWrap
        }

        // Separador
        Rectangle {
            anchors.bottom:       metricRow.top
            anchors.left:         parent.left
            anchors.right:        parent.right
            anchors.leftMargin:   Style.resize(24)
            anchors.rightMargin:  Style.resize(24)
            anchors.bottomMargin: Style.resize(12)
            height:  Style.resize(1)
            color:   root.accentColor
            opacity: 0.25
        }

        // Fila de métricas
        Row {
            id: metricRow
            anchors.bottom:       parent.bottom
            anchors.left:         parent.left
            anchors.right:        parent.right
            anchors.bottomMargin: Style.resize(24)
            anchors.leftMargin:   Style.resize(24)
            spacing: Style.resize(8)
            Rectangle {
                width:  Style.resize(8)
                height: Style.resize(8)
                radius: width / 2
                color:  root.accentColor
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: "Z " + root.textZDepth.toFixed(0)
                      + "px · return " + root.textSpring.toFixed(1)
                font.pixelSize: Style.resize(12)
                color:          Style.fontSecondaryColor
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    // ── MouseArea ─────────────────────────────────────────────────────────────
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape:  Qt.PointingHandCursor
    }
}
