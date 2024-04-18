# Statuses
ONLINE = 'conn-online'
MSG_COUNT = 'conn-msg-count'

DATA_TEXT = 'text'
DATA_BOOL = 'boolean'
DATA_ANALOG = 'analog'

STATE_ERROR = 'state-error'
STATE_LAMP_HOURS = 'state-lamp-hrs'
STATE_MODE = 'state-mode'
STATE_SOURCE = 'state-source'
NETWORK_IPADDR = 'network-ipaddr'
NETWORK_MASK = 'network-netmask'
NETWORK_MAC = 'network-mac'
NETWORK_PORT = 'network-port'
CONFIG_LOCATION = 'config-location'
INFO_RESOLUTION = 'info-resolution'
INFO_FIRMWARE = 'info-firmware'


class DataNamer:
    def __init__(self):
        self.TEXT_NAMES = {
            2: STATE_ERROR,
            5: STATE_LAMP_HOURS,
            5003: STATE_MODE,
            5010: STATE_SOURCE,
            5040: NETWORK_IPADDR,
            5041: NETWORK_MASK,
            5044: NETWORK_MAC,
            5047: NETWORK_PORT,
            5052: CONFIG_LOCATION,
            5054: INFO_RESOLUTION,
            5056: INFO_FIRMWARE,
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
