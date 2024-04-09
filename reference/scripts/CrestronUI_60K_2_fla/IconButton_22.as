package CrestronUI_60K_2_fla
{
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.net.URLRequest;
   
   public dynamic class IconButton_22 extends MovieClip
   {
       
      
      public var btn:SimpleButton;
      
      public function IconButton_22()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function setIconURL(param1:String) : *
      {
         var _loc2_:Loader = new Loader();
         var _loc3_:URLRequest = new URLRequest(param1);
         _loc2_.load(_loc3_);
         addChild(_loc2_);
         _loc2_.mouseEnabled = false;
      }
      
      function frame1() : *
      {
      }
   }
}
