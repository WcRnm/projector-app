import cherrypy
from cherrypy.process import plugins
import json
import os
import threading
import time

debug = True

projector = None


class Projector(plugins.SimplePlugin):
    def __init__(self, bus):
        super(Projector, self).__init__(bus)

        global projector
        projector = self

        self.t = None
        self.running = False
        self.state = [
            {'location': 'Sanctuary', 'online': False, 'lampHours': 0, 'serviceHours': 0}
        ]

    def start(self):
        self.running = True
        self.t = threading.Thread(target=Projector.worker)
        self.t.daemon = True
        self.t.start()

    def stop(self):
        self.running = False

    @staticmethod
    def worker():
        while projector.running:
            # TODO: manage projector connection
            time.sleep(5)


class LocalServer(object):
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
    def projector(self):
        return json.dumps(projector.state)


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
    cherrypy.quickstart(LocalServer(), '/', conf)
