package com.taomee.seer2.module.app
{
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.utils.LifecycleType;
   import com.taomee.seer2.module.app.newPetStorage.data.StorageData;
   import com.taomee.seer2.module.app.newPetStorage.view.PetInfoPanel;
   import com.taomee.seer2.module.app.newPetStorage.view.bagList.BagPets;
   import com.taomee.seer2.module.app.newPetStorage.view.storage.StorageMainPanel;
   import com.taomee.seer2.core.module.Module;
   import flash.events.MouseEvent;
   
   public class NewPetStoragePanel extends Module
   {
       
      
      private var _moduleData:StorageData;
      
      private var _subPanels:Array;
      
      public function NewPetStoragePanel()
      {
         this._subPanels = [];
         super();
         _lifecycleType = LifecycleType.NONCE;
         this._moduleData = new StorageData();
      }

      override public function setup():void{
         setMainUI(new NewPetStorageUI());
         this.initSet();
         this.initEvent();
      }
      
      private function initSet() : void
      {
         this._subPanels.push(new BagPets(_mainUI["bagPets"]));
         this._subPanels.push(new PetInfoPanel(_mainUI["petInfo"]));
         this._subPanels.push(new StorageMainPanel(_mainUI["storage"]));
         this.moduleData.setData("focus_pet",PetInfoManager.getFirstPetInfo());
      }

      private function initEvent():void{
         this._mainUI["petBagBtn"].addEventListener("click",this.onPanelClick);
         this._mainUI["oldPetStorageBtn"].addEventListener("click",this.onPanelClick);
      }
      
      private function onPanelClick(e:MouseEvent) : void
      {
         switch(e.target.name)
         {
            case "petBagBtn":
               onClose(null);
               ModuleManager.showAppModule("PetBagPanel");
               break;
            case "oldPetStorageBtn":
               onClose(null);
               ServerBufferManager.updateServerBuffer(461,8,0);
               ModuleManager.showAppModule("PetStoragePanel");
         }
      }
      
      public function get moduleData() : StorageData
      {
         return this._moduleData;
      }
      
      override public function dispose() : void
      {
         this._moduleData.destory();
         super.dispose();
      }
   }
}
