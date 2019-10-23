package com.wcRnm.projectorController

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import androidx.appcompat.app.AppCompatActivity
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.widget.TextView

import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    private val host                            = DEFAULT_HOST
    private val port                            = DEFAULT_PORT
    private var txtStatus  : TextView?          = null
    private var client     : Client?            = null
    private var connStatus : ConnectionStatus   = ConnectionStatus.DISCONNECTED

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        setSupportActionBar(toolbar)

        this.txtStatus = findViewById(R.id.textview_connectionStatus)

        onConnectionStatus(ConnectionStatus.DISCONNECTED)
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        // Inflate the menu; this adds items to the action bar if it is present.
        menuInflater.inflate(R.menu.menu_main, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean = when (item.itemId) {
        R.id.action_settings    -> {
            startActivity(Intent(this, SettingsActivity::class.java))
            true
        }
        else                    -> {
            super.onOptionsItemSelected(item)
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

                Handler().postDelayed(
                    {
                        client = Client(host, port, ::onConnectionStatus)
                        client?.connect()
                    }, 1000)
            }
            ConnectionStatus.CONNECTED     -> {
                this.setUiText(this.txtStatus, R.string.status_connected)
            }
            ConnectionStatus.CONNECTING    -> {
                this.setUiText(this.txtStatus, R.string.status_connecting)
            }
            ConnectionStatus.DISCONNECTING -> {
                this.setUiText(this.txtStatus, R.string.status_disconnecting)
            }
        }
    }

    private fun setUiText(textView: TextView?, resId: Int) {
        textView?.post(java.lang.Runnable { textView.setText(resId) })
    }
}
