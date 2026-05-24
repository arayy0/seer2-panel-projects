package com.taomee.seer2.module.app.honor
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   [Embed(source="/_assets/assets.swf", symbol="com.taomee.seer2.module.app.honor.HonorPetSelectUI")]
   public dynamic class HonorPetSelectUI extends MovieClip
   {
       
      
      public var yesBtn:SimpleButton;
      
      public var noBtn:SimpleButton;
      
      public function HonorPetSelectUI()
      {
         super();
      }
   }
}
