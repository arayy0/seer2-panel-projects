package com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel.selectSkillPanel
{
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.skill.PetSkillSettingDefinition;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.SkillInfo;
import com.taomee.seer2.app.utils.PetUtil;
import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel.BaseSkillPanel;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.util.skill.BaseSkillCell;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.util.skill.CriticalSkillCell;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.util.skill.NoramlSkillCell;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public class CandidateSkillPanel extends BaseSkillPanel
   {
      
      public static const SELECT_SKILL:String = "selectSkill";
       
      
      private var _container:CandidateSkillUI;
      
      private var _nextBtn:SimpleButton;
      
      private var _prevBtn:SimpleButton;
      
      private var _hideNormalSkillInfoVec:Vector.<SkillInfo>;
      
      private var _hideCiriticalSkillInfo:SkillInfo;
      
      private var _hideCiriticalSkillInfo2:SkillInfo;
      
      private var _offset:int;
      
      private var _isShow:Boolean;
      
      private const MAX_NUM:int = 5;
      
      public function CandidateSkillPanel()
      {
         super();
      }
      
      override protected function createContainer() : void
      {
         this._container = new CandidateSkillUI();
         addChild(this._container);
         this._nextBtn = this._container["nextBtn"];
         this._prevBtn = this._container["prevBtn"];
         DisplayObjectUtil.disableButton(this._container["prevBtn2"]);
      }
      
      override protected function createSkillVec() : void
      {
         var rowCount:int = 0;
         var cell:BaseSkillCell = null;
         rowCount = 5;
         var horizontalPadding:int = 135;
         var verticalPadding:int = 68;
         _normalSkillCellVec = new Vector.<BaseSkillCell>();
         var i:int = 0;
         while(i < 5)
         {
            (cell = new NoramlSkillCell()).x = horizontalPadding * (i % rowCount);
            cell.y = verticalPadding * (int(i / rowCount)) + 5;
            addChild(cell);
            _normalSkillCellVec.push(cell);
            i++;
         }
         _criticalSkillCell = new CriticalSkillCell();
         _criticalSkillCell.x = 703;
         _criticalSkillCell.y = 11;
         addChild(_criticalSkillCell);
         _criticalSkillCell2 = new CriticalSkillCell();
         _criticalSkillCell2.x = 703;
         _criticalSkillCell2.y = 11;
         addChild(_criticalSkillCell2);
         _criticalSkillCell2.visible = false;
      }
      
      public function criticalSkillIsEmpty() : Boolean
      {
         return _criticalSkillCell.skillInfo == null;
      }
      
      override protected function initEventListener() : void
      {
         super.initEventListener();
         this._prevBtn.addEventListener("click",this.onPrevBtnClick);
         this._nextBtn.addEventListener("click",this.onNextBtnClick);
         this._container["prevBtn2"].addEventListener("click",this.onBtn2Click);
         this._container["nextBtn2"].addEventListener("click",this.onBtn2Click);
      }
      
      private function onPrevBtnClick(evt:MouseEvent) : void
      {
         --this._offset;
         this.updateDisplay();
      }
      
      private function onNextBtnClick(evt:MouseEvent) : void
      {
         ++this._offset;
         this.updateDisplay();
      }
      
      public function changePetInfoData(info:PetInfo) : void
      {
         _petInfo = info;
         super.reset();
         this.updateData();
         this.updateDisplay();
      }
      
      override protected function reset() : void
      {
         super.reset();
         this._offset = 0;
         this._isShow = false;
      }
      
      override protected function updateData() : void
      {
         updateSkillInfo(_petInfo.skillInfo.candidateSkillInfoVec);
         this.updateHideSkillInfo();
      }
      
      private function updateHideSkillInfo() : void
      {
         var skillInfo:SkillInfo = null;
         var petSkillInfo:SkillInfo = null;
         this._hideNormalSkillInfoVec = new Vector.<SkillInfo>();
         this._hideCiriticalSkillInfo = null;
         this._hideCiriticalSkillInfo2 = null;
         if(_petInfo.level < 60 || (PetUtil.getMaxStatusPet(this._petInfo.bunchId).resId != this._petInfo.resourceId && !HideSkillCheck.checkHasHideSkill(this._petInfo.resourceId)))
         {
            return;
         }
         var skillInfoVec:Vector.<SkillInfo> = this.getNotGainedHideSkillInfoVec();
         for each(skillInfo in skillInfoVec)
         {
            trace(_petInfo.name + " #还未学会的技能:" + skillInfo.name);
            if(skillInfo.isCritical)
            {
               if(this._hideCiriticalSkillInfo == null)
               {
                  if(_criticalSkillCell.skillInfo != null && _criticalSkillCell.skillInfo.id == skillInfo.id)
                  {
                     this._hideCiriticalSkillInfo = skillInfo;
                  }
                  else if(_criticalSkillCell.skillInfo == null)
                  {
                     this._hideCiriticalSkillInfo = skillInfo;
                  }
                  else
                  {
                     this._hideCiriticalSkillInfo2 = skillInfo;
                  }
               }
               else
               {
                  this._hideCiriticalSkillInfo2 = skillInfo;
               }
            }
            else
            {
               this._hideNormalSkillInfoVec.push(skillInfo);
            }
         }
         for each(petSkillInfo in _petInfo.skillInfo.candidateSkillInfoVec)
         {
            if(petSkillInfo.isIntercourse)
            {
               trace(_petInfo.name + " #合体技能:" + petSkillInfo.name);
               if(this._hideCiriticalSkillInfo == null)
               {
                  if(_criticalSkillCell.skillInfo != null && _criticalSkillCell.skillInfo.id == petSkillInfo.id)
                  {
                     this._hideCiriticalSkillInfo = petSkillInfo;
                  }
                  else if(_criticalSkillCell.skillInfo == null)
                  {
                     this._hideCiriticalSkillInfo = petSkillInfo;
                  }
                  else
                  {
                     this._hideCiriticalSkillInfo2 = petSkillInfo;
                  }
               }
               else
               {
                  this._hideCiriticalSkillInfo2 = petSkillInfo;
               }
               return;
            }
         }
         for each(petSkillInfo in _petInfo.skillInfo.candidateSkillInfoVec)
         {
            if(petSkillInfo.isCritical)
            {
               trace(_petInfo.name + " #暴击技能:" + petSkillInfo.name);
               if(this._hideCiriticalSkillInfo == null)
               {
                  if(_criticalSkillCell.skillInfo != null && _criticalSkillCell.skillInfo.id == petSkillInfo.id)
                  {
                     this._hideCiriticalSkillInfo = petSkillInfo;
                  }
                  else if(_criticalSkillCell.skillInfo == null)
                  {
                     this._hideCiriticalSkillInfo = petSkillInfo;
                  }
                  else
                  {
                     this._hideCiriticalSkillInfo2 = petSkillInfo;
                  }
               }
               else
               {
                  this._hideCiriticalSkillInfo2 = petSkillInfo;
               }
               return;
            }
         }
      }
      
      private function getNotGainedHideSkillInfoVec() : Vector.<SkillInfo>
      {
         var petSkillSetting:PetSkillSettingDefinition = null;
         var skillInfo:SkillInfo = null;
         var hideSkillInfoVec:Vector.<SkillInfo> = new Vector.<SkillInfo>();
         var petSettingSkillVec:Vector.<PetSkillSettingDefinition> = PetConfig.getPetSkillSettingDefinitionVec(_petInfo.getPetDefinition().bunchId);
         petSettingSkillVec = HideSkillCheck.hideSkillCoveredRepair(_petInfo.resourceId,petSettingSkillVec);
         for each(petSkillSetting in petSettingSkillVec)
         {
            if(petSkillSetting.learningLv > 100)
            {
               skillInfo = new SkillInfo(petSkillSetting.id);
               skillInfo.isHideSkill = true;
               hideSkillInfoVec.push(skillInfo);
            }
         }
         return hideSkillInfoVec.filter(this.filterSkillByNotGained);
      }
      
      private function filterSkillByNotGained(skillInfo:SkillInfo, index:int, skillInfoVec:Vector.<SkillInfo>) : Boolean
      {
         var petSkillInfo:SkillInfo = null;
         var candidateSkillInfo:SkillInfo = null;
         for each(petSkillInfo in _petInfo.skillInfo.skillInfoVec)
         {
            if(petSkillInfo.id == skillInfo.id)
            {
               return false;
            }
         }
         for each(candidateSkillInfo in _petInfo.skillInfo.candidateSkillInfoVec)
         {
            if(candidateSkillInfo.id == skillInfo.id)
            {
               return false;
            }
         }
         return true;
      }
      
      private function skillFilter() : void
      {
         //屏蔽已有技能，某些精灵出现有两个同名但效果不同的技能，屏蔽掉无效的那个
         var resList:Array = [963,975,980,986,726,950,951,770,771,982,983,813,777,668,716,769,703,703,703,703,703,703,703,703,703,955,560,560,560,560];
         var skillList:Array = [17163,16077,16079,16078,11618,11618,11618,11619,11619,11619,11619,16095,15774,14638,15233,15697,12893,12894,12895,12897,12900,12901,12903,12905,12907,12908,11697,11698,11700,11701];
         var index:int = resList.indexOf(_petInfo.resourceId);
         var i:int = 0;
         var j:int = 0;
         while(i < resList.length)
         {
            if(_petInfo.resourceId == resList[i])
            {
               j = 0;
               while(j < _normalSkillInfoVec.length)
               {
                  if(_normalSkillInfoVec[j].id == skillList[i])
                  {
                     _normalSkillInfoVec.splice(j,1);
                  }
                  j++;
               }
            }
            i++;
         }
         i = 0;
         while(i < this._hideNormalSkillInfoVec.length)
         {
            if(!HideSkillCheck.checkSkillHideable(_petInfo.resourceId,this._hideNormalSkillInfoVec[i].id))
            {
               this._hideNormalSkillInfoVec.splice(i,1);
            }
            i++;
         }
         if(this._hideCiriticalSkillInfo2 != null && !HideSkillCheck.checkSkillHideable(_petInfo.resourceId,this._hideCiriticalSkillInfo2.id))
         {
            this._hideCiriticalSkillInfo2 = null;
         }
         if(this._hideCiriticalSkillInfo != null && !HideSkillCheck.checkSkillHideable(_petInfo.resourceId,this._hideCiriticalSkillInfo.id))
         {
            this._hideCiriticalSkillInfo = null;
            if(this._hideCiriticalSkillInfo2 != null)
            {
               this._hideCiriticalSkillInfo = this._hideCiriticalSkillInfo2;
               this._hideCiriticalSkillInfo2 = null;
            }
         }
         i = 0;
         while(i < resList.length)
         {
            if(_petInfo.resourceId == resList[i])
            {
               if(_criticalSkillInfo != null && _criticalSkillInfo.id == skillList[i])
               {
                  _criticalSkillInfo = null;
               }
            }
            i++;
         }
      }
      
      override protected function updateDisplay() : void
      {
         var skill:SkillInfo = null;
         var infoIndex:int = 0;
         var skillCell:BaseSkillCell = null;
         var normalSkillIndex:* = 0;
         var hideSkillIndex:int = 0;
         this.skillFilter();
         var noramlSkillLength:int = int(_normalSkillInfoVec.length);
         var hideSkillLength:int = int(this._hideNormalSkillInfoVec.length);
         var i:int = 0;
         while(i < 5)
         {
            infoIndex = this._offset + i;
            skillCell = _normalSkillCellVec[i];
            if(infoIndex < noramlSkillLength)
            {
               normalSkillIndex = infoIndex;
               skill = _normalSkillInfoVec[normalSkillIndex];
               trace("已学会技能:" + skill.name);
               skillCell.setSkillCellData(skill,true);
            }
            else if(infoIndex < noramlSkillLength + hideSkillLength)
            {
               hideSkillIndex = infoIndex - noramlSkillLength;
               skill = this._hideNormalSkillInfoVec[hideSkillIndex];
               trace("隐藏技能:" + skill.name);
               skillCell.setSkillCellData(skill,false);
            }
            else
            {
               skillCell.setSkillCellData(null);
            }
            i++;
         }
         if(_criticalSkillInfo == null)
         {
            if(this._hideCiriticalSkillInfo != null)
            {
               _criticalSkillCell.setSkillCellData(this._hideCiriticalSkillInfo,false);
            }
            else if(_criticalSkillInfo2 != null)
            {
               _criticalSkillCell.setSkillCellData(_criticalSkillInfo2,true);
               _criticalSkillInfo2 = null;
               _criticalSkillCell.visible = true;
               _criticalSkillCell2.visible = false;
               DisplayObjectUtil.disableButton(this._container["nextBtn2"]);
               DisplayObjectUtil.disableButton(this._container["prevBtn2"]);
            }
            else if(_hideCiriticalSkillInfo2 != null)
            {
               _criticalSkillCell.setSkillCellData(this._hideCiriticalSkillInfo2,false);
               _hideCiriticalSkillInfo2 = null;
               _criticalSkillCell.visible = true;
               _criticalSkillCell2.visible = false;
               DisplayObjectUtil.disableButton(this._container["nextBtn2"]);
               DisplayObjectUtil.disableButton(this._container["prevBtn2"]);
            }
            else
            {
               _criticalSkillCell.setSkillCellData(null);
            }
         }
         else
         {
            _criticalSkillCell.setSkillCellData(_criticalSkillInfo,true);
         }
         if(_criticalSkillInfo2 == null)
         {
            if(this._hideCiriticalSkillInfo2 != null)
            {
               _criticalSkillCell2.setSkillCellData(this._hideCiriticalSkillInfo2,false);
               if(_criticalSkillCell.visible == true)
               {
                  DisplayObjectUtil.enableButton(this._container["nextBtn2"]);
                  DisplayObjectUtil.disableButton(this._container["prevBtn2"]);
               }
               else
               {
                  DisplayObjectUtil.disableButton(this._container["nextBtn2"]);
                  DisplayObjectUtil.enableButton(this._container["prevBtn2"]);
               }
            }
            else
            {
               _criticalSkillCell2.setSkillCellData(null);
               _criticalSkillCell.visible = true;
               _criticalSkillCell2.visible = false;
               DisplayObjectUtil.disableButton(this._container["nextBtn2"]);
               DisplayObjectUtil.disableButton(this._container["prevBtn2"]);
            }
         }
         else
         {
            _criticalSkillCell2.setSkillCellData(_criticalSkillInfo2,true);
            if(_criticalSkillCell.visible == true)
            {
               DisplayObjectUtil.enableButton(this._container["nextBtn2"]);
               DisplayObjectUtil.disableButton(this._container["prevBtn2"]);
            }
            else
            {
               DisplayObjectUtil.disableButton(this._container["nextBtn2"]);
               DisplayObjectUtil.enableButton(this._container["prevBtn2"]);
            }
         }
         DisplayObjectUtil.enableButton(this._prevBtn);
         DisplayObjectUtil.enableButton(this._nextBtn);
         if(this._offset == 0)
         {
            DisplayObjectUtil.disableButton(this._prevBtn);
         }
         if(this._offset + 5 >= _normalSkillInfoVec.length + this._hideNormalSkillInfoVec.length)
         {
            DisplayObjectUtil.disableButton(this._nextBtn);
         }
      }
      
      private function onBtn2Click(e:MouseEvent) : void
      {
         if(_criticalSkillCell.visible == false)
         {
            _criticalSkillCell.visible = true;
            _criticalSkillCell2.visible = false;
            DisplayObjectUtil.disableButton(this._container["prevBtn2"]);
            DisplayObjectUtil.enableButton(this._container["nextBtn2"]);
         }
         else
         {
            _criticalSkillCell.visible = false;
            _criticalSkillCell2.visible = true;
            DisplayObjectUtil.enableButton(this._container["prevBtn2"]);
            DisplayObjectUtil.disableButton(this._container["nextBtn2"]);
         }
      }
   }
}
