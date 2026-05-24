package com.taomee.seer2.module.app.userPanel
{
   import com.taomee.seer2.app.inventory.item.MedalItem;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   internal class UserPanelTitleItem extends Sprite
   {
       
      
      private var _container:MovieClip;
      
      private var _selectedMc:MovieClip;
      
      private var _titleTxt:TextField;
      
      private var _info:*;
      
      private var _isMedalItem:Boolean;
      
      private var _isSelected:Boolean;
      
      public function UserPanelTitleItem()
      {
         super();
         this.createChildren();
         this.initEventListener();
      }
      
      private function createChildren() : void
      {
         this.mouseChildren = false;
         this._container = new UserPanelTitleItemUI();
         addChild(this._container);
         this._selectedMc = this._container["selected"];
         this._titleTxt = this._container["title"];
      }
      
      private function initEventListener() : void
      {
         this.mouseChildren = false;
      }
      
      public function reset() : void
      {
         this.hide();
      }
      
      public function setData(info:*) : void
      {
         this._info = info;
         this.updateData(info);
         this.updateDisplay();
      }
      
      private function updateData(info:*) : void
      {
         var item:MedalItem = this._info as MedalItem;
         if(item != null)
         {
            this._isMedalItem = true;
         }
         else
         {
            this._isMedalItem = false;
         }
      }
      
      private function updateDisplay() : void
      {
         this.show();
         if(this._isMedalItem)
         {
            this._titleTxt.text = this._info.title;
         }
         else
         {
            this._titleTxt.text = String(this._info);
         }
      }
      
      private function show() : void
      {
         this.visible = true;
      }
      
      private function hide() : void
      {
         this.visible = false;
      }
      
      public function set isSelected(value:Boolean) : void
      {
         this._isSelected = value;
         if(this._isSelected)
         {
            this._selectedMc.visible = true;
            this.buttonMode = false;
            this.mouseEnabled = false;
         }
         else
         {
            this._selectedMc.visible = false;
            this.buttonMode = true;
            this.mouseEnabled = true;
         }
      }
      
      public function get medalId() : int
      {
         if(this._isMedalItem)
         {
            return this._info.referenceId;
         }
         return 0;
      }
   }
}
