package com.taomee.seer2.module.app.newPetStorage.view.bagList
{
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.module.app.newPetStorage.view.StorageSubView;
   import flash.display.MovieClip;
   
   public class BagPets extends StorageSubView
   {
       
      
      private var _cellList:Array;
      
      public function BagPets(ui:MovieClip)
      {
         this._cellList = [];
         super(ui);
         this.initCellList();
         moduleData.listenTo("pet_change_position",this.onPetChangePosition);
         this.onPetChangePosition();
      }
      
      private function initCellList() : void
      {
         var i:int = 0;
         var cell:PetCell = null;
         for(i = 0; i < 12; )
         {
            cell = new PetCell(_ui["cell" + i],i);
            this._cellList.push(cell);
            addSubPanel(cell);
            i++;
         }
      }
      
      private function onPetChangePosition() : void
      {
         var i:int = 0;
         var petInfo:PetInfo = null;
         var list:Vector.<PetInfo> = null;
         var cell:PetCell = null;
         var list0:Vector.<PetInfo> = PetInfoManager.getAllBagPetInfo().slice();
         for(i = 0; i < list0.length; )
         {
            petInfo = list0[i];
            if(Boolean(petInfo) && Boolean(petInfo.isStarting))
            {
               list0.splice(i,1);
               list0.unshift(petInfo);
               break;
            }
            i++;
         }
         var list1:Vector.<PetInfo> = PetInfoManager.getAllBagPetStorageInfo();
         for(i = 0; i < 12; )
         {
            list = i >= 6 ? list1 : list0;
            cell = this._cellList[i];
            if(list.length > i % 6)
            {
               cell.setPetInfo(list[i % 6]);
            }
            else
            {
               cell.setPetInfo(null);
            }
            i++;
         }
      }
   }
}
