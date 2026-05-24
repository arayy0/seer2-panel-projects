package com.taomee.seer2.module.app.versionOnePetBagPanel.util.skill
{
   import com.taomee.seer2.app.component.PetTypeIcon;
   import flash.text.TextField;
   
   public class NoramlSkillCell extends BaseSkillCell
   {
       
      
      private var _categoryTxt:TextField;
      
      private var _typeIcon:PetTypeIcon;
      
      private var _angerTxt:TextField;
      
      public function NoramlSkillCell()
      {
         super();
      }
      
      override protected function createContainer() : void
      {
         _container = new NormalSkillCellUI();
         addChild(_container);
         this.addTypeIcon();
      }
      
      private function addTypeIcon() : void
      {
         this._typeIcon = new PetTypeIcon();
         this._typeIcon.x = 4;
         this._typeIcon.y = 5;
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
            this._angerTxt.text = _skillInfo.anger.toString();
            this._typeIcon.type = _skillInfo.typeId;
         }
      }
   }
}
