package com.taomee.seer2.module.app.newPetStorage.view
{
   import com.taomee.seer2.core.manager.EventListenerManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.module.app.NewPetStoragePanel;
   import com.taomee.seer2.module.app.newPetStorage.data.StorageData;
   import flash.display.MovieClip;
   
   public class StorageSubView
   {
       
      
      protected var _ui:MovieClip;
      
      private var _eventListenerMgr:EventListenerManager;
      
      private var _subPanels:Array;
      
      public function StorageSubView(ui:MovieClip)
      {
         super();
         this._ui = ui;
      }
      
      public function get moduleData() : StorageData
      {
         var storageModule:NewPetStoragePanel = ModuleManager.getModule("NewPetStoragePanel").module as NewPetStoragePanel;
         return storageModule.moduleData;
      }
      
      protected function get eventListenerMgr() : EventListenerManager
      {
         if(this._eventListenerMgr == null)
         {
            this._eventListenerMgr = new EventListenerManager();
         }
         return this._eventListenerMgr;
      }
      
      protected function addSubPanel(subPanel:StorageSubView) : void
      {
         if(this._subPanels == null)
         {
            this._subPanels = [];
         }
         this._subPanels.push(subPanel);
      }
      
      public function destory() : void
      {
         var i:int = 0;
         if(this._eventListenerMgr != null)
         {
            this._eventListenerMgr.clear();
            this._eventListenerMgr = null;
         }
         if(this._subPanels != null)
         {
            for(i = 0; i < this._subPanels.length; )
            {
               (this._subPanels[i] as StorageSubView).destory();
               i++;
            }
         }
         this._ui = null;
      }
   }
}
