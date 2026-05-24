package com.taomee.seer2.module.app.gmail
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.component.ItemToolTip;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.mail.GmailAttachInfo;
   import com.taomee.seer2.core.inventory.Item;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class GmailAwardPanelItem extends Sprite
   {
      
      private var bg:Sprite;
      
      private var data:GmailAttachInfo;
      
      private var item:Item;
      
      private var resourceId:int;
      
      private var numTxt:TextField;
      
      private var iconDisplay:IconDisplayer;
      
      public function GmailAwardPanelItem()
      {
         super();
         this.bg = new GmailAwardPanelItemBgUI();
         addChild(this.bg);
         this.bg.mouseChildren = this.bg.mouseEnabled = false;
         this.iconDisplay = new IconDisplayer();
         this.bg.addChildAt(this.iconDisplay,this.bg.getChildIndex(this.bg["rect"]));
         this.mouseChildren = false;
      }
      
      public function setData(data:GmailAttachInfo) : void
      {
         this.data = data;
         if(data.flag == 0)
         {
            this.showWuPin();
         }
         else
         {
            this.showJingLing();
         }
         this.numTxt = new TextField();
         if(this.data.flag == 0)
         {
            if(data.itemId >= 604140 && data.itemId <= 604152 || data.itemId >= 605004 && data.itemId <= 605005)
            {
               this.numTxt.text = "";
            }
            else
            {
               this.numTxt.text = "X" + this.data.count.toString();
            }
         }
         var format:TextFormat = new TextFormat();
         format.color = 6750207;
         format.size = 14;
         this.numTxt.setTextFormat(format);
         addChild(this.numTxt);
         this.numTxt.width = this.numTxt.textWidth + 5;
         this.numTxt.height = this.numTxt.textHeight + 5;
         this.numTxt.selectable = false;
         this.numTxt.x = this.bg.x + this.bg.width - this.numTxt.width - 5;
         this.numTxt.y = this.bg.y + this.bg.height - this.numTxt.height;
         this.addTips();
      }
      
      private function addTips() : void
      {
         if(this.data.flag == 0)
         {
            TooltipManager.addCommonTip(this,ItemConfig.getItemName(this.data.itemId));
         }
         else
         {
            TooltipManager.addCommonTip(this,PetConfig.getPetDefinition(this.data.itemId).name);
         }
      }
      
      private function showWuPin() : void
      {
         var url:String = null;
         this.resourceId = this.data.itemId;
         if(this.resourceId == 1)
         {
            this.iconDisplay.setIconUrl(URLUtil.getCoinsIcon(),this.onComplete);
         }
         else
         {
            url = ItemConfig.getItemIconUrl(this.resourceId);
            if(Boolean(url))
            {
               this.iconDisplay.setIconUrl(url,this.onComplete);
            }
         }
      }
      
      private function showJingLing() : void
      {
         var url:String = URLUtil.getPetIcon(this.data.itemId);
         this.iconDisplay.setIconUrl(url,this.onComplete);
         this.bg["rect"].visible = false;
      }
      
      private function onComplete() : void
      {
         if(Boolean(this.iconDisplay))
         {
            if(this.iconDisplay.width > 67.8)
            {
               this.iconDisplay.scaleX = 67.8 / this.iconDisplay.width;
               this.iconDisplay.scaleY = 67.8 / this.iconDisplay.height;
            }
            else
            {
               this.iconDisplay.scaleX = 1;
               this.iconDisplay.scaleY = 1;
            }
            this.iconDisplay.x = (this.bg.width - this.iconDisplay.width) / 2;
            this.iconDisplay.y = (this.bg.height - this.iconDisplay.height) / 2;
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this.iconDisplay))
         {
            this.iconDisplay.removeIcon();
            this.iconDisplay.scaleX = 1;
            this.iconDisplay.scaleY = 1;
            this.iconDisplay = null;
         }
         ItemToolTip.hide();
         this.resourceId = 0;
         DisplayObjectUtil.removeFromParent(this.numTxt);
         this.numTxt = null;
         this.data = null;
      }
   }
}

