import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import Quickshell

Rectangle {
    property int fontSize: 16
    color: "transparent"
    Layout.fillWidth: true
    Layout.maximumWidth: child.implicitWidth

    RowLayout {
        id: child
        spacing: -20
        MenuItem {
            visible: light.enabled
            itemColor: Colors.color2
            MouseArea {
                anchors.verticalCenter: parent.verticalCenter
                implicitWidth: light_text.implicitWidth
                implicitHeight: parent.implicitHeight
                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
                onWheel: w => {
                    let per = light.percent;
                    per += w.angleDelta.y > 0 ? 1 : -1;
                    per = Math.min(Math.max(per, 0), 100);
                    light.setValue(per);
                }
                Text {
                    id: light_text
                    anchors.verticalCenter: parent.verticalCenter
                    text: light.text
                    font.pixelSize: fontSize
                }
            }
        }
        MenuItem {
            itemColor: Colors.color3
            MouseArea {
                anchors.verticalCenter: parent.verticalCenter
                implicitWidth: vol_text.implicitWidth
                implicitHeight: parent.implicitHeight
                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
                onWheel: w => {
                    let per = Math.round(audio.sink.audio.volume * 100);
                    per += w.angleDelta.y > 0 ? 1 : -1;
                    per = Math.min(Math.max(per, 0), 100);
                    audio.sink.audio.volume = per / 100;
                }
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                onClicked: event => {
                    if (event.button == Qt.LeftButton) {
                        var pos = mapToItem(null, parent.x, parent.y).x;
                        popup_menu.open("VolumePopup.qml", pos + parent.implicitWidth / 2);
                    } else if (event.button == Qt.MiddleButton)
                        audio.sink.audio.muted = !audio.sink.audio.muted;
                    else {
                        pavucontrol.running = true;
                    }
                }
                Text {
                    id: vol_text
                    anchors.verticalCenter: parent.verticalCenter
                    function getVolumeIcon(volume, muted): string {
                        if (muted)
                            return "  ";
                        if (volume < 0.5)
                            return "  ";
                        return "  ";
                    }
                    text: Math.round(audio.sink.audio.volume * 100) + getVolumeIcon(audio.sink.audio.volume, audio.sink.audio.muted)
                    font.pixelSize: fontSize
                }
            }
        }
        MenuItem {
            itemColor: Colors.color4
            MouseArea {
                anchors.verticalCenter: parent.verticalCenter
                implicitWidth: bat_text.implicitWidth
                implicitHeight: parent.implicitHeight
                onClicked: {
                    var pos = mapToItem(null, parent.x, parent.y).x;
                    popup_menu.open("PowerPopup.qml", pos + implicitWidth / 2);
                }
                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
                Text {
                    id: bat_text
                    anchors.verticalCenter: parent.verticalCenter
                    function getBatteryIcon(percentage): string {
                        let icon = "  ";
                        if (percentage < 0.5)
                            icon = "  ";
                        else if (percentage < 0.75)
                            icon = "  ";
                        else if (percentage < 1)
                            icon = "  ";
                        else if (percentage == 1)
                            icon = "  ";
                        if (UPower.onBattery)
                            return "";
                        return icon + "󱐋";
                    }
                    text: Math.round(UPower.displayDevice.percentage * 100) + getBatteryIcon(UPower.displayDevice.percentage)
                    font.pixelSize: fontSize
                }
            }
        }
        MenuItem {
            itemColor: Colors.color5

            MouseArea {
                anchors.verticalCenter: parent.verticalCenter
                implicitWidth: time_text.implicitWidth
                implicitHeight: parent.implicitHeight
                onClicked: {
                    var pos = mapToItem(null, parent.x, parent.y).x;
                    popup_menu.open("CalendarPopup.qml", pos + implicitWidth / 2);
                }
                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
                Text {
                    id: time_text
                    anchors.verticalCenter: parent.verticalCenter
                    text: Qt.formatDateTime(clock.date, "hh:mm  ")
                    font.pixelSize: fontSize
                }
            }
        }
        MenuItem {
            itemColor: Colors.color6
            Tray {}
        }
        MenuItem {
            itemColor: Colors.color7
            padding: 10

            MouseArea {
                anchors.verticalCenter: parent.verticalCenter
                implicitWidth: settings_text.implicitWidth
                implicitHeight: parent.implicitHeight
                onClicked: {
                    popup_menu.open("SettingsPopup.qml", 0);
                }
                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
                Text {
                    id: settings_text
                    anchors.verticalCenter: parent.verticalCenter
                    text: " ⏻  "
                    font.pixelSize: fontSize
                }
            }
        }
    }
}
