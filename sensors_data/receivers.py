from sensors_data.real import RealReceiver
from sensors_data.emulator import Emulator
from enum import Enum
from PySide6.QtCore import QObject


class Type(Enum):
    REAL = RealReceiver
    EMULATOR = Emulator


class Factory:

    @staticmethod
    def create(receiver_type: Type, parent: QObject = None):
        return receiver_type.value(parent)
