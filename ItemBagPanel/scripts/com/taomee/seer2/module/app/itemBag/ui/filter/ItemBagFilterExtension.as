package com.taomee.seer2.module.app.itemBag.ui.filter
{
   import com.taomee.seer2.app.config.item.SuitDefinition;
   import com.taomee.seer2.module.app.itemBag.ItemBagFilterExtensionUI;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ItemBagFilterExtension extends Sprite
   {
      
      public static const SELECTED_ITEM_CHANGE:String = "selectedItemChange";
      
      private static var MAX_NUM:int = 6;
       
      
      private var _container:MovieClip;
      
      private var _upBtn:SimpleButton;
      
      private var _downBtn:SimpleButton;
      
      private var _itemVec:Vector.<ItemBagFilterItem>;
      
      private var _suitVec:Vector.<SuitDefinition>;
      
      private var _offsetIndex:int;
      
      private var _selectedSuitID:int;
      
      public function ItemBagFilterExtension()
      {
         super();
         this.initialize();
      }
      
      private function initialize() : void
      {
         this.createChildren();
         this.initEventListener();
      }
      
      private function createChildren() : void
      {
         this.x = 100;
         this.y = -23;
         this._container = new ItemBagFilterExtensionUI();
         addChild(this._container);
         this._upBtn = this._container["up"];
         this._downBtn = this._container["down"];
         this.createItemVec();
      }
      
      private function createItemVec() : void
      {
         var item:ItemBagFilterItem = null;
         var leftMargin:int = 5;
         var topMargin:int = 20;
         var verticalPadding:int = 26;
         this._itemVec = new Vector.<ItemBagFilterItem>();
         for(var i:int = 0; i < MAX_NUM; i++)
         {
            item = new ItemBagFilterItem();
            item.x = leftMargin;
            item.y = topMargin + i * verticalPadding;
            addChild(item);
            this._itemVec.push(item);
         }
      }
      
      private function initEventListener() : void
      {
         this.mouseEnabled = false;
         this._upBtn.addEventListener(MouseEvent.CLICK,this.onUpBtnClick);
         this._downBtn.addEventListener(MouseEvent.CLICK,this.onDownBtnClick);
         for(var i:int = 0; i < MAX_NUM; i++)
         {
            this._itemVec[i].addEventListener(MouseEvent.CLICK,this.onItemClick);
         }
      }
      
      private function onUpBtnClick(evt:MouseEvent) : void
      {
         evt.stopPropagation();
         if(this._upBtn.alpha > 0.5)
         {
            --this._offsetIndex;
            this.updateDisplay();
         }
      }
      
      private function onDownBtnClick(evt:MouseEvent) : void
      {
         evt.stopPropagation();
         if(this._downBtn.alpha > 0.5)
         {
            ++this._offsetIndex;
            this.updateDisplay();
         }
      }
      
      private function onItemClick(evt:MouseEvent) : void
      {
         evt.stopPropagation();
         var target:ItemBagFilterItem = evt.currentTarget as ItemBagFilterItem;
         for(var i:int = 0; i < MAX_NUM; i++)
         {
            if(this._itemVec[i] == target)
            {
               this._selectedSuitID = this._suitVec[this._offsetIndex + i].id;
               this._itemVec[i].isSelected = true;
            }
            else
            {
               this._itemVec[i].isSelected = false;
            }
         }
         dispatchEvent(new Event(SELECTED_ITEM_CHANGE));
      }
      
      public function setData(suitVec:Vector.<SuitDefinition>) : void
      {
         this._suitVec = suitVec;
         this._offsetIndex = 0;
         this._selectedSuitID = -1;
         this.updateDisplay();
      }
      
      public function updateDisplay() : void
      {
         this.updateItemVec();
         this.updateBtnStatus();
      }
      
      private function updateItemVec() : void
      {
         var suitIndex:int = 0;
         for(var i:int = 0; i < MAX_NUM; i++)
         {
            suitIndex = this._offsetIndex + i;
            if(suitIndex < this._suitVec.length)
            {
               this._itemVec[i].setData(this._suitVec[suitIndex].name);
               this._itemVec[i].isSelected = this._suitVec[suitIndex].id == this._selectedSuitID;
            }
            else
            {
               this._itemVec[i].reset();
            }
         }
      }
      
      private function updateBtnStatus() : void
      {
         this._upBtn.alpha = 1;
         this._downBtn.alpha = 1;
         if(this._offsetIndex == 0)
         {
            this._upBtn.alpha = 0.4;
         }
         if(this._offsetIndex + MAX_NUM >= this._suitVec.length)
         {
            this._downBtn.alpha = 0.4;
         }
      }
      
      public function show() : void
      {
         this.visible = true;
      }
      
      public function hide() : void
      {
         this.visible = false;
      }
      
      public function get selectedSuitId() : int
      {
         return this._selectedSuitID;
      }
   }
}
