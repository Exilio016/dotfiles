import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick.Layouts
import QtQuick

RowLayout {
    spacing: 10
    anchors.verticalCenter: parent.verticalCenter

    QsMenuAnchor {
        id: menu_anchor
        anchor {
            window: bar
        }
    }
    Repeater {
        model: SystemTray.items
        delegate: MouseArea {
            required property SystemTrayItem modelData
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            width: 20
            height: 20
            onClicked: event => {
                menu_anchor.close();
                var windowCoords = mapToItem(bar.contentItem, event.x, event.y);
                if (event.button == Qt.LeftButton) {
                    modelData.activate();
                } else {
                    menu_anchor.anchor.rect.x = windowCoords.x;
                    menu_anchor.anchor.rect.y = windowCoords.y;
                    menu_anchor.menu = modelData.menu;
                    menu_anchor.open();
                }
            }

            IconImage {
                function getTrayIcon(icon): string {
                    if (icon.includes("?path=")) {
                        const [name, path] = icon.split("?path=");
                        const file = name.slice(name.lastIndexOf("/") + 1);
                        const themed = Quickshell.iconPath(file, true);
                        icon = themed ? themed : Qt.resolvedUrl(`${path}/${file}`);
                    }
                    return icon;
                }
                source: getTrayIcon(modelData.icon)
                anchors.fill: parent
                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }
}
