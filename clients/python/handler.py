from abc import abstractmethod

from enum import Enum


class ConnectState(Enum):
    Disconnected = 'Disconnected'
    Connecting = 'Connecting'
    Connected = 'Connected'


class ProjectorDataHandler:
    @abstractmethod
    def on_connect_change(self, state):
        pass

    def on_idle(self):
        pass

    @abstractmethod
    def on_heartbeat(self):
        pass

    @abstractmethod
    def set_lamp_hours(self, curr_hrs):
        pass
