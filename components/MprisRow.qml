import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import Quickshell.Services.Mpris

import "../Colors/"

Rectangle {
    id: rowBg
    required property var modelData
    Layout.fillWidth: true
    Layout.preferredHeight: rowContent.implicitHeight + 12
    implicitWidth: rowContent.implicitWidth + 150
    radius: 6
    color: Colors.fg

    ColumnLayout {
        id: rowContent
        anchors.fill: parent
        anchors.margins: 6
        spacing: 2

        RowLayout {
            IconImage {
                implicitSize: 20
                source: modelData.desktopEntry ? Quickshell.iconPath(modelData.desktopEntry, true) : ""
            }

            Text {
                id:textInput
                text: modelData.desktopEntry || ""
                color: Colors.cyan
                font { family: Colors.fontFamily; pixelSize: Colors.regular; bold: false; capitalization: Font.Capitalize }
            }
        }

        Item { Layout.fillWidth: true }

        RowLayout {
            spacing: 2

            VolumeSlider {
                id: volumeSlider
                Layout.fillWidth: true
                value: modelData.volume
                onMoved: modelData.volume = value
            }
            Text {
                id: percentText
                property real animatedVolume: modelData.volume * 100

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

        RowLayout {
            Layout.fillWidth: true
            spacing: 2

            IconImage {
                height: 60
                implicitSize: 50
                source: modelData.trackArtUrl
                visible: modelData && modelData.trackArtUrl !== ""
            }

            ColumnLayout {
                Layout.fillWidth: true 
                spacing: 2
                MarqueeText {
                    text: modelData.trackTitle 
                    Layout.fillWidth: true
                    color: Colors.white
                    font { family: Colors.fontFamily; pixelSize: Colors.small; bold: false }
                }
                MarqueeText  {
                    Layout.fillWidth: true
                    text: modelData.trackArtist
                    color: Colors.emerald
                    font { family: Colors.fontFamily; pixelSize: Colors.small; bold: false }
                }
            }
            CircleBackground{
                visible: modelData.canGoPrevious
                onClicked: modelData.previous()
                Text {
                    anchors.centerIn: parent
                    id: previousSong
                    text: "󰒮"
                    color: Colors.blue
                    font { family: Colors.fontFamily; pixelSize: Colors.regular; bold: true }
                }
            }
            CircleBackground{
                visible: modelData.canPause || modelData.canPlay
                onClicked: modelData.isPlaying ? modelData.pause() : modelData.play()
                Text {
                    anchors.centerIn: parent
                    id: pauseSong
                    anchors.horizontalCenterOffset: modelData.isPlaying ? -0.7 : 0
                    text: modelData.isPlaying ? "" : ""
                    color: Colors.blue
                    font { family: Colors.fontFamily; pixelSize: Colors.regular; bold: true }
                }
            }
            CircleBackground {
                visible: modelData.canGoNext
                onClicked: modelData.next()
                Text {
                    anchors.centerIn: parent
                    id: nextSong
                    text: "󰒭"
                    color: Colors.blue
                    font { family: Colors.fontFamily; pixelSize: Colors.regular; bold: true }
                }
            }
        }
        RowLayout {
            Layout.topMargin: 5
            id:row
            Layout.fillWidth: true
            spacing: 8
            function formatTime(totalSeconds) {
                if (totalSeconds <= 0) {
                    return "0:00";
                }
                var minutes = Math.floor(totalSeconds / 60);
                var seconds = Math.floor(totalSeconds % 60);
                return minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
            }
            Text {
                text: row.formatTime(modelData ? modelData.position : 0)
                color: Colors.blue
                font { family: Colors.fontFamily; pixelSize: Colors.small; bold: true }
            }
            FrameAnimation {
                running: modelData ? modelData.isPlaying : false
                onTriggered: modelData.positionChanged()
            }
            ProgressLine {
                id: progressBar
                Layout.fillWidth: true

                from: 0
                to: modelData ? modelData.length : 1
                value: modelData ? modelData.position : 0
            }
            Text {
                text: row.formatTime(modelData ? modelData.length : 0)
                color: Colors.blue
                font { family: Colors.fontFamily; pixelSize: Colors.small; bold: true }
            }
        }
    }
}

