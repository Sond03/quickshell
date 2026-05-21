import QtQuick
import Quickshell
import Quickshell.Io

import "./Processes.qml" as Processes 




PopupWindow {
    id: cpuPopup
    width: 150
    height: 50 + (coreUsages.length * 22)
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 14

    property var coreUsages: []
    property string coresProc: ""

    onCoresProcChanged: {
        let lines = coresProc.trim().split("\n").filter(l => l !== "");
        coreUsages = lines.map(l => parseInt(l));
        coresProc = ""; // reset so next tick overwrites cleanly
    }

    color: "transparent"

    property bool isHovered: false 
    property bool isPinned: false

    visible: isHovered || isPinned || localMouse.containsMouse || container.opacity > 0

    property var last: ({})

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

                if (cpuPopup.last[name]) {
                    let dIdle = idle - cpuPopup.last[name].idle;
                    let dTotal = total - cpuPopup.last[name].total;
                    if (dTotal > 0) {
                        let usage = Math.max(0, Math.min(100, Math.round(100 * (dTotal - dIdle) / dTotal)));
                        let updated = [...cpuPopup.coreUsages];
                        let idx = parseInt(name.replace("cpu", ""));
                        updated[idx] = usage;
                        cpuPopup.coreUsages = updated;
                    }
                }
                cpuPopup.last[name] = { idle: idle, total: total };
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: coresProcGrabber.running = true
    }

    Rectangle {
        id: container
        anchors.fill: parent
        color: "#1a1b26"
        border.color: "#7aa2f7"
        border.width: 1
        radius: 8

        opacity: (cpuPopup.isHovered) ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: container.opacity > 0 ? 500 : 200 } }

        MouseArea {
            id: localMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: isPinned = !isPinned
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        }

        Column {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 6

            Text {
                text: "Core Usage"  
                color: "#7aa2f7"
                font { pixelSize: cpuPopup.fontSize; bold: true; family: cpuPopup.fontFamily }
                  width: parent.width
                  horizontalAlignment: Text.AlignHCenter
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#444b6a"
            }
            Repeater {
                model: cpuPopup.coreUsages.length

                Row {
                    spacing: 6
                    width: 120

                    Text {
                        text: "C" + index + ":"
                        color: "#7aa2f7"
                        font { pixelSize: cpuPopup.fontSize - 2; family: cpuPopup.fontFamily }
                        width: 24
                    }
                    Rectangle {
                        width: 70
                        height: 10
                        color: "#2a2b3a"
                        radius: 5
                        Rectangle {
                            width: parent.width * (cpuPopup.coreUsages[index] / 100)
                            height: parent.height
                            radius: 5
                            color: cpuPopup.coreUsages[index] > 80 ? "#f7768e"
                            : cpuPopup.coreUsages[index] > 50 ? "#e0af68"
                            : "#9ece6a"
                            Behavior on width { NumberAnimation { duration: 400 } }
                        }
                    }
                    Text {
                        text: (cpuPopup.coreUsages[index] ?? 0) + "%"
                        color: "#eeeeee"
                        font { pixelSize: cpuPopup.fontSize - 2; family: cpuPopup.fontFamily }
                        width: 36
                    }
                }
            } 
        }
    }
}
