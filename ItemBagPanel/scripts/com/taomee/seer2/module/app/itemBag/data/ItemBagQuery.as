package com.taomee.seer2.module.app.itemBag.data
{
   public class ItemBagQuery
   {
       
      
      private var _type:int;
      
      private var _content:*;
      
      public function ItemBagQuery(type:int, content:* = null)
      {
         super();
         this._type = type;
         this._content = content;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function get content() : *
      {
         return this._content;
      }
   }
}
