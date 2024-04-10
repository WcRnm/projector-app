package CrestronUI_60K_2_fla
{
   import Crestron.AnalogEvent;
   import Crestron.CNXConnection;
   import CrestronDLP.StandardCommand;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public dynamic class warmingPopup_49 extends MovieClip
   {
       
      
      public var prompt_txt:TextField;
      
      public var tmrgauge:MovieClip;
      
      public var lblWarming:TextField;
      
      public var bwarming:Boolean;
      
      public var str_warming:String;
      
      public var str_cooling:String;
      
      public var fakeanalogval:Number;
      
      public var tmr:Timer;
      
      public var objs:Array;
      
      public function warmingPopup_49()
      {
         super();
         addFrameScript(0,frame1,6,frame7,12,frame13);
      }
      
      public function showwarming(param1:Boolean) : *
      {
         bwarming = param1;
         gotoAndPlay("open");
      }
      
      public function closewarming() : *
      {
         gotoAndPlay("close");
      }
      
      public function fakevalue(param1:Event) : *
      {
         var e:Event = param1;
         try
         {
            fakeanalogval = fakeanalogval + 5;
            if(fakeanalogval > 255)
            {
               fakeanalogval = 0;
            }
            tmrgauge.gotoAndStop(fakeanalogval);
            return;
         }
         catch(e:*)
         {
            tmr.stop();
            return;
         }
      }
      
      public function onAnalog(param1:AnalogEvent) : *
      {
         var _loc2_:StandardCommand = MovieClip(parent).projconfig.GetStandardCommand(StandardCommand.CMD_WARMING_VAL);
         if(_loc2_ != undefined && _loc2_.join == param1.Join)
         {
            tmr.stop();
         }
         if(param1.Join == 5011)
         {
            tmr.stop();
         }
         setJoinVal();
      }
      
      public function setJoinVal() : *
      {
         var _loc3_:StandardCommand = null;
         if(tmrgauge == null)
         {
            return;
         }
         var _loc1_:uint = 0;
         if(bwarming)
         {
            _loc3_ = MovieClip(parent).projconfig.GetStandardCommand(StandardCommand.CMD_WARMING_VAL);
            if(_loc3_ == undefined)
            {
               return;
            }
            if(MovieClip(parent).analogs[_loc3_.join] != undefined)
            {
               _loc1_ = MovieClip(parent).analogs[_loc3_.join];
            }
         }
         else
         {
            _loc1_ = MovieClip(parent).analogs[5011];
         }
         var _loc2_:Number = Math.ceil(_loc1_ / 65536 * 255);
         tmrgauge.gotoAndStop(_loc2_ + 2);
      }
      
      function frame1() : *
      {
         bwarming = true;
         stop();
      }
      
      function frame7() : *
      {
         str_warming = "";
         try
         {
            str_warming = MovieClip(parent).getXMLText("warmingPopup.prompt_txt_warming");
         }
         catch(e:Error)
         {
            str_warming = "Warming Up";
         }
         if(str_warming.length == 0)
         {
            str_warming = "Warming Up";
         }
         str_cooling = "";
         try
         {
            str_cooling = MovieClip(parent).getXMLText("warmingPopup.prompt_txt_cooling");
         }
         catch(e:Error)
         {
            str_cooling = "Cooling Down";
         }
         if(str_cooling.length == 0)
         {
            str_cooling = "Cooling Down";
         }
         if(bwarming)
         {
            prompt_txt.text = str_warming;
         }
         else
         {
            prompt_txt.text = str_cooling;
         }
      }
      
      function frame13() : *
      {
         stop();
         fakeanalogval = 0;
         tmr = new Timer(300);
         tmr.addEventListener(TimerEvent.TIMER,fakevalue);
         tmr.start();
         prompt_txt.mouseEnabled = false;
         objs = new Array();
         objs.push(tmrgauge);
         MovieClip(this.parent).ThemeObjects(objs,MovieClip(this.parent).projconfig.ui_color);
         tmrgauge.gotoAndStop(2);
         MovieClip(parent).cnx.addEventListener(CNXConnection.ANALOG,onAnalog);
         setJoinVal();
      }
   }
}
