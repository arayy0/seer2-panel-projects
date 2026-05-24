package com.taomee.seer2.module.app.lottery
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="com.taomee.seer2.module.app.lottery.StayAtHomePanelUI")]
   public dynamic class StayAtHomePanelUI extends MovieClip
   {
       
      
      public var an_mc:MovieClip;
      
      public var closeBtn:SimpleButton;
      
      public var lottoBtn:SimpleButton;
      
      public var countTxt:TextField;
      
      public function StayAtHomePanelUI()
      {
         super();
      }
   }
}
