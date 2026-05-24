package com.taomee.seer2.module.app.itemBag.cell
{
   import com.taomee.seer2.module.app.itemBag.events.ItemBagEvent;
   import flash.events.MouseEvent;
   
   public class ItemBagEquipCell extends ItemBagCell
   {
       
      
      public function ItemBagEquipCell()
      {
         super();
         _isChangeBackground = false;
         _isShowNumber = false;
         _isHandCursor = true;
      }
      
      override protected function onMouseClick(evt:MouseEvent) : void
      {
         dispatchEvent(new ItemBagEvent(ItemBagEvent.REQUEST_REMOVE_EQUIP,_item,true));
      }
   }
}
