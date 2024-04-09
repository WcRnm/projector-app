package CrestronUI_60K_2_fla
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public dynamic class UserPassword_58 extends MovieClip
   {
       
      
      public var txtLoginTitle:TextField;
      
      public var ExitBttn:SimpleButton;
      
      public var ExitTXT:TextField;
      
      public var lblPassword:TextField;
      
      public var USendTXT:TextField;
      
      public var Usertxt:TextField;
      
      public function UserPassword_58()
      {
         super();
         addFrameScript(0,frame1,1,frame2);
      }
      
      public function exitpage(param1:MouseEvent) : void
      {
         gotoAndPlay(1);
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame2() : *
      {
         stop();
         ExitBttn.addEventListener(MouseEvent.CLICK,exitpage);
         USendTXT.mouseEnabled = false;
         ExitTXT.mouseEnabled = false;
      }
   }
}
