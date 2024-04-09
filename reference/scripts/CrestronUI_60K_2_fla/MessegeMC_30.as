package CrestronUI_60K_2_fla
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public dynamic class MessegeMC_30 extends MovieClip
   {
       
      
      public var WriteBttn:SimpleButton;
      
      public var objs:Array;
      
      public function MessegeMC_30()
      {
         super();
         addFrameScript(0,frame1,1,frame2,23,frame24);
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame2() : *
      {
         stop();
         objs = new Array();
         objs.push(WriteBttn);
         MovieClip(parent.parent).ThemeButtonObjects(objs,MovieClip(parent.parent).projconfig.ui_color);
         WriteBttn.addEventListener(MouseEvent.CLICK,MovieClip(parent).readMsg);
      }
      
      function frame24() : *
      {
         gotoAndPlay("start");
      }
   }
}
