package com.taomee.seer2.module.app.petDictionary
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   [Embed(source="/_assets/assets.swf", symbol="com.taomee.seer2.module.app.petDictionary.suitCollecteCellUI")]
   public dynamic class suitCollecteCellUI extends MovieClip
   {
       
      
      public var receivedBtn:MovieClip;
      
      public var shineMC:MovieClip;
      
      public var icon_0:DictionaryCellUI;
      
      public var icon_1:DictionaryCellUI;
      
      public var rewardIcon:MovieClip;
      
      public var icon_2:DictionaryCellUI;
      
      public var getRewardBtn:SimpleButton;
      
      public var levelBg:MovieClip;
      
      public function suitCollecteCellUI()
      {
         super();
      }
   }
}
