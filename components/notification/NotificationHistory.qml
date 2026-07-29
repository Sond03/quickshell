import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick.Layouts
import Quickshell.Widgets

import qs.Colors
import qs.services

PanelWindow {
    id: panelRoot
    implicitWidth: 350
    implicitHeight: 800
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "NotificationHistory:qml"
    exclusionMode: ExclusionMode.Normal
    anchors{ right: true; top: true}
    margins{ top: 110}

    color: "transparent"
    // property bool visible: false

    Rectangle {
        anchors.fill: parent
        color: Colors.bg
        topLeftRadius: 12
        bottomLeftRadius: 12
        topRightRadius: 0
        bottomRightRadius: 0
        border{ color: Colors.border; width: 1}
        ColumnLayout {
            anchors.fill: parent
            spacing: 5
            RowLayout{
                Layout.fillWidth: true
                Layout.margins: 10
                spacing: 10
                Text {
                    text: "Notifications"
                    font { family: Colors.fontFamily; pixelSize: Colors.large; bold: true}
                    color: Colors.green
                }

                Rectangle{
                    Layout.leftMargin: 10
                    width: clearText.implicitWidth + 5
                    height: clearText.implicitHeight + 5
                    color: clear.containsMouse ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
                    radius: 5

                    Behavior on color { ColorAnimation { duration: 220 } }

                    Text {
                        anchors.centerIn: parent
                        id: clearText
                        text: "Clear all"
                        font { family: Colors.fontFamily; pixelSize: Colors.large; bold: false}
                        color: clear.containsMouse ? Qt.lighter(Colors.crimson, 1.2) : Colors.white
                        Behavior on color { ColorAnimation { duration: 220 } }
                    }
                    MouseArea {
                        id: clear
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: Notifications.dismissAll()
                        // TODO
                    }

                }

                Item { Layout.fillWidth: true }

                Rectangle{
                    Layout.rightMargin: 10
                    width: 22
                    height: 22
                    radius: 5
                    color: close.containsMouse ? Qt.rgba(1, 1, 1, 0.08) : "transparent"

                    Behavior on color { ColorAnimation { duration: 220 } }

                    Text { 
                        anchors.centerIn: parent
                        text: ""
                        color: close.containsMouse ? Colors.red : Colors.green 
                        font { family: Colors.fontFamily; pixelSize: Colors.regular; bold: true}
                        visible: true
                        opacity: 1

                        Behavior on color { ColorAnimation { duration: 220 } }
                    }
                    MouseArea {
                        id: close
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: Quickshell.execDetached(["qs", "ipc","call", "history", "toggle"])
                        // TODO make this better 
                    }
                }
            }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: Notifications.history
                spacing: 6
                Layout.margins: 5
                clip: true 

                delegate: Rectangle {
                    width: (parent?.width || 0) - 9
                    height: (contentRow?.implicitHeight || 0) + 16
                    radius: 8
                    color: Qt.darker(Colors.fg, 1.0)

                    border {
                        color: model.urgency === NotificationUrgency.Critical ? Colors.crimson : Colors.blue
                        width: 3
                    }
                    ColumnLayout {
                        id: contentRow
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 8

                        RowLayout {
                            id: appRow
                            spacing: 5
                            IconImage {
                                Layout.alignment: Qt.AlignLeft
                                implicitSize: 20
                                visible: source.toString() !== ""
                                source: model.image || model.appIcon || ""
                            }
                            Text{ 
                                text: model.appName 
                                font { family: Colors.fontFamily; pixelSize: Colors.regular; bold: true }
                                color: Colors.cyan
                            }
                            Item { Layout.fillWidth: true}
                            RowLayout {

                                Text {
                                    text: model.time
                                    font { family: Colors.fontFamily; pixelSize: Colors.regular; bold: true}
                                    color: Colors.rose
                                }
                                Rectangle{
                                    // Layout.rightMargin: 10
                                    width: 22
                                    height: 22
                                    radius: 5
                                    color: dismiss.containsMouse ? Qt.rgba(1, 1, 1, 0.08) : "transparent"

                                    Behavior on color { ColorAnimation { duration: 220 } }

                                    Text { 
                                        anchors.centerIn: parent
                                        text: ""
                                        color: dismiss.containsMouse ? Colors.red : Colors.green 
                                        font { family: Colors.fontFamily; pixelSize: Colors.regular; bold: true}
                                        visible: true
                                        opacity: 1

                                        Behavior on color { ColorAnimation { duration: 220 } }
                                    }
                                    MouseArea {
                                        id: dismiss
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onClicked: Notifications.dismiss(index)
                                    }
                                }
                            }
                        }
                        Text {
                            Layout.fillWidth: true
                            text: model.summary + " " + model.body
                            color: Colors.blue
                            font { family: Colors.fontFamily; pixelSize: Colors.regular; bold: true }
                            wrapMode: Text.WordWrap
                        }
                    }

                }
            }
        }
    }
}


