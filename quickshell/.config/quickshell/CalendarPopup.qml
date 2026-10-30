import QtQuick

Rectangle {
    id: calendar
    color: Colors.color5
    implicitWidth: 400
    implicitHeight: calendar_widget.height + 60
    radius: 10

    property string selectedDateStr: ""

    property var monthDays: []
    property string currentMonthStr: ""
    property string authError: ""

    property int currentViewYear: new Date().getFullYear()
    property int currentViewMonth: new Date().getMonth()

    function updateMonthGrid() {
        let year = currentViewYear;
        let month = currentViewMonth;

        let d = new Date(year, month, 1);
        currentMonthStr = d.toLocaleDateString(Qt.locale("en_US"), "MMMM yyyy");

        let lastDay = new Date(year, month + 1, 0);
        let startOffset = d.getDay();

        let daysArray = [];
        for (let i = startOffset - 1; i >= 0; i--) {
            let pd = new Date(year, month, -i);
            daysArray.push({
                dayNum: pd.getDate(),
                isCurrentMonth: false,
                dateStr: pd.toDateString()
            });
        }
        for (let i = 1; i <= lastDay.getDate(); i++) {
            let cd = new Date(year, month, i);
            daysArray.push({
                dayNum: i,
                isCurrentMonth: true,
                dateStr: cd.toDateString()
            });
        }
        let remaining = 42 - daysArray.length;
        for (let i = 1; i <= remaining; i++) {
            let nd = new Date(year, month + 1, i);
            daysArray.push({
                dayNum: i,
                isCurrentMonth: false,
                dateStr: nd.toDateString()
            });
        }
        monthDays = daysArray;

        selectedDateStr = "";
        authError = "";
    }

    Component.onCompleted: updateMonthGrid()
    onCurrentViewMonthChanged: updateMonthGrid()
    onCurrentViewYearChanged: updateMonthGrid()

    CalendarWidget {
        id: calendar_widget
        width: 200
        height: 400
        anchors.left: parent.left
        anchors.right: parent.right

        currentViewMonth: calendar.currentViewMonth
        currentViewYear: calendar.currentViewYear
        currentMonthStr: calendar.currentMonthStr
        monthDays: calendar.monthDays
        selectedDateStr: calendar.selectedDateStr

        onChangeMonth: function (offset) {
            calendar.currentViewMonth += offset;
            if (calendar.currentViewMonth < 0) {
                calendar.currentViewMonth = 11;
                calendar.currentViewYear--;
            } else if (calendar.currentViewMonth > 11) {
                calendar.currentViewMonth = 0;
                calendar.currentViewYear++;
            }
        }

        onDateSelected: function (dateStr) {
            calendar.selectedDateStr = dateStr;
        }
    }

    Text {
        id: separator
        font.pixelSize: 16
        anchors.top: calendar_widget.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        text: "──────────────────────────────────────"
    }
    Text {
        id: calendar_title
        anchors.top: separator.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 16
        text: Qt.formatDateTime(clock.date, "dd/MM/yyyy hh:mm:ss")
    }
}
