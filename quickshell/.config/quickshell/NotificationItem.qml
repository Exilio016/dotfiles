import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: not_item
    required property string image
    required property string summary
    required property string body
    required property string key

    required property bool show
    required property var dismiss
    implicitWidth: not_main_layout.implicitWidth + 10
    implicitHeight: not_main_layout.implicitHeight + 10

    color: Colors.background
    radius: 10
    border {
        color: Colors.color1
        width: 3
    }
    RowLayout {
        id: not_main_layout
        anchors.right: parent.right
        anchors.left: parent.left
        Image {
            id: not_image
            Layout.preferredHeight: 60
            Layout.preferredWidth: 60
            source: not_item.image
            visible: not_item.image != ""
            Layout.topMargin: 10
            Layout.leftMargin: 10
        }
        ColumnLayout {
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 10
            Layout.leftMargin: 10
            Text {
                id: not_summary
                color: Colors.foreground
                font.pixelSize: 16
                font.bold: true
                text: not_item.summary
                elide: Text.ElideRight
                Layout.preferredWidth: Math.min(implicitWidth, 380)
            }

            Text {
                id: not_body
                color: Colors.foreground
                font.pixelSize: 14
                text: not_item.body
                visible: not_item.body != ""
                elide: Text.ElideRight
                Layout.preferredWidth: Math.min(implicitWidth, 380)
            }
        }
        Item {
            Layout.fillWidth: true
        }
        Button {
            id: not_dismiss
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 10
            Layout.rightMargin: 10
            property var dismiss
            text: "Dismiss"
            onClicked: {
                not_item.dismiss();
            }

            background: Rectangle {
                implicitWidth: 40
                implicitHeight: 20
                radius: 10
                color: not_dismiss.down ? Colors.color2 : (not_dismiss.hovered ? Colors.color3 : Colors.color1)
            }
            contentItem: Text {
                color: Colors.foreground
                text: not_dismiss.text
            }
            HoverHandler {
                cursorShape: Qt.PointingHandCursor
            }
        }
    }
}
