package com.taomee.seer2.module.app.gmail
{
   import com.taomee.seer2.app.mail.GmailDataManager;
   import com.taomee.seer2.app.mail.GmailDataObj;
   import com.taomee.seer2.app.mail.GmailEvent;
   import com.taomee.seer2.app.popup.AlertManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class GmailItemListPanel extends Sprite
   {
      
      private static const MailListCount:int = 6;
      
      private static const start_y_pos:Number = 5;
      
      private static const distance_y:Number = 55;
      
      private var mailList:Array;
      
      private var dataAry:Vector.<GmailDataObj>;
      
      private var upBtnCon:GmailListPanelUpBtn;
      
      private var downBtnCon:GmailListPanelDownBtn;
      
      private var _currentPageIndex:int = 0;
      
      public function GmailItemListPanel()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.upBtnCon = new GmailListPanelUpBtn();
         addChild(this.upBtnCon);
         this.upBtnCon.x = 48 - 14;
         this.upBtnCon.y = 3 - 28 + 5;
         this.mailList = [];
         for(var i:int = 0; i < MailListCount; i++)
         {
            this.mailList.push(new GmailItem());
            addChild(this.mailList[i]);
            this.mailList[i].x = 10;
            this.mailList[i].y = start_y_pos + i * distance_y;
         }
         this.downBtnCon = new GmailListPanelDownBtn();
         addChild(this.downBtnCon);
         this.downBtnCon.x = 52;
         this.downBtnCon.y = 355 - 28;
      }
      
      public function setData(value:Vector.<GmailDataObj>) : void
      {
         this.dataAry = value;
         this.addEvent();
         this.setPageCount();
         this._currentPageIndex = this.downBtnCon.currentPage;
         this.updateCurrentPage();
      }
      
      private function addEvent() : void
      {
         for(var i:int = 0; i < MailListCount; i++)
         {
            this.mailList[i].buttonMode = true;
            this.mailList[i].addEventListener(MouseEvent.CLICK,this.onMailItemClick);
         }
         this.downBtnCon.addEventListener(GmailListPanelDownBtn.DELETE_ALL_ITEM,this.onDeleteAll);
         this.downBtnCon.addEventListener(GmailListPanelDownBtn.DELETE_ITEM,this.onDelete);
         this.downBtnCon.addEventListener(GmailEvent.LIST_PANEL_PAGE_CHANGED,this.onPageChanged);
         this.upBtnCon.addEventListener(GmailEvent.CLICK_SELECT_ALL_BTN,this.onSelectAll);
      }
      
      private function removeEvent() : void
      {
         for(var i:int = 0; i < MailListCount; i++)
         {
            this.mailList[i].removeEventListener(MouseEvent.CLICK,this.onMailItemClick);
         }
         this.downBtnCon.removeEventListener(GmailListPanelDownBtn.DELETE_ALL_ITEM,this.onDeleteAll);
         this.downBtnCon.removeEventListener(GmailListPanelDownBtn.DELETE_ITEM,this.onDelete);
         this.downBtnCon.removeEventListener(GmailEvent.LIST_PANEL_PAGE_CHANGED,this.onPageChanged);
         this.upBtnCon.removeEventListener(GmailEvent.CLICK_SELECT_ALL_BTN,this.onSelectAll);
      }
      
      private function setPageCount() : void
      {
         this.downBtnCon.totalPage = Math.ceil(this.dataAry.length / MailListCount);
         if(this.downBtnCon.currentPage >= this.downBtnCon.totalPage)
         {
            this.downBtnCon.currentPage = this.downBtnCon.totalPage - 1;
         }
      }
      
      private function updateCurrentPage() : void
      {
         var start:int = this._currentPageIndex * MailListCount;
         for(var i:int = 0; i < MailListCount; i++)
         {
            if(Boolean(this.mailList[i]))
            {
               this.mailList[i].reset();
            }
            if(this._currentPageIndex >= 0 && this.dataAry && this.dataAry.length > start + i && this.dataAry[start + i] != null)
            {
               this.mailList[i].setData(this.dataAry[start + i]);
            }
         }
      }
      
      private function onPageChanged(e:GmailEvent) : void
      {
         this.upBtnCon.reset();
         if(this._currentPageIndex != this.downBtnCon.currentPage)
         {
            this._currentPageIndex = this.downBtnCon.currentPage;
            this.updateCurrentPage();
         }
      }
      
      private function onDelete(e:Event) : void
      {
         this.checkAndDelete();
      }
      
      private function onDeleteAll(e:Event) : void
      {
         this.checkAndDelete();
      }
      
      private function checkAndDelete() : void
      {
         var tempAry:Array = [];
         var checkStart:int = this._currentPageIndex * MailListCount;
         var canDelete:Boolean = true;
         for(var i:int = 0; i < MailListCount; i++)
         {
            if(this.mailList && this.mailList[i] != null && Boolean(this.mailList[i].mailData) && this.mailList[i].selected == true)
            {
               if(this.mailList[i].mailData.attachmentSymble == true)
               {
                  canDelete = false;
                  break;
               }
               tempAry.push(this.mailList[i].mailData.mailId);
            }
         }
         if(canDelete == false)
         {
            AlertManager.showAlert("当前要删除的邮件有附件未领取，请领取之后再删除吧");
            return;
         }
         var index:int = -1;
         for(var j:int = 0; j < tempAry.length; j++)
         {
            index = int(GmailDataManager.getInstance().getMailPosition(tempAry[j]));
            if(index != -1)
            {
               this.dataAry.splice(index,1);
            }
         }
         for(var m:int = 0; m < GmailDataManager.getInstance().getAllData().length; m++)
         {
            trace("[剩余邮件id:]",GmailDataManager.getInstance().getAllData()[m].mailId);
         }
         if(tempAry.length > 0)
         {
            this.deleteMailonServer(tempAry);
            this.setPageCount();
            this._currentPageIndex = this.downBtnCon.currentPage;
            this.updateCurrentPage();
         }
      }
      
      private function onMailItemClick(e:MouseEvent) : void
      {
         var evt:GmailEvent = null;
         var index:int = int(this.mailList.indexOf(e.currentTarget as GmailItem));
         if(index != -1 && (e.currentTarget as GmailItem).mailData != null)
         {
            evt = new GmailEvent(GmailEvent.CLICK_TO_READ_MAIL);
            evt.data = (e.currentTarget as GmailItem).mailData.mailId;
            dispatchEvent(evt);
         }
      }
      
      private function onSelectAll(e:GmailEvent) : void
      {
         var select:Boolean = Boolean(e.data);
         var checkStart:int = this._currentPageIndex * MailListCount;
         for(var i:int = 0; i < MailListCount; i++)
         {
            if(this.mailList && this.mailList[i] && this.mailList[i].mailData != null)
            {
               this.mailList[i].selected = select;
            }
         }
      }
      
      private function deleteMailonServer(ary:Array) : void
      {
         GmailDataManager.getInstance().deleteMail(ary);
      }
      
      public function reset() : void
      {
         for(var i:int = 0; i < MailListCount; i++)
         {
            this.mailList[i].reset();
         }
         this.removeEvent();
      }
   }
}

