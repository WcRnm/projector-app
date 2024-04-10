package CrestronUI_60K_2_fla
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public dynamic class SendMC_43 extends MovieClip
   {
       
      
      public var send_txt:TextField;
      
      public var WriteBttn:SimpleButton;
      
      public var SendBttn:SimpleButton;
      
      public var sendtxt:String;
      
      public var objs:Array;
      
      public var objs2:Array;
      
      public function SendMC_43()
      {
         super();
         addFrameScript(0,frame1,1,frame2);
      }
      
      function frame1() : *
      {
         stop();
         sendtxt = MovieClip(parent.parent).getDefaultXMLText("HelpDesk.lblSend","Send");
         send_txt.text = sendtxt;
         send_txt.mouseEnabled = false;
         objs = new Array();
         objs.push(SendBttn);
         MovieClip(parent.parent).ThemeButtonObjects(objs,MovieClip(parent.parent).projconfig.ui_color);
         SendBttn.addEventListener(MouseEvent.CLICK,MovieClip(parent).sendMsg);
      }
      
      function frame2() : *
      {
         stop();
         objs2 = new Array();
         objs2.push(WriteBttn);
         MovieClip(parent.parent).ThemeButtonObjects(objs2,MovieClip(parent.parent).projconfig.ui_color);
         WriteBttn.addEventListener(MouseEvent.CLICK,MovieClip(parent).writeMode);
      }
   }
}
