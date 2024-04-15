from dataclasses import dataclass
import PyQt6.QtWidgets as qt
from PyQt6.QtGui import QGuiApplication
from PyQt6.QtCore import QThread

from enum import IntEnum
import sys
import time

from connection import ProjectorConnection
from crestron import Projector
from data_names import DataId

VERSION = 0.1
MAX_LAMP_LIFE = 400  # hrs


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
    def __init__(self, main):
        QThread.__init__(self)
        self.main = main
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
                    self.main.on_heartbeat()
                elif DataId.STATE_LAMP_HOURS == task.id:
                    self.main.set_lamp_hours(int(task.value))

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


class MainWindow(qt.QMainWindow):
    def __init__(self):
        super().__init__()

        self.setWindowTitle('Projector')

        self.worker = Worker(self)

        self.projector = Projector(self.worker)
        self.connection = ProjectorConnection(self.projector)

        self.layout = qt.QGridLayout()
        self.row = 0

        self.power_button = qt.QPushButton('ON')
        self.power_button.setCheckable(True)
        self.power_button.clicked.connect(self.power_toggled)
        self.set_color(self.power_button, 'white', 'green')

        self.lamp_progress = qt.QProgressBar()
        self.lamp_progress.setMinimum(0)
        self.lamp_progress.setMaximum(MAX_LAMP_LIFE)
        self.lamp_progress.setValue(0)
        self.lamp_progress.setFormat('%v/%m hrs')

        self.heartbeatCount = 0
        self.heartbeat = qt.QLCDNumber()

        self.add_row('Power', self.power_button)
        self.add_row('Lamp', self.lamp_progress)
        self.add_row('Heartbeat', self.heartbeat)

        widget = qt.QWidget()
        widget.setLayout(self.layout)
        self.setCentralWidget(widget)

    def add_row(self, label, widget):
        self.layout.addWidget(qt.QLabel(label), self.row, 0)
        self.layout.addWidget(widget, self.row, 1)
        self.row += 1

    def power_toggled(self, checked):
        print("Checked?", checked)
        self.power_button.setText('OFF' if checked else 'ON')
        self.set_color(self.power_button,
                       'black' if checked else 'white',
                       'red' if checked else 'green')

    def set_color(self, widget, fg, bg):
        widget.setStyleSheet(f"color: {fg}; background-color : {bg};")

    def connect(self):
        self.worker.start()
        self.connection.start()

    def disconnect(self):
        self.connection.stop()
        self.worker.stop()

    def on_idle(self):
        pass
        # QGuiApplication.processEvents()

    def set_lamp_hours(self, hrs):
        self.lamp_progress.setValue(hrs)
        self.lamp_progress.update()

    def on_heartbeat(self):
        self.heartbeatCount += 1
        self.heartbeat.display(self.heartbeatCount)
        self.heartbeat.update()


if __name__ == '__main__':
    app = qt.QApplication(sys.argv)

    window = MainWindow()
    window.connect()
    window.show()

    app.exec()

    window.disconnect()
