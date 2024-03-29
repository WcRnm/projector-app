import cherrypy
from cherrypy.process import plugins

from ws4py.server.cherrypyserver import WebSocketPlugin, WebSocketTool
from ws4py.websocket import EchoWebSocket

import mimetypes
import os
import socket
import threading
import time

from projector import ProjectorInfo

debug = True

projector = None

PROJECTOR_ADDR = '127.0.0.1'
PROJECTOR_PORT = 41794


def _setup_mimetypes():
    """Pre-initialize global mimetype map."""
    if not mimetypes.inited:
        mimetypes.init()
    mimetypes.types_map['.js'] = 'application/javascript'
    mimetypes.types_map['.css'] = 'text/css'


_setup_mimetypes()


class Projector(plugins.SimplePlugin):
    def __init__(self, bus):
        super(Projector, self).__init__(bus)

        global projector
        projector = self

        self.info = ProjectorInfo('Sanctuary', 0)
        self.t = None
        self.running = False
        self.status = [self.info.status]
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
        except IOError as e:
            self.disconnect()

    def disconnect(self):
        if self.sock is not None:
            try:
                self.sock.close()
            finally:
                self.sock = None
                self.info.reset()

    def process(self):
        if self.sock is None:
            self.connect()

        if self.sock is not None:
            try:
                data = self.sock.recv(1024)
                self.info.handle_data(data)

            except IOError:
                self.disconnect()
            except projector.ProjectorDisconnectError:
                self.disconnect()

        self.info.idle_tasks(self.sock)

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

    @cherrypy.expose
    def ws(self):
        # you can access the class instance through
        handler = cherrypy.request.ws_handler


if __name__ == '__main__':
    conf = {
        '/': {
            'tools.sessions.on': True,
            'tools.staticdir.root': os.path.abspath(os.getcwd()),
        },
        '/static': {
            'tools.staticdir.on': True,
            'tools.staticdir.dir': './static',
        },
        '/ws': {
            'tools.websocket.on': True,
            'tools.websocket.handler_cls': EchoWebSocket
        }
    }

    Projector(cherrypy.engine).subscribe()

    WebSocketPlugin(cherrypy.engine).subscribe()
    cherrypy.tools.websocket = WebSocketTool()

    cherrypy.quickstart(ProjectorServer(), '/', conf)
