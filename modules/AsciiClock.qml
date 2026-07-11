import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets

RowLayout {
    required property SystemClock clock
    required property color digitColor
    property int size: 20

    readonly property var pattern: [
        [ 1, 1, 1,
          1, 0, 1,
          1, 0, 1,
          1, 0, 1,
          1, 1, 1, ],
        [ 0, 0, 1,
          0, 0, 1,
          0, 0, 1,
          0, 0, 1,
          0, 0, 1, ],
        [ 1, 1, 1,
          0, 0, 1,
          1, 1, 1,
          1, 0, 0,
          1, 1, 1, ],
        [ 1, 1, 1,
          0, 0, 1,
          1, 1, 1,
          0, 0, 1,
          1, 1, 1, ],
        [ 1, 0, 1,
          1, 0, 1,
          1, 1, 1,
          0, 0, 1,
          0, 0, 1, ],
        [ 1, 1, 1,
          1, 0, 0,
          1, 1, 1,
          0, 0, 1,
          1, 1, 1, ],
        [ 1, 1, 1,
          1, 0, 0,
          1, 1, 1,
          1, 0, 1,
          1, 1, 1, ],
        [ 1, 1, 1,
          0, 0, 1,
          0, 0, 1,
          0, 0, 1,
          0, 0, 1, ],
        [ 1, 1, 1,
          1, 0, 1,
          1, 1, 1,
          1, 0, 1,
          1, 1, 1, ],
        [ 1, 1, 1,
          1, 0, 1,
          1, 1, 1,
          0, 0, 1,
          1, 1, 1, ],
        [ 0, 0, 0,
          0, 1, 0,
          0, 0, 0,
          0, 1, 0,
          0, 0, 0, ],
    ];

    spacing: 12

    Repeater {
        model: Qt.formatDateTime(clock.date, "hh:mm:ss")

        delegate: GridLayout {
            id: digit

            required property string modelData

            columns: 3
            columnSpacing: 0
            rowSpacing: 0

            Repeater {
                model: 15

                delegate: Rectangle {
                    required property int modelData

                    implicitWidth: size
                    implicitHeight: size
                    color: {
                        const p = digit.modelData === ':' ? 10 : Number(digit.modelData);
                        return pattern[p][modelData] === 1 ? digitColor : 'transparent'
                    }
                }
            }
        }
    }
}
