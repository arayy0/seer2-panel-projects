package com.taomee.seer2.module.core
{
   import com.taomee.seer2.app.controls.MapTitlePanel;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.module.Module;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.utils.LifecycleType;
   import com.taomee.seer2.core.utils.URLUtil;
   
   public class TopModule extends Module
   {
      
      protected var _fullName:String;
      
      public function TopModule()
      {
         super();
         _lifecycleType = LifecycleType.GLOBAL;
      }
      
      override public function show() : void
      {
         super.show();
         MapTitlePanel.hide();
         ++ModuleManager.topNum;
      }
      
      override public function hide() : void
      {
         super.hide();
         --ModuleManager.topNum;
         if(ModuleManager.topNum == 0)
         {
            MapTitlePanel.show();
         }
      }
      
      protected function playFull(skip:Boolean = false) : void
      {
         MovieClipUtil.playFullScreen(URLUtil.getActivityFullScreen(this._fullName),null,true,skip);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         MapTitlePanel.show();
      }
   }
}

