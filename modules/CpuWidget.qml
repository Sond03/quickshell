import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Layouts

import "."
import "../Colors/"
import qs.components

PanelWindow {
    id: popup
    implicitWidth: 155
    // implicitHeight: 50 + (coreUsages.length * 22) + tempText.implicitHeight
    implicitHeight: content.implicitHeight + 20  

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "cpuWidget:quickshell"
    exclusionMode: ExclusionMode.Normal

    property var coreUsages: []
    property string coresProc: ""
    property bool isHovered: false 
    property bool isPinned: false
    property var last: ({})

    onCoresProcChanged: {
        let lines = coresProc.trim().split("\n").filter(l => l !== "");
        coreUsages = lines.map(l => parseInt(l));
        coresProc = ""; // reset so next tick overwrites cleanly
    }

    color: "transparent"

    visible: isHovered || isPinned || container.opacity > 0


    anchors{
        top: true
        right:true
    }
    margins{
        right: 205 + 5 + 3
    }

    Process {
        id: coresProcGrabber
        command: ["sh", "-c", "grep '^cpu[0-9]' /proc/stat"]

        stdout: SplitParser {
            onRead: data => {
                let p = data.trim().split(/\s+/);
                let name = p[0];
                if (!name.match(/^cpu[0-9]/)) return;

                let idle = parseFloat(p[4]);
                let total = p.slice(1).reduce((a, b) => a + parseInt(b), 0);

                if (popup.last[name]) {
                    let dIdle = idle - popup.last[name].idle;
                    let dTotal = total - popup.last[name].total;
                    if (dTotal > 0) {
                        let usage = Math.max(0, Math.min(100, Math.round(100 * (dTotal - dIdle) / dTotal)));
                        let updated = [...popup.coreUsages];
                        let idx = parseInt(name.replace("cpu", ""));
                        updated[idx] = usage;
                        popup.coreUsages = updated;
                    }
                }
                popup.last[name] = { idle: idle, total: total };
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: coresProcGrabber.running = true
    }

    Item {
        id: avgCpu

        property real usagePercent: 0
        property real prevIdle: 0
        property real prevTotal: 0

        Process {
            id: avgCpuProc
            command: ["sh", "-c", "grep '^cpu ' /proc/stat"]
            stdout: SplitParser {
                onRead: data => {
                    let p = data.trim().split(/\s+/).slice(1).map(Number)
                    let idle = p[3] + p[4]  // idle + iowait
                    let total = p.reduce((a, b) => a + b, 0)

                    let dIdle = idle - avgCpu.prevIdle
                    let dTotal = total - avgCpu.prevTotal

                    if (avgCpu.prevTotal !== 0 && dTotal > 0) {
                        avgCpu.usagePercent = Math.max(0, Math.min(100,
                        Math.round(100 * (dTotal - dIdle) / dTotal)))
                    }

                    avgCpu.prevIdle = idle
                    avgCpu.prevTotal = total
                }
            }
        }

        Timer {
            interval: 1000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: avgCpuProc.running = true
        }
    }

    Rectangle {
        id: container
        anchors.fill: parent
        color: Colors.bg
        border.color: Colors.blue
        border.width: 1
        radius: 8

        scale: (popup.isHovered) ? 1.0 : 0.85
        opacity: (popup.isHovered) ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: container.opacity > 0 ? 200 : 200 } }

        Behavior on scale{
            SpringAnimation { 
                spring: 5
                damping: 0.4
                mass: 1
            }
        }


        MouseArea {
            id: localMouse
            anchors.fill: parent
            hoverEnabled: true
            enabled: popup.visible 
            onClicked: isPinned = !isPinned
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        }

        Column {
            id: content
            anchors.fill: parent
            anchors.margins: 15
            spacing: 6

            Text {
                text: "Core Usage"  
                color: Colors.blue
                font { pixelSize: Colors.small ; bold: true; family: Colors.fontFamily }
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Colors.muted
            }
            Repeater {
                model: popup.coreUsages.length

                Row {
                    spacing: 6
                    width: 120

                    Text {
                        text: "C" + (index+1)
                        color: Colors.blue
                        font { pixelSize: Colors.tiny; family: Colors.fontFamily }
                        width: 24
                    }
                    Rectangle {
                        width: 70
                        height: 10
                        color: Colors.cpuBar
                        radius: 5
                        y: 3
                        Rectangle {
                            width: parent.width * (popup.coreUsages[index] / 100)
                            height: parent.height
                            radius: 5
                            color: popup.coreUsages[index] > 80 ? Colors.cpuHigh
                            : popup.coreUsages[index] > 50 ? Colors.cpuMed
                            : Colors.cpuLow
                            Behavior on width { NumberAnimation { duration: 400 } ColorAnimation { duration: 400 }}
                        }
                    }
                    Text {
                        text: (popup.coreUsages[index] ?? 0) + "%"
                        color: Colors.white
                        font { pixelSize: Colors.tiny ; family: Colors.fontFamily }
                        width: 36
                    }
                }
            } 
            Rectangle {
                width: parent.width
                height: 1
                color: Colors.muted
            }

            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6

                    StyledText {
                        text: "Temp"
                        size: Colors.tiny
                        color: Colors.cBlue
                    }
                    Rectangle {
                        Layout.preferredWidth: 70
                        height: 10
                        color: Colors.cpuBar
                        radius: 5
                        Rectangle {
                            width: parent.width * Math.min(Processes.temp / 100, 1)
                            height: parent.height
                            radius: 5
                            color: Processes.temp > 90 ? Colors.cpuHigh
                            : Processes.temp > 60 ? Colors.cpuMed
                            : Colors.cpuLow
                            Behavior on width { NumberAnimation { duration: 400 } }
                            Behavior on color { ColorAnimation { duration: 400 } }
                        }
                    }
                    StyledText {
                        text: Processes.temp + "󰔄"
                        size: Colors.tiny
                        horizontalAlignment: Text.AlignRight
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6

                    StyledText {
                        text: "Avg"
                        size: Colors.tiny
                        color: Colors.cBlue
                    }
                    Item { Layout.fillWidth: true }
                    Rectangle {
                        Layout.preferredWidth: 70
                        height: 10
                        color: Colors.cpuBar
                        radius: 5
                        Rectangle {
                            width: parent.width * (avgCpu.usagePercent / 100)
                            height: parent.height
                            radius: 5
                            color: avgCpu.usagePercent > 80 ? Colors.cpuHigh
                            : avgCpu.usagePercent > 50 ? Colors.cpuMed
                            : Colors.cpuLow
                            Behavior on width { NumberAnimation { duration: 400 } }
                            Behavior on color { ColorAnimation { duration: 400 } }
                        }
                    }
                    Item{ Layout.fillWidth: true}
                    StyledText {
                        text: avgCpu.usagePercent + "%"
                        size: Colors.tiny
                        horizontalAlignment: Text.AlignRight
                    }
                }
            }
        }
    }
}
