from sensors_data import receivers
from PySide6.QtCore import QObject, Signal, Slot, QThread, QUrl, QFile
import ast


class AppCore(QObject):

    # Private
    __receiver: QObject
    __thread: QThread

    def __init__(self, parent=None):
        super().__init__(parent)

        self.__receiver = receivers.Factory.create(receivers.Type.EMULATOR)
        self.request_data.connect(self.__receiver.request_data)
        self.__receiver.send_data.connect(self.receive_sensors_data)
        self.set_new_chart_params.connect(self.__receiver.set_new_chart_params)

        self.__thread = QThread(self)
        self.__receiver.moveToThread(self.__thread)
        self.__thread.start()

    # Public
    # Stop receiver thread
    def stop_receiver(self):
        self.__thread.quit()

    # Signals
    send_sensors_data = Signal(str)
    send_sensors_data_from_CSV = Signal(str)
    send_error_message = Signal(str)
    set_new_chart_params = Signal(list)
    request_data = Signal()

    # Slots
    @Slot()
    def request_sensors_data(self):
        self.request_data.emit()

    @Slot(str)
    def receive_sensors_data(self, data: str):
        self.send_sensors_data.emit(data)

    @Slot(str)
    def receive_CVS_filename(self, filename_url: str):
        filename = QUrl(filename_url).toLocalFile();
        if not QFile(filename).exists():
            self.send_error_message.emit("Cannot open " + filename)
            return

        data = open(filename, "rt").read()
        print(data)
        self.send_sensors_data_from_CSV.emit(data)


    @Slot(str)
    def receive_new_charts_param(self, new_params_str: str):
        self.set_new_chart_params.emit(ast.literal_eval(new_params_str))

    @Slot(str)
    def receive_message(self, data: str):
        print(data)

