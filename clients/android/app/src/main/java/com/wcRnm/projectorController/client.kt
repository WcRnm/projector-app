package com.wcRnm.projectorController

import android.os.AsyncTask
import android.widget.Button
import android.widget.TextView
//import java.io.ByteArrayOutputStream
import java.io.IOException
import java.net.InetSocketAddress
import java.net.Socket
import java.net.SocketTimeoutException
import java.net.UnknownHostException

enum class ConnectionStatus {
    DISCONNECTED, CONNECTED, CONNECTING, DISCONNECTING
}
typealias StatusCallback = (status: ConnectionStatus) -> Unit

const val DEFAULT_HOST          = "10.0.2.2"
const val DEFAULT_PORT          = 41794
const val CONNECTION_TIMEOUT    = 5000
const val CONNECT_TIMEOUT       = 5000

class Client : AsyncTask<Void, Void, Void> {
    private var host                        = DEFAULT_HOST
    private var port                        = DEFAULT_PORT
    private var cbStatus : StatusCallback
    private var socket:    Socket           = Socket()

    var status:    ConnectionStatus = ConnectionStatus.DISCONNECTED
        private set

    constructor(cbStatus: StatusCallback) {
        this.cbStatus           = cbStatus
        this.socket.soTimeout   = CONNECTION_TIMEOUT
    }

    constructor(host: String, port: Int, cbStatus: StatusCallback) {
        this.host               = host
        this.port               = port
        this.cbStatus           = cbStatus
        this.socket.soTimeout   = CONNECTION_TIMEOUT
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

            //val byteArrayOutputStream = ByteArrayOutputStream(1024)
            //var buffer: Array<Byte> = Array(1024)

            //var bytesRead: Int
            val inStream = socket.getInputStream()
            val outStream = socket.getOutputStream()

            this.setStatus(ConnectionStatus.CONNECTED)

            outStream.write(1)
            inStream.read()

            /*
             * notice: inputStream.read() will block if no data return
             */
            //while ((bytesRead = inStream.read(buffer)) != -1) {
                //byteArrayOutputStream.write(buffer, 0, bytesRead);
                //response += byteArrayOutputStream.toString("UTF-8");
            //}

        } catch (e: UnknownHostException) {
            // TODO Auto-generated catch block
            e.printStackTrace()
        } catch (e: SocketTimeoutException) {
            e.printStackTrace()
        } catch (e: IOException) {
            // TODO Auto-generated catch block
            e.printStackTrace()
        } finally {
            this.setStatus(ConnectionStatus.DISCONNECTING)
            try {
                socket.close()
            } catch (e: IOException) {
                // TODO Auto-generated catch block
                e.printStackTrace()
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
        this.cbStatus(status)
    }

}