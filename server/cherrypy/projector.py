
class ProjectorInfo:
    def __init__(self):
        self.location = 'Sanctuary'
        self.lamp_hours = 0
        self.service_hours = 0
        self.msg_count = 0

    def reset(self):
        self.lamp_hours = 0
        self.service_hours = 0
        self.msg_count = 0

    def handle_data(self, data):
        print("read {}".format(len(data)))
        self.msg_count += 1

