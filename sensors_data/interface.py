from abc import abstractmethod, ABCMeta
from PySide6.QtCore import QObject


class _AbstractReceiverMeta(type(QObject), ABCMeta):
    pass


class AbstractReceiver(object, metaclass=_AbstractReceiverMeta):

    # Request current sensors data
    @abstractmethod
    def request_data(self):
        pass


