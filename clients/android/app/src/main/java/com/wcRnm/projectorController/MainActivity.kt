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
    private var mRunning                        = true

    private var firstCreate = true

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d(TAG, "++onCreate")
        setContentView(R.layout.activity_main)
        setSupportActionBar(toolbar)

        this.txtStatus = findViewById(R.id.textview_connectionStatus)

        Log.d(TAG, "--onCreate")
    }

    override fun onDestroy() {
        super.onDestroy()
        client?.disconnect()
        client = null
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

    override fun onPause() {
        super.onPause()
        Log.d(TAG, "++onPause")
        mRunning = false
        stopConnection()
        Log.d(TAG, "--onPause")
    }

    override fun onResume() {
        super.onResume()
        Log.d(TAG, "++onResume")
        mRunning = true
        startConnection()
        Log.d(TAG, "--onResume")
    }

    override fun onRestart() {
        super.onRestart()
        Log.d(TAG, "++onRestart")
        Log.d(TAG, "--onRestart")
    }

    private fun startConnection() {
        Handler().postDelayed(
            {
                val prefs = PreferenceManager.getDefaultSharedPreferences(this)
                var host = prefs.getString("pref_conn_host", DEFAULT_HOST)

                if (host == "") host = DEFAULT_HOST

                client = Client(ClientCallbacks(::onStatusChange, ::onError, ::onConnectionInfo, ::onPropertyChange), host)
                client?.connect()
            }, 1000)
    }

    private fun stopConnection() {
        client?.disconnect()
    }

    private fun onStatusChange(status: ConnectionStatus) {
        if (connStatus != status) {
            Log.d(TAG, "onStatusChange: $status")

            connStatus = status

            when (status) {
                ConnectionStatus.DISCONNECTED -> {
                    this.setUiText(txtStatus, R.string.status_disconnected)
                    this.setUiTextColor(txtStatus, Color.RED)

                    // auto-reconnect
                    if (mRunning)
                        startConnection()
                }
                ConnectionStatus.CONNECTED -> {
                    this.setUiText(txtStatus, R.string.status_connected)
                    this.setUiTextColor(txtStatus, Color.GREEN)
                }
                ConnectionStatus.CONNECTING -> {
                    this.setUiText(txtStatus, R.string.status_connecting)
                    this.setUiTextColor(txtStatus, Color.CYAN)
                }
                ConnectionStatus.DISCONNECTING -> {
                    this.setUiText(txtStatus, R.string.status_disconnecting)
                    this.setUiTextColor(txtStatus, Color.YELLOW)
                }
            }
        }
    }

    private fun onError(error: String, e: Exception) {
    }

    private fun onConnectionInfo(server: String, client: String) {
        setUiText(findViewById<TextView>(R.id.textview_projector_addr), server)
        setUiText(findViewById<TextView>(R.id.textview_client_addr), client)
    }

    private fun onPropertyChange(sv: StringVal?, iv: IntVal?, bv: BoolVal?) {
        if (sv != null) {
            val tvId:Int = when (sv.prop) {
                StringProp.ERROR                -> R.id.textview_projector_error
                StringProp.ID_5                 -> R.id.textview_unknown_text_5
                StringProp.ID_4745              -> R.id.textview_unknown_text_4745
                StringProp.ID_4746              -> R.id.textview_unknown_text_4746
                StringProp.ID_4747              -> R.id.textview_unknown_text_4747
                StringProp.ID_4748              -> R.id.textview_unknown_text_4748
                StringProp.ID_4754              -> 0
                StringProp.NETWORK_IP_ADDRESS   -> 0
                StringProp.NETWORK_NETMASK      -> 0
                StringProp.ID_4786              -> 0
                StringProp.ID_4787              -> 0
                StringProp.NETWORK_MAC_ADDRESS  -> R.id.textview_projector_mac
                StringProp.ID_4789              -> 0
                StringProp.ID_4790              -> R.id.textview_unknown_text_4790
                StringProp.NETWORK_PORT         -> 0
                StringProp.ID_4794              -> R.id.textview_unknown_text_4794
                StringProp.ID_4795              -> R.id.textview_unknown_text_4795
                StringProp.ID_4796              -> R.id.textview_unknown_text_4796
                StringProp.ID_4797              -> R.id.textview_unknown_text_4797
                StringProp.RESOLUTION           -> R.id.textview_projector_resolution
                StringProp.ID_4799              -> R.id.textview_unknown_text_4799
                StringProp.SW_VERSION           -> R.id.textview_projector_firmware
                else                            -> 0
            }
            if (tvId > 0)
                setUiText(tvId, sv.value)
        }
        if (iv != null) {
            val tvId:Int = when (iv.prop) {
                IntProp.ID_257  -> R.id.textview_analog_257
                IntProp.ID_5000 -> R.id.textview_analog_5000
                IntProp.ID_5001 -> R.id.textview_analog_5001
                IntProp.ID_5002 -> R.id.textview_analog_5002
                IntProp.ID_5003 -> R.id.textview_analog_5003
                IntProp.ID_5011 -> R.id.textview_analog_5011
                IntProp.ID_5012 -> R.id.textview_analog_5012
            }
            if (tvId > 0)
                setUiText(tvId, iv.value.toString())
        }
        if (bv != null) {
            val tvId:Int = when (bv.prop) {
                BoolProp.ID_1    -> 0
                BoolProp.ID_5    -> 0
                BoolProp.ID_6    -> 0
                BoolProp.ID_22   -> 0
                BoolProp.ID_4847 -> 0
                BoolProp.ID_4848 -> 0
                BoolProp.ID_4849 -> 0
                BoolProp.ID_4850 -> 0
                BoolProp.ID_4861 -> 0
                BoolProp.ID_4862 -> 0
                BoolProp.ID_5115 -> 0
                BoolProp.ID_5210 -> 0
                BoolProp.ID_5211 -> 0
                BoolProp.ID_5213 -> 0
                BoolProp.ID_5217 -> 0
            }
            if (tvId > 0)
                setUiText(tvId, bv.value.toString())
        }
    }

    private fun setUiText(tvId: Int, text: String) {
        val textView = findViewById<TextView>(tvId)
        textView?.post(java.lang.Runnable { textView.text = text })
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
