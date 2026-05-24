package com.taomee.seer2.module.app
{
   import com.taomee.seer2.app.mail.GmailDataManager;
   import com.taomee.seer2.app.mail.GmailEvent;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.LifecycleType;
   import com.taomee.seer2.module.app.gmail.GmailFullItem;
   import com.taomee.seer2.module.app.gmail.GmailItemListPanel;
   import com.taomee.seer2.module.core.TopModule;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
import flash.text.TextField;

public class CheatGmail extends TopModule
   {
      
      private var mailDataAry:Array;
      
      private var listPanel:GmailItemListPanel;
      
      private var readPanel:GmailFullItem;
      
      private var writeMailBtn:SimpleButton;
      
      private var mailBg:Sprite;

      private var target:TextField;

      private var confirmBtn:SimpleButton;
      
      public function CheatGmail()
      {
         super();
         _lifecycleType = LifecycleType.GLOBAL;
      }
      
      override public function setup() : void
      {
         setMainUI(new GmailPanelUI());
         this.writeMailBtn = _mainUI["writeMailBtn"];
         this.target = _mainUI["targetIdTxt"];
         this.confirmBtn = _mainUI["confirmBtn"];
         DisplayObjectUtil.disableButton(this.writeMailBtn);
         this.listPanel = new GmailItemListPanel();
         this.addListPanel();
         this.readPanel = new GmailFullItem();
         this.mailBg = _mainUI["mailBg"];
      }
      
      private function addListPanel() : void
      {
         _mainUI.addChild(this.listPanel);
         this.listPanel.x = 107 - 57;
         this.listPanel.y = 50 + 20;
      }
      
      private function addReadPanel() : void
      {
         _mainUI.addChild(this.readPanel);
         this.readPanel.x = 55;
         this.readPanel.y = 43;
      }
      
      override public function show() : void
      {
         StatisticsManager.sendNovice("0x10034500");
         GmailDataManager.getInstance().initMailData(this.showPanel);
      }
      
      private function showPanel() : void
      {
         this.addEvent();
         this.updateDisplay();
         super.show();
      }
      
      private function addEvent() : void
      {
         GmailDataManager.getInstance().addEventListener(GmailEvent.MAIL_SORT_COMPLETED,this.onSortChanged);
         this.listPanel.addEventListener(GmailEvent.CLICK_TO_READ_MAIL,this.onReadMail);
         this.readPanel.addEventListener(GmailEvent.RETURN_FROM_READ,this.onReturnFromRead);
      }
      
      private function onSortChanged(e:GmailEvent) : void
      {
         this.updateDisplay();
      }
      
      private function onReadMail(e:GmailEvent) : void
      {
         var readMailId:int = int(e.data);
         DisplayObjectUtil.removeFromParent(this.listPanel);
         this.addReadPanel();
         this.readPanel.setData(readMailId);
         if(Boolean(this.mailBg))
         {
            this.mailBg.visible = false;
         }
      }
      
      private function onReturnFromRead(e:GmailEvent) : void
      {
         DisplayObjectUtil.removeFromParent(this.readPanel);
         this.readPanel.reset();
         this.addListPanel();
         this.updateDisplay();
      }
      
      private function updateDisplay() : void
      {
         if(Boolean(this.readPanel))
         {
            DisplayObjectUtil.removeFromParent(this.readPanel);
            this.readPanel.reset();
         }
         if(Boolean(this.listPanel))
         {
            if(this.listPanel.parent == null)
            {
               this.addListPanel();
            }
            if(Boolean(this.mailBg))
            {
               this.mailBg.visible = true;
            }
            this.listPanel.setData(GmailDataManager.getInstance().getAllData());
         }
      }
      
      override public function hide() : void
      {
         this.removeEvent();
         super.hide();
      }
      
      private function removeEvent() : void
      {
         GmailDataManager.getInstance().removeEventListener(GmailEvent.MAIL_SORT_COMPLETED,this.onSortChanged);
         this.listPanel.removeEventListener(GmailEvent.CLICK_TO_READ_MAIL,this.onReadMail);
         this.readPanel.removeEventListener(GmailEvent.RETURN_FROM_READ,this.onReturnFromRead);
      }
   }
}

