import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import qs.Colors

TextField {
    id: root

    property real fieldRadius: 5
    property real borderWidthNormal: 1
    property real borderWidthFocused: 2
    property color glowColor: Colors.white

    implicitHeight: 30
    implicitWidth: 240
    leftPadding: 14
    rightPadding: 14
    color: Colors.blue
    selectionColor: Colors.blue
    selectedTextColor: Colors.bg
    font {family: Colors.fontFamily; pixelSize: Colors.regular}
    cursorVisible: activeFocus
    selectByMouse: true

    Timer {
        interval: 530
        running: root.activeFocus
        repeat: true
        onTriggered: root.cursorVisible = !root.cursorVisible
    }
    onActiveFocusChanged: if (activeFocus) root.cursorVisible = true

    placeholderTextColor: Colors.muted

    HoverHandler {
        id: hoverHandler
    }

    background: Rectangle {
        id: bg
        radius: root.fieldRadius
        color: root.activeFocus
               ? Qt.darker(Colors.fg, 1.0)
               : (hoverHandler.hovered ? Colors.bg : Colors.fg)
        border.width: root.activeFocus ? root.borderWidthFocused : root.borderWidthNormal
        border.color: root.activeFocus
                      ? Colors.fg
                      : (hoverHandler.hovered ? Colors.bg : Colors.fg)

        Behavior on color {
            ColorAnimation { duration: 150; easing.type: Easing.OutCubic }
        }
        Behavior on border.color {
            ColorAnimation { duration: 150; easing.type: Easing.OutCubic }
        }
        Behavior on border.width {
            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
        }

        scale: root.activeFocus ? 1.015 : 1.0
        Behavior on scale {
            NumberAnimation {
                duration: 220
                easing.type: Easing.OutBack
                easing.overshoot: 4
            }
        }

    }
}
