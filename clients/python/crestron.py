import math
import queue

from data_names import *


class ProjectorError(Exception):
    pass


class ProjectorDisconnectError(ProjectorError):
    pass


# Tasks
TASK_NONE = 'none'
TASK_CONNECT = 'connect'
TASK_REQUEST_INFO = 'request-info'
TASK_END_OF_QUERY = 'end-of-query'
TASK_VALUE = 'value'
TASK_HEARTBEAT = 'heartbeat'


class TaskQueue(queue.Queue):
    def clear(self):
        try:
            while True:
                self.get_nowait()
        except queue.Empty:
            pass

    def safe_get(self):
        try:
            return self.get_nowait()
        except queue.Empty:
            return TASK_NONE, 0, 0


# Capabilities
SUPPORTS_HEARTBEAT = 'supports_heartbeat'
SUPPORTS_REPEAT_DIGITALS = 'supports_repeat_digitals'


def LOG_D(msg):
    print(msg)


class Projector:
    def __init__(self, callbacks=None, ipid=0):
        self.connected = False
        self.ipid = ipid  # app ID ?
        self.handle = 0  # Projector ID
        self.buffer = bytearray()
        self.tasks = TaskQueue()
        self.status = {}
        self.caps = {}
        self.namer = DataNamer()
        self.callbacks = callbacks

        self.reset()

    def reset(self):
        self.connected = False
        self.handle = 0
        self.buffer.clear()
        self.tasks.clear()

        self.status[MSG_COUNT] = 0
        self.status[ONLINE] = False

        self.caps[SUPPORTS_HEARTBEAT] = False
        self.caps[SUPPORTS_REPEAT_DIGITALS] = False

    def idle_tasks(self, sock):
        self.callbacks.on_idle()
        while not self.tasks.empty():
            task, data_id, data_value, value_type = self.tasks.safe_get()

            if TASK_CONNECT == task:
                sock.send(self.msg_connect(self.ipid))
            elif TASK_REQUEST_INFO == task:
                sock.send(self.msg_update_request(self.handle))
            elif TASK_END_OF_QUERY == task:
                sock.send(self.msg_end_of_query_response(self.handle))
            elif TASK_VALUE == task:
                name = self.namer.get_name(data_id, value_type)
                LOG_D(f"  {data_id}) {name} = {data_value}")
                self.status[name] = data_value
                self.callbacks.on_value_change(name, data_value)
            elif TASK_HEARTBEAT == task:
                self.callbacks.on_heartbeat()
            else:
                continue

    def submit_task(self, task, data_id=0, data_value=0, value_type=None):
        self.tasks.put((task, data_id, value_type, data_value))

    def handle_data(self, data):
        # LOG_D("read {}".format(len(data)))
        self.status[ONLINE] = True

        self.buffer.extend(data)

        while True:
            packet_len = Projector.next_packet_len(self.buffer)
            if 0 == packet_len:
                break

            packet = self.buffer[0:packet_len]
            self.buffer = self.buffer[packet_len:]
            self.handle_packet(packet)
            self.status[MSG_COUNT] += 1

    @staticmethod
    def next_packet_len(avail):
        avail_len = len(avail)
        if avail_len < 3:
            return 0

        payload_len = avail[1] * 256 + avail[2]
        if avail_len < payload_len + 3:
            return 0

        return payload_len + 3

    def handle_packet(self, packet):
        packet_type = packet[0]

        if 2 == packet_type:
            self.handle_connect_response(packet)
        elif 3 == packet_type:
            self.handle_disconnect(packet)
        elif 4 == packet_type:
            self.handle_disconnect(packet)
        elif 5 == packet_type:
            self.handle_data_packet(packet)
        elif 14 == packet_type:
            self.handle_heartbeat(packet)
        elif 15 == packet_type:
            self.handle_connect_status(packet)
        else:
            pass  # ignore

    def handle_connect_response(self, packet):
        LOG_D("connect_response")
        if self.connected:
            return

        if len(packet) < 6:
            return

        self.handle = packet[3] * 256 + packet[4]

        if len(packet) >= 7:
            b = (1 == (1 and packet[6]))
            self.caps[SUPPORTS_REPEAT_DIGITALS] = b
            self.caps[SUPPORTS_HEARTBEAT] = b

        self.connected = True
        self.submit_task(TASK_REQUEST_INFO)

    def handle_disconnect(self, packet):
        LOG_D("disconnect")
        self.on_disconnect()

    def handle_data_packet(self, data):
        # LOG_D("handle_data_packet")

        if data[5] > 0:
            offset = data[6] == 32 if 3 else 0
            data_type = data[6 + offset]
            if 0 == data_type:
                self.handle_digital(data, offset)
            elif 1 == data_type:
                self.handle_analog(data, offset)
            elif 20 == data_type:
                self.handle_analog(data, offset)
            elif 21 == data_type:
                self.handle_serial1(data, offset)
            elif 18 == data_type:
                self.handle_serial2(data, offset)
            elif 2 == data_type:
                self.handle_serial3(data, offset)
            elif 3 == data_type:
                self.handle_end_of_query(data, offset)

    def handle_heartbeat(self, packet):
        LOG_D("heartbeat")
        # TODO: if missed heart beat response ...
        self.submit_task(TASK_HEARTBEAT)

    def handle_connect_status(self, packet):
        LOG_D("connect_status")
        if len(packet) > 3:
            action = packet[3]
            if 0 == action:
                self.on_disconnect()
            elif 2 == action:
                if not self.connected:
                    self.submit_task(TASK_CONNECT)

    def on_disconnect(self):
        self.reset()
        raise ProjectorDisconnectError()

    def handle_digital(self, data, offset):
        if data[5 + offset] != 3:
            return

        data_id = (data[8 + offset] * 256) + data[7 + offset]
        data_id = (data_id & 32767) + 1  # (data_id & 0x7FFF) + 1
        value = ((data[8 + offset] & 128) != 128)  # 0x80

        self.submit_task(TASK_VALUE, data_id, DATA_BOOL, value)

    def handle_analog(self, data, offset):
        data_id = data[7 + offset] + 1
        t = data[5 + offset]
        if 3 == t:
            value = data[8 + offset]
        elif 4 == t:
            value = data[8 + offset] * 256 + data[9 + offset]
        elif 5 == t:
            data_id = data_id * 256 + data[8 + offset]
            value = data[9 + offset] * 256 + data[10 + offset]
        else:
            return

        self.submit_task(TASK_VALUE, data_id, DATA_ANALOG, value)

    def handle_serial1(self, data, offset):
        # LOG_D("-->handle_serial1")
        msg = ""
        data_id = (data[7 + offset] * 256) + data[8 + offset] + 1
        n = data[5 + offset] - 4
        j = 10 + offset
        i = 0

        while i < n:
            # todo: string append is inefficient - improve it!
            msg += chr(data[j])
            i += 1
            j += 1

        self.submit_task(TASK_VALUE, data_id, DATA_TEXT, msg)

    def handle_serial2(self, data, offset):
        # LOG_D("-->handle_serial2")
        msg = ""
        data_id = data[7 + offset] + 1
        n = data[5 + offset] - 2
        j = 8 + offset
        i = 0
        while i < n:
            # todo: string append is inefficient - improve it!
            msg += chr(data[j])
            i += 1
            j += 1

        self.submit_task(TASK_VALUE, data_id, DATA_TEXT, msg)

    def handle_serial3(self, data, offset):
        # LOG_D("-->handle_serial3")
        if data[7 + offset] == 35:
            i = 8 + offset
            j = i + (data[5 + offset] - 2)
            while j > i:
                msg = ""
                data_id = 0
                while 48 <= data[i] <= 57:
                    i += 1
                    data_id = data_id * 10 + (data[i] - 48)
                i += 1
                while i < j and data[i] != 13:
                    i += 1
                    # todo: string append is inefficient - improve it!
                    msg += chr(data[i])

                self.submit_task(TASK_VALUE, data_id, DATA_TEXT, msg)

                i += 2

    def handle_end_of_query(self, data, offset):
        self.submit_task(TASK_END_OF_QUERY)

    @staticmethod
    def msg_connect(ipid):
        return bytes([
            1,
            0,
            7,
            0,
            0,
            0,
            0,
            math.floor(ipid / 256),
            ipid % 256,
            64
        ])

    @staticmethod
    def msg_end_of_query_response(handle):
        return bytes([
            5,
            0,
            5,
            math.floor(handle / 256),
            handle % 256,
            2,
            3,
            29
        ])

    @staticmethod
    def msg_update_request(handle):
        return bytes([
            5,
            0,
            5,
            math.floor(handle / 256),
            handle % 256,
            2,
            3,
            30
        ])
