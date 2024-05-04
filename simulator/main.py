import logging
import threading
from http.server import HTTPServer, SimpleHTTPRequestHandler
import socketserver
import os
from functools import partial

from sim import constants as c
from sim.projectorSimulator import ProjectorSim


class HttpServer:
    def __init__(self, name):
        self.name = name
        self.running = False
        self.port = 80
        self.root = os.path.join(os.path.dirname(__file__), 'web')
        self.httpd = None

    def run(self):
        self.running = True

        handler = partial(SimpleHTTPRequestHandler, directory=self.root)
        self.httpd = socketserver.TCPServer(("", self.port), handler)
        logging.info(f'serving at port {self.port}')

        while self.running:
            self.httpd.handle_request()

        self.httpd = None
        self.running = False

    def stop(self):
        self.running = False
        if self.httpd is not None:
            self.httpd.server_close()


def runner_thread(name, runner):
    logging.info(f'{name}_thread:start')
    runner.run()
    logging.info(f'{name}_thread:end')


def main():
    fmt = "%(asctime)s: %(message)s"
    logging.basicConfig(format=fmt, level=logging.INFO, datefmt="%H:%M:%S")

    sim = ProjectorSim(c.INFOCUS_IN2128HDx)
    server = HttpServer(c.INFOCUS_IN2128HDx)

    sim_t = threading.Thread(target=runner_thread, args=('sim', sim,))
    http_t = threading.Thread(target=runner_thread, args=('http', server,))

    sim_t.start()
    http_t.start()

    input("Press Enter to exit...")

    logging.info('stopping...')
    sim.stop()
    server.stop()

    sim_t.join()
    http_t.join()


if __name__ == "__main__":
    main()
