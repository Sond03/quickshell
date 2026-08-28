import QtQuick
import Quickshell.Services.UPower
import Quickshell
import Quickshell.Io

import "./" as Processes 
import "../Colors/"

PopupWindow {
    id: popup
    width: 160
    height: 50
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 14

    color: "transparent"

    property bool isHovered: false 
    property string timeTo: ""

    visible: isHovered || localMouse.containsMouse || container.opacity > 0

    function batTime() {
        var full = UPower.displayDevice.timeToFull
        var empty = UPower.displayDevice.timeToEmpty
        var secs = UPower.displayDevice.timeToFull > 0
            ? UPower.displayDevice.timeToFull
            : UPower.displayDevice.timeToEmpty
        var hours = Math.floor(secs / 3600)
        var minutes = Math.floor((secs % 3600) / 60)
        var label = full  > 0 ? "Full in " : "Empty in " 
        return label + hours + "h " + minutes + "m"
    }

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
        }

        Column {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 10

            Text {
                text: popup.batTime()
                color: Colors.blue
                font { pixelSize: Colors.regular ; bold: true; family: Colors.fontFamily }
            }
        }
    }
}

