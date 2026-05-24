package com.taomee.seer2.module.app.newPetDictionary
{
   import flash.events.Event;
   
   public class NewPetDicsEvent extends Event
   {
      
      public static const SHOW_PET_DETAIL:String = "showPetDetail";
       
      
      private var _petResourceId:uint;
      
      public function NewPetDicsEvent(type:String, petResourceId:uint = 0, bubbles:Boolean = false, cancelable:Boolean = false)
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
