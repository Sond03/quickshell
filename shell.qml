import Quickshell 
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

import "./modules" as Modules

PanelWindow {
    id: root
    property color colBg: "#1a1b26"
    property color colFg: "#a9b1d6"
    property color colMuted: "#444b6a"
    property color colCyan: "#0db9d7"
    property color colBlue: "#7aa2f7"
    property color bgModules: "#1d1e2f"
    property color colYellow: "#e0af68"
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 16

    Modules.Processes { id: sysData }

    Modules.MemoryWidget {
        id: memPopup
        anchor.window: root 
        isHovered: mouseMem.containsMouse
        procData: sysData.topProcs
        anchor.rect.x: parentWindow.width - 260
        anchor.rect.y: parentWindow.height + 8
    }

    Modules.CpuWidget {
        id: cpuPopup
        anchor.window: root 
        isHovered: mouseCpu.containsMouse
        anchor.rect.x: parentWindow.width - 260
        anchor.rect.y: parentWindow.height + 8

    }

    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 40
    color: "transparent"


    Rectangle {
        id: background
        anchors.fill: parent 
        anchors.leftMargin: 6
        anchors.rightMargin: 6
        opacity: 0.75
        radius: 10
        color: root.colBg
    }

    RowLayout {
        anchors.fill: background
        anchors.topMargin: 5 
        anchors.bottomMargin: 5
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 2

        Repeater {
            model: 5

            Rectangle {
                id: workspaceCircle
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: width

                property var workspace: Hyprland.workspaces.values.find(w => w.id == index + 1)
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

                width: isActive ? 45 : 30
                height: 22
                radius: isActive ? width / 4.5  : width / 2

                // border.color: "white"
                // border.width: 1

                color: mouseArea.containsMouse ? "#F4F4F4" : isActive ? "#2fbde7" : workspace ? "#6f9eb7" : "#1d1e2f"

                Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

                Text {
                    text: index +1
                    anchors.centerIn: parent 
                    // font { family: root.fontFamily; pointSize: 13; bold: true; }
                    font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
                    color: mouseArea.containsMouse ? "#1d1e2f" : "#00FFF" 
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent 
                    hoverEnabled: true
                    onClicked: Hyprland.dispatch("workspace " + (index + 1))
                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                }
            }
        }
        Item { Layout.fillWidth: true }

        Item {
            id: clockContainer
            Layout.preferredWidth: clock.width + 20
            Layout.preferredHeight: 30 
            anchors.centerIn: parent

            Rectangle {
                id: clockBg
                anchors.fill: parent
                radius: 5
                color: root.bgModules
                opacity: 1
            }

            Text {
                id: clock
                anchors.centerIn: parent
                color: root.colBlue
                font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
                text: Qt.formatDateTime(new Date(), "dd - HH:mm")

                Timer {
                    interval: 1000; running: true; repeat: true
                    onTriggered: clock.text = Qt.formatDateTime(new Date(), "dd - HH:mm")
                }
            }
        }
        Item { Layout.fillWidth: true }
        Item {
            id: rightModules
            Layout.preferredWidth: cpu.width + mem.width + 20
            Layout.preferredHeight: 30 
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
                id: rightBg
                anchors.fill: parent
                radius: 5
                color: root.bgModules
                opacity: 1
            }
            Row {
                id: contentRow
                anchors.centerIn: parent
                spacing: 10
                Text {
                    id: cpu
                    text: "CPU:" + sysData.cpuUsage + "%"
                    color: root.colYellow
                    font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }

                    MouseArea{
                        id: mouseCpu
                        anchors.fill: parent 
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                    }
                }

                Text {
                    id: mem
                    text: sysData.memUsage 
                    color: root.colCyan
                    font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }

                    MouseArea {
                        id: mouseMem
                        anchors.fill: parent 
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                    }
                }
            }
        }
    }
}

