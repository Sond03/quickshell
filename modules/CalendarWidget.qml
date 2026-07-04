import QtQuick
import Quickshell
import Quickshell.Io

import "../Colors"

PopupWindow {
    id: popup
    implicitWidth: 250
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
        AsciiClock{
            id: clock
            anchors.horizontalCenter: parent.horizontalCenter 
            y: 10
            clock: sysClock
            digitColor: Colors.blue
            size: 6
        }
    }
}


