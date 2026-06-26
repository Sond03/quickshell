import QtQuick
import Quickshell
import Quickshell.Io

import "../Colors"

PopupWindow {
    id: popup
    width: 250
    height: 200
    anchor.window: root
    anchor.rect.x: parentWindow.width / 2 - width / 2
    anchor.rect.y: parentWindow.height

    color: "transparent"

    property bool isHovered: false 
    property string procData: ""

    visible: isHovered || calendarMouse.containsMouse  || container.opacity > 0

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
            id: calendarMouse
            anchors.fill: parent
            hoverEnabled: true
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


