package Crestron
{
   import flash.events.Event;
   
   public class AnalogEvent extends Event
   {
       
      
      public var Join:int = 0;
      
      public var Value:int = 0;
      
      public function AnalogEvent(param1:String, param2:int, param3:int)
      {
         super(param1);
         Join = param2;
         Value = param3;
      }
      
      override public function clone() : Event
      {
         return new AnalogEvent(type,Join,Value);
      }
   }
}
