import cherrypy
from cherrypy.process import plugins

import os
import socket
import threading
import time

from projector import ProjectorInfo

debug = True

projector = None

PROJECTOR_ADDR = '127.0.0.1'
PROJECTOR_PORT = 41794


class Projector(plugins.SimplePlugin):
    def __init__(self, bus):
        super(Projector, self).__init__(bus)

        global projector
        projector = self

        self.info = ProjectorInfo()
        self.t = None
        self.running = False
        self.status = [
            {'location': 'Sanctuary', 'online': False, 'lampHours': 0, 'serviceHours': 0, 'msgCount': 0}
        ]
        self.sock = None

    def start(self):
        self.running = True
        self.t = threading.Thread(target=Projector.worker)
        self.t.daemon = True
        self.t.start()

    def stop(self):
        self.running = False

    def connect(self):
        try:
            print("connect {}:{}".format(PROJECTOR_ADDR, PROJECTOR_PORT))
            self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.sock.settimeout(1000)
            self.sock.connect((PROJECTOR_ADDR, PROJECTOR_PORT))
            projector.status[0]['online'] = True
        except IOError as e:
            self.disconnect()

    def disconnect(self):
        if self.sock is not None:
            try:
                self.sock.close()
            finally:
                self.sock = None
                self.info.reset()
                projector.status[0]['online'] = False

    def process(self):
        if self.sock is None:
            self.connect()

        if self.sock is not None:
            try:
                data = self.sock.recv(1024)
                self.info.handle_data(data)

            except IOError:
                self.disconnect()

        self.status[0]['lampHours'] = self.info.lamp_hours
        self.status[0]['serviceHours'] = self.info.service_hours
        self.status[0]['msgCount'] = self.info.msg_count

    @staticmethod
    def worker():
        s = None
        while projector.running:
            time.sleep(1)
            projector.process()

        projector.disconect()


class ProjectorServer(object):
    def __init__(self):
        self.pages = {}

    def get_page(self, pathname):
        if pathname not in self.pages:
            with open('static/{}'.format(pathname), 'r') as file:
                if debug:
                    return file.read()
                else:
                    self.pages[pathname] = file.read()
        return self.pages[pathname]

    @cherrypy.expose
    def index(self):
        return self.get_page('index.html')

    @cherrypy.expose
    @cherrypy.tools.json_out()
    def projector(self):
        return projector.status


if __name__ == '__main__':
    conf = {
        '/': {
            'tools.sessions.on': True,
            'tools.staticdir.root': os.path.abspath(os.getcwd())
        },
        '/static': {
            'tools.staticdir.on': True,
            'tools.staticdir.dir': './static',
        }
    }
    Projector(cherrypy.engine).subscribe()
    cherrypy.quickstart(ProjectorServer(), '/', conf)
