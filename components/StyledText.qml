import Quickshell
import QtQuick
import qs.Colors

Text {
    property bool bold: false
    property int size: Colors.regular
    font { family: Colors.fontFamily; pixelSize: size; bold: bold }
    color: Colors.white
}
