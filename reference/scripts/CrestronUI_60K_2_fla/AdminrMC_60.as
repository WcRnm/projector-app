package CrestronUI_60K_2_fla
{
   import Crestron.DigitalEvent;
   import CrestronDLP.Base64;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.text.TextField;
   
   public dynamic class AdminrMC_60 extends MovieClip
   {
       
      
      public var txtLoginTitle:TextField;
      
      public var ExitBttn:SimpleButton;
      
      public var ExitTXT:TextField;
      
      public var lblPassword:TextField;
      
      public var btnEnterPwd:SimpleButton;
      
      public var Admintxt:TextField;
      
      public var USendTXT:TextField;
      
      public const USER_PWD:uint = 1;
      
      public const ADMIN_PWD:uint = 2;
      
      public var correct:Boolean;
      
      public var pwordType:uint;
      
      public function AdminrMC_60()
      {
         super();
         addFrameScript(0,frame1,1,frame2);
      }
      
      public function local_applyUiXml() : *
      {
         var _loc1_:* = undefined;
         if(currentFrame != 2)
         {
            return;
         }
         for each(_loc1_ in MovieClip(parent).projconfig.hidden_objects)
         {
            if("AdminrMC.lblPassword" == _loc1_.name)
            {
               lblPassword.text = _loc1_.text;
            }
            else if("AdminrMC.USendTXT" == _loc1_.name)
            {
               USendTXT.text = _loc1_.text;
            }
            else if("AdminrMC.ExitTXT" == _loc1_.name)
            {
               ExitTXT.text = _loc1_.text;
            }
            else if("AdminrMC.UserLogin" == _loc1_.name)
            {
               if(pwordType == USER_PWD)
               {
                  txtLoginTitle.text = _loc1_.text;
               }
            }
            else if("AdminrMC.AdminLogin" == _loc1_.name)
            {
               if(pwordType == ADMIN_PWD)
               {
                  txtLoginTitle.text = _loc1_.text;
               }
            }
         }
      }
      
      public function WaitingForAdminPassword() : Boolean
      {
         if(this.currentFrame == 2 && pwordType == ADMIN_PWD)
         {
            return true;
         }
         return false;
      }
      
      public function WaitingForUserPassword() : Boolean
      {
         if(this.currentFrame == 2 && pwordType == USER_PWD)
         {
            return true;
         }
         return false;
      }
      
      public function onDigital(param1:DigitalEvent) : *
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(this.currentFrame != 2)
         {
            return;
         }
         if(txtLoginTitle == null)
         {
            return;
         }
         if(param1.Join == 5215 && param1.Value)
         {
            if(WaitingForUserPassword())
            {
               _loc2_ = MovieClip(parent).getXMLText("AdminrMC.UserLogin");
               if(_loc2_.length == 0)
               {
                  _loc2_ = "User Login";
               }
               _loc3_ = MovieClip(parent).getXMLText("AdminrMC.Incorrect");
               if(_loc3_.length == 0)
               {
                  _loc3_ = "Incorrect";
               }
               _loc4_ = _loc2_ + " - " + _loc3_;
               txtLoginTitle.text = _loc4_;
            }
         }
         else if(param1.Join == 5219 && param1.Value)
         {
            if(WaitingForAdminPassword())
            {
               _loc2_ = MovieClip(parent).getXMLText("AdminrMC.UserLogin");
               if(_loc2_.length == 0)
               {
                  _loc2_ = "Admin Login";
               }
               _loc3_ = MovieClip(parent).getXMLText("AdminrMC.Incorrect");
               if(_loc3_.length == 0)
               {
                  _loc3_ = "Incorrect";
               }
               _loc4_ = _loc2_ + " - " + _loc3_;
               txtLoginTitle.text = _loc4_;
            }
         }
      }
      
      public function exitpage(param1:MouseEvent) : void
      {
         gotoAndPlay(1);
      }
      
      public function clearErrorText(param1:Event) : *
      {
         if(pwordType == USER_PWD)
         {
            txtLoginTitle.text = MovieClip(parent).getXMLText("AdminrMC.UserLogin");
            ExitTXT.visible = false;
            ExitBttn.visible = false;
         }
         else
         {
            txtLoginTitle.text = MovieClip(parent).getXMLText("AdminrMC.AdminLogin");
            ExitTXT.visible = true;
            ExitBttn.visible = true;
         }
      }
      
      public function sendPassword(param1:KeyboardEvent) : *
      {
         var _loc2_:MouseEvent = null;
         if(param1.keyCode == 13)
         {
            sendpwd(_loc2_);
         }
      }
      
      public function sendpwd(param1:MouseEvent) : *
      {
         var _loc2_:String = Base64.Encode(Admintxt.text);
         if(pwordType == USER_PWD)
         {
            MovieClip(parent).cnx.SendSerial(5063,_loc2_);
         }
         else
         {
            MovieClip(parent).cnx.SendSerial(5063,_loc2_);
         }
         Admintxt.text = "";
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame2() : *
      {
         stop();
         ExitBttn.addEventListener(MouseEvent.CLICK,exitpage);
         btnEnterPwd.addEventListener(MouseEvent.CLICK,sendpwd);
         USendTXT.mouseEnabled = false;
         ExitTXT.mouseEnabled = false;
         txtLoginTitle.addEventListener(TextEvent.TEXT_INPUT,clearErrorText);
         Admintxt.addEventListener(KeyboardEvent.KEY_DOWN,sendPassword);
         Admintxt.text = "";
         if(pwordType == USER_PWD)
         {
            txtLoginTitle.text = MovieClip(parent).getXMLText("AdminrMC.UserLogin");
            ExitTXT.visible = false;
            ExitBttn.visible = false;
         }
         else
         {
            txtLoginTitle.text = MovieClip(parent).getXMLText("AdminrMC.AdminLogin");
            ExitTXT.visible = true;
            ExitBttn.visible = true;
         }
         local_applyUiXml();
      }
   }
}
