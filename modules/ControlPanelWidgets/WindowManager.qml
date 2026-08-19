import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.components
import qs.modules
import qs.Colors

RowLayout {
    spacing: 10
    StyledRectangle {
        height: text.implicitHeight - 10
        width: text.implicitHeight - 10
        color: Colors.base
        border.color: Qt.rgba(Colors.blue.r, Colors.blue.g, Colors.blue.b, 0.35)
        border.width: 1

        StyledText{
            text: "" 
            color: Colors.blue
            font.pixelSize: text.implicitHeight - 20
            anchors.centerIn: parent
        }
    }

    ColumnLayout{ 
        id: text
        spacing: 2
        Layout.fillWidth: true
        StyledText{
            text: "Window Manager"
            color: Colors.blue
            font.pixelSize: Colors.small -1
            font.bold: true
        }
        StyledText{
            text: Processes.wm
            font.pixelSize: Colors.small -1
        }
    }
} 
