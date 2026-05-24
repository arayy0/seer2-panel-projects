package com.taomee.seer2.module.app.itemBag.ui.filter
{
   import com.taomee.seer2.module.app.itemBag.ItemBagFilterPageUI;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ItemBagFilterPage extends Sprite
   {
      
      public static const SELECTED_ITEM_CHANGE:String = "selectedItemChange";
       
      
      private var _background:Sprite;
      
      private var _itemContainer:Sprite;
      
      private var _itemVec:Vector.<ItemBagFilterItem>;
      
      private var _dataVec:Vector.<String>;
      
      private var _pageSize:int;
      
      private var _selectedItemIndex:int;
      
      private var _isShow:Boolean;
      
      public function ItemBagFilterPage(dataVec:Vector.<String>)
      {
         super();
         this._dataVec = dataVec;
         this._pageSize = this._dataVec.length;
         this.createChildren();
         this.initEventListener();
      }
      
      private function createChildren() : void
      {
         this.y = 63;
         this.x = 36.5;
         this._background = new ItemBagFilterPageUI();
         addChild(this._background);
         this.createItemVec();
      }
      
      private function createItemVec() : void
      {
         var item:ItemBagFilterItem = null;
         var padding:int = 25;
         this._itemContainer = new Sprite();
         this._itemContainer.x = 0;
         this._itemContainer.y = 5;
         this._itemVec = new Vector.<ItemBagFilterItem>();
         addChild(this._itemContainer);
         for(var i:int = 0; i < this._pageSize; i++)
         {
            item = new ItemBagFilterItem();
            item.setData(this._dataVec[i]);
            item.x = 6.5;
            item.y = i * padding;
            this._itemContainer.addChild(item);
            this._itemVec.push(item);
         }
         this._background.height = this._itemContainer.height + 10;
      }
      
      private function initEventListener() : void
      {
         this.mouseEnabled = false;
         for(var i:int = 0; i < this._pageSize; i++)
         {
            this._itemVec[i].addEventListener(MouseEvent.CLICK,this.onItemClick);
         }
      }
      
      private function onItemClick(evt:MouseEvent) : void
      {
         evt.stopPropagation();
         var target:ItemBagFilterItem = evt.currentTarget as ItemBagFilterItem;
         for(var i:int = 0; i < this._pageSize; i++)
         {
            if(target == this._itemVec[i])
            {
               if(this._selectedItemIndex == i)
               {
                  return;
               }
               this._selectedItemIndex = i;
               this._itemVec[i].isSelected = true;
            }
            else
            {
               this._itemVec[i].isSelected = false;
            }
         }
         dispatchEvent(new Event(SELECTED_ITEM_CHANGE));
      }
      
      public function reset() : void
      {
         this.hide();
         this.clearSelectedItem();
      }
      
      public function hide() : void
      {
         this._isShow = false;
         this.toggle();
      }
      
      private function clearSelectedItem() : void
      {
         this._selectedItemIndex = -1;
         for(var i:int = 0; i < this._pageSize; i++)
         {
            this._itemVec[i].isSelected = false;
         }
      }
      
      public function toggle() : void
      {
         this.visible = this._isShow;
         this._isShow = !this._isShow;
      }
      
      public function setExtension(extension:ItemBagFilterExtension, index:int) : void
      {
         this._itemVec[index].extension = extension;
      }
      
      public function get selectedItemIndex() : int
      {
         return this._selectedItemIndex;
      }
      
      public function get selectedItem() : ItemBagFilterItem
      {
         return this._itemVec[this._selectedItemIndex];
      }
   }
}
