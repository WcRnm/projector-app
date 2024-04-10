package CrestronUI_60K_2_fla
{
   import CrestronDLP.StandardCommand;
   import fl.motion.Color;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public dynamic class HelpDeskPopup_41 extends MovieClip
   {
       
      
      public var MessageMC:MovieClip;
      
      public var lblTitle:TextField;
      
      public var ScrollDown:SimpleButton;
      
      public var ScrollDownGF:MovieClip;
      
      public var ScrollUp:SimpleButton;
      
      public var SendMC:MovieClip;
      
      public var textBox:TextField;
      
      public var ScrollUpGF:MovieClip;
      
      public var closeBttn:SimpleButton;
      
      public var msg:String;
      
      public var curmode:int;
      
      public var minheight:int;
      
      public var objs:Array;
      
      public function HelpDeskPopup_41()
      {
         super();
         addFrameScript(0,frame1,1,frame2,11,frame12);
      }
      
      public function showingNew() : Boolean
      {
         if(this.currentFrame == 12 && curmode == 1)
         {
            return true;
         }
         return false;
      }
      
      public function setMsg(param1:String) : *
      {
         var _loc3_:Color = null;
         if(param1.length == 0)
         {
            return;
         }
         if(msg.length != 0)
         {
            msg = msg + "\n";
         }
         var _loc2_:Date = new Date();
         msg = msg + "[" + _loc2_.toLocaleTimeString() + "]: " + param1;
         if(curmode == 0)
         {
            if(MessageMC != null)
            {
               MessageMC.visible = true;
               _loc3_ = new Color();
               _loc3_.setTint(MovieClip(parent).projconfig.ui_color,0.6);
               MessageMC.transform.colorTransform = _loc3_;
            }
         }
         else
         {
            UpdateText(msg);
         }
      }
      
      public function UpdateText(param1:String) : *
      {
         if(textBox == null)
         {
            return;
         }
         var _loc2_:int = textBox.scrollV;
         var _loc3_:int = textBox.maxScrollV;
         MessageMC.transform.colorTransform = new Color();
         textBox.text = msg;
         textBox.scrollV = textBox.maxScrollV;
         handleScrollBars();
      }
      
      public function closepopup(param1:MouseEvent) : *
      {
         gotoAndPlay("close");
      }
      
      public function scrollup(param1:Event) : *
      {
         textBox.scrollV--;
         handleScrollBars();
      }
      
      public function scrolldown(param1:Event) : *
      {
         textBox.scrollV++;
         handleScrollBars();
      }
      
      public function scrolled(param1:Event) : *
      {
         handleScrollBars();
      }
      
      public function writeMode(param1:Event) : *
      {
         textBox.type = "input";
         textBox.text = "";
         curmode = 0;
         SendMC.gotoAndStop(1);
         handleScrollBars();
         ScrollUp.visible = false;
         ScrollDown.visible = false;
      }
      
      public function readMsg(param1:Event) : *
      {
         curmode = 1;
         MessageMC.gotoAndStop(2);
         textBox.type = "dynamic";
         SendMC.gotoAndStop(2);
         UpdateText(msg);
      }
      
      public function sendMsg(param1:Event) : *
      {
         var _loc3_:String = null;
         var _loc2_:StandardCommand = MovieClip(parent).projconfig.GetStandardCommand(StandardCommand.CMD_HELP_MSG);
         if(_loc2_ != undefined)
         {
            _loc3_ = textBox.text.replace("\r","");
            MovieClip(parent).cnx.SendSerial(_loc2_.join,_loc3_);
            textBox.scrollV = 0;
            ScrollUp.visible = false;
            ScrollDown.visible = false;
            textBox.text = "";
         }
      }
      
      public function sendHelpMsg(param1:KeyboardEvent) : *
      {
         var _loc2_:MouseEvent = null;
         if(curmode != 0)
         {
            return;
         }
         if(param1.keyCode == 13)
         {
            sendMsg(_loc2_);
         }
      }
      
      public function handleScrollBars() : *
      {
         if(textBox.bottomScrollV < textBox.numLines)
         {
            ScrollDown.visible = true;
         }
         else
         {
            ScrollDown.visible = false;
         }
         ScrollDownGF.visible = ScrollDown.visible;
         if(textBox.scrollV > 1)
         {
            ScrollUp.visible = true;
         }
         else
         {
            ScrollUp.visible = false;
         }
         ScrollUpGF.visible = ScrollUp.visible;
      }
      
      function frame1() : *
      {
         stop();
         if(msg == null)
         {
            msg = "";
         }
         minheight = 11;
      }
      
      function frame2() : *
      {
         MovieClip(parent).applyUiXml();
         MovieClip(parent).checkForLoginButton();
      }
      
      function frame12() : *
      {
         stop();
         if(msg == null || msg.length == 0)
         {
            MessageMC.visible = false;
         }
         this.closeBttn.addEventListener(MouseEvent.CLICK,closepopup);
         ScrollUp.addEventListener(MouseEvent.CLICK,scrollup);
         ScrollDown.addEventListener(MouseEvent.CLICK,scrolldown);
         textBox.addEventListener(Event.SCROLL,scrolled);
         ScrollUp.visible = false;
         ScrollDown.visible = false;
         MessageMC.gotoAndStop(2);
         objs = new Array();
         objs.push(closeBttn);
         MovieClip(parent).ThemeButtonObjects(objs,MovieClip(parent).projconfig.ui_color);
         if(curmode == 1)
         {
            readMsg(null);
         }
         textBox.addEventListener(KeyboardEvent.KEY_UP,sendHelpMsg);
         ScrollDownGF.mouseEnabled = false;
         ScrollUpGF.mouseEnabled = false;
         MovieClip(parent).applyUiXml();
         MovieClip(parent).checkForLoginButton();
         if(lblTitle.text.length == 0)
         {
            lblTitle.text = "Help Desk";
         }
      }
   }
}
