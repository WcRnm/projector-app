package com.wcRnm.projectorController

import android.os.AsyncTask
import android.util.Log
import java.io.IOException
import java.lang.Exception
import java.net.InetSocketAddress
import java.net.Socket
import java.net.SocketTimeoutException
import java.net.UnknownHostException

private val TAG: String = Client::class.java.simpleName

enum class ConnectionStatus {
    DISCONNECTED, CONNECTED, CONNECTING, DISCONNECTING
}
typealias StatusCallback = (status: ConnectionStatus) -> Unit
typealias ErrorCallback = (error: String, e: Exception) -> Unit
typealias ConnectionCallback = (server: String, client: String) -> Unit

class ClientCallbacks(val onStatusChange: StatusCallback, val onError: ErrorCallback, val onConnectionInfo: ConnectionCallback, val onPropertyChange: OnPropertyChange)

const val DEFAULT_HOST          = "10.0.2.2" // Android emulator IP for development workstation
const val DEFAULT_PORT          = 41794
const val READ_TIMEOUT          = 1000
const val CONNECT_TIMEOUT       = 5000

class Client(private val callbacks: ClientCallbacks, host: String?) : AsyncTask<Void, Void, Void>() {
    private var host                        = DEFAULT_HOST
    private var port                        = DEFAULT_PORT
    private var socket:    Socket           = Socket()
    private val projector: IProjector       = InfocusIN2128HDx(ProjectorCallbacks(callbacks.onPropertyChange))

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
        //if (status == ConnectionStatus.CONNECTED) {
            try {
                socket.close()
            } catch (e: IOException) {
                // TODO Auto-generated catch block
                e.printStackTrace()
            }
        //}
    }

    override fun doInBackground(vararg params: Void?): Void? {
        try {
            socket.connect(InetSocketAddress(this.host, this.port), CONNECT_TIMEOUT)

            callbacks.onConnectionInfo(socket.inetAddress.toString(), socket.localAddress.toString())

            val inStream = socket.getInputStream()
            val outStream = socket.getOutputStream()

            val buffer = ByteArray(1024)

            this.setStatus(ConnectionStatus.CONNECTED)

            while (!isCancelled) {
                projector.idleTasks(outStream)

                try {
                    val n = inStream.read(buffer)
                    if (n == -1)
                        break
                    projector.handleData(buffer, n, outStream)
                } catch (e: SocketTimeoutException) {
                    // Log.d(TAG, "read timeout")
                    // read timeout
                    continue
                }
            }
        } catch (e: UnknownHostException) {
            this.callbacks.onError("Unknown host", e)
        } catch (e: SocketTimeoutException) {
            this.callbacks.onError("Connect timeout", e)
        } catch (e: java.net.ConnectException) {
            this.callbacks.onError("Connect exception", e)
        } catch (e: IOException) {
            e.printStackTrace()
            this.callbacks.onError(e.toString(), e)
        } catch (e: DisconnectException) {
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
}