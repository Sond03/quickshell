pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string countryCode: "NO"
    property string cacheDir: Quickshell.env("HOME") + "/.cache/quickshell/holidays"
    property var dates: ({})
    property var loadedYears: []
    property var queue: []
    property string currentFile: ""

    function isHoliday(date){
        return root.dates[Qt.formatDate(date, "yyyy-MM-dd")] !== undefined
    }

    function holidayName(date) {
        return root.dates[Qt.formatDate(date, "yyyy-MM-dd")]
    }


    function ensureLoadedYear(year) {
        if (loadedYears.indexOf(year) !== -1 || queue.indexOf(year) !== -1) return
        queue.push(year);
        if (!fetchProc.running){
            processQueue()
        }
    }

    function processQueue(){
        if (queue.length === 0){
            return
        }
        var year = queue.shift()
        currentFile = cacheDir + "/" + year + ".json"
        fetchProc.year = year
        fetchProc.running = true
    }

    Process {
        id: fetchProc
        property int year
        command: [
            "sh", "-c",
            'test -s "$1" || curl -sf --create-dirs -o "$1" "$2"',
            "-", root.currentFile,
            "https://date.nager.at/api/v4/Holidays/" + root.countryCode + "/" + year
        ]
        onExited: (code, status) => {
            file.path = ""
            file.path = root.currentFile
        }
    }

    FileView {
        id: file
        blockLoading: false
        onLoaded: {
            try{
                var list = JSON.parse(this.text())
                var d = root.dates
                for (var i = 0; i < list.length; i++){
                    d[list[i].date] = list[i].name
                }
                root.dates = d
            } catch(e){
                console.warn("[Holidays] parse failed for", fetchProc.year, e)
            }
            root.loadedYears.push(fetchProc.year)
            root.processQueue()
        }
    }
    Component.onCompleted: {
        var y = new Date().getFullYear()
        ensureLoadedYear(y - 1)
        ensureLoadedYear(y)
        ensureLoadedYear(y + 1)
    }
}

