package CrestronUI_60K_2_fla
{
   import Crestron.DigitalEvent;
   import Crestron.SerialEvent;
   import CrestronDLP.Base64;
   import CrestronDLP.StandardCommand;
   import fl.motion.Color;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   
   public dynamic class ToolsPopup_50 extends MovieClip
   {
       
      
      public var hide_lblProjectorName_mc:MovieClip;
      
      public var lblAdminPasswordEnabled:TextField;
      
      public var txtPort:TextField;
      
      public var hide_lblDNSServer_mc:MovieClip;
      
      public var lblPasswordEnabled:TextField;
      
      public var lblHostname:TextField;
      
      public var txtAdminPassword:TextField;
      
      public var txtIpAddr:TextField;
      
      public var lblName:TextField;
      
      public var btnUpdateAdmin:SimpleButton;
      
      public var chkUser:MovieClip;
      
      public var lblConfirmPassword:TextField;
      
      public var lblProjector:TextField;
      
      public var chkAdmin:MovieClip;
      
      public var txtProjectorName:TextField;
      
      public var txtConfirmPassword_ne_mc:MovieClip;
      
      public var txtConfirmAdminPassword_ne_mc:MovieClip;
      
      public var CSendTXT2:TextField;
      
      public var ExitBttn:SimpleButton;
      
      public var lblLocation:TextField;
      
      public var lblIpId:TextField;
      
      public var txtIpId_ne_mc:MovieClip;
      
      public var txtDefaultGateway_ne_mc:MovieClip;
      
      public var txtPassword_ne_mc:MovieClip;
      
      public var exittext:TextField;
      
      public var lblDefaultGateway:TextField;
      
      public var txtConfirmPassword:TextField;
      
      public var lblProjectorName:TextField;
      
      public var txtIpAddr_ne_mc:MovieClip;
      
      public var hide_lblDefaultGateway_mc:MovieClip;
      
      public var hide_lblCrestronControl_mc:MovieClip;
      
      public var chkDHCP:MovieClip;
      
      public var txtDefaultGateway:TextField;
      
      public var txtSubnetMask:TextField;
      
      public var btnUpdateEtcInfo:SimpleButton;
      
      public var hide_lblIpAddr_mc:MovieClip;
      
      public var btnUpdateIpInfo:SimpleButton;
      
      public var lblPassword:TextField;
      
      public var txtProjectorName_ne_mc:MovieClip;
      
      public var txtSubnetMask_ne_mc:MovieClip;
      
      public var hide_lblSubnetMask_mc:MovieClip;
      
      public var CSendTXT:TextField;
      
      public var txtName:TextField;
      
      public var lblAdminPass:TextField;
      
      public var lblAdminPassword:TextField;
      
      public var txtLocation_ne_mc:MovieClip;
      
      public var txtName_ne_mc:MovieClip;
      
      public var txtConfirmPassword_BG:MovieClip;
      
      public var txtConfirmAdminPassword_BG:MovieClip;
      
      public var hide_btnUpdateIpInfo_mc:MovieClip;
      
      public var txtIpAddress:TextField;
      
      public var lblConfirmAdminPassword:TextField;
      
      public var lblIpAddr:TextField;
      
      public var txtPort_ne_mc:MovieClip;
      
      public var txtIpAddress_ne_mc:MovieClip;
      
      public var txtDNSServer_BG:MovieClip;
      
      public var txtIpAddress_BG:MovieClip;
      
      public var hide_lblProjector_mc:MovieClip;
      
      public var btnUpdateProjector:SimpleButton;
      
      public var ASendTXT:TextField;
      
      public var lblIpAddress:TextField;
      
      public var lblPort:TextField;
      
      public var txtHostname_ne_mc:MovieClip;
      
      public var txtAdminPassword_BG:MovieClip;
      
      public var hide_lblIpAddress_mc:MovieClip;
      
      public var hide_lblHostname_mc:MovieClip;
      
      public var hide_lblLocation_mc:MovieClip;
      
      public var txtPassword:TextField;
      
      public var txtIpId:TextField;
      
      public var txtAdminPassword_ne_mc:MovieClip;
      
      public var txtDefaultGateway_BG:MovieClip;
      
      public var hide_lblDHCP_mc:MovieClip;
      
      public var btnUpdateUser:SimpleButton;
      
      public var txtDNSServer:TextField;
      
      public var hide_lblIpId_mc:MovieClip;
      
      public var lblDNSServer:TextField;
      
      public var txtConfirmAdminPassword:TextField;
      
      public var txtDNSServer_ne_mc:MovieClip;
      
      public var txtHostname_BG:MovieClip;
      
      public var txtPassword_BG:MovieClip;
      
      public var CSendTXT10:TextField;
      
      public var hide_lblPort_mc:MovieClip;
      
      public var txtHostname:TextField;
      
      public var lblDHCP:TextField;
      
      public var hide_btnUpdateProjector_mc:MovieClip;
      
      public var hide_btnUpdateEtcInfo_mc:MovieClip;
      
      public var hide_lblName_mc:MovieClip;
      
      public var lblDHCPEnabled:TextField;
      
      public var USendTXT:TextField;
      
      public var txtSubnetMask_BG:MovieClip;
      
      public var lblSubnetMask:TextField;
      
      public var txtLocation:TextField;
      
      public var lblUserPass:TextField;
      
      public var lblCrestronControl:TextField;
      
      public const SERIAL_CS_IP_ADDR:uint = 5045;
      
      public const SERIAL_CS_IPID:uint = 5046;
      
      public const SERIAL_CS_PORT:uint = 5047;
      
      public const SERIAL_PROJ_NAME:uint = 5050;
      
      public const SERIAL_LOCATION:uint = 5052;
      
      public const SERIAL_IP_ADDR:uint = 5040;
      
      public const SERIAL_SUBNET_MASK:uint = 5041;
      
      public const SERIAL_DEFAULT_GATEWAY:uint = 5042;
      
      public const SERIAL_DNS_SERVER:uint = 5043;
      
      public const SERIAL_USER_NAME:uint = 5051;
      
      public const SERIAL_USER_PWD:uint = 5061;
      
      public const SERIAL_ADMIN_PWD:uint = 5062;
      
      public const SERIAL_ASSIGNED_TO:uint = 5051;
      
      public const SERIAL_DHCP_ADDR:uint = 5039;
      
      public var lcl_serials:Array;
      
      public var lcl_digitals:Array;
      
      public var dhcp_on_to_start:Boolean;
      
      public var ilimit_txtIpAddr:uint;
      
      public var ilimit_txtIpId:uint;
      
      public var ilimit_txtPort:uint;
      
      public var ilimit_txtIpAddress:uint;
      
      public var ilimit_txtSubnetMask:uint;
      
      public var ilimit_txtDefaultGateway:uint;
      
      public var ilimit_txtDNSServer:uint;
      
      public var ilimit_txtHostname:uint;
      
      public var ilimit_txtPassword:uint;
      
      public var ilimit_txtConfirmPassword:uint;
      
      public var ilimit_txtAdminPassword:uint;
      
      public var ilimit_txtConfirmAdminPassword:uint;
      
      public var _FILLALL:String;
      
      public var _DONOTMATCH:String;
      
      public var _INVALIDADDR:String;
      
      public var _INVALIDHOST:String;
      
      public var _INVALIDPW:String;
      
      public var objs:Array;
      
      public function ToolsPopup_50()
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
      
      public function onDigital(param1:DigitalEvent) : *
      {
         if(this.currentFrame == 2)
         {
            updateText();
         }
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
      
      public function setStandardCommandText(param1:uint, param2:Object) : *
      {
         var _loc3_:StandardCommand = null;
         _loc3_ = MovieClip(parent).projconfig.GetStandardCommand(param1);
         if(_loc3_ != undefined && _loc3_.lbl.length > 0)
         {
            param2.text = _loc3_.lbl;
         }
      }
      
      public function enableAdmin(param1:Boolean) : *
      {
         var _loc2_:Color = null;
         txtAdminPassword.mouseEnabled = param1;
         txtConfirmAdminPassword.mouseEnabled = param1;
         if(param1)
         {
            chkAdmin.gotoAndStop(2);
            txtAdminPassword_BG.transform.colorTransform = new Color();
            txtConfirmAdminPassword_BG.transform.colorTransform = new Color();
         }
         else
         {
            chkAdmin.gotoAndStop(1);
            _loc2_ = new Color();
            _loc2_.setTint(12632256,0.6);
            txtAdminPassword_BG.transform.colorTransform = _loc2_;
            txtConfirmAdminPassword_BG.transform.colorTransform = _loc2_;
         }
      }
      
      public function enableUser(param1:Boolean) : *
      {
         var _loc2_:Color = null;
         txtPassword.mouseEnabled = param1;
         txtConfirmPassword.mouseEnabled = param1;
         if(param1)
         {
            chkUser.gotoAndStop(2);
            txtPassword_BG.transform.colorTransform = new Color();
            txtConfirmPassword_BG.transform.colorTransform = new Color();
         }
         else
         {
            chkUser.gotoAndStop(1);
            _loc2_ = new Color();
            _loc2_.setTint(12632256,0.6);
            txtPassword_BG.transform.colorTransform = _loc2_;
            txtConfirmPassword_BG.transform.colorTransform = _loc2_;
         }
      }
      
      public function enableDHCP(param1:Boolean) : *
      {
         var _loc2_:Color = null;
         txtIpAddress.mouseEnabled = !param1;
         txtSubnetMask.mouseEnabled = !param1;
         txtDNSServer.mouseEnabled = !param1;
         txtDefaultGateway.mouseEnabled = !param1;
         if(param1)
         {
            chkDHCP.gotoAndStop(2);
            _loc2_ = new Color();
            _loc2_.setTint(12632256,0.6);
            txtIpAddress_BG.transform.colorTransform = _loc2_;
            txtSubnetMask_BG.transform.colorTransform = _loc2_;
            txtDNSServer_BG.transform.colorTransform = _loc2_;
            txtDefaultGateway_BG.transform.colorTransform = _loc2_;
            txtIpAddress.transform.colorTransform = _loc2_;
            txtSubnetMask.transform.colorTransform = _loc2_;
            txtDNSServer.transform.colorTransform = _loc2_;
            txtDefaultGateway.transform.colorTransform = _loc2_;
         }
         else
         {
            chkDHCP.gotoAndStop(1);
            txtIpAddress_BG.transform.colorTransform = new Color();
            txtSubnetMask_BG.transform.colorTransform = new Color();
            txtDNSServer_BG.transform.colorTransform = new Color();
            txtDefaultGateway_BG.transform.colorTransform = new Color();
            txtIpAddress.transform.colorTransform = new Color();
            txtSubnetMask.transform.colorTransform = new Color();
            txtDNSServer.transform.colorTransform = new Color();
            txtDefaultGateway.transform.colorTransform = new Color();
         }
      }
      
      public function checkTextLength(param1:Event) : void
      {
         var _loc2_:String = param1.target.name;
         var _loc3_:TextField = TextField(param1.target);
         var _loc4_:String = _loc3_.text;
         switch(_loc2_)
         {
            case "txtIpAddr":
         }
      }
      
      public function updateText() : *
      {
         txtIpAddr_ne_mc.visible = false;
         txtIpId_ne_mc.visible = false;
         txtPort_ne_mc.visible = false;
         txtProjectorName_ne_mc.visible = false;
         txtLocation_ne_mc.visible = false;
         txtName_ne_mc.visible = false;
         txtIpAddress_ne_mc.visible = false;
         txtSubnetMask_ne_mc.visible = false;
         txtDefaultGateway_ne_mc.visible = false;
         txtDNSServer_ne_mc.visible = false;
         txtHostname_ne_mc.visible = false;
         txtPassword_ne_mc.visible = false;
         txtConfirmPassword_ne_mc.visible = false;
         txtAdminPassword_ne_mc.visible = false;
         txtConfirmAdminPassword_ne_mc.visible = false;
         txtIpAddr.maxChars = MovieClip(parent).projconfig.GetToolTextLimit("ToolsMC.txtIpAddr");
         if(MovieClip(parent).projconfig.CheckForTextEdit("ToolsMC.txtIpAddr"))
         {
            txtIpAddr.type = TextFieldType.INPUT;
         }
         else
         {
            txtIpAddr.type = TextFieldType.DYNAMIC;
            txtIpAddr_ne_mc.visible = true;
         }
         txtIpId.maxChars = MovieClip(parent).projconfig.GetToolTextLimit("ToolsMC.txtIpId");
         if(MovieClip(parent).projconfig.CheckForTextEdit("ToolsMC.txtIpId"))
         {
            txtIpId.type = TextFieldType.INPUT;
         }
         else
         {
            txtIpId.type = TextFieldType.DYNAMIC;
            txtIpId_ne_mc.visible = true;
         }
         txtPort.maxChars = MovieClip(parent).projconfig.GetToolTextLimit("ToolsMC.txtPort");
         if(MovieClip(parent).projconfig.CheckForTextEdit("ToolsMC.txtPort"))
         {
            txtPort.type = TextFieldType.INPUT;
         }
         else
         {
            txtPort.type = TextFieldType.DYNAMIC;
            txtPort_ne_mc.visible = true;
         }
         txtProjectorName.maxChars = MovieClip(parent).projconfig.GetToolTextLimit("ToolsMC.txtProjectorName");
         if(MovieClip(parent).projconfig.CheckForTextEdit("ToolsMC.txtProjectorName"))
         {
            txtProjectorName.type = TextFieldType.INPUT;
         }
         else
         {
            txtProjectorName.type = TextFieldType.DYNAMIC;
            txtProjectorName_ne_mc.visible = true;
         }
         txtLocation.maxChars = MovieClip(parent).projconfig.GetToolTextLimit("ToolsMC.txtLocation");
         if(MovieClip(parent).projconfig.CheckForTextEdit("ToolsMC.txtLocation"))
         {
            txtLocation.type = TextFieldType.INPUT;
         }
         else
         {
            txtLocation.type = TextFieldType.DYNAMIC;
            txtLocation_ne_mc.visible = true;
         }
         txtName.maxChars = MovieClip(parent).projconfig.GetToolTextLimit("ToolsMC.txtName");
         if(MovieClip(parent).projconfig.CheckForTextEdit("ToolsMC.txtName"))
         {
            txtName.type = TextFieldType.INPUT;
         }
         else
         {
            txtName.type = TextFieldType.DYNAMIC;
            txtName_ne_mc.visible = true;
         }
         txtIpAddress.maxChars = MovieClip(parent).projconfig.GetToolTextLimit("ToolsMC.txtIpAddress");
         if(MovieClip(parent).projconfig.CheckForTextEdit("ToolsMC.txtIpAddress"))
         {
            txtIpAddress.type = TextFieldType.INPUT;
         }
         else
         {
            txtIpAddress.type = TextFieldType.DYNAMIC;
            txtIpAddress_ne_mc.visible = true;
         }
         txtSubnetMask.maxChars = MovieClip(parent).projconfig.GetToolTextLimit("ToolsMC.txtSubnetMask");
         if(MovieClip(parent).projconfig.CheckForTextEdit("ToolsMC.txtSubnetMask"))
         {
            txtSubnetMask.type = TextFieldType.INPUT;
         }
         else
         {
            txtSubnetMask.type = TextFieldType.DYNAMIC;
            txtSubnetMask_ne_mc.visible = true;
         }
         txtDefaultGateway.maxChars = MovieClip(parent).projconfig.GetToolTextLimit("ToolsMC.txtDefaultGateway");
         if(MovieClip(parent).projconfig.CheckForTextEdit("ToolsMC.txtDefaultGateway"))
         {
            txtDefaultGateway.type = TextFieldType.INPUT;
         }
         else
         {
            txtDefaultGateway.type = TextFieldType.DYNAMIC;
            txtDefaultGateway_ne_mc.visible = true;
         }
         txtDNSServer.maxChars = MovieClip(parent).projconfig.GetToolTextLimit("ToolsMC.txtDNSServer");
         if(MovieClip(parent).projconfig.CheckForTextEdit("ToolsMC.txtDNSServer"))
         {
            txtDNSServer.type = TextFieldType.INPUT;
         }
         else
         {
            txtDNSServer.type = TextFieldType.DYNAMIC;
            txtDNSServer_ne_mc.visible = true;
         }
         txtHostname.maxChars = MovieClip(parent).projconfig.GetToolTextLimit("ToolsMC.txtHostname");
         if(MovieClip(parent).projconfig.CheckForTextEdit("ToolsMC.txtHostname"))
         {
            txtHostname.type = TextFieldType.INPUT;
         }
         else
         {
            txtHostname.type = TextFieldType.DYNAMIC;
            txtHostname_ne_mc.visible = true;
         }
         txtPassword.maxChars = MovieClip(parent).projconfig.GetToolTextLimit("ToolsMC.txtPassword");
         if(MovieClip(parent).projconfig.CheckForTextEdit("ToolsMC.txtPassword"))
         {
            txtPassword.type = TextFieldType.INPUT;
         }
         else
         {
            txtPassword.type = TextFieldType.DYNAMIC;
            txtPassword_ne_mc.visible = true;
         }
         txtConfirmPassword.maxChars = MovieClip(parent).projconfig.GetToolTextLimit("ToolsMC.txtConfirmPassword");
         if(MovieClip(parent).projconfig.CheckForTextEdit("ToolsMC.txtConfirmPassword"))
         {
            txtConfirmPassword.type = TextFieldType.INPUT;
         }
         else
         {
            txtConfirmPassword.type = TextFieldType.DYNAMIC;
            txtConfirmPassword_ne_mc.visible = true;
         }
         txtAdminPassword.maxChars = MovieClip(parent).projconfig.GetToolTextLimit("ToolsMC.txtAdminPassword");
         if(MovieClip(parent).projconfig.CheckForTextEdit("ToolsMC.txtAdminPassword"))
         {
            txtAdminPassword.type = TextFieldType.INPUT;
         }
         else
         {
            txtAdminPassword.type = TextFieldType.DYNAMIC;
            txtAdminPassword_ne_mc.visible = true;
         }
         txtConfirmAdminPassword.maxChars = MovieClip(parent).projconfig.GetToolTextLimit("ToolsMC.txtConfirmAdminPassword");
         if(MovieClip(parent).projconfig.CheckForTextEdit("ToolsMC.txtConfirmAdminPassword"))
         {
            txtConfirmAdminPassword.type = TextFieldType.INPUT;
         }
         else
         {
            txtConfirmAdminPassword.type = TextFieldType.DYNAMIC;
            txtConfirmAdminPassword_ne_mc.visible = true;
         }
         hide_lblIpAddr_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("ToolsMC.lblIpAddr");
         hide_lblIpId_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("ToolsMC.lblIpId");
         hide_lblPort_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("ToolsMC.lblPort");
         hide_lblCrestronControl_mc.visible = false;
         hide_btnUpdateIpInfo_mc.visible = false;
         if(hide_lblIpAddr_mc.visible && hide_lblIpId_mc.visible && hide_lblPort_mc.visible)
         {
            hide_lblCrestronControl_mc.visible = true;
            hide_btnUpdateIpInfo_mc.visible = true;
         }
         else
         {
            hide_lblCrestronControl_mc.visible = false;
            hide_btnUpdateIpInfo_mc.visible = false;
         }
         hide_lblProjectorName_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("ToolsMC.lblProjectorName");
         hide_lblLocation_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("ToolsMC.lblLocation");
         hide_lblName_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("ToolsMC.lblName");
         hide_lblProjector_mc.visible = false;
         hide_btnUpdateEtcInfo_mc.visible = false;
         if(hide_lblProjectorName_mc.visible && hide_lblLocation_mc.visible && hide_lblName_mc.visible)
         {
            hide_lblProjector_mc.visible = true;
            hide_btnUpdateEtcInfo_mc.visible = true;
         }
         else
         {
            hide_lblProjector_mc.visible = false;
            hide_btnUpdateEtcInfo_mc.visible = false;
         }
         hide_lblDHCP_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("ToolsMC.lblDHCP");
         var _loc1_:Boolean = MovieClip(parent).projconfig.chkDHCP_Edit();
         if(!_loc1_)
         {
            chkDHCP.mouseEnabled = false;
         }
         hide_lblIpAddress_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("ToolsMC.lblIpAddress");
         hide_lblSubnetMask_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("ToolsMC.lblSubnetMask");
         hide_lblDefaultGateway_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("ToolsMC.lblDefaultGateway");
         hide_lblDNSServer_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("ToolsMC.lblDNSServer");
         hide_lblHostname_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("ToolsMC.lblHostname");
         hide_btnUpdateProjector_mc.visible = false;
         var _loc2_:Boolean = false;
         if(hide_lblDHCP_mc.visible && hide_lblIpAddress_mc.visible && hide_lblSubnetMask_mc.visible && hide_lblDefaultGateway_mc.visible && hide_lblDNSServer_mc.visible && hide_lblHostname_mc.visible)
         {
            hide_btnUpdateProjector_mc.visible = true;
            _loc2_ = true;
         }
         else
         {
            hide_btnUpdateProjector_mc.visible = false;
         }
         if(!_loc2_)
         {
            hide_btnUpdateProjector_mc.visible = MovieClip(parent).projconfig.CheckInfoHide("ToolsMC.CSendTXT");
         }
         txtIpAddr.text = getSerialText(SERIAL_CS_IP_ADDR);
         setStandardCommandText(StandardCommand.CMD_CS_IP_ADDR,lblIpAddr);
         txtIpId.text = getSerialText(SERIAL_CS_IPID);
         setStandardCommandText(StandardCommand.CMD_CS_IP_ID,lblIpId);
         txtPort.text = getSerialText(SERIAL_CS_PORT);
         setStandardCommandText(StandardCommand.CMD_CS_PORT,lblPort);
         txtProjectorName.text = getSerialText(SERIAL_PROJ_NAME);
         setStandardCommandText(StandardCommand.CMD_PROJECTOR_NAME,lblProjectorName);
         txtLocation.text = getSerialText(SERIAL_LOCATION);
         setStandardCommandText(StandardCommand.CMD_LOCATION,lblLocation);
         txtIpAddress.text = getSerialText(SERIAL_IP_ADDR);
         setStandardCommandText(StandardCommand.CMD_IP_ADDR,lblIpAddress);
         txtSubnetMask.text = getSerialText(SERIAL_SUBNET_MASK);
         setStandardCommandText(StandardCommand.CMD_SUBNET_MASK,lblSubnetMask);
         txtDefaultGateway.text = getSerialText(SERIAL_DEFAULT_GATEWAY);
         setStandardCommandText(StandardCommand.CMD_DEFAULT_GATEWAY,lblDefaultGateway);
         txtDNSServer.text = getSerialText(SERIAL_DNS_SERVER);
         setStandardCommandText(StandardCommand.CMD_DNS_SERVER,lblDNSServer);
         txtHostname.text = getSerialText(SERIAL_DHCP_ADDR);
         enableDHCP(lcl_digitals[5210]);
         dhcp_on_to_start = lcl_digitals[5210];
         setStandardCommandText(StandardCommand.CMD_DHCP_ENABLED,lblDHCPEnabled);
         enableUser(lcl_digitals[5212]);
         setStandardCommandText(StandardCommand.CMD_U_PWRD_ENABLED,lblPasswordEnabled);
         enableAdmin(lcl_digitals[5216]);
         setStandardCommandText(StandardCommand.CMD_A_PWRD_ENABLED,lblAdminPasswordEnabled);
         txtName.text = getSerialText(SERIAL_ASSIGNED_TO);
         setStandardCommandText(StandardCommand.CMD_USER_NAME,lblName);
         setStandardCommandText(StandardCommand.CMD_USER_PWRD,lblPassword);
         setStandardCommandText(StandardCommand.CMD_USER_CONFIRM,lblConfirmPassword);
         setStandardCommandText(StandardCommand.CMD_ADMIN_PWRD,lblAdminPassword);
         setStandardCommandText(StandardCommand.CMD_ADMIN_CONFIRM,lblConfirmAdminPassword);
      }
      
      public function exitpage(param1:MouseEvent) : void
      {
         MovieClip(parent).showToolsPage(false);
      }
      
      public function toggleDHCP(param1:Event) : *
      {
         if(chkDHCP.currentFrame == 1)
         {
            enableDHCP(true);
         }
         else
         {
            enableDHCP(false);
         }
      }
      
      public function toggleUser(param1:Event) : *
      {
         if(chkUser.currentFrame == 1)
         {
            enableUser(true);
         }
         else
         {
            enableUser(false);
         }
      }
      
      public function toggleAdmin(param1:Event) : *
      {
         if(chkAdmin.currentFrame == 1)
         {
            enableAdmin(true);
         }
         else
         {
            enableAdmin(false);
         }
      }
      
      public function updateEtc(param1:Event) : *
      {
         if(!(txtProjectorName.text.length > 0 && txtLocation.text.length > 0 && txtName.text.length > 0))
         {
            alert(_FILLALL);
            return;
         }
         MovieClip(parent).cnx.SendSerial(5050,txtProjectorName.text);
         MovieClip(parent).cnx.SendSerial(5052,txtLocation.text);
         MovieClip(parent).cnx.SendSerial(5051,txtName.text);
         MovieClip(parent).UpdateCompleteMC.play();
      }
      
      public function updateIp_saved(param1:Event) : *
      {
         if(txtIpAddr.text.length > 0 && txtIpId.text.length > 0 && txtPort.text.length > 0)
         {
            MovieClip(parent).cnx.SendSerial(5045,txtIpAddr.text);
            MovieClip(parent).cnx.SendSerial(5046,txtIpId.text);
            MovieClip(parent).cnx.SendSerial(5047,txtPort.text);
            MovieClip(parent).UpdateCompleteMC.play();
         }
      }
      
      public function updateIp(param1:Event) : *
      {
         if(txtIpAddr.text.length > 0 && txtIpId.text.length > 0 && txtPort.text.length > 0)
         {
            MovieClip(parent).cnx.SendSerial(5045,txtIpAddr.text);
            MovieClip(parent).cnx.SendSerial(5046,txtIpId.text);
            MovieClip(parent).cnx.SendSerial(5047,txtPort.text);
            MovieClip(parent).UpdateCompleteMC.play();
         }
      }
      
      public function CheckIpAddrRange(param1:String) : Boolean
      {
         var _loc2_:Boolean = true;
         var _loc3_:Array = new Array();
         if(param1.indexOf(".") > 0)
         {
            _loc3_ = param1.split(".");
            if(_loc3_.length < 3)
            {
               _loc2_ = false;
            }
         }
         if(_loc2_)
         {
            if(int(_loc3_[0]) == 0)
            {
               _loc2_ = false;
            }
            if(int(_loc3_[0]) == 127)
            {
               _loc2_ = false;
            }
            if(int(_loc3_[0]) >= 224 && int(_loc3_[0]) <= 239)
            {
               _loc2_ = false;
            }
            if(int(_loc3_[0]) >= 240 && int(_loc3_[0]) <= 255)
            {
               _loc2_ = false;
            }
         }
         return _loc2_;
      }
      
      public function validAddress(param1:String) : Boolean
      {
         var _loc2_:Array = null;
         var _loc3_:* = undefined;
         _loc2_ = param1.split(".");
         if(_loc2_.length != 4)
         {
            return false;
         }
         for(_loc3_ in _loc2_)
         {
            if(parseInt(_loc2_[_loc3_]) < 0 || parseInt(_loc2_[_loc3_]) > 255)
            {
               return false;
            }
         }
         return true;
      }
      
      public function verifyData() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(chkDHCP.currentFrame == 1)
         {
            _loc1_ = true;
            _loc2_ = true;
            if(!hide_lblIpAddress_mc.visible)
            {
               if(!txtIpAddress.text.length > 0)
               {
                  _loc1_ = false;
               }
               if(!CheckIpAddrRange(txtIpAddress.text))
               {
                  _loc2_ = false;
               }
            }
            if(!hide_lblSubnetMask_mc.visible)
            {
               if(!txtSubnetMask.text.length > 0)
               {
                  _loc1_ = false;
               }
            }
            if(!hide_lblDNSServer_mc.visible)
            {
               if(!txtDNSServer.text.length > 0)
               {
                  _loc1_ = false;
               }
            }
            if(!hide_lblDefaultGateway_mc.visible)
            {
               if(!txtDefaultGateway.text.length > 0)
               {
                  _loc1_ = false;
               }
            }
            if(!_loc1_)
            {
               alert(_FILLALL);
               return false;
            }
            if(!hide_lblIpAddress_mc.visible)
            {
               if(!validAddress(txtIpAddress.text))
               {
                  _loc2_ = false;
               }
            }
            if(!hide_lblSubnetMask_mc.visible)
            {
               if(!validAddress(txtSubnetMask.text))
               {
                  _loc2_ = false;
               }
            }
            if(!hide_lblDNSServer_mc.visible)
            {
               if(!validAddress(txtDNSServer.text))
               {
                  _loc2_ = false;
               }
            }
            if(!hide_lblDefaultGateway_mc.visible)
            {
               if(!validAddress(txtDefaultGateway.text))
               {
                  _loc2_ = false;
               }
            }
            if(!_loc2_)
            {
               alert(_INVALIDADDR);
               return false;
            }
         }
         if(!hide_lblHostname_mc.visible)
         {
            _loc3_ = 0;
            _loc4_ = 0;
            while(_loc4_ < txtHostname.text.length)
            {
               _loc3_ = txtHostname.text.charCodeAt(_loc4_);
               if(_loc3_ >= 65 && _loc3_ <= 90 || _loc3_ >= 97 && _loc3_ <= 122)
               {
                  _loc4_++;
                  continue;
               }
               alert(_INVALIDHOST);
               return false;
            }
         }
         return true;
      }
      
      public function updateProj(param1:Event) : *
      {
         if(!verifyData())
         {
            return;
         }
         if(chkDHCP.currentFrame == 2)
         {
            MovieClip(parent).cnx.SendDigital(5210,true);
         }
         else
         {
            MovieClip(parent).cnx.SendDigital(5210,false);
         }
         MovieClip(parent).cnx.SendSerial(5040,txtIpAddress.text);
         MovieClip(parent).cnx.SendSerial(5041,txtSubnetMask.text);
         MovieClip(parent).cnx.SendSerial(5042,txtDefaultGateway.text);
         MovieClip(parent).cnx.SendSerial(5043,txtDNSServer.text);
         MovieClip(parent).cnx.SendSerial(5039,txtHostname.text);
         MovieClip(parent).UpdateCompleteMC.play();
         if(chkDHCP.currentFrame == 2)
         {
            MovieClip(parent).ipInfoChanged("");
         }
         else
         {
            MovieClip(parent).ipInfoChanged(txtIpAddress.text);
         }
      }
      
      public function updateUser(param1:Event) : *
      {
         var _loc2_:String = null;
         if(chkUser.currentFrame != 2)
         {
            MovieClip(parent).cnx.SendDigital(5213,true);
            MovieClip(parent).cnx.SendDigital(5212,false);
            MovieClip(parent).UpdateCompleteMC.play();
            return;
         }
         if(txtPassword.text.length > 0)
         {
            if(txtPassword.text == txtConfirmPassword.text)
            {
               MovieClip(parent).cnx.SendDigital(5212,true);
               MovieClip(parent).cnx.SendDigital(5213,false);
               _loc2_ = Base64.Encode(txtPassword.text);
               MovieClip(parent).cnx.SendSerial(5061,_loc2_);
               MovieClip(parent).UpdateCompleteMC.play();
            }
            else
            {
               alert(_DONOTMATCH);
            }
         }
         else
         {
            alert(_INVALIDPW);
         }
      }
      
      public function alert(param1:String) : *
      {
         MovieClip(parent).UpdateCompleteMC.setMsg(param1);
      }
      
      public function updateAdmin(param1:Event) : *
      {
         var _loc2_:String = null;
         if(chkAdmin.currentFrame != 2)
         {
            MovieClip(parent).cnx.SendDigital(5217,true);
            MovieClip(parent).cnx.SendDigital(5216,false);
            MovieClip(parent).UpdateCompleteMC.play();
            return;
         }
         if(txtAdminPassword.text.length > 0)
         {
            if(txtAdminPassword.text == txtConfirmAdminPassword.text)
            {
               MovieClip(parent).cnx.SendDigital(5216,true);
               MovieClip(parent).cnx.SendDigital(5217,false);
               _loc2_ = Base64.Encode(txtAdminPassword.text);
               MovieClip(parent).cnx.SendSerial(5062,_loc2_);
               MovieClip(parent).UpdateCompleteMC.play();
            }
            else
            {
               alert(_DONOTMATCH);
            }
         }
         else
         {
            alert(_INVALIDPW);
         }
      }
      
      function frame1() : *
      {
         stop();
         ilimit_txtIpAddr = 10;
         ilimit_txtIpId = 10;
         ilimit_txtPort = 10;
         ilimit_txtIpAddress = 10;
         ilimit_txtSubnetMask = 10;
         ilimit_txtDefaultGateway = 10;
         ilimit_txtDNSServer = 10;
         ilimit_txtHostname = 10;
         ilimit_txtPassword = 10;
         ilimit_txtConfirmPassword = 10;
         ilimit_txtAdminPassword = 10;
         ilimit_txtConfirmAdminPassword = 10;
      }
      
      function frame2() : *
      {
         stop();
         if(MovieClip(parent).projconfig.hasdhcp != "1")
         {
            txtHostname.visible = false;
            txtHostname_BG.visible = false;
            lblHostname.visible = false;
            btnUpdateProjector.y = txtDNSServer.y + txtDNSServer.height + 5;
            CSendTXT.y = btnUpdateProjector.y + 1.4;
         }
         _FILLALL = MovieClip(parent).getDefaultXMLText("FillAll","All fields must be completed");
         _DONOTMATCH = MovieClip(parent).getDefaultXMLText("DoNotMatch","Passwords do not match");
         _INVALIDADDR = MovieClip(parent).getDefaultXMLText("InvalidAddr","Invalid address entered");
         _INVALIDHOST = MovieClip(parent).getDefaultXMLText("InvalidHost","Invalid host name");
         _INVALIDPW = MovieClip(parent).getDefaultXMLText("InvalidPW","Invalid Password");
         ExitBttn.addEventListener(MouseEvent.CLICK,exitpage);
         objs = new Array();
         objs.push(ExitBttn);
         MovieClip(parent).ThemeButtonObjects(objs,MovieClip(parent).projconfig.ui_color);
         exittext.mouseEnabled = false;
         CSendTXT.mouseEnabled = false;
         CSendTXT2.mouseEnabled = false;
         CSendTXT10.mouseEnabled = false;
         ASendTXT.mouseEnabled = false;
         USendTXT.mouseEnabled = false;
         updateText();
         chkDHCP.addEventListener(MouseEvent.CLICK,toggleDHCP);
         chkUser.addEventListener(MouseEvent.CLICK,toggleUser);
         chkAdmin.addEventListener(MouseEvent.CLICK,toggleAdmin);
         btnUpdateEtcInfo.addEventListener(MouseEvent.CLICK,updateEtc);
         btnUpdateIpInfo.addEventListener(MouseEvent.CLICK,updateIp);
         btnUpdateProjector.addEventListener(MouseEvent.CLICK,updateProj);
         btnUpdateUser.addEventListener(MouseEvent.CLICK,updateUser);
         btnUpdateAdmin.addEventListener(MouseEvent.CLICK,updateAdmin);
         MovieClip(parent).applyUiXml();
         MovieClip(parent).checkForLoginButton();
         if(hide_lblIpAddress_mc.visible)
         {
            txtIpAddress.tabEnabled = false;
         }
         else
         {
            txtIpAddress.tabEnabled = true;
         }
         if(hide_lblSubnetMask_mc.visible)
         {
            txtSubnetMask.tabEnabled = false;
         }
         else
         {
            txtSubnetMask.tabEnabled = true;
         }
         if(hide_lblDefaultGateway_mc.visible)
         {
            txtDefaultGateway.tabEnabled = false;
         }
         else
         {
            txtDefaultGateway.tabEnabled = true;
         }
         if(hide_lblDNSServer_mc.visible)
         {
            txtDNSServer.tabEnabled = false;
         }
         else
         {
            txtDNSServer.tabEnabled = true;
         }
         if(hide_lblHostname_mc.visible)
         {
            txtHostname.tabEnabled = false;
         }
         else
         {
            txtHostname.tabEnabled = true;
         }
         if(hide_lblName_mc.visible)
         {
            txtName.tabEnabled = false;
         }
         else
         {
            txtName.tabEnabled = true;
         }
         if(hide_lblLocation_mc.visible)
         {
            txtLocation.tabEnabled = false;
         }
         else
         {
            txtLocation.tabEnabled = true;
         }
         if(hide_lblProjectorName_mc.visible)
         {
            txtProjectorName.tabEnabled = false;
         }
         else
         {
            txtProjectorName.tabEnabled = true;
         }
         if(hide_lblPort_mc.visible)
         {
            txtPort.tabEnabled = false;
         }
         else
         {
            txtPort.tabEnabled = true;
         }
         if(hide_lblIpId_mc.visible)
         {
            txtIpId.tabEnabled = false;
         }
         else
         {
            txtIpId.tabEnabled = true;
         }
         if(hide_lblIpAddr_mc.visible)
         {
            txtIpAddr.tabEnabled = false;
         }
         else
         {
            txtIpAddr.tabEnabled = true;
         }
         stage.focus = txtIpAddr;
         txtIpAddr.tabIndex = 1;
         txtIpId.tabIndex = 2;
         txtPort.tabIndex = 3;
         txtProjectorName.tabIndex = 4;
         txtLocation.tabIndex = 5;
         txtName.tabIndex = 6;
         txtIpAddress.tabIndex = 7;
         txtSubnetMask.tabIndex = 8;
         txtDefaultGateway.tabIndex = 9;
         txtDNSServer.tabIndex = 10;
         txtHostname.tabIndex = 11;
         txtPassword.tabIndex = 12;
         txtConfirmPassword.tabIndex = 13;
         txtAdminPassword.tabIndex = 14;
         txtConfirmAdminPassword.tabIndex = 15;
      }
   }
}
