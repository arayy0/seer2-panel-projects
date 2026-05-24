package com.taomee.seer2.module.app.gmail
{
   import com.taomee.seer2.app.mail.GmailDataManager;
   import com.taomee.seer2.app.mail.GmailDataObj;
   import com.taomee.seer2.app.mail.GmailEvent;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class GmailFullItem extends Sprite
   {
      
      private var _mainUI:Sprite;
      
      private var _senderNameTxt:TextField;
      
      private var _sendTimeTxt:TextField;
      
      private var _mailTitleTxt:TextField;
      
      private var _titleBg:Sprite;
      
      private var _mailContentText:TextField;
      
      private var _getAwardBtn:SimpleButton;
      
      private var _deleteBtn:SimpleButton;
      
      private var _prevMailBtn:SimpleButton;
      
      private var _nextMailBtn:SimpleButton;
      
      private var _backToListBtn:SimpleButton;
      
      private var _awardPanel:GmailAwardPanel;
      
      private var _mailBg:MovieClip;
      
      private var $data:GmailDataObj;
      
      public function GmailFullItem()
      {
         super();
         this.initDisplay();
      }
      
      private function initDisplay() : void
      {
         this._mainUI = new GmailFullItemUI();
         addChild(this._mainUI);
         this._titleBg = this._mainUI["titleBg"];
         this._senderNameTxt = this._mainUI["senderNameTxt"];
         this._senderNameTxt.text = "";
         this._senderNameTxt.selectable = false;
         this._sendTimeTxt = this._mainUI["sendTimeTxt"];
         this._sendTimeTxt.text = "";
         this._sendTimeTxt.selectable = false;
         this._mailTitleTxt = this._mainUI["mailTitleTxt"];
         this._mailTitleTxt.text = "";
         this._mailTitleTxt.selectable = false;
         this._mailContentText = this._mainUI["mailContentText"];
         this._mailContentText.text = "";
         this._mailContentText.wordWrap = true;
         this._mailContentText.multiline = true;
         this._getAwardBtn = this._mainUI["getAwardBtn"];
         this._getAwardBtn.visible = false;
         this._deleteBtn = this._mainUI["deleteBtn"];
         this._prevMailBtn = this._mainUI["prevMailBtn"];
         this._nextMailBtn = this._mainUI["nextMailBtn"];
         this._prevMailBtn.addEventListener(MouseEvent.CLICK,this.onPrev);
         this._nextMailBtn.addEventListener(MouseEvent.CLICK,this.onNext);
         this._backToListBtn = this._mainUI["backToListBtn"];
         this._backToListBtn.addEventListener(MouseEvent.CLICK,this.onBackList);
         this._mailBg = this._mainUI["fullItemMailBg"];
         this._mailBg.gotoAndStop(1);
      }
      
      public function setData(mailId:int) : void
      {
         GmailDataManager.getInstance().getFullInfoFromServer(mailId,this.updateDisplay);
      }
      
      private function updateDisplay(data:GmailDataObj) : void
      {
         this.$data = data;
         if(this.$data.senderId == 11)
         {
            this._mailBg.gotoAndStop(2);
         }
         else
         {
            this._mailBg.gotoAndStop(1);
         }
         GmailDataManager.getInstance().getMailDataById(this.$data.mailId).readSymble = true;
         this._senderNameTxt.text = data.senderName;
         this._senderNameTxt.width = this._senderNameTxt.textWidth + 5;
         this._sendTimeTxt.text = data.sendTime;
         this._mailTitleTxt.text = data.mailTitle;
         this._mailTitleTxt.textColor = 16711680;
         this._mailTitleTxt.width = this._mailTitleTxt.textWidth + 5;
         this._mailTitleTxt.x = this._titleBg.x + (this._titleBg.width - this._mailTitleTxt.width) / 2;
         this._mailContentText.text = "    " + data.contentTxt;
         this._mailContentText.height = this._mailContentText.textHeight + 5;
         if(data.attachmentSymble == true)
         {
            this._getAwardBtn.visible = true;
            this._getAwardBtn.mouseEnabled = true;
            this._awardPanel = new GmailAwardPanel();
            this._mainUI.addChild(this._awardPanel);
            this._awardPanel.x = 20;
            this._awardPanel.y = 285 - 5;
            this._awardPanel.setData(data.attachmentArray);
         }
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         if(this._getAwardBtn.visible == true)
         {
            this._getAwardBtn.addEventListener(MouseEvent.CLICK,this.onGetAward);
         }
         this._deleteBtn.addEventListener(MouseEvent.CLICK,this.onDelete);
      }
      
      private function removeEvent() : void
      {
         if(this._getAwardBtn != null)
         {
            this._getAwardBtn.removeEventListener(MouseEvent.CLICK,this.onGetAward);
         }
         this._deleteBtn.removeEventListener(MouseEvent.CLICK,this.onDelete);
      }
      
      private function onGetAward(e:MouseEvent) : void
      {
         DisplayObjectUtil.disableButton(this._getAwardBtn);
         GmailAwardManager.getMailAward(this.$data.mailId,this.successGetAward,this.failGetAward);
      }
      
      private function successGetAward() : void
      {
         this._getAwardBtn.visible = false;
         DisplayObjectUtil.enableButton(this._getAwardBtn);
         this._getAwardBtn.removeEventListener(MouseEvent.CLICK,this.onGetAward);
         trace("[GmailFullItem:邮件附件信息:]",this.$data.attachmentSymble,this.$data.attachmentArray);
         this.$data.attachmentArray = [];
         this.$data.attachmentSymble = false;
         trace("[GmailFullItem:邮件附件信息:]",this.$data.attachmentSymble,this.$data.attachmentArray);
         if(Boolean(this._awardPanel))
         {
            DisplayObjectUtil.removeFromParent(this._awardPanel);
         }
      }
      
      private function failGetAward() : void
      {
         DisplayObjectUtil.enableButton(this._getAwardBtn);
      }
      
      private function onDelete(e:MouseEvent) : void
      {
         if(this.$data.attachmentSymble == true && this.$data.attachmentArray && this.$data.attachmentArray.length > 0)
         {
            AlertManager.showAlert("你当前删除的邮件还有奖品未收取,领取之后再删除吧");
            return;
         }
         var position:int = int(GmailDataManager.getInstance().getMailPosition(this.$data.mailId));
         if(position >= 0)
         {
            GmailDataManager.getInstance().deleteMail([this.$data.mailId]);
            GmailDataManager.getInstance().getAllData().splice(position,1);
            this.onNext();
         }
      }
      
      private function onBackList(e:MouseEvent) : void
      {
         dispatchEvent(new GmailEvent(GmailEvent.RETURN_FROM_READ));
      }
      
      private function onPrev(e:MouseEvent) : void
      {
         var data:GmailDataObj = null;
         if(this.$data == null)
         {
            return;
         }
         var index:int = int(GmailDataManager.getInstance().getMailPosition(this.$data.mailId));
         if(index <= 0)
         {
            AlertManager.showAlert("没有上一封了!!!");
         }
         else
         {
            this.reset();
            data = GmailDataManager.getInstance().getMailByPosition(index - 1);
            this.setData(data.mailId);
         }
      }
      
      private function onNext(e:MouseEvent = null) : void
      {
         var data:GmailDataObj = null;
         if(this.$data == null)
         {
            return;
         }
         var index:int = int(GmailDataManager.getInstance().getMailPosition(this.$data.mailId));
         if(index >= GmailDataManager.getInstance().getAllData().length - 1)
         {
            AlertManager.showAlert("已经是最后一封了!");
            if(e == null)
            {
               this.reset();
            }
         }
         else
         {
            this.reset();
            data = GmailDataManager.getInstance().getMailByPosition(index + 1);
            this.setData(data.mailId);
         }
      }
      
      public function reset() : void
      {
         this.removeEvent();
         if(Boolean(this._awardPanel))
         {
            DisplayObjectUtil.removeFromParent(this._awardPanel);
            this._awardPanel.reset();
            this._awardPanel = null;
         }
         this._mailContentText.text = "";
         this._senderNameTxt.text = "";
         this._sendTimeTxt.text = "";
         this._mailTitleTxt.text = "";
         this._getAwardBtn.visible = false;
         this.$data = null;
      }
   }
}

