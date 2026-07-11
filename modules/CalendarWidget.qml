import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

import "../Colors"

PopupWindow {
    id: popup
    implicitWidth: 500
    implicitHeight: 460

    color: "transparent"

    property bool isHovered: false 
    property bool isPinned: false
    property string procData: ""

    visible: isHovered || isPinned || container.opacity > 0 


    Rectangle {
        id: container
        anchors.fill: parent
        color: Colors.bg
        border.color: Colors.blue
        border.width: 0
        radius: 8

        scale: (popup.isHovered) ? 1.0 : 0.85
        opacity: (popup.isHovered) ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: container.opacity > 0 ? 200 : 200 } }

        Behavior on scale{
            SpringAnimation { 
                spring: 5
                damping: 0.4
                mass: 1
            }
        }

        MouseArea {
            id: localMouse
            anchors.fill: parent
            hoverEnabled: true
            enabled: popup.visible 
        }

        ColumnLayout {
            id: column
            anchors.fill: parent
            anchors.margins: 15
            spacing: 15
            property date viewedDate: new Date()

            RowLayout {
                Layout.fillWidth: true
                spacing: 20

                Button {
                    id: leftBtn
                    text: ""
                    flat: true
                    Layout.preferredWidth: 30
                    Layout.fillHeight: true
                    HoverHandler { id: leftBtnHandler; cursorShape: Qt.PointingHandCursor }

                    contentItem: Text {
                        text: leftBtn.text
                        color: leftBtn.hovered ? "#00f0ff" : Colors.blue
                        font { family: Colors.fontFamily; pixelSize: Colors.huge; bold: true }
                        horizontalAlignment: Text.AlignHCenter
                        scale:  leftBtnHandler.hovered ? 1.3 : 1
                        Behavior on scale{
                            SpringAnimation { 
                                spring: 5
                                damping: 0.4
                                mass: 1
                            }
                        }
                    }

                    background: Rectangle { 
                        id: leftBtnBg
                        color: leftBtn.hovered ? Qt.lighter(Colors.fg, 1.4) : Colors.fg
                        radius: width / 2
                        scale:  leftBtnHandler.hovered ? 1.3 : 1
                        Behavior on scale{
                            SpringAnimation { 
                                spring: 5
                                damping: 0.4
                                mass: 1
                            }
                        }
                    }

                    onClicked: {
                        var current = new Date(column.viewedDate.getFullYear(), column.viewedDate.getMonth() - 1, 1);
                        column.viewedDate = current;
                    }
                }

                Item {
                    id: monthLabelWrapper
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    readonly property date today: new Date()
                    readonly property bool isCurrentMonth:
                    column.viewedDate.getFullYear() === today.getFullYear() && column.viewedDate.getMonth() === today.getMonth()

                    readonly property bool isFuture: 
                    column.viewedDate.getFullYear() > today.getFullYear() || (column.viewedDate.getFullYear() === today.getFullYear()
                    && column.viewedDate.getMonth() > today.getMonth())

                    Rectangle {
                        id: labelBg
                        anchors.centerIn: parent
                        width: monthText.implicitWidth + 24
                        height: monthText.implicitHeight + 10
                        radius: 15
                        color: monthMouseArea.containsMouse ? Qt.lighter(Colors.fg, 1.4) : Colors.fg

                        scale: monthMouseArea.containsMouse  ? 1.1 : 1
                        Behavior on scale{
                            SpringAnimation { 
                                spring: 5
                                damping: 0.4
                                mass: 1
                            }
                        }

                        Behavior on color { ColorAnimation { duration: 220 } }
                    }

                    Text {
                        id: monthText
                        anchors.centerIn: parent
                        text: Qt.formatDate(column.viewedDate, "MMMM yyyy")
                        font.pixelSize: 32
                        font.bold: true
                        font.family: "JetBrains Mono"
                        color: Colors.blue

                        scale: monthMouseArea.containsMouse  ? 1.1 : 1
                        Behavior on scale{
                            SpringAnimation { 
                                spring: 5
                                damping: 0.4
                                mass: 1
                            }
                        }
                    }

                    MouseArea {
                        id: monthMouseArea
                        anchors.fill: labelBg
                        hoverEnabled: true
                        cursorShape: monthLabelWrapper.isCurrentMonth ? Qt.ArrowCursor : Qt.PointingHandCursor
                        enabled: !monthLabelWrapper.isCurrentMonth
                        onClicked: {
                            column.viewedDate = new Date();
                        }
                    }
                }
                Button {
                    id: rightBtn
                    text: ""
                    flat: true
                    Layout.preferredWidth: 30
                    Layout.fillHeight: true
                    HoverHandler { id: rightBtnHandler; cursorShape: Qt.PointingHandCursor }

                    contentItem: Text {
                        text: rightBtn.text
                        color: rightBtn.hovered ? "#00f0ff" : Colors.blue
                        font { family: Colors.fontFamily; pixelSize: Colors.huge; bold: true }
                        horizontalAlignment: Text.AlignHCenter
                        Behavior on scale{
                            SpringAnimation { 
                                spring: 5
                                damping: 0.4
                                mass: 1
                            }
                        }
                        scale:  rightBtnHandler.hovered ? 1.3 : 1
                    }

                    background: Rectangle { 
                        id: rightBtnBg
                        color: rightBtn.hovered ? Qt.lighter(Colors.fg, 1.4) : Colors.fg
                        radius: width / 2
                        scale:  rightBtnHandler.hovered ? 1.3 : 1
                        Behavior on scale{
                            SpringAnimation { 
                                spring: 5
                                damping: 0.4
                                mass: 1
                            }
                        }
                    }

                    onClicked: {
                        var current = new Date(column.viewedDate.getFullYear(), column.viewedDate.getMonth() + 1, 1);
                        column.viewedDate = current;
                    }
                }
            }
            GridLayout {
                columns: 2
                rows: 2
                columnSpacing: 5
                rowSpacing: 5
                Layout.fillWidth: true
                Layout.fillHeight: true


                DayOfWeekRow {
                    locale: grid.locale
                    Layout.row: 0
                    Layout.column: 1
                    Layout.fillWidth: true

                    delegate: Text {
                        text: shortName
                        font { family: Colors.fontFamily; pixelSize: Colors.small; bold: true }
                        color: Colors.white
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter


                        required property string shortName
                    }
                }

                WeekNumberColumn {
                    id: weekColumn
                    month: grid.month
                    year: grid.year
                    locale: grid.locale

                    Layout.row: 1
                    Layout.column: 0
                    Layout.fillHeight: true

                    delegate: Text {
                        readonly property var rowDate: new Date(grid.year, grid.month, 1 + (model.index * 7) - new Date(grid.year, grid.month, 1).getDay())
                        text: weekNumber
                        font { family: Colors.fontFamily; pixelSize: Colors.small; bold: false }
                        color: "#565f89"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                    }
                }

                MonthGrid {
                    id: grid
                    month: column.viewedDate.getMonth()
                    year: column.viewedDate.getFullYear()
                    locale: Qt.locale()

                    delegate: Item {
                        readonly property bool isToday: model.day === new Date().getDate() && 
                        model.month === new Date().getMonth() && 
                        model.year === new Date().getFullYear()

                        implicitWidth: 45
                        implicitHeight: 45
                        z: box.hovered ? 1 : 0

                        Rectangle { 
                            id: box
                            clip: false
                            HoverHandler { id: hoverHandler}
                            property bool hovered: hoverHandler.hovered
                            anchors.centerIn: parent
                            width: isToday ? parent.width + 2 : parent.width
                            height: isToday ? parent.width + 2 : parent.height 
                            radius: 5
                            opacity: model.month === grid.month ? 1 : 0

                            color: hovered ? Colors.muted : Colors.fg 
                            scale: hovered ? 1.3 : 1
                            Behavior on scale{
                                SpringAnimation { 
                                    spring: 5
                                    damping: 0.4
                                    mass: 1
                                }
                            }
                        }
                        Text {
                            anchors.centerIn: parent
                            opacity: model.month === grid.month ? 1 : 0
                            text: grid.locale.toString(model.date, "d")
                            font { family: Colors.fontFamily; pixelSize: Colors.normal; bold: true; underline: isToday }
                            color: isToday ? Colors.cyan : Colors.blue

                        }
                    }


                    Layout.row: 1
                    Layout.column: 1
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }
    }
}


