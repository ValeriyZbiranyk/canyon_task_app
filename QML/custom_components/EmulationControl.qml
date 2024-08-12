import QtQuick
import QtQuick.Layouts
import QtQuick.Controls


Item {
    id: root

    signal chartParamsChanged()

    GridLayout {
        anchors.centerIn: parent
        columns: 2
        rows: 2

        Text {
            text: qsTr("Amlpitude: ")
        }

        SpinBox {
            id: sensorAmpSpinbox
            value: 1
            stepSize: 1

            onValueChanged: chartParamsChanged();
        }

        Text {
            text: qsTr("Frequency: ")
        }

        SpinBox {
            id: sensorFreqSpinbox
            value: 1
            stepSize: 1

            onValueChanged: chartParamsChanged();
        }
    }

    function getChartParams() {
        return [Number(sensorAmpSpinbox.value).toString(),
                Number(sensorFreqSpinbox.value).toString()]
    }
}
