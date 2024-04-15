from enum import IntEnum

# Statuses
ONLINE = 'conn-online'
MSG_COUNT = 'conn-msg-count'

DATA_TEXT = 'text'
DATA_BOOL = 'boolean'
DATA_ANALOG = 'analog'


class DataId(IntEnum):
    STATE_ERROR = 2,
    STATE_LAMP_HOURS = 5
    STATE_MODE = 5003
    NETWORK_IPADDR = 5040
    NETWORK_PORT = 5047
    INFO_RESOLUTION = 5054
    INFO_FIRMWARE = 5056


STATE_LAMP_HOURS = 'state-lamp-hrs'


class DataNamer:
    def __init__(self):
        self.TEXT_NAMES = {
            2: 'state-error',
            5: STATE_LAMP_HOURS,
            5003: 'state-mode',
            5010: 'value-source',
            5040: 'network-ip-addr',
            5041: 'network-netmask',
            5044: 'network-mac-addr',
            5047: 'network-port',
            5052: 'config-location',
            5054: 'info-resolution',
            5056: 'info-firmware-version',
            5070: 'value-source-1',
            5071: 'value-source-2',
            5072: 'value-source-3',
            5073: 'value-source-4',
            5074: 'value-source-5',
            5075: 'value-source-6',
        }

        self.BOOL_NAMES = {}
        self.ANALOG_NAMES = {}

    def get_name(self, data_id, data_type):
        if DATA_ANALOG == data_type:
            table = self.ANALOG_NAMES
        elif DATA_BOOL == data_type:
            table = self.BOOL_NAMES
        elif DATA_TEXT == data_type:
            table = self.TEXT_NAMES
        else:
            return None

        if data_id not in table:
            table[data_id] = f'x-{data_type}-{data_id}'

        return table[data_id]
