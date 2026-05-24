package com.taomee.seer2.module.app.appraisal
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   [Embed(source="/_assets/assets.swf", symbol="com.taomee.seer2.module.app.appraisal.AppraisalPanelUI")]
   public dynamic class AppraisalPanelUI extends MovieClip
   {
       
      
      public var ssTxt:MovieClip;
      
      public var appraisalTxt:MovieClip;
      
      public var petList:MovieClip;
      
      public var bagButton:SimpleButton;
      
      public var petContainer:MovieClip;
      
      public var appraisalButton:SimpleButton;
      
      public var closeBtn:SimpleButton;
      
      public var storageButton:SimpleButton;
      
      public function AppraisalPanelUI()
      {
         super();
      }
   }
}
