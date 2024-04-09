package Crestron
{
   import flash.events.Event;
   
   public class DigitalEvent extends Event
   {
       
      
      public var Join:int = 0;
      
      public var Value:Boolean = false;
      
      public function DigitalEvent(param1:String, param2:int, param3:Boolean)
      {
         super(param1);
         Join = param2;
         Value = param3;
      }
      
      override public function clone() : Event
      {
         return new DigitalEvent(type,Join,Value);
      }
   }
}
