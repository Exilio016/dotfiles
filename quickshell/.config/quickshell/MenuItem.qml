import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

Rectangle {
    required property color itemColor
    required default property Item child
    property int padding: 24
    id: menu_item_root

    implicitWidth: layout.implicitWidth

    RowLayout {
        id: layout
        spacing: -1
        Shape {
            width: 10
            height: parent.implicitHeight

            layer.enabled: true
            layer.samples: 4
        
            ShapePath {
                fillColor: menu_item_root.itemColor
                strokeColor: menu_item_root.itemColor
                strokeWidth: 2
        
                startX: 0; startY: 20          // Left tip (center-left)
                PathLine { x: 20; y: 0 }     // Top-right
                PathLine { x: 20; y: 40 }    // Bottom-right
                PathLine { x: 0; y: 20 }       // Back to tip
            }
        }
        Rectangle {
            color: menu_item_root.itemColor
            implicitWidth: menu_item_root.child.implicitWidth + menu_item_root.padding
            implicitHeight: parent.implicitHeight
            children: [menu_item_root.child]
        }
    }
}
