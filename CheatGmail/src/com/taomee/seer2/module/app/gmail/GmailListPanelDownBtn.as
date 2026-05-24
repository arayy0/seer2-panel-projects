package com.taomee.seer2.module.app.gmail
{
   import com.taomee.seer2.app.mail.GmailEvent;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class GmailListPanelDownBtn extends Sprite
   {
      
      public static const DELETE_ITEM:String = "DELETE_ITEM";
      
      public static const DELETE_ALL_ITEM:String = "DELETE_ALL_ITEM";
      
      private var _mainUI:Sprite;
      
      private var deleteAllBtn:SimpleButton;
      
      private var leftBtn:SimpleButton;
      
      private var rightBtn:SimpleButton;
      
      private var _currentPage:int;
      
      private var currentPageTxt:TextField;
      
      private var _totalPage:int;
      
      private var totalPageTxt:TextField;
      
      public function GmailListPanelDownBtn()
      {
         super();
         this._mainUI = new GmailListPanelDownBtnUI();
         addChild(this._mainUI);
         this.initPanel();
      }
      
      private function initPanel() : void
      {
         this.deleteAllBtn = this._mainUI["deleteAllBtn"];
         this.leftBtn = this._mainUI["leftBtn"];
         this.rightBtn = this._mainUI["rightBtn"];
         this.currentPageTxt = this._mainUI["currentPageTxt"];
         this.totalPageTxt = this._mainUI["totalPageTxt"];
         this.currentPageTxt.selectable = this.totalPageTxt.selectable = false;
         this.currentPageTxt.text = "0";
         this.totalPageTxt.text = "0";
         this.deleteAllBtn.addEventListener(MouseEvent.CLICK,this.onClick);
         this.leftBtn.addEventListener(MouseEvent.CLICK,this.onClick);
         this.rightBtn.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(e:MouseEvent) : void
      {
         switch(e.currentTarget as SimpleButton)
         {
            case this.deleteAllBtn:
               dispatchEvent(new Event(DELETE_ALL_ITEM));
               break;
            case this.leftBtn:
               if(this.currentPage > 0)
               {
                  --this._currentPage;
                  this.updateTxt();
                  dispatchEvent(new GmailEvent(GmailEvent.LIST_PANEL_PAGE_CHANGED));
               }
               break;
            case this.rightBtn:
               if(this.currentPage < this.totalPage - 1)
               {
                  ++this._currentPage;
                  this.updateTxt();
                  dispatchEvent(new GmailEvent(GmailEvent.LIST_PANEL_PAGE_CHANGED));
               }
         }
      }
      
      public function set totalPage(count:int) : void
      {
         this._totalPage = count;
         this.updateTxt();
      }
      
      public function get totalPage() : int
      {
         return this._totalPage;
      }
      
      public function set currentPage(count:int) : void
      {
         this._currentPage = count;
         this.updateTxt();
      }
      
      public function get currentPage() : int
      {
         return this._currentPage;
      }
      
      private function updateTxt() : void
      {
         if(Boolean(this.totalPageTxt))
         {
            this.totalPageTxt.text = String(this._totalPage);
         }
         if(Boolean(this.currentPageTxt))
         {
            this.currentPageTxt.text = String(this._currentPage + 1);
         }
      }
   }
}

