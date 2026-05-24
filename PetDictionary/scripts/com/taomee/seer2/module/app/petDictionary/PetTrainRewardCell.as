package com.taomee.seer2.module.app.petDictionary
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="com.taomee.seer2.module.app.petDictionary.PetTrainRewardCell")]
   public dynamic class PetTrainRewardCell extends MovieClip
   {
       
      
      public var txt:TextField;
      
      public var shineMC:MovieClip;
      
      public var nameMC:MovieClip;
      
      public function PetTrainRewardCell()
      {
         super();
      }
   }
}
