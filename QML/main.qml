import QtQuick
import QtQuick.Controls
import QtCharts
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Controls.Universal
import "custom_components"


ApplicationWindow {
    id: mainWindow
    width: 1270
    height: 720
    minimumWidth: 1024
    minimumHeight: 768
    visible: true
    title: qsTr("Canyon task app")

    Universal.theme: Universal.System
    Universal.accent: Universal.Crimson

    Connections {
        target: app_core

        function onSend_sensors_data(data) {
            chartsViewer.updateCharts(data)
        }

        function onSend_sensors_data_from_CSV(data) {
            csvChartsViewer.clearCharts()
            csvDataViewPopup.open()
            csvChartsViewer.updateCharts(data)
        }

        function onSend_error_message(message) {
            errorMessageText.text = message
            errorPopup.open()
        }
    }

    Connections {
        target: csvChartsViewer

        function onErrorOccurred(message) {
            errorMessageText.text = message
            csvDataViewPopup.close()
            errorPopup.open()
        }
    }

    Connections {
        target: sensorOneEmuControl

        function onChartParamsChanged() {
            updateChartParams()
        }
    }

    Connections {
        target: sensorTwoEmuControl

        function onChartParamsChanged() {
            updateChartParams()
        }
    }

    Connections {
        target: sensorThreeEmuControl

        function onChartParamsChanged() {
            updateChartParams()
        }
    }

    Timer {
        id: timer
        interval: 100 // 10 times per sec
        repeat: true
        running: false

        onTriggered: app_core.request_sensors_data()
    }

    Popup {
        id: errorPopup
        anchors.centerIn: parent
        height: 240
        width: 420
        closePolicy: Popup.NoAutoClose
        modal: true
        focus: true

        ColumnLayout {
            spacing: 10
            anchors.fill: parent

            Text {
                id: errorPopupTitle
                text: qsTr("Error ocured")
                font.bold: true
                Layout.fillWidth: true
            }

            Text {
                id: errorMessageText
                Layout.fillWidth: true
                Layout.fillHeight: true
                wrapMode: TextEdit.Wrap
            }

            Button {
                id: errorPopupOkButton
                text: qsTr("OK")
                Layout.alignment: Qt.AlignRight

                onClicked: errorPopup.close()
            }
        }
    }

    Popup {
        id: csvDataViewPopup
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        closePolicy: Popup.NoAutoClose
        modal: true
        focus: true

        ColumnLayout {
            spacing: 10
            anchors.fill: parent

            ChartsViewer {
                id: csvChartsViewer
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            Button {
                id: closeCsvDataViewPopup
                Layout.fillWidth: true
                text: qsTr("Close")
                Layout.alignment: Qt.AlignBottom

                onClicked: csvDataViewPopup.close()
            }
        }
    }

    FileDialog {
        id: fileDialog

        onAccepted: {
            if(fileMode === FileDialog.SaveFile) {
                chartsViewer.grabToImage(function(result) {
                    result.saveToFile(fileDialog.selectedFile);
                }, Qt.size(chartsViewer.width * 2, chartsViewer.height * 2))
            }
            else {
                csvChartsViewer.clearCharts()
                app_core.receive_CVS_filename(fileDialog.selectedFile.toString())
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ChartsViewer {
                id: chartsViewer
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: 150

                ColumnLayout {
                    anchors.fill: parent
                    uniformCellSizes: true

                    EmulationControl {
                        id: sensorOneEmuControl
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    EmulationControl {
                        id: sensorTwoEmuControl
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    EmulationControl {
                        id: sensorThreeEmuControl
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }
            }
        }



        RowLayout {
            spacing: 10
            uniformCellSizes: true
            Layout.fillWidth: true

            Button {
                id: startStopButton
                text: qsTr("Start")
                Layout.alignment: Qt.AlignLeft
                Layout.fillWidth: true

                onClicked: {
                    chartsViewer.clearCharts()
                    text = text === "Start" ? "Stop" : "Start"
                    timer.running = timer.running ? false : true
                }
            }

            Button  {
                id: readDataFromCSVFileButton
                text: qsTr("Read data from CSV file")
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true

                onClicked: {
                    fileDialog.fileMode = FileDialog.OpenFile
                    fileDialog.nameFilters = ["CSV file (*.csv)"]
                    fileDialog.title = "Open CSV file"
                    fileDialog.open()
                }
            }

            Button {
                id: savePlotToImageButton
                text: qsTr("Save plots as png")
                Layout.alignment: Qt.AlignRight
                Layout.fillWidth: true

                onClicked: {
                    fileDialog.fileMode = FileDialog.SaveFile
                    fileDialog.nameFilters = ["Image file (*.png)"]
                    fileDialog.title = "Save plot as image"
                    fileDialog.open()
                }
            }
        }
    }

    function updateChartParams() {
        const AMP = 0
        const FREQ = 1
        var sensorOneParams = sensorOneEmuControl.getChartParams()
        var sensorTwoParams = sensorTwoEmuControl.getChartParams()
        var sensorThreeParams = sensorThreeEmuControl.getChartParams()

        chartsViewer.updateYAxis(parseInt(sensorOneParams), parseInt(sensorTwoParams), parseInt(sensorThreeParams))

        var newChartParamsString = "[{\"amp\": " + sensorOneParams[AMP] + ", \"freq\":  " + sensorOneParams[FREQ] + "},
                                     {\"amp\": " + sensorTwoParams[AMP] + ", \"freq\":  " + sensorTwoParams[FREQ] + "},
                                     {\"amp\": " + sensorThreeParams[AMP] + ", \"freq\":  " + sensorThreeParams[FREQ] + "}
                                    ]"

        app_core.receive_new_charts_param(newChartParamsString)
    }
}
