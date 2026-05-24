package com.taomee.seer2.module.app.itemBag
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="com.taomee.seer2.module.app.itemBag.ItemBagCellUI")]
   public dynamic class ItemBagCellUI extends MovieClip
   {
       
      
      public var bg:MovieClip;
      
      public var vipFlag:MovieClip;
      
      public function ItemBagCellUI()
      {
         super();
      }
   }
}
