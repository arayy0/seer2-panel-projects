package com.taomee.seer2.module.app.userPanel
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="com.taomee.seer2.module.app.userPanel.UserPanelTitleItemUI")]
   public dynamic class UserPanelTitleItemUI extends MovieClip
   {
       
      
      public var selected:MovieClip;
      
      public var title:TextField;
      
      public function UserPanelTitleItemUI()
      {
         super();
      }
   }
}
