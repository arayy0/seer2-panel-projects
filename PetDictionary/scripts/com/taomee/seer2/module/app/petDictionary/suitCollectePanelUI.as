package com.taomee.seer2.module.app.petDictionary
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="com.taomee.seer2.module.app.petDictionary.suitCollectePanelUI")]
   public dynamic class suitCollectePanelUI extends MovieClip
   {
       
      
      public var suitName:TextField;
      
      public var newMc:MovieClip;
      
      public var nameTxt:TextField;
      
      public function suitCollectePanelUI()
      {
         super();
      }
   }
}
