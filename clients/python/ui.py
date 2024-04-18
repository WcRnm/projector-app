import PyQt6.QtWidgets as qt

from handler import *

TURN_ON = 'Turn ON'
TURN_OFF = 'Turn OFF'


class MainWindow(qt.QMainWindow, ProjectorDataHandler):
    def __init__(self, max_lamp_hrs):
        super().__init__()

        self.setWindowTitle('Projector')

        self.layout = qt.QGridLayout()
        self.row = 0

        self.connection = qt.QLabel(ConnectState.Disconnected.value)

        self.power_button = qt.QPushButton(TURN_ON, self)
        self.power_button.setCheckable(True)
        self.power_button.clicked.connect(self.power_toggled)

        self.lamp_progress = qt.QProgressBar()
        self.lamp_progress.setFormat('%v/%m')
        self.lamp_progress.setMinimum(0)
        self.lamp_progress.setMaximum(max_lamp_hrs)

        self.heartbeatCount = 0
        self.heartbeat = qt.QLabel(str(self.heartbeatCount))

        self.addr = None
        self.port = None
        self.net_addr = qt.QLabel()
        self.mac_addr = qt.QLabel()
        self.location = qt.QLabel()
        self.resolution = qt.QLabel()
        self.error = qt.QLabel()
        self.firmware = qt.QLabel()

        self.add_row('Location', self.location)
        self.add_row('Connection', self.connection)
        self.add_row('Power', self.power_button)
        self.add_row('Lamp Hours', self.lamp_progress)
        self.add_row('Heartbeat', self.heartbeat)
        self.add_row('Error', self.error)

        self.add_row('Resolution', self.resolution)
        self.add_row('Network Address', self.net_addr)
        self.add_row('MAC Address', self.mac_addr)
        self.add_row('Firmware', self.firmware)

        widget = qt.QWidget()
        widget.setLayout(self.layout)
        self.setCentralWidget(widget)

    def add_row(self, label, widget):
        self.layout.addWidget(qt.QLabel(label), self.row, 0)
        self.layout.addWidget(widget, self.row, 1)
        self.row += 1

    def power_toggled(self, checked):
        print("Checked?", checked)
        self.power_button.setText(TURN_OFF if checked else TURN_ON)

    def set_color(self, widget, fg, bg):
        widget.setStyleSheet(f"color: {fg}; background-color : {bg};")

    def on_connect_change(self, state):
        print(f'ui:on_connect_change({state.value})')
        self.connection.setText(state.value)

    def on_idle(self):
        pass
        # QGuiApplication.processEvents()

    def set_lamp_hours(self, curr_hrs):
        print(f'ui:set_lamp_hours({curr_hrs})')
        self.lamp_progress.setValue(curr_hrs)
        # self.lamp_progress.update()

    def on_heartbeat(self):
        self.heartbeatCount += 1
        print(f'ui:on_heartbeat({self.heartbeatCount})')
        self.heartbeat.setText(str(self.heartbeatCount))

    def set_network_address(self, addr, port):
        if addr is not None:
            self.addr = addr
        if port is not None:
            self.port = port

        self.net_addr.setText('{}:{}'.format(
            self.addr if self.addr is not None else '',
            self.port if self.port is not None else ''
        ))

    def set_mac_address(self, addr):
        self.mac_addr.setText(addr)

    def set_location(self, location):
        self.location.setText(location)

    def set_resolution(self, res):
        self.resolution.setText(res)

    def set_error(self, error):
        self.error.setText(error)

    def set_firmware(self, firmware):
        self.firmware.setText(firmware)
