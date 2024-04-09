package Crestron
{
   import flash.events.Event;
   
   public class HeartbeatEvent extends Event
   {
       
      
      public var Missed:Boolean = true;
      
      public function HeartbeatEvent(param1:String, param2:Boolean)
      {
         super(param1);
         Missed = param2;
      }
      
      override public function clone() : Event
      {
         return new HeartbeatEvent(type,Missed);
      }
   }
}
