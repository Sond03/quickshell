import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.components
import qs.modules
import qs.Colors

StyledRectangle{
    color: Colors.bg
    implicitHeight: topBg.implicitHeight - 10
    implicitWidth: uptimeContent.implicitWidth + 10
    RowLayout {
        id: uptimeContent
        spacing: 10
        anchors.centerIn: parent
        IconImage{
            source: Quickshell.iconPath(Processes.iconResult)
            implicitSize: 25
            visible: source != "" 
        }
        ColumnLayout{
            spacing: 2
            StyledText{
                text: Processes.osName
                visible: text != ""
                font.pixelSize: Colors.small
                font.bold: true
                color: Colors.cBlue
            }
            StyledText{
                text: Processes.kernelVersion
                visible: text != ""
                font.pixelSize: Colors.small
                color: Colors.muted
            } 
        }
    }
}
