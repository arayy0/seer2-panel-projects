package com.taomee.seer2.module.app.itemBag.ui
{
   import com.taomee.seer2.app.actor.constant.EquipSlot;
   import com.taomee.seer2.app.inventory.item.EquipItem;
   import com.taomee.seer2.core.inventory.Item;
   import com.taomee.seer2.module.app.itemBag.cell.ItemBagCell;
   import com.taomee.seer2.module.app.itemBag.cell.ItemBagEquipCell;
   import flash.display.Sprite;
   
   public class ItemBagEquip extends Sprite
   {
      
      private static var _equipSlotVec:Vector.<int>;
      
      {
         initialize();
      }
      
      private var _itemCellVec:Vector.<ItemBagCell>;
      
      private var _equipItemVec:Vector.<EquipItem>;
      
      public function ItemBagEquip()
      {
         super();
         this.createChildren();
      }
      
      private static function initialize() : void
      {
         _equipSlotVec = Vector.<int>([EquipSlot.HEAD,EquipSlot.WING,EquipSlot.HAND_RIGHT,EquipSlot.BELT,EquipSlot.FOOT_RIGHT,EquipSlot.DOGZ_RIGHT]);
      }
      
      private function createChildren() : void
      {
         var cell:ItemBagCell = null;
         this._itemCellVec = new Vector.<ItemBagCell>();
         var horizontalNum:int = 2;
         var horizontalMargin:int = 10;
         var horizontalPadding:int = 280;
         var verticalMargin:int = 80;
         var verticalPadding:int = 100;
         var length:int = 6;
         for(var i:int = 0; i < length; i++)
         {
            cell = new ItemBagEquipCell();
            cell.x = horizontalMargin + i % horizontalNum * horizontalPadding;
            cell.y = verticalMargin + int(i / horizontalNum) * verticalPadding;
            addChild(cell);
            this._itemCellVec.push(cell);
         }
      }
      
      public function setData(equipVec:Vector.<EquipItem>) : void
      {
         this._equipItemVec = equipVec;
         this.updateNonoEquip();
         this.updateDisplay();
      }
      
      private function updateNonoEquip() : void
      {
         var count:int = int(this._equipItemVec.length);
         var list:Vector.<EquipItem> = Vector.<EquipItem>([]);
         for(var i:int = 0; i < count; i++)
         {
            if(this._equipItemVec[i].referenceId < 102000 || this._equipItemVec[i].referenceId > 102999)
            {
               list.push(this._equipItemVec[i]);
            }
         }
         this._equipItemVec = list;
      }
      
      protected function updateDisplay() : void
      {
         var slotIndex:int = 0;
         var item:Item = null;
         var count:int = int(_equipSlotVec.length);
         for(var i:int = 0; i < count; i++)
         {
            slotIndex = _equipSlotVec[i];
            item = this.getItemBySlotIndex(slotIndex);
            this._itemCellVec[i].setData(item);
         }
      }
      
      private function getItemBySlotIndex(slotIndex:int) : Item
      {
         var equipItem:EquipItem = null;
         var count:int = int(this._equipItemVec.length);
         for(var i:int = 0; i < count; i++)
         {
            equipItem = this._equipItemVec[i];
            if(equipItem.slotIndex == slotIndex)
            {
               return equipItem;
            }
         }
         return null;
      }
   }
}
