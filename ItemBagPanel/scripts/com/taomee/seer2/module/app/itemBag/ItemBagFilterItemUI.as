package com.taomee.seer2.module.app.itemBag
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="com.taomee.seer2.module.app.itemBag.ItemBagFilterItemUI")]
   public dynamic class ItemBagFilterItemUI extends MovieClip
   {
       
      
      public var description:TextField;
      
      public var bg:MovieClip;
      
      public function ItemBagFilterItemUI()
      {
         super();
      }
   }
}
