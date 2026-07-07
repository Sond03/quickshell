import QtQuick
import Quickshell

import "./Processes.qml" as Processes 
import "../Colors"

PopupWindow {
    id: popup
    implicitWidth: 205
    implicitHeight: 200

    color: "transparent"

    property bool isHovered: false 
    property bool isPinned: false
    property string procData: ""

    visible: isHovered || isPinned || container.opacity > 0

    Rectangle {
        id: container
        anchors.fill: parent
        color: Colors.bg
        border.color: Colors.blue
        border.width: 1
        radius: 8

        opacity: (popup.isHovered) ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: container.opacity > 0 ? 500 : 200 } }

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
