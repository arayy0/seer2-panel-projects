package com.taomee.seer2.module.app.itemBag
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="com.taomee.seer2.module.app.itemBag.ItemBagFilterMenuUI")]
   public dynamic class ItemBagFilterMenuUI extends MovieClip
   {
       
      
      public var description:TextField;
      
      public var titleBg:MovieClip;
      
      public var indicator:MovieClip;
      
      public function ItemBagFilterMenuUI()
      {
         super();
      }
   }
}
