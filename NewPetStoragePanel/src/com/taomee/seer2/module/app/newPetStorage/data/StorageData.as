package com.taomee.seer2.module.app.newPetStorage.data
{
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.core.module.ModuleData;
   import com.taomee.seer2.module.app.petStorage.data.PetStorageDataService;
   import com.taomee.seer2.module.app.petStorage.data.PetStorageQuery;
   
   public class StorageData extends ModuleData
   {
       
      
      private var _dataService:PetStorageDataService;
      
      public function StorageData(data:Object = null)
      {
         super(data);
         this.init();
      }
      
      private function init() : void
      {
         this._dataService = new PetStorageDataService();
         this.reset();
      }
      
      private function onListChange(e:* = null) : void
      {
         emit("pet_list");
      }
      
      public function get query() : PetStorageQuery
      {
         return getData("query");
      }
      
      public function get listDataService() : PetStorageDataService
      {
         return this._dataService;
      }
      
      private function onPetChangePosition(e:* = null) : void
      {
         emit("pet_change_position");
      }
      
      public function get focusePet() : PetInfo
      {
         return getData("focus_pet");
      }

      public function reset():void{
         PetInfoManager.addEventListener("petRemove",this.onPetChangePosition);
         PetInfoManager.addEventListener("petStorageAdd",this.onPetChangePosition);
         PetInfoManager.addEventListener("petBagStorageChange",this.onPetChangePosition);
         PetInfoManager.addEventListener("petStorageRemove",this.onPetChangePosition);
         PetInfoManager.addEventListener("petPutToBag",this.onPetChangePosition);
         this._dataService.addEventListener("petStorageDataChange",this.onListChange);
         this._dataService.includeBagPet = false;
         this._dataService.reset();
         var query:PetStorageQuery = new PetStorageQuery();
         query.dataType = 0;
         query.filterType = 3;
         query.sortType = 0;
         query.isAscending = false;
         setData("query",query);
      }

      public function clear():void{
         this._dataService.removeEventListener("petStorageDataChange",this.onListChange);
         PetInfoManager.removeEventListener("petStorageAdd",this.onPetChangePosition);
         PetInfoManager.removeEventListener("petBagStorageChange",this.onPetChangePosition);
         PetInfoManager.removeEventListener("petStorageRemove",this.onPetChangePosition);
         PetInfoManager.removeEventListener("petPutToBag",this.onPetChangePosition);
         this._dataService.clear();
      }
      
      override public function destory() : void
      {
         this.clear();
         super.destory();
      }
   }
}
