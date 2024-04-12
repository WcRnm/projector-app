import PyQt6.QtWidgets as qt
import sys

from connection import ProjectorConnection
from crestron import Projector

VERSION = 0.1
MAX_LAMP_LIFE = 400  # hrs


class MainWindow(qt.QMainWindow):
    def __init__(self):
        super().__init__()

        self.setWindowTitle('Projector')

        self.projector = Projector()
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
        self.lamp_progress.setFormat('%v/%m hrs')
        self.set_lamp_life(40)

        self.add_row('Power', self.power_button)
        self.add_row('Lamp', self.lamp_progress)

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

    def set_lamp_life(self, curr):
        self.lamp_progress.setValue(curr)
        pass

    def connect(self):
        self.connection.start()

    def disconnect(self):
        self.connection.stop()


if __name__ == '__main__':
    app = qt.QApplication(sys.argv)

    window = MainWindow()
    window.connect()
    window.show()

    app.exec()

    window.disconnect()
