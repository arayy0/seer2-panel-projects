package com.taomee.seer2.module.app.gmail
{
   import com.taomee.seer2.app.mail.GmailDataManager;
   import com.taomee.seer2.app.mail.GmailEvent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class GmailListPanelUpBtn extends Sprite
   {
      
      private var _mainUI:Sprite;
      
      private var crossSp:Sprite;
      
      private var selectRectBtn:Sprite;
      
      private var bSelectAll:Boolean;
      
      private var timeSortBtn:MovieClip;
      
      public function GmailListPanelUpBtn()
      {
         super();
         this._mainUI = new GmailListPanelUpBtnUI();
         addChild(this._mainUI);
         this.initPanel();
      }
      
      private function initPanel() : void
      {
         this.crossSp = this._mainUI["crossSp"];
         this.crossSp.visible = false;
         this.crossSp.mouseChildren = this.crossSp.mouseEnabled = false;
         this.selectRectBtn = this._mainUI["selectRectBtn"];
         this.selectRectBtn.buttonMode = true;
         this.selectRectBtn.addEventListener(MouseEvent.CLICK,this.onSelectAll);
      }
      
      private function onSelectAll(e:MouseEvent) : void
      {
         this.bSelectAll = !this.bSelectAll;
         this.crossSp.visible = this.bSelectAll;
         var evt:GmailEvent = new GmailEvent(GmailEvent.CLICK_SELECT_ALL_BTN);
         evt.data = this.bSelectAll;
         dispatchEvent(evt);
      }
      
      public function get isSelectAll() : Boolean
      {
         return this.bSelectAll;
      }
      
      private function onTimeSort(e:MouseEvent) : void
      {
         var frame:int = 0;
         GmailDataManager.getInstance().addEventListener(GmailEvent.MAIL_SORT_COMPLETED,this.onSortOver);
         this.timeSortBtn.mouseEnabled = false;
         GmailDataManager.getInstance().sortByType(frame);
         frame = this.timeSortBtn.currentFrame == 1 ? 2 : 1;
         this.timeSortBtn.gotoAndStop(frame);
      }
      
      private function onSortOver(e:GmailEvent = null) : void
      {
         GmailDataManager.getInstance().removeEventListener(GmailEvent.MAIL_SORT_COMPLETED,this.onSortOver);
         this.timeSortBtn.mouseEnabled = true;
      }
      
      public function reset() : void
      {
         this.bSelectAll = false;
         this.crossSp.visible = false;
      }
   }
}

