package CrestronUI_60K_2_fla
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public dynamic class UpdateCompleteMC_63 extends MovieClip
   {
       
      
      public var txtUpdateComplete:TextField;
      
      public var closeBttn:SimpleButton;
      
      public var gmsg:String;
      
      public var updatemsg:String;
      
      public function UpdateCompleteMC_63()
      {
         super();
         addFrameScript(0,frame1,1,frame2,7,frame8,11,frame12);
      }
      
      public function setMsg(param1:String) : *
      {
         gmsg = param1;
         play();
      }
      
      public function closepopup(param1:MouseEvent) : void
      {
         gotoAndPlay("close");
      }
      
      function frame1() : *
      {
         stop();
         gmsg = "";
      }
      
      function frame2() : *
      {
         if(gmsg.length == 0)
         {
            updatemsg = MovieClip(parent).getDefaultXMLText("lblUpdateComplete");
            if(updatemsg.length == 0)
            {
               updatemsg = "Update Complete";
            }
            gmsg = updatemsg;
         }
      }
      
      function frame8() : *
      {
         if(gmsg.length > 0)
         {
            txtUpdateComplete.text = gmsg;
         }
      }
      
      function frame12() : *
      {
         stop();
         this.closeBttn.addEventListener(MouseEvent.CLICK,closepopup);
         if(gmsg.length > 0)
         {
            txtUpdateComplete.text = gmsg;
         }
      }
   }
}
