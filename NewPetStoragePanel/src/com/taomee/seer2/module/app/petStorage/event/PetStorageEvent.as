package com.taomee.seer2.module.app.petStorage.event
{
   import flash.events.Event;
   
   public class PetStorageEvent extends Event
   {
      
      public static const PET_STORAGE_DATA_CHANGE:String = "petStorageDataChange";
      
      public static const PET_STORAGE_TAB_CHANGE:String = "petStorageTabChange";
      
      public static const SELECTED_PET_CHANGE:String = "selecteddPetChange";
      
      public static const QUERY_PET_LIST:String = "queryPetList";
      
      public static const QUERY_PET_RIDE:String = "QUERY_PET_RIDE";
       
      
      private var _content:*;
      
      public function PetStorageEvent(type:String, content:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this._content = content;
      }
      
      public function get content() : *
      {
         return this._content;
      }
   }
}
