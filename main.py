import sys
from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from app_core import AppCore


def main():
    app = QApplication(sys.argv)
    core = AppCore()
    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("app_core", core)
    engine.load("QML/main.qml")
    if not engine.rootObjects():
        return -1
    exit_code = app.exec()
    core.stop_receiver()
    del core
    del engine
    return exit_code


if __name__ == "__main__":
    sys.exit(main())



