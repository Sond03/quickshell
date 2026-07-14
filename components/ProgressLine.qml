import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../Colors/"

ProgressBar {
    id: progressBar
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignVCenter
    
    from: 0
    to: modelData ? modelData.length : 1
    value: modelData ? modelData.position : 0

    implicitHeight: 4

    background: Rectangle {
        implicitHeight: progressBar.implicitHeight
        color: Qt.rgba(1, 1, 1, 0.08) 
        radius: height / 2
    }

    contentItem: Item {
        implicitHeight: progressBar.implicitHeight

        Rectangle {
            width: progressBar.visualPosition * parent.width
            height: parent.height
            radius: height / 2
            
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: Colors.blue }
                GradientStop { position: 1.0; color: Colors.cyan }
            }

            layer.enabled: true
            layer.effect: ShaderEffect { }
        }
    }
}
