package CrestronDLP
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.Capabilities;
   
   public class DLPConfig
   {
       
      
      var loader:URLLoader;
      
      public var company_name:String;
      
      public var company_logo:String;
      
      public var company_banner:String;
      
      public var restart_time:uint;
      
      public var dhcp_msg:String;
      
      public var staticmsg:String;
      
      public var link1:String;
      
      public var link2:String;
      
      public var ui_color:Number = 0;
      
      public var ui_hidetransport:Boolean = false;
      
      public var modelnum:String = "";
      
      public var hasdhcp:String = "";
      
      public var canedit:Boolean = false;
      
      public var langid:String = "";
      
      public var sources:Array;
      
      public var standardcommands:Array;
      
      public var extendedcommands:Array;
      
      public var langs:Array;
      
      public var hidden_objects:Array;
      
      public var xml:XML;
      
      public var bVolumnIsHidden:Boolean = false;
      
      public var external_files:Array;
      
      public var hasDefaultLanguage:Boolean = false;
      
      protected var disp:EventDispatcher;
      
      public function DLPConfig()
      {
         sources = new Array();
         standardcommands = new Array();
         extendedcommands = new Array();
         langs = new Array();
         hidden_objects = new Array();
         xml = new XML();
         external_files = new Array();
         super();
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         if(disp == null)
         {
            disp = new EventDispatcher();
         }
         disp.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         if(disp == null)
         {
            return;
         }
         disp.removeEventListener(param1,param2,param3);
      }
      
      public function dispatchEvent(param1:Event) : void
      {
         if(disp == null)
         {
            return;
         }
         disp.dispatchEvent(param1);
      }
      
      public function CrestronDLPConfig() : *
      {
      }
      
      public function Load() : *
      {
         loader = new URLLoader();
         loader.addEventListener(Event.COMPLETE,OnXmlLoaded);
         loader.addEventListener(IOErrorEvent.IO_ERROR,LoadFailed);
         if(langid == "")
         {
            langid = Capabilities.language;
         }
         var _loc1_:* = "CrestronDLPConfig";
         if(langid != "en")
         {
            _loc1_ = _loc1_ + ("_" + langid);
         }
         _loc1_ = _loc1_ + ".xml";
         loader.load(new URLRequest(_loc1_));
      }
      
      public function SetLanguage(param1:String) : *
      {
         if(langid == param1)
         {
            return;
         }
         if(langid == "")
         {
            langid = "en";
         }
         langid = param1;
         Load();
      }
      
      private function LoadFailed(param1:Event) : *
      {
         loader = new URLLoader();
         loader.addEventListener(Event.COMPLETE,OnXmlLoaded);
         loader.load(new URLRequest("CrestronDLPConfig.xml"));
      }
      
      private function OnXmlLoaded(param1:Event) : *
      {
         var rts:String = null;
         var e:Event = param1;
         xml = new XML(e.target.data);
         company_name = xml.company[0].@name;
         company_logo = xml.company[0].@logo;
         company_banner = xml.company[0].@banner;
         try
         {
            link1 = xml.ui[0].@link1;
            link2 = xml.ui[0].@link2;
         }
         catch(e:Error)
         {
         }
         try
         {
            staticmsg = xml.msg[0].@static;
            dhcp_msg = xml.msg[0].@dhcp;
         }
         catch(e:Error)
         {
         }
         if(dhcp_msg.length < 1)
         {
            dhcp_msg = "Ip Address has changed";
         }
         if(staticmsg.length < 1)
         {
            staticmsg = "Device restarting";
         }
         modelnum = xml.device.@model;
         hasdhcp = xml.device.@hasdhcp;
         restart_time = 30;
         try
         {
            rts = xml.device[0].@restartlen;
            if(rts.length > 0)
            {
               restart_time = parseInt(rts);
            }
         }
         catch(e:Error)
         {
            restart_time = 30;
         }
         if(restart_time < 1 || restart_time > 120)
         {
            restart_time = 30;
         }
         ui_color = xml.ui[0].@color;
         if(xml.ui[0].@hidetransport == true)
         {
            ui_hidetransport = true;
         }
         try
         {
            if(xml.ui[0].@edit == "1")
            {
               canedit = true;
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            if(xml.ui[0].@deflang == "1")
            {
               hasDefaultLanguage = true;
            }
         }
         catch(e:Error)
         {
         }
         CheckIfVolumeButtonsAreHidden(xml);
         LoadStandardCommands(xml);
         LoadExtendedCommands(xml);
         LoadHiddenElements(xml);
         LoadLanguages(xml);
         LoadExternalFiles(xml);
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function CheckIfVolumeButtonsAreHidden(param1:XML) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Boolean = true;
         _loc2_ = 0;
         while(_loc2_ < param1.ui_elems[0].ui_elem.length())
         {
            if(param1.ui_elems[0].ui_elem[_loc2_].@name == "voldownbtn")
            {
               if(param1.ui_elems[0].ui_elem[_loc2_].@hidden == "true")
               {
                  _loc3_ = false;
               }
               break;
            }
            _loc2_++;
         }
         var _loc4_:Boolean = true;
         _loc2_ = 0;
         while(_loc2_ < param1.ui_elems[0].ui_elem.length())
         {
            if(param1.ui_elems[0].ui_elem[_loc2_].@name == "volupbtn")
            {
               if(param1.ui_elems[0].ui_elem[_loc2_].@hidden == "true")
               {
                  _loc4_ = false;
               }
               break;
            }
            _loc2_++;
         }
         var _loc5_:Boolean = true;
         _loc2_ = 0;
         while(_loc2_ < param1.ui_elems[0].ui_elem.length())
         {
            if(param1.ui_elems[0].ui_elem[_loc2_].@name == "mutebtn")
            {
               if(param1.ui_elems[0].ui_elem[_loc2_].@hidden == "true")
               {
                  _loc5_ = false;
               }
               break;
            }
            _loc2_++;
         }
         if(!_loc3_ && !_loc4_ && !_loc5_)
         {
            bVolumnIsHidden = true;
         }
      }
      
      public function CheckIfVolume() : Boolean
      {
         var _loc1_:Boolean = true;
         if(bVolumnIsHidden)
         {
            _loc1_ = false;
         }
         return _loc1_;
      }
      
      public function GetStandardCommand(param1:uint) : *
      {
         return standardcommands[param1];
      }
      
      public function GetStandardCommandsForJoin(param1:uint) : Array
      {
         var _loc3_:StandardCommand = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in standardcommands)
         {
            if(_loc3_.join == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function GetSourcesForJoin(param1:uint) : Array
      {
         var _loc3_:DLPSource = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in sources)
         {
            if(_loc3_.join == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function GetExternalFiles() : Array
      {
         return external_files;
      }
      
      private function LoadExternalFiles(param1:XML) : void
      {
         var i:uint = 0;
         var xml:XML = param1;
         try
         {
            i = 0;
            while(i < xml.external_files[0].external_file.length())
            {
               external_files.push(xml.external_files[0].external_file[i].@src);
               i++;
            }
            return;
         }
         catch(e:Error)
         {
            external_files.push("None");
            return;
         }
      }
      
      private function LoadLanguages(param1:XML) : *
      {
         var _loc3_:Object = null;
         langs = new Array();
         var _loc2_:uint = param1.langs.*.length();
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = new Object();
            _loc3_.name = param1.langs.lang[_loc4_].@name;
            _loc3_.ident = param1.langs.lang[_loc4_].@ident;
            langs.push(_loc3_);
            _loc4_++;
         }
      }
      
      public function CheckInfoHide(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:uint = 0;
         while(_loc3_ < xml.ui_elems[0].ui_elem.length())
         {
            if(xml.ui_elems[0].ui_elem[_loc3_].@name == param1)
            {
               if(xml.ui_elems[0].ui_elem[_loc3_].@show_item == "true")
               {
                  _loc2_ = false;
               }
               else
               {
                  _loc2_ = true;
               }
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function CheckForTextEdit(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:uint = 0;
         while(_loc3_ < xml.ui_elems[0].ui_text_limit.length())
         {
            if(xml.ui_elems[0].ui_text_limit[_loc3_].@name == param1)
            {
               if(xml.ui_elems[0].ui_text_limit[_loc3_].@can_edit == "true")
               {
                  _loc2_ = true;
               }
               else
               {
                  _loc2_ = false;
               }
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function chkDHCP_Edit() : Boolean
      {
         var _loc1_:Boolean = true;
         if(xml.ui_elems[0].ui_chkDHCP_Edit[0].@can_edit == "true")
         {
            _loc1_ = true;
         }
         else
         {
            _loc1_ = false;
         }
         return _loc1_;
      }
      
      public function GetToolTextLimit(param1:String) : uint
      {
         var _loc2_:uint = 10;
         var _loc3_:uint = 0;
         while(_loc3_ < xml.ui_elems[0].ui_text_limit.length())
         {
            if(xml.ui_elems[0].ui_text_limit[_loc3_].@name == param1)
            {
               _loc2_ = uint(xml.ui_elems[0].ui_text_limit[_loc3_].@char_limit);
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function CanShowVolumeBar() : Boolean
      {
         var _loc1_:Boolean = true;
         if(xml.volume_bar_visibility[0].@show_bar == false)
         {
            _loc1_ = false;
         }
         return _loc1_;
      }
      
      public function ShowTestOutput() : Boolean
      {
         var _loc1_:Boolean = false;
         if(xml.show_test_output[0].@show == "true")
         {
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      private function LoadHiddenElements(param1:XML) : void
      {
         var _loc3_:Object = null;
         var _loc2_:uint = param1.ui_elems.ui_elem.length();
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = new Object();
            if(param1.ui_elems.ui_elem[_loc4_].@hidden == "true")
            {
               _loc3_.visible = false;
            }
            else
            {
               _loc3_.visible = true;
            }
            _loc3_.text = param1.ui_elems.ui_elem[_loc4_].@text;
            _loc3_.name = param1.ui_elems.ui_elem[_loc4_].@name;
            _loc3_.icon = param1.ui_elems.ui_elem[_loc4_].@icon;
            _loc3_.setcolor = false;
            if("@color" in param1.ui_elems.ui_elem[_loc4_])
            {
               _loc3_.setcolor = true;
               _loc3_.color = param1.ui_elems.ui_elem[_loc4_].@color;
            }
            _loc3_.tint = 1;
            if("@tint" in param1.ui_elems.ui_elem[_loc4_])
            {
               _loc3_.tint = param1.ui_elems.ui_elem[_loc4_].@tint;
            }
            hidden_objects.push(_loc3_);
            _loc4_++;
         }
      }
      
      private function LoadStandardCommands(param1:XML) : *
      {
         var _loc4_:String = null;
         var _loc5_:StandardCommand = null;
         var _loc2_:uint = param1.scs.*.length();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = "";
            _loc4_ = param1.scs.sc[_loc3_].@btnlabel;
            _loc5_ = new StandardCommand(param1.scs.sc[_loc3_].@name,param1.scs.sc[_loc3_].@join,_loc4_);
            if(_loc5_.cmd != StandardCommand.CMD_NONE)
            {
               standardcommands[_loc5_.cmd] = _loc5_;
            }
            _loc3_++;
         }
      }
      
      private function LoadExtendedCommands(param1:XML) : *
      {
         var _loc4_:ExtendedCommand = null;
         var _loc2_:uint = param1.ecs.*.length();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new ExtendedCommand(param1.ecs.ec[_loc3_]);
            extendedcommands[_loc4_.cmdidx] = _loc4_;
            _loc3_++;
         }
      }
      
      public function AddSource(param1:String, param2:uint, param3:uint) : *
      {
         var _loc4_:DLPSource = new DLPSource(param1,param3,param2);
         sources[_loc4_.index] = _loc4_;
      }
      
      public function getVisibleSourceCount() : uint
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < 17)
         {
            if(!isSourceHidden(_loc2_))
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getVisibleSourceAt(param1:uint) : DLPSource
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < 17)
         {
            if(!isSourceHidden(_loc3_))
            {
               if(_loc2_ == param1)
               {
                  return sources[_loc3_];
               }
               _loc2_++;
            }
            _loc3_++;
         }
         return undefined;
      }
      
      public function isSourceHidden(param1:uint) : Boolean
      {
         var _loc2_:DLPSource = sources[param1];
         if(_loc2_ == undefined)
         {
            return true;
         }
         if(_loc2_.sourceName.substr(0,1) == " ")
         {
            return true;
         }
         return false;
      }
      
      public function getSourceAt(param1:uint) : DLPSource
      {
         return sources[param1];
      }
   }
}
