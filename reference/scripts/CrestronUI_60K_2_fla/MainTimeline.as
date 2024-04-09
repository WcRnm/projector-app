package CrestronUI_60K_2_fla
{
   import Crestron.AnalogEvent;
   import Crestron.CNXConnection;
   import Crestron.DigitalEvent;
   import Crestron.SerialEvent;
   import CrestronDLP.DLPConfig;
   import CrestronDLP.DLPSource;
   import CrestronDLP.ExtendedCommand;
   import CrestronDLP.StandardCommand;
   import fl.motion.Color;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.Capabilities;
   import flash.text.TextField;
   import flash.ui.ContextMenu;
   import flash.utils.Timer;
   
   public dynamic class MainTimeline extends MovieClip
   {
       
      
      public var EmergencyMC:MovieClip;
      
      public var expansion:MovieClip;
      
      public var warmingPopup:MovieClip;
      
      public var mutebtn:MovieClip;
      
      public var voldowntext:TextField;
      
      public var InfoMC:MovieClip;
      
      public var gaugePopUp:MovieClip;
      
      public var info_txt:TextField;
      
      public var loadingMC:MovieClip;
      
      public var coverup2:MovieClip;
      
      public var volumeMC:MovieClip;
      
      public var voluptext:TextField;
      
      public var ToolsMC:MovieClip;
      
      public var hdrLoader:MovieClip;
      
      public var tools_txt:TextField;
      
      public var HelpBttn:SimpleButton;
      
      public var compline1text:TextField;
      
      public var UserMC:MovieClip;
      
      public var volupbtn:MovieClip;
      
      public var btnRoomView:SimpleButton;
      
      public var UpdateCompleteMC:MovieClip;
      
      public var powertext:TextField;
      
      public var modeltext:TextField;
      
      public var compline2text:TextField;
      
      public var coverup:MovieClip;
      
      public var ZoomPopUp:MovieClip;
      
      public var HelpDesk:MovieClip;
      
      public var InfoBttn:SimpleButton;
      
      public var AdminrMC:MovieClip;
      
      public var powerbtn:MovieClip;
      
      public var btnLogout:SimpleButton;
      
      public var logout_txt:TextField;
      
      public var PowerPrompt:MovieClip;
      
      public var versiontext:TextField;
      
      public var transportControls:MovieClip;
      
      public var headerBar:MovieClip;
      
      public var WarmingPrompt:MovieClip;
      
      public var mutetext:TextField;
      
      public var Extensions:MovieClip;
      
      public var voldownbtn:MovieClip;
      
      public var SourceList:MovieClip;
      
      public var ToolsBttn:SimpleButton;
      
      public var help_txt:TextField;
      
      public var temp_ipaddr:String;
      
      public var temp_ipid:String;
      
      public var bUseTempIpaddr:Boolean;
      
      public var hightlight_x_size:uint;
      
      public var hightlight_y_size:uint;
      
      public var loggedIn:Boolean;
      
      public const verstr:String = "2.7.2.6";
      
      public const _SRC:String = "source";
      
      public var my_cm:ContextMenu;
      
      public var txts:Array;
      
      public var msgTimer:Timer;
      
      public var volTimer:Timer;
      
      public var extCmd:ExtendedCommand;
      
      public var currentIndex:uint;
      
      public var currentExtIndex:uint;
      
      public var ldr:Loader;
      
      public var projconfig:DLPConfig;
      
      public var txti:uint;
      
      public var exti:uint;
      
      public var cnx:CNXConnection;
      
      public var digitals:Array;
      
      public var analogs:Array;
      
      public var serials:Array;
      
      public var ipaddr;
      
      public var slashpos:int;
      
      public var ipid:String;
      
      public var conTimer:Timer;
      
      public var bDisableRetry:Boolean;
      
      public var RestartDeviceTimer:Timer;
      
      public var retryConTimer:Timer;
      
      public const DIG_PROMPT_PASSWORD:uint = 5212;
      
      public const DIG_USR_PWD_CORRECT:uint = 5214;
      
      public const DIG_ADM_PWD_CORRECT:uint = 5218;
      
      public var required_level:int;
      
      public const LOGIN_NONE:int = 0;
      
      public const LOGIN_USER:int = 1;
      
      public const LOGIN_ADMIN:int = 2;
      
      public var loginLevel:int;
      
      public var emergencyType:String;
      
      public var disabledAnalog:uint;
      
      public function MainTimeline()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function StripHTML(param1:String) : String
      {
         var _loc2_:RegExp = /<[^>]*>/gi;
         var _loc3_:String = param1.replace(_loc2_,"");
         return _loc3_;
      }
      
      public function showToolsPage(param1:Boolean) : *
      {
         if(param1)
         {
            coverup.visible = false;
            coverup2.visible = false;
            if(ToolsMC.currentFrame == 1)
            {
               ToolsMC.gotoAndPlay(2);
            }
            this.tabChildren = true;
         }
         else
         {
            coverup.visible = !getPowerState();
            if(!projconfig.bVolumnIsHidden)
            {
               coverup2.visible = !getPowerState();
            }
            else
            {
               coverup2.visible = false;
            }
            if(ToolsMC.currentFrame == 2)
            {
               ToolsMC.gotoAndPlay(1);
            }
         }
      }
      
      public function showInfoPage(param1:Boolean) : *
      {
         if(param1)
         {
            coverup.visible = false;
            coverup2.visible = false;
            if(InfoMC.currentFrame == 1)
            {
               InfoMC.gotoAndPlay(2);
            }
         }
         else
         {
            coverup.visible = !getPowerState();
            if(!projconfig.bVolumnIsHidden)
            {
               coverup2.visible = !getPowerState();
            }
            else
            {
               coverup2.visible = false;
            }
            if(InfoMC.currentFrame == 2)
            {
               InfoMC.gotoAndPlay(1);
            }
         }
      }
      
      public function ThemeButtonObjects(param1:Array, param2:uint) : *
      {
         var _loc3_:* = undefined;
         for each(_loc3_ in param1)
         {
            ThemeButtonObject(_loc3_,param2);
         }
      }
      
      public function ThemeButtonObject(param1:Object, param2:uint) : *
      {
         if(param1.downState == undefined)
         {
            ThemeButtonObject(param1.btn,param2);
            return;
         }
         var _loc3_:Color = new Color();
         _loc3_.setTint(param2,0.5);
         param1.downState.transform.colorTransform = _loc3_;
         param1.upState.transform.colorTransform = new Color();
         param1.overState.transform.colorTransform = new Color();
         var _loc4_:GlowFilter = new GlowFilter(param2,1,2,50,2,1,true);
         param1.overState.filters = [_loc4_];
      }
      
      public function SetExtObjectDisabled(param1:uint, param2:Boolean) : *
      {
         var _loc5_:Color = null;
         var _loc3_:Object = Extensions["extended" + param1];
         var _loc4_:Object = Extensions["extended" + param1 + "text"];
         if(true == param2)
         {
            _loc3_.enabled = false;
            _loc3_.mouseEnabled = false;
            ClearObjectHighlight(_loc3_);
            _loc5_ = new Color();
            _loc5_.setTint(12632256,0.3);
            _loc3_.downState.transform.colorTransform = _loc5_;
            _loc3_.upState.transform.colorTransform = _loc5_;
            _loc3_.overState.transform.colorTransform = _loc5_;
            _loc4_.textColor = 10526880;
         }
         else
         {
            _loc3_.mouseEnabled = true;
            ThemeButtonObject(_loc3_,projconfig.ui_color);
            _loc4_.textColor = 15066597;
         }
      }
      
      public function SetObjectHighlight(param1:Object, param2:uint) : *
      {
         if(param1.downState == undefined)
         {
            if(param1.btn != undefined)
            {
               SetObjectHighlight(param1.btn,param2);
            }
            return;
         }
         var _loc3_:GlowFilter = new GlowFilter(param2,1,hightlight_x_size,hightlight_y_size,3,2,false);
         param1.downState.filters = [_loc3_];
         _loc3_ = new GlowFilter(param2,1,hightlight_x_size * 4,hightlight_y_size * 4,1,50,true);
         var _loc4_:GlowFilter = new GlowFilter(param2,1,15,5,2,1,true);
         param1.overState.filters = [_loc3_,_loc4_];
         _loc3_ = new GlowFilter(param2,1,hightlight_x_size * 3,hightlight_y_size * 3,1,50,true);
         param1.upState.filters = [_loc3_];
      }
      
      public function ClearObjectHighlight(param1:Object) : *
      {
         if(param1.downState == undefined)
         {
            if(param1.btn != undefined)
            {
               ClearObjectHighlight(param1.btn);
            }
            return;
         }
         var _loc2_:GlowFilter = new GlowFilter(projconfig.ui_color,1,2,50,2,1,true);
         param1.overState.filters = [_loc2_];
         param1.upState.filters = null;
         param1.downState.filters = null;
      }
      
      public function IsObjectHighlighted(param1:Object) : Boolean
      {
         if(param1.overState.filters.length > 1)
         {
            return true;
         }
         return false;
      }
      
      public function ThemeObjects(param1:Array, param2:uint) : *
      {
         var _loc4_:* = undefined;
         var _loc3_:Color = new Color();
         _loc3_.setTint(param2,0.5);
         for each(_loc4_ in param1)
         {
            _loc4_.transform.colorTransform = _loc3_;
         }
      }
      
      public function ThemeSourceList(param1:Object, param2:String, param3:uint, param4:uint) : *
      {
         var _loc7_:GlowFilter = null;
         var _loc5_:Color = new Color();
         _loc5_.setTint(param4,0.5);
         var _loc6_:uint = 1;
         while(_loc6_ <= param3)
         {
            param1[param2 + _loc6_].downState.transform.colorTransform = _loc5_;
            _loc7_ = new GlowFilter(param4,1,15,5,2,1,true);
            param1[param2 + _loc6_].overState.filters = [_loc7_];
            _loc6_++;
         }
      }
      
      public function SetButtonText(param1:String, param2:uint) : *
      {
         if(txts[param2] == undefined)
         {
            txts[param2] = new Array();
            txts[param2][1] = new TextField();
            txts[param2][1].autoSize = "center";
            txts[param2][1].width = 440;
            txts[param2][1].height = 41;
            txts[param2][1].y = 0;
            txts[param2][1].x = 0;
            txts[param2][1].y = this.SourceList.source1.y;
            txts[param2][1].x = this.SourceList.source1.x;
            txts[param2][1].mouseEnabled = false;
            this.SourceList[_SRC + param2].overState.addChild(txts[param2][1]);
         }
         txts[param2][1].text = param1;
      }
      
      public function info(param1:MouseEvent) : void
      {
         if(false == loggedIn)
         {
            return;
         }
         if(true == inEmergency())
         {
            return;
         }
         showToolsPage(false);
         showInfoPage(true);
      }
      
      public function tools(param1:MouseEvent) : void
      {
         if(false == loggedIn)
         {
            return;
         }
         if(true == inEmergency())
         {
            return;
         }
         if(digitals[5216] == true && loginLevel != LOGIN_ADMIN)
         {
            showAdminPasswordPrompt();
         }
         else
         {
            showInfoPage(false);
            showToolsPage(true);
         }
      }
      
      public function pulseCmd(param1:StandardCommand) : *
      {
         cnx.SendDigital(param1.join,1);
         cnx.SendDigital(param1.join,0);
      }
      
      public function powerOn() : *
      {
         var _loc1_:StandardCommand = projconfig.GetStandardCommand(StandardCommand.CMD_POWER_ON);
         if(_loc1_ != undefined)
         {
            pulseCmd(_loc1_);
         }
      }
      
      public function powerOff() : *
      {
         PowerPrompt.gotoAndPlay("open");
      }
      
      public function powerOffConfirmed(param1:Event) : *
      {
         var _loc2_:StandardCommand = projconfig.GetStandardCommand(StandardCommand.CMD_POWER_OFF);
         if(_loc2_ != undefined)
         {
            pulseCmd(_loc2_);
         }
      }
      
      public function powerClick(param1:MouseEvent) : *
      {
         var _loc2_:StandardCommand = null;
         if(digitals[5160] != 1 && digitals[5161] != 1)
         {
            _loc2_ = projconfig.GetStandardCommand(StandardCommand.CMD_POWER_ON);
            if(_loc2_ != undefined)
            {
               if(digitals[_loc2_.join] != 1)
               {
                  powerOn();
               }
               else
               {
                  powerOff();
               }
            }
         }
      }
      
      public function scrollSources(param1:MouseEvent) : *
      {
         var _loc2_:uint = currentIndex;
         if(param1.target.name == "ScrollDOWN")
         {
            _loc2_ = _loc2_ + 5;
         }
         else
         {
            _loc2_ = _loc2_ - 5;
         }
         ScrollSourceList(_loc2_);
      }
      
      public function scrollExt(param1:MouseEvent) : *
      {
         var _loc2_:uint = currentExtIndex;
         if(param1.target.name == "Right_bttn")
         {
            _loc2_ = _loc2_ + 4;
         }
         else
         {
            _loc2_ = _loc2_ - 4;
         }
         ScrollExtList(_loc2_);
      }
      
      public function sendJoinClick(param1:MouseEvent) : *
      {
         var _loc3_:StandardCommand = null;
         var _loc4_:StandardCommand = null;
         var _loc2_:* = param1.target.name;
         if(_loc2_ == "btn")
         {
            _loc2_ = param1.target.parent.name;
         }
         switch(_loc2_)
         {
            case "volupbtn":
               _loc3_ = projconfig.GetStandardCommand(StandardCommand.CMD_VOLUME_UP);
               break;
            case "mutebtn":
               _loc4_ = projconfig.GetStandardCommand(StandardCommand.CMD_MUTE);
               if(_loc4_ != undefined)
               {
                  if(digitals[_loc4_.join] != 1)
                  {
                     _loc3_ = _loc4_;
                  }
                  else
                  {
                     _loc3_ = projconfig.GetStandardCommand(StandardCommand.CMD_MUTE_OFF);
                  }
               }
               break;
            case "voldownbtn":
               _loc3_ = projconfig.GetStandardCommand(StandardCommand.CMD_VOLUME_DOWN);
               break;
            case "menubtn":
               _loc3_ = projconfig.GetStandardCommand(StandardCommand.CMD_MENU);
               break;
            case "upbtn":
               _loc3_ = projconfig.GetStandardCommand(StandardCommand.CMD_MENU_UP);
               break;
            case "downbtn":
               _loc3_ = projconfig.GetStandardCommand(StandardCommand.CMD_MENU_DOWN);
               break;
            case "leftbtn":
               _loc3_ = projconfig.GetStandardCommand(StandardCommand.CMD_MENU_LEFT);
               break;
            case "rightbtn":
               _loc3_ = projconfig.GetStandardCommand(StandardCommand.CMD_MENU_RIGHT);
               break;
            case "okbtn":
               _loc3_ = projconfig.GetStandardCommand(StandardCommand.CMD_MENU_ENTER);
               break;
            case "exitbtn":
               _loc3_ = projconfig.GetStandardCommand(StandardCommand.CMD_MENU_EXIT);
         }
         if(!(_loc3_ == undefined || _loc3_ == null))
         {
            pulseCmd(_loc3_);
         }
      }
      
      public function flashMsg(param1:Event) : *
      {
         help_txt.visible = !help_txt.visible;
      }
      
      public function showVolumeBar(param1:uint) : *
      {
         if(projconfig.CanShowVolumeBar())
         {
            param1 = param1 + 2;
            volumeMC.gotoAndStop(param1);
            volTimer.reset();
            volTimer.start();
         }
      }
      
      public function hideVolumeBar(param1:Event) : *
      {
         volTimer.stop();
         volumeMC.gotoAndStop(0);
      }
      
      public function sourceClicked(param1:uint) : *
      {
         var _loc3_:DLPSource = null;
         param1--;
         var _loc2_:Boolean = canEditSources();
         if(_loc2_)
         {
            _loc3_ = projconfig.getSourceAt(currentIndex + param1);
         }
         else
         {
            _loc3_ = projconfig.getVisibleSourceAt(currentIndex + param1);
         }
         if(_loc3_ != undefined)
         {
            cnx.SendDigital(_loc3_.join,1);
            cnx.SendDigital(_loc3_.join,0);
         }
      }
      
      public function source1Clicked(param1:Event) : *
      {
         sourceClicked(1);
      }
      
      public function source2Clicked(param1:Event) : *
      {
         sourceClicked(2);
      }
      
      public function source3Clicked(param1:Event) : *
      {
         sourceClicked(3);
      }
      
      public function source4Clicked(param1:Event) : *
      {
         sourceClicked(4);
      }
      
      public function source5Clicked(param1:Event) : *
      {
         sourceClicked(5);
      }
      
      public function extendedClicked(param1:uint) : *
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(projconfig.extendedcommands[currentExtIndex + param1] != undefined)
         {
            this.gaugePopUp.gotoAndStop(0);
            this.ZoomPopUp.gotoAndStop(0);
            extCmd = projconfig.extendedcommands[currentExtIndex + param1];
            switch(extCmd.cmdtype)
            {
               case ExtendedCommand.CMD_EXT_MOMENTARY:
                  cnx.SendDigital(extCmd.cmdjoin[ExtendedCommand.JOIN_MOMENTARY],1);
                  cnx.SendDigital(extCmd.cmdjoin[ExtendedCommand.JOIN_MOMENTARY],0);
                  break;
               case ExtendedCommand.CMD_EXT_TOGGLE:
                  _loc2_ = 0;
                  if(undefined != digitals[extCmd.getFeedbackJoin(ExtendedCommand.JOIN_FBACK_DIGITAL)])
                  {
                     _loc2_ = digitals[extCmd.getFeedbackJoin(ExtendedCommand.JOIN_FBACK_DIGITAL)];
                  }
                  _loc3_ = extCmd.cmdjoin[ExtendedCommand.JOIN_STATE_0];
                  if(_loc2_ == 1)
                  {
                     _loc3_ = extCmd.cmdjoin[ExtendedCommand.JOIN_STATE_1];
                  }
                  cnx.SendDigital(_loc3_,1);
                  cnx.SendDigital(_loc3_,0);
                  break;
               case ExtendedCommand.CMD_EXT_RAMP:
                  this.gaugePopUp.gotoAndPlay("open");
                  break;
               case ExtendedCommand.CMD_EXT_ZOOM:
                  this.ZoomPopUp.gotoAndPlay("open");
            }
         }
      }
      
      public function extendedXClicked(param1:Event) : *
      {
         var _loc2_:uint = parseInt(param1.target.name.substr(param1.target.name.length - 1,1));
         extendedClicked(_loc2_);
      }
      
      public function SetupTheme(param1:uint) : *
      {
         var _loc2_:Array = new Array();
         _loc2_.push(SourceList.source1);
         _loc2_.push(SourceList.source2);
         _loc2_.push(SourceList.source3);
         _loc2_.push(SourceList.source4);
         _loc2_.push(SourceList.source5);
         _loc2_.push(transportControls.menubtn);
         _loc2_.push(transportControls.upbtn);
         _loc2_.push(transportControls.leftbtn);
         _loc2_.push(transportControls.okbtn);
         _loc2_.push(transportControls.rightbtn);
         _loc2_.push(transportControls.downbtn);
         _loc2_.push(transportControls.exitbtn);
         _loc2_.push(Extensions.Left_bttn);
         _loc2_.push(Extensions.Right_bttn);
         _loc2_.push(Extensions.extended1);
         _loc2_.push(Extensions.extended2);
         _loc2_.push(Extensions.extended3);
         _loc2_.push(Extensions.extended4);
         _loc2_.push(powerbtn);
         _loc2_.push(voldownbtn);
         _loc2_.push(mutebtn);
         _loc2_.push(volupbtn);
         _loc2_.push(HelpBttn);
         _loc2_.push(InfoBttn);
         _loc2_.push(ToolsBttn);
         _loc2_.push(btnLogout);
         help_txt.mouseEnabled = false;
         help_txt.autoSize = "center";
         ThemeButtonObjects(_loc2_,param1);
         _loc2_.length = 0;
         _loc2_.push(headerBar);
         _loc2_.push(volumeMC);
         ThemeObjects(_loc2_,param1);
      }
      
      public function SetSourceText(param1:String, param2:uint) : *
      {
         SourceList[_SRC + param2 + "text"].htmlText = param1;
      }
      
      public function SetExtText(param1:String, param2:uint) : *
      {
         Extensions["extended" + param2 + "text"].text = param1;
      }
      
      public function getActiveSource() : uint
      {
         var _loc1_:* = undefined;
         for(_loc1_ in projconfig.sources)
         {
            if(digitals[projconfig.sources[_loc1_].join] == 1)
            {
               return projconfig.sources[_loc1_].index;
            }
         }
         return 0;
      }
      
      public function ScrollSourceList(param1:uint) : *
      {
         var _loc2_:DLPSource = null;
         var _loc4_:int = 0;
         if(param1 < 0)
         {
            return;
         }
         var _loc3_:Boolean = canEditSources();
         if(_loc3_)
         {
            _loc4_ = projconfig.sources.length;
         }
         else
         {
            _loc4_ = projconfig.getVisibleSourceCount();
         }
         if(param1 >= projconfig.sources.length && param1 != 0)
         {
            return;
         }
         if(_loc4_ < 6)
         {
            SourceList.upsource.visible = false;
            SourceList.downsource.visible = false;
         }
         else
         {
            SourceList.upsource.visible = true;
            SourceList.downsource.visible = true;
         }
         currentIndex = param1;
         var _loc5_:uint = 0;
         while(_loc5_ < 5)
         {
            if(_loc3_)
            {
               _loc2_ = projconfig.getSourceAt(currentIndex + _loc5_);
            }
            else
            {
               _loc2_ = projconfig.getVisibleSourceAt(currentIndex + _loc5_);
            }
            if(_loc2_ != undefined)
            {
               SourceList["edit" + (_loc5_ + 1)].visible = _loc3_;
               SourceList["reset" + (_loc5_ + 1)].visible = _loc3_;
               SourceList["hide" + (_loc5_ + 1)].visible = _loc3_;
               SourceList[_SRC + (_loc5_ + 1)].enabled = true;
               if(_loc2_.isHidden() == true)
               {
                  SourceList["hide" + (_loc5_ + 1)].text = "Show";
               }
               else
               {
                  SourceList["hide" + (_loc5_ + 1)].text = "Hide";
               }
               if(digitals[_loc2_.join] == 1 && getPowerState())
               {
                  SetSourceText("<B>" + _loc2_.getSourceName() + "</B>",_loc5_ + 1);
                  InfoMC.updateSource(_loc2_.sourceName);
                  SetObjectHighlight(SourceList[_SRC + (_loc5_ + 1)],projconfig.ui_color);
                  SourceList[_SRC + (_loc5_ + 1) + "text"].textColor = 16777215;
               }
               else
               {
                  SetSourceText(_loc2_.getSourceName(),_loc5_ + 1);
                  ClearObjectHighlight(SourceList[_SRC + (_loc5_ + 1)]);
                  SourceList[_SRC + (_loc5_ + 1) + "text"].textColor = 10526880;
               }
            }
            else
            {
               SourceList["edit" + (_loc5_ + 1)].visible = false;
               SourceList["reset" + (_loc5_ + 1)].visible = false;
               SourceList["hide" + (_loc5_ + 1)].visible = false;
               SourceList[_SRC + (_loc5_ + 1)].enabled = false;
               SetSourceText("",_loc5_ + 1);
               ClearObjectHighlight(SourceList["source" + (_loc5_ + 1)]);
            }
            _loc5_++;
         }
         if(param1 > 0)
         {
            SourceList.ScrollUP.mouseEnabled = true;
            SetObjectHighlight(SourceList.ScrollUP,projconfig.ui_color);
         }
         else
         {
            SourceList.ScrollUP.mouseEnabled = false;
            ClearObjectHighlight(SourceList.ScrollUP);
         }
         if(_loc4_ >= param1 + 6)
         {
            SourceList.ScrollDOWN.mouseEnabled = true;
            SetObjectHighlight(SourceList.ScrollDOWN,projconfig.ui_color);
         }
         else
         {
            SourceList.ScrollDOWN.mouseEnabled = false;
            ClearObjectHighlight(SourceList.ScrollDOWN);
         }
      }
      
      public function disabledByJoin(param1:uint) : Boolean
      {
         param1--;
         return disabledAnalog & Math.pow(2,param1);
      }
      
      public function ScrollExtList(param1:uint, param2:Boolean = true) : *
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         if(param1 < 0)
         {
            return;
         }
         if(param1 >= projconfig.extendedcommands.length - 1)
         {
            return;
         }
         if(param2 == true)
         {
            this.gaugePopUp.gotoAndStop(0);
            this.ZoomPopUp.gotoAndStop(0);
         }
         var _loc3_:uint = getActiveSource();
         currentExtIndex = param1;
         var _loc4_:uint = 1;
         while(_loc4_ < 5)
         {
            if(projconfig.extendedcommands[currentExtIndex + _loc4_] != undefined)
            {
               SetExtText(projconfig.extendedcommands[currentExtIndex + _loc4_].cmdname,_loc4_);
               if(disabledByJoin(currentExtIndex + _loc4_))
               {
                  SetExtObjectDisabled(_loc4_,true);
               }
               else
               {
                  SetExtObjectDisabled(_loc4_,false);
                  Extensions["extended" + _loc4_].enabled = true;
                  _loc5_ = projconfig.extendedcommands[currentExtIndex + _loc4_].cmdfback[ExtendedCommand.JOIN_FBACK_DIGITAL];
                  _loc6_ = digitals[_loc5_];
                  if(digitals[projconfig.extendedcommands[currentExtIndex + _loc4_].cmdfback[ExtendedCommand.JOIN_FBACK_DIGITAL]] == 1)
                  {
                     SetObjectHighlight(Extensions["extended" + _loc4_],projconfig.ui_color);
                  }
                  else
                  {
                     ClearObjectHighlight(Extensions["extended" + _loc4_]);
                  }
               }
            }
            else
            {
               SetExtObjectDisabled(_loc4_,false);
               Extensions["extended" + _loc4_].enabled = false;
               SetExtText("",_loc4_);
               ClearObjectHighlight(Extensions["extended" + _loc4_]);
            }
            _loc4_++;
         }
         if(param1 > 0)
         {
            Extensions.Left_bttn.enabled = true;
            SetObjectHighlight(Extensions.Left_bttn,projconfig.ui_color);
         }
         else
         {
            Extensions.Left_bttn.enabled = false;
            ClearObjectHighlight(Extensions.Left_bttn);
         }
         if(projconfig.extendedcommands.length > param1 + 5)
         {
            Extensions.Right_bttn.enabled = true;
            SetObjectHighlight(Extensions.Right_bttn,projconfig.ui_color);
         }
         else
         {
            Extensions.Right_bttn.enabled = false;
            ClearObjectHighlight(Extensions.Right_bttn);
         }
      }
      
      public function setStandardCommandText(param1:*, param2:*) : *
      {
         if(param2 == undefined)
         {
            return;
         }
         param1.autoSize = "center";
         param1.mouseEnabled = false;
         if(param2.lbl.length > 0)
         {
            param1.text = param2.lbl;
         }
      }
      
      public function showHelpDesk(param1:Event) : *
      {
         if(false == loggedIn)
         {
            return;
         }
         var _loc2_:Boolean = msgTimer.running;
         msgTimer.stop();
         HelpBttn.visible = true;
         help_txt.visible = true;
         if(HelpDesk.currentFrame == 1)
         {
            this.HelpDesk.gotoAndPlay("open");
         }
         if(true == _loc2_)
         {
            this.HelpDesk.curmode = 1;
         }
      }
      
      public function volup_start(param1:Event) : *
      {
         var _loc2_:StandardCommand = projconfig.GetStandardCommand(StandardCommand.CMD_VOLUME_UP);
         cnx.SendDigital(_loc2_.join,1);
      }
      
      public function volup_end(param1:Event) : *
      {
         var _loc2_:StandardCommand = projconfig.GetStandardCommand(StandardCommand.CMD_VOLUME_UP);
         cnx.SendDigital(_loc2_.join,0);
      }
      
      public function voldown_start(param1:Event) : *
      {
         var _loc2_:StandardCommand = projconfig.GetStandardCommand(StandardCommand.CMD_VOLUME_DOWN);
         cnx.SendDigital(_loc2_.join,1);
      }
      
      public function voldown_end(param1:Event) : *
      {
         var _loc2_:StandardCommand = projconfig.GetStandardCommand(StandardCommand.CMD_VOLUME_DOWN);
         cnx.SendDigital(_loc2_.join,0);
      }
      
      public function resetsource(param1:Event) : *
      {
         var _loc2_:* = parseInt(param1.target.name.replace("reset",""));
         var _loc3_:DLPSource = projconfig.getSourceAt(currentIndex + _loc2_ - 1);
         if(_loc3_ == undefined)
         {
            return;
         }
         cnx.SendSerial(_loc3_.join,"");
      }
      
      public function hidesource(param1:Event) : *
      {
         var _loc2_:* = parseInt(param1.target.name.replace("hide",""));
         var _loc3_:DLPSource = projconfig.getSourceAt(currentIndex + _loc2_ - 1);
         if(_loc3_ == undefined)
         {
            return;
         }
         if(_loc3_.sourceName.substr(0,1) == " ")
         {
            cnx.SendSerial(_loc3_.join,_loc3_.sourceName.substr(1));
         }
         else
         {
            cnx.SendSerial(_loc3_.join," " + _loc3_.sourceName);
         }
      }
      
      public function editsource(param1:Event) : *
      {
         var _loc2_:* = parseInt(param1.target.name.replace("edit",""));
         var _loc3_:int = 1;
         while(_loc3_ < 6)
         {
            SourceList["source" + _loc3_ + "text"].mouseEnabled = _loc2_ == _loc3_?true:false;
            if(SourceList["source" + _loc3_ + "text"].mouseEnabled == true)
            {
               stage.focus = SourceList["source" + _loc3_ + "text"];
               SourceList["source" + _loc3_ + "text"].setSelection(0,SourceList["source" + _loc3_ + "text"].text.length);
            }
            _loc3_++;
         }
      }
      
      public function finishsourceedit(param1:KeyboardEvent) : *
      {
         var _loc5_:* = undefined;
         var _loc6_:String = null;
         var _loc2_:* = param1.target.name.replace("source","");
         var _loc3_:* = parseInt(_loc2_.replace("text",""));
         var _loc4_:DLPSource = projconfig.getSourceAt(currentIndex + _loc3_ - 1);
         if(_loc4_ == undefined)
         {
            return;
         }
         if(param1.keyCode == 13)
         {
            SourceList["source" + _loc3_ + "text"].mouseEnabled = false;
            _loc5_ = _loc4_.join;
            _loc6_ = StripHTML(String(SourceList["source" + _loc3_ + "text"].text));
            cnx.SendSerial(_loc5_,_loc6_);
            stage.focus = null;
            ScrollSourceList(currentIndex);
         }
         if(param1.keyCode == 27)
         {
            SourceList["source" + _loc3_ + "text"].mouseEnabled = false;
            stage.focus = null;
            ScrollSourceList(currentIndex);
         }
      }
      
      public function editlostfocus(param1:Event) : *
      {
         var _loc2_:* = param1.target.name.replace("source","");
         var _loc3_:* = parseInt(_loc2_.replace("text",""));
         SourceList["source" + _loc3_ + "text"].mouseEnabled = false;
         ScrollSourceList(currentIndex);
      }
      
      public function RightArrowButtonDown(param1:MouseEvent) : void
      {
         var _loc2_:StandardCommand = null;
         _loc2_ = projconfig.GetStandardCommand(StandardCommand.CMD_MENU_RIGHT);
         cnx.SendDigital(_loc2_.join,1);
      }
      
      public function RightArrowButtonUp(param1:MouseEvent) : void
      {
         var _loc2_:StandardCommand = null;
         _loc2_ = projconfig.GetStandardCommand(StandardCommand.CMD_MENU_RIGHT);
         cnx.SendDigital(_loc2_.join,0);
      }
      
      public function LeftArrowButtonDown(param1:MouseEvent) : void
      {
         var _loc2_:StandardCommand = null;
         _loc2_ = projconfig.GetStandardCommand(StandardCommand.CMD_MENU_LEFT);
         cnx.SendDigital(_loc2_.join,1);
      }
      
      public function LeftArrowButtonUp(param1:MouseEvent) : void
      {
         var _loc2_:StandardCommand = null;
         _loc2_ = projconfig.GetStandardCommand(StandardCommand.CMD_MENU_LEFT);
         cnx.SendDigital(_loc2_.join,0);
      }
      
      public function UpArrowButtonDown(param1:MouseEvent) : void
      {
         var _loc2_:StandardCommand = null;
         _loc2_ = projconfig.GetStandardCommand(StandardCommand.CMD_MENU_UP);
         cnx.SendDigital(_loc2_.join,1);
      }
      
      public function UpArrowButtonUp(param1:MouseEvent) : void
      {
         var _loc2_:StandardCommand = null;
         _loc2_ = projconfig.GetStandardCommand(StandardCommand.CMD_MENU_UP);
         cnx.SendDigital(_loc2_.join,0);
      }
      
      public function DownArrowButtonDown(param1:MouseEvent) : void
      {
         var _loc2_:StandardCommand = null;
         _loc2_ = projconfig.GetStandardCommand(StandardCommand.CMD_MENU_DOWN);
         cnx.SendDigital(_loc2_.join,1);
      }
      
      public function DownArrowButtonUp(param1:MouseEvent) : void
      {
         var _loc2_:StandardCommand = null;
         _loc2_ = projconfig.GetStandardCommand(StandardCommand.CMD_MENU_DOWN);
         cnx.SendDigital(_loc2_.join,0);
      }
      
      public function linkControls() : *
      {
         var _loc1_:StandardCommand = null;
         powerbtn.btn.addEventListener(MouseEvent.CLICK,powerClick);
         setStandardCommandText(powertext,projconfig.GetStandardCommand(StandardCommand.CMD_POWER_ON));
         SourceList.ScrollUP.addEventListener(MouseEvent.CLICK,scrollSources);
         SourceList.ScrollDOWN.addEventListener(MouseEvent.CLICK,scrollSources);
         Extensions.Left_bttn.addEventListener(MouseEvent.CLICK,scrollExt);
         Extensions.Right_bttn.addEventListener(MouseEvent.CLICK,scrollExt);
         volupbtn.addEventListener(MouseEvent.MOUSE_DOWN,volup_start);
         volupbtn.addEventListener(MouseEvent.MOUSE_UP,volup_end);
         setStandardCommandText(voluptext,projconfig.GetStandardCommand(StandardCommand.CMD_VOLUME_UP));
         mutebtn.addEventListener(MouseEvent.CLICK,sendJoinClick);
         setStandardCommandText(mutetext,projconfig.GetStandardCommand(StandardCommand.CMD_MUTE));
         voldownbtn.addEventListener(MouseEvent.MOUSE_DOWN,voldown_start);
         voldownbtn.addEventListener(MouseEvent.MOUSE_UP,voldown_end);
         setStandardCommandText(voldowntext,projconfig.GetStandardCommand(StandardCommand.CMD_VOLUME_DOWN));
         transportControls.menubtn.addEventListener(MouseEvent.CLICK,sendJoinClick);
         setStandardCommandText(transportControls.menutext,projconfig.GetStandardCommand(StandardCommand.CMD_MENU));
         transportControls.leftbtn.addEventListener(MouseEvent.MOUSE_DOWN,LeftArrowButtonDown);
         transportControls.leftbtn.addEventListener(MouseEvent.MOUSE_UP,LeftArrowButtonUp);
         transportControls.rightbtn.addEventListener(MouseEvent.MOUSE_DOWN,RightArrowButtonDown);
         transportControls.rightbtn.addEventListener(MouseEvent.MOUSE_UP,RightArrowButtonUp);
         transportControls.upbtn.addEventListener(MouseEvent.MOUSE_DOWN,UpArrowButtonDown);
         transportControls.upbtn.addEventListener(MouseEvent.MOUSE_UP,UpArrowButtonUp);
         transportControls.downbtn.addEventListener(MouseEvent.MOUSE_DOWN,DownArrowButtonDown);
         transportControls.downbtn.addEventListener(MouseEvent.MOUSE_UP,DownArrowButtonUp);
         transportControls.okbtn.addEventListener(MouseEvent.CLICK,sendJoinClick);
         setStandardCommandText(transportControls.oktext,projconfig.GetStandardCommand(StandardCommand.CMD_MENU_ENTER));
         transportControls.exitbtn.addEventListener(MouseEvent.CLICK,sendJoinClick);
         setStandardCommandText(transportControls.exittext,projconfig.GetStandardCommand(StandardCommand.CMD_MENU_EXIT));
         HelpBttn.addEventListener(MouseEvent.CLICK,showHelpDesk);
         Extensions.extended1.addEventListener(MouseEvent.CLICK,extendedXClicked);
         Extensions.extended2.addEventListener(MouseEvent.CLICK,extendedXClicked);
         Extensions.extended3.addEventListener(MouseEvent.CLICK,extendedXClicked);
         Extensions.extended4.addEventListener(MouseEvent.CLICK,extendedXClicked);
         SourceList.edit1.addEventListener(MouseEvent.CLICK,editsource);
         SourceList.edit2.addEventListener(MouseEvent.CLICK,editsource);
         SourceList.edit3.addEventListener(MouseEvent.CLICK,editsource);
         SourceList.edit4.addEventListener(MouseEvent.CLICK,editsource);
         SourceList.edit5.addEventListener(MouseEvent.CLICK,editsource);
         SourceList.reset1.addEventListener(MouseEvent.CLICK,resetsource);
         SourceList.reset2.addEventListener(MouseEvent.CLICK,resetsource);
         SourceList.reset3.addEventListener(MouseEvent.CLICK,resetsource);
         SourceList.reset4.addEventListener(MouseEvent.CLICK,resetsource);
         SourceList.reset5.addEventListener(MouseEvent.CLICK,resetsource);
         SourceList.hide1.addEventListener(MouseEvent.CLICK,hidesource);
         SourceList.hide2.addEventListener(MouseEvent.CLICK,hidesource);
         SourceList.hide3.addEventListener(MouseEvent.CLICK,hidesource);
         SourceList.hide4.addEventListener(MouseEvent.CLICK,hidesource);
         SourceList.hide5.addEventListener(MouseEvent.CLICK,hidesource);
         SourceList.source1text.addEventListener(KeyboardEvent.KEY_DOWN,finishsourceedit);
         SourceList.source2text.addEventListener(KeyboardEvent.KEY_DOWN,finishsourceedit);
         SourceList.source3text.addEventListener(KeyboardEvent.KEY_DOWN,finishsourceedit);
         SourceList.source4text.addEventListener(KeyboardEvent.KEY_DOWN,finishsourceedit);
         SourceList.source5text.addEventListener(KeyboardEvent.KEY_DOWN,finishsourceedit);
         SourceList.source1text.addEventListener(FocusEvent.FOCUS_OUT,editlostfocus);
         SourceList.source2text.addEventListener(FocusEvent.FOCUS_OUT,editlostfocus);
         SourceList.source3text.addEventListener(FocusEvent.FOCUS_OUT,editlostfocus);
         SourceList.source4text.addEventListener(FocusEvent.FOCUS_OUT,editlostfocus);
         SourceList.source5text.addEventListener(FocusEvent.FOCUS_OUT,editlostfocus);
         SourceList.source1.addEventListener(MouseEvent.CLICK,source1Clicked);
         SourceList.source2.addEventListener(MouseEvent.CLICK,source2Clicked);
         SourceList.source3.addEventListener(MouseEvent.CLICK,source3Clicked);
         SourceList.source4.addEventListener(MouseEvent.CLICK,source4Clicked);
         SourceList.source5.addEventListener(MouseEvent.CLICK,source5Clicked);
         setStandardCommandText(help_txt,projconfig.GetStandardCommand(StandardCommand.CMD_JUMP_TO_HELP));
         setStandardCommandText(info_txt,projconfig.GetStandardCommand(StandardCommand.CMD_JUMP_TO_INFO));
         setStandardCommandText(tools_txt,projconfig.GetStandardCommand(StandardCommand.CMD_JUMP_TO_TOOLS));
         logout_txt.text = getXMLText("logout_txt");
         tools_txt.text = getXMLText("tools_txt");
         info_txt.text = getXMLText("info_txt");
         help_txt.text = getXMLText("help_txt");
         btnLogout.addEventListener(MouseEvent.CLICK,blogOut);
      }
      
      public function menuExtXclicked(param1:Event) : *
      {
         var _loc2_:uint = parseInt(param1.currentTarget.name.substr(param1.currentTarget.name.length - 1,1)) - 1;
         var _loc3_:StandardCommand = projconfig.GetStandardCommand(StandardCommand.CMD_KEYPAD_EXT1 + _loc2_);
         var _loc4_:StandardCommand = projconfig.GetStandardCommand(StandardCommand.CMD_KEYPAD_EXT1_T + _loc2_);
         if(_loc3_ != undefined && _loc4_ != undefined)
         {
            if(digitals[_loc3_.join] == 1)
            {
               pulseCmd(_loc4_);
            }
            else
            {
               pulseCmd(_loc3_);
            }
         }
         else if(_loc3_ != undefined)
         {
            pulseCmd(_loc3_);
         }
      }
      
      public function setupMenuExt(param1:Object, param2:Object, param3:uint) : *
      {
         var _loc4_:StandardCommand = projconfig.GetStandardCommand(param3);
         if(_loc4_ != undefined && _loc4_.lbl.length > 0)
         {
            ThemeButtonObject(param1,projconfig.ui_color);
            param2.text = _loc4_.lbl;
            param2.autoSize = "center";
            param2.mouseEnabled = false;
         }
      }
      
      public function getDefaultXMLText(param1:String, param2:String = "") : String
      {
         var _loc3_:String = getXMLText(param1);
         if(_loc3_.length == 0)
         {
            return param2;
         }
         return _loc3_;
      }
      
      public function getXMLText(param1:String) : String
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in projconfig.hidden_objects)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_.text;
            }
         }
         return "";
      }
      
      public function applyUiXml() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:Color = null;
         for each(_loc2_ in projconfig.hidden_objects)
         {
            _loc1_ = null;
            _loc3_ = _loc2_.name.split(".");
            if(_loc2_.name.substr(0,8) != "AdminrMC")
            {
               for each(_loc4_ in _loc3_)
               {
                  if(_loc1_ == null)
                  {
                     _loc1_ = this[_loc4_];
                  }
                  else
                  {
                     _loc1_ = _loc1_[_loc4_];
                  }
               }
               if(_loc1_ != null)
               {
                  _loc1_.visible = _loc2_.visible;
                  if(_loc2_.text.toString().length > 0)
                  {
                     _loc1_.text = _loc2_.text;
                  }
                  if(true == _loc2_.setcolor)
                  {
                     _loc5_ = new Color();
                     _loc5_.setTint(_loc2_.color,_loc2_.tint);
                     _loc1_.transform.colorTransform = _loc5_;
                  }
               }
            }
         }
         if(!projconfig.CheckIfVolume())
         {
            coverup2.visible = false;
            voldowntext.visible = false;
            voldownbtn.visible = false;
            mutetext.visible = false;
            mutebtn.visible = false;
            voluptext.visible = false;
            volupbtn.visible = false;
         }
      }
      
      public function link1Clicked(param1:Event) : *
      {
         var e:Event = param1;
         var url:String = projconfig.link1;
         var request:URLRequest = new URLRequest(url);
         try
         {
            navigateToURL(request,"_blank");
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      public function link2Clicked(param1:Event) : *
      {
         var e:Event = param1;
         var url:String = projconfig.link2;
         var request:URLRequest = new URLRequest(url);
         try
         {
            navigateToURL(request,"_blank");
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      public function link2Over(param1:Event) : *
      {
         var _loc2_:Color = new Color();
         _loc2_.setTint(projconfig.ui_color,0.6);
         expansion.transform.colorTransform = _loc2_;
      }
      
      public function link2Out(param1:Event) : *
      {
         expansion.transform.colorTransform = new Color();
      }
      
      public function configLoaded(param1:Event) : *
      {
         loadingMC.setText("Configuring...");
         SetupTheme(projconfig.ui_color);
         modeltext.text = projconfig.modelnum;
         modeltext.autoSize = "left";
         modeltext.mouseEnabled = false;
         compline1text.text = projconfig.company_name;
         compline2text.text = projconfig.company_logo;
         transportControls.visible = !projconfig.ui_hidetransport;
         ScrollSourceList(0);
         ScrollExtList(0);
         linkControls();
         if(projconfig.company_banner.length > 0)
         {
            loadLogo(projconfig.company_banner);
         }
         setupMenuExt(transportControls.btnExt1,transportControls.lblExt1,StandardCommand.CMD_KEYPAD_EXT1);
         transportControls.btnExt1.addEventListener(MouseEvent.CLICK,menuExtXclicked);
         setupMenuExt(transportControls.btnExt2,transportControls.lblExt2,StandardCommand.CMD_KEYPAD_EXT2);
         transportControls.btnExt2.addEventListener(MouseEvent.CLICK,menuExtXclicked);
         setupMenuExt(transportControls.btnExt3,transportControls.lblExt3,StandardCommand.CMD_KEYPAD_EXT3);
         transportControls.btnExt3.addEventListener(MouseEvent.CLICK,menuExtXclicked);
         setupMenuExt(transportControls.btnExt4,transportControls.lblExt4,StandardCommand.CMD_KEYPAD_EXT4);
         transportControls.btnExt4.addEventListener(MouseEvent.CLICK,menuExtXclicked);
         applyUiXml();
         btnRoomView.addEventListener(MouseEvent.CLICK,link1Clicked);
         expansion.addEventListener(MouseEvent.CLICK,link2Clicked);
         expansion.addEventListener(MouseEvent.MOUSE_OVER,link2Over);
         expansion.addEventListener(MouseEvent.MOUSE_OUT,link2Out);
         var _loc2_:String = getDefaultXMLText("lblConnecting","Connecting...");
         loadingMC.setText(_loc2_);
         if(!cnx.connected)
         {
            cnx.cnxConnect(ipaddr,ipid,41794,9);
         }
         if(2 == AdminrMC.currentFrame)
         {
            AdminrMC.local_applyUiXml();
         }
         if(!projconfig.CheckIfVolume())
         {
            coverup2.visible = false;
            voldowntext.visible = false;
            voldownbtn.visible = false;
            mutetext.visible = false;
            mutebtn.visible = false;
            voluptext.visible = false;
            volupbtn.visible = false;
         }
      }
      
      public function loadLogo(param1:String) : *
      {
         var _loc2_:URLRequest = new URLRequest(param1);
         ldr = new Loader();
         ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,loadedLogo);
         ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,failed_to_load);
         ldr.load(_loc2_);
      }
      
      public function failed_to_load(param1:Event) : *
      {
      }
      
      public function loadedLogo(param1:Event) : *
      {
         hdrLoader.addChild(ldr);
         compline1text.text = "";
         compline2text.text = "";
      }
      
      public function conxError(param1:Event) : *
      {
         var _loc2_:String = getDefaultXMLText("lblConnectingErr","Connection Error");
         loadingMC.setText(_loc2_);
         conTimer.stop();
      }
      
      public function onConnect(param1:Event) : *
      {
         digitals = new Array();
         analogs = new Array();
         serials = new Array();
         InfoMC.lcl_serials = serials;
         InfoMC.lcl_digitals = digitals;
         ToolsMC.lcl_serials = serials;
         ToolsMC.lcl_digitals = digitals;
         retryConTimer.stop();
         var _loc2_:String = getDefaultXMLText("lblWaiting","Waiting...");
         loadingMC.setText(_loc2_);
         conTimer.start();
         var _loc3_:String = Capabilities.language.substr(0,2).toLowerCase();
         var _loc4_:String = Capabilities.language;
         if(_loc4_.indexOf("zh") > -1)
         {
            _loc3_ = Capabilities.language.substr(0,5).toLowerCase();
         }
         cnx.SendSerial(5090,_loc3_);
         var _loc5_:DigitalEvent = new DigitalEvent(CNXConnection.DIGITAL,5,false);
         onDigital(_loc5_);
      }
      
      public function RestartDevice(param1:Event) : *
      {
         bDisableRetry = false;
         if(cnx != undefined && cnx != null)
         {
            cnx.cnxDisconnect();
         }
         cnx = new CNXConnection();
         cnx.addEventListener(CNXConnection.DIGITAL,onDigital);
         cnx.addEventListener(CNXConnection.ANALOG,onAnalog);
         cnx.addEventListener(CNXConnection.SERIAL,onSerial);
         cnx.addEventListener(CNXConnection.CONNECT,onConnect);
         cnx.addEventListener(IOErrorEvent.IO_ERROR,onDisconnect);
         cnx.addEventListener(Event.CLOSE,onDisconnect);
         cnx.addEventListener(CNXConnection.DISCONNECT,onDisconnect);
         cnx.cnxConnect(ipaddr,ipid,41794,9);
      }
      
      public function ipInfoChanged(param1:String) : *
      {
         logOut(null);
         if(param1.length == 0)
         {
            ipaddr = "";
            bDisableRetry = true;
            loadingMC.setText(projconfig.dhcp_msg);
         }
         else
         {
            ipaddr = param1;
            loadingMC.setText(projconfig.staticmsg);
            bDisableRetry = true;
            RestartDeviceTimer.delay = projconfig.restart_time * 1000;
            RestartDeviceTimer.start();
         }
      }
      
      public function retryCon(param1:Event) : *
      {
         cnx = new CNXConnection();
         cnx.addEventListener(CNXConnection.DIGITAL,onDigital);
         cnx.addEventListener(CNXConnection.ANALOG,onAnalog);
         cnx.addEventListener(CNXConnection.SERIAL,onSerial);
         cnx.addEventListener(CNXConnection.CONNECT,onConnect);
         cnx.addEventListener(IOErrorEvent.IO_ERROR,onDisconnect);
         cnx.addEventListener(Event.CLOSE,onDisconnect);
         cnx.addEventListener(CNXConnection.DISCONNECT,onDisconnect);
         cnx.cnxConnect(ipaddr,ipid,41794,9);
      }
      
      public function onDisconnect(param1:Event) : *
      {
         if(true == bDisableRetry)
         {
            return;
         }
         var _loc2_:String = getDefaultXMLText("lblRetrying","Retrying...");
         loadingMC.setText("Retrying...");
         retryConTimer.reset();
         retryConTimer.start();
      }
      
      public function onSerial(param1:SerialEvent) : *
      {
         var _loc3_:String = null;
         serials[param1.Join] = param1.Value;
         var _loc2_:StandardCommand = projconfig.GetStandardCommand(StandardCommand.CMD_HELP_MSG);
         if(_loc2_ != undefined && _loc2_.join == param1.Join)
         {
            if(param1.Value.length < 1)
            {
               return;
            }
            HelpDesk.setMsg(param1.Value);
            if(HelpDesk.currentFrame == 1)
            {
               if(false == loggedIn)
               {
                  return;
               }
               msgTimer.start();
            }
         }
         if(param1.Join == 22)
         {
            EmergencyMC.setMsg(param1.Value);
         }
         if(param1.Join > 5069 && param1.Join < 5085)
         {
            if(param1.Value.length > 0)
            {
               _loc3_ = StripHTML(String(param1.Value));
               projconfig.AddSource(_loc3_,param1.Join - 5070,param1.Join);
               ScrollSourceList(currentIndex);
            }
         }
         InfoMC.onSerial(param1);
      }
      
      public function showAdminPasswordPrompt() : *
      {
         AdminrMC.pwordType = 2;
         AdminrMC.gotoAndStop(2);
      }
      
      public function showUserPasswordPrompt() : *
      {
         btnLogout.visible = true;
         logout_txt.visible = true;
         AdminrMC.pwordType = 1;
         AdminrMC.gotoAndStop(2);
      }
      
      public function canEditSources() : Boolean
      {
         if(projconfig.canedit == false)
         {
            return false;
         }
         var _loc1_:int = LOGIN_ADMIN;
         if(digitals[5217] == true)
         {
            _loc1_ = LOGIN_USER;
         }
         if(digitals[5213] == true && digitals[5217] == true)
         {
            _loc1_ = LOGIN_NONE;
         }
         return loginLevel >= _loc1_;
      }
      
      public function checkForLoginButton() : void
      {
         if(required_level == LOGIN_NONE)
         {
            btnLogout.visible = false;
            logout_txt.visible = false;
         }
      }
      
      public function logIn(param1:Event, param2:int) : *
      {
         loggedIn = true;
         if(param2 > loginLevel)
         {
            loginLevel = param2;
         }
         if(digitals[5217] == true)
         {
            required_level = LOGIN_USER;
         }
         if(digitals[5213] == true && digitals[5217] == true)
         {
            required_level = LOGIN_NONE;
            checkForLoginButton();
         }
         ScrollSourceList(currentIndex);
         if(digitals[5213] == true && digitals[5217] == true)
         {
            btnLogout.visible = false;
            logout_txt.visible = false;
         }
         else if(digitals[5212] == true && loginLevel >= LOGIN_USER)
         {
            btnLogout.visible = true;
            logout_txt.visible = true;
         }
         else if(digitals[5216] == true && loginLevel >= LOGIN_ADMIN)
         {
            btnLogout.visible = true;
            logout_txt.visible = true;
         }
         else
         {
            btnLogout.visible = false;
            logout_txt.visible = false;
         }
         btnLogout.mouseEnabled = true;
         HelpBttn.mouseEnabled = true;
         InfoBttn.mouseEnabled = true;
         ToolsBttn.mouseEnabled = true;
         showToolsPage(false);
         showInfoPage(false);
         hidePasswordPrompt();
      }
      
      public function blogOut(param1:Event) : *
      {
         if(inEmergency())
         {
            return;
         }
         logOut(param1);
      }
      
      public function logOut(param1:Event) : *
      {
         loginLevel = LOGIN_NONE;
         loggedIn = false;
         currentIndex = 0;
         if(digitals[5217] == true && digitals[5213] == true)
         {
            logIn(null,LOGIN_ADMIN);
            return;
         }
         if(digitals[5213] == true)
         {
            logIn(null,LOGIN_USER);
            return;
         }
         btnLogout.mouseEnabled = false;
         HelpBttn.mouseEnabled = false;
         InfoBttn.mouseEnabled = false;
         ToolsBttn.mouseEnabled = false;
         if(HelpDesk.currentFrame > 1)
         {
            HelpDesk.gotoAndPlay("close");
         }
         showToolsPage(false);
         showInfoPage(false);
         showUserPasswordPrompt();
      }
      
      public function hidePasswordPrompt() : *
      {
         AdminrMC.pwordType = 0;
         AdminrMC.gotoAndStop(1);
      }
      
      public function inEmergency() : Boolean
      {
         if(EmergencyMC.currentFrame == 2)
         {
            return true;
         }
         return false;
      }
      
      public function SetEmergencyMode() : *
      {
         if(EmergencyMC.currentFrame == 2)
         {
            return;
         }
         logIn(null,LOGIN_USER);
         EmergencyMC.gotoAndPlay(2);
      }
      
      public function ClearEmergencyMode() : *
      {
         if(EmergencyMC.currentFrame != 2)
         {
            return;
         }
         EmergencyMC.gotoAndPlay(1);
         logOut(null);
      }
      
      public function getPowerState() : Boolean
      {
         var _loc1_:StandardCommand = projconfig.GetStandardCommand(StandardCommand.CMD_POWER_ON);
         if(_loc1_ != undefined)
         {
            return digitals[_loc1_.join];
         }
         return false;
      }
      
      public function showPower(param1:Boolean) : *
      {
         if(true == param1)
         {
            coverup.visible = false;
            coverup2.visible = false;
            SetObjectHighlight(powerbtn,projconfig.ui_color);
         }
         else
         {
            showToolsPage(false);
            showInfoPage(false);
            coverup.visible = true;
            if(!projconfig.bVolumnIsHidden)
            {
               coverup2.visible = true;
            }
            else
            {
               coverup2.visible = false;
            }
            ClearObjectHighlight(powerbtn);
         }
      }
      
      public function onDigital(param1:DigitalEvent) : *
      {
         var _loc2_:uint = getActiveSource();
         digitals[param1.Join] = param1.Value;
         var _loc3_:Boolean = false;
         if(getActiveSource() != _loc2_)
         {
            _loc3_ = true;
         }
         if(2 == AdminrMC.currentFrame)
         {
            AdminrMC.onDigital(param1);
         }
         if(param1.Join == DIG_PROMPT_PASSWORD && param1.Value)
         {
            loadingMC.gotoAndStop(1);
            conTimer.stop();
            logOut(null);
            return;
         }
         if(param1.Join == 5213)
         {
            loadingMC.gotoAndStop(1);
            conTimer.stop();
            logOut(null);
         }
         if(param1.Join == 5217 || param1.Join == 5216 || param1.Join == 5213 || param1.Join == 5212)
         {
            logOut(null);
         }
         if(param1.Join == DIG_USR_PWD_CORRECT && param1.Value)
         {
            if(AdminrMC.WaitingForUserPassword())
            {
               logIn(null,LOGIN_USER);
            }
            return;
         }
         if(param1.Join == DIG_ADM_PWD_CORRECT && param1.Value)
         {
            if(AdminrMC.WaitingForAdminPassword())
            {
               logIn(null,LOGIN_ADMIN);
               showInfoPage(false);
               showToolsPage(true);
            }
            else if(AdminrMC.WaitingForUserPassword())
            {
               logIn(null,LOGIN_ADMIN);
            }
         }
         var _loc4_:StandardCommand = projconfig.GetStandardCommand(StandardCommand.CMD_WARMING_UP);
         if(_loc4_ != undefined && _loc4_.join == param1.Join)
         {
            if(param1.Value == true)
            {
               warmingPopup.showwarming(true);
            }
            else
            {
               warmingPopup.closewarming();
            }
         }
         if(param1.Join == 5161)
         {
            if(param1.Value == true)
            {
               warmingPopup.showwarming(false);
            }
            else
            {
               warmingPopup.closewarming();
            }
         }
         _loc4_ = projconfig.GetStandardCommand(StandardCommand.CMD_POWER_ON);
         if(_loc4_ != undefined && _loc4_.join == param1.Join)
         {
            showPower(param1.Value);
         }
         _loc4_ = projconfig.GetStandardCommand(StandardCommand.CMD_MUTE);
         if(_loc4_ != undefined && _loc4_.join == param1.Join)
         {
            if(param1.Value)
            {
               SetObjectHighlight(mutebtn,projconfig.ui_color);
            }
            else
            {
               ClearObjectHighlight(mutebtn);
            }
         }
         _loc4_ = projconfig.GetStandardCommand(StandardCommand.CMD_KEYPAD_EXT1);
         if(_loc4_ != undefined && _loc4_.join == param1.Join)
         {
            if(param1.Value)
            {
               SetObjectHighlight(transportControls.btnExt1,projconfig.ui_color);
            }
            else
            {
               ClearObjectHighlight(transportControls.btnExt1);
            }
         }
         _loc4_ = projconfig.GetStandardCommand(StandardCommand.CMD_KEYPAD_EXT2);
         if(_loc4_ != undefined && _loc4_.join == param1.Join)
         {
            if(param1.Value)
            {
               SetObjectHighlight(transportControls.btnExt2,projconfig.ui_color);
            }
            else
            {
               ClearObjectHighlight(transportControls.btnExt2);
            }
         }
         _loc4_ = projconfig.GetStandardCommand(StandardCommand.CMD_KEYPAD_EXT3);
         if(_loc4_ != undefined && _loc4_.join == param1.Join)
         {
            if(param1.Value)
            {
               SetObjectHighlight(transportControls.btnExt3,projconfig.ui_color);
            }
            else
            {
               ClearObjectHighlight(transportControls.btnExt3);
            }
         }
         _loc4_ = projconfig.GetStandardCommand(StandardCommand.CMD_KEYPAD_EXT4);
         if(_loc4_ != undefined && _loc4_.join == param1.Join)
         {
            if(param1.Value)
            {
               SetObjectHighlight(transportControls.btnExt4,projconfig.ui_color);
            }
            else
            {
               ClearObjectHighlight(transportControls.btnExt4);
            }
         }
         ScrollSourceList(currentIndex);
         ScrollExtList(currentExtIndex,_loc3_);
      }
      
      public function setEmergencyType() : *
      {
         EmergencyMC.setEmergencyType(emergencyType);
      }
      
      public function onAnalog(param1:AnalogEvent) : *
      {
         var _loc3_:uint = 0;
         analogs[param1.Join] = param1.Value;
         if(param1.Join == 5013)
         {
            disabledAnalog = param1.Value;
            ScrollExtList(currentExtIndex,true);
         }
         if(param1.Join == 22)
         {
            switch(param1.Value)
            {
               case 0:
                  emergencyType = "";
                  break;
               case 1:
                  emergencyType = getXMLText("e_General");
                  if(emergencyType.length == 0)
                  {
                     emergencyType = "General";
                  }
                  break;
               case 2:
                  emergencyType = getXMLText("e_Building");
                  if(emergencyType.length == 0)
                  {
                     emergencyType = "Building";
                  }
                  break;
               case 3:
                  emergencyType = getXMLText("e_Environmental");
                  if(emergencyType.length == 0)
                  {
                     emergencyType = "Environmental";
                  }
                  break;
               case 4:
                  emergencyType = getXMLText("e_Fire");
                  if(emergencyType.length == 0)
                  {
                     emergencyType = "Fire";
                  }
                  break;
               case 5:
                  emergencyType = getXMLText("e_Medical");
                  if(emergencyType.length == 0)
                  {
                     emergencyType = "Medical";
                  }
                  break;
               case 6:
                  emergencyType = getXMLText("e_Police");
                  if(emergencyType.length == 0)
                  {
                     emergencyType = "Police";
                  }
                  break;
               case 7:
                  emergencyType = getXMLText("e_Safety");
                  if(emergencyType.length == 0)
                  {
                     emergencyType = "Safety";
                  }
                  break;
               case 8:
                  emergencyType = getXMLText("e_Weather");
                  if(emergencyType.length == 0)
                  {
                     emergencyType = "Weather";
                  }
            }
            setEmergencyType();
            if(param1.Value != 0)
            {
               SetEmergencyMode();
            }
            else
            {
               EmergencyMC.setMsg("");
               ClearEmergencyMode();
            }
            return;
         }
         var _loc2_:StandardCommand = projconfig.GetStandardCommand(StandardCommand.CMD_VOLUME);
         if(_loc2_ != undefined)
         {
            if(_loc2_.join == param1.Join)
            {
               _loc3_ = param1.Value / 65535 * 255;
               showVolumeBar(_loc3_);
            }
         }
      }
      
      function frame1() : *
      {
         temp_ipaddr = "172.30.192.21";
         temp_ipid = "03";
         bUseTempIpaddr = false;
         hightlight_x_size = 7;
         hightlight_y_size = 7;
         loggedIn = false;
         ToolsBttn.mouseEnabled = false;
         InfoBttn.mouseEnabled = false;
         HelpBttn.mouseEnabled = false;
         stage.stageFocusRect = false;
         powerbtn.tabEnabled = false;
         powerbtn.focusRect = false;
         voldownbtn.tabEnabled = false;
         mutebtn.tabEnabled = false;
         volupbtn.tabEnabled = false;
         expansion.buttonMode = true;
         expansion.useHandCursor = true;
         Extensions.leftarrow.mouseEnabled = false;
         Extensions.rightarrow.mouseEnabled = false;
         coverup.alpha = 0.5;
         coverup2.alpha = 0.5;
         SourceList.upsource.mouseEnabled = false;
         SourceList.downsource.mouseEnabled = false;
         versiontext.text = "Interface " + verstr;
         stop();
         my_cm = new ContextMenu();
         my_cm.hideBuiltInItems();
         this.menu = my_cm;
         this.contextMenu = my_cm;
         this.tabEnabled = false;
         this.tabChildren = false;
         tools_txt.mouseEnabled = false;
         info_txt.mouseEnabled = false;
         transportControls.menutext.mouseEnabled = false;
         transportControls.exittext.mouseEnabled = false;
         InfoBttn.addEventListener(MouseEvent.CLICK,info);
         ToolsBttn.addEventListener(MouseEvent.CLICK,tools);
         powertext.mouseEnabled = false;
         powertext.autoSize = "center";
         compline1text.text = "";
         compline2text.text = "";
         txts = new Array();
         if(HelpBttn.visible != false || help_txt.visible != false)
         {
            msgTimer = new Timer(750);
            msgTimer.addEventListener(TimerEvent.TIMER,flashMsg);
         }
         volTimer = new Timer(3000);
         volTimer.addEventListener(TimerEvent.TIMER,hideVolumeBar);
         extCmd = undefined;
         currentIndex = 0;
         currentExtIndex = 0;
         transportControls.leftgf.mouseEnabled = false;
         transportControls.lefttext.mouseEnabled = false;
         transportControls.upgf.mouseEnabled = false;
         transportControls.uptext.mouseEnabled = false;
         transportControls.rightgf.mouseEnabled = false;
         transportControls.righttext.mouseEnabled = false;
         transportControls.downgfx.mouseEnabled = false;
         transportControls.downtext.mouseEnabled = false;
         projconfig = new DLPConfig();
         projconfig.addEventListener(Event.COMPLETE,configLoaded);
         loadingMC.gotoAndStop(12);
         projconfig.Load();
         txti = 1;
         while(txti < 6)
         {
            SetSourceText("",txti);
            SourceList["source" + txti + "text"].mouseEnabled = false;
            txti++;
         }
         exti = 1;
         while(exti < 5)
         {
            SetExtText("",exti);
            Extensions["extended" + exti + "text"].mouseEnabled = false;
            Extensions["extended" + exti + "text"].autoSize = "center";
            exti++;
         }
         cnx = new CNXConnection();
         digitals = new Array();
         analogs = new Array();
         serials = new Array();
         InfoMC.lcl_serials = serials;
         InfoMC.lcl_digitals = digitals;
         ToolsMC.lcl_serials = serials;
         ToolsMC.lcl_digitals = digitals;
         ipaddr = this.loaderInfo.url.substr(0,this.loaderInfo.url.lastIndexOf("/"));
         ipaddr = ipaddr.substr(ipaddr.indexOf("//") + 2,ipaddr.length);
         slashpos = 0;
         slashpos = ipaddr.indexOf("/");
         if(-1 != slashpos)
         {
            ipaddr = ipaddr.substr(0,slashpos - 0);
         }
         ipid = "03";
         if(bUseTempIpaddr)
         {
            ipaddr = temp_ipaddr;
            ipid = temp_ipid;
         }
         cnx.addEventListener(CNXConnection.DIGITAL,onDigital);
         cnx.addEventListener(CNXConnection.ANALOG,onAnalog);
         cnx.addEventListener(CNXConnection.SERIAL,onSerial);
         cnx.addEventListener(CNXConnection.CONNECT,onConnect);
         cnx.addEventListener(IOErrorEvent.IO_ERROR,onDisconnect);
         cnx.addEventListener(Event.CLOSE,onDisconnect);
         cnx.addEventListener(CNXConnection.DISCONNECT,onDisconnect);
         conTimer = new Timer(15000);
         conTimer.addEventListener(TimerEvent.TIMER,conxError);
         bDisableRetry = false;
         RestartDeviceTimer = new Timer(30000,1);
         RestartDeviceTimer.addEventListener(TimerEvent.TIMER,RestartDevice);
         retryConTimer = new Timer(5000,1);
         retryConTimer.addEventListener(TimerEvent.TIMER,retryCon);
         required_level = LOGIN_ADMIN;
         loginLevel = LOGIN_NONE;
         logOut(null);
         emergencyType = "";
         disabledAnalog = 0;
      }
   }
}
