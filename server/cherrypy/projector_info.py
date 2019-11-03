# Statuses
ONLINE = 'online'
LOCATION = 'location'
LAMP_HRS = 'lampHrs'
SERVICE_HRS = 'serviceHrs'
MSG_COUNT = 'msgCount'

DATA_TEXT = 'text'
DATA_BOOL = 'bool'
DATA_ANALOG = 'analog'

TEXT_NAMES = {
    2: 'error',
    5: LAMP_HRS,
    5003: 'mode',
    5040: 'ip-addr',
    5041: 'netmask',
    5044: 'mac-addr',
    5047: 'port',
    5052: LOCATION,
    5054: 'resolution',
    5056: 'firmware-version',
    5070: 'source-1',
    5071: 'source-2',
    5072: 'source-3',
    5073: 'source-4',
    5074: 'source-5',
    5075: 'source-6',
}

BOOL_NAMES = {

}

ANALOG_NAMES = {

}


def get_id_name(data_id, data_type):
    if DATA_ANALOG == data_type:
        table = ANALOG_NAMES
        prefix = 'A'
    elif DATA_BOOL == data_type:
        table = BOOL_NAMES
        prefix = 'B'
    elif DATA_TEXT == data_type:
        table = TEXT_NAMES
        prefix = 'T'
    else:
        return None

    try:
        return table[data_id]
    except Exception as e:
        return '{}-{}'.format(prefix, data_id)
