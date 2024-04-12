# Statuses
ONLINE = 'conn-online'
MSG_COUNT = 'conn-msg-count'

DATA_TEXT = 'text'
DATA_BOOL = 'boolean'
DATA_ANALOG = 'analog'

TEXT_NAMES = {
    2: 'state-error',
    5: 'state-lamp-hrs',
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

BOOL_NAMES = {

}

ANALOG_NAMES = {

}


def get_id_name(data_id, data_type):
    if DATA_ANALOG == data_type:
        table = ANALOG_NAMES
        prefix = 'x-analog-'
    elif DATA_BOOL == data_type:
        table = BOOL_NAMES
        prefix = 'x-bool-'
    elif DATA_TEXT == data_type:
        table = TEXT_NAMES
        prefix = 'x-text-'
    else:
        return None

    try:
        return table[data_id]
    except Exception as e:
        return '{}{}'.format(prefix, data_id)
