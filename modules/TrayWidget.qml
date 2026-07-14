import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import Quickshell

import "../Colors/"

PopupWindow {
    id: popup
    color: "transparent"
    implicitHeight: tray.implicitHeight + 24
    implicitWidth: tray.implicitWidth + 20
    property bool open: false
    visible: open


    Rectangle {
        id: container
        anchors.fill: parent
        color: Colors.bg
        border.color: Colors.blue
        border.width: 1
        radius: 8

        opacity: popup.open ? 1 : 0
        scale: popup.open ? 1 : 0.85

        Behavior on scale{
            SpringAnimation { 
                spring: 5
                damping: 0.4
                mass: 1
            }
        }

        GridLayout {
            id: tray
            rows: 3 
            columns: 3
            anchors.fill: parent
            anchors.margins: 8

            Repeater {
                model: SystemTray.items
                delegate: Item {
                    id: trayItem
                    required property var modelData
                    implicitWidth: 24
                    implicitHeight: 24

                    QsMenuAnchor {
                        id: menuAnchor
                        menu: trayItem.modelData.menu
                        anchor.window: popup
                    }

                    Rectangle {
                        anchors.fill: parent
                        radius: 6
                        color: trayItem.modelData.active ? Colors.blue : Colors.bg
                        Behavior on color {
                            ColorAnimation { duration: 120 }
                        }
                        

                    }

                    IconImage {
                        anchors.centerIn: parent
                        implicitSize: 20
                        source: trayItem.modelData.icon
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: (mouse) => {
                            if (mouse.button === Qt.RightButton && trayItem.modelData.hasMenu) {
                                const pos = mapToItem(popup.contentItem, mouse.x, mouse.y)
                                menuAnchor.anchor.rect.x = pos.x
                                menuAnchor.anchor.rect.y = pos.y
                                menuAnchor.open()
                            } else {
                                trayItem.modelData.activate()
                            }
                        }
                    }
                }
            }
        }
    }
}

