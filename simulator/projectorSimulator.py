import time
import math
import socket

import constants as c


class Error(Exception):
    # Base class for exceptions in this module
    pass


class ProtocolError(Error):
    def __init__(self, message):
        self.message = message


def ms():
    return math.floor(time.time_ns() / 1000000)



class ProjectorSim:
    def __init__(self, model):
        self.model = model
        self.port = c.PORT
        self.host = '127.0.0.1'
        self.socket = None
        self.conn = None
        self.client_id = 0
        self.client_handle = 0
        self.start = 0

    def log(self, msg):
        print('{0:6} {}'.format((ms() - self.start), msg))

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
                        self.conn = conn
                        self.start = ms()
                        self.log('Connected to ', addr)

                        conn.send(ProjectorSim.connect_request())

                        while True:
                            data = conn.recv(64)
                            if len(data) == 0:
                                self.log('Client disconnect')
                                break

                            # append data to pending messages
                            for b in data:
                                pending.append(b)

                            while self.handle_message(pending):
                                continue

                except Exception as e:
                    self.log('Exception: {}'.format(e))
                except ProtocolError as e:
                    self.log('ProtocolError: {}'.format(e.message))
                finally:
                    conn.close()
                    self.conn = None

    def send_message(self, msg):
        if self.conn is not None:
            self.conn.send(msg)

    def handle_message(self, pending):
        self.log('recv {} bytes'.format(len(pending)))

        while len(pending) > 0:
            packet = self.read_packet(pending)
            if packet is None:
                return False
            else:
                self.handle_packet(packet)

        return False

    @staticmethod
    def read_packet(self, pending):
        if len(pending) < 3:
            return None

        msg_len = 3 + (pending[1] * 256 + pending[2])

        if len(pending) < msg_len:
            return None

        packet = pending[0:(msg_len-1)]
        del pending[0:(msg_len-1)]

        return packet

    def handle_packet(self, data):
        if data[0] == 1:
            self.handle_connect(data)
        elif data[0] == 0xd:  # 13
            self.handle_heartbeat(data)

    def handle_connect(self, data):
        payload_len = len(data) - 3

        if payload_len != 7:
            raise ProtocolError('Bad connect message length ({})', payload_len)

        self.log('recv: connect request')

        self.client_id = data[7] * 256 + data[8]
        self.send_message(self.connect_response(self.client_id))

    def handle_heartbeat(self, data):
        payload_len = len(data) - 3

        if payload_len != 2:
            raise ProtocolError('Bad heartbeat message length ({})', payload_len)

        self.log('recv: heartbeat')
        self.client_handle = data[3] * 256 + data[4]
        self.send_message(self.heartbeat_response(self.client_handle))

    @staticmethod
    def connect_request():
        return bytes([0x0f, 0x00, 0x01, 0x02])

    @staticmethod
    def connect_response(client_id):
        return bytes([0x02, 0x00, 0x04, 0x00, 0x00, math.floor(client_id/256), client_id % 256])

    @staticmethod
    def heartbeat_response(client_handle):
        return bytes([0x0e, 0x00, 0x02, math.floor(client_handle/256), client_handle % 256])


def main(model=c.INFOCUS_IN2128HDx):
    sim = ProjectorSim(model)

    sim.run()


if __name__ == "__main__":
    main()
