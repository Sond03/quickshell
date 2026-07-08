import Quickshell
import QtQuick

PanelWindow {
    id: bounceWindow
    
    implicitWidth: Screen.width
    implicitHeight: Screen.height - root.implicitHeight
    
    color: "transparent"

    aboveWindows: true

    Image {
        id: rui
        source: Qt.resolvedUrl("./assets/pictures/rui1.jpg") 
        width: 150
        height: 150
        fillMode: Image.PreserveAspectFit

        property real dx: 0
        property real dy: 0

        Component.onCompleted: {
            x = Math.random() * (bounceWindow.implicitWidth - width)
            y = Math.random() * (bounceWindow.implicitHeight - height)
            let angle = 5
            let speed = 10
            dx = Math.cos(angle) * speed
            dy = Math.sin(angle) * speed
        }

        RotationAnimation on rotation { 
            from: 0
            to: 360
            duration: 1000
            loops: Animation.Infinite
        }
    }

    Image {
        id: katniss
        source: Qt.resolvedUrl("./assets/pictures/katniss1.jpg") 
        width: 150
        height: 150
        fillMode: Image.PreserveAspectFit

        property real dx: 0
        property real dy: 0

        Component.onCompleted: {
            x = Math.random() * (bounceWindow.implicitWidth - width)
            y = Math.random() * (bounceWindow.implicitHeight - height)
            let angle = 5
            let speed = 10
            dx = Math.cos(angle) * speed
            dy = Math.sin(angle) * speed
        }

        RotationAnimation on rotation { 
            from: 0
            to: 360
            duration: 1000
            loops: Animation.Infinite
        }
    }

    Timer {
        interval: 16 // ~60 FPS
        running: true
        repeat: true
        onTriggered: {
            bounceImage(rui)
            bounceImage(katniss)
        }
}

function bounceImage(img) {
        var newX = img.x + img.dx
        var newY = img.y + img.dy

        if (newX <= 0) {
            newX = 0
            img.dx = -img.dx
        } else if (newX + img.width >= bounceWindow.implicitWidth) {
            newX = bounceWindow.implicitWidth - img.width
            img.dx = -img.dx
        }

        if (newY <= 0) {
            newY = 0
            img.dy = -img.dy
        } else if (newY + img.height >= bounceWindow.implicitHeight) {
            newY = bounceWindow.implicitHeight - img.height
            img.dy = -img.dy
        }

        img.x = newX
        img.y = newY
    }
}
