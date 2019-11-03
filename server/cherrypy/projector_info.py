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
        table = ANALOG_NAMES
        prefix = 'T'
    else:
        return None

    try:
        return table[data_id]
    except Exception as e:
        return '{}-{}'.format(prefix, data_id)
