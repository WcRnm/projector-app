import sys
import time
from dataclasses import dataclass
from enum import Enum

from PyQt6.QtCore import QThread
from PyQt6.QtWidgets import QApplication

from connection import ProjectorConnection
from crestron import Projector
from data_names import *
from ui import MainWindow

VERSION = 0.1
MAX_LAMP_HOURS = 400  # hrs


class TaskType(Enum):
    Heartbeat = 'Heartbeat'
    Value = 'Value'
    ConnectionState = 'ConnectionState'


@dataclass
class UiTask:
    type: TaskType
    name: str
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
            if len(self.tasks) > 0:
                task = self.tasks.pop(0)

                if TaskType.Heartbeat == task.type:
                    self.handler.on_heartbeat()
                elif TaskType.ConnectionState == task.type:
                    self.handler.on_connect_change(task.value)
                elif TaskType.Value == task.type:
                    if STATE_LAMP_HOURS == task.name:
                        self.handler.set_lamp_hours(int(task.value))
                    elif NETWORK_IPADDR == task.name:
                        self.handler.set_network_address(task.value, None)
                    elif NETWORK_PORT == task.name:
                        self.handler.set_network_address(None, int(task.value))
                    elif NETWORK_MAC == task.name:
                        self.handler.set_mac_address(task.value)
                    elif CONFIG_LOCATION == task.name:
                        self.handler.set_location(task.value)
                    elif STATE_ERROR == task.name:
                        self.handler.set_error(task.value)
                    elif INFO_RESOLUTION == task.name:
                        self.handler.set_resolution(task.value)
                    elif INFO_FIRMWARE == task.name:
                        self.handler.set_firmware(task.value)
                    else:
                        print(f'UNHANDLED: {task}')
                else:
                    print(f'UNHANDLED: {task}')
            else:
                time.sleep(0.25)
                QApplication.processEvents()

        print('Worker: Done')

    def on_idle(self):
        pass

    def on_value_change(self, data_name, data_value):
        task = UiTask(
            TaskType.Value, data_name, data_value
        )
        self.tasks.append(task)

    def on_heartbeat(self):
        task = UiTask(
            TaskType.Heartbeat, '', 0
        )
        self.tasks.append(task)

    def on_connect_change(self, state):
        # print(f'w:on_connect_change({state.value})')
        task = UiTask(
            TaskType.ConnectionState, '', state
        )
        self.tasks.append(task)


class MainApp:
    def __init__(self):
        self.app = QApplication(sys.argv)
        self.window = MainWindow(MAX_LAMP_HOURS)
        self.worker = Worker(self.window)
        self.projector = Projector(self.worker)
        self.connection = ProjectorConnection(self.projector, self.worker)

    def start(self):
        print('mainapp:start')
        self.window.show()
        self.worker.start()
        self.connection.start()

    def stop(self):
        print('mainapp:stop')
        self.connection.stop()
        self.worker.stop()

    def exec(self):
        print('mainapp:exec')
        self.app.exec()


if __name__ == '__main__':
    main = MainApp()

    main.start()
    main.exec()
    main.stop()
