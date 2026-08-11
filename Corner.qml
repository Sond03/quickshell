import Quickshell
import QtQuick
import QtQuick.Shapes

import qs.Colors

Shape {
    id: root
    preferredRendererType: Shape.CurveRenderer
    width: root.size
    height: root.size

    property int size: 48
    property real radius: 0
    property color fillColor: Colors.bg
    property color strokeColor: Colors.red
    property int strokeWidth: 0
    property int edge: 0


     rotation: {
        switch (root.edge) {
        case 1:  return 90
        case 2: return 180
        case 3:   return 270
        default:       return 0 
        }
    }

    ShapePath {
        fillColor: root.fillColor
        strokeColor: root.strokeColor
        strokeWidth: root.strokeWidth

        startX: 0
        startY: 0

        PathQuad {      
            x: root.width
            y: root.height
            controlX: root.width - root.radius
            controlY: root.radius
        }

        PathLine { x: root.width; y: 0 } 
        PathLine { x: 0; y: 0 }         
    }
}

