from sensors_data.interface import AbstractReceiver
from PySide6.QtCore import Signal, Slot, QObject


# No implementation because idk interface or proto for real sensors
class RealReceiver(QObject, AbstractReceiver):

    def __init__(self, parent=None):
        super().__init__(parent)


    send_data = Signal(str, name="data")

    @Slot()
    def request_data(self):
        pass
