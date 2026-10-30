// Time.qml
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: back_root
    property bool enabled
    property int max_val
    property int val
    property int percent
    property string text

    function setValue(per) {
        set.new_val = Math.round(per / 100 * max_val);
        set.running = true;
    }

    Process {
        id: set
        property int new_val
        command: ["sh", "-c", "echo " + new_val + " > /sys/class/backlight/intel_backlight/brightness"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                device.running = true;
            }
        }
    }

    Process {
        id: device
        command: ["cat", "/sys/class/backlight/intel_backlight/device/enabled"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                back_root.enabled = this.text.trim() == "enabled";
                max.running = true;
            }
        }
    }

    Process {
        id: max
        command: ["cat", "/sys/class/backlight/intel_backlight/max_brightness"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                back_root.max_val = this.text;
                actual.running = true;
            }
        }
    }
    Process {
        id: actual
        command: ["cat", "/sys/class/backlight/intel_backlight/actual_brightness"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                back_root.val = this.text;
                let per = back_root.val / back_root.max_val;
                back_root.percent = Math.round(per * 100);
                if (per < 0.5) {
                    back_root.text = back_root.percent + " 󱩎 ";
                } else {
                    back_root.text = back_root.percent + " 󰛨 ";
                }
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            device.running = true;
        }
    }
}
