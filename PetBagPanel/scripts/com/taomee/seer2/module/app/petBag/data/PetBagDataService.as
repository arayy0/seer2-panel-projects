package com.taomee.seer2.module.app.petBag.data
{
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.pet.events.PetInfoEvent;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.module.app.petBag.event.PetBagEvent;
   import flash.events.EventDispatcher;
   
   public class PetBagDataService extends EventDispatcher
   {
       
      
      public function PetBagDataService()
      {
         super();
      }
      
      public function reloadEventListener() : void
      {
         this.addPetInfoEventListener();
         this.addPetCommandErrorListener();
      }
      
      private function addPetCommandErrorListener() : void
      {
         Connection.addErrorHandler(CommandSet.PET_TRAINING_START_1039,this.onSetPetTrainingError);
      }
      
      private function removePetCommandErrorListener() : void
      {
         Connection.removeErrorHandler(CommandSet.PET_TRAINING_START_1039,this.onSetPetTrainingError);
      }
      
      private function onSetPetTrainingError(event:MessageEvent) : void
      {
         if(event.message.statusCode == 104341)
         {
            AlertManager.showAlert("训练的精灵超过上限");
            dispatchEvent(new PetBagEvent("petTrainingError"));
         }
      }
      
      public function clearEventListener() : void
      {
         this.removePetInfoEventListener();
         this.removePetCommandErrorListener();
      }
      
      private function addPetInfoEventListener() : void
      {
         PetInfoManager.addEventListener("petAdd",this.onPetAdd);
         PetInfoManager.addEventListener("petRemove",this.onPetRemove);
         PetInfoManager.addEventListener("petChangeStart",this.onPetStart);
         PetInfoManager.addEventListener("petChangeSub",this.onPetSub);
         PetInfoManager.addEventListener("petCure",this.onPetCure);
         PetInfoManager.addEventListener("petStorageAdd",this.onPetAdd);
         PetInfoManager.addEventListener("petBagStorageChange",this.onPetChange);
         PetInfoManager.addEventListener("petStorageRemove",this.onPetRemove);
      }
      
      private function removePetInfoEventListener() : void
      {
         PetInfoManager.removeEventListener("petAdd",this.onPetAdd);
         PetInfoManager.removeEventListener("petRemove",this.onPetRemove);
         PetInfoManager.removeEventListener("petChangeStart",this.onPetStart);
         PetInfoManager.removeEventListener("petChangeSub",this.onPetSub);
         PetInfoManager.removeEventListener("petCure",this.onPetCure);
      }
      
      private function onPetAdd(evt:PetInfoEvent) : void
      {
         dispatchEvent(new PetBagEvent("petDataChange"));
      }
      
      private function onPetChange(evt:PetInfoEvent) : void
      {
         dispatchEvent(new PetBagEvent("petDataChange"));
      }
      
      private function onPetRemove(evt:PetInfoEvent) : void
      {
         dispatchEvent(new PetBagEvent("petDataChange"));
      }
      
      private function onPetSub(evt:PetInfoEvent) : void
      {
         dispatchEvent(new PetBagEvent("petDataChange"));
      }
      
      private function onPetStart(evt:PetInfoEvent) : void
      {
         dispatchEvent(new PetBagEvent("petDataChange"));
      }
      
      private function onPetCure(evt:PetInfoEvent) : void
      {
         dispatchEvent(new PetBagEvent("petAddedHp",evt.info));
      }
      
      public function get petInfoVec() : Vector.<PetInfo>
      {
         return PetInfoManager.getAllBagPetInfo().slice();
      }
      
      public function get petInfoStorageVec() : Vector.<PetInfo>
      {
         return PetInfoManager.getAllBagPetStorageInfo().slice();
      }
   }
}
