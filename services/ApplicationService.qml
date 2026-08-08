pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    readonly property var applications: DesktopEntries.applications

    function search(query) {
        return applications.values.filter(app =>
            app.name.toLowerCase().includes(query.toLowerCase())
        )
    }
}
