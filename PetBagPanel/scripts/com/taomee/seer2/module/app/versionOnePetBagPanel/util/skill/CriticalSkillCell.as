package com.taomee.seer2.module.app.versionOnePetBagPanel.util.skill
{
   import com.taomee.seer2.app.component.PetTypeIcon;
   import com.taomee.seer2.app.pet.data.SkillInfo;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class CriticalSkillCell extends BaseSkillCell
   {
       
      
      private var _noSkillTips:Sprite;
      
      private var _angerTxt:TextField;
      
      private var _ctypeIcon:PetTypeIcon;
      
      public function CriticalSkillCell()
      {
         super();
      }
      
      override protected function createContainer() : void
      {
         _container = new CriticalSkillCellUI();
         addChild(_container);
      }
      
      override protected function extractAssets() : void
      {
         super.extractAssets();
         this._noSkillTips = _container["noSkillTips"];
         this._angerTxt = _container["angerTxt"];
         this._ctypeIcon = new PetTypeIcon();
         this._ctypeIcon.x = 4;
         this._ctypeIcon.y = 1;
         addChild(this._ctypeIcon);
      }
      
      override public function setSkillCellData(info:SkillInfo, hasLearnSkill:Boolean = false) : void
      {
         super.setSkillCellData(info,hasLearnSkill);
         if(_skillInfo == null)
         {
            this._noSkillTips.visible = true;
         }
         else
         {
            this._noSkillTips.visible = false;
         }
      }
      
      override protected function updateDisplay() : void
      {
         super.updateDisplay();
         if(Boolean(_skillInfo))
         {
            openInteraction();
            changeTextFormat(this._angerTxt,_isHide);
            this._angerTxt.text = _skillInfo.anger.toString();
            this._ctypeIcon.type = _skillInfo.typeId;
         }
      }
      
      override public function reset() : void
      {
         super.reset();
         this._angerTxt.text = "";
         this._ctypeIcon.clear();
      }
   }
}
