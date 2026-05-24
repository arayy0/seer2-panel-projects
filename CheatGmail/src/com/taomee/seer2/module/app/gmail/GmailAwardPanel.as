package com.taomee.seer2.module.app.gmail
{
   import com.taomee.seer2.app.mail.GmailAttachInfo;
   import flash.display.Sprite;
   
   public class GmailAwardPanel extends Sprite
   {
      
      private static const distance:Number = 80;
      
      private var itemList:Vector.<GmailAwardPanelItem>;
      
      private var $dataAry:Array;
      
      public function GmailAwardPanel()
      {
         super();
         this.itemList = new Vector.<GmailAwardPanelItem>();
      }
      
      public function setData(dataAry:Array) : void
      {
         this.$dataAry = dataAry;
         for(var i:int = 0; i < this.$dataAry.length; i++)
         {
            this.itemList.push(new GmailAwardPanelItem());
            this.itemList[i].setData(GmailAttachInfo(dataAry[i]));
            addChild(this.itemList[i]);
            this.itemList[i].x = distance * i;
            if(i >= 6)
            {
               this.itemList[i].x = distance * (i - 6);
               this.itemList[i].y = -distance;
            }
         }
      }
      
      public function reset() : void
      {
         for(var i:int = 0; i < this.$dataAry.length; i++)
         {
            this.itemList[i].dispose();
         }
         this.$dataAry = null;
      }
   }
}

