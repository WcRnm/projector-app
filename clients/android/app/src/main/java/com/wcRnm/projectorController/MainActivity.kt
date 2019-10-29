package com.wcRnm.projectorController

import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.os.Handler
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import android.view.Menu
import android.view.MenuItem
import android.widget.TextView
import androidx.preference.PreferenceManager

import kotlinx.android.synthetic.main.activity_main.*
import java.lang.Exception

private val TAG: String = MainActivity::class.java.simpleName

class MainActivity : AppCompatActivity() {

    private var txtStatus  : TextView?          = null
    private var client     : Client?            = null
    private var connStatus : ConnectionStatus   = ConnectionStatus.DISCONNECTED

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d(TAG, "++onCreate")
        setContentView(R.layout.activity_main)
        setSupportActionBar(toolbar)

        this.txtStatus = findViewById(R.id.textview_connectionStatus)

        onStatusChange(ConnectionStatus.DISCONNECTED)
        Log.d(TAG, "--onCreate")
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

    private fun onStatusChange(status: ConnectionStatus) {
        Log.d(TAG, "onStatusChange: $status")
        connStatus = status
        when (status) {
            ConnectionStatus.DISCONNECTED  -> {
                this.setUiText(txtStatus, R.string.status_disconnected)
                this.setUiTextColor(txtStatus, Color.RED)

                Handler().postDelayed(
                    {
                        val prefs = PreferenceManager.getDefaultSharedPreferences(this)
                        var host = prefs.getString("pref_conn_host", DEFAULT_HOST)

                        if (host == "") host = DEFAULT_HOST

                        client = Client(this, ClientCallbacks(::onStatusChange, ::onError, ::onConnectionInfo), host)
                        client?.connect()
                    }, 1000)
            }
            ConnectionStatus.CONNECTED     -> {
                this.setUiText(txtStatus, R.string.status_connected)
                this.setUiTextColor(txtStatus, Color.GREEN)
            }
            ConnectionStatus.CONNECTING    -> {
                this.setUiText(txtStatus, R.string.status_connecting)
                this.setUiTextColor(txtStatus, Color.CYAN)
            }
            ConnectionStatus.DISCONNECTING -> {
                this.setUiText(txtStatus, R.string.status_disconnecting)
                this.setUiTextColor(txtStatus, Color.YELLOW)
            }
        }
    }

    private fun onError(error: String, e: Exception) {
    }

    private fun onConnectionInfo(server: String, client: String) {
        setUiText(findViewById(R.id.textview_projector_addr), server)
        setUiText(findViewById(R.id.textview_client_addr), client)
    }

    private fun setUiText(textView: TextView?, resId: Int) {
        textView?.post(java.lang.Runnable { textView.setText(resId) })
    }
    private fun setUiText(textView: TextView?, text: String) {
        textView?.post(java.lang.Runnable { textView.text = text })
    }

    private fun setUiTextColor(textView: TextView?, color: Int) {
        textView?.post(java.lang.Runnable { textView.setTextColor(color) })
    }
}
