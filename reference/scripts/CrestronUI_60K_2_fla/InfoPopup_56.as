package CrestronUI_60K_2_fla
{
   import Crestron.SerialEvent;
   import CrestronDLP.StandardCommand;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public dynamic class InfoPopup_56 extends MovieClip
   {
       
      
      public var hide_ProjectorPosition_mc:MovieClip;
      
      public var lblLampMode:TextField;
      
      public var Test_Output_mc:MovieClip;
      
      public var hide_Firmware_mc:MovieClip;
      
      public var hide_MacAddress_mc:MovieClip;
      
      public var hide_LampHours2_mc:MovieClip;
      
      public var hide_ProjectorName_mc:MovieClip;
      
      public var txtProjectorName:TextField;
      
      public var lblLocation:TextField;
      
      public var ExitBttn:SimpleButton;
      
      public var txtLampHours:TextField;
      
      public var lblMacAddress:TextField;
      
      public var lblProjectorName:TextField;
      
      public var exittext:TextField;
      
      public var hide_ErrorStatus_mc:MovieClip;
      
      public var hide_LampMode_mc:MovieClip;
      
      public var lblLampHours:TextField;
      
      public var txtResolution:TextField;
      
      public var txtFirmware:TextField;
      
      public var lblPowerStatus:TextField;
      
      public var lblResolution:TextField;
      
      public var hide_Source_mc:MovieClip;
      
      public var hide_PresetMode_mc:MovieClip;
      
      public var txtLampHours2:TextField;
      
      public var lblLampHours2:TextField;
      
      public var hide_Resolution_mc:MovieClip;
      
      public var hide_LampHours_mc:MovieClip;
      
      public var hide_PowerStatus_mc:MovieClip;
      
      public var txtPresetMode:TextField;
      
      public var lblProjectorPosition:TextField;
      
      public var lblPresetMode:TextField;
      
      public var lblSource:TextField;
      
      public var lblProjectorStatus:TextField;
      
      public var txtSource:TextField;
      
      public var txtErrorStatus:TextField;
      
      public var hide_Location_mc:MovieClip;
      
      public var hide_AssignedTo_mc:MovieClip;
      
      public var txtLampMode:TextField;
      
      public var lblAssignedTo:TextField;
      
      public var lblErrorStatus:TextField;
      
      public var lblFirmware:TextField;
      
      public var txtProjectorPosition:TextField;
      
      public var txtPowerStatus:TextField;
      
      public var txtMacAddress:TextField;
      
      public var lblProjectorInformation:TextField;
      
      public var txtLocation:TextField;
      
      public var txtAssignedTo:TextField;
      
      public const SERIAL_PROJ_NAME:uint = 5050;
      
      public const SERIAL_LOCATION:uint = 5052;
      
      public const SERIAL_FIRMWARE:uint = 5056;
      
      public const SERIAL_MAC_ADDR:uint = 5044;
      
      public const SERIAL_RESOLUTION:uint = 5054;
      
      public const SERIAL_LAMP_HOURS:uint = 5;
      
      public const SERIAL_LAMP_HOURS2:uint = 5032;
      
      public const SERIAL_ASSIGNED_TO:uint = 5051;
      
      public const SERIAL_POWER_STATUS:uint = 5002;
      
      public const SERIAL_SOURCE:uint = 5010;
      
      public const SERIAL_PRESET_MODE:uint = 5055;
      
      public const SERIAL_PROJ_POS:uint = 5053;
      
      public const SERIAL_LAMP_MODE:uint = 5003;
      
      public const SERIAL_ERROR_STATUS:uint = 2;
      
      public var m_strSource:String;
      
      public var lcl_serials:Array;
      
      public var lcl_digitals:Array;
      
      public var objs:Array;
      
      public function InfoPopup_56()
      {
         super();
         addFrameScript(0,frame1,1,frame2);
      }
      
      public function onSerial(param1:SerialEvent) : *
      {
         if(this.currentFrame == 2)
         {
            updateText();
         }
      }
      
      public function setStandardCommandText(param1:uint, param2:Object) : *
      {
         var _loc3_:StandardCommand = null;
         _loc3_ = MovieClip(parent).projconfig.GetStandardCommand(param1);
         if(_loc3_ != undefined && _loc3_.lbl.length > 0)
         {
            param2.text = _loc3_.lbl;
         }
      }
      
      public function updateSource(param1:String) : *
      {
         m_strSource = param1;
      }
      
      public function getSerialText(param1:uint) : *
      {
         var join:uint = param1;
         var retStr:String = "";
         try
         {
            retStr = lcl_serials[join];
         }
         catch(e:*)
         {
            retStr = "";
         }
         if(retStr == null)
         {
            retStr = "";
         }
         return retStr;
      }
      
      public function updateText() : *
      {
         Test_Output_mc.visible = false;
         hide_ProjectorName_mc.visible = false;
         hide_Location_mc.visible = false;
         hide_Firmware_mc.visible = false;
         hide_MacAddress_mc.visible = false;
         hide_Resolution_mc.visible = false;
         hide_LampHours_mc.visible = false;
         hide_LampHours2_mc.visible = false;
         hide_AssignedTo_mc.visible = false;
         hide_PowerStatus_mc.visible = false;
         hide_Source_mc.visible = false;
         hide_PresetMode_mc.visible = false;
         hide_ProjectorPosition_mc.visible = false;
         hide_LampMode_mc.visible = false;
         hide_ErrorStatus_mc.visible = false;
         lblProjectorStatus.visible = false;
         lblProjectorInformation.visible = false;
         if(!MovieClip(parent).projconfig.CheckInfoHide("InfoMC.lblProjectorStatus"))
         {
            lblProjectorStatus.visible = true;
         }
         if(!MovieClip(parent).projconfig.CheckInfoHide("InfoMC.lblProjectorInformation"))
         {
            lblProjectorInformation.visible = true;
         }
         txtProjectorName.text = getSerialText(SERIAL_PROJ_NAME);
         setStandardCommandText(StandardCommand.CMD_PROJECTOR_NAME,lblProjectorName);
         hide_ProjectorName_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("InfoMC.lblProjectorName");
         txtLocation.text = getSerialText(SERIAL_LOCATION);
         setStandardCommandText(StandardCommand.CMD_LOCATION,lblLocation);
         hide_Location_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("InfoMC.lblLocation");
         txtFirmware.text = getSerialText(SERIAL_FIRMWARE);
         setStandardCommandText(StandardCommand.CMD_FIRMWARE,lblFirmware);
         hide_Firmware_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("InfoMC.lblFirmware");
         txtMacAddress.text = getSerialText(SERIAL_MAC_ADDR);
         setStandardCommandText(StandardCommand.CMD_MAC_ADDR,lblMacAddress);
         hide_MacAddress_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("InfoMC.lblMacAddress");
         txtResolution.text = getSerialText(SERIAL_RESOLUTION);
         setStandardCommandText(StandardCommand.CMD_RESOLUTION,lblResolution);
         hide_Resolution_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("InfoMC.lblResolution");
         if(MovieClip(parent).projconfig.ShowTestOutput())
         {
            Test_Output_mc.visible = true;
            Test_Output_mc.Output_txt.text = "SERIAL_LAMP_HOURS " + SERIAL_LAMP_HOURS + " = " + getSerialText(SERIAL_LAMP_HOURS) + "\n";
            Test_Output_mc.Output_txt.text = Test_Output_mc.Output_txt.text + ("SERIAL_LAMP_HOURS2 " + SERIAL_LAMP_HOURS2 + " = " + getSerialText(SERIAL_LAMP_HOURS2));
         }
         txtLampHours.text = getSerialText(SERIAL_LAMP_HOURS);
         setStandardCommandText(StandardCommand.CMD_LAMP_HOURS,lblLampHours);
         hide_LampHours_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("InfoMC.lblLampHours");
         txtLampHours2.text = getSerialText(SERIAL_LAMP_HOURS2);
         setStandardCommandText(StandardCommand.CMD_LAMP_HOURS2,lblLampHours2);
         hide_LampHours2_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("InfoMC.lblLampHours2");
         txtAssignedTo.text = getSerialText(SERIAL_ASSIGNED_TO);
         setStandardCommandText(StandardCommand.CMD_ASSIGNED_TO,lblAssignedTo);
         hide_AssignedTo_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("InfoMC.lblAssignedTo");
         txtPowerStatus.text = getSerialText(SERIAL_POWER_STATUS);
         setStandardCommandText(StandardCommand.CMD_POWER_STATUS,lblPowerStatus);
         hide_PowerStatus_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("InfoMC.lblPowerStatus");
         txtPresetMode.text = getSerialText(SERIAL_PRESET_MODE);
         setStandardCommandText(StandardCommand.CMD_PRESET_MODE,lblPresetMode);
         hide_PresetMode_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("InfoMC.lblPresetMode");
         txtProjectorPosition.text = getSerialText(SERIAL_PROJ_POS);
         setStandardCommandText(StandardCommand.CMD_PROJ_POS,lblProjectorPosition);
         hide_ProjectorPosition_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("InfoMC.lblProjectorPosition");
         txtLampMode.text = getSerialText(SERIAL_LAMP_MODE);
         setStandardCommandText(StandardCommand.CMD_LAMP_MODE,lblLampMode);
         hide_LampMode_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("InfoMC.lblLampMode");
         txtErrorStatus.text = getSerialText(SERIAL_ERROR_STATUS);
         setStandardCommandText(StandardCommand.CMD_ERROR_STATUS,lblErrorStatus);
         hide_ErrorStatus_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("InfoMC.lblErrorStatus");
         txtSource.text = getSerialText(SERIAL_SOURCE);
         hide_Source_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("InfoMC.lblSource");
      }
      
      public function exitpage(param1:MouseEvent) : void
      {
         MovieClip(parent).showInfoPage(false);
      }
      
      function frame1() : *
      {
         m_strSource = "";
         stop();
      }
      
      function frame2() : *
      {
         stop();
         ExitBttn.addEventListener(MouseEvent.CLICK,exitpage);
         exittext.mouseEnabled = false;
         objs = new Array();
         objs.push(ExitBttn);
         MovieClip(parent).ThemeButtonObjects(objs,MovieClip(parent).projconfig.ui_color);
         updateText();
         MovieClip(parent).applyUiXml();
         MovieClip(parent).checkForLoginButton();
      }
   }
}
