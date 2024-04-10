package CrestronDLP
{
   public class DLPSource
   {
       
      
      public var sourceName:String = "";
      
      public var join:uint = 0;
      
      public var index:uint = 0;
      
      public function DLPSource(param1:String, param2:uint, param3:uint = 0)
      {
         super();
         sourceName = param1;
         join = param2;
         index = param3;
      }
      
      public function toString() : String
      {
         return index.toString();
      }
      
      public function getSourceName() : *
      {
         if(sourceName.substr(0,1) == " ")
         {
            return "";
         }
         return sourceName;
      }
      
      public function isHidden() : Boolean
      {
         if(sourceName.substr(0,1) == " ")
         {
            return true;
         }
         return false;
      }
   }
}
