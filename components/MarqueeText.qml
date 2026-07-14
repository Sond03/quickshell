import QtQuick
import QtQuick.Layouts

Item {
    id: marqueeContainer
    
    property string text: ""
    property color color: "white"
    property font font
    
    Layout.fillWidth: true
    implicitHeight: hiddenMeasurer.implicitHeight 
    clip: true 

    readonly property real maxScroll: (parent && parent.width > 0) ? Math.max(0, hiddenMeasurer.implicitWidth - parent.width) : 0

    Text {
        id: hiddenMeasurer
        text: marqueeContainer.text
        font: marqueeContainer.font
        visible: false
    }

    Text {
        id: movingText
        text: marqueeContainer.text
        color: marqueeContainer.color
        font: marqueeContainer.font
        y: 0
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        
        propagateComposedEvents: true
        onClicked: (mouse) => mouse.accepted = false
    }

    SequentialAnimation {
        id: scrollAnimation
        running: marqueeContainer.maxScroll > 0 && hoverArea.containsMouse
        loops: Animation.Infinite

        PauseAnimation { duration: 500 }

        NumberAnimation {
            target: movingText
            property: "x"
            from: 0
            to: -marqueeContainer.maxScroll
            duration: Math.max(1000, marqueeContainer.maxScroll * 30) // Dynamic speed
            easing.type: Easing.InOutQuad
        }

        PauseAnimation { duration: 1500 }

        NumberAnimation {
            target: movingText
            property: "x"
            to: 0
            duration: 800
            easing.type: Easing.InOutCubic
        }
    }

    Connections {
        target: hoverArea
        function onContainsMouseChanged() {
            if (!hoverArea.containsMouse) {
                resetTimer.start();
            } else {
                resetTimer.stop();
            }
        }
    }

    Timer {
        id: resetTimer
        interval: 50
        onTriggered: movingText.x = 0
    }

    onTextChanged: {
        movingText.x = 0;
    }
    
    onWidthChanged: {
        movingText.x = 0;
    }
}
