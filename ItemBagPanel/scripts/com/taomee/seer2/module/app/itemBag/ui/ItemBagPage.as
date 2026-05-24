package com.taomee.seer2.module.app.itemBag.ui
{
   import com.taomee.seer2.core.inventory.Item;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.module.app.itemBag.ItemBagPageUI;
   import com.taomee.seer2.module.app.itemBag.cell.ItemBagCell;
   import com.taomee.seer2.module.app.itemBag.cell.ItemBagPageCell;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class ItemBagPage extends Sprite
   {
      
      public static const PAGE_INDEX_CHANGE:String = "pageIndexChange";
      
      private static const PAGE_SIZE:int = 25;
       
      
      private var _container:Sprite;
      
      private var _previousBtn:SimpleButton;
      
      private var _nextBtn:SimpleButton;
      
      private var _pageTxt:TextField;
      
      private var _itemCellVec:Vector.<ItemBagCell>;
      
      private var _itemDataVec:Vector.<Item>;
      
      private var _pageIndex:int;
      
      private var _pageTotal:int;
      
      public function ItemBagPage()
      {
         super();
         this.createChildren();
         this.initEventListener();
      }
      
      private function createChildren() : void
      {
         this._container = new ItemBagPageUI();
         this._container.x = 527;
         this._container.y = 448;
         addChild(this._container);
         this._previousBtn = this._container["previous"];
         this._nextBtn = this._container["next"];
         this._pageTxt = this._container["page"];
         this.createItemVec();
      }
      
      private function createItemVec() : void
      {
         var itemCell:ItemBagCell = null;
         var rowCount:int = 3;
         var leftMargin:int = 401;
         var horizontalPadding:int = 70;
         var topMargin:int = 90;
         var verticalPadding:int = 70;
         this._itemCellVec = new Vector.<ItemBagCell>();
         var i:int = 0;
         while(i < PAGE_SIZE)
         {
            itemCell = new ItemBagPageCell();
            itemCell.x = leftMargin + i % 5 * horizontalPadding;
            itemCell.y = topMargin + int(i / 5) * verticalPadding;
            addChild(itemCell);
            this._itemCellVec.push(itemCell);
            i++;
         }
      }
      
      private function initEventListener() : void
      {
         this._previousBtn.addEventListener(MouseEvent.CLICK,this.onPreviousClick);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.onNextClick);
      }
      
      private function onPreviousClick(e:MouseEvent) : void
      {
         --this._pageIndex;
         this.updateDisplay();
         dispatchEvent(new Event(PAGE_INDEX_CHANGE));
      }
      
      private function onNextClick(e:MouseEvent) : void
      {
         ++this._pageIndex;
         this.updateDisplay();
         dispatchEvent(new Event(PAGE_INDEX_CHANGE));
      }
      
      private function updateDisplay() : void
      {
         this.updateItemGrid();
         this.updatePageTxt();
         this.updateBtnStatus();
      }
      
      private function updateItemGrid() : void
      {
         var dataIndex:int = 0;
         var gridData:Vector.<Item> = new Vector.<Item>();
         var startIndex:int = this._pageIndex * PAGE_SIZE;
         var len:int = int(this._itemDataVec.length);
         var i:int = 0;
         while(i < PAGE_SIZE)
         {
            dataIndex = startIndex + i;
            if(dataIndex < len)
            {
               this._itemCellVec[i].setData(this._itemDataVec[dataIndex]);
            }
            else
            {
               this._itemCellVec[i].setData(null);
            }
            i++;
         }
      }
      
      private function updatePageTxt() : void
      {
         this._pageTxt.text = this._pageIndex + 1 + "/" + this._pageTotal;
      }
      
      private function updateBtnStatus() : void
      {
         DisplayObjectUtil.enableButton(this._previousBtn);
         DisplayObjectUtil.enableButton(this._nextBtn);
         if(this._pageIndex == 0)
         {
            DisplayObjectUtil.disableButton(this._previousBtn);
         }
         if(this._pageIndex == this._pageTotal - 1)
         {
            DisplayObjectUtil.disableButton(this._nextBtn);
         }
      }
      
      public function setData(value:Vector.<Item>, isKeepPageIndex:Boolean) : void
      {
         this._itemDataVec = value;
         this.updateNonoEquip();
         this.updatePageData(isKeepPageIndex);
         this.updateDisplay();
      }
      
      private function updateNonoEquip() : void
      {
         var count:int = int(this._itemDataVec.length);
         var list:Vector.<Item> = Vector.<Item>([]);
         var i:int = 0;
         while(i < count)
         {
            if(this._itemDataVec[i].referenceId < 102000 || this._itemDataVec[i].referenceId > 102999)
            {
               if(this._itemDataVec[i].quantity > 0)
               {
                  list.push(this._itemDataVec[i]);
               }
            }
            i++;
         }
         this._itemDataVec = list;
      }
      
      private function updatePageData(isKeepPageIndex:Boolean) : void
      {
         this._pageTotal = Math.ceil(this._itemDataVec.length / PAGE_SIZE);
         if(this._pageTotal == 0)
         {
            this._pageTotal = 1;
         }
         if(isKeepPageIndex == false)
         {
            this._pageIndex = 0;
         }
         if(this._pageIndex >= this._pageTotal - 1)
         {
            this._pageIndex = this._pageTotal - 1;
         }
      }
   }
}
