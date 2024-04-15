import sys
import time
from dataclasses import dataclass
from enum import IntEnum

from PyQt6.QtWidgets import QApplication
from PyQt6.QtCore import QThread

from connection import ProjectorConnection
from crestron import Projector
from data_names import DataId
from ui import MainWindow

VERSION = 0.1
MAX_LAMP_HOURS = 400  # hrs


class TaskType(IntEnum):
    Heartbeat = 0
    Value = 1


@dataclass
class UiTask:
    type: TaskType
    id: int
    nam: str
    value: any


class Worker(QThread):
    def __init__(self, handler):
        QThread.__init__(self)
        self.handler = handler
        self.running = False
        self.tasks = []

    def __del__(self):
        self.stop()

    def stop(self):
        if self.running:
            self.running = False
            self.wait()

    def run(self):
        self.running = True
        print('Worker: Run')

        while self.running:
            time.sleep(0.25)

            while len(self.tasks) > 0:
                task = self.tasks.pop()

                if TaskType.Heartbeat == task.type:
                    self.handler.on_heartbeat()
                elif DataId.STATE_LAMP_HOURS == task.id:
                    self.handler.set_lamp_hours(int(task.value), MAX_LAMP_HOURS)

        print('Worker: Done')

    def on_idle(self):
        pass

    def on_value_change(self, data_id, data_name, data_value):
        task = UiTask(
            TaskType.Value, data_id, data_name, data_value
        )
        self.tasks.append(task)

    def on_heartbeat(self):
        task = UiTask(
            TaskType.Heartbeat, 0, 'Heartbeat', 0
        )
        self.tasks.append(task)


class MainApp:
    def __init__(self):
        self.app = QApplication(sys.argv)
        self.window = MainWindow()
        self.worker = Worker(self.window)
        self.projector = Projector(self.worker)
        self.connection = ProjectorConnection(self.projector)

    def start(self):
        self.window.show()
        self.worker.start()
        self.connection.start()

    def stop(self):
        self.connection.stop()
        self.worker.stop()

    def exec(self):
        self.app.exec()


if __name__ == '__main__':
    main = MainApp()

    main.start()
    main.exec()
    main.stop()
