package com.wcRnm.projectorController

const val DEFAULT_IPID          = 3
const val DEFAULT_HANDLE        = 0

interface IProjector {
    val heartbeat:           ByteArray
    val connectMessage:      ByteArray
    val endOfQueryResponse:  ByteArray
    val updateRequestPacket: ByteArray
    fun digitalCommand(stdCmd:Int, value:Boolean, extraParam:Int = 0) : ByteArray
}

const val CMD_NONE          = 0
const val CMD_POWER_ON      = 1
const val CMD_POWER_OFF     = 2
const val CMD_VOLUME_UP     = 3
const val CMD_VOLUME_DOWN   = 4
const val CMD_MUTE          = 5
const val CMD_MENU_UP       = 6
const val CMD_MENU_DOWN     = 7
const val CMD_MENU_LEFT     = 8
const val CMD_MENU_RIGHT    = 9
const val CMD_MENU          = 10
const val CMD_MENU_ENTER    = 11
const val CMD_MENU_EXIT     = 12
const val CMD_HELP          = 13
const val CMD_VOLUME        = 14
const val CMD_WARMING_UP    = 15
const val CMD_WARMING_VAL   = 16
const val CMD_HELP_MSG      = 17
const val CMD_JUMP_TO_TOOLS = 18
const val CMD_JUMP_TO_INFO  = 19
const val CMD_CS_IP_ADDR    = 20
const val CMD_CS_IP_ID      = 21
const val CMD_CS_PORT       = 22
const val CMD_PROJECTOR_NAME = 23
const val CMD_LOCATION      = 24
const val CMD_IP_ADDR       = 25
const val CMD_SUBNET_MASK   = 26
const val CMD_DEFAULT_GATEWAY = 27
const val CMD_DNS_SERVER    = 28
const val CMD_USER_NAME     = 29
const val CMD_USER_PWRD         = 30
const val CMD_USER_CONFIRM      = 31
const val CMD_ADMIN_PWRD        = 32
const val CMD_ADMIN_CONFIRM     = 33
const val CMD_JUMP_TO_HELP      = 34
const val CMD_U_PWRD_ENABLED    = 35
const val CMD_A_PWRD_ENABLED    = 36
const val CMD_DHCP_ENABLED      = 37
const val CMD_FIRMWARE      = 38
const val CMD_MAC_ADDR      = 39
const val CMD_RESOLUTION    = 40
const val CMD_LAMP_HOURS    = 41
const val CMD_ASSIGNED_TO   = 42
const val CMD_POWER_STATUS  = 43
const val CMD_PRESET_MODE   = 44
const val CMD_PROJ_POS      = 45
const val CMD_LAMP_MODE     = 46
const val CMD_ERROR_STATUS  = 47
const val CMD_KEYPAD_EXT1   = 48
const val CMD_KEYPAD_EXT2   = 49
const val CMD_KEYPAD_EXT3   = 50
const val CMD_KEYPAD_EXT4   = 51
const val CMD_MUTE_OFF      = 52
const val CMD_KEYPAD_EXT1_T = 53
const val CMD_KEYPAD_EXT2_T = 54
const val CMD_KEYPAD_EXT3_T = 55
const val CMD_KEYPAD_EXT4_T = 56

class InfocusIN2128HDx() : IProjector {
    private val handle: Int = DEFAULT_HANDLE
    private val ipid:   Int = DEFAULT_IPID

    override val heartbeat = byteArrayOfInts(
        13,
        0,
        2,
        handle / 256,
        handle % 256
    )
    override val connectMessage = byteArrayOfInts(
        1,
        0,
        7,
        0,
        0,
        0,
        0,
        ipid / 256,
        ipid % 256,
        64
    )

    override val endOfQueryResponse = byteArrayOfInts(
        5,
        0,
        5,
        handle / 256,
        handle % 256,
        2,
        3,
        29
    )

    override val updateRequestPacket = byteArrayOfInts(
        5,
        0,
        5,
        handle / 256,
        handle % 256,
        2,
        3,
        30
    )

    override fun digitalCommand(stdCmd:Int, value:Boolean, extraParam:Int) : ByteArray
    {
        var extraLen:Byte = if (extraParam > 0) 3 else 0
        val iCmd = stdCmd-1

        var cmd = byteArrayOfInts(
            5,
            0,
            6 + extraLen,
            handle / 256,
            handle % 256,
            3 + extraLen
        )

        if(extraParam > 0)
        {
            cmd += 32
            cmd += extraParam.toByte()
            cmd += 3
        }

        cmd += 0
        cmd += (iCmd % 256).toByte()

        if (!value)
            cmd += ((iCmd / 256) or 128).toByte()
        else
            cmd += (iCmd / 256).toByte()

        return cmd
    }

    private fun byteArrayOfInts(vararg ints: Int) = ByteArray(ints.size) { pos -> ints[pos].toByte() }
}