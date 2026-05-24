package com.taomee.seer2.module.app.itemBag.events
{
   import flash.events.Event;
   
   public class ItemBagEvent extends Event
   {
      
      public static const REQUEST_ADD_EQUIP:String = "requestAddEquip";
      
      public static const REQUEST_REMOVE_EQUIP:String = "requestRemoveEquip";
      
      public static const QUERY_ITEM_LIST:String = "queryItemList";
      
      public static const QUERY_ITEM_REFERES:String = "queryItemReferes";
      
      public static const QUERY_SUIT:String = "querySuit";

      public static const QUERY_SEARCH:String = "querySearch";
       
      
      private var _content:*;
      
      public function ItemBagEvent(type:String, content:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
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
