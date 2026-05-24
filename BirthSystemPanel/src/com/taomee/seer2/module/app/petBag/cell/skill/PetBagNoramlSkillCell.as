package com.taomee.seer2.module.app.petBag.cell.skill
{
   import com.taomee.seer2.app.component.PetTypeIcon;
   import com.taomee.seer2.core.utils.StringConstants;
   import com.taomee.seer2.module.app.petBag.PetBagNormalSkillCellUI;
   import flash.text.TextField;
   
   public class PetBagNoramlSkillCell extends PetBagBaseSkillCell
   {
      private var _categoryTxt:TextField;
      
      private var _typeIcon:PetTypeIcon;
      
      private var _angerTxt:TextField;
      
      public function PetBagNoramlSkillCell()
      {
         super();
      }
      
      override protected function createContainer() : void
      {
         _container = new PetBagNormalSkillCellUI();
         addChild(_container);
         this.addTypeIcon();
      }
      
      private function addTypeIcon() : void
      {
         this._typeIcon = new PetTypeIcon();
         this._typeIcon.x = 4;
         this._typeIcon.y = 4;
         addChild(this._typeIcon);
      }
      
      override protected function extractAssets() : void
      {
         super.extractAssets();
         this._categoryTxt = _container["categoryTxt"];
         this._angerTxt = _container["angerTxt"];
      }
      
      override public function reset() : void
      {
         super.reset();
         this._typeIcon.clear();
         this._angerTxt.text = "";
         this._categoryTxt.text = "";
      }
      
      override protected function updateDisplay() : void
      {
         super.updateDisplay();
         if(_hasLearnSkill == true)
         {
            this._categoryTxt.text = _skillInfo.category;
            changeTextFormat(this._angerTxt,_isHide);
            this._angerTxt.text = "怒气" + StringConstants.COLON + _skillInfo.anger;
            this._typeIcon.type = _skillInfo.typeId;
         }
      }
   }
}

