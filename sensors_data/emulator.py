from sensors_data.interface import AbstractReceiver
import pandas
import numpy
from scipy import signal
from datetime import datetime, timedelta
from PySide6.QtCore import Signal, Slot, QObject


class Emulator(QObject, AbstractReceiver):
    _sensors_params = [
        {"amp": 1, "freq": 1},
        {"amp": 1, "freq": 1},
        {"amp": 1, "freq": 1}
    ]


    def __init__(self, parent=None):
        super().__init__(parent)



    send_data = Signal(str, name="data")

    # Generating sensors data
    @Slot()
    def request_data(self):
        now = datetime.now()
        hundred_msec_ago = now - timedelta(milliseconds=100)

        start = pandas.Timestamp(hundred_msec_ago)
        end = pandas.Timestamp(now)

        timeAxisValues = pandas.date_range(hundred_msec_ago, now, periods = 100)

        timeValues = numpy.linspace(start.value, end.value, 100)

        # Sine waveform
        signal1 = self._sensors_params[0]["amp"] * numpy.sin(2 * numpy.pi * self._sensors_params[0]["freq"] * timeValues)

        # Square waveform
        signal2 = self._sensors_params[1]["amp"] * signal.square(2 * numpy.pi * self._sensors_params[1]["freq"] * timeValues, duty=0.3)

        # Triangle waveform
        signal3 = self._sensors_params[2]["amp"] * signal.sawtooth(2 * numpy.pi * self._sensors_params[2]["freq"] * timeValues, width=1)

        sensorsDataCSVString = ""

        for i in range(0, 10):
            sensorsDataCSVString += "{0};{1};{2};{3}".format(timeAxisValues.values[i], signal1[i], signal2[i], signal3[i])
            if i != 9:
                sensorsDataCSVString += "\n"

        self.send_data.emit(sensorsDataCSVString)


    @Slot(list)
    def set_new_chart_params(self, new_sensors_params):
        self._sensors_params = new_sensors_params

