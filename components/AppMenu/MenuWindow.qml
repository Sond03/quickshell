import Quickshell
import QtQuick.Effects
import Quickshell 
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Io

import qs.components
import qs.Colors


PanelWindow {
    id: panelRoot
    GlobalShortcut {
        name: "toggleAppMenu"
        description: "Show the application menu"

        onPressed: panelRoot.visible = !panelRoot.visible 
    }

    implicitWidth: 650
    implicitHeight: 600
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "MenuWindow:qs"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: WlrLayershell.OnDemand
    color: "transparent"
    visible: false

       onVisibleChanged: {
        if (visible) {
            textFieldId.forceActiveFocus()
        } else {
            textFieldId.text = ""
        }
    }
    
    ListView {
        anchors.fill: parent
        StyledRectangle { 
            id: styledRect 
            border.color: Colors.surface1
            color: Colors.base
            border.width: 1
            radius: 10
            TextFieldStyled {
                id: textFieldId
                fieldRadius: 10
                implicitHeight: 40
                implicitWidth: parent.width - 35
                anchors.top: parent.top
                anchors.topMargin: 12
                anchors.horizontalCenter: parent.horizontalCenter
                placeholderText: "Search"
            }
        }
    }
}
