package CrestronDLP
{
   public class Base64
   {
      
      private static var _EndOfInput = -1;
      
      private static var _Chars:Array = new Array("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","0","1","2","3","4","5","6","7","8","9","+","/");
      
      private static var _Digits = new Array("0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f");
       
      
      private var _base64Str:String;
      
      private var _base64Count:Number;
      
      public function Base64()
      {
         super();
      }
      
      public static function Encode(param1:String) : String
      {
         var _loc2_:Base64 = new Base64();
         return _loc2_.encodeBase64(param1);
      }
      
      private function setBase64Str(param1:String) : *
      {
         _base64Str = param1;
         _base64Count = 0;
      }
      
      private function readBase64() : Number
      {
         if(!_base64Str)
         {
            return _EndOfInput;
         }
         if(_base64Count >= _base64Str.length)
         {
            return _EndOfInput;
         }
         var _loc1_:Number = _base64Str.charCodeAt(_base64Count) & 255;
         _base64Count++;
         return _loc1_;
      }
      
      private function encodeBase64(param1:String) : *
      {
         setBase64Str(param1);
         var _loc2_:* = "";
         var _loc3_:* = new Array(3);
         var _loc4_:* = 0;
         var _loc5_:* = false;
         while(!_loc5_ && (_loc3_[0] = readBase64()) != _EndOfInput)
         {
            _loc3_[1] = readBase64();
            _loc3_[2] = readBase64();
            _loc2_ = _loc2_ + _Chars[_loc3_[0] >> 2];
            if(_loc3_[1] != _EndOfInput)
            {
               _loc2_ = _loc2_ + _Chars[_loc3_[0] << 4 & 48 | _loc3_[1] >> 4];
               if(_loc3_[2] != _EndOfInput)
               {
                  _loc2_ = _loc2_ + _Chars[_loc3_[1] << 2 & 60 | _loc3_[2] >> 6];
                  _loc2_ = _loc2_ + _Chars[_loc3_[2] & 63];
               }
               else
               {
                  _loc2_ = _loc2_ + _Chars[_loc3_[1] << 2 & 60];
                  _loc2_ = _loc2_ + "=";
                  _loc5_ = true;
               }
            }
            else
            {
               _loc2_ = _loc2_ + _Chars[_loc3_[0] << 4 & 48];
               _loc2_ = _loc2_ + "=";
               _loc2_ = _loc2_ + "=";
               _loc5_ = true;
            }
            _loc4_ = _loc4_ + 4;
            if(_loc4_ >= 76)
            {
               _loc2_ = _loc2_ + "\n";
               _loc4_ = 0;
            }
         }
         return _loc2_;
      }
   }
}
