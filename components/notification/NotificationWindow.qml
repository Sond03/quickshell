import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick.Controls
import Quickshell.Hyprland
import Quickshell.Widgets
import qs.Colors
import qs.services
import qs.components

PanelWindow {
    id: root
    implicitWidth: 300
    // implicitHeight: Math.max(1, notifLoader.item ? notifLoader.item.implicitHeight : 0)
    implicitHeight: 800
    color: "transparent"

    property var notifications: Notifications.notifications

    anchors{ right: true; top: true }
    margins{ right: 15; top: 15 }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "NotificationWindow:qml"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: WlrLayershell.OnDemand

    Loader {
        id: notifLoader
        anchors.fill: parent
        active: true
        asynchronous: false


        sourceComponent: ListView {
            id: notifList
            anchors.fill: parent
            width: root.width
            model: root.notifications
            spacing: 10
            interactive: false

            displaced: Transition { NumberAnimation { property: "y"; duration: 250; easing.type: Easing.OutCubic } }
            remove: Transition { NumberAnimation { property: "x"; to: 350; duration: 350; easing.type: Easing.OutCubic } }
            removeDisplaced: Transition { NumberAnimation { property: "y"; duration: 250; easing.type: Easing.OutCubic } }


                delegate: Rectangle {
                    id: notifCard
                    required property var modelData
                    width: notifList.width
                    height: row.implicitHeight + 20
                    radius: 5
                    color: Colors.bg
                    border {
                        color: modelData.urgency === NotificationUrgency.Critical ? Colors.crimson : Colors.blue
                        width: 2
                    }

                    RowLayout {
                        id: row
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 8

                        Image {
                            Layout.preferredHeight: 36
                            Layout.preferredWidth: 36
                            Layout.alignment: Qt.AlignHCenter
                            fillMode: Image.PreserveAspectFit
                            visible: source.toString() !== ""
                            source: notifCard.modelData.image || notifCard.modelData.appIcon || ""
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            
                            RowLayout {

                                Text {
                                    Layout.fillWidth: true
                                    text: notifCard.modelData.summary 
                                    color: Colors.blue
                                    font { family: Colors.fontFamily; pixelSize: Colors.regular; bold: true}
                                    elide: Text.ElideRight
                                }

                                Rectangle{
                                    Layout.alignment: Qt.AlignRight
                                    width: 22
                                    height: 22
                                    radius: 5
                                    color: dismiss.containsMouse ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
                                    antialiasing: true

                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 120
                                        }
                                    }

                                    Text { 
                                        anchors.centerIn: parent
                                        text: ""
                                        color: dismiss.containsMouse ? Colors.crimson : Colors.emerald 
                                        font { family: Colors.fontFamily; pixelSize: Colors.regular; bold: true}
                                        visible: true
                                        opacity: 1
                                    }
                                    MouseArea {
                                        id: dismiss
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onClicked: notifCard.closing = true
                                    }
                                }
                            }
                            

                            Text {
                                Layout.fillWidth: true
                                visible: text != ""
                                text: notifCard.modelData.body
                                color: Colors.white
                                font { family: Colors.fontFamily; pixelSize: Colors.small; bold: false}
                                wrapMode: Text.WordWrap
                            }

                            TextFieldStyled {
                                id: replyField
                                Layout.fillWidth: true
                                visible: notifCard.modelData.hasInlineReply
                                placeholderText: qsTr("Reply..")
                                hoverEnabled: true

                                onAccepted: {
                                    notifCard.modelData.sendInlineReply(replyField.text)
                                    replyField.clear()
                                }
                            }
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        cursorShape: Qt.PointingHandCursor
                        z: -1
                        onClicked: {
                            const className = notifCard.modelData.appName
                            if (className) {
                                Hyprland.dispatch(`hl.dsp.focus({ window = "class:^(${className})$" })`)
                            }
                            modelData.dismiss()
                        }
                    }
                    Timer{
                        running: true
                        repeat: true
                        interval: 5000

                        onTriggered: modelData.dismiss()
                    }
                }
            }
        }
    }

