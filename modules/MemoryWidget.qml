import QtQuick
import Quickshell

import "./Processes.qml" as Processes 

PopupWindow {
    id: popup
    width: 250
    height: 200
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 14

    color: "transparent"

    property bool isHovered: false 
    property string procData: ""

    visible: isHovered || localMouse.containsMouse || container.opacity > 0

    Rectangle {
        id: container
        anchors.fill: parent
        color: "#1a1b26"
        border.color: "#7aa2f7"
        border.width: 1
        radius: 8

        opacity: (popup.isHovered) ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: container.opacity > 0 ? 500 : 200 } }

        MouseArea {
            id: localMouse
            anchors.fill: parent
            hoverEnabled: true
        }

        Column {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 10

            Text {
                text: "Processes with most usage"
                color: "#7aa2f7"
                font { pixelSize: popup.fontSize; bold: true; family: popup.fontFamily }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#444b6a"
            }

            Text {
                text: popup.procData || "Data parsing...." 
                color: "#eeeeee" 
                font { pixelSize: popup.fontSize; bold: true; family: popup.fontFamily }
                lineHeight: 1.5
            }
        }
    }
}
