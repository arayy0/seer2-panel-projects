package com.taomee.seer2.module.app.versionOnePetBagPanel.util.skill {
   import com.taomee.seer2.app.component.PetTypeIcon;
   import com.taomee.seer2.app.pet.data.SkillInfo;
   import flash.text.TextField;
   
   public class CriticalSkillCell extends BaseSkillCell {
      private var _angerTxt:TextField;
      private var _ctypeIcon:PetTypeIcon;
      
      public function CriticalSkillCell() {
         super();
      }
      
      override protected function createContainer() : void {
         this._container = new CriticalSkillCellUI();
         this.addChild(_container);
      }
      
      override protected function extractAssets() : void {
         super.extractAssets();
         this._angerTxt = _container["angerTxt"];
         this._ctypeIcon = new PetTypeIcon();
         this._ctypeIcon.x = 4;
         this._ctypeIcon.y = 3;
         this.addChild(this._ctypeIcon);
      }
      
      override protected function updateDisplay() : void {
         super.updateDisplay();
         if(Boolean(this._skillInfo)) {
            this.openInteraction();
            this.changeTextFormat(this._angerTxt,_isHide);
            this._angerTxt.text = _skillInfo.anger.toString();
            this._ctypeIcon.type = _skillInfo.typeId;
         }
      }
      
      override public function reset() : void {
         super.reset();
         this._angerTxt.text = "";
         this._ctypeIcon.clear();
      }
   }
}
