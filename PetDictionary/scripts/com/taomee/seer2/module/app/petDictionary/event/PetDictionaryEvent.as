package com.taomee.seer2.module.app.petDictionary.event
{
   import flash.events.Event;
   
   public class PetDictionaryEvent extends Event
   {
      
      public static const SHOW_PET_DETAIL:String = "showPetDetail";
      
      public static const HIDE_PET_DETAIL:String = "hidePetDetail";
      
      public static const COLLECT_PET_SHINE:String = "collectPetShine";
      
      public static const TRAIN_PET_SHINE:String = "trainPetShine";
       
      
      private var _petResourceId:uint;
      
      public function PetDictionaryEvent(type:String, petResourceId:uint = 0, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this._petResourceId = petResourceId;
      }
      
      public function getPetResourceId() : uint
      {
         return this._petResourceId;
      }
   }
}
