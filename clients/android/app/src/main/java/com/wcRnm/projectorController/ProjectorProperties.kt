package com.wcRnm.projectorController

import android.util.SparseArray
import android.util.SparseBooleanArray
import android.util.SparseIntArray

class ProjectorProperties {

    enum class StringProp(val id: Int) {
        ERROR(2),               // "0:No Error"

        ID_5(5),               // "39"

        ID_4745(4745),         // "Power Off."
        ID_4746(4746),         // "Power Off."
        ID_4747(4747),         // "Normal Mode"
        ID_4748(4748),         // "1000"

        ID_4754(4754),         // "Source"

        NETWORK_IP_ADDRESS(4784),   // "10.4.3.60"
        NETWORK_NETMASK(4785),      // "255.255.252.0"
        ID_4786(4786),              // "10.4.0.1"
        ID_4787(4787),              // "10.4.0.1"
        NETWORK_MAC_ADDRESS(4788),  // 00:e0:47:26:2a:7a
        ID_4789(4789),              // "10.0.167.101"
        ID_4790(4790),              // "5"
        NETWORK_PORT(4791),         // "41797"

        ID_4794(4794),      // PROJECTOR
        ID_4795(4795),      // GROUP
        ID_4796(4796),      // Sanctuary
        ID_4797(4797),      // Rear Table
        RESOLUTION(4798),   // 1920 x 1080
        ID_4799(4799),      // Bright
        SW_VERSION(4800),   // V04.01.64

        SOURCE_1(4814),      // Computer1
        SOURCE_2(4815),      // Computer2
        SOURCE_3(4816),      // HDMI
        SOURCE_4(4817),      // Composite
        SOURCE_5(4818),      // S-Video
        SOURCE_6(4819)       // Lightcast
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

    private val bMap = SparseBooleanArray(64)
    private val iMap = SparseIntArray(64)
    private val sMap = SparseArray<String>(64)

    // String Values
    var error:          String  = ""
        get() = sMap[StringProp.ERROR.id]
        private set
    var text5:          String = ""
        get() = sMap[StringProp.ID_5.id]
        private set

    var text4745:       String = ""
        get() = sMap[StringProp.ID_4745.id]
        private set
    var text4746:       String = ""
        get() = sMap[StringProp.ID_4746.id]
        private set
    var text4747:       String = ""
        get() = sMap[StringProp.ID_4747.id]
        private set
    var text4748:       String = ""
        get() = sMap[StringProp.ID_4748.id]
        private set

    var text4754:       String = ""
        get() = sMap[StringProp.ID_4754.id]
        private set

    var netIpAddress:   String  = ""
        get() = sMap[StringProp.NETWORK_IP_ADDRESS.id]
        private set
    var netNetmask:     String  = ""
        get() = sMap[StringProp.NETWORK_NETMASK.id]
        private set
    var text4786:       String = ""
        get() = sMap[StringProp.ID_4786.id]
        private set
    var text4787:       String = ""
        get() = sMap[StringProp.ID_4787.id]
        private set
    var netMacAddress:  String  = ""
        get() = sMap[StringProp.NETWORK_MAC_ADDRESS.id]
        private set
    var text4789:       String = ""
        get() = sMap[StringProp.ID_4789.id]
        private set
    var text4790:       String = ""
        get() = sMap[StringProp.ID_4790.id]
        private set
    var netPort:       String = ""
        get() = sMap[StringProp.NETWORK_PORT.id]
        private set

    var text4794:       String = ""
        get() = sMap[StringProp.ID_4794.id]
        private set
    var text4795:       String = ""
        get() = sMap[StringProp.ID_4795.id]
        private set
    var text4796:       String = ""
        get() = sMap[StringProp.ID_4796.id]
        private set
    var text4797:       String = ""
        get() = sMap[StringProp.ID_4797.id]
        private set
    var resolution:     String = ""
        get() = sMap[StringProp.RESOLUTION.id]
        private set
    var text4799:       String = ""
        get() = sMap[StringProp.ID_4799.id]
        private set
    var sw_version:     String  = ""
        get() = sMap[StringProp.SW_VERSION.id]
        private set

    var source1: String = ""
        get() = sMap[StringProp.SOURCE_1.id]
        private set
    var source2: String = ""
        get() = sMap[StringProp.SOURCE_2.id]
        private set
    var source3: String = ""
        get() = sMap[StringProp.SOURCE_3.id]
        private set
    var source4: String = ""
        get() = sMap[StringProp.SOURCE_4.id]
        private set
    var source5: String = ""
        get() = sMap[StringProp.SOURCE_5.id]
        private set
    var source6: String = ""
        get() = sMap[StringProp.SOURCE_6.id]
        private set

    // Boolean Values
    var bool1:          Boolean = false
        get() = bMap[BoolProp.ID_1.id]
        private set
    var bool5:          Boolean = false
        get() = bMap[BoolProp.ID_5.id]
        private set
    var bool6:          Boolean = false
        get() = bMap[BoolProp.ID_6.id]
        private set
    var bool22:         Boolean = false
        get() = bMap[BoolProp.ID_22.id]
        private set
    var bool4847:         Boolean = false
        get() = bMap[BoolProp.ID_4847.id]
        private set
    var bool4848:         Boolean = false
        get() = bMap[BoolProp.ID_4848.id]
        private set
    var bool4849:         Boolean = false
        get() = bMap[BoolProp.ID_4849.id]
        private set
    var bool4850:         Boolean = false
        get() = bMap[BoolProp.ID_4850.id]
        private set
    var bool4861:         Boolean = false
        get() = bMap[BoolProp.ID_4861.id]
        private set
    var bool4862:         Boolean = false
        get() = bMap[BoolProp.ID_4862.id]
        private set
    var bool5115:         Boolean = false
        get() = bMap[BoolProp.ID_5115.id]
        private set
    var bool5210:         Boolean = false
        get() = bMap[BoolProp.ID_5210.id]
        private set
    var bool5211:         Boolean = false
        get() = bMap[BoolProp.ID_5211.id]
        private set
    var bool5213:         Boolean = false
        get() = bMap[BoolProp.ID_5213.id]
        private set
    var bool5217:         Boolean = false
        get() = bMap[BoolProp.ID_5217.id]
        private set

    // Analog Values
    var analog257:      Int = 0
        get() = iMap[IntProp.ID_257.id]
        private set
    var analog5000:      Int = 0
        get() = iMap[IntProp.ID_5000.id]
        private set
    var analog5001:      Int = 0
        get() = iMap[IntProp.ID_5001.id]
        private set
    var analog5002:      Int = 0
        get() = iMap[IntProp.ID_5002.id]
        private set
    var analog5003:      Int = 0
        get() = iMap[IntProp.ID_5003.id]
        private set
    var analog5011:      Int = 0
        get() = iMap[IntProp.ID_5011.id]
        private set
    var analog5012:      Int = 0
        get() = iMap[IntProp.ID_5012.id]
        private set

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
    }
}