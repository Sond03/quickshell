import QtQuick
import QtQuick.Layouts
import qs.components
import qs.modules
import qs.Colors

StyledRectangle {
    color: Colors.border2
    implicitHeight: content.implicitHeight + 10
    implicitWidth: content.implicitWidth + 10
    Layout.fillWidth: true

    RowLayout{
        id: content
        anchors.centerIn: parent
        spacing: 10
        Sysname{}
        Uptime{}
        HostName{}
        WindowManager{}
    }
}

