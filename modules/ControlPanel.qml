import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Widgets
import qs.components
import qs.Colors
import qs.modules
import qs.modules.ControlPanelWidgets

PanelWindowStyled {
    id: root
    anchors{ left: true; top: true}
    margins{ left: 7; top: 5;}
    implicitHeight: Screen.height - 50
    layerName: "overlay"
    nameSpace: "ControlPanel.qs"

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
                RowLayout{
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 5
                    Uptime{}
                    Sysname{}

                }
            }
        }
    }
}
