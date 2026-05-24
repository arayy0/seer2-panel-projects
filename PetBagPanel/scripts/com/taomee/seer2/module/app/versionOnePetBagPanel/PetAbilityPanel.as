package com.taomee.seer2.module.app.versionOnePetBagPanel
{
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.petAbilityPanel.BasePetAblilityPanel;
   import flash.display.Sprite;
   
   public class PetAbilityPanel extends Sprite
   {
      
      public static const BASE_ABILITY_PANEL:int = 0;
       
      
      private var _baseInfoPanel:BasePetAblilityPanel;
      
      private var _curPanel:Sprite;
      
      private var _petInfo:PetInfo;
      
      public function PetAbilityPanel()
      {
         super();
         this.initSet();
      }
      
      private function initSet() : void
      {
         this._baseInfoPanel = new BasePetAblilityPanel(this);
         addChild(this._baseInfoPanel);
         this._curPanel = this._baseInfoPanel;
      }
      
      public function setData(info:PetInfo) : void
      {
         this._petInfo = info;
         if(Boolean(this._curPanel))
         {
            Object(this._curPanel).setData(this._petInfo);
         }
      }
      
      public function changePanelShow(type:int) : void
      {
         if(Boolean(this._curPanel))
         {
            DisplayObjectUtil.removeFromParent(this._curPanel);
            this._curPanel = null;
         }
         switch(type)
         {
            case 0:
               this._curPanel = this._baseInfoPanel;
         }
         addChild(this._curPanel);
         if(this._petInfo != null)
         {
            Object(this._curPanel).setData(this._petInfo);
         }
      }
   }
}
