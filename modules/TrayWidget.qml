// import QtQuick
// import QtQuick.Layouts
// import Quickshell.Services.SystemTray
// import Quickshell.Widgets
// import Quickshell
// import Quickshell.DBusMenu
// import Quickshell.Io
//
// import "../Colors/"
//
// PopupWindow {
//     id: popup    
//     color: "transparent"
//     implicitHeight: tray.implicitHeight + 24
//     implicitWidth: tray.implicitWidth + 20
//
//     property bool open: false
//
//     visible: open
//
//     Rectangle {
//         id: container
//         visible: open
//         anchors.fill: parent
//         color: Colors.bg
//         border.color: Colors.blue
//         border.width: 1
//         radius: 8
//
//         RowLayout {
//             id: tray
//             spacing: 8 
//             anchors.fill: parent
//             anchors.margins: 8
//
//             Repeater {
//                 model: SystemTray.items
//
//                 delegate: Item { 
//                     width: 20 
//                     height: 10
//                     // radius: 6
//                     // color: modelData.active ? Colors.crimson : "transparent"
//
//                     // Behavior on color {
//                     //     ColorAnimation { duration: 120 }
//                     // }
//                     MouseArea {
//                         anchors.fill: parent
//                         onClicked: modelData.display(tray, mouse.x, mouse.y)
//                         acceptedButtons: Qt.LeftButton | Qt.RightButton
//                     }
//                     IconImage { 
//                         anchors.centerIn: parent
//                         implicitSize: 20
//                         source: modelData.icon
//                     }
//                 }
//             }
//         }
//     }
// }
//

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import Quickshell
import Quickshell.Io
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

        RowLayout {
            id: tray
            spacing: 8
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
                        color: trayItem.modelData.active ? Colors.blue : "transparent"
                        Behavior on color {
                            ColorAnimation { duration: 120 }
                        }
                    }

                    IconImage {
                        anchors.centerIn: parent
                        implicitSize: 20
                        source: status === Image.Error ? "/home/sond/.icons/candy-icons/devices/scalable/drive-removable-media-usb-pendrive.svg" : trayItem.modelData.icon
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: (mouse) => {
                            if (mouse.button === Qt.RightButton && trayItem.modelData.hasMenu) {
                                // map the click from this delegate's local space
                                // into popup's coordinate space before opening
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

