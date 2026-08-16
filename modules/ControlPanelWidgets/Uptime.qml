import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.components
import qs.modules
import qs.Colors

StyledRectangle {
    id: uptimeBg
    color: Colors.bg
    implicitHeight: topBg.implicitHeight - 10
    implicitWidth: uptimeContent.implicitWidth + 10
    RowLayout {
        id: uptimeContent
        spacing: 10
        anchors.centerIn: parent
        StyledRectangle {
            height: 25
            width: 25
            color: Qt.rgba(Colors.cBlue.r, Colors.cBlue.g, Colors.cBlue.b, 0.2)
            StyledText{
                id:timeIcon
                text: "󰔟" 
                color: Colors.cBlue
                font.pixelSize: 25
                anchors.centerIn: parent
            }
        }

        ColumnLayout{ 
            spacing: 2
            Layout.fillWidth: true
            StyledText{
                text: "System Uptime"
                color: Colors.emerald
                font.pixelSize: Colors.tiny
                font.bold: true
            }
            StyledText{
                text: Processes.uptime
                Layout.leftMargin: 5
            }
        }
    } 
}
