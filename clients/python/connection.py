import socket
import threading
import time

from crestron import Projector, ProjectorDisconnectError

debug = True

connection = None

DEFAULT_PROJECTOR_ADDR = '127.0.0.1'
DEFAULT_PROJECTOR_PORT = 41794


# class ProjectorConnection(plugins.SimplePlugin):
class ProjectorConnection:
    def __init__(self, projector):
        global connection
        connection = self

        self.projector = projector
        self.t = None
        self.running = False
        self.status = [self.projector.status]
        self.sock = None

    def start(self):
        self.running = True
        self.t = threading.Thread(target=ProjectorConnection.worker)
        self.t.daemon = True
        self.t.start()

    def stop(self):
        self.running = False

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

    def process(self):
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

    @staticmethod
    def worker():
        while connection.running:
            time.sleep(1)
            connection.process()

        connection.disconect()
