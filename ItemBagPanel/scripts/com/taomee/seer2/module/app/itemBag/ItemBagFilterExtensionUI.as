package com.taomee.seer2.module.app.itemBag
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   [Embed(source="/_assets/assets.swf", symbol="com.taomee.seer2.module.app.itemBag.ItemBagFilterExtensionUI")]
   public dynamic class ItemBagFilterExtensionUI extends MovieClip
   {
       
      
      public var up:SimpleButton;
      
      public var down:SimpleButton;
      
      public function ItemBagFilterExtensionUI()
      {
         super();
      }
   }
}
