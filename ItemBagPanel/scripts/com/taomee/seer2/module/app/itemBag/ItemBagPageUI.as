package com.taomee.seer2.module.app.itemBag
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="com.taomee.seer2.module.app.itemBag.ItemBagPageUI")]
   public dynamic class ItemBagPageUI extends MovieClip
   {
       
      
      public var next:SimpleButton;
      
      public var previous:SimpleButton;
      
      public var page:TextField;
      
      public function ItemBagPageUI()
      {
         super();
      }
   }
}
