package com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel.selectSkillPanel {
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
   
   public class CandidateSkillPanel extends BaseSkillPanel {
      public static const SELECT_SKILL:String = "selectSkill";
      private var _container:CandidateSkillUI;
      private var _nextBtn:SimpleButton;
      private var _prevBtn:SimpleButton;
      private var _nextBtn2:SimpleButton;
      private var _prevBtn2:SimpleButton;
      private var _hideNormalSkillInfoVec:Vector.<SkillInfo>;
      private var _hideCriticalSkillInfo:SkillInfo;
      private var _hideCriticalSkillInfo2:SkillInfo;
      private var _offset:int;
      private var _isShow:Boolean;
      private const MAX_NUM:int = 4;
      
      public function CandidateSkillPanel() {
         super();
      }
      
      override protected function createContainer() : void {
         this._container = new CandidateSkillUI();
         this._container.x = 98;
         this.addChild(this._container);
         this._nextBtn = this._container["nextBtn"];
         this._prevBtn = this._container["prevBtn"];
         this._nextBtn2 = this._container["nextBtn2"];
         this._prevBtn2 = this._container["prevBtn2"];
         DisplayObjectUtil.disableButton(this._prevBtn2);
      }
      
      override protected function createSkillVec() : void {
         var cell:BaseSkillCell = null;
         var padding:int = 150;
         this._normalSkillCellVec = new Vector.<BaseSkillCell>();
         for(var i:int = 0; i < this.MAX_NUM; ++i) {
            cell = new NoramlSkillCell();
            cell.x = 90 + padding * i;
            cell.y = 45;
            this.addChild(cell);
            this._normalSkillCellVec.push(cell);
         }
         this._criticalSkillCell = new CriticalSkillCell();
         this._criticalSkillCell.x = 734;
         this._criticalSkillCell.y = 45;
         this.addChild(_criticalSkillCell);
         this._criticalSkillCell2 = new CriticalSkillCell();
         this._criticalSkillCell2.x = 734;
         this._criticalSkillCell2.y = 45;
         this.addChild(_criticalSkillCell2);
         this._criticalSkillCell2.visible = false;
      }
      
      public function criticalSkillIsEmpty() : Boolean {
         return _criticalSkillCell.skillInfo == null;
      }
      
      override protected function initEventListener() : void {
         super.initEventListener();
         this._prevBtn.addEventListener("click",this.onPrevBtnClick);
         this._nextBtn.addEventListener("click",this.onNextBtnClick);
         this._prevBtn2.addEventListener("click",this.onBtn2Click);
         this._nextBtn2.addEventListener("click",this.onBtn2Click);
      }
      
      private function onPrevBtnClick(evt:MouseEvent) : void {
         --this._offset;
         this.updateDisplay();
      }
      
      private function onNextBtnClick(evt:MouseEvent) : void {
         ++this._offset;
         this.updateDisplay();
      }
      
      public function changePetInfoData(info:PetInfo) : void {
         this._petInfo = info;
         super.reset();
         this.updateData();
         this.updateDisplay();
      }
      
      override protected function reset() : void {
         super.reset();
         this._offset = 0;
         this._isShow = false;
      }
      
      override protected function updateData() : void {
         this.updateSkillInfo(this._petInfo.skillInfo.candidateSkillInfoVec);
         this.updateHideSkillInfo();
      }
      
      private function updateHideSkillInfo() : void {
         var skillInfo:SkillInfo = null;
         var petSkillInfo:SkillInfo = null;
         this._hideNormalSkillInfoVec = new Vector.<SkillInfo>();
         this._hideCriticalSkillInfo = null;
         this._hideCriticalSkillInfo2 = null;
         if(_petInfo.level < 60 || (PetUtil.getMaxStatusPet(this._petInfo.bunchId).resId != this._petInfo.resourceId && !HideSkillCheck.checkHasHideSkill(this._petInfo.resourceId))) {
            return;
         }
         var skillInfoVec:Vector.<SkillInfo> = this.getNotGainedHideSkillInfoVec();
         for each(skillInfo in skillInfoVec) {
            if(skillInfo.isCritical) {
               if(this._hideCriticalSkillInfo == null) {
                  if(this._criticalSkillCell.skillInfo != null && this._criticalSkillCell.skillInfo.id == skillInfo.id) {
                     this._hideCriticalSkillInfo = skillInfo;
                  }
                  else if(this._criticalSkillCell.skillInfo == null) {
                     this._hideCriticalSkillInfo = skillInfo;
                  }
                  else {
                     this._hideCriticalSkillInfo2 = skillInfo;
                  }
               }
               else {
                  this._hideCriticalSkillInfo2 = skillInfo;
               }
            }
            else {
               this._hideNormalSkillInfoVec.push(skillInfo);
            }
         }
         for each(petSkillInfo in _petInfo.skillInfo.candidateSkillInfoVec) {
            if(petSkillInfo.isIntercourse) {
               if(this._hideCriticalSkillInfo == null) {
                  if(this._criticalSkillCell.skillInfo != null && this._criticalSkillCell.skillInfo.id == petSkillInfo.id) {
                     this._hideCriticalSkillInfo = petSkillInfo;
                  }
                  else if(this._criticalSkillCell.skillInfo == null) {
                     this._hideCriticalSkillInfo = petSkillInfo;
                  }
                  else {
                     this._hideCriticalSkillInfo2 = petSkillInfo;
                  }
               }
               else {
                  this._hideCriticalSkillInfo2 = petSkillInfo;
               }
               return;
            }
         }
         for each(petSkillInfo in this._petInfo.skillInfo.candidateSkillInfoVec) {
            if(petSkillInfo.isCritical) {
               if(this._hideCriticalSkillInfo == null) {
                  if(this._criticalSkillCell.skillInfo != null && this._criticalSkillCell.skillInfo.id == petSkillInfo.id) {
                     this._hideCriticalSkillInfo = petSkillInfo;
                  }
                  else if(this._criticalSkillCell.skillInfo == null) {
                     this._hideCriticalSkillInfo = petSkillInfo;
                  }
                  else {
                     this._hideCriticalSkillInfo2 = petSkillInfo;
                  }
               }
               else {
                  this._hideCriticalSkillInfo2 = petSkillInfo;
               }
               return;
            }
         }
      }
      
      private function getNotGainedHideSkillInfoVec() : Vector.<SkillInfo> {
         var petSkillSetting:PetSkillSettingDefinition = null;
         var skillInfo:SkillInfo = null;
         var hideSkillInfoVec:Vector.<SkillInfo> = new Vector.<SkillInfo>();
         var petSettingSkillVec:Vector.<PetSkillSettingDefinition> = PetConfig.getPetSkillSettingDefinitionVec(this._petInfo.getPetDefinition().bunchId);
         petSettingSkillVec = HideSkillCheck.hideSkillCoveredRepair(this._petInfo.resourceId,petSettingSkillVec);
         for each(petSkillSetting in petSettingSkillVec) {
            if(petSkillSetting.learningLv > 100) {
               skillInfo = new SkillInfo(petSkillSetting.id);
               skillInfo.isHideSkill = true;
               hideSkillInfoVec.push(skillInfo);
            }
         }
         return hideSkillInfoVec.filter(this.filterSkillByNotGained);
      }
      
      private function filterSkillByNotGained(skillInfo:SkillInfo, index:int, skillInfoVec:Vector.<SkillInfo>) : Boolean {
         var petSkillInfo:SkillInfo = null;
         var candidateSkillInfo:SkillInfo = null;
         for each(petSkillInfo in _petInfo.skillInfo.skillInfoVec) {
            if(petSkillInfo.id == skillInfo.id) {
               return false;
            }
         }
         for each(candidateSkillInfo in _petInfo.skillInfo.candidateSkillInfoVec) {
            if(candidateSkillInfo.id == skillInfo.id) {
               return false;
            }
         }
         return true;
      }
      
      private function skillFilter() : void {
         //屏蔽已有技能，某些精灵出现有两个同名但效果不同的技能，屏蔽掉无效的那个
         var resList:Array = [963,975,980,986,726,950,951,770,771,982,983,813,777,668,716,769,703,703,703,703,703,703,703,703,703,955,560,560,560,560];
         var skillList:Array = [17163,16077,16079,16078,11618,11618,11618,11619,11619,11619,11619,16095,15774,14638,15233,15697,12893,12894,12895,12897,12900,12901,12903,12905,12907,12908,11697,11698,11700,11701];
         for(var i:int = 0; i < resList.length; ++i) {
            if(this._petInfo.resourceId == resList[i]) {
               j = 0;
               for(var j:int = 0; j < this._normalSkillInfoVec.length; ++j) {
                  if(this._normalSkillInfoVec[j].id == skillList[i]) {
                     this._normalSkillInfoVec.splice(j,1);
                  }
               }
            }
         }
         for(i = 0; i < this._hideNormalSkillInfoVec.length; ++i) {
            if(!HideSkillCheck.checkSkillHideable(this._petInfo.resourceId,this._hideNormalSkillInfoVec[i].id)) {
               this._hideNormalSkillInfoVec.splice(i,1);
            }
         }
         if(this._hideCriticalSkillInfo2 != null && !HideSkillCheck.checkSkillHideable(_petInfo.resourceId,this._hideCriticalSkillInfo2.id)) {
            this._hideCriticalSkillInfo2 = null;
         }
         if(this._hideCriticalSkillInfo != null && !HideSkillCheck.checkSkillHideable(_petInfo.resourceId,this._hideCriticalSkillInfo.id)) {
            this._hideCriticalSkillInfo = null;
            if(this._hideCriticalSkillInfo2 != null) {
               this._hideCriticalSkillInfo = this._hideCriticalSkillInfo2;
               this._hideCriticalSkillInfo2 = null;
            }
         }
         for(i = 0; i < resList.length; ++i) {
            if(_petInfo.resourceId == resList[i]) {
               if(_criticalSkillInfo != null && _criticalSkillInfo.id == skillList[i]) {
                  _criticalSkillInfo = null;
               }
            }
         }
      }
      
      override protected function updateDisplay() : void {
         var skill:SkillInfo = null;
         var infoIndex:int = 0;
         var skillCell:BaseSkillCell = null;
         var normalSkillIndex:* = 0;
         var hideSkillIndex:int = 0;
         this.skillFilter();
         var noramlSkillLength:int = int(_normalSkillInfoVec.length);
         var hideSkillLength:int = int(this._hideNormalSkillInfoVec.length);
         var i:int = 0;
         while(i < this.MAX_NUM) {
            infoIndex = this._offset + i;
            skillCell = _normalSkillCellVec[i];
            if(infoIndex < noramlSkillLength) {
               normalSkillIndex = infoIndex;
               skill = _normalSkillInfoVec[normalSkillIndex];
               trace("已学会技能:" + skill.name);
               skillCell.setSkillCellData(skill,true);
            }
            else if(infoIndex < noramlSkillLength + hideSkillLength) {
               hideSkillIndex = infoIndex - noramlSkillLength;
               skill = this._hideNormalSkillInfoVec[hideSkillIndex];
               trace("隐藏技能:" + skill.name);
               skillCell.setSkillCellData(skill,false);
            }
            else {
               skillCell.setSkillCellData(null);
            }
            i++;
         }
         if(_criticalSkillInfo == null) {
            if(this._hideCriticalSkillInfo != null) {
               _criticalSkillCell.setSkillCellData(this._hideCriticalSkillInfo,false);
            }
            else if(_criticalSkillInfo2 != null) {
               _criticalSkillCell.setSkillCellData(_criticalSkillInfo2,true);
               _criticalSkillInfo2 = null;
               _criticalSkillCell.visible = true;
               _criticalSkillCell2.visible = false;
               DisplayObjectUtil.disableButton(this._container["nextBtn2"]);
               DisplayObjectUtil.disableButton(this._container["prevBtn2"]);
            }
            else if(_hideCriticalSkillInfo2 != null) {
               _criticalSkillCell.setSkillCellData(this._hideCriticalSkillInfo2,false);
               _hideCriticalSkillInfo2 = null;
               _criticalSkillCell.visible = true;
               _criticalSkillCell2.visible = false;
               DisplayObjectUtil.disableButton(this._container["nextBtn2"]);
               DisplayObjectUtil.disableButton(this._container["prevBtn2"]);
            }
            else {
               _criticalSkillCell.setSkillCellData(null);
            }
         }
         else {
            _criticalSkillCell.setSkillCellData(_criticalSkillInfo,true);
         }
         if(_criticalSkillInfo2 == null) {
            if(this._hideCriticalSkillInfo2 != null) {
               _criticalSkillCell2.setSkillCellData(this._hideCriticalSkillInfo2,false);
               if(_criticalSkillCell.visible) {
                  DisplayObjectUtil.enableButton(this._container["nextBtn2"]);
                  DisplayObjectUtil.disableButton(this._container["prevBtn2"]);
               }
               else {
                  DisplayObjectUtil.disableButton(this._container["nextBtn2"]);
                  DisplayObjectUtil.enableButton(this._container["prevBtn2"]);
               }
            }
            else {
               _criticalSkillCell2.setSkillCellData(null);
               _criticalSkillCell.visible = true;
               _criticalSkillCell2.visible = false;
               DisplayObjectUtil.disableButton(this._container["nextBtn2"]);
               DisplayObjectUtil.disableButton(this._container["prevBtn2"]);
            }
         }
         else {
            _criticalSkillCell2.setSkillCellData(_criticalSkillInfo2,true);
            if(_criticalSkillCell.visible) {
               DisplayObjectUtil.enableButton(this._container["nextBtn2"]);
               DisplayObjectUtil.disableButton(this._container["prevBtn2"]);
            }
            else {
               DisplayObjectUtil.disableButton(this._container["nextBtn2"]);
               DisplayObjectUtil.enableButton(this._container["prevBtn2"]);
            }
         }
         DisplayObjectUtil.enableButton(this._prevBtn);
         DisplayObjectUtil.enableButton(this._nextBtn);
         if(this._offset == 0) {
            DisplayObjectUtil.disableButton(this._prevBtn);
         }
         if(this._offset + this.MAX_NUM >= this._normalSkillInfoVec.length + this._hideNormalSkillInfoVec.length) {
            DisplayObjectUtil.disableButton(this._nextBtn);
         }
      }
      
      private function onBtn2Click(e:MouseEvent) : void {
         if(!_criticalSkillCell.visible) {
            _criticalSkillCell.visible = true;
            _criticalSkillCell2.visible = false;
            DisplayObjectUtil.disableButton(this._container["prevBtn2"]);
            DisplayObjectUtil.enableButton(this._container["nextBtn2"]);
         }
         else {
            _criticalSkillCell.visible = false;
            _criticalSkillCell2.visible = true;
            DisplayObjectUtil.enableButton(this._container["prevBtn2"]);
            DisplayObjectUtil.disableButton(this._container["nextBtn2"]);
         }
      }
   }
}
