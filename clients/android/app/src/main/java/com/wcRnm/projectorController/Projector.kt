package com.wcRnm.projectorController

import android.content.Context
import android.util.Log
import androidx.preference.PreferenceManager
import java.io.OutputStream
import java.util.*

private const val TAG: String = "Projector"

const val DEFAULT_IPID          = 3
const val DEFAULT_HANDLE        = 0
const val HEARTBEAT_INTERVAL = 9000

class DisconnectException(message:String): Exception(message)

interface IProjector {
    fun handleData(data: ByteArray, dataLen: Int, outputStream: OutputStream)
    fun idleTasks(outputStream: OutputStream)
}

enum class ProjectorTask { SEND_CONNECT_MSG, REQUEST_INFO, DIGITAL_VALUE, ANALOG_VALUE, SERIAL_VALUE }
class ProjectorTaskItem(val task: ProjectorTask, val id: Int, val bVal: Boolean, val iVal: Int, val sVal: String) {

    constructor(task: ProjectorTask): this(task, 0, false, 0, "")
    constructor(task: ProjectorTask, id: Int, bVal: Boolean): this(task, id, bVal, 0, "")
    constructor(task: ProjectorTask, id: Int, iVal: Int): this(task, id, false, iVal, "")
    constructor(task: ProjectorTask, id: Int, sVal: String): this(task, id, false, 0, sVal)

    override fun toString(): String {
        return when (task) {
            ProjectorTask.SEND_CONNECT_MSG  -> "$task"
            ProjectorTask.REQUEST_INFO      -> "$task"
            ProjectorTask.DIGITAL_VALUE     -> "$task ${id}:${bVal}"
            ProjectorTask.ANALOG_VALUE      -> "$task ${id}:${iVal}"
            ProjectorTask.SERIAL_VALUE      -> "$task ${id}:${sVal}"
        }
    }
}

class InfocusIN2128HDx(context: Context) : IProjector {
    private var handle: Int = DEFAULT_HANDLE  // projector ID
    private val ipid:   Int = DEFAULT_IPID    // client ID

    private var cnxConnected            = false
    private var supportsRepeatDigitals  = false
    private var supportsHeartbeat       = false

    private var idleTicks   = System.currentTimeMillis()
    private var buffer      = ByteArray(0)
    private val taskQ       = ArrayDeque<ProjectorTaskItem>()
    private val props       = ProjectorProperties(PreferenceManager.getDefaultSharedPreferences(context))

    override fun idleTasks(outputStream: OutputStream) {
        //Log.d(TAG, "++idleTasks(${cnxConnected}, n:${taskQ.size})")
        //if (cnxConnected) {

            while (taskQ.size > 0) {
                val task = taskQ.removeFirst()

                Log.d(TAG, task.toString())

                when (task.task) {
                    ProjectorTask.SEND_CONNECT_MSG -> {
                        outputStream.write(msgConnect(ipid))
                    }
                    ProjectorTask.REQUEST_INFO     -> {
                        outputStream.write(msgUpdateRequest(handle))
                        //outputStream.write(msgDigitalCommand(handle, CMD_CS_PORT))
                    }
                    ProjectorTask.DIGITAL_VALUE     -> props.set(task.id, task.bVal)
                    ProjectorTask.ANALOG_VALUE      -> props.set(task.id, task.iVal)
                    ProjectorTask.SERIAL_VALUE      -> props.set(task.id, task.sVal)
                }
            }

            if (supportsHeartbeat) {
                val now = System.currentTimeMillis()
                if ((now - idleTicks) > HEARTBEAT_INTERVAL) {
                    outputStream.write(msgHeartbeat(handle))
                    idleTicks = System.currentTimeMillis()
                }
            }
        //}
        //else {
        //    if (taskQ.size > 0)
        //    taskQ.clear()
        //}
        //Log.d(TAG, "--idleTasks")
    }

    override fun handleData(data: ByteArray, dataLen: Int, outStream: OutputStream) {
        //Log.d(TAG, "++handleData(${dataLen})")
        buffer += data.take(dataLen)
        var len = nextPacketLength(buffer)

        while (len > 0) {
            val packet = buffer.take(len).toByteArray()
            buffer = buffer.drop(len).toByteArray()
            handlePacket(packet, outStream)
            len = nextPacketLength(buffer)
        }
        //Log.d(TAG, "--handleData")
    }

    private fun nextPacketLength(avail: ByteArray) : Int {
        if(avail.size < 3) {
            return 0
        }
        val len = avail[1] * 256 + avail[2]
        if(avail.size < len + 3) {
            return 0
        }

        return len + 3
    }

    private fun handlePacket(packet: ByteArray, outputStream: OutputStream) {
        //Log.d(TAG, "++handlePacket(id:${msgId} len:${packet.size})")

        when (packet[0].toInt()) {
            2    -> handleConnectResponse(packet)
            3    -> handleDisconnect()
            4    -> handleDisconnect()
            5    -> handleDataPacket(packet, outputStream)
            14   -> handleHeartbeat()
            15   -> handleConnectStatus(packet)
            else -> { /* ignore */ }
        }
        //Log.d(TAG, "--handlePacket")
    }

    private fun handleConnectStatus(packet:ByteArray) {
        if (packet.size > 3) {
            Log.d(TAG, "++handleConnectStatus(${packet[3]}, connected=${cnxConnected})")
            when(packet[3].toInt()) {
                0 -> handleDisconnect()
                2 -> {
                    if (!cnxConnected)
                        taskQ.add(ProjectorTaskItem(ProjectorTask.SEND_CONNECT_MSG))
                }
            }
        }
        Log.d(TAG, "--handleConnectStatus()")
    }

    private fun handleConnectResponse(data:ByteArray) {
        Log.d(TAG, "++handleConnect")

        if (cnxConnected)
            return

        if (data.size < 6)
            return

        this.handle = data[3] * 256 + data[4]

        if (data.size >= 7) {
            supportsRepeatDigitals = (1 == (1 and data[6].toInt()))
            supportsHeartbeat      = supportsRepeatDigitals

            Log.d(TAG, "handleConnect: supports heartbeat")
        }

        // this seems redundant, we already sent this message!
        //if (!cnxConnected)
        //    taskQ.add(ProjectorTaskItem(ProjectorTask.SEND_CONNECT_MSG))

        idleTicks    = System.currentTimeMillis()
        cnxConnected = true

        taskQ.add(ProjectorTaskItem(ProjectorTask.REQUEST_INFO))

        Log.d(TAG, "--handleConnect")
    }

    private fun handleDisconnect() {
        Log.d(TAG, "++handleDisconnect")
        if (cnxConnected) {
            cnxConnected = false
        }
        throw DisconnectException("Server initiated disconnect")
    }

    private fun handleHeartbeat() {
        Log.d(TAG, "handleHeartbeat")
        // TODO: if missed heart beat response ...
    }

    private fun handleDigitalPacket(data:ByteArray, offset:Int) {
        //Log.d(TAG, "handleDigitalPacket")

        if(data[5 + offset].toInt() != 3) {
            return
        }
        var id = data[8 + offset] * 256 + data[7 + offset]
        id = (id and 32767) + 1 // (id & 0x7FFF) + 1
        val bool = ((data[8 + offset].toInt() and 128) != 128) // 0x80

        taskQ.add(ProjectorTaskItem(ProjectorTask.DIGITAL_VALUE, id, bool))
    }

    private fun handleAnalogPacket(data:ByteArray, offset:Int) {
        //Log.d(TAG, "handleAnalogPacket")

        var id = data[7 + offset].toInt() + 1
        val value: Int
        when(data[5 + offset].toInt()) {
            3 -> value = data[8 + offset].toInt()
            4 -> value = data[8 + offset] * 256 + data[9 + offset]
            5 -> {
                id = id * 256 + data[8 + offset].toInt()
                value = data[9 + offset] * 256 + data[10 + offset]
            }
            else -> return
        }
        taskQ.add(ProjectorTaskItem(ProjectorTask.ANALOG_VALUE, id, value))
    }

    private fun handleSerialPacket1(data:ByteArray, offset:Int, type:Int) {
        //Log.d(TAG, "handleSerialPacket1")

        var msg = ""
        val id: Int = data[7 + offset] * 256 + data[8 + offset] + 1
        val n = data[5 + offset] - 4
        var j = 10 + offset
        var i = 0

        while(i++ < n) {
            msg += data[j++].toChar()
        }

        taskQ.add(ProjectorTaskItem(ProjectorTask.SERIAL_VALUE, id, msg))
    }

    private fun handleSerialPacket2(data:ByteArray, offset:Int, type:Int) {
        //Log.d(TAG, "handleSerialPacket2")

        var msg = ""
        val id = data[7 + offset].toInt() + 1
        val n = data[5 + offset] - 2
        var j = 8 + offset
        var i = 0
        while(i++ < n) {
            msg += data[j++].toChar()
        }

        taskQ.add(ProjectorTaskItem(ProjectorTask.SERIAL_VALUE, id, msg))
    }

    private fun handleSerialPacket3(data:ByteArray, offset:Int, type:Int) {
        Log.d(TAG, "handleSerialPacket3")

        if(data[7 + offset].toInt() == 35) {
            var i = 8 + offset
            var j = i + (data[5 + offset] - 2)
            while(j > i) {
                var msg = ""
                var id = 0
                while(data[i] >= 48 && data[i] <= 57) {
                    id = id * 10 + (data[i++] - 48)
                }
                i++
                while(i < j && data[i].toInt() != 13) {
                    msg += msg + data[i++].toChar()
                }

                taskQ.add(ProjectorTaskItem(ProjectorTask.SERIAL_VALUE, id, msg))

                i += 2
            }
        }
    }

    private fun handleEndOfQueryPacket(data:ByteArray, offset:Int, os: OutputStream) {
        Log.d(TAG, "handleEndOfQueryPacket")

        //val i = data[7 + offset].toInt()
        //if (i == 0 || i == 31) {
        //    //val event = ClearAllEvent(CNXConnection.ALLCLEAR);
        //    //dispatchEvent(event)
        //}
        os.write(msgEndOfQueryResponse(handle))
    }

    private fun handleDataPacket(data: ByteArray, os: OutputStream) {
        //Log.d(TAG, "handleDataPacket")

        var offset = 0
        var extraData = 0

        if(data[6].toInt() == 32)
        {
            extraData = data[7].toInt()
            offset = 3
        }

        if(data[5] > 0)
        {
            when(data[6 + offset].toInt()) {
                0  -> handleDigitalPacket(data, offset)
                1  -> handleAnalogPacket(data, offset)
                20 -> handleAnalogPacket(data, offset)
                21 -> handleSerialPacket1(data, offset, 0)
                18 -> handleSerialPacket2(data, offset, 1)
                2  -> handleSerialPacket3(data, offset, 2)
                3  -> handleEndOfQueryPacket(data, offset, os)
            }
        }
    }
}