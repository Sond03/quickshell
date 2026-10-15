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
    anchors{
        top: true
        right:true
    }
    margins{
        right: 205 + 5 + 3
    }

    StyledRectangle {
        id: content
        anchors.fill: parent
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 5
            StyledRectangle{
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                Layout.preferredHeight: memText.implicitHeight + 5
                color: Colors.bg
                StyledText{
                    id: memText
                    text: Processes.gpuMemUsage + " | " + Processes.gpuMemMax
                    size: Colors.large
                }
            }

            StyledRectangle{
                Layout.fillWidth: true
                Layout.preferredHeight: tempText.implicitHeight + 5
                color: Colors.bg
                StyledText{
                    id: tempText
                    text: Processes.gpuTemp
                    size: Colors.large
                }
            }
            Item { Layout.fillHeight: true }
        }
    }
}
