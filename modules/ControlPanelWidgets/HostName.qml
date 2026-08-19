import QtQuick
import QtQuick.Layouts
import qs.components
import qs.modules
import qs.Colors

RowLayout {
    spacing: 10
    StyledRectangle {
        height: text.implicitHeight - 10
        width: text.implicitHeight - 10
        color: Colors.base
        border.color: Qt.rgba(Colors.purple.r, Colors.purple.g, Colors.purple.b, 0.35)
        border.width: 1

        StyledText{
            text: "" 
            color: Colors.purple
            font.pixelSize: text.implicitHeight - 20
            anchors.centerIn: parent
        }
    }

    ColumnLayout{ 
        id: text
        spacing: 2
        Layout.fillWidth: true
        StyledText{
            text: "Hostname"
            color: Colors.purple
            font.pixelSize: Colors.small -1
            font.bold: true
        }
        StyledText{
            text: Processes.hostname
            font.pixelSize: Colors.small -1
        }
    }
} 

