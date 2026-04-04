import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Item {
    id: statsRoot

    property int cpuUsage: 0
    property string memUsage: "0/0" 
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0

    implicitWidth: contentRow.width + 20
    implicitHeight: 30

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

    Process {
        id: cpuCoresProc
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


    Timer {
        interval: 2000; running: true; repeat: true
        onTriggered: {
            cpuProc.running = true
            memProc.running = true
            topProcGrabber.running = true
        }
    }
}
