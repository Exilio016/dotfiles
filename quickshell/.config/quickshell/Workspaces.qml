import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
    required property string monitor
    color: Colors.background
    Layout.fillWidth: true
    Layout.maximumWidth: child.implicitWidth
    radius: 30
    RowLayout {
        id: child
        spacing: 5
        anchors {
            verticalCenter: parent.verticalCenter
        }
        Item {
            width: 10
        }
        Repeater {
            model: niri.workspaces
            Rectangle {
                property bool active: model.isActive
                visible: (model.output == monitor)
                color: (model.isActive ? Colors.color1 : Colors.background)
                width: 24
                height: 28
                radius: 10
                MouseArea {
                    anchors.fill: parent
                    onClicked: niri.focusWorkspaceById(model.id)
                    cursorShape: Qt.PointingHandCursor
                }
                Text {
                    topPadding: 4
                    leftPadding: 6
                    font.pixelSize: 16
                    color: Colors.foreground
                    text: model.index
                }
                onActiveChanged: {
                    if (model.isActive) {
                        bar.focused_workspace = model.id
                    }
                }
            }
        }
        Item {
            width: 10
        }
    }
}
