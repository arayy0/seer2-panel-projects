package com.taomee.seer2.module.app.itemBag
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="com.taomee.seer2.module.app.itemBag.ItemBagNickUI")]
   public dynamic class ItemBagNickUI extends MovieClip
   {
       
      
      public var decorationMC:MovieClip;
      
      public var nick:TextField;
      
      public var changeNick:SimpleButton;
      
      public var yearVipMC:MovieClip;
      
      public var passWordBtn:SimpleButton;
      
      public var saveNick:SimpleButton;
      
      public function ItemBagNickUI()
      {
         super();
      }
   }
}
