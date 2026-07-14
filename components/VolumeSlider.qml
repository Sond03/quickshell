import QtQuick
import QtQuick.Controls

import "../Colors/"

Slider {
    id: control
    from: 0
    to: 1
    implicitHeight: 20

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        width: control.availableWidth
        height: 5
        radius: height / 2
        color: Qt.rgba(1, 1, 1, 0.12)

        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            radius:5
            color: Colors.blue
        }
    }

    handle: Rectangle {
        id: handleRect
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: control.pressed ? 18 : 14
        implicitHeight: implicitWidth
        radius: implicitWidth / 2
        color: Colors.white
        border.color: Qt.rgba(0, 0, 0, 0.3)
        border.width: control.hovered || control.pressed ? 1 : 0

        // Behavior on implicitWidth {
        //     NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
        // }
    }
}
