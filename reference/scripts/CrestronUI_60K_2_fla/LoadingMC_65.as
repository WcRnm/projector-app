package CrestronUI_60K_2_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class LoadingMC_65 extends MovieClip
   {
       
      
      public var lblloadingMC_txt:TextField;
      
      public var loadingText:TextField;
      
      public var ltext:String;
      
      public var str_lblloadingMC_txt:String;
      
      public var str_loadingText:String;
      
      public function LoadingMC_65()
      {
         super();
         addFrameScript(0,frame1,11,frame12);
      }
      
      public function setText(param1:String) : *
      {
         this.gotoAndStop(12);
         if(this.loadingText != undefined && this.loadingText != null)
         {
            this.loadingText.text = param1;
         }
         ltext = param1;
      }
      
      function frame1() : *
      {
         stop();
         ltext = "";
      }
      
      function frame12() : *
      {
         stop();
         if(ltext != null)
         {
            loadingText.text = ltext;
         }
         str_lblloadingMC_txt = "";
         try
         {
            str_lblloadingMC_txt = MovieClip(parent).getXMLText("loadingMC.lbl_loadingMC_txt");
         }
         catch(e:Error)
         {
            str_lblloadingMC_txt = "LOADING PROMPT";
         }
         if(str_lblloadingMC_txt.length == 0)
         {
            str_lblloadingMC_txt = "LOADING PROMPT";
         }
         if(str_lblloadingMC_txt.length > 0)
         {
            lblloadingMC_txt.text = str_lblloadingMC_txt;
         }
         str_loadingText = "";
         try
         {
            str_loadingText = MovieClip(parent).getXMLText("loadingMC.loadingText");
         }
         catch(e:Error)
         {
            str_loadingText = "Loading...";
         }
         if(str_loadingText.length == 0)
         {
            str_loadingText = "Loading...";
         }
         if(str_loadingText.length > 0)
         {
            loadingText.text = str_loadingText;
         }
      }
   }
}
