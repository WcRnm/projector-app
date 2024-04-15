import socket
import time

from PyQt6.QtCore import QThread

from crestron import ProjectorDisconnectError

DEFAULT_PROJECTOR_ADDR = '127.0.0.1'
DEFAULT_PROJECTOR_PORT = 41794


class ProjectorConnection(QThread):
    def __init__(self, projector):
        QThread.__init__(self)
        self.projector = projector
        self.running = False
        self.status = [self.projector.status]
        self.sock = None

    def stop(self):
        self.running = False
        self.sock.close()
        self.wait()

    def connect(self):
        try:
            print("connect {}:{}".format(DEFAULT_PROJECTOR_ADDR, DEFAULT_PROJECTOR_PORT))
            self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.sock.settimeout(1000)
            self.sock.connect((DEFAULT_PROJECTOR_ADDR, DEFAULT_PROJECTOR_PORT))
        except IOError as e:
            self.disconnect()

    def disconnect(self):
        if self.sock is not None:
            try:
                self.sock.close()
            finally:
                self.sock = None
                self.projector.reset()

    def run(self):
        self.running = True

        while self.running:
            if self.sock is None:
                self.connect()

            if self.sock is not None:
                try:
                    data = self.sock.recv(1024)
                    self.projector.handle_data(data)

                except IOError:
                    self.disconnect()
                except ProjectorDisconnectError:
                    self.disconnect()

            self.projector.idle_tasks(self.sock)
            time.sleep(0.2)

        self.running = False
