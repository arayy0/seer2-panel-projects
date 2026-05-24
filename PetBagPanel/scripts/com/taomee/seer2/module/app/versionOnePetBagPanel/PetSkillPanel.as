package com.taomee.seer2.module.app.versionOnePetBagPanel
{
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.skill.PetSkillSettingDefinition;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.SkillInfo;
   import com.taomee.seer2.app.utils.PetUtil;
   import com.taomee.seer2.core.effects.SoundEffects;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel.GetedSkillPanel;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel.SelectSkillPanel;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class PetSkillPanel extends Sprite
   {
       
      
      private var _container:MovieClip;
      
      private var _resetBtn:SimpleButton;
      
      private var _getedSkillPanel:GetedSkillPanel;
      
      private var _selectSkillPanel:SelectSkillPanel;
      
      private var _petInfo:PetInfo;
      
      public function PetSkillPanel()
      {
         super();
         this._container = new PetSkillUI();
         addChild(this._container);
         this._container.x = 609;
         this._container.y = 90;
         this._resetBtn = this._container["resetBtn"];
         SoundEffects.setButton(this._resetBtn);
         this._resetBtn.addEventListener("click",this.onResetBtnClick);
         this._getedSkillPanel = new GetedSkillPanel();
         addChild(this._getedSkillPanel);
         this._getedSkillPanel.x = 631;
         this._getedSkillPanel.y = 140;
         this._selectSkillPanel = new SelectSkillPanel();
         this._selectSkillPanel.x = 42;
         this._selectSkillPanel.y = 62;
      }
      
      private function onResetBtnClick(evt:MouseEvent) : void
      {
         this._selectSkillPanel.setData(this._petInfo);
         addChild(this._selectSkillPanel);
      }
      
      private function updateNewGuide() : void
      {
      }
      
      private function onLoadComplete(info:ContentInfo) : void
      {
      }
      
      private function getPetHideSkillCount(petInfo:PetInfo) : Boolean
      {
         if(PetUtil.getMaxStatusPet(petInfo.bunchId).resId == petInfo.resourceId)
         {
            return true;
         }
         return false;
      }
      
      private function graspHideSkillPanel() : void
      {
      }
      
      private function hasChangedSkill(skillInfoVec:Vector.<SkillInfo>) : Boolean
      {
         var skillInfo:SkillInfo = null;
         if(skillInfoVec.length != this._petInfo.skillInfo.skillInfoVec.length)
         {
            return true;
         }
         for each(skillInfo in skillInfoVec)
         {
            if(this.containsSkillInfo(skillInfo) == false)
            {
               return true;
            }
         }
         return false;
      }
      
      private function containsSkillInfo(skillInfo:SkillInfo) : Boolean
      {
         var orginalSkillInfo:SkillInfo = null;
         for each(orginalSkillInfo in this._petInfo.skillInfo.skillInfoVec)
         {
            if(skillInfo.id == orginalSkillInfo.id)
            {
               return true;
            }
         }
         return false;
      }
      
      public function setData(info:PetInfo) : void
      {
         this.setPetInfoData(info);
      }
      
      public function setPetInfoData(info:PetInfo) : void
      {
         this._petInfo = info;
         this._getedSkillPanel.setPetInfoData(this._petInfo);
         this._selectSkillPanel.setPetInfoData(this._petInfo);
         this.updateNewGuide();
      }
      
      private function getPetHideCount(petInfo:PetInfo) : uint
      {
         var skillInfo:PetSkillSettingDefinition = null;
         var count:uint = 0;
         for each(skillInfo in PetConfig.getPetSkillSettingDefinitionVec(petInfo.bunchId))
         {
            if(skillInfo.learningLv > 100)
            {
               count++;
            }
         }
         return count;
      }
      
      public function hideSkillGraspHideSkill() : void
      {
      }
      
      public function updateSelectedSkillPanel() : void
      {
         this._getedSkillPanel.setPetInfoData(this._petInfo);
      }
      
      public function changePetInfoData(info:PetInfo) : void
      {
         this._petInfo = info;
         this._getedSkillPanel.setPetInfoData(this._petInfo);
         this._selectSkillPanel.changePetInfoData(this._petInfo);
      }
   }
}
