package CrestronDLP
{
   public class ExtendedCommand
   {
      
      public static const CMD_EXT_MOMENTARY = 0;
      
      public static const CMD_EXT_TOGGLE = 1;
      
      public static const CMD_EXT_RAMP = 2;
      
      public static const CMD_EXT_ZOOM = 3;
      
      public static const TXT_EXT_MOMENTARY = "momentary";
      
      public static const TXT_EXT_TOGGLE = "toggle";
      
      public static const TXT_EXT_RAMP = "ramp";
      
      public static const TXT_EXT_ZOOM = "zoom";
      
      public static const JOIN_MOMENTARY = 0;
      
      public static const JOIN_STATE_0 = 0;
      
      public static const JOIN_STATE_1 = 1;
      
      public static const JOIN_RAMPUP = 0;
      
      public static const JOIN_RAMPDOWN = 1;
      
      public static const JOIN_RAMPED = 2;
      
      public static const JOIN_ZOOMIN = 0;
      
      public static const JOIN_ZOOMOUT = 1;
      
      public static const JOIN_PAN_LEFT = 2;
      
      public static const JOIN_PAN_UP = 3;
      
      public static const JOIN_PAN_RIGHT = 4;
      
      public static const JOIN_PAN_DOWN = 5;
      
      public static const JOIN_FBACK_DIGITAL = 0;
       
      
      public var cmdname:String = "";
      
      public var cmdjoin:Array;
      
      public var cmdfback:Array;
      
      public var cmdidx:uint = 0;
      
      public var cmdtype:uint = 0;
      
      public var valid:Boolean = false;
      
      public var disable_for_sources:Array;
      
      public function ExtendedCommand(param1:XML)
      {
         cmdjoin = new Array();
         cmdfback = new Array();
         disable_for_sources = new Array();
         super();
         cmdname = param1.@name;
         cmdidx = param1.@index;
         var _loc2_:String = TXT_EXT_MOMENTARY;
         if(0 < param1.@cmdtype.length())
         {
            _loc2_ = param1.@cmdtype;
         }
         switch(_loc2_.toLowerCase())
         {
            case TXT_EXT_MOMENTARY:
               cmdtype = CMD_EXT_MOMENTARY;
               cmdjoin[JOIN_MOMENTARY] = param1.@join;
               break;
            case TXT_EXT_TOGGLE:
               cmdtype = CMD_EXT_TOGGLE;
               cmdjoin[JOIN_STATE_0] = param1.@join0;
               cmdjoin[JOIN_STATE_1] = param1.@join1;
               break;
            case TXT_EXT_RAMP:
               cmdtype = CMD_EXT_RAMP;
               cmdjoin[JOIN_RAMPUP] = param1.@rampup;
               cmdjoin[JOIN_RAMPDOWN] = param1.@rampdown;
               cmdjoin[JOIN_RAMPED] = param1.@ramped;
               break;
            case TXT_EXT_ZOOM:
               cmdtype = CMD_EXT_ZOOM;
               cmdjoin[JOIN_ZOOMIN] = param1.@zoomin;
               cmdjoin[JOIN_ZOOMOUT] = param1.@zoomout;
               cmdjoin[JOIN_PAN_LEFT] = param1.@panleft;
               cmdjoin[JOIN_PAN_RIGHT] = param1.@panright;
               cmdjoin[JOIN_PAN_UP] = param1.@panup;
               cmdjoin[JOIN_PAN_DOWN] = param1.@pandown;
         }
         if(0 < param1.@digfb.length())
         {
            cmdfback[JOIN_FBACK_DIGITAL] = param1.@digfb;
         }
         if(0 < param1.@sd.length())
         {
            disable_for_sources = param1.@sd.split(",");
         }
      }
      
      public function getFeedbackJoin(param1:uint) : uint
      {
         if(cmdfback[param1] != undefined)
         {
            return cmdfback[param1];
         }
         return 0;
      }
      
      public function toString() : String
      {
         return cmdidx.toString();
      }
   }
}
