import QtQuick
import Quickshell
import Quickshell.Wayland

import "./Processes.qml" as Processes 
import "../Colors"

PanelWindow {
    id: popup
    implicitWidth: 205
    implicitHeight: 200

    color: "transparent"

    property bool isHovered: false 
    property bool isPinned: false
    property string procData: ""

    visible: isHovered || isPinned || container.opacity > 0

    anchors{
        top: true
        right:true
    }
    margins{
        right: 5
    }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "memoryWidget:quickshell"
    exclusionMode: ExclusionMode.Normal

    Rectangle {
        id: container
        anchors.fill: parent
        color: Colors.bg
        border.color: Colors.blue
        border.width: 1
        radius: 8

        scale: (popup.isHovered) ? 1.0 : 0.85
        opacity: (popup.isHovered) ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: container.opacity > 0 ? 200 : 200 } }

        Behavior on scale{
            SpringAnimation { 
                spring: 5
                damping: 0.4
                mass: 1
            }
        }

        MouseArea {
            id: localMouse
            anchors.fill: parent
            hoverEnabled: true
            enabled: popup.visible
            onClicked: isPinned = !isPinned
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        }

        Column {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 10

            Text {
                text: "Most mem usage"
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                color: Colors.blue
                font { pixelSize: Colors.small ; bold: true; family: Colors.fontFamily }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Colors.muted
            }

            Text {
                text: popup.procData || "Data parsing...." 
                color: Colors.white
                font { pixelSize: Colors.small ; bold: true; family: Colors.fontFamily }
                lineHeight: 1.5
            }
        }
    }
}
