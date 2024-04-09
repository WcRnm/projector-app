package CrestronUI_60K_2_fla
{
   import Crestron.CNXConnection;
   import CrestronDLP.ExtendedCommand;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public dynamic class pictmodePopup_45 extends MovieClip
   {
       
      
      public var l_Bttn:SimpleButton;
      
      public var gaugeMC:MovieClip;
      
      public var r_Bttn:SimpleButton;
      
      public var closeBttn:SimpleButton;
      
      public var slidername:TextField;
      
      public var objs:Array;
      
      public function pictmodePopup_45()
      {
         super();
         addFrameScript(0,frame1,11,frame12);
      }
      
      public function closepopup(param1:MouseEvent) : void
      {
         gotoAndPlay("close");
      }
      
      public function rampdownstart(param1:Event) : *
      {
         var _loc2_:uint = MovieClip(parent).extCmd.cmdjoin[ExtendedCommand.JOIN_RAMPDOWN];
         MovieClip(parent).cnx.SendDigital(_loc2_,1);
      }
      
      public function rampdownstop(param1:Event) : *
      {
         var _loc2_:uint = MovieClip(parent).extCmd.cmdjoin[ExtendedCommand.JOIN_RAMPDOWN];
         MovieClip(parent).cnx.SendDigital(_loc2_,0);
      }
      
      public function rampupstart(param1:Event) : *
      {
         var _loc2_:uint = MovieClip(parent).extCmd.cmdjoin[ExtendedCommand.JOIN_RAMPUP];
         MovieClip(parent).cnx.SendDigital(_loc2_,1);
      }
      
      public function rampupstop(param1:Event) : *
      {
         var _loc2_:uint = MovieClip(parent).extCmd.cmdjoin[ExtendedCommand.JOIN_RAMPUP];
         MovieClip(parent).cnx.SendDigital(_loc2_,0);
      }
      
      public function setJoinVal() : *
      {
         if(gaugeMC == null)
         {
            return;
         }
         var _loc1_:uint = 0;
         if(MovieClip(parent).analogs[MovieClip(parent).extCmd.cmdjoin[ExtendedCommand.JOIN_RAMPED]] != undefined)
         {
            _loc1_ = MovieClip(parent).analogs[MovieClip(parent).extCmd.cmdjoin[ExtendedCommand.JOIN_RAMPED]];
         }
         var _loc2_:Number = Math.ceil(_loc1_ / 65536 * 255);
         gaugeMC.gotoAndStop(_loc2_ + 2);
      }
      
      public function onAnalog(param1:Event) : *
      {
         setJoinVal();
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame12() : *
      {
         stop();
         this.closeBttn.addEventListener(MouseEvent.CLICK,closepopup);
         l_Bttn.addEventListener(MouseEvent.MOUSE_DOWN,rampdownstart);
         l_Bttn.addEventListener(MouseEvent.MOUSE_UP,rampdownstop);
         r_Bttn.addEventListener(MouseEvent.MOUSE_DOWN,rampupstart);
         r_Bttn.addEventListener(MouseEvent.MOUSE_UP,rampupstop);
         objs = new Array();
         objs.push(l_Bttn);
         objs.push(r_Bttn);
         objs.push(closeBttn);
         MovieClip(parent).ThemeButtonObjects(objs,MovieClip(parent).projconfig.ui_color);
         objs = new Array();
         objs.push(gaugeMC);
         MovieClip(parent).ThemeObjects(objs,MovieClip(parent).projconfig.ui_color);
         slidername.text = MovieClip(parent).extCmd.cmdname;
         setJoinVal();
         MovieClip(parent).cnx.addEventListener(CNXConnection.ANALOG,onAnalog);
      }
   }
}
