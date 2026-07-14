import Quickshell
import QtQuick

import "../Colors/"

Rectangle { 
    id: root
    radius: height / 2
    width: 25
    height: 25
    color: Qt.rgba(1, 1, 1, mouseArea.containsMouse ? 0.16 : 0.08)
    border.color: Qt.rgba(1, 1, 1, 0.22)
    border.width: 1
    scale: mouseArea.pressed ? 0.9 : 1.0
    signal clicked()

    Behavior on color { ColorAnimation { duration: 120 } }
    Behavior on border.color { ColorAnimation { duration: 120 } }
    Behavior on scale { NumberAnimation { duration: 80; easing.type: Easing.OutCubic } }

    default property alias content: root.children

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
