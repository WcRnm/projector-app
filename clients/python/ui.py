import PyQt6.QtWidgets as qt

from handler import ProjectorDataHandler


class MainWindow(qt.QMainWindow, ProjectorDataHandler):
    def __init__(self):
        super().__init__()

        self.setWindowTitle('Projector')

        self.layout = qt.QGridLayout()
        self.row = 0

        self.power_button = qt.QPushButton('ON')
        self.power_button.setCheckable(True)
        self.power_button.clicked.connect(self.power_toggled)
        self.set_color(self.power_button, 'white', 'green')

        self.lamp_progress = qt.QProgressBar()
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

    def on_idle(self):
        pass
        # QGuiApplication.processEvents()

    def set_lamp_hours(self, curr_hrs, max_hrs):
        self.lamp_progress.setMaximum(max_hrs)
        self.lamp_progress.setValue(curr_hrs)
        self.lamp_progress.update()

    def on_heartbeat(self):
        self.heartbeatCount += 1
        self.heartbeat.display(self.heartbeatCount)
        self.heartbeat.update()
