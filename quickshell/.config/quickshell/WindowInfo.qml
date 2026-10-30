import QtQuick
import QtQuick.Layouts

Rectangle {
    color: Colors.background
    radius: 30
    Layout.fillWidth: true
    Layout.maximumWidth: child.implicitWidth
    MouseArea {
        width: parent.width
        height: parent.height

        onClicked: {
            popup_menu.open("WindowPopup.qml", parent.x + parent.width / 2);
        }
        HoverHandler {
            cursorShape: Qt.PointingHandCursor
        }
    }
    Text {
        id: child
        text: niri.focusedWindow?.title ?? "Desktop"
        anchors.verticalCenter: parent.verticalCenter
        topPadding: 2
        leftPadding: 10
        rightPadding: 10
        font.pixelSize: 16
        color: Colors.foreground
        elide: Qt.ElideRight
        width: parent.width + 10
    }
}
