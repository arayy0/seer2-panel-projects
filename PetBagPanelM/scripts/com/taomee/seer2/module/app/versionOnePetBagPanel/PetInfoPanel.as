package com.taomee.seer2.module.app.versionOnePetBagPanel {
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.petInfoPanel.BaseInfoPanel;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.petInfoPanel.SetPotentionPanel;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.petInfoPanel.SetQualityPanel;
   import flash.display.Sprite;
   
   public class PetInfoPanel extends Sprite {
      public static const BASE_PANEL:int = 0;
      public static const SET_POTENT_PANEL:int = 1;
      public static const SET_QUALITY_PANEL:int = 2;
      public static const SET_LEVELUP_PANEL:int = 3;
      public static const SET_CHANGEATTR_PANEL:int = 4;
      private var _baseInfoPanel:BaseInfoPanel;
      private var _setPotentionPanel:SetPotentionPanel;
      private var _setQualityPanel:SetQualityPanel;
      private var _curPanel:Sprite;
      private var _petInfo:PetInfo;
      private var _petBagPanel:PetBagPanel;
      
      public function PetInfoPanel(petBagPanel:PetBagPanel) {
         super();
         this._petBagPanel = petBagPanel;
         this.initSet();
      }
      
      private function initSet() : void {
         this._baseInfoPanel = new BaseInfoPanel(this);
         this.addChild(this._baseInfoPanel);
         this._curPanel = this._baseInfoPanel;
         this._setPotentionPanel = new SetPotentionPanel(this);
         this._setQualityPanel = new SetQualityPanel(this,this._petBagPanel);
      }
      
      public function setData(info:PetInfo) : void {
         this._petInfo = info;
         if(Boolean(this._curPanel)) {
            Object(this._curPanel).setData(this._petInfo);
         }
      }
      
      public function changePanelShow(type:int) : void {
         if(Boolean(this._curPanel)) {
            DisplayObjectUtil.removeFromParent(this._curPanel);
            this._curPanel = null;
         }
         switch(type) {
            case 0:
               this._curPanel = this._baseInfoPanel;
               break;
            case 1:
               this._curPanel = this._setPotentionPanel;
               break;
            case 2:
               this._curPanel = this._setQualityPanel;
               break;
            case 3:
               this._curPanel = this._baseInfoPanel;
               ModuleManager.showAppModule("GotExpPanel");
               break;
            case 4:
               this._curPanel = this._baseInfoPanel;
               ModuleManager.showAppModule("GotAttributePanel",this._petInfo);
               break;
            }
         this.addChild(this._curPanel);
         if(this._petInfo != null) {
            Object(this._curPanel).setData(this._petInfo);
         }
      }
   }
}
