package com.taomee.seer2.module.app.userPanel
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="com.taomee.seer2.module.app.userPanel.UserPanelTitleUI")]
   public dynamic class UserPanelTitleUI extends MovieClip
   {
       
      
      public var titleBg:MovieClip;
      
      public var title:TextField;
      
      public var select:MovieClip;
      
      public function UserPanelTitleUI()
      {
         super();
      }
   }
}
