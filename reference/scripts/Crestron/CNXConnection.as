package Crestron
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class CNXConnection extends Socket
   {
      
      public static const MAX_DIGITAL_JOIN:int = 65535;
      
      public static const MAX_ANALOG_JOIN:int = 65535;
      
      public static const MAX_SEND_STRING:int = 123;
      
      public static const MAX_SLOT:int = 50;
      
      private static const ONE_SECOND:int = 1000;
      
      private static const TIMER_INTERVAL:int = 500;
      
      private static const CONNECT_TIMEOUT_LENGTH = ONE_SECOND * 30;
      
      private static const NO_CONNECT_TIMEOUT = -1;
      
      private static const REPEAT_DIGITAL_NOT_FOUND:int = -1;
      
      public static const ANALOG:String = "analog";
      
      public static const DIGITAL:String = "digital";
      
      public static const SERIAL:String = "serial";
      
      public static const ALLCLEAR:String = "allclear";
      
      public static const CONNECT:String = "cnxconnect";
      
      public static const DISCONNECT:String = "cnxdisconnect";
      
      public static const ERROR:String = "cnxerror";
      
      public static const HEARTBEAT:String = "heartbeat";
       
      
      private var m_iIPID:int = 3;
      
      private var m_iHandle:int = 0;
      
      private var m_sIP:String = null;
      
      private var response:String = "";
      
      private var m_timer:Timer = null;
      
      private var m_heartbeat_interval:int = 0;
      
      private var m_active_heartbeat:int = 0;
      
      private var m_waiting_for_heartbeat_response:Boolean = false;
      
      private var m_missed_heartbeat_response:Boolean = false;
      
      private var m_heartbeat_event_timeout = 0;
      
      private var m_next_heartbeat_event:int = 0;
      
      private var m_repeat_digitals:Array = null;
      
      private var m_connection_supports_repeat_digitals:Boolean = true;
      
      private var m_bConnected:Boolean = false;
      
      private var m_iConnectTimeoutTime:int = -1;
      
      private var m_buffer:Array;
      
      public function CNXConnection(param1:String = null, param2:uint = 41794, param3:int = 3)
      {
         m_buffer = new Array();
         super(param1,param2);
         configureListeners();
         m_sIP = param1;
         m_iIPID = param3;
      }
      
      public function getAddress() : String
      {
         return m_sIP;
      }
      
      public function getIPID() : int
      {
         return m_iIPID;
      }
      
      private function configureListeners() : void
      {
         this.addEventListener(Event.CONNECT,onConnect);
         this.addEventListener(ProgressEvent.SOCKET_DATA,socketDataHandler);
         this.addEventListener(Event.CLOSE,connError);
         this.addEventListener(IOErrorEvent.IO_ERROR,connError);
         this.addEventListener(SecurityErrorEvent.SECURITY_ERROR,connError);
      }
      
      public function cnxConnect(param1:String = null, param2:String = "03", param3:uint = 41794, param4:int = 0) : Boolean
      {
         if(true == this.connected)
         {
            return false;
         }
         if(param4 < 0)
         {
            param4 = 0;
         }
         m_heartbeat_interval = param4 * (ONE_SECOND / TIMER_INTERVAL);
         m_heartbeat_event_timeout = 1000 / TIMER_INTERVAL;
         m_waiting_for_heartbeat_response = false;
         m_missed_heartbeat_response = false;
         m_sIP = param1;
         m_iIPID = parseInt(param2,16);
         if(m_iIPID < 3 || m_iIPID > 255)
         {
            return false;
         }
         this.connect(param1,param3);
         return true;
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         var _loc2_:Date = new Date();
         if(!this.HasCnxConnection() && m_iConnectTimeoutTime != NO_CONNECT_TIMEOUT && m_iConnectTimeoutTime < getTimer())
         {
            cnxDisconnect();
         }
         if(true == this.connected && true == this.HasCnxConnection())
         {
            if(m_heartbeat_interval > 0)
            {
               heartbeatTimer(param1);
            }
            repeatdigitalTimer(param1);
         }
      }
      
      private function heartbeatTimer(param1:TimerEvent) : void
      {
         var _loc2_:HeartbeatEvent = null;
         if(!this.HasCnxConnection())
         {
            return;
         }
         if(m_active_heartbeat <= 0)
         {
            if(m_waiting_for_heartbeat_response == true)
            {
               _loc2_ = new HeartbeatEvent(CNXConnection.HEARTBEAT,true);
               dispatchEvent(_loc2_);
               m_missed_heartbeat_response = true;
            }
            SendHeartbeat();
            m_waiting_for_heartbeat_response = true;
            m_active_heartbeat = m_heartbeat_interval;
         }
         else
         {
            m_active_heartbeat--;
         }
      }
      
      public function cnxDisconnect() : void
      {
         var _loc1_:DisconnectEvent = null;
         if(this.connected)
         {
            this.close();
         }
         if(this.HasCnxConnection() == true)
         {
            _loc1_ = new DisconnectEvent(CNXConnection.DISCONNECT);
            dispatchEvent(_loc1_);
            this.m_bConnected = false;
         }
         enableTimer(false);
      }
      
      public function HasCnxConnection() : Boolean
      {
         return m_bConnected;
      }
      
      private function SendHeartbeat() : void
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_[0] = 13;
         _loc1_[1] = 0;
         _loc1_[2] = 2;
         _loc1_[3] = m_iHandle / 256;
         _loc1_[4] = m_iHandle % 256;
         this.writeBytes(_loc1_);
         this.flush();
      }
      
      private function SendConnectMessage() : void
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_[0] = 1;
         _loc1_[1] = 0;
         _loc1_[2] = 7;
         _loc1_[3] = 0;
         _loc1_[4] = 0;
         _loc1_[5] = 0;
         _loc1_[6] = 0;
         _loc1_[7] = Math.floor(m_iIPID / 256);
         _loc1_[8] = m_iIPID % 256;
         _loc1_[9] = 64;
         this.writeBytes(_loc1_);
         this.flush();
      }
      
      private function SendEndOfQueryResponse() : void
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_[0] = 5;
         _loc1_[1] = 0;
         _loc1_[2] = 5;
         _loc1_[3] = this.m_iHandle / 256;
         _loc1_[4] = this.m_iHandle % 256;
         _loc1_[5] = 2;
         _loc1_[6] = 3;
         _loc1_[7] = 29;
         this.writeBytes(_loc1_);
         this.flush();
      }
      
      private function SendUpdateRequestPacket() : void
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_[0] = 5;
         _loc1_[1] = 0;
         _loc1_[2] = 5;
         _loc1_[3] = this.m_iHandle / 256;
         _loc1_[4] = this.m_iHandle % 256;
         _loc1_[5] = 2;
         _loc1_[6] = 3;
         _loc1_[7] = 30;
         this.writeBytes(_loc1_);
         this.flush();
      }
      
      private function enableTimer(param1:Boolean) : void
      {
         if(m_timer == null)
         {
            if(true == param1)
            {
               m_timer = new Timer(TIMER_INTERVAL);
               m_timer.addEventListener(TimerEvent.TIMER,onTimer);
            }
            else
            {
               return;
            }
         }
         if(false == param1)
         {
            m_timer.stop();
         }
         else if(!m_timer.running)
         {
            m_timer.start();
         }
      }
      
      private function onConnect(param1:Event) : void
      {
         if(m_repeat_digitals != null)
         {
            m_repeat_digitals = null;
         }
         m_repeat_digitals = new Array();
         m_iConnectTimeoutTime = getTimer() + CONNECT_TIMEOUT_LENGTH;
         enableTimer(true);
      }
      
      private function connError(param1:Event) : void
      {
         cnxDisconnect();
      }
      
      public function SendDigital(param1:int, param2:Boolean, param3:int = 0) : void
      {
         if(this.connected == false)
         {
            return;
         }
         var _loc4_:ByteArray = new ByteArray();
         var _loc5_:int = 0;
         if(param3 > 0)
         {
            _loc5_ = 3;
         }
         _loc4_[0] = 5;
         _loc4_[1] = 0;
         _loc4_[2] = 6 + _loc5_;
         _loc4_[3] = Math.floor(m_iHandle / 256);
         _loc4_[4] = m_iHandle % 256;
         _loc4_[5] = 3 + _loc5_;
         if(param3 > 0)
         {
            _loc4_[6] = 32;
            _loc4_[7] = param3;
            _loc4_[8] = 3;
         }
         param1--;
         _loc4_[6 + _loc5_] = 0;
         _loc4_[7 + _loc5_] = param1 % 256;
         if(param2 == false)
         {
            _loc4_[8 + _loc5_] = Math.floor(param1 / 256) | 128;
         }
         else
         {
            _loc4_[8 + _loc5_] = Math.floor(param1 / 256);
         }
         this.writeBytes(_loc4_);
         this.flush();
      }
      
      public function SendAnalog(param1:int, param2:int, param3:int = 0) : Boolean
      {
         var _loc4_:ByteArray = new ByteArray();
         var _loc5_:int = 0;
         if(this.connected || param1 > MAX_ANALOG_JOIN || param1 < 0)
         {
            if(param3 > 0)
            {
               _loc5_ = 3;
            }
            _loc4_[0] = 5;
            _loc4_[1] = 0;
            _loc4_[2] = 8 + _loc5_;
            _loc4_[3] = Math.floor(this.m_iHandle / 256);
            _loc4_[4] = this.m_iHandle % 256;
            _loc4_[5] = 5 + _loc5_;
            if(param3 > 0)
            {
               _loc4_[6] = 32;
               _loc4_[7] = param3;
               _loc4_[8] = 5;
            }
            _loc4_[6 + _loc5_] = 20;
            param1--;
            _loc4_[7 + _loc5_] = Math.floor(param1 / 256);
            _loc4_[8 + _loc5_] = param1 % 256;
            _loc4_[9 + _loc5_] = Math.floor(param2 / 256);
            _loc4_[10 + _loc5_] = param2 % 256;
            this.writeBytes(_loc4_);
            this.flush();
            return true;
         }
         return false;
      }
      
      public function SendSerial(param1:int, param2:String, param3:int = 0) : Boolean
      {
         var _loc7_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:ByteArray = new ByteArray();
         _loc6_.endian = Endian.LITTLE_ENDIAN;
         if(this.connected || param1 > MAX_DIGITAL_JOIN || param1 < 0)
         {
            _loc5_ = param2.length;
            if(param3 > 0)
            {
               _loc4_ = 3;
            }
            if(_loc5_ > MAX_SEND_STRING)
            {
               _loc5_ = MAX_SEND_STRING;
            }
            _loc6_[0] = 5;
            _loc6_[1] = 0;
            _loc6_[2] = _loc5_ + 7 + _loc4_;
            _loc6_[3] = Math.floor(this.m_iHandle / 256);
            _loc6_[4] = this.m_iHandle % 256;
            _loc6_[5] = _loc5_ + 4 + _loc4_;
            if(param3 > 0)
            {
               _loc6_[6] = 32;
               _loc6_[7] = param3;
               _loc6_[8] = _loc5_ + 4;
            }
            _loc6_[6 + _loc4_] = 21;
            param1--;
            _loc6_[7 + _loc4_] = param1 / 256;
            _loc6_[8 + _loc4_] = param1 % 256;
            _loc6_[9 + _loc4_] = 1;
            _loc7_ = 0;
            while(_loc7_ < _loc5_)
            {
               _loc6_[_loc7_ + 10 + _loc4_] = param2.charCodeAt(_loc7_);
               _loc7_++;
            }
            this.writeBytes(_loc6_);
            this.flush();
            if(param2.length > MAX_SEND_STRING)
            {
               param1++;
               param2 = param2.substr(MAX_SEND_STRING);
               SendSerial(param1,param2,param3);
            }
            return true;
         }
         return false;
      }
      
      private function HandleDataPacket(param1:Array) : void
      {
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:ClearAllEvent = null;
         var _loc2_:int = param1[3] * 256 + param1[4];
         var _loc3_:int = param1[1] * 256 + param1[2];
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:Boolean = true;
         var _loc9_:String = "";
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:DigitalEvent = null;
         var _loc14_:AnalogEvent = null;
         var _loc15_:SerialEvent = null;
         if(param1[6] == 32)
         {
            _loc5_ = param1[7];
            _loc4_ = 3;
         }
         if(param1[5] > 0)
         {
            switch(param1[6 + _loc4_])
            {
               case 0:
                  if(param1[5 + _loc4_] != 3)
                  {
                     return;
                  }
                  _loc6_ = param1[8 + _loc4_] * 256 + param1[7 + _loc4_];
                  _loc6_ = _loc6_ & 32767;
                  _loc6_++;
                  _loc7_ = param1[8 + _loc4_];
                  _loc8_ = true;
                  if((_loc7_ & 128) == 128)
                  {
                     _loc8_ = false;
                  }
                  _loc13_ = new DigitalEvent(CNXConnection.DIGITAL,_loc6_,_loc8_);
                  dispatchEvent(_loc13_);
                  break;
               case 1:
               case 20:
                  switch(param1[5 + _loc4_])
                  {
                     case 3:
                        _loc6_ = param1[7 + _loc4_];
                        _loc7_ = param1[8 + _loc4_];
                        break;
                     case 4:
                        _loc6_ = param1[7 + _loc4_];
                        _loc7_ = param1[8 + _loc4_] * 256 + param1[9 + _loc4_];
                        break;
                     case 5:
                        _loc6_ = param1[7 + _loc4_] * 256 + param1[8 + _loc4_];
                        _loc7_ = param1[9 + _loc4_] * 256 + param1[10 + _loc4_];
                  }
                  _loc6_++;
                  _loc14_ = new AnalogEvent(CNXConnection.ANALOG,_loc6_,_loc7_);
                  dispatchEvent(_loc14_);
                  break;
               case 21:
                  _loc9_ = "";
                  _loc6_ = param1[7 + _loc4_] * 256 + param1[8 + _loc4_];
                  _loc6_++;
                  _loc10_ = param1[5 + _loc4_] - 4;
                  _loc11_ = 10 + _loc4_;
                  _loc12_ = 0;
                  while(_loc12_ < _loc10_)
                  {
                     _loc9_ = _loc9_ + String.fromCharCode(param1[_loc11_++]);
                     _loc12_++;
                  }
                  _loc15_ = new SerialEvent(CNXConnection.SERIAL,_loc6_,_loc9_);
                  dispatchEvent(_loc15_);
                  break;
               case 18:
                  _loc6_ = param1[7 + _loc4_];
                  _loc6_++;
                  _loc10_ = param1[5 + _loc4_] - 2;
                  _loc11_ = 8 + _loc4_;
                  _loc12_ = 0;
                  while(_loc12_ < _loc10_)
                  {
                     _loc9_ = _loc9_ + param1[_loc11_++].toString();
                     _loc12_++;
                  }
                  _loc15_ = new SerialEvent(CNXConnection.SERIAL,_loc6_,_loc9_);
                  dispatchEvent(_loc15_);
                  break;
               case 2:
                  if(param1[7 + _loc4_] == 35)
                  {
                     _loc16_ = 8 + _loc4_;
                     _loc17_ = _loc16_ + (param1[5 + _loc4_] - 2);
                     while(_loc17_ > _loc16_)
                     {
                        _loc9_ = "";
                        _loc6_ = 0;
                        while(param1[_loc16_] >= 48 && param1[_loc16_] <= 57)
                        {
                           _loc6_ = _loc6_ * 10 + (param1[_loc16_++] - 48);
                        }
                        _loc16_++;
                        while(_loc16_ < _loc17_ && param1[_loc16_] != 13)
                        {
                           _loc9_ = _loc9_ + String.fromCharCode(param1[_loc16_++]);
                        }
                        _loc15_ = new SerialEvent(CNXConnection.SERIAL,_loc6_,_loc9_);
                        dispatchEvent(_loc15_);
                        _loc16_++;
                        _loc16_++;
                     }
                  }
                  break;
               case 3:
                  switch(param1[7 + _loc4_])
                  {
                     case 0:
                     case 31:
                        _loc18_ = new ClearAllEvent(CNXConnection.ALLCLEAR);
                        dispatchEvent(_loc18_);
                     case 28:
                        SendEndOfQueryResponse();
                     default:
                        SendEndOfQueryResponse();
                  }
                  break;
               case 8:
            }
         }
      }
      
      private function ReadPacket() : Array
      {
         if(m_buffer.length < 3)
         {
            return null;
         }
         var _loc1_:uint = uint(m_buffer[1]);
         var _loc2_:uint = uint(m_buffer[2]);
         var _loc3_:uint = _loc1_ * 256 + _loc2_;
         if(m_buffer.length < _loc3_ + 3)
         {
            return null;
         }
         var _loc4_:Array = m_buffer.splice(0,_loc3_ + 3);
         return _loc4_;
      }
      
      private function socketDataHandler(param1:ProgressEvent) : void
      {
         var _loc4_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:ConnectEvent = null;
         var _loc8_:HeartbeatEvent = null;
         var _loc2_:DisconnectEvent = null;
         var _loc3_:ByteArray = new ByteArray();
         _loc4_ = null;
         while(this.bytesAvailable)
         {
            m_buffer.push(this.readUnsignedByte());
         }
         var _loc5_:ByteArray = new ByteArray();
         while(null != (_loc4_ = ReadPacket()))
         {
            switch(_loc4_[0])
            {
               case 2:
                  if(this.HasCnxConnection() == false)
                  {
                     if(_loc4_.length < 6)
                     {
                        return;
                     }
                     this.m_iHandle = _loc4_[3] * 256 + _loc4_[4];
                     if(_loc4_.length >= 7)
                     {
                        if(1 == (1 & _loc4_[6]))
                        {
                           m_connection_supports_repeat_digitals = true;
                           if(m_heartbeat_interval > 0)
                           {
                              enableTimer(true);
                           }
                        }
                        else
                        {
                           m_connection_supports_repeat_digitals = false;
                        }
                     }
                     else
                     {
                        m_connection_supports_repeat_digitals = false;
                     }
                     SendUpdateRequestPacket();
                     this.m_bConnected = true;
                     _loc7_ = new ConnectEvent(CNXConnection.CONNECT);
                     dispatchEvent(_loc7_);
                  }
                  continue;
               case 3:
                  if(this.connected)
                  {
                     this.close();
                  }
                  if(this.HasCnxConnection() == true)
                  {
                     _loc2_ = new DisconnectEvent(CNXConnection.DISCONNECT);
                     dispatchEvent(_loc2_);
                     this.m_bConnected = false;
                  }
                  continue;
               case 4:
                  if(this.connected)
                  {
                     this.close();
                  }
                  if(this.HasCnxConnection() == true)
                  {
                     _loc2_ = new DisconnectEvent(CNXConnection.DISCONNECT);
                     dispatchEvent(_loc2_);
                     this.m_bConnected = false;
                  }
                  continue;
               case 5:
                  HandleDataPacket(_loc4_);
                  continue;
               case 14:
                  if(true == m_missed_heartbeat_response)
                  {
                     _loc8_ = new HeartbeatEvent(CNXConnection.HEARTBEAT,false);
                     dispatchEvent(_loc8_);
                     m_missed_heartbeat_response = false;
                  }
                  m_waiting_for_heartbeat_response = 0;
                  continue;
               case 15:
                  if(_loc4_[3] == undefined)
                  {
                     return;
                  }
                  _loc6_ = _loc4_[3];
                  if(_loc6_ == 0)
                  {
                     cnxDisconnect();
                  }
                  else if(_loc6_ != 1)
                  {
                     if(_loc6_ == 2 && !HasCnxConnection())
                     {
                        SendConnectMessage();
                     }
                  }
                  continue;
               default:
                  continue;
            }
         }
      }
      
      private function readResponse() : void
      {
         var _loc1_:String = readUTFBytes(bytesAvailable);
         response = response + _loc1_;
      }
      
      public function SendRepeatDigital(param1:int, param2:Boolean, param3:int = 0) : Boolean
      {
         if(!this.connected && !this.HasCnxConnection())
         {
            return false;
         }
         if(param1 > MAX_DIGITAL_JOIN || param1 < 0 || param3 > MAX_SLOT || param3 < 0)
         {
            return false;
         }
         if(false == m_connection_supports_repeat_digitals)
         {
            return false;
         }
         enableTimer(true);
         if(param2 != 0)
         {
            return addRepeatDigital(param1,param3);
         }
         return removeRepeatDigital(param1,param3);
      }
      
      private function getRepeatDigitalIndex(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < m_repeat_digitals.length)
         {
            if(m_repeat_digitals[_loc3_].Join == param1 && m_repeat_digitals[_loc3_].Slot == param2)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return REPEAT_DIGITAL_NOT_FOUND;
      }
      
      private function sendRepeatDigitalPacket(param1:int, param2:int, param3:Boolean) : void
      {
         var _loc4_:ByteArray = new ByteArray();
         var _loc5_:int = 0;
         var _loc6_:int = param1 - 1;
         if(param2 > 0)
         {
            _loc5_ = 3;
         }
         _loc4_[0] = 5;
         _loc4_[1] = 0;
         _loc4_[2] = 6 + _loc5_;
         _loc4_[3] = Math.floor(this.m_iHandle / 256);
         _loc4_[4] = this.m_iHandle % 256;
         _loc4_[5] = 3 + _loc5_;
         if(param2 > 0)
         {
            _loc4_[6] = 32;
            _loc4_[7] = param2;
            _loc4_[8] = 3;
         }
         _loc4_[6 + _loc5_] = 39;
         _loc4_[7 + _loc5_] = _loc6_ % 256;
         if(false == param3)
         {
            _loc4_[8 + _loc5_] = _loc6_ / 256 | 128;
         }
         else
         {
            _loc4_[8 + _loc5_] = _loc6_ / 256;
         }
         this.writeBytes(_loc4_);
         this.flush();
      }
      
      private function addRepeatDigital(param1:int, param2:int) : Boolean
      {
         if(REPEAT_DIGITAL_NOT_FOUND != getRepeatDigitalIndex(param1,param2))
         {
            return false;
         }
         var _loc3_:RepeatDigital = new RepeatDigital(param1,param2);
         m_repeat_digitals.push(_loc3_);
         sendRepeatDigitalPacket(_loc3_.Join,_loc3_.Slot,true);
         return true;
      }
      
      private function removeRepeatDigital(param1:int, param2:int) : Boolean
      {
         var _loc3_:int = getRepeatDigitalIndex(param1,param2);
         sendRepeatDigitalPacket(param1,param2,false);
         if(REPEAT_DIGITAL_NOT_FOUND != _loc3_)
         {
            m_repeat_digitals.splice(_loc3_,1);
            return true;
         }
         return false;
      }
      
      private function sendMultiRepeatingDigitalPacket(param1:ByteArray, param2:int, param3:Array) : void
      {
         if(0 >= param1.length)
         {
            return;
         }
         var _loc4_:ByteArray = new ByteArray();
         var _loc5_:int = 0;
         if(param2 > 0)
         {
            _loc5_ = 3;
         }
         var _loc6_:int = 4 + param1.length;
         _loc4_[0] = 5;
         _loc4_[1] = Math.floor(_loc6_ / 256);
         _loc4_[2] = _loc6_ % 256;
         _loc4_[3] = Math.floor(m_iHandle / 256);
         _loc4_[4] = m_iHandle % 256;
         _loc4_[5] = 1 + _loc5_ + param1.length;
         if(param2 > 0)
         {
            _loc4_[6] = 32;
            _loc4_[7] = param2;
            _loc4_[8] = 1 + param1.length;
         }
         _loc4_[6 + _loc5_] = 39;
         var _loc7_:int = 0;
         _loc7_ = 0;
         while(_loc7_ < param1.length)
         {
            _loc4_[_loc4_.length] = param1[_loc7_];
            _loc7_++;
         }
         this.writeBytes(_loc4_);
         this.flush();
      }
      
      private function repeatdigitalTimer(param1:TimerEvent) : void
      {
         if(m_repeat_digitals.length < 1)
         {
            return;
         }
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < m_repeat_digitals.length)
         {
            if(undefined == _loc2_[m_repeat_digitals[_loc3_].Slot])
            {
               _loc2_[m_repeat_digitals[_loc3_].Slot] = new ByteArray();
            }
            _loc2_[m_repeat_digitals[_loc3_].Slot][_loc2_[m_repeat_digitals[_loc3_].Slot].length] = (m_repeat_digitals[_loc3_].Join - 1) % 256;
            _loc2_[m_repeat_digitals[_loc3_].Slot][_loc2_[m_repeat_digitals[_loc3_].Slot].length] = Math.floor((m_repeat_digitals[_loc3_].Join - 1) / 256);
            _loc3_++;
         }
         _loc2_.map(this.sendMultiRepeatingDigitalPacket);
      }
   }
}
