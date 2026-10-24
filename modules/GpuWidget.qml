import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Layouts

import "."
import "../Colors/"
import qs.components

PanelWindowStyled {
    implicitWidth: 300 
    implicitHeight: 300
    anchors{
        top: true
        right:true
    }
    margins{
        right: 205 + 5 + 3
    }

    StyledRectangle {
        anchors.fill: parent
        ColumnLayout {
            id: content
            anchors.fill: parent
            anchors.margins: 10
            spacing: 5
            StyledText{
                text: "Gpu stats"
                color: Colors.cBlue
                Layout.alignment: Qt.AlignHCenter
                bold: true
            }
            Rectangle {
                height: 2
                Layout.fillWidth: true
                color: Colors.fg
            }
            StyledRectangle{
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                Layout.preferredHeight: memText.implicitHeight + 5
                color: Colors.fg
                StyledText{
                    id: memText
                    text: Processes.gpuMemUsage + " | " + Processes.gpuMemMax
                    size: Colors.large
                }
            }

            StyledRectangle{
                Layout.fillWidth: true
                Layout.preferredHeight: tempText.implicitHeight + 5
                color: Colors.fg
                StyledText{
                    id: tempText
                    text: Processes.gpuTemp + ""
                    size: Colors.large
                }
            }
            Item { Layout.fillHeight: true }
        }
    }
}
