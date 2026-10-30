import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    color: Colors.color3
    implicitWidth: 400
    implicitHeight: main_layout.implicitHeight + 10
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
            text: "Volume"
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Text {
                text: "Speaker:  "
            }
            MouseArea {
                implicitWidth: slider.implicitWidth
                implicitHeight: slider.implicitHeight
                onWheel: w => {
                    if (w.angleDelta.y > 0)
                        slider.increase();
                    else
                        slider.decrease();
                }

                Slider {
                    id: slider
                    from: 0
                    to: 1
                    value: audio.sink.audio.volume
                    onValueChanged: {
                        audio.sink.audio.volume = value;
                    }
                    stepSize: 0.01
                    background: Rectangle {
                        id: slider_bg
                        x: slider.leftPadding
                        y: slider.topPadding + slider.availableHeight / 2 - height / 2
                        implicitWidth: 250
                        implicitHeight: 4
                        width: slider.availableWidth
                        height: implicitHeight
                        radius: 2
                        color: "#bdbebf"

                        Rectangle {
                            width: slider.visualPosition * parent.width
                            height: parent.height
                            color: "#21be2b"
                            radius: 2
                        }
                    }
                    handle: Rectangle {
                        x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                        y: slider.topPadding + slider.availableHeight / 2 - height / 2
                        implicitWidth: 14
                        implicitHeight: 14
                        radius: 13
                        color: slider.pressed ? "#f0f0f0" : "#f6f6f6"
                        border.color: "#bdbebf"
                    }
                    HoverHandler {
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
            Button {
                id: mute_btn
                text: audio.sink.audio.muted ? "Unmute" : "Mute"
                onClicked: {
                    audio.sink.audio.muted = !audio.sink.audio.muted;
                }
                background: Rectangle {
                    implicitWidth: 40
                    implicitHeight: 20
                    radius: 10
                    color: mute_btn.down ? Colors.color2 : (mute_btn.hovered ? Colors.color0 : Colors.color1)
                }
                contentItem: Text {
                    color: Colors.foreground
                    text: mute_btn.text
                }
                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Text {
                text: "Mic:  "
            }
            MouseArea {
                implicitWidth: slider2.implicitWidth
                implicitHeight: slider2.implicitHeight
                onWheel: w => {
                    if (w.angleDelta.y > 0)
                        slider2.increase();
                    else
                        slider2.decrease();
                }

                Slider {
                    id: slider2
                    from: 0
                    to: 1
                    value: audio.source.audio.volume
                    onValueChanged: {
                        audio.source.audio.volume = value;
                    }
                    stepSize: 0.01
                    background: Rectangle {
                        id: slider2_bg
                        x: slider2.leftPadding
                        y: slider2.topPadding + slider2.availableHeight / 2 - height / 2
                        implicitWidth: 250
                        implicitHeight: 4
                        width: slider.availableWidth
                        height: implicitHeight
                        radius: 2
                        color: "#bdbebf"

                        Rectangle {
                            width: slider2.visualPosition * parent.width
                            height: parent.height
                            color: "#21be2b"
                            radius: 2
                        }
                    }
                    handle: Rectangle {
                        x: slider2.leftPadding + slider2.visualPosition * (slider2.availableWidth - width)
                        y: slider2.topPadding + slider2.availableHeight / 2 - height / 2
                        implicitWidth: 14
                        implicitHeight: 14
                        radius: 13
                        color: slider2.pressed ? "#f0f0f0" : "#f6f6f6"
                        border.color: "#bdbebf"
                    }
                    HoverHandler {
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
            Button {
                id: mute_btn_2
                text: audio.source.audio.muted ? "Unmute" : "Mute"
                onClicked: {
                    audio.source.audio.muted = !audio.source.audio.muted;
                }
                background: Rectangle {
                    implicitWidth: 40
                    implicitHeight: 20
                    radius: 10
                    color: mute_btn_2.down ? Colors.color2 : (mute_btn_2.hovered ? Colors.color0 : Colors.color1)
                }
                contentItem: Text {
                    color: Colors.foreground
                    text: mute_btn_2.text
                }
                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
        Text {
            font.pixelSize: 16
            Layout.alignment: Qt.AlignHCenter
            text: "──────────────────────────────────────"
        }
        Text {
            font.pixelSize: 16
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: 20
            text: "Output device:"
        }
        ListView {
            Layout.preferredHeight: contentItem.childrenRect.height
            Layout.preferredWidth: contentItem.childrenRect.width
            Layout.maximumHeight: 200
            Layout.fillWidth: true

            orientation: Qt.Vertical
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }

            model: audio.nodes
            delegate: Button {
                id: sink_btn
                height: sink_btn.visible ? 45 : 0
                width: sink_btn.visible ? 380 : 0
                visible: modelData.isSink && !modelData.isStream
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    audio.setSink(modelData);
                }
                background: Rectangle {
                    height: sink_btn.visible ? 40 : 0
                    width: sink_btn.visible ? 380 : 0
                    visible: sink_btn.visible
                    color: sink_btn.down ? Colors.color2 : (sink_btn.hovered ? Colors.color1 : Colors.background)
                    border {
                        color: audio.sink.id == modelData.id ? Colors.color2 : Colors.color1
                        width: 4
                    }
                    Text {
                        text: audio.getName(modelData)
                        color: Colors.foreground
                        anchors.centerIn: parent
                        elide: Text.ElideRight
                        width: Math.min(implicitWidth, parent.width - 10)
                    }
                }
                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
        Text {
            font.pixelSize: 16
            Layout.alignment: Qt.AlignHCenter
            text: "──────────────────────────────────────"
        }
        Text {
            font.pixelSize: 16
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: 20
            text: "Input device:"
        }
        ListView {
            Layout.preferredHeight: contentItem.childrenRect.height
            Layout.preferredWidth: contentItem.childrenRect.width
            Layout.maximumHeight: 200
            Layout.fillWidth: true

            orientation: Qt.Vertical
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }

            model: audio.nodes
            delegate: Button {
                id: source_btn
                height: source_btn.visible ? 45 : 0
                width: source_btn.visible ? 380 : 0
                visible: !modelData.isSink && !modelData.isStream
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    audio.setSource(modelData);
                }
                background: Rectangle {
                    height: source_btn.visible ? 40 : 0
                    width: source_btn.visible ? 380 : 0
                    visible: source_btn.visible
                    color: source_btn.down ? Colors.color2 : (source_btn.hovered ? Colors.color1 : Colors.background)
                    border {
                        color: audio.source.id == modelData.id ? Colors.color2 : Colors.color1
                        width: 4
                    }
                    Text {
                        text: audio.getName(modelData)
                        color: Colors.foreground
                        anchors.centerIn: parent
                        elide: Text.ElideRight
                        width: Math.min(implicitWidth, parent.width - 10)
                    }
                }
                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }
}
