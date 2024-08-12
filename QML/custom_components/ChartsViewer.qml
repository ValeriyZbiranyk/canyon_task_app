import QtQuick
import QtQuick.Controls
import QtCharts
import QtQuick.Layouts


Rectangle {
    id: root

    signal errorOccurred(message: string)

    ColumnLayout {
        anchors.fill: parent
        uniformCellSizes: true

        ChartView {
            id: sensorOneChartView
            title: qsTr("Sensor 1 Data")
            antialiasing: true
            Layout.fillWidth: true
            Layout.fillHeight: true
            legend.alignment: Qt.AlignLeft

            DateTimeAxis {
                id: sensorOneDateTimeAxis
                min: new Date()
                max: new Date()
            }

            ValuesAxis {
                id: sensorOneValueAxis
                min: max * (-1)
                max: 1
            }

            LineSeries {
                id: sensorOneLineSeries
                color: "red"
                name: qsTr("Sine")
                axisX: sensorOneDateTimeAxis
                axisY: sensorOneValueAxis
            }
        }

        ChartView {
            id: sensorTwoChartView
            title: qsTr("Sensor 2 Data")
            Layout.fillWidth: true
            Layout.fillHeight: true
            antialiasing: true
            legend.alignment: Qt.AlignLeft

            DateTimeAxis {
                id: sensorTwoDateTimeAxis
                min: new Date()
                max: new Date()
            }

            ValuesAxis {
                id: sensorTwoValueAxis
                min: max * (-1)
                max: 1
            }

            LineSeries {
                id: sensorTwoLineSeries
                color: "green"
                name: qsTr("Square")
                axisX: sensorTwoDateTimeAxis
                axisY: sensorTwoValueAxis
            }
        }

        ChartView {
            id: sensorThreeChartView
            title: qsTr("Sensor 3 Data")
            Layout.fillWidth: true
            Layout.fillHeight: true
            antialiasing: true
            legend.alignment: Qt.AlignLeft

            DateTimeAxis {
                id: sensorThreeDateTimeAxis
                min: new Date()
                max: new Date()
            }

            ValuesAxis {
                id: sensorThreeValueAxis
                min: max * (-1)
                max: 1
            }

            LineSeries {
                id: sensorThreeLineSeries
                color: "blue"
                name: qsTr("Triangle")
                axisX: sensorThreeDateTimeAxis
                axisY: sensorThreeValueAxis
            }
        }
    }

    function updateCharts(data) {
        var allSensorsDataStringList = data.split('\n')

        if(allSensorsDataStringList.length === 0) {
            root.errorOccurred("Bad CVS file!")
            return
        }

        for(var i = 0; i < allSensorsDataStringList.length; i++) {
            var sensorsDataStringList = allSensorsDataStringList[i].split(';')
            if(sensorsDataStringList.length === 4)
            {
                var datetimeValue = new Date(sensorsDataStringList[0])
                var sensorOneValue = parseFloat(sensorsDataStringList[1])
                var sensorTwoValue = parseFloat(sensorsDataStringList[2])
                var sensorThreeValue = parseFloat(sensorsDataStringList[3])

                if((datetimeValue === NaN) &&
                        (sensorOneValue === NaN) &&
                        (sensorTwoValue === NaN) &&
                        (sensorThreeValue === NaN))
                {
                    root.errorOccurred("Bad CVS file!")
                    return
                }

                if(i === 0) {
                    sensorOneDateTimeAxis.min = datetimeValue
                    sensorTwoDateTimeAxis.min = datetimeValue
                    sensorThreeDateTimeAxis.min = datetimeValue
                }
                else if(i === allSensorsDataStringList.length - 1) {
                    sensorOneDateTimeAxis.max = datetimeValue
                    sensorTwoDateTimeAxis.max = datetimeValue
                    sensorThreeDateTimeAxis.max = datetimeValue
                }

                sensorOneLineSeries.append(datetimeValue, sensorOneValue)
                sensorTwoLineSeries.append(datetimeValue, sensorTwoValue)
                sensorThreeLineSeries.append(datetimeValue, sensorThreeValue)
            }
            else {
                root.errorOccurred("Bad CVS file!")
                return
            }
        }
    }

    function clearCharts() {
        sensorOneLineSeries.clear()
        sensorTwoLineSeries.clear()
        sensorThreeLineSeries.clear()
    }

    function updateYAxis(maxOne, maxTwo, maxThree) {
        sensorOneValueAxis.max = maxOne
        sensorTwoValueAxis.max = maxTwo
        sensorThreeValueAxis.max = maxThree
        sensorOneValueAxis.min = maxOne * (-1)
        sensorTwoValueAxis.min = maxTwo * (-1)
        sensorThreeValueAxis.min = maxThree * (-1)
    }
}
