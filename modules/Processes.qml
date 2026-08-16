pragma Singleton
import QtQuick
import Quickshell.Io
import Quickshell

Singleton {
    id: statsRoot

    property int cpuUsage: 0
    property string memUsage: "0/0" 
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0
    property var uptime: 0

    Process {
        id: memProc
        command: ["sh", "-c", "free | grep Mem"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var parts = data.trim().split(/\s+/)
                var total = (parseFloat(parts[1]) / 1048576).toFixed(1)
                var used = (parseFloat(parts[2]) / 1048576).toFixed(1)
                statsRoot.memUsage = `${used} Gb / ${total} Gb`
            }
        }
    }
    
    Process {
        id: uptimeProc
        function dayHourOrMinute(uptime) {
            if (uptime[3] != undefined) {
                return uptime[1] + uptime[2][0] + "" + uptime[3] + uptime[4][0];
            } else {
                return uptime[1] + uptime[2][0];
            }
        }

        command: ["sh", "-c", "uptime -p"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var parts = data.trim().split(/\s+/)
                var up = parts[2]
                var pretty = parts[1] + parts[2][0]
                var test = uptimeProc.dayHourOrMinute(parts)
                statsRoot.uptime = `${test}`
            }
        }
    }

    Process {
        id: cpuProc
        command: ["sh", "-c", "grep 'cpu ' /proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var parts = data.trim().split(/\s+/)
                var idle = parseInt(parts[4])
                var total = parts.slice(1).reduce((a, b) => a + parseInt(b), 0)

                var diffIdle = idle - statsRoot.lastCpuIdle
                var diffTotal = total - statsRoot.lastCpuTotal

                statsRoot.cpuUsage = Math.round(100 * (1 - diffIdle / diffTotal))
                statsRoot.lastCpuIdle = idle
                statsRoot.lastCpuTotal = total
            }
        }
    }

    property string topProcs: ""
    property string tempBuffer: ""

    Process {
        id: topProcGrabber
        command: ["sh", "-c", "ps -eo comm:15,%mem --sort=-%mem | head -n 6 | tail -n 5"]

        stdout: SplitParser {
            onRead: data => {
                tempBuffer += data + "%" + "\n"
            }
        }

        onExited: {
            topProcs = tempBuffer.trim()
            tempBuffer = "" 
        }
    }

    Timer {
        interval: 2000; running: true; repeat: true
        onTriggered: {
            cpuProc.running = true
            memProc.running = true
            topProcGrabber.running = true
            uptimeProc.running = true
        }
    }
}
