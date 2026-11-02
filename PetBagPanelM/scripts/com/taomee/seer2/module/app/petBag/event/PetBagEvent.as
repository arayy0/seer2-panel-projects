package com.taomee.seer2.module.app.petBag.event
{
   import com.taomee.seer2.app.pet.data.PetInfo;
   import flash.events.Event;
   
   public class PetBagEvent extends Event
   {
      
      public static const PET_DATA_CHANGE:String = "petDataChange";
      
      public static const PET_SELCTED:String = "petSelected";
      
      public static const PET_ADDED_HP:String = "petAddedHp";
      
      public static const TRAINING_PET_ERROR:String = "petTrainingError";
       
      
      private var _info:PetInfo;
      
      public function PetBagEvent(type:String, info:PetInfo = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this._info = info;
      }
      
      public function get petInfo() : PetInfo
      {
         return this._info;
      }
   }
}
