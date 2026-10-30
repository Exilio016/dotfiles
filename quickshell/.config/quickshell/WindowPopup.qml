import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    color: Colors.background
    implicitWidth: 400
    implicitHeight: layout.implicitHeight
    radius: 10

    property var workspaces: niri.workspaces
    ColumnLayout {
        id: layout
        Text {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: 10
            font.pixelSize: 24
            font.bold: true
            color: Colors.foreground
            text: "Windows"
        }

        ListView {
            model: niri.windows
            Layout.topMargin: 10
            Layout.bottomMargin: 10
            Layout.preferredWidth: 400
            Layout.preferredHeight: contentItem.childrenRect.height
            Layout.maximumHeight: 300
            orientation: Qt.Vertical
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }
            delegate: Button {
                required property int id
                required property string title
                required property int workspaceId
                required property bool isFocused
                visible: workspaceId == bar.focused_workspace
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                height: visible ? 35 : 0

                onClicked: {
                    niri.focusWindow(id);
                }

                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
                background: Rectangle {
                    color: parent.hovered ? Colors.color3 : (isFocused ? Colors.color2 : Colors.color1)
                    radius: 10
                    height: 30

                    Text {
                        text: title
                        color: Colors.foreground
                        anchors.centerIn: parent
                        elide: Text.ElideRight
                        width: Math.min(implicitWidth, parent.width - 10)
                    }
                }
            }
        }
    }
}
