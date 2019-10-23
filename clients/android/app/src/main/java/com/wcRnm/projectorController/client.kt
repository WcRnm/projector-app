package com.wcRnm.projectorController

import android.os.AsyncTask
import android.widget.Button
import android.widget.TextView
//import java.io.ByteArrayOutputStream
import java.io.IOException
import java.net.Socket
import java.net.UnknownHostException

enum class ConnectionStatus {
    DISCONNECTED, CONNECTED, CONNECTING, DISCONNECTING
}
typealias StatusCallback = (status: ConnectionStatus) -> Unit


class Client : AsyncTask<Void, Void, Void> {
    private var host                        = "10.0.2.2"
    private var port                        = 41794
    private var response                    = ""
    private var cbStatus : StatusCallback
    //private var tvStatus : TextView
    //private var btnConnect: Button

    constructor(host: String, port: Int, cbStatus: StatusCallback /*, tvStatus: TextView, btnConnect: Button */) {
        this.host = host
        this.port = port
        this.cbStatus = cbStatus
        //this.tvStatus = tvStatus
        //this.btnConnect = btnConnect
    }

    override fun doInBackground(vararg params: Void?): Void? {
        var socket: Socket? = null

        try {
            socket = Socket(this.host, this.port)
            //val byteArrayOutputStream = ByteArrayOutputStream(1024)
            //var buffer: Array<Byte> = Array(1024)

            //var bytesRead: Int
            //val inStream = socket.getInputStream()
            val outStream = socket.getOutputStream()

            this.setStatus(ConnectionStatus.CONNECTED)

            outStream.write(1)

            /*
             * notice: inputStream.read() will block if no data return
             */
            //while ((bytesRead = inStream.read(buffer)) != -1) {
                //byteArrayOutputStream.write(buffer, 0, bytesRead);
                //response += byteArrayOutputStream.toString("UTF-8");
            //}

            this.response = "Done"

        } catch (e: UnknownHostException) {
            // TODO Auto-generated catch block
            e.printStackTrace()
            this.response = "UnknownHostException: $e"
        } catch (e: IOException) {
            // TODO Auto-generated catch block
            e.printStackTrace()
            this.response = "IOException: $e"
        } finally {
            this.setStatus(ConnectionStatus.DISCONNECTING)
            if (socket != null) {
                try {
                    socket.close()
                } catch (e: IOException) {
                    // TODO Auto-generated catch block
                    e.printStackTrace()
                }
            }
        }
        return null
    }

    override fun onPreExecute() {
        super.onPreExecute()
        this.setStatus(ConnectionStatus.CONNECTING)
    }

    override fun onPostExecute(result: Void?) {
        super.onPostExecute(result)
        this.setStatus(ConnectionStatus.DISCONNECTED)
    }

    private fun setStatus(status: ConnectionStatus) {
        this.cbStatus(status)
    }

}