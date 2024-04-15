from abc import ABC, abstractmethod


class ProjectorDataHandler:
    @abstractmethod
    def on_idle(self):
        pass

    @abstractmethod
    def on_heartbeat(self):
        pass

    @abstractmethod
    def set_lamp_hours(self, hrs):
        pass

