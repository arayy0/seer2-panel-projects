package com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel
{
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.skill.PetSkillSettingDefinition;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.pet.data.SkillInfo;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.utils.PetUtil;
   import com.taomee.seer2.core.effects.SoundEffects;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.PetSkillPanel;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel.selectSkillPanel.AvailableSkillPanel;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel.selectSkillPanel.CandidateSkillPanel;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel.selectSkillPanel.GraspHideSkillPanel;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel.selectSkillPanel.HideSkillCheck;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class SelectSkillPanel extends Sprite
   {
       
      
      private var _container:MovieClip;
      
      private var _closeBtn:SimpleButton;
      
      private var _availableSkillPanel:AvailableSkillPanel;
      
      private var _candidateSkillPanel:CandidateSkillPanel;
      
      private var _skillGraspHideSkillPanel:GraspHideSkillPanel;
      
      private var _loadInfo:ContentInfo;
      
      private var _skillGraspMC:MovieClip;
      
      private var _petInfo:PetInfo;

      
      public function SelectSkillPanel()
      {
         super();
         this.initSet();
         this.initEvent();
      }
      
      private function initSet() : void
      {
         this._container = new SelectSkillUI();
         addChild(this._container);
         this._closeBtn = this._container["closeBtn"] as SimpleButton;
         this._availableSkillPanel = new AvailableSkillPanel();
         addChild(this._availableSkillPanel);
         this._availableSkillPanel.x = 73;
         this._availableSkillPanel.y = 33;
         this._candidateSkillPanel = new CandidateSkillPanel();
         addChild(this._candidateSkillPanel);
         this._candidateSkillPanel.x = 48;
         this._candidateSkillPanel.y = 192;
         this._skillGraspHideSkillPanel = new GraspHideSkillPanel(this);
         addChild(this._skillGraspHideSkillPanel);
         this._skillGraspHideSkillPanel.x = 147;
         this._skillGraspHideSkillPanel.y = 284;
      }
      
      private function initEvent() : void
      {
         this._closeBtn.addEventListener("click",this.onCloseBtn);
         this._availableSkillPanel.addEventListener("requestChangeSkill",this.onRequestChangeSkill);
         this._candidateSkillPanel.addEventListener("requestChangeSkill",this.onRequestChangeSkill);
      }
      
      private function onCloseBtn(evt:MouseEvent) : void
      {
         this.hide();
      }
      
      private function hide() : void
      {
         (this.parent as PetSkillPanel).updateSelectedSkillPanel();
         DisplayObjectUtil.removeFromParent(this);
      }
      
      private function updateNewGuide() : void
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
      
      private function onRequestChangeSkill(evt:Event) : void
      {
         var availableSkillInfo:SkillInfo = null;
         var candidateSkillInfo:SkillInfo = null;
         var data:LittleEndianByteArray = null;
         var count:int = 0;
         var i:int = 0;
         if(this._availableSkillPanel.isNormalSkillSelected() && this._candidateSkillPanel.isNormalSkillSelected())
         {
            availableSkillInfo = this._availableSkillPanel.selectedNormalSkillInfo;
            candidateSkillInfo = this._candidateSkillPanel.selectedNormalSkillInfo;
            this._availableSkillPanel.replaceNormalSkill(candidateSkillInfo);
            this._candidateSkillPanel.replaceNormalSkill(availableSkillInfo);
         }
         if(this._availableSkillPanel.isCriticalSkillSelected() && this._candidateSkillPanel.isCriticalSkillSelected())
         {
            if(this._candidateSkillPanel.criticalSkillIsEmpty() == false)
            {
               availableSkillInfo = this._availableSkillPanel.selectedCriticalSkillInfo;
               candidateSkillInfo = this._candidateSkillPanel.selectedCriticalSkillInfo;
               this._availableSkillPanel.replaceCriticalSkill(candidateSkillInfo);
               this._candidateSkillPanel.replaceCriticalSkill(availableSkillInfo);
            }
            else
            {
               this._availableSkillPanel.resetSelectedCriticalSkillCell();
               this._candidateSkillPanel.resetSelectedCriticalSkillCell();
            }
         }
         var skillInfoVec:Vector.<SkillInfo> = this._availableSkillPanel.getAllSkillInfoVec();
         if(this.hasChangedSkill(skillInfoVec))
         {
            data = new LittleEndianByteArray();
            data.writeUnsignedInt(this._petInfo.catchTime);
            count = int(skillInfoVec.length);
            data.writeUnsignedInt(count);
            for(i = 0; i < count; )
            {
               data.writeUnsignedInt(skillInfoVec[i].id);
               i++;
            }
            Connection.addCommandListener(CommandSet.PET_REPLACE_SKILL_1030,this.onReplacedSkill);
            Connection.addErrorHandler(CommandSet.PET_REPLACE_SKILL_1030,this.onReplacedSkillError);
            Connection.send(CommandSet.PET_REPLACE_SKILL_1030,data);
            DisplayObjectUtil.disableSprite(this);
         }
      }
      
      private function onReplacedSkillError(evt:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.PET_REPLACE_SKILL_1030,this.onReplacedSkill);
         Connection.removeErrorHandler(CommandSet.PET_REPLACE_SKILL_1030,this.onReplacedSkillError);
         DisplayObjectUtil.enableSprite(this);
         switch(int(evt.message.statusCode) - 33)
         {
            case 0:
               AlertManager.showAlert("精灵不在精灵背包里");
               break;
            case 3:
               AlertManager.showAlert("精灵没有此技能");
               break;
            case 4:
               AlertManager.showAlert("替换的技能或必杀技多于1个，或普通技能多于4个");
               break;
            case 5:
               AlertManager.showAlert("欲替换的技能和原背包中的技能数量不符");
         }
      }
      
      private function onReplacedSkill(event:MessageEvent) : void
      {
         DisplayObjectUtil.enableSprite(this);
         Connection.removeErrorHandler(CommandSet.PET_REPLACE_SKILL_1030,this.onReplacedSkillError);
         Connection.removeCommandListener(CommandSet.PET_REPLACE_SKILL_1030,this.onReplacedSkill);
         var data:LittleEndianByteArray = event.message.getRawData();
         var petId:uint = uint(data.readUnsignedInt());
         var petInfo:PetInfo;
         if((petInfo = PetInfoManager.getPetInfoFromBag(petId)) == null)
         {
            return;
         }
         PetInfo.readSkillInfo(petInfo,data);
         PetInfo.readCandidateSkillInfo(petInfo,data);
         if(petId == this._petInfo.catchTime)
         {
            SoundEffects.playSkillReset();
         }
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
         this._availableSkillPanel.setPetInfoData(this._petInfo);
         this._candidateSkillPanel.setPetInfoData(this._petInfo);
         if(this._petInfo.level >= 60 && (this.getPetHideSkillCount(this._petInfo) || HideSkillCheck.checkHasHideSkill(this._petInfo.resourceId)) && this.getPetHideCount(this._petInfo) > 0)
         {
            this._skillGraspHideSkillPanel.setPetInfoData(this._petInfo);
         }
         if(this.isCanShowHideSkill())
         {
            this._skillGraspHideSkillPanel.show();
         }
         else
         {
            this._skillGraspHideSkillPanel.hide();
         }
         this.updateNewGuide();
      }
      
      private function isCanShowHideSkill() : Boolean
      {
         var canShow:Boolean = true;
         if(this._petInfo.level < 60)
         {
            canShow = false;
         }
         if(this._petInfo.bunchId == 247 || this._petInfo.bunchId == 195)
         {
         }
         if(this.getPetHideSkillCount(this._petInfo) == false && this._petInfo.resourceId != 496 && this._petInfo.resourceId != 497 && this._petInfo.resourceId != 271)
         {
         }
         if(!this.getPetHideSkillCount(this._petInfo) && !HideSkillCheck.checkHasHideSkill(this._petInfo.resourceId))
         {
            canShow = false;
         }
         if(this.getPetHideCount(this._petInfo) <= 0)
         {
            canShow = false;
         }
         return canShow;
      }
      
      private function getPetHideCount(petInfo:PetInfo) : uint
      {
         var skillInfo:PetSkillSettingDefinition = null;
         var count:uint = 0;
         var skillInfoVec:Vector.<PetSkillSettingDefinition> = PetConfig.getPetSkillSettingDefinitionVec(petInfo.bunchId);
         skillInfoVec = HideSkillCheck.hideSkillCoveredRepair(petInfo.resourceId,skillInfoVec);
         for each(skillInfo in skillInfoVec)
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
         DisplayUtil.removeForParent(this._skillGraspHideSkillPanel);
         this._skillGraspHideSkillPanel.hide();
      }
      
      public function changePetInfoData(info:PetInfo = null) : void
      {
         if(info != null)
         {
            this._petInfo = info;
         }
         if(Boolean(this._petInfo))
         {
            this._availableSkillPanel.setPetInfoData(this._petInfo);
            this._candidateSkillPanel.changePetInfoData(this._petInfo);
         }
      }
   }
}
