package CrestronUI_60K_2_fla
{
   import CrestronDLP.ExtendedCommand;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public dynamic class ZoomPopup_46 extends MovieClip
   {
       
      
      public var leftbtn:SimpleButton;
      
      public var rightbtn:SimpleButton;
      
      public var upbtn:SimpleButton;
      
      public var zoominbtn:SimpleButton;
      
      public var zoomoutbtn:SimpleButton;
      
      public var downbtn:SimpleButton;
      
      public var closeBttn:SimpleButton;
      
      public var txtHeader:TextField;
      
      public var objs:Array;
      
      public function ZoomPopup_46()
      {
         super();
         addFrameScript(0,frame1,11,frame12);
      }
      
      public function closepopup(param1:MouseEvent) : void
      {
         gotoAndPlay("close");
      }
      
      public function zoomin(param1:Event) : *
      {
         var _loc2_:uint = MovieClip(parent).extCmd.cmdjoin[ExtendedCommand.JOIN_ZOOMIN];
         MovieClip(parent).cnx.SendDigital(_loc2_,1);
         MovieClip(parent).cnx.SendDigital(_loc2_,0);
      }
      
      public function zoomout(param1:Event) : *
      {
         var _loc2_:uint = MovieClip(parent).extCmd.cmdjoin[ExtendedCommand.JOIN_ZOOMOUT];
         MovieClip(parent).cnx.SendDigital(_loc2_,1);
         MovieClip(parent).cnx.SendDigital(_loc2_,0);
      }
      
      public function panup(param1:Event) : *
      {
         var _loc2_:uint = MovieClip(parent).extCmd.cmdjoin[ExtendedCommand.JOIN_PAN_UP];
         MovieClip(parent).cnx.SendDigital(_loc2_,1);
         MovieClip(parent).cnx.SendDigital(_loc2_,0);
      }
      
      public function panleft(param1:Event) : *
      {
         var _loc2_:uint = MovieClip(parent).extCmd.cmdjoin[ExtendedCommand.JOIN_PAN_LEFT];
         MovieClip(parent).cnx.SendDigital(_loc2_,1);
         MovieClip(parent).cnx.SendDigital(_loc2_,0);
      }
      
      public function panright(param1:Event) : *
      {
         var _loc2_:uint = MovieClip(parent).extCmd.cmdjoin[ExtendedCommand.JOIN_PAN_RIGHT];
         MovieClip(parent).cnx.SendDigital(_loc2_,1);
         MovieClip(parent).cnx.SendDigital(_loc2_,0);
      }
      
      public function pandown(param1:Event) : *
      {
         var _loc2_:uint = MovieClip(parent).extCmd.cmdjoin[ExtendedCommand.JOIN_PAN_DOWN];
         MovieClip(parent).cnx.SendDigital(_loc2_,1);
         MovieClip(parent).cnx.SendDigital(_loc2_,0);
      }
      
      function frame1() : *
      {
         stop();
      }
      
      function frame12() : *
      {
         stop();
         this.closeBttn.addEventListener(MouseEvent.CLICK,closepopup);
         zoominbtn.addEventListener(MouseEvent.CLICK,zoomin);
         zoomoutbtn.addEventListener(MouseEvent.CLICK,zoomout);
         upbtn.addEventListener(MouseEvent.CLICK,panup);
         leftbtn.addEventListener(MouseEvent.CLICK,panleft);
         rightbtn.addEventListener(MouseEvent.CLICK,panright);
         downbtn.addEventListener(MouseEvent.CLICK,pandown);
         objs = new Array();
         objs.push(zoominbtn);
         objs.push(zoomoutbtn);
         objs.push(upbtn);
         objs.push(downbtn);
         objs.push(leftbtn);
         objs.push(rightbtn);
         objs.push(closeBttn);
         MovieClip(parent).ThemeButtonObjects(objs,MovieClip(parent).projconfig.ui_color);
         txtHeader.text = MovieClip(parent).extCmd.cmdname;
      }
   }
}
