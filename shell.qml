import Quickshell 
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

PanelWindow {
    id: root
    property color colBg: "#1a1b26"
    property color colFg: "#a9b1d6"
    property color colMuted: "#444b6a"
    property color colCyan: "#0db9d7"
    property color colBlue: "#7aa2f7"
    property color colYellow: "#e0af68"
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 16


    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 40
    color: "transparent"


    Rectangle {
        id: background
        anchors.fill: parent 
        anchors.leftMargin: 6
        anchors.rightMargin: 6
        // anchors.bottomMargin: 5
        // anchors.topMargin: 5
        opacity: 0.75
        radius: 10
        color: root.colBg
    }

    RowLayout {
        anchors.fill: background
        anchors.margins: 8
        spacing: 2
        Repeater {
            model: 5

            Rectangle {
                id: workspaceCircle
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: width

                property var workspace: Hyprland.workspaces.values.find(w => w.id == index + 1)
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

                width: isActive ? 45 : 30
                height: 22
                radius: isActive ? width / 4.5  : width / 2

                color: mouseArea.containsMouse ? "#F4F4F4" : isActive ? "#2fbde7" : workspace ? "#6f9eb7" : "#1d1e2f"


                Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

                Text {
                    text: index +1
                    anchors.centerIn: parent 
                    // font { family: root.fontFamily; pointSize: 13; bold: true; }
                    font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
                    color: mouseArea.containsMouse ? "#1d1e2f" : "#00FFF" 
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent 
                    hoverEnabled: true
                    onClicked: Hyprland.dispatch("workspace " + (index + 1))
                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                }
            }
        }
        Item { Layout.fillWidth: true }
    }
}
            // Text {
            //     property var workspace: Hyprland.workspaces.values.find(w => w.id == index + 1)
            //     property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
            //
            //     text: index + 1
            //     // color : isActive ? "#0db9d7" : (workspace ? "#7aa2f7" : "#1d1e2f")
            //     // color: mouseArea.containsMouse ? "white" : "black"
            //     font { pointSize: 14; bold: true; }
            //
            //     MouseArea{
            //         id: mouseArea
            //         anchors.fill: parent
            //         onClicked: Hyprland.dispatch("workspace " + (index + 1)) 
            //         acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            //         hoverEnabled: true
            //     }
            //     color: mouseArea.containsMouse ? "white" : (isActive ? "#0db9d7" : (workspace ? "#7aa2f7" : "#1d1e2f"))
            // }
