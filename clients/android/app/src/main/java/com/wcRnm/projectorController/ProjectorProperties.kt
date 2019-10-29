package com.wcRnm.projectorController

import android.content.SharedPreferences
import android.util.Log
import android.util.SparseArray
import android.util.SparseBooleanArray
import android.util.SparseIntArray

private const val TAG: String = "ProjectorProps"

enum class StringProp(val id: Int, val key: String) {
    ERROR  (2, "pref_error"),               // "0:No Error"

    ID_5   (5, ""),               // "39"

    ID_4745(4745, ""),         // "Power Off."
    ID_4746(4746, ""),         // "Power Off."
    ID_4747(4747, ""),         // "Normal Mode"
    ID_4748(4748, ""),         // "1000"

    ID_4754(4754, ""),         // "Source"

    NETWORK_IP_ADDRESS  (4784, ""), // "10.4.3.60"
    NETWORK_NETMASK     (4785, ""), // "255.255.252.0"
    ID_4786             (4786, ""), // "10.4.0.1"
    ID_4787             (4787, ""), // "10.4.0.1"
    NETWORK_MAC_ADDRESS (4788, ""), // 00:e0:47:26:2a:7a
    ID_4789             (4789, ""), // "10.0.167.101"
    ID_4790             (4790, ""), // "5"
    NETWORK_PORT        (4791, ""), // "41797"

    ID_4794   (4794, ""),   // PROJECTOR
    ID_4795   (4795, ""),   // GROUP
    ID_4796   (4796, ""),   // Sanctuary
    ID_4797   (4797, ""),   // Rear Table
    RESOLUTION(4798, "pref_resolution"),   // 1920 x 1080
    ID_4799   (4799, ""),   // Bright
    SW_VERSION(4800, "pref_version"),   // V04.01.64

    SOURCE_1(4814, ""),      // Computer1
    SOURCE_2(4815, ""),      // Computer2
    SOURCE_3(4816, ""),      // HDMI
    SOURCE_4(4817, ""),      // Composite
    SOURCE_5(4818, ""),      // S-Video
    SOURCE_6(4819, "")       // Lightcast
}

enum class BoolProp(val id: Int) {
    ID_1(1),
    ID_5(5),
    ID_6(6),
    ID_22(22),

    ID_4847(4847),
    ID_4848(4848),
    ID_4849(4849),
    ID_4850(4850),

    ID_4861(4861),
    ID_4862(4862),

    ID_5115(5115),
    ID_5210(5210),
    ID_5211(5211),
    ID_5213(5213),
    ID_5217(5217),
}

enum class IntProp(val id: Int) {
    ID_257(257),

    ID_5000(5000),
    ID_5001(5001),
    ID_5002(5002),
    ID_5003(5003),

    ID_5011(5011),
    ID_5012(5012),
}

class ProjectorProperties(val prefs: SharedPreferences) {

    private val editor = prefs.edit()

    private val bMap = SparseBooleanArray(64)
    private val iMap = SparseIntArray(64)
    private val sMap = SparseArray<String>(64)

    init {
        reset()
    }

    fun reset() {
        sMap.clear()
        iMap.clear()
        bMap.clear()

        for (p in StringProp.values())
            sMap.put(p.id, "")
        for (p in BoolProp.values())
            bMap.put(p.id, false)
        for (p in IntProp.values())
            iMap.put(p.id, 0)
    }

    fun set(id: Int, b: Boolean) {
        bMap.put(id, b)
    }

    fun set(id: Int, i: Int) {
        iMap.put(id, i)
    }

    fun set(id: Int, s: String) {
        sMap.put(id, s)

        when (id) {
            StringProp.ERROR.id      -> setProperty(StringProp.ERROR, s)
            StringProp.SW_VERSION.id -> setProperty(StringProp.SW_VERSION, s)
            StringProp.RESOLUTION.id -> setProperty(StringProp.RESOLUTION, s)
        }
    }

    private fun setProperty(p: StringProp, s: String) {
        //editor.
        //val pm = PreferenceManager.findPreference()
        editor.putString(p.key, s)
        editor.apply()

        Log.d(TAG, "setProperty($p, ${prefs.getString(p.key, "not found")})")
        //val text = prefs.getString(p.key, "not found")
    }
}