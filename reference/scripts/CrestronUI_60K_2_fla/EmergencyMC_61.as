package CrestronUI_60K_2_fla
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public dynamic class EmergencyMC_61 extends MovieClip
   {
       
      
      public var ScrollDown:SimpleButton;
      
      public var ScrollDownGF:MovieClip;
      
      public var ScrollUp:SimpleButton;
      
      public var txtReportEmergency:TextField;
      
      public var txtEmergencyIncoming:TextField;
      
      public var txtEmergencyTitle:TextField;
      
      public var txtEmergencyOutgoing:TextField;
      
      public var boxEmergencyOutgoing:MovieClip;
      
      public var SendTXT:TextField;
      
      public var InstanceName_0:MovieClip;
      
      public var SendBttn:SimpleButton;
      
      public var ScrollUpGF:MovieClip;
      
      public var msg:String;
      
      public var etype:String;
      
      public var clearonclick:Boolean;
      
      public var outgoingdefault:String;
      
      public function EmergencyMC_61()
      {
         super();
         addFrameScript(0,frame1,1,frame2);
      }
      
      public function setEmergencyType(param1:String) : *
      {
         var _loc2_:String = null;
         etype = param1;
         if(etype.length == 0)
         {
            etype = "Emergency";
         }
         if(txtEmergencyTitle != null)
         {
            _loc2_ = MovieClip(parent).getXMLText("e_Alert");
            if(_loc2_.length == 0)
            {
               _loc2_ = "Alert";
            }
            txtEmergencyTitle.text = etype + " " + _loc2_;
         }
      }
      
      public function setMsg(param1:String) : *
      {
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
         if(txtEmergencyIncoming != null)
         {
            txtEmergencyIncoming.text = msg;
            txtEmergencyIncoming.type = "dynamic";
            txtEmergencyIncoming.scrollV = txtEmergencyIncoming.maxScrollV;
            handleScrollBars();
         }
      }
      
      public function sendEmergencyMsg(param1:KeyboardEvent) : *
      {
         var _loc2_:MouseEvent = null;
         if(param1.keyCode == 13)
         {
            sendmsg(_loc2_);
         }
      }
      
      public function sendmsg(param1:Event) : *
      {
         var _loc2_:String = null;
         if(txtEmergencyOutgoing.text.length == 0)
         {
            return;
         }
         _loc2_ = txtEmergencyOutgoing.text.replace("\r","");
         MovieClip(parent).cnx.SendSerial(22,_loc2_);
         setMsg("[Sent] " + _loc2_);
         txtEmergencyOutgoing.text = "";
      }
      
      public function scrollup(param1:Event) : *
      {
         txtEmergencyIncoming.scrollV--;
         handleScrollBars();
      }
      
      public function scrolldown(param1:Event) : *
      {
         txtEmergencyIncoming.scrollV++;
         handleScrollBars();
      }
      
      public function focused(param1:Event) : *
      {
         if(clearonclick == true)
         {
            txtEmergencyOutgoing.textColor = 0;
            txtEmergencyOutgoing.text = "";
         }
         clearonclick = false;
      }
      
      public function scrolled(param1:Event) : *
      {
         handleScrollBars();
      }
      
      public function handleScrollBars() : *
      {
         if(txtEmergencyIncoming.bottomScrollV < txtEmergencyIncoming.numLines)
         {
            ScrollDown.visible = true;
         }
         else
         {
            ScrollDown.visible = false;
         }
         ScrollDownGF.visible = ScrollDown.visible;
         if(txtEmergencyIncoming.scrollV > 1)
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
         msg = "";
         etype = "";
      }
      
      function frame2() : *
      {
         stop();
         clearonclick = true;
         SendTXT.mouseEnabled = false;
         txtEmergencyIncoming.type = "dynamic";
         outgoingdefault = MovieClip(parent).getXMLText("EmergencyMC.DefaultText");
         if(outgoingdefault.length != 0)
         {
            txtEmergencyOutgoing.text = outgoingdefault;
         }
         txtEmergencyOutgoing.addEventListener(KeyboardEvent.KEY_UP,sendEmergencyMsg);
         SendBttn.addEventListener(MouseEvent.CLICK,sendmsg);
         ScrollUp.addEventListener(MouseEvent.CLICK,scrollup);
         ScrollDown.addEventListener(MouseEvent.CLICK,scrolldown);
         txtEmergencyOutgoing.addEventListener(FocusEvent.FOCUS_IN,focused);
         txtEmergencyIncoming.addEventListener(Event.SCROLL,scrolled);
         ScrollUp.visible = false;
         ScrollDown.visible = false;
         ScrollDownGF.mouseEnabled = false;
         ScrollUpGF.mouseEnabled = false;
         txtEmergencyIncoming.text = msg;
         txtEmergencyIncoming.type = "dynamic";
         txtEmergencyIncoming.scrollV = txtEmergencyIncoming.maxScrollV;
         handleScrollBars();
         MovieClip(parent).applyUiXml();
         setEmergencyType(etype);
      }
   }
}
