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

    private val addr = "10.0.2.2"
    private val port = 41794
    private var btnConnect : Button? = null
    private var txtStatus : TextView? = null

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

    fun onConnect(view: View) {
        val client = Client(this.addr, this.port, ::onConnectionStatus)
        client.execute()
    }

    private fun onConnectionStatus(status: ConnectionStatus) {
        //var tid = R
        val connected = status == ConnectionStatus.DISCONNECTED

        this.setUiText(this.txtStatus, 0)
        when (status) {
            ConnectionStatus.DISCONNECTED  -> this.txtStatus?.setText(R.string.status_disconnected)
            ConnectionStatus.CONNECTED     -> this.txtStatus?.setText(R.string.status_connected)
            ConnectionStatus.CONNECTING    -> this.txtStatus?.setText(R.string.status_connecting)
            ConnectionStatus.DISCONNECTING -> this.txtStatus?.setText(R.string.status_disconnecting)
        }
        this.btnConnect?.setEnabled(status == ConnectionStatus.DISCONNECTED)
    }

    private fun setUiText(textView: TextView?, stringId: Int) {
        textView?.post(java.lang.Runnable { textView?.setText(stringId) })
    }
}
