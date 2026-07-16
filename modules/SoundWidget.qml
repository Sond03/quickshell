import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris
import QtQuick.Shapes

import "../Colors/"
import "../components/"
import "../services/"

Item {
    id: wrapper
    implicitHeight: labelBg.implicitHeight
    implicitWidth: labelBg.width

    property bool open: false
    property real closeDelay: 500
    property real dropdownExtraHeight: 0

    readonly property real sharedWidth: Math.max( label.implicitWidth + 12, (contentLoader.item ? contentLoader.item.implicitWidth : 0) + 16)

    Rectangle  {
        id: labelBg
        implicitHeight: label.implicitHeight 
        implicitWidth: wrapper.open ? wrapper.sharedWidth - 8 : label.implicitWidth + 12
        color: Qt.rgba(1, 1, 1, 0.0)
        radius: 5

        Behavior on implicitWidth {
            NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 5
            spacing: 6


            Text {
                id: label
                anchors.left: parent.left
                Layout.alignment: Qt.AlignVCenter
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
            Loader {
                id: labelLoader
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
                active: wrapper.open
                sourceComponent: sinkComboComponent
            }
        }

        Component {
            id: sinkComboComponent
            Item {
                id: sinkPickerRoot
                implicitWidth: 160
                implicitHeight: pickerBg.implicitHeight

                function labelFor(node) { return node.nickname || node.description || node.name }

                Rectangle {
                    id: pickerBg
                    implicitHeight: 25
                    width: parent.width
                    radius: 5
                    color: Colors.fg
                    border.color: pickerArea.containsMouse ? Colors.blue : "transparent"
                    border.width: 1

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        anchors.right: chevron.left
                        anchors.verticalCenter: parent.verticalCenter
                        text: Audio.defaultSink ? sinkPickerRoot.labelFor(Audio.defaultSink) : ""
                        color: Colors.white
                        elide: Text.ElideRight
                        font { family: Colors.fontFamily; pixelSize: Colors.regular }
                    }
                    Text {
                        id: chevron
                        anchors.right: parent.right
                        anchors.rightMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        text: dropdown.visible ? "󰅃" : "󰅀"
                        color: Colors.blue
                        font { family: Colors.fontFamily; pixelSize: Colors.small }
                    }
                    MouseArea {
                        id: pickerArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: dropdown.visible = !dropdown.visible
                    }
                }

                PopupWindow {
                    id: dropdown
                    visible: false
                    color: "transparent"
                    anchor.item: pickerBg
                    anchor.rect.y: pickerBg.height
                    anchor.edges: Edges.Bottom | Edges.Left
                    implicitWidth: pickerBg.width
                    implicitHeight: dropdownList.implicitHeight + 8

                    Rectangle {
                        anchors.fill: parent
                        radius: 6
                        color: Colors.bg
                        border.color: Colors.fg
                        border.width: 1

                        ColumnLayout {
                            id: dropdownList
                            anchors.fill: parent
                            anchors.margins: 4
                            spacing: 2

                            Repeater {
                                model: Audio.sinks
                                delegate: Rectangle {
                                    Layout.fillWidth: true
                                    implicitHeight: 28
                                    radius: 4
                                    color: itemArea.containsMouse ? Qt.lighter(Colors.fg, 1.4) : "transparent"

                                    Text {
                                        anchors.fill: parent
                                        anchors.leftMargin: 8
                                        verticalAlignment: Text.AlignVCenter
                                        text: sinkPickerRoot.labelFor(modelData)
                                        color: modelData === Audio.defaultSink ? Colors.cyan : Colors.white
                                        font { family: Colors.fontFamily; pixelSize: Colors.regular; bold: modelData === Audio.defaultSink }
                                        elide: Text.ElideRight
                                    }
                                    MouseArea {
                                        id: itemArea
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            Pipewire.preferredDefaultAudioSink = modelData
                                            dropdown.visible = false
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
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
        implicitHeight: wrapper.open && contentLoader.item ? contentLoader.item.implicitHeight + 16 : 1

        Behavior on implicitWidth {
            NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
        }
        Behavior on implicitHeight {
            NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
        }

        // Rectangle {
        //     anchors.top: parent.top
        //     color: Colors.bg
        //     height: 15
        //     width: parent.width 
        // }

        // Shape {
        //     id: spacerShape
        //     width: parent.width 
        //     height: 15
        //     property int radius: 8
        //     ShapePath {
        //         fillColor: Colors.crimson
        //         strokeWidth: 0
        //         startX: 0; startY: 0
        //         PathLine { x: (spacerShape.width / 2) - spacerShape.radius; y: 0 }
        //         PathArc {
        //             x: (spacerShape.width / 2) + spacerShape.radius
        //             y: 0
        //             radiusX: spacerShape.radius
        //             radiusY: spacerShape.radius
        //             direction: PathArc.Counterclockwise
        //         }
        //         PathLine { x: spacerShape.width; y: 0 }
        //         PathLine { x: spacerShape.width; y: spacerShape.height }
        //         PathLine { x: 0; y: spacerShape.height }
        //         PathLine { x: 0; y: 0 }
        //     }
        // } 

        Rectangle {
            id: mainRect
            anchors.fill: parent 
            radius: 8
            color: Colors.bg
            topLeftRadius: 0
            topRightRadius: 0
            anchors.topMargin: 4
            // anchors.leftMargin: 15
            // anchors.rightMargin: 15
            // for when i fix the concave radius box above

            Loader {
                id: contentLoader
                anchors.fill: parent
                active: expandedContent.visible && Audio.ready
                sourceComponent: Component {
                    ColumnLayout {
                        id: listColumn
                        anchors.fill: parent
                        spacing: 5
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        anchors.topMargin: 5
                        anchors.bottomMargin: 8

                        PwObjectTracker {
                            objects: Pipewire.nodes
                        }

                        PipewireRow {
                            modelData: Audio.defaultSink
                            visible: Pipewire.defaultAudioSink !== null
                            label: " Output"
                        }
                        PipewireRow {
                            modelData: Audio.defaultSource
                            visible: Pipewire.defaultAudioSource !== null
                            label: " Input"
                        }
                        Repeater{
                            model: Audio.streams
                            delegate: PipewireRow{}
                        }
                        Repeater {
                            model: Audio.players
                            delegate: MprisRow { }
                        }
                    }
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
