package com.wcRnm.projectorController

import android.os.AsyncTask
import java.io.IOException
import java.lang.Exception
import java.net.InetSocketAddress
import java.net.Socket
import java.net.SocketTimeoutException
import java.net.UnknownHostException

enum class ConnectionStatus {
    DISCONNECTED, CONNECTED, CONNECTING, DISCONNECTING
}
typealias StatusCallback = (status: ConnectionStatus) -> Unit
typealias ErrorCallback = (error: String, e: Exception) -> Unit

class ClientCallbacks(val onStatusChange: StatusCallback, val onError: ErrorCallback)

const val DEFAULT_HOST          = "10.0.2.2" // Android emulator IP for development workstation
const val DEFAULT_PORT          = 41794
const val READ_TIMEOUT          = 1000
const val CONNECT_TIMEOUT       = 5000

class Client(private val callbacks: ClientCallbacks, host: String?) : AsyncTask<Void, Void, Void>() {
    private var host                        = DEFAULT_HOST
    private var port                        = DEFAULT_PORT
    private var socket:    Socket           = Socket()
    private val projector: IProjector       = InfocusIN2128HDx()

    var status:    ConnectionStatus = ConnectionStatus.DISCONNECTED
        private set

    init {
        this.host               = host?: DEFAULT_HOST
        this.socket.soTimeout   = READ_TIMEOUT
    }

    fun connect() {
        if (status == ConnectionStatus.DISCONNECTED) {
            this.execute()
        }
    }

    fun disconnect() {
        if (status == ConnectionStatus.CONNECTED) {
            try {
                socket.close()
            } catch (e: IOException) {
                // TODO Auto-generated catch block
                e.printStackTrace()
            }
        }
    }

    override fun doInBackground(vararg params: Void?): Void? {
        try {
            socket.connect(InetSocketAddress(this.host, this.port), CONNECT_TIMEOUT)

            var buffer   = ByteArray(0)
            val inStream = socket.getInputStream()

            this.setStatus(ConnectionStatus.CONNECTED)

            var timerStart = System.currentTimeMillis() - HEARTBEAT_INTERVAL - 1
            while (true) {
                val now = System.currentTimeMillis()
                if (now - timerStart > HEARTBEAT_INTERVAL) {
                    sendMessage(projector.heartbeat)
                    timerStart = System.currentTimeMillis()
                }
                try {
                    val data = inStream.readBytes()
                    buffer += data
                    val len = projector.nextPacketLength(buffer)

                    if (len > 0) {
                        val packet = buffer.take(len).toByteArray()
                        buffer = buffer.drop(len).toByteArray()
                        projector.handlePacket(packet)
                    }
                } catch (e: SocketTimeoutException) {
                    // read timeout
                    continue
                }
            }
        } catch (e: UnknownHostException) {
            this.callbacks.onError("Unknown host", e)
        } catch (e: SocketTimeoutException) {
            // connect timeout
            this.callbacks.onError("Connect timeout", e)
        } catch (e: IOException) {
            e.printStackTrace()
            this.callbacks.onError(e.toString(), e)
        } finally {
            this.setStatus(ConnectionStatus.DISCONNECTING)
            try {
                socket.close()
            } catch (e: IOException) {
            }
        }

        return null
    }

    override fun onPreExecute() {
        this.setStatus(ConnectionStatus.CONNECTING)
    }

    override fun onPostExecute(result: Void?) {
        this.setStatus(ConnectionStatus.DISCONNECTED)
    }

    private fun setStatus(status: ConnectionStatus) {
        this.callbacks.onStatusChange(status)
    }

    private fun sendMessage(msg: ByteArray) {
        socket.getOutputStream().write(msg)
    }

}