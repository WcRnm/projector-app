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

    @abstractmethod
    def set_network_address(self, addr, port):
        pass

    @abstractmethod
    def set_mac_address(self, addr):
        pass

    @abstractmethod
    def set_location(self, loc):
        pass

    @abstractmethod
    def set_resolution(self, res):
        pass

    @abstractmethod
    def set_error(self, error):
        pass

    @abstractmethod
    def set_firmware(self, firmware):
        pass
