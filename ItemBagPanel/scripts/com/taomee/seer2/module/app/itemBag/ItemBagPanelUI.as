package com.taomee.seer2.module.app.itemBag
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="com.taomee.seer2.module.app.itemBag.ItemBagPanelUI")]
   public dynamic class ItemBagPanelUI extends MovieClip
   {
       
      
      public var userBtn:SimpleButton;
      
      public var zuanTxt:TextField;
      
      public var conisTxt:TextField;
      
      public var closeBtn:SimpleButton;
      
      public var dragMC:MovieClip;
      
      public function ItemBagPanelUI()
      {
         super();
      }
   }
}
