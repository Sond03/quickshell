import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Widgets
import qs.components
import qs.Colors
import qs.modules

PanelWindowStyled {
    id: root
    anchors{ left: true; top: true}
    margins{ left: 7; top: 5;}
    implicitHeight: Screen.height - 50

    StyledRectangle{
        id: bg
        anchors.fill: parent
        color: Qt.rgba(Colors.base.r, Colors.base.g ,Colors.base.b, 0.8)
        border.color: Colors.border
        border.width: 1

        ColumnLayout { 
            id: column
            anchors.fill: parent
            StyledRectangle{
                id: topBg
                implicitHeight: 50
                implicitWidth: root.implicitWidth - 11
                Layout.alignment: Qt.AlignTop
                Layout.margins: 5
                border.color: Colors.cBlue
                border.width: 0
                StyledRectangle {
                    id: uptimeBg
                    color: Colors.bg
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 5
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
                                font.pixelSize: 20
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
                            }
                            StyledText{
                                text: Processes.uptime
                                Layout.leftMargin: 5
                            }
                        }
                    } 
                }
            }
        }
    }
}
