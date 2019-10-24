import time
import math
import socket

import constants as c


def ms():
    return math.floor(time.time_ns() / 1000000)


def dt(startMs):
    return ms() - startMs


class ProjectorSim:
    def __init__(self, model):
        self.model = model
        self.port = c.PORT
        self.host = '127.0.0.1'
        self.socket = None

    def run(self):
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.bind((self.host, self.port))
            s.listen()

            print("Listening on port ", self.port)
            while True:
                pending = bytearray()
                conn, addr = s.accept()
                try:
                    with conn:
                        print('Connected to ', addr)
                        start = ms()
                        while True:
                            data = conn.recv(64)
                            if len(data) is 0:
                                print('{0:6} Client disconnect'.format(dt(start)))
                                break

                            # append data to pending messages
                            for b in data:
                                pending.append(b)

                            while self.handle_message(dt(start), pending):
                                continue
                except Exception as e:
                    print('{0:6} Exception: {1}'.format(dt(start), e))
                finally:
                    conn.close()

    def handle_message(self, dt, data):
        print('{0:6} recv {1} bytes'.format(dt, len(data)))

        while len(data) > 0:
            data.pop(0)

        return False


def main(model=c.INFOCUS_IN2128HDx):
    sim = ProjectorSim(model)

    sim.run()


if __name__ == "__main__":
    main()
