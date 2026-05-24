package com.taomee.seer2.module.app.gmail
{
   import com.taomee.seer2.app.mail.GmailDataObj;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class GmailItem extends Sprite
   {
      
      private var mainUI:Sprite;
      
      private var selectBtn:SimpleButton;
      
      private var crossSymble:Sprite;
      
      private var readSymble:MovieClip;
      
      private var senderNameTxt:TextField;
      
      private var simpleInfoTxt:TextField;
      
      private var sendTimeTxt:TextField;
      
      private var attachmentSymble:Sprite;
      
      private var $data:GmailDataObj;
      
      private var isSelected:Boolean;
      
      private var isShow:Boolean;
      
      public function GmailItem()
      {
         super();
         this.mainUI = new GmailItemUI();
         addChild(this.mainUI);
         this.initItem();
      }
      
      private function initItem() : void
      {
         this.selectBtn = this.mainUI["selectBtn"];
         this.crossSymble = this.mainUI["crossSymble"];
         this.crossSymble.visible = false;
         this.crossSymble.mouseChildren = this.crossSymble.mouseEnabled = false;
         this.readSymble = this.mainUI["readSymble"];
         this.readSymble.gotoAndStop(1);
         this.senderNameTxt = this.mainUI["senderNameTxt"];
         this.senderNameTxt.text = "";
         this.senderNameTxt.selectable = false;
         this.senderNameTxt.mouseEnabled = false;
         this.simpleInfoTxt = this.mainUI["simpleInfoTxt"];
         this.simpleInfoTxt.text = "";
         this.simpleInfoTxt.selectable = false;
         this.simpleInfoTxt.mouseEnabled = false;
         this.sendTimeTxt = this.mainUI["sendTimeTxt"];
         this.sendTimeTxt.text = "";
         this.sendTimeTxt.selectable = false;
         this.sendTimeTxt.mouseEnabled = false;
         this.attachmentSymble = this.mainUI["attachmentSymble"];
         this.attachmentSymble.visible = false;
         this.attachmentSymble.mouseChildren = this.attachmentSymble.mouseEnabled = false;
      }
      
      public function setData(data:GmailDataObj) : void
      {
         this.reset();
         this.$data = data;
         this.isShow = true;
         this.updateDisplay();
      }
      
      public function get mailData() : GmailDataObj
      {
         return this.$data;
      }
      
      private function updateDisplay() : void
      {
         this.readSymble.visible = true;
         this.readSymble.gotoAndStop(this.$data.readSymble == true ? 2 : 1);
         this.senderNameTxt.text = this.$data.senderName;
         this.simpleInfoTxt.text = this.$data.mailTitle;
         this.sendTimeTxt.text = this.$data.sendTime;
         this.attachmentSymble.visible = this.$data.attachmentSymble;
         this.selectBtn.visible = true;
         this.selectBtn.addEventListener(MouseEvent.CLICK,this.onSelect);
      }
      
      private function onSelect(e:MouseEvent) : void
      {
         if(this.$data == null)
         {
            return;
         }
         e.stopPropagation();
         this.isSelected = !this.isSelected;
         this.crossSymble.visible = this.isSelected;
      }
      
      public function get selected() : Boolean
      {
         return this.isSelected;
      }
      
      public function set selected(value:Boolean) : void
      {
         this.isSelected = value;
         this.crossSymble.visible = this.isSelected;
      }
      
      public function reset() : void
      {
         this.$data = null;
         this.selectBtn.removeEventListener(MouseEvent.CLICK,this.onSelect);
         this.selectBtn.visible = false;
         this.readSymble.visible = false;
         this.senderNameTxt.text = "";
         this.simpleInfoTxt.text = "";
         this.sendTimeTxt.text = "";
         this.attachmentSymble.visible = false;
         this.isSelected = false;
         this.crossSymble.visible = false;
         this.isShow = false;
      }
   }
}

