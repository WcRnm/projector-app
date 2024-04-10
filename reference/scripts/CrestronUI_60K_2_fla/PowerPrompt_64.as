package CrestronUI_60K_2_fla
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public dynamic class PowerPrompt_64 extends MovieClip
   {
       
      
      public var yesbtn:SimpleButton;
      
      public var lblYes:TextField;
      
      public var lblSure:TextField;
      
      public var nobtn:SimpleButton;
      
      public var lblPrompt:TextField;
      
      public var lblNo:TextField;
      
      public var closeBttn:SimpleButton;
      
      public var objs:Array;
      
      public function PowerPrompt_64()
      {
         super();
         addFrameScript(0,frame1,1,frame2,11,frame12);
      }
      
      public function closepopup(param1:MouseEvent) : void
      {
         gotoAndPlay("close");
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame2() : *
      {
         MovieClip(parent).applyUiXml();
      }
      
      function frame12() : *
      {
         stop();
         MovieClip(parent).applyUiXml();
         if(lblPrompt.text.length == 0)
         {
            lblPrompt.text = "Power Prompt";
         }
         if(lblSure.text.length == 0)
         {
            lblSure.text = "Are you sure?";
         }
         if(lblYes.text.length == 0)
         {
            lblYes.text = "Yes";
         }
         if(lblNo.text.length == 0)
         {
            lblNo.text = "No";
         }
         this.closeBttn.addEventListener(MouseEvent.CLICK,closepopup);
         this.nobtn.addEventListener(MouseEvent.CLICK,closepopup);
         yesbtn.addEventListener(MouseEvent.CLICK,MovieClip(parent).powerOffConfirmed);
         yesbtn.addEventListener(MouseEvent.CLICK,closepopup);
         lblYes.mouseEnabled = false;
         lblNo.mouseEnabled = false;
         objs = new Array();
         objs.push(yesbtn);
         objs.push(nobtn);
         objs.push(closeBttn);
         MovieClip(parent).ThemeButtonObjects(objs,MovieClip(parent).projconfig.ui_color);
      }
   }
}
