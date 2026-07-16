import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

import "../Colors/"
import "../components/"
import "../services/"

Rectangle {
    id: rowBg
    required property var modelData
    Layout.fillWidth: true
    Layout.preferredHeight: rowContent.implicitHeight + 12
    implicitWidth: rowContent.implicitWidth + 10
    radius: 6
    color: Colors.fg
    property string label: ""

    GridLayout {
        id: rowContent
        anchors.fill: parent
        anchors.margins: 6
        columns: 3
        rowSpacing: 4
        columnSpacing: 8

        RowLayout {

            Text {
                id: labelText
                visible: label !== ""
                text: label + " - "
                color: Colors.blue   
                font { family: Colors.fontFamily; pixelSize: Colors.regular; bold: true }
            }

            Text {
                id:textInput
                text: (modelData.nickname || modelData.description || modelData.name || "")
                color: Colors.cyan
                font { family: Colors.fontFamily; pixelSize: Colors.regular; bold: false; capitalization: Font.Capitalize }
            }
        }

        Item { Layout.fillWidth: true }

        RowLayout {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            spacing: 8

            VolumeSlider {
                id: volumeSlider
                Layout.fillWidth: true
                value: modelData.audio.volume
                onMoved: modelData.audio.volume = value
            }

            Text {
                id: percentText
                property real animatedVolume: modelData.audio.volume * 100

                Behavior on animatedVolume {
                    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                }
                text: Math.round(animatedVolume) + "%"
                color: Colors.white
                font { family: Colors.fontFamily; pixelSize: Colors.regular; bold: false }
                horizontalAlignment: Text.AlignRight
                Layout.preferredWidth: percentMetrics.width 
            }
            TextMetrics {
                id: percentMetrics
                font: percentText.font
                text: "100%"
            }


        }
        Rectangle { 
            id: mutedBg
            radius: height / 2
            width: 25
            height: 25
            color: modelData.audio.muted ? Qt.rgba(0.8, 0.2, 0.2, muteArea.containsMouse ? 0.25 : 0.15) : Qt.rgba(1, 1, 1, muteArea.containsMouse ? 0.16 : 0.08)
            border.color: modelData.audio.muted ? Qt.rgba(0.8, 0.2, 0.2, 0.4) : Qt.rgba(1, 1, 1, 0.22)
            border.width: 1
            scale: muteArea.pressed ? 0.9 : 1.0

            Behavior on color { ColorAnimation { duration: 120 } }
            Behavior on border.color { ColorAnimation { duration: 120 } }
            Behavior on scale { NumberAnimation { duration: 80; easing.type: Easing.OutCubic } }

            Text {
                id: muted
                anchors.centerIn: parent
                text: modelData.isSink ? (Audio.volumeIcon(modelData)) : (modelData.audio.muted ? "󰍭" : "󰍬")
                color: muteArea.containsMouse ? Colors.crimson : Colors.blue
                font { family: Colors.fontFamily; pixelSize: Colors.large; bold: false }

                Behavior on color {
                    ColorAnimation { duration: 120 }
                }
                
                MouseArea {
                    id: muteArea
                    anchors.fill: parent
                    anchors.margins: -6   
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: modelData.audio.muted = !modelData.audio.muted
                }
            }
        }
    }
}
