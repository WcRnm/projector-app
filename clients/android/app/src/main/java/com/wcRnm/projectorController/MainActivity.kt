package com.wcRnm.projectorController

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.widget.Button
import android.widget.TextView

import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    private val host                            = DEFAULT_HOST
    private val port                            = DEFAULT_PORT
    private var btnConnect : Button?            = null
    private var txtStatus  : TextView?          = null
    private var client     : Client?            = null
    private var connStatus : ConnectionStatus   = ConnectionStatus.DISCONNECTED

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        setSupportActionBar(toolbar)

        this.btnConnect = findViewById(R.id.button_connect)
        this.txtStatus = findViewById(R.id.textview_connectionStatus)
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        // Inflate the menu; this adds items to the action bar if it is present.
        menuInflater.inflate(R.menu.menu_main, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        return when (item.itemId) {
            R.id.action_settings -> true
            else -> super.onOptionsItemSelected(item)
        }
    }

    fun onConnectButton(view: View) {
        when(connStatus) {
            ConnectionStatus.CONNECTED     -> this.client?.disconnect()
            ConnectionStatus.DISCONNECTED  -> {
                client = Client(host, port, ::onConnectionStatus)
                client?.connect()
            }
            ConnectionStatus.CONNECTING    -> {}
            ConnectionStatus.DISCONNECTING -> {}
        }
    }

    private fun onConnectionStatus(status: ConnectionStatus) {
        connStatus = status
        when (status) {
            ConnectionStatus.DISCONNECTED  -> {
                this.setUiText(this.txtStatus, R.string.status_disconnected)
                this.setUiText(btnConnect, R.string.btn_connect)
                this.enableUiItem(btnConnect, true)
            }
            ConnectionStatus.CONNECTED     -> {
                this.setUiText(this.txtStatus, R.string.status_connected)
                this.setUiText(btnConnect, R.string.btn_disconnect)
                this.enableUiItem(btnConnect, true)
            }
            ConnectionStatus.CONNECTING    -> {
                this.setUiText(this.txtStatus, R.string.status_connecting)
                this.setUiText(btnConnect, R.string.btn_disconnect)
                this.enableUiItem(btnConnect, false)
            }
            ConnectionStatus.DISCONNECTING -> {
                this.setUiText(this.txtStatus, R.string.status_disconnecting)
                this.setUiText(btnConnect, R.string.btn_disconnect)
                this.enableUiItem(btnConnect, false)
            }
        }
    }

    private fun setUiText(textView: TextView?, resId: Int) {
        textView?.post(java.lang.Runnable { textView.setText(resId) })
    }
    private fun enableUiItem(button: Button?, enable: Boolean) {
        button?.post(java.lang.Runnable { button.setEnabled(enable) })
    }
}
