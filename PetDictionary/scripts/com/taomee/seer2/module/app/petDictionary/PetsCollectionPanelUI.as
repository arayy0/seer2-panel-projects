package com.taomee.seer2.module.app.petDictionary
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   [Embed(source="/_assets/assets.swf", symbol="com.taomee.seer2.module.app.petDictionary.PetsCollectionPanelUI")]
   public dynamic class PetsCollectionPanelUI extends MovieClip
   {
       
      
      public var preBtn:SimpleButton;
      
      public var nextBtn:SimpleButton;
      
      public function PetsCollectionPanelUI()
      {
         super();
      }
   }
}
