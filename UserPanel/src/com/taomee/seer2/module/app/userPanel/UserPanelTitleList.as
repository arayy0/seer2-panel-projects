package com.taomee.seer2.module.app.userPanel
{
   import com.taomee.seer2.app.component.Scroller;
   import com.taomee.seer2.app.inventory.item.MedalItem;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   internal class UserPanelTitleList extends Sprite
   {
      
      public static const USER_TITLE_CHANGE:String = "userTitleChange";
      
      private static const PAGE_SIZE:int = 6;
      
      private var _container:MovieClip;
      
      private var _userTitleScroller:Scroller;
      
      private var _userTitleItemContainer:Sprite;
      
      private var _userTitleItemVec:Vector.<UserPanelTitleItem>;
      
      private var _medalItemVec:Vector.<MedalItem>;
      
      private var _selectedMedalId:int;
      
      private var _isShow:Boolean;
      
      public function UserPanelTitleList()
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
         this._container = new UserPanelTitleListUI();
         this._container.x = 50;
         addChild(this._container);
         this.createScroller();
         this.createItemVec();
      }
      
      private function createScroller() : void
      {
         this._userTitleScroller = new Scroller(this._container["scroller"]);
         this._userTitleScroller.pageSize = PAGE_SIZE;
         this._userTitleScroller.x = 143;
         this._userTitleScroller.y = 9;
         addChild(this._userTitleScroller);
         DisplayObjectUtil.removeFromParent(this._container["scroller"]);
      }
      
      private function createItemVec() : void
      {
         var verticalPadding:int = 0;
         var i:int = 0;
         var item:UserPanelTitleItem = null;
         verticalPadding = 20;
         this._userTitleItemContainer = new Sprite();
         this._userTitleItemContainer.mouseEnabled = false;
         this._userTitleItemContainer.x = 57;
         this._userTitleItemContainer.y = 2;
         addChild(this._userTitleItemContainer);
         this._userTitleItemVec = new Vector.<UserPanelTitleItem>();
         for(i = 0; i < PAGE_SIZE; i++)
         {
            item = new UserPanelTitleItem();
            item.buttonMode = true;
            item.mouseEnabled = true;
            item.y = verticalPadding * i;
            this._userTitleItemContainer.addChild(item);
            this._userTitleItemVec.push(item);
         }
      }
      
      private function initEventListener() : void
      {
         this._userTitleScroller.addEventListener(Scroller.MOVE,this.onScrollerMove);
         this._userTitleItemContainer.addEventListener(MouseEvent.CLICK,this.onTitleItemClick,true);
      }
      
      private function onScrollerMove(evt:Event) : void
      {
         this.updateItemVec();
      }
      
      private function onTitleItemClick(evt:MouseEvent) : void
      {
         var titleItem:UserPanelTitleItem = evt.target as UserPanelTitleItem;
         this._selectedMedalId = titleItem.medalId;
         dispatchEvent(new Event(USER_TITLE_CHANGE));
      }
      
      public function show() : void
      {
         this._isShow = true;
         this.toggle();
      }
      
      public function hide() : void
      {
         this._isShow = false;
         this.toggle();
      }
      
      public function toggle() : void
      {
         this.visible = this._isShow;
         this._isShow = !this._isShow;
      }
      
      public function reset() : void
      {
         for(var i:int = 0; i < PAGE_SIZE; i++)
         {
            this._userTitleItemVec[i].reset();
         }
      }
      
      public function setData(medalItemVec:Vector.<MedalItem>, selectedMedalId:int) : void
      {
         this._selectedMedalId = selectedMedalId;
         this.updateData(medalItemVec);
         this.updateTitleScroller();
         this.updateDisplay();
      }
      
      private function updateData(medalVec:Vector.<MedalItem>) : void
      {
         var item:MedalItem = null;
         this._medalItemVec = new Vector.<MedalItem>();
         for each(item in medalVec)
         {
            if(item.hasTitle())
            {
               this._medalItemVec.push(item);
            }
         }
      }
      
      private function updateDisplay() : void
      {
         this.updateTitleScroller();
         this.updateItemVec();
      }
      
      private function updateTitleScroller() : void
      {
         this._userTitleScroller.scrollPosition = 0;
         this._userTitleScroller.maxScrollPosition = this._medalItemVec.length + 1;
      }
      
      private function updateItemVec() : void
      {
         var medalIndex:int = 0;
         var medalItem:MedalItem = null;
         var titleItem:UserPanelTitleItem = null;
         var titleItemIndex:int = 0;
         if(this._selectedMedalId != 0)
         {
            this._userTitleItemVec[0].setData("无");
            this._userTitleItemVec[0].isSelected = false;
            titleItemIndex = 1;
         }
         var index:int = int(this._userTitleScroller.scrollPosition);
         var len:int = int(this._medalItemVec.length);
         while(titleItemIndex < PAGE_SIZE)
         {
            medalIndex = index;
            if(medalIndex < len)
            {
               medalItem = this._medalItemVec[medalIndex];
               titleItem = this._userTitleItemVec[titleItemIndex];
               titleItem.setData(medalItem);
               titleItem.isSelected = medalItem.referenceId == this._selectedMedalId;
            }
            else
            {
               this._userTitleItemVec[titleItemIndex].reset();
            }
            titleItemIndex++;
            index++;
         }
      }
      
      public function get selectedMedalId() : int
      {
         return this._selectedMedalId;
      }
   }
}

