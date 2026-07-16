//@ pragma UseQApplication

import Quickshell 
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import "./modules"
import "./Colors" 

ShellRoot { 
    PanelWindow {
        id: root
        Processes { id: sysData }
        SystemClock { id: sysClock }

        MemoryWidget {
            id: memPopup
            isHovered: mouseMem.containsMouse || isPinned 
            procData: sysData.topProcs
            anchor.window: root 
            anchor.rect.x: Screen.width - 210
            anchor.rect.y: parentWindow.height + 8
        }

        CpuWidget {
            id: cpuPopup
            anchor.window: root 
            isHovered: mouseCpu.containsMouse || isPinned
            anchor.rect.x: memPopup.anchor.rect.x - width - 5
            anchor.rect.y: parentWindow.height + 8
        }
        CalendarWidget {
            id: calendarPopup
            isHovered: mouseClock.containsMouse || isPinned
            anchor.window: root
            anchor.rect.x: parentWindow.width / 2 - width / 2
            anchor.rect.y: parentWindow.height
        }

        anchors.top: true
        anchors.left: true
        anchors.right: true
        implicitHeight: 40
        color: "transparent"


        Rectangle {
            id: background
            anchors.fill: parent 
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            opacity: 0.75
            radius: 5
            color: Colors.bg
        }


        RowLayout {
            id: row
            anchors.fill: background

            Rectangle{
                id: workspaceContainer
                implicitHeight: workspaceLayout.implicitHeight + 3
                implicitWidth: workspaceLayout.implicitWidth + 16
                color: Colors.bg
                radius: 5
                Layout.leftMargin: 5

                RowLayout {
                    id: workspaceLayout
                    anchors.centerIn: parent
                    spacing: 2


                    Repeater {
                        model: {
                            let base = [1, 2, 3, 4, 5];
                            let focused = Hyprland.focusedWorkspace?.id;
                            if (focused > 5) {
                                base.push(focused);
                            }
                            return base;
                        }

                        Rectangle {
                            id: workspaceCircle
                            Layout.alignment: Qt.AlignVCenter
                            Layout.preferredWidth: width
                            Layout.preferredHeight: height

                            property var workspace: Hyprland.workspaces.values.find(w => w.id == modelData)
                            property bool isActive: Hyprland.focusedWorkspace?.id === modelData

                            width: isActive ? 45 : 30
                            height: 23
                            radius: isActive ? width / 4.5  : width / 2


                            color: mouseArea.containsMouse ? Colors.bg : isActive ? Colors.wsActive : workspace ? Colors.wsPopulated : Colors.bg

                            Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

                            Text {
                                text: modelData
                                anchors.centerIn: parent 
                                font { family: Colors.fontFamily; pixelSize: Colors.regular; bold: true }
                                color: mouseArea.containsMouse ? Colors.cyan : Colors.fg
                            }

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent 
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${modelData} })`);
                                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                            }
                        }
                    }
                    Text{
                        padding: 5 
                        Layout.alignment: Qt.AlignVCenter
                        id:kitty 
                        text: ""
                        color: Colors.blue
                        property bool kittyBounce: false

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: kitty.kittyBounce = !kitty.kittyBounce
                        }

                        Loader {
                            active: kitty.kittyBounce
                            source: "RuiOgKatniss.qml"
                        }
                    }

                    SoundWidget{ }
                }
            }
            Item {
                Layout.fillWidth: true 
            }

            Item {
                id: clockContainer
                Layout.preferredWidth: clock.width + 20
                Layout.preferredHeight: 30 
                anchors.centerIn: parent

                Rectangle {
                    id: clockBg
                    anchors.fill: parent
                    radius: 5
                    color: Colors.bg
                    opacity: 1

                    MouseArea {
                        id: mouseClock
                        anchors.fill: parent 
                        hoverEnabled: true
                        onClicked: calendarPopup.isPinned = !calendarPopup.isPinned
                        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                    }
                }

                Text {
                    id: clock
                    anchors.centerIn: parent
                    color: Colors.blue
                    font { family: Colors.fontFamily; pixelSize: Colors.regular; bold: true }
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
                Layout.preferredWidth: (hovered||trayOpen) ? moduleExpand : moduleWidth
                Layout.preferredHeight: 30 
                Layout.alignment: Qt.AlignVCenter
                Layout.rightMargin: 5

                property int expandHover:  15
                property bool hovered: hoverHandler.hovered
                property int moduleWidth: contentRow.implicitWidth + 15
                property int moduleExpand: moduleWidth + expandHover
                property bool trayOpen: false

                HoverHandler { id: hoverHandler}

                Rectangle {
                    id: rightBg
                    anchors.right: parent.right 
                    anchors.verticalCenter: parent.verticalCenter
                    implicitHeight: parent.height
                    width: parent.width
                    radius: 5
                    color: Colors.bg

                    Behavior on width {
                        NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                    }

                    Text {
                        id: leftArrow
                        text: "❮"
                        color: Colors.fg

                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 2

                        rotation: (arrowHover.hovered||rightModules.trayOpen) ? -90 : 0
                        opacity: (rightModules.hovered||rightModules.trayOpen) ? 1 : 0

                        Behavior on rotation { NumberAnimation { duration: 150; easing.type: Easing.InOutQuad } }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                rightModules.trayOpen = !rightModules.trayOpen
                                trayWidget.open = !trayWidget.open 
                            }
                        }

                        HoverHandler { id: arrowHover }
                    }
                }

                TrayWidget{
                    id: trayWidget
                    anchor.window: root 
                    anchor.rect.x: cpuPopup.anchor.rect.x 
                    anchor.rect.y: parentWindow.height + 8
                }
                RowLayout {
                    id: contentRow
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10

                    Text {
                        id: cpu
                        text: "CPU:" + sysData.cpuUsage + "%"
                        color: Colors.yellow
                        font { family: Colors.fontFamily; pixelSize: Colors.regular; bold: true }

                        MouseArea{
                            id: mouseCpu
                            anchors.fill: parent 
                            hoverEnabled: true
                            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                            onClicked: cpuPopup.isPinned = !cpuPopup.isPinned
                        }
                    }

                    Text {
                        id: mem
                        text: sysData.memUsage 
                        color: Colors.cyan
                        font { family: Colors.fontFamily; pixelSize: Colors.regular; bold: true }

                        MouseArea {
                            id: mouseMem
                            anchors.fill: parent 
                            hoverEnabled: true
                            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                            onClicked: memPopup.isPinned = !memPopup.isPinned
                        }
                    }
                    Text {
                        id:powerButton
                        text: "⏻"
                        color: mousePowerButton.containsMouse ? Colors.crimson : Colors.emerald
                        font { family: Colors.fontFamily; pixelSize: Colors.regular; bold: true }
                        MouseArea {
                            id: mousePowerButton
                            anchors.fill: parent 
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Quickshell.execDetached(["wlogout"])
                            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                        }
                    }
                }
            }
        }
    }
}
