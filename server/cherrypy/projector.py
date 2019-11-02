import queue


class ProjectorError(Exception):
    pass


class ProjectorDisconnectError(ProjectorError):
    pass


class MyQueue(queue.Queue):
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
            return None


# Statuses
ONLINE = 'online'
LOCATION = 'location'
LAMP_HRS = 'lampHrs'
SERVICE_HRS = 'serviceHrs'
MSG_COUNT = 'msgCount'

# Capabilities
SUPPORTS_HEARTBEAT = 'supports_heartbeat'
SUPPORTS_REPEAT_DIGITALS = 'supports_repeat_digitals'

# Tasks
TASK_CONNECT = 0
TASK_REQUEST_INFO = 1


def LOG_D(msg):
    print(msg)


class ProjectorInfo:
    def __init__(self, location, server_id):
        self.connected = False
        self.id = server_id
        self.handle = 0  # Projector ID
        self.buffer = bytearray()
        self.tasks = MyQueue()
        self.status = {}
        self.caps = {}

    def reset(self):
        self.connected = False
        self.handle = 0
        self.buffer.clear()
        self.tasks.clear()

        self.status[LAMP_HRS] = 0
        self.status[MSG_COUNT] = 0
        self.status[SERVICE_HRS] = 0
        self.status[ONLINE] = False

        self.caps[SUPPORTS_HEARTBEAT] = False
        self.caps[SUPPORTS_REPEAT_DIGITALS] = False

    def idle_tasks(self):
        task = self.tasks.safe_get()
        while task is not None:
            LOG_D("task: {}".format(task))
            task = self.tasks.safe_get()

            # todo: handle tasks
            if TASK_CONNECT == task:
                pass
            if TASK_REQUEST_INFO == task:
                pass

    def handle_data(self, data):
        LOG_D("read {}".format(len(data)))
        self.status[ONLINE] = True

        self.buffer.extend(data)

        while True:
            packet_len = ProjectorInfo.next_packet_len(self.buffer)
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
        self.tasks.put(TASK_REQUEST_INFO)

    def handle_disconnect(self, packet):
        LOG_D("disconnect")
        self.on_disconnect()

    def handle_data_packet(self, packet):
        LOG_D("data_packet")
        pass

    def handle_heartbeat(self, packet):
        LOG_D("heartbeat")
        pass

    def handle_connect_status(self, packet):
        LOG_D("connect_status")
        if len(packet) > 3:
            action = packet[3]
            if 0 == action:
                self.on_disconnect()
            elif 2 == action:
                if not self.connected:
                    self.tasks.put(TASK_CONNECT)

    def on_disconnect(self):
        self.reset()
        raise ProjectorDisconnectError()
