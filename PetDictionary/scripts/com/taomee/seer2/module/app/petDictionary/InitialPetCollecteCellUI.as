package com.taomee.seer2.module.app.petDictionary
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="com.taomee.seer2.module.app.petDictionary.InitialPetCollecteCellUI")]
   public dynamic class InitialPetCollecteCellUI extends MovieClip
   {
       
      
      public var receivedBtn:MovieClip;
      
      public var monstIcon:MovieClip;
      
      public var shineMC:MovieClip;
      
      public var rewardIcon:MovieClip;
      
      public var rewardPetName:TextField;
      
      public var getRewardBtn:SimpleButton;
      
      public var initialIcon:MovieClip;
      
      public function InitialPetCollecteCellUI()
      {
         super();
      }
   }
}
