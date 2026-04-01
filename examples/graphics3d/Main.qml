import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick3D
import utils

Item {
    id: root

    property bool fullSize: false

    opacity: fullSize ? 1.0 : 0.0
    visible: opacity > 0.0
    Behavior on opacity { NumberAnimation { duration: 200 } }

    anchors.fill: parent

    // Propiedades personalizables de la escena
    property real animSpeed: 1.0
    property string shape1: "#Cube"
    property string shape2: "#Sphere"
    property color color1: Style.mainColor
    property color color2: Style.fontPrimaryColor
    property real lightIntensity: 1.0
    property int moveType: 0 // 0: Suave, 1: Ondulado, 2: Saltos

    Rectangle {
        anchors.fill: parent
        color: Style.bgColor

        View3D {
            id: view
            anchors.fill: parent
            anchors.rightMargin: controlPanel.width
            
            environment: SceneEnvironment {
                clearColor: Style.bgColor
                backgroundMode: SceneEnvironment.Color
                antialiasingMode: SceneEnvironment.MSAA
                antialiasingQuality: SceneEnvironment.High
            }

            PerspectiveCamera {
                id: camera
                position: Qt.vector3d(0, 200, 300)
                eulerRotation.x: -30
            }

            DirectionalLight {
                eulerRotation.x: -30
                eulerRotation.y: -70
                color: Qt.rgba(1.0, 1.0, 1.0, 1.0)
                ambientColor: Qt.rgba(0.2, 0.2, 0.2, 1.0)
                brightness: lightIntensity
            }

            // Figura 1: Izquierda (Rota en dos ejes)
            Model {
                position: Qt.vector3d(-100, 0, 0)
                source: shape1
                materials: [ DefaultMaterial {
                        diffuseColor: color1
                    }
                ]
                
                NumberAnimation on eulerRotation.y {
                    loops: Animation.Infinite
                    from: 0
                    to: 360
                    duration: 4000 / animSpeed
                }
                NumberAnimation on eulerRotation.x {
                    loops: Animation.Infinite
                    from: 0
                    to: 360
                    duration: 5000 / animSpeed
                }
            }

            // Figura 2: Derecha (Flota)
            Model {
                position: Qt.vector3d(100, 0, 0)
                source: shape2
                materials: [ DefaultMaterial {
                        diffuseColor: color2
                    }
                ]
                
                SequentialAnimation on position.y {
                    running: moveType === 0
                    loops: Animation.Infinite
                    NumberAnimation {
                        from: -50
                        to: 50
                        duration: 2000 / animSpeed
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        from: 50
                        to: -50
                        duration: 2000 / animSpeed
                        easing.type: Easing.InOutQuad
                    }
                }

                NumberAnimation on position.y {
                    running: moveType === 1
                    loops: Animation.Infinite
                    from: -50
                    to: 50
                    duration: 2000 / animSpeed
                    easing.type: Easing.SineCurve
                }

                SequentialAnimation on position.y {
                    running: moveType === 2
                    loops: Animation.Infinite
                    NumberAnimation { to: -30; duration: 500 / animSpeed; easing.type: Easing.OutBounce }
                    PauseAnimation { duration: 500 / animSpeed }
                    NumberAnimation { to: 60; duration: 500 / animSpeed; easing.type: Easing.OutBounce }
                    PauseAnimation { duration: 500 / animSpeed }
                }
            }
        }

        // Overlay text
        Label {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: Style.resize(20)
            text: "Qt Quick 3D Demo\n- Rotación\n- Levitación"
            color: Style.fontPrimaryColor
            font.pixelSize: Style.resize(16)
            opacity: 0.8
        }
        
        // Panel lateral de controles
        Rectangle {
            id: controlPanel
            width: Style.resize(320)
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            color: Style.cardColor
            
            // Fina línea de separación
            Rectangle {
                width: 1
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                color: Style.surfaceColor
            }
            
            ScrollView {
                anchors.fill: parent
                anchors.margins: Style.resize(25)
                contentWidth: availableWidth
                clip: true
                
                ColumnLayout {
                    width: parent.width
                    spacing: Style.resize(15)
                    
                    Label {
                        text: "Panel de Personalización"
                        color: Style.fontPrimaryColor
                        font.pixelSize: Style.resize(18)
                        font.bold: true
                        Layout.bottomMargin: Style.resize(10)
                    }
                    
                    // Controles Globales
                    Label { text: "Velocidad Animación"; color: Style.fontSecondaryColor }
                    Slider {
                        Layout.fillWidth: true
                        from: 0.2
                        to: 4.0
                        value: animSpeed
                        onValueChanged: animSpeed = value
                    }
                    
                    Label { text: "Intensidad de Luz"; color: Style.fontSecondaryColor }
                    Slider {
                        Layout.fillWidth: true
                        from: 0.0
                        to: 3.0
                        value: lightIntensity
                        onValueChanged: lightIntensity = value
                    }
                    
                    Rectangle { Layout.fillWidth: true; height: 1; color: Style.surfaceColor; Layout.topMargin: 10; Layout.bottomMargin: 10 }
                    
                    // Controles Figura 1
                    Label { text: "Figura 1 (Izquierda)"; color: Style.fontPrimaryColor; font.bold: true }
                    ComboBox {
                        Layout.fillWidth: true
                        model: ["#Cube", "#Sphere", "#Cone", "#Cylinder", "#Rectangle"]
                        onCurrentTextChanged: shape1 = currentText
                    }
                    
                    Label { text: "Color"; color: Style.fontSecondaryColor }
                    RowLayout {
                        spacing: 12
                        Repeater {
                            model: ["#E74C3C", "#3498DB", "#2ECC71", "#F1C40F", "#9B59B6"]
                            Rectangle {
                                width: Style.resize(30); height: width; radius: width/2
                                color: modelData
                                border.color: color1 == modelData ? Style.fontPrimaryColor : "transparent"
                                border.width: 2
                                MouseArea { anchors.fill: parent; onClicked: color1 = modelData }
                            }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: Style.surfaceColor; Layout.topMargin: 10; Layout.bottomMargin: 10 }
                    
                    // Controles Figura 2
                    Label { text: "Figura 2 (Derecha)"; color: Style.fontPrimaryColor; font.bold: true }
                    ComboBox {
                        Layout.fillWidth: true
                        model: ["#Sphere", "#Cube", "#Cone", "#Cylinder", "#Rectangle"]
                        onCurrentTextChanged: shape2 = currentText
                    }
                    
                    Label { text: "Estilo de Flotación"; color: Style.fontSecondaryColor }
                    ComboBox {
                        Layout.fillWidth: true
                        model: ["Suave (Linear)", "Ondulado (Sine)", "Saltos (Bounce)"]
                        currentIndex: moveType
                        onCurrentIndexChanged: moveType = currentIndex
                    }
                    
                    Label { text: "Color"; color: Style.fontSecondaryColor }
                    RowLayout {
                        spacing: 12
                        Repeater {
                            model: ["#1ABC9C", "#E67E22", "#E84393", "#34495E", "#FFFFFF"]
                            Rectangle {
                                width: Style.resize(30); height: width; radius: width/2
                                color: modelData
                                border.color: color2 == modelData ? Style.fontPrimaryColor : "transparent"
                                border.width: 2
                                MouseArea { anchors.fill: parent; onClicked: color2 = modelData }
                            }
                        }
                    }
                }
            }
        }
    }
}
