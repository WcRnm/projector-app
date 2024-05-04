import time
import math
import socket

from simulator.sim import constants as c


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
        self.handle = 0
        self.start_time = 0
        self.running = False
        self.sever_socket = None

    def log(self, msg):
        print('{0:6} {1}'.format((ms() - self.start_time), msg))

    def stop(self):
        self.running = False
        if self.sever_socket is not None:
            self.sever_socket.close()

    def run(self):
        self.running = True
        self.sever_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sever_socket.bind((self.host, self.port))
        self.sever_socket.listen()

        print("Listening on port ", self.port)
        while self.running:
            pending = bytearray()
            try:
                conn, addr = self.sever_socket.accept()
            except OSError:
                return

            try:
                with conn:
                    self.conn = conn
                    self.start_time = ms()
                    self.log('Connected to {}'.format(addr))

                    conn.sendall(ProjectorSim.connect_request())

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

            except ProtocolError as e:
                self.log('ProtocolError: {}'.format(e.message))
            except IOError as e:
                self.log('IOError: {}'.format(e))
            finally:
                conn.close()
                self.conn = None

            self.log('Connection Done')

    def send_message(self, msg):
        if self.conn is not None:
            self.conn.sendall(msg)

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
    def read_packet(pending):
        if len(pending) < 3:
            return None

        msg_len = 3 + (pending[1] * 256 + pending[2])

        if len(pending) < msg_len:
            return None

        packet = pending[0:msg_len]
        del pending[0:msg_len]

        return packet

    def handle_packet(self, data):
        if data[0] == 1:
            self.handle_connect(data)
        elif data[0] == 0xd:  # 13
            self.handle_heartbeat(data)
        elif data[0] == 5:
            self.send_test_messages()

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
        self.handle = data[3] * 256 + data[4]
        self.send_message(self.heartbeat_response(self.handle))

    @staticmethod
    def connect_request():
        return bytes([0x0f, 0x00, 0x01, 0x02])

    @staticmethod
    def connect_response(client_id):
        return bytes([0x02, 0x00, 0x04, 0x00, 0x00, math.floor(client_id/256), client_id % 256])

    @staticmethod
    def heartbeat_response(client_handle):
        return bytes([0x0e, 0x00, 0x02, math.floor(client_handle/256), client_handle % 256])

    def send_test_messages(self):
        msgs = ProjectorSim.test_messages(self.client_id, self.handle)

        for msg in msgs:
            try:
                self.send_message(bytes.fromhex(msg))
            except ValueError as e:
                pass

    @staticmethod
    def test_messages(id, handle):
        return [
            "050006000003001500",
            "050006000003000000",
            "050006000003000500",
            "05000600000300ef13",
            "05000600000300f113",
            "05000600000300fd13",
            "050006000003005a14",
            "050006000003005c14",
            "050006000003006014",
            "050008000005140001001e",
            "05000600000300fa94",
            "050006000003005914",
            "05001000000d1513af0331302e342e332e3630",
            "0500140000111513b0033235352e3235352e3235322e30",
            "05000f00000c1513b10331302e342e302e31",
            "05000f00000c1513b20331302e342e302e31",
            "0500180000151513b30330303a65303a34373a32363a32613a3761",
            "05001000000d1513cd03436f6d707574657231",
            "05001000000d1513ce03436f6d707574657232",
            "05000b0000081513cf0348444d49",
            "05001000000d1513d003436f6d706f73697465",
            "05000e00000b1513d103532d566964656f",
            "05001000000d1513d2034c6967687463617374",
            "0500060000030015000500130000101513b40331302e302e3136372e313031",
            "0500080000051513b5033505000c0000091513b6033431373934",
            "05001000000d1513b90350524f4a4543544f52",
            "05000c0000091513ba0347524f5550",
            "05001000000d1513bb0353616e637475617279",
            "050009000006150004033339",
            "05000b00000815138b0331303030",
            "050006000003000480",
            "05000600000300",
            "050005001100000e15138803506f776572204f66662e",
            "05001100000e15138903506f776572204f66662e",
            "05000d00000a15139103536f75726365",
            "05001200000f15138a034e6f726d616c204d6f6465",
            "05001100000e15000103303a4e6f204572726f72",
            "05001200000f1513bd033139323020782031303830",
            "05001100000e1513bc0352656172205461626c65",
            "0500080000051413937ffd05000600000300ee93",
            "05000600000300ef1305000600000300f093",
            "05000600000300f11305000600000300fc93",
            "05000600000300fd1305000d00000a1513be03427269676874",
            "0500080000051413897fee05000800000514138a7fee",
            "050008000005141388000005000800000514138bfffe",
            "0500100000 0d1513bf035630342e30312e3634",
            "050008000005141394003f",
        ]


def main(model=c.INFOCUS_IN2128HDx):
    sim = ProjectorSim(model)

    sim.run()


if __name__ == "__main__":
    main()
