pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.Notifications

Singleton {
    id: root 

    property var notifications: notificationServer.trackedNotifications

    NotificationServer {
        id: notificationServer
        actionsSupported: true
        imageSupported: true
        inlineReplySupported: true
        keepOnReload: true // false in live

        onNotification: notif => {
            notif.tracked = true
        }
    }

}
