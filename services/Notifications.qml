pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.Notifications

Singleton {
    id: root 

    property var notifications: notificationServer.trackedNotifications
    property alias history: history

    ListModel { id: history }
    NotificationServer {
        id: notificationServer
        actionsSupported: true
        imageSupported: true
        inlineReplySupported: true
        keepOnReload: true // false in live

        onNotification: notif => {
            notif.tracked = true
            // notif.Retainable.lock()
            // TODO: make it retained and deleted
            history.insert(0, {
                summary: notif.summary,
                body: notif.body,
                appName: notif.appName,
                appIcon: notif.appIcon,
                image: notif.image,
                urgency: notif.urgency,
                time: Qt.formatDateTime(new Date(), "HH:mm")
                // notifObj: notif
                // TODO
            })
        }
    }

    function dismissAll(){ history.clear() }
    function dismiss(index){ history.remove(index, 1)}
    // TODO: make these delete the retained notif
}
