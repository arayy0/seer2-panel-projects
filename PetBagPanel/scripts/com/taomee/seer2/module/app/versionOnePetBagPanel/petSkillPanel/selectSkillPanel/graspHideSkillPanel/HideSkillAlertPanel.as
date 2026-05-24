package com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel.selectSkillPanel.graspHideSkillPanel
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class HideSkillAlertPanel extends Sprite
   {
       
      
      private var ui:Sprite;
      
      private var closeBtn:Sprite;
      
      private var buyOneBtn:Sprite;
      
      private var buyAllBtn:Sprite;
      
      private var buyOneFunc:Function;
      
      private var buyAllFunc:Function;
      
      private var closeFunc:Function;
      
      public function HideSkillAlertPanel(buyOneFunc:Function, buyAllFunc:Function, close:Function)
      {
         super();
         this.ui = new HideSkillAlertUI();
         addChild(this.ui);
         this.buyOneBtn = this.ui["buyOneBtn"];
         this.buyAllBtn = this.ui["buyAllBtn"];
         this.closeBtn = this.ui["closeBtn"];
         this.buyOneBtn.buttonMode = this.buyAllBtn.buttonMode = this.closeBtn.buttonMode = true;
         this.buyOneFunc = buyOneFunc;
         this.buyAllFunc = buyAllFunc;
         this.closeFunc = close;
         this.buyOneBtn.addEventListener("click",this.onClick);
         this.buyAllBtn.addEventListener("click",this.onClick);
         this.closeBtn.addEventListener("click",this.onClick);
      }
      
      private function onClick(e:MouseEvent) : void
      {
         switch(e.currentTarget)
         {
            case this.buyOneBtn:
               this.buyOneFunc();
               this.close();
               break;
            case this.buyAllBtn:
               this.buyAllFunc();
               this.close();
               break;
            case this.closeBtn:
               this.close();
         }
      }
      
      private function close() : void
      {
         this.buyOneBtn.removeEventListener("click",this.onClick);
         this.buyAllBtn.removeEventListener("click",this.onClick);
         this.closeBtn.removeEventListener("click",this.onClick);
         this.closeFunc();
      }
   }
}
