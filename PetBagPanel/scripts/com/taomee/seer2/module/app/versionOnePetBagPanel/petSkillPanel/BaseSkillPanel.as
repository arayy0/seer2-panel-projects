package com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel
{
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.skill.PetSkillSettingDefinition;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.SkillInfo;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel.selectSkillPanel.HideSkillCheck;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.util.skill.BaseSkillCell;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class BaseSkillPanel extends Sprite
   {
      
      public static const MAX_NUM:int = 4;
      
      public static const REQUEST_CHANGE_SKILL:String = "requestChangeSkill";
       
      
      protected var _normalSkillInfoVec:Vector.<SkillInfo>;
      
      protected var _criticalSkillInfo:SkillInfo;
      
      protected var _normalSkillCellVec:Vector.<BaseSkillCell>;
      
      protected var _criticalSkillCell:BaseSkillCell;
      
      protected var _selectedNormalSkillCell:BaseSkillCell;
      
      protected var _selectedCriticalSkillCell:BaseSkillCell;
      
      protected var _petInfo:PetInfo;
      
      protected var _criticalSkillInfo2:SkillInfo;
      
      protected var _criticalSkillCell2:BaseSkillCell;
      
      public function BaseSkillPanel()
      {
         super();
         this.createContainer();
         this.createSkillVec();
         this.initEventListener();
      }
      
      protected function createContainer() : void
      {
      }
      
      protected function createSkillVec() : void
      {
      }
      
      protected function updateData() : void
      {
      }
      
      protected function updateDisplay() : void
      {
      }
      
      protected function initEventListener() : void
      {
         this.mouseEnabled = false;
         var i:int = 0;
         while(i < this._normalSkillCellVec.length)
         {
            this._normalSkillCellVec[i].addEventListener("cellClick",this.onNormalSkillCellClick);
            i++;
         }
         this._criticalSkillCell.addEventListener("cellClick",this.onCriticalSkillCellClick);
         this._criticalSkillCell2.addEventListener("cellClick",this.onCriticalSkillCellClick);
      }
      
      protected function onNormalSkillCellClick(evt:Event) : void
      {
         this._selectedNormalSkillCell = evt.currentTarget as BaseSkillCell;
         var i:int = 0;
         while(i < this._normalSkillCellVec.length)
         {
            if(this._normalSkillCellVec[i] == this._selectedNormalSkillCell)
            {
               this._normalSkillCellVec[i].isSelected = true;
            }
            else
            {
               this._normalSkillCellVec[i].isSelected = false;
            }
            i++;
         }
         dispatchEvent(new Event("requestChangeSkill"));
      }
      
      protected function onCriticalSkillCellClick(evt:Event) : void
      {
         this._criticalSkillCell.isSelected = false;
         this._criticalSkillCell2.isSelected = false;
         var cell:BaseSkillCell = evt.currentTarget as BaseSkillCell;
         if(cell.hasLearnSkill)
         {
            this._selectedCriticalSkillCell = cell;
            this._selectedCriticalSkillCell.isSelected = true;
            dispatchEvent(new Event("requestChangeSkill"));
         }
      }
      
      public function setPetInfoData(info:PetInfo) : void
      {
         this._petInfo = info;
         this.reset();
         this.updateData();
         this.updateDisplay();
      }
      
      protected function reset() : void
      {
         this.resetSelectedNormalSkillCell();
         this.resetSelectedCriticalSkillCell();
      }
      
      protected function updateSkillInfo(skillInfoVec:Vector.<SkillInfo>) : void
      {
         var skillInfo:SkillInfo = null;
         var petSkillSetting:PetSkillSettingDefinition = null;
         this._criticalSkillInfo = null;
         this._criticalSkillInfo2 = null;
         var petSettingSkillVec:Vector.<PetSkillSettingDefinition> = PetConfig.getPetSkillSettingDefinitionVec(this._petInfo.getPetDefinition().bunchId);
         petSettingSkillVec = HideSkillCheck.hideSkillCoveredRepair(this._petInfo.resourceId,petSettingSkillVec);
         for each(petSkillSetting in petSettingSkillVec)
         {
            if(petSkillSetting.learningLv > 100)
            {
               skillInfo = this.getSkillInfo(skillInfoVec,petSkillSetting.id);
               if(skillInfo != null)
               {
                  skillInfo.isHideSkill = true;
               }
            }
         }
         this._normalSkillInfoVec = new Vector.<SkillInfo>();
         for each(skillInfo in skillInfoVec)
         {
            if(skillInfo.isCritical)
            {
               if(this._criticalSkillInfo == null)
               {
                  this._criticalSkillInfo = skillInfo;
               }
               else
               {
                  this._criticalSkillInfo2 = skillInfo;
               }
            }
            else
            {
               this._normalSkillInfoVec.push(skillInfo);
            }
         }
      }
      
      private function getSkillInfo(skillInfoVec:Vector.<SkillInfo>, skillId:uint) : SkillInfo
      {
         var rs:SkillInfo = null;
         var len:uint = skillInfoVec.length;
         var i:uint = 0;
         while(i < len)
         {
            if(skillInfoVec[i].id == skillId)
            {
               rs = skillInfoVec[i];
               break;
            }
            i++;
         }
         return rs;
      }
      
      private function updateSkillInfoVec(newSkillInfo:SkillInfo, oldSkillInfo:SkillInfo) : void
      {
         var index:int = this.getSkillInfoIndex(oldSkillInfo);
         if(index == -1)
         {
            if(newSkillInfo != null)
            {
               this._normalSkillInfoVec.push(newSkillInfo);
            }
         }
         else if(newSkillInfo != null)
         {
            this._normalSkillInfoVec.splice(index,1,newSkillInfo);
         }
         else
         {
            this._normalSkillInfoVec.splice(index,1);
         }
      }
      
      private function getSkillInfoIndex(info:SkillInfo) : int
      {
         var index:* = -1;
         if(info == null)
         {
            return index;
         }
         var len:int = int(this._normalSkillInfoVec.length);
         var i:int = 0;
         while(i < len)
         {
            if(this._normalSkillInfoVec[i].id == info.id)
            {
               index = i;
               break;
            }
            i++;
         }
         return index;
      }
      
      public function replaceCriticalSkill(info:SkillInfo) : void
      {
         if(this._selectedCriticalSkillCell == this._criticalSkillCell)
         {
            this._criticalSkillInfo = info;
         }
         else
         {
            this._criticalSkillInfo2 = info;
         }
         if(this._selectedCriticalSkillCell != null)
         {
            this._selectedCriticalSkillCell.showReplaceAnnimation();
         }
         this.resetSelectedCriticalSkillCell();
         this.updateDisplay();
      }
      
      public function replaceNormalSkill(info:SkillInfo) : void
      {
         var oldInfo:SkillInfo = this._selectedNormalSkillCell.skillInfo;
         this.updateSkillInfoVec(info,oldInfo);
         if(this._selectedNormalSkillCell != null)
         {
            this._selectedNormalSkillCell.showReplaceAnnimation();
         }
         this.resetSelectedNormalSkillCell();
         this.updateDisplay();
      }
      
      public function resetSelectedNormalSkillCell() : void
      {
         if(this._selectedNormalSkillCell != null)
         {
            this._selectedNormalSkillCell.isSelected = false;
            this._selectedNormalSkillCell = null;
         }
      }
      
      public function resetSelectedCriticalSkillCell() : void
      {
         if(this._selectedCriticalSkillCell != null)
         {
            this._selectedCriticalSkillCell.isSelected = false;
            this._selectedCriticalSkillCell = null;
         }
      }
      
      public function getAllSkillInfoVec() : Vector.<SkillInfo>
      {
         var infoVec:Vector.<SkillInfo> = this._normalSkillInfoVec.slice();
         if(this._criticalSkillInfo != null)
         {
            infoVec.push(this._criticalSkillInfo);
         }
         if(this._criticalSkillInfo2 != null)
         {
            infoVec.push(this._criticalSkillInfo2);
         }
         return infoVec;
      }
      
      public function isNormalSkillSelected() : Boolean
      {
         return this._selectedNormalSkillCell != null;
      }
      
      public function get selectedNormalSkillInfo() : SkillInfo
      {
         return this._selectedNormalSkillCell.skillInfo;
      }
      
      public function isCriticalSkillSelected() : Boolean
      {
         return this._selectedCriticalSkillCell != null;
      }
      
      public function get selectedCriticalSkillInfo() : SkillInfo
      {
         return this._selectedCriticalSkillCell.skillInfo;
      }
   }
}
