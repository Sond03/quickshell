import Quickshell
import QtQuick.Effects
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

        onPressed: toggleMenu()
    }

    Shortcut {
        id: escapeSequence
        sequence: "Escape"
        onActivated: {
            toggleMenu()
        }
    }

    HyprlandFocusGrab {
        active: panelRoot.visible
        windows: [panelRoot]
        onCleared: {
            if (panelRoot.visible) {
                hideMenu()
            }
        }
    }
    function toggleMenu(){
        panelRoot.visible = !panelRoot.visible
    }

    function hideMenu() {
        panelRoot.visible = false
    }

    function launchApp(app) { 
        if (app.runInTerminal) {
            Quickshell.execDetached({
                command: ["kitty", "-e", ...modelData.command],
                workingDirectory: modelData.workingDirectory
            })
        } else {
            app.execute()    
        }
        panelRoot.visible = false
    }

    implicitWidth: 650
    implicitHeight: 595
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "MenuWindow:qs"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: WlrLayershell.OnDemand
    color: "transparent"
    visible: false
    property var filteredApps: Applications.search(textFieldId.text)

    onFilteredAppsChanged: appListView.currentIndex = filteredApps.length > 0 ? 0 : -1


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
                onTextChanged: Applications.query = text

                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Down) {
                        if (appListView.currentIndex < filteredApps.length - 1)
                        appListView.currentIndex++
                        event.accepted = true
                    } else if (event.key === Qt.Key_Up) {
                        if (appListView.currentIndex > 0)
                        appListView.currentIndex--
                        event.accepted = true
                    } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        if (appListView.currentIndex >= 0)
                        panelRoot.launchApp(filteredApps[appListView.currentIndex])
                        event.accepted = true
                    }
                }
            }
        }

        ListView {
            id: appListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: filteredApps
            spacing: 2
            onCurrentIndexChanged: positionViewAtIndex(currentIndex, ListView.Contain)

            delegate: Rectangle {
                id: application
                width: appListView.width
                height: 50
                color: (mouseArea.containsMouse || index === appListView.currentIndex) ? Colors.bg : "transparent"
                radius: 8

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent 
                    hoverEnabled: true
                    onContainsMouseChanged: {
                        if (containsMouse) appListView.currentIndex = index
                    }
                    onClicked: panelRoot.launchApp(modelData) 
                }

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

                    ColumnLayout {
                        spacing: 2
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
                            visible: modelData.genericName != ""
                        }
                    }
                }
            }
        }
    }
    }
}
