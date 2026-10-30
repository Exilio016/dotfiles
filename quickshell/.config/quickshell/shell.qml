//@ pragma RespectSystemStyle
//@ pragma UseQApplication
pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Niri
import Quickshell.Services.Pipewire
import "UuidUtis.js" as UUID
import Quickshell.Services.Notifications

ShellRoot {
    id: root
    property Notification notification: null
    property bool notification_visible: false

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property var modelData
            property int focused_workspace: 1
            screen: modelData
            color: "#80000000" //Transparent

            anchors {
                top: true
                left: true
                right: true
            }
            implicitHeight: 40
            FlexboxLayout {
                id: flexLayout
                anchors.fill: parent
                wrap: FlexboxLayout.Wrap
                direction: FlexboxLayout.Row
                justifyContent: FlexboxLayout.JustifySpaceBetween
                Workspaces {
                    monitor: bar.screen.name
                    implicitHeight: parent.height
                }
                WindowInfo {
                    implicitHeight: parent.height
                }
                Menus {
                    implicitHeight: parent.height
                }
            }

            PopupWindow {
                id: popup_menu
                grabFocus: true
                color: 'transparent'
                implicitWidth: popup_menu_loader.implicitWidth
                implicitHeight: popup_menu_loader.implicitHeight
                anchor {
                    window: bar
                    rect.x: parentWindow.width - 10
                    rect.y: parentWindow.height + 5
                }
                Loader {
                    id: popup_menu_loader
                    anchors.fill: parent
                }

                function open(source, x_position) {
                    if (popup_menu_loader.source == source && popup_menu.visible) {
                        popup_menu.visible = false;
                        return;
                    }
                    popup_menu_loader.source = source;
                    if (x_position != 0) {
                        popup_menu.anchor.rect.x = x_position - popup_menu_loader.implicitWidth / 2;
                    } else {
                        popup_menu.anchor.rect.x = parentWindow.width - 10;
                    }
                    popup_menu.visible = true;
                }
            }
            PopupWindow {
                anchor {
                    window: bar
                    rect.x: parentWindow.width - 10
                    rect.y: parentWindow.height + 5
                }
                implicitHeight: not_rect.implicitHeight
                implicitWidth: not_rect.implicitWidth

                visible: root.notification_visible
                color: "transparent"
                NotificationItem {
                    id: not_rect
                    image: root.notification.image
                    summary: root.notification.summary
                    body: root.notification.body
                    show: root.notification_visible
                    key: "main"
                    dismiss: function () {
                        root.notification_visible = false;
                    }
                }
                Timer {
                    id: not_timer
                    repeat: false
                    running: root.notification_visible
                    interval: root.notification.expireTimeout > 0 ? Math.round(root.notification.expireTimeout * 1000) : 5000
                    onTriggered: {
                        root.notification_visible = false;
                    }
                }
            }
        }
    }

    Niri {
        id: niri
        Component.onCompleted: connect()
        onConnected: console.log("Connected to niri")
        onErrorOccurred: function (error) {
            console.error("Connection error:", error);
        }
    }
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Singleton {
        id: audio
        readonly property PwNode sink: Pipewire.defaultAudioSink
        readonly property PwNode source: Pipewire.defaultAudioSource
        readonly property var nodes: Pipewire.nodes
        function setSink(node) {
            Pipewire.preferredDefaultAudioSink = node;
        }
        function setSource(node) {
            Pipewire.preferredDefaultAudioSource = node;
        }
        function getName(node): string {
            if (node.nickname != "")
                return node.nickname;
            else if (node.description != "")
                return node.description;
            return node.name;
        }
        PwObjectTracker {
            objects: [audio.sink, audio.source]
        }
    }

    Backlight {
        id: light
    }
    Process {
        id: pavucontrol
        running: false
        command: ["pavucontrol"]
    }
    NotificationServer {
        id: notification_server
        imageSupported: true
        onNotification: not => {
            root.notification = not;
            root.notification_visible = true;
            notification_list.append({
                "image": not.image,
                "summary": not.summary,
                "body": not.body,
                "key": UUID.generate()
            });
        }
    }

    ListModel {
        id: notification_list
    }
}
