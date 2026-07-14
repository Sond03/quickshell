import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris

import "../Colors/"
import "../components/"



Item {
    id: wrapper
    implicitHeight: labelBg.implicitHeight
    implicitWidth: labelBg.width

    property bool open: false
    property real closeDelay: 500

    readonly property real sharedWidth: Math.max(label.implicitWidth + 12, listColumn.implicitWidth + 16)

    Rectangle  {
        id: labelBg
        implicitHeight: label.implicitHeight 
        implicitWidth: wrapper.open ? wrapper.sharedWidth - 8 : label.implicitWidth + 12
        color: Qt.rgba(1, 1, 1, 0.0)
        radius: 5

        Behavior on implicitWidth {
            NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
        }

        Text {
            id: label
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            text: ""
            color: Colors.blue
            font { family: Colors.fontFamily; pixelSize: Colors.regular; bold: true }

            MouseArea{
                anchors.fill: parent
                onClicked: wrapper.open = !wrapper.open
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
            }
        }
    }

    PopupWindow {
        id: expandedContent
        color: "transparent"

        anchor.item: labelBg
        anchor.rect.x: 0 
        anchor.rect.y: labelBg.height
        anchor.edges: Edges.Bottom | Edges.Left

        implicitWidth: wrapper.open ? wrapper.sharedWidth : 1
        implicitHeight: wrapper.open ? listColumn.implicitHeight + 16 : 1

        Behavior on implicitWidth {
            NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
        }
        Behavior on implicitHeight {
            NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
        }

        Rectangle {
            anchors.fill: parent
            radius: 8
            color: Colors.bg

            ColumnLayout {
                id: listColumn
                anchors.fill: parent
                spacing: 5
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                anchors.topMargin: 2
                anchors.bottomMargin: 8

                PwObjectTracker {
                    objects: Pipewire.nodes
                }

                PipewireRow {
                    modelData: Pipewire.defaultAudioSink
                    visible: Pipewire.defaultAudioSink !== null
                    label: " Output"
                }
                PipewireRow {
                    modelData: Pipewire.defaultAudioSource
                    visible: Pipewire.defaultAudioSource !== null
                    label: " Input"
                }
                Repeater {
                    model: Mpris.players
                    delegate: MprisRow { }
                }
            }
        }
    }
    Timer {
        id: hideTimer
        interval: wrapper.closeDelay
        onTriggered: expandedContent.visible = false
    }

    onOpenChanged: {
        if (open) {
            hideTimer.stop()
            expandedContent.visible = true
        } else {
            hideTimer.start()
        }
    }
}
