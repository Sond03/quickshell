import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import qs.Colors

TextField {
    id: root

    property real fieldRadius: 5
    property real borderWidthNormal: 1
    property real borderWidthFocused: 2
    property color glowColor: Colors.red

    implicitHeight: 30
    implicitWidth: 240
    leftPadding: 14
    rightPadding: 14
    color: Colors.blue
    selectionColor: Colors.cBlue
    selectedTextColor: Colors.base
    font { family: Colors.fontFamily; pixelSize: Colors.regular}
    cursorVisible: false

    cursorDelegate: Rectangle {
        width: 1.5
        color: Colors.blue
        opacity: 0

        SequentialAnimation on opacity {
            running: root.activeFocus
            loops: Animation.Infinite
            NumberAnimation { to: 1; duration: 500; easing.type: Easing.InOutQuad }
            NumberAnimation { to: 0; duration: 500; easing.type: Easing.InOutQuad }
        }
    }


    placeholderTextColor: Colors.overlay1

    HoverHandler { id: hoverHandler }

    background: Rectangle {
        id: bg
        radius: root.fieldRadius
        color: root.activeFocus ? Qt.darker(Colors.fg, 1.0) : (hoverHandler.hovered ? Colors.bg : Colors.fg)
        // border.width: root.activeFocus ? root.borderWidthFocused : root.borderWidthNormal
        // border.color: root.activeFocus ? Colors.fg : (hoverHandler.hovered ? Colors.bg : Colors.fg)

        Behavior on color {
            ColorAnimation { duration: 150; easing.type: Easing.OutCubic }
        }
    }
}
