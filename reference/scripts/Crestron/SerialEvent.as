package Crestron
{
   import flash.events.Event;
   
   public class SerialEvent extends Event
   {
       
      
      public var Join:int = 0;
      
      public var Value:String = "";
      
      public function SerialEvent(param1:String, param2:int, param3:String)
      {
         super(param1);
         Join = param2;
         Value = param3;
      }
      
      override public function clone() : Event
      {
         return new SerialEvent(type,Join,Value);
      }
   }
}
