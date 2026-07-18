import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import "../Colors/"

PanelWindow {
    id: popup
    color: "transparent"
    implicitHeight: (contentLoader.item?.implicitHeight ?? 0) + 24
    implicitWidth: (contentLoader.item?.implicitWidth ?? 0) + 20
    property bool isOpen: false
    visible: isOpen

    anchors{
        top: true
        right:true
    }

    margins {
        right: 225
    }
    HyprlandFocusGrab{
        active: popup.isOpen
        windows: [popup]
        onCleared: popup.isOpen = !popup.isOpen
    }

    Shortcut {
        sequence: "Escape"
        onActivated: popup.isOpen = !popup.isOpen
    }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "tray:quickshell"
    exclusionMode: ExclusionMode.Normal

    Component.onCompleted: contentLoader.active = true

    Rectangle {
        id: container
        anchors.fill: parent
        color: Colors.bg
        border.color: Colors.blue

        border.width: 1
        radius: 8

        opacity: popup.isOpen ? 1 : 0
        scale: popup.isOpen ? 1 : 0.85

        Behavior on scale{
            SpringAnimation { spring: 5; damping: 0.4; mass: 1 }
        }

        Loader { 
            id: contentLoader
            anchors.fill: parent
            anchors.margins: 8 
            active: false

            sourceComponent: GridLayout {
                id: tray
                rows: 3 
                columns: 3

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
                                    menuAnchor.isOpen()
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
}

