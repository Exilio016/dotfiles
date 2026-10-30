import QtQuick
import Quickshell

Item {
    id: root

    property int currentViewMonth
    property int currentViewYear
    property string currentMonthStr
    property var monthDays
    property string selectedDateStr

    signal changeMonth(int offset)
    signal dateSelected(string dateStr)
    Column {
        anchors.fill: parent
        anchors {
            topMargin: 20
            bottomMargin: 0
            leftMargin: 20
            rightMargin: 20
        }
        spacing: 20

        Row {
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            // Previous Month Button
            Rectangle {
                width: 32
                height: 32
                radius: 16
                color: prevMouseArea.containsMouse ? Colors.color1 : "transparent"
                Text {
                    text: "◀"
                    anchors.centerIn: parent
                    color: Colors.background
                    font.pixelSize: 14
                }
                MouseArea {
                    id: prevMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.changeMonth(-1)
                }
            }

            Text {
                text: root.currentMonthStr
                font.pixelSize: 28
                font.bold: true
                font.family: "Inter"
                color: Colors.background
                anchors.verticalCenter: parent.verticalCenter
            }

            // Next Month Button
            Rectangle {
                width: 32
                height: 32
                radius: 16
                color: nextMouseArea.containsMouse ? Colors.color1 : "transparent"
                Text {
                    text: "▶"
                    anchors.centerIn: parent
                    color: Colors.background
                    font.pixelSize: 14
                }
                MouseArea {
                    id: nextMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.changeMonth(1)
                }
            }
        }

        Row {
            width: parent.width
            spacing: 0
            Repeater {
                model: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                Text {
                    width: parent.width / 7
                    text: modelData
                    font.pixelSize: 14
                    font.bold: true
                    font.family: "Inter"
                    color: Colors.background
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        // The actual 7x6 month grid
        GridView {
            id: calGrid
            width: parent.width
            height: parent.height - 100
            cellWidth: width / 7
            cellHeight: height / 6
            model: root.monthDays
            interactive: false

            delegate: Rectangle {
                width: calGrid.cellWidth - 10
                height: calGrid.cellHeight - 10

                color: modelData.isCurrentMonth ? Colors.color1 : Colors.color2
                radius: 12

                // Dim all unselected days, but less aggressively
                opacity: root.selectedDateStr === "" || root.selectedDateStr === modelData.dateStr ? 1.0 : 0.5
                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }

                border.color: modelData.dateStr === new Date().toDateString() ? Colors.color3 : "transparent"
                border.width: 2

                Text {
                    anchors.centerIn: parent
                    text: modelData.dayNum
                    font.pixelSize: 18
                    font.family: "Inter"
                    font.bold: modelData.dateStr === new Date().toDateString()
                    color: modelData.isCurrentMonth ? Colors.foreground : Colors.background
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (root.selectedDateStr === modelData.dateStr) {
                            root.dateSelected("");
                        } else {
                            root.dateSelected(modelData.dateStr);
                        }
                    }
                }
            }
        }
    }
}
