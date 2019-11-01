
ONLINE = 'online'
LOCATION = 'location'
LAMP_HRS = 'lampHrs'
SERVICE_HRS = 'serviceHrs'
MSG_COUNT = 'msgCount'


class ProjectorInfo:
    def __init__(self):
        self.status = {LOCATION: 'Sanctuary', ONLINE: False, LAMP_HRS: 0, SERVICE_HRS: 0, MSG_COUNT: 0}

    def reset(self):
        self.status[LAMP_HRS] = 0
        self.status[MSG_COUNT] = 0
        self.status[SERVICE_HRS] = 0
        self.status[ONLINE] = False

    def handle_data(self, data):
        print("read {}".format(len(data)))
        self.status[ONLINE] = True
        self.status[MSG_COUNT] += 1

