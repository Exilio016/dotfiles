import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

Rectangle {
    color: Colors.color7
    implicitWidth: main_layout.implicitWidth
    implicitHeight: main_layout.implicitHeight
    radius: 10

    Process {
        id: system_command_executor
        command: []
        running: false
    }

    Dialog {
        id: confirm_dialog
        anchors.centerIn: parent
        modal: true
        title: "Are you sure?"
        standardButtons: Dialog.Ok | Dialog.Cancel

        // Custom property to hold what command is about to be fired
        property var stagedCommand: []

        Text {
            id: confirm_text
            text: "Are you sure you want to proceed?"
            font.pixelSize: 14
            color: Colors.background
        }

        onAccepted: {
            system_command_executor.command = stagedCommand;
            system_command_executor.running = true;
        }
    }
    ColumnLayout {
        id: main_layout
        anchors.fill: parent

        Text {
            font.pixelSize: 24
            font.bold: true
            text: "Control Panel"
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 10
        }

        Text {
            visible: notification_list.count > 0
            font.pixelSize: 16
            Layout.alignment: Qt.AlignHCenter
            text: "────────────────────────────────────────────────────────"
        }
        FlexboxLayout {
            visible: notification_list.count > 0
            wrap: FlexboxLayout.Wrap
            direction: FlexboxLayout.Row
            justifyContent: FlexboxLayout.JustifySpaceBetween
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            Text {
                font.pixelSize: 16
                text: "Notifications"
            }
            Button {
                id: clear_btn
                Layout.alignment: Qt.AlignTop
                onClicked: {
                    notification_list.clear();
                }

                background: Rectangle {
                    implicitWidth: 40
                    implicitHeight: 20
                    radius: 10
                    color: clear_btn.down ? Colors.color2 : (clear_btn.hovered ? Colors.color3 : Colors.color1)
                }
                contentItem: Text {
                    color: Colors.foreground
                    text: "Clear"
                }
                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
        ListView {
            Layout.preferredHeight: contentItem.childrenRect.height
            Layout.preferredWidth: contentItem.childrenRect.width
            Layout.maximumHeight: 400
            Layout.fillWidth: true
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            spacing: 5
            orientation: Qt.Vertical
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }
            model: notification_list
            delegate: NotificationItem {
                id: element
                Layout.alignment: Qt.AlignHCenter
                width: 540
                show: true
                dismiss: function () {
                    for (var i = 0; i < notification_list.count; i++) {
                        if (notification_list.get(i).key == element.key) {
                            notification_list.remove(i);
                            return;
                        }
                    }
                }
            }
        }

        Text {
            font.pixelSize: 16
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            Layout.alignment: Qt.AlignHCenter
            text: "────────────────────────────────────────────────────────"
        }
        RowLayout {
            spacing: 12
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 10

            // 1. Lock Screen
            PowerButton {
                label: "Lock"
                iconName: "system-lock-screen"
                requireConfirmation: false
                commandArgs: ["swaylock"]
            }

            // 2. Log Out
            PowerButton {
                label: "Log Out"
                iconName: "system-log-out"
                // Gracefully terminates the current user session
                commandArgs: ["loginctl", "terminate-user", ""]
            }

            // 3. Suspend / Hibernate / Hybrid options
            PowerButton {
                label: "Suspend"
                iconName: "system-suspend"
                commandArgs: ["systemctl", "suspend"]
            }

            // 4. Reboot
            PowerButton {
                label: "Reboot"
                iconName: "system-reboot"
                commandArgs: ["systemctl", "reboot"]
            }

            // 5. Shut Down
            PowerButton {
                label: "Shut Down"
                iconName: "system-shutdown"
                commandArgs: ["systemctl", "poweroff"]
            }
        }
    }

    // Reusable template for executing system power commands
    component PowerButton: Rectangle {
        id: btn
        required property string label
        required property string iconName
        required property var commandArgs
        property bool requireConfirmation: true

        implicitWidth: 90
        implicitHeight: 80
        radius: 8
        color: mouseArea.containsMouse ? Colors.color2 : Colors.background
        border.color: mouseArea.containsMouse ? Colors.color1 : "transparent"
        border.width: 3

        Process {
            id: proc
            command: btn.commandArgs
            // Explicitly set running to false so it only fires when we manually call it
            running: false
        }
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                if (btn.requireConfirmation) {
                    confirm_text.text = "Are you sure you want to " + btn.label.toLowerCase() + "?";
                    confirm_dialog.stagedCommand = btn.commandArgs;
                    confirm_dialog.open();
                } else {
                    system_command_executor.command = btn.commandArgs;
                    system_command_executor.running = true;
                }
            }
            HoverHandler {
                cursorShape: Qt.PointingHandCursor
            }
        }

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 6

            IconImage {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: 36
                Layout.preferredWidth: 36
                source: Quickshell.iconPath(btn.iconName)
            }

            Text {
                text: btn.label
                font.pixelSize: 12
                color: Colors.foreground
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
