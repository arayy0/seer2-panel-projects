package com.taomee.seer2.module.app.versionOnePetBagPanel
{
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.module.app.appraisal.IResetable;
   import com.taomee.seer2.module.app.starMagic.StarBagShowPanel;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class PetTabPanel extends Sprite implements IResetable
   {
       
      
      private var _bagPanel:PetBagPanel;
      
      private var _tab:PanelTab;
      
      private var _petInfoPanel:PetInfoPanel;
      
      private var _petSkillPanel:PetSkillPanel;
      
      private var _itemPanel:PetItemBagPanel;
      
      private var _petAbilityPanel:PetAbilityPanel;
      
      private var _magicPanel:StarBagShowPanel;
      
      private var _currentPanel:Sprite;
      
      private var _petInfo:PetInfo;
      
      public function PetTabPanel(bagPanel:PetBagPanel)
      {
         super();
         this._bagPanel = bagPanel;
         this.initialize();
      }
      
      private function initialize() : void
      {
         this._petInfoPanel = new PetInfoPanel(this._bagPanel);
         this._petInfoPanel.x = 20;
         this._petInfoPanel.y = 170;
         addChild(this._petInfoPanel);
         this._currentPanel = this._petInfoPanel;
         this._itemPanel = new PetItemBagPanel(this._bagPanel,this);
         this._itemPanel.x = 2;
         this._itemPanel.y = 48;
         this._petAbilityPanel = new PetAbilityPanel();
         this._petAbilityPanel.x = 20;
         this._petAbilityPanel.y = 15;
         this._petSkillPanel = new PetSkillPanel();
         this._petSkillPanel.y = 10;
         this._magicPanel = new StarBagShowPanel();
         this._magicPanel.x = 30;
         this._magicPanel.y = -10;
         this._tab = new PanelTab();
         addChild(this._tab);
         this._tab.x = 270;
         this._tab.y = 72;
         this._tab.activeTabIndex = 0;
         this._tab.addEventListener("activeTabChange",this.onTabChange);
      }
      
      private function onTabChange(evt:Event) : void
      {
         DisplayObjectUtil.removeFromParent(this._currentPanel);
         switch(this._tab.activeTabIndex)
         {
            case 0:
               this._currentPanel = this._petInfoPanel;
               break;
            case 1:
               this._currentPanel = this._petAbilityPanel;
               break;
            case 2:
               this._currentPanel = this._petSkillPanel;
               break;
            case 3:
               this._currentPanel = this._magicPanel;
               break;
            case 4:
               this._currentPanel = this._itemPanel;
         }
         if(Boolean(this._petInfo))
         {
            Object(this._currentPanel).setData(this._petInfo);
         }
         addChild(this._currentPanel);
         addChild(this._tab);
         this.resetFilter();
      }
      
      private function resetFilter() : void
      {
         if(this._currentPanel is PetInfoPanel)
         {
            (this._currentPanel as PetInfoPanel).changePanelShow(0);
         }
      }
      
      public function changeCurPanelTab(type:int, subType:int) : void
      {
         if(Boolean(this._currentPanel))
         {
            if(type == 0)
            {
               (this._currentPanel as PetInfoPanel).changePanelShow(subType);
            }
         }
      }
      
      public function reset() : void
      {
         DisplayObjectUtil.disableSprite(this);
         this._tab.reset();
         this._itemPanel.keepPage(false);
      }
      
      public function setData(info:PetInfo) : void
      {
         this._petInfo = info;
         if(Boolean(this._currentPanel))
         {
            Object(this._currentPanel).setData(this._petInfo);
         }
      }
      
      public function updatePet() : void
      {
         this._itemPanel.setData(this._petInfo);
         this._petInfoPanel.setData(this._petInfo);
         this._petSkillPanel.setData(this._petInfo);
         this._petAbilityPanel.setData(this._petInfo);
      }
      
      public function hideGrasp() : void
      {
      }
      
      public function changeTab(index:int) : void
      {
         this._tab.activeTabIndex = index;
      }
      
      public function resetMouseable() : void
      {
         DisplayObjectUtil.enableSprite(this);
      }
      
      public function dispose() : void
      {
         this._itemPanel.dispose();
      }
   }
}
