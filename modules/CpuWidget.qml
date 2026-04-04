import QtQuick
import Quickshell
import Quickshell.Io

import "./Processes.qml" as Processes 

PopupWindow {
    id: cpuPopup
    width: 150
    height: 200
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 14

    color: "transparent"

    property bool isHovered: false 
    property string coresProc: ""

    visible: isHovered || localMouse.containsMouse || container.opacity > 0

    property var last: ({})

    Process {
        id: coresProcGrabber
        command: ["sh", "-c", "grep '^cpu[0-9]' /proc/stat"]

        stdout: SplitParser {
            onRead: data => {
                let lines = data.trim().split("\n");
                let result = "";

                for (let line of lines) {
                    let p = line.split(/\s+/);
                    let name = p[0];
                    let idle = parseInt(p[4]);
                    let total = p.slice(1).reduce((a, b) => a + parseInt(b), 0);

                    if (last[name]) {
                        let dIdle = idle - last[name].idle;
                        let dTotal = total - last[name].total;
                        if (dTotal > 0) {
                            let usage = Math.max(0, Math.min(100, Math.round(100 * (dTotal - dIdle) / dTotal)));
                            result += usage + "%\n";
                        }
                    }
                    last[name] = { idle: idle, total: total };
                }
                if (result !== "") coresProc = result;
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
        }

        Column {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 10

            Text {
                text: "Cores"
                color: "#7aa2f7"
                font { pixelSize: cpuPopup.fontSize; bold: true; family: cpuPopup.fontFamily }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#444b6a"
            }
            Text {
                text: cpuPopup.coresProc
                color: "#eeeeee" 
                font { pixelSize: cpuPopup.fontSize; bold: true; family: cpuPopup.fontFamily }
                lineHeight: 1.5
            }
        }
    }
}
