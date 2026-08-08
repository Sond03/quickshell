import Quickshell
import QtQuick.Effects
import Quickshell 
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Widgets

import qs.components
import qs.services
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

    ClippingRectangle {
        anchors.fill: parent
        id: bg
        color: Colors.base
        border.color: Colors.surface1
        border.width: 1
        radius: 10
        clip: true

    ColumnLayout {
        anchors.fill: parent
        anchors.rightMargin: 10
        anchors.leftMargin: 10

        Rectangle {
            id: styledRect
            Layout.fillWidth: true
            Layout.preferredHeight: 64
            color: "transparent"
            border.width: 0
            radius: 10

            TextFieldStyled {
                id: textFieldId
                anchors.centerIn: parent
                fieldRadius: 10
                implicitHeight: 40
                implicitWidth: parent.width
                placeholderText: "Search"
            }
        }

        ListView {
            id: appListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: Applications.applications
            spacing: 2

            delegate: Rectangle {
                id: application
                width: appListView.width
                height: 50
                color: Colors.base
                border.color: Colors.surface1
                border.width: 1
                radius: 8

                RowLayout {
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10

                    ClippingWrapperRectangle {
                        radius: 5
                        color: "transparent"
                        IconImage {
                            implicitSize: application.height - 10
                            source: Quickshell.iconPath(modelData.icon)
                        }
                    }

                    Text {
                        Layout.alignment: Qt.AlignVCenter
                        text: modelData.name
                        font { family: Colors.fontFamily; pixelSize: Colors.regular ; bold: false }
                        color: Colors.rose
                    }
                    Text {
                        text: modelData.genericName
                        font { family: Colors.fontFamily; pixelSize: Colors.regular ; bold: false }
                        color: Colors.muted
                    }
                }
            }
        }
    }
    }
}
