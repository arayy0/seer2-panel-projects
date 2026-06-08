package com.taomee.seer2.module.app
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol60")]
   public dynamic class BusinessPanelUI extends MovieClip
   {
      
      public var descriptionTxt:TextField;
      
      public var selectedTabMc:MovieClip;
      
      public var titleMC:MovieClip;
      
      public var totalPriceTxt:TextField;
      
      public var purchaseTabBtn:SimpleButton;
      
      public var sellTabBtn:SimpleButton;
      
      public var next:SimpleButton;
      
      public var prev:SimpleButton;
      
      public var closeBtn:SimpleButton;
      
      public var purchaseBtn:MovieClip;
      
      public var purchasePriceTxt:TextField;
      
      public var thisConisTxt:TextField;
      
      public var purchaseMC:MovieClip;
      
      public var countTxt:TextField;
      
      public var nameTxt:TextField;
      
      public function BusinessPanelUI()
      {
         super();
      }
   }
}

