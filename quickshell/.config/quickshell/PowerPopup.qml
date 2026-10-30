import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.UPower

Rectangle {
    color: Colors.color4
    implicitWidth: 400
    implicitHeight: 200
    radius: 10

    ColumnLayout {
        id: main_layout
        anchors.fill: parent
        anchors.bottomMargin: 10
        spacing: 10

        Text {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: 10
            font.pixelSize: 24
            font.bold: true
            text: "Power Profile"
        }

        Button {
            id: perf_btn
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 380
            Layout.preferredHeight: 40
            onClicked: {
                PowerProfiles.profile = PowerProfile.Performance;
            }
            background: Rectangle {
                anchors.fill: parent
                color: perf_btn.down ? Colors.color2 : (perf_btn.hovered ? Colors.color1 : Colors.background)
                border {
                    color: PowerProfiles.profile == PowerProfile.Performance ? Colors.color2 : Colors.color1
                    width: 4
                }
                Text {
                    text: "Performance"
                    color: Colors.foreground
                    anchors.centerIn: parent
                }
                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
        Button {
            id: balance_btn
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 380
            Layout.preferredHeight: 40
            onClicked: {
                PowerProfiles.profile = PowerProfile.Balanced;
            }
            background: Rectangle {
                anchors.fill: parent
                color: balance_btn.down ? Colors.color2 : (balance_btn.hovered ? Colors.color1 : Colors.background)
                border {
                    color: PowerProfiles.profile == PowerProfile.Balanced ? Colors.color2 : Colors.color1
                    width: 4
                }
                Text {
                    text: "Balanced"
                    color: Colors.foreground
                    anchors.centerIn: parent
                }
                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
        Button {
            id: psaver_btn
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 380
            Layout.preferredHeight: 40
            onClicked: {
                PowerProfiles.profile = PowerProfile.PowerSaver;
            }
            background: Rectangle {
                anchors.fill: parent
                color: psaver_btn.down ? Colors.color2 : (psaver_btn.hovered ? Colors.color1 : Colors.background)
                border {
                    color: PowerProfiles.profile == PowerProfile.PowerSaver ? Colors.color2 : Colors.color1
                    width: 4
                }
                Text {
                    text: "Power Saver"
                    color: Colors.foreground
                    anchors.centerIn: parent
                }
                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }
}
