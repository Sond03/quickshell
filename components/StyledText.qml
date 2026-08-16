import Quickshell
import QtQuick
import qs.Colors

Text {
    property bool bold: false
    font { family: Colors.fontFamily; pixelSize: Colors.regular; bold: bold }
    color: Colors.white
}
