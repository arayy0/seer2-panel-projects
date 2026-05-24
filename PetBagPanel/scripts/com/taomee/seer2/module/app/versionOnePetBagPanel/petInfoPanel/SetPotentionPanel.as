package com.taomee.seer2.module.app.versionOnePetBagPanel.petInfoPanel
{
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.event.LogicEvent;
   import com.taomee.seer2.app.guide.manager.GuideManager;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.pet.events.PetInfoEvent;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.processor.quest.handler.main.quest99.QuestMapHandler_99_80491;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.events.ModelLocator;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.module.app.petBag.helper.PetBagLearningPointHelper;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.PetInfoPanel;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public class SetPotentionPanel extends Sprite
   {
       
      
      private var _mainUI:MovieClip;
      
      private var _onClose:SimpleButton;
      
      private var _introduceTxt:TextField;
      
      private var _barList:Vector.<MovieClip>;
      
      private var _reduceBtnList:Vector.<SimpleButton>;
      
      private var _addBtnList:Vector.<SimpleButton>;
      
      private var _valTxtList:Vector.<TextField>;
      
      private var _leftPointTxt:TextField;
      
      private var _setBtn:SimpleButton;
      
      private var _sureBtn:SimpleButton;
      
      private var _setPropUIList:Vector.<MovieClip>;
      
      private var _setPropValList:Vector.<TextField>;
      
      private var _addPointList:Vector.<TextField>;
      
      private const WHOLE_LEARNING_POINT_MAX:int = 510;
      
      private const MAX_NUM:int = 6;
      
      private const CHANGE_VALUE:int = 1;
      
      private const CHANGE_VALUE_CONTINUOUS:int = 10;
      
      private const LEARNING_POINT_MAX:int = 255;
      
      private const DOWN_INTERVAL:int = 200;
      
      private var _petInfo:PetInfo;
      
      private var _hasUsedPoint:uint;
      
      private var _unusedLearningPoint:uint;
      
      private var _propMaxVal:Vector.<int>;
      
      private var _propRealVal:Vector.<int>;
      
      private var _originalAbilityValueVec:Vector.<int>;
      
      private var _originalLearingPointVec:Vector.<int>;
      
      private var _changedLearningPointVec:Vector.<int>;
      
      private var _thisParent:PetInfoPanel;
      
      public function SetPotentionPanel(thisParent:PetInfoPanel)
      {
         super();
         this._thisParent = thisParent;
         this.initSet();
         this.initEvent();
      }
      
      private function initSet() : void
      {
         var i:int = 0;
         this._mainUI = new SetPotentionUI();
         addChild(this._mainUI);
         this._mainUI.x = 760;
         this._mainUI.y = 20;
         this._onClose = this._mainUI["onClose"];
         this._introduceTxt = this._mainUI["introduceTxt"];
         this._barList = new Vector.<MovieClip>();
         this._reduceBtnList = new Vector.<SimpleButton>();
         this._addBtnList = new Vector.<SimpleButton>();
         this._valTxtList = new Vector.<TextField>();
         this._setPropUIList = new Vector.<MovieClip>();
         this._setPropValList = new Vector.<TextField>();
         this._addPointList = new Vector.<TextField>();
         for(i = 0; i < 6; )
         {
            this._barList.push(this._mainUI["bar" + i]);
            this._reduceBtnList.push(this._mainUI["reduceBtn" + i]);
            this._addBtnList.push(this._mainUI["addBtn" + i]);
            this._valTxtList.push(this._mainUI["valTxt" + i]);
            this._addPointList.push(this._mainUI["addPoint" + i]);
            this._setPropUIList.push(this._mainUI["setPropUI" + i]);
            this._setPropValList.push(this._setPropUIList[i]["setPropVal"] as TextField);
            this._setPropValList[i].maxChars = 3;
            this._setPropValList[i].restrict = "0-9";
            this._setPropValList[i].addEventListener("keyDown",this.onKeyClick);
            this._setPropValList[i].addEventListener("keyUp",this.onKeyClick);
            i++;
         }
         this._leftPointTxt = this._mainUI["leftPointTxt"];
         this._setBtn = this._mainUI["setBtn"];
         this._sureBtn = this._mainUI["sureBtn"];
         this._sureBtn.visible = false;
      }
      
      private function onKeyClick(evt:KeyboardEvent) : void
      {
         var index:int = this._setPropValList.indexOf(evt.currentTarget as TextField);
         if(int(this._setPropValList[index].text) == 0)
         {
            this._setPropValList[index].text = "";
         }
         this.updateLearningPointToCell(int(this._setPropValList[index].text),index);
      }
      
      private function initEvent() : void
      {
         var item:SimpleButton = null;
         var item1:SimpleButton = null;
         this._onClose.addEventListener("click",this.onCloseBtn);
         this._setBtn.addEventListener("click",this.onSetBtn);
         this._sureBtn.addEventListener("click",this.onSureBtn);
         for each(item in this._addBtnList)
         {
            item.addEventListener("click",this.onAddClick);
         }
         for each(item1 in this._reduceBtnList)
         {
            item1.addEventListener("click",this.onReduceClick);
         }
      }
      
      private function setPropUIListVisible(val:Boolean) : void
      {
         var item:MovieClip = null;
         for each(item in this._setPropUIList)
         {
            item.visible = val;
         }
      }
      
      private function setAddPointListVisible(val:Boolean) : void
      {
         var item:TextField = null;
         for each(item in this._addPointList)
         {
            item.visible = val;
         }
      }
      
      private function onReduceClick(evt:MouseEvent) : void
      {
         var index:int = this._reduceBtnList.indexOf(evt.currentTarget as SimpleButton);
         if(int(this._setPropValList[index].text) <= 0)
         {
            return;
         }
         this._setPropValList[index].text = (int(this._setPropValList[index].text) - 1).toString();
         this.updateLearningPointToCell(int(this._setPropValList[index].text),index);
      }
      
      private function reduceLearningPointToCell(changeValue:int, index:int) : void
      {
         var validChage:* = 0;
         if(this._changedLearningPointVec[index] - changeValue >= this._originalLearingPointVec[index])
         {
            validChage = changeValue;
         }
         else
         {
            validChage = this._changedLearningPointVec[index] - this._originalLearingPointVec[index];
         }
         var _loc4_:* = index;
         var _loc5_:* = this._changedLearningPointVec[_loc4_] - validChage;
         this._changedLearningPointVec[_loc4_] = _loc5_;
         this._unusedLearningPoint += validChage;
         this.updateAddPointTxt(index);
         this.updateLearningPoolText();
         this.updateBarListShow();
      }
      
      private function onSetBtn(evt:MouseEvent) : void
      {
         if(Boolean(QuestManager.isAccepted(99)) && !QuestManager.isStepComplete(99,6) && Boolean(QuestMapHandler_99_80491.isClickQuest99_6))
         {
            GuideManager.instance.pause();
            this._setBtn.visible = false;
            this._sureBtn.visible = true;
            this.setAddPointListVisible(false);
            this.setPropUIListVisible(true);
            this.setActBtnsVisble(true);
            this.setPointBtnEnable(true,0);
            this.setPointBtnEnable(true,1);
            this.onGuideNext1();
            return;
         }
         if(this._unusedLearningPoint == 0)
         {
            AlertManager.showAlert("当前没有可分配的学习力哦!");
            return;
         }
         this._setBtn.visible = false;
         this._sureBtn.visible = true;
         this.setAddPointListVisible(false);
         this.setPropUIListVisible(true);
         this.setActBtnsVisble(true);
         this.setPointBtnEnable(true,0);
         this.setPointBtnEnable(true,1);
      }
      
      private function setPointBtnEnable(val:Boolean, type:int) : void
      {
         var item:SimpleButton = null;
         var item1:SimpleButton = null;
         if(type == 0)
         {
            for each(item in this._addBtnList)
            {
               if(val)
               {
                  DisplayObjectUtil.enableButton(item);
               }
               else
               {
                  DisplayObjectUtil.disableButton(item);
               }
            }
         }
         else
         {
            for each(item1 in this._reduceBtnList)
            {
               if(val)
               {
                  DisplayObjectUtil.enableButton(item1);
               }
               else
               {
                  DisplayObjectUtil.disableButton(item1);
               }
            }
         }
      }
      
      private function updateLearningPointToCell(changeValue:int, index:int) : void
      {
         var changedLearningPoint:int = 0;
         var validChangeValue:int = 0;
         var validChage:int = 0;
         if(changeValue > this._changedLearningPointVec[index] - this._originalLearingPointVec[index])
         {
            changedLearningPoint = this._changedLearningPointVec[index];
            validChangeValue = changeValue - (this._changedLearningPointVec[index] - this._originalLearingPointVec[index]);
            if(this._unusedLearningPoint - validChangeValue < 0)
            {
               validChangeValue = int(this._unusedLearningPoint);
            }
            if(validChangeValue + changedLearningPoint > 255)
            {
               validChangeValue = 255 - changedLearningPoint;
            }
            this._unusedLearningPoint -= validChangeValue;
            this._changedLearningPointVec[index] += validChangeValue;
            this._setPropValList[index].text = (this._changedLearningPointVec[index] - this._originalLearingPointVec[index]).toString();
            this.updateLearningPoolText();
            this.updateBarListShow();
         }
         if(changeValue < this._changedLearningPointVec[index] - this._originalLearingPointVec[index])
         {
            validChage = this._changedLearningPointVec[index] - this._originalLearingPointVec[index] - changeValue;
            this._changedLearningPointVec[index] -= validChage;
            this._unusedLearningPoint += validChage;
            this._setPropValList[index].text = (this._changedLearningPointVec[index] - this._originalLearingPointVec[index]).toString();
            this.updateLearningPoolText();
            this.updateBarListShow();
         }
      }
      
      private function updateAddPointTxt(index:int) : void
      {
         this._addPointList[index].text = "+" + this._changedLearningPointVec[index];
      }
      
      private function onCloseBtn(evt:MouseEvent) : void
      {
         this._thisParent.changePanelShow(0);
      }
      
      private function hide() : void
      {
         DisplayObjectUtil.removeFromParent(this);
      }
      
      private function onAddClick(evt:MouseEvent) : void
      {
         var index:int = this._addBtnList.indexOf(evt.currentTarget as SimpleButton);
         this.onGuideNext2();
         if(this._unusedLearningPoint <= 0)
         {
            return;
         }
         this._setPropValList[index].text = (int(this._setPropValList[index].text) + 1).toString();
         this.updateLearningPointToCell(int(this._setPropValList[index].text),index);
      }
      
      private function onSureBtn(evt:MouseEvent) : void
      {
         if(Boolean(QuestManager.isAccepted(99)) && !QuestManager.isStepComplete(99,6) && Boolean(QuestMapHandler_99_80491.isClickQuest99_6))
         {
            this.onGuideNext3();
            return;
         }
         AlertManager.showConfirm("你确定要这样分配精灵学习力吗？",function():void
         {
            if(PetBagLearningPointHelper.canChangeLearningPointSvr(_changedLearningPointVec,_originalLearingPointVec))
            {
               DisplayObjectUtil.disableSprite(this as Sprite);
               PetInfoManager.addEventListener("petPropertiesChange",onPetPropertiesChange);
               PetBagLearningPointHelper.changeLearningPointSvr(_petInfo.catchTime,_changedLearningPointVec,_originalLearingPointVec);
            }
            else
            {
               AlertManager.showAlert("你当前没有分配学习力哦!");
            }
         });
      }
      
      private function onPetPropertiesChange(evt:PetInfoEvent) : void
      {
         if(evt.info.catchTime == this._petInfo.catchTime)
         {
            this.setData(evt.info);
         }
      }
      
      public function setData(value:PetInfo) : void
      {
         var item:SimpleButton = null;
         this.clear();
         this._petInfo = value;
         this.updateData();
         this.updateDisplay();
         this.resetButtons();
         this.setAddPointListVisible(true);
         this.setActBtnsVisble(false);
         if(Boolean(QuestManager.isAccepted(99)) && !QuestManager.isStepComplete(99,6) && Boolean(QuestMapHandler_99_80491.isClickQuest99_6))
         {
            this.setActBtnsVisble(true);
            for each(item in this._addBtnList)
            {
               DisplayObjectUtil.enableButton(item);
            }
         }
      }
      
      private function setActBtnsVisble(val:Boolean) : void
      {
         var item:SimpleButton = null;
         var item1:SimpleButton = null;
         for each(item in this._addBtnList)
         {
            item.visible = val;
         }
         for each(item1 in this._reduceBtnList)
         {
            item1.visible = val;
         }
      }
      
      private function clear() : void
      {
         PetInfoManager.removeEventListener("petPropertiesChange",this.onPetPropertiesChange);
         DisplayObjectUtil.enableSprite(this);
         this._hasUsedPoint = 0;
         this._petInfo = null;
      }
      
      private function updateData() : void
      {
         if(Boolean(this._petInfo) && Boolean(this._petInfo.learningInfo))
         {
            this._unusedLearningPoint = this._petInfo.learningInfo.pointUnused;
         }
         this.updateAbilityValue();
         this.updateLearningPoint();
      }
      
      private function updateAbilityValue() : void
      {
         this._originalAbilityValueVec = new Vector.<int>();
         this._originalAbilityValueVec.push(this._petInfo.atk);
         this._originalAbilityValueVec.push(this._petInfo.defence);
         this._originalAbilityValueVec.push(this._petInfo.specialAtk);
         this._originalAbilityValueVec.push(this._petInfo.specialDefence);
         this._originalAbilityValueVec.push(this._petInfo.speed);
         this._originalAbilityValueVec.push(this._petInfo.maxHp);
      }
      
      private function updateLearningPoint() : void
      {
         this._originalLearingPointVec = new Vector.<int>();
         this._originalLearingPointVec.push(this._petInfo.learningInfo.pointAtk);
         this._originalLearingPointVec.push(this._petInfo.learningInfo.pointDefence);
         this._originalLearingPointVec.push(this._petInfo.learningInfo.pointSpecialAtk);
         this._originalLearingPointVec.push(this._petInfo.learningInfo.pointSpecialDefence);
         this._originalLearingPointVec.push(this._petInfo.learningInfo.pointSpeed);
         this._originalLearingPointVec.push(this._petInfo.learningInfo.pointHp);
         this._changedLearningPointVec = this._originalLearingPointVec.slice();
      }
      
      private function updateDisplay() : void
      {
         this.updateLearningPoolText();
         this.updateBarListShow();
         this.newGuideShow();
      }
      
      private function newGuideShow() : void
      {
         var rect:Rectangle = null;
         if(Boolean(QuestManager.isAccepted(99)) && !QuestManager.isStepComplete(99,6) && Boolean(QuestMapHandler_99_80491.isClickQuest99_6))
         {
            GuideManager.instance.close();
            rect = new Rectangle(0,0,73,31);
            GuideManager.instance.addTarget(rect,0);
            GuideManager.instance.addGuide2Target(rect,0,25,new Point(924,479),false,false,9,false,true,false,990,560);
            GuideManager.instance.startGuide(25);
         }
      }
      
      private function onGuideNext1() : void
      {
         var rect:Rectangle = null;
         if(Boolean(QuestManager.isAccepted(99)) && !QuestManager.isStepComplete(99,6) && Boolean(QuestMapHandler_99_80491.isClickQuest99_6))
         {
            GuideManager.instance.pause();
            rect = new Rectangle(0,0,24,24);
            GuideManager.instance.addTarget(rect,0);
            GuideManager.instance.addGuide2Target(rect,0,23,new Point(973,325),false,false,9,false,true,false,990,560);
            GuideManager.instance.startGuide(23);
         }
      }
      
      private function onGuideNext2() : void
      {
         var rect:Rectangle = null;
         if(Boolean(QuestManager.isAccepted(99)) && !QuestManager.isStepComplete(99,6) && Boolean(QuestMapHandler_99_80491.isClickQuest99_6))
         {
            GuideManager.instance.pause();
            rect = new Rectangle(0,0,73,31);
            GuideManager.instance.addTarget(rect,0);
            GuideManager.instance.addGuide2Target(rect,0,24,new Point(924,479),false,false,9,false,true,false,990,560);
            GuideManager.instance.startGuide(24);
         }
      }
      
      private function onGuideNext3() : void
      {
         GuideManager.instance.close();
         ModuleManager.closeForName("PetBagPanel");
         ModelLocator.getInstance().dispatchEvent(new LogicEvent("newGuideBroad8"));
      }
      
      private function updateLearningPoolText() : void
      {
         this._leftPointTxt.text = String(this._unusedLearningPoint);
      }
      
      private function updateIntroduce() : void
      {
         var _recommandCharacterStr:String = String(PetConfig.getPetDefinition(this._petInfo.resourceId).charaPoint);
         if(Boolean(_recommandCharacterStr) && _recommandCharacterStr != "")
         {
            this._introduceTxt.text = _recommandCharacterStr;
         }
         else
         {
            this._introduceTxt.text = "";
         }
      }
      
      private function updateBarListShow() : void
      {
         var i:int = 0;
         for(i = 0; i < 6; )
         {
            this._hasUsedPoint += this._originalLearingPointVec[i];
            i++;
         }
         this.setMaxData();
         this.setRealData();
         for(i = 0; i < this._barList.length; )
         {
            this._barList[i].scaleX = this._propRealVal[i] / this._propMaxVal[i];
            this._valTxtList[i].text = this._propRealVal[i] + "/" + this._propMaxVal[i];
            this.updateAddPointTxt(i);
            i++;
         }
      }
      
      private function resetButtons() : void
      {
         this._sureBtn.visible = false;
         this._setBtn.visible = true;
         if(this._hasUsedPoint >= 510)
         {
            DisplayObjectUtil.disableButton(this._setBtn);
         }
         else if(this._unusedLearningPoint > 0)
         {
            DisplayObjectUtil.enableButton(this._setBtn);
         }
         else
         {
            DisplayObjectUtil.disableButton(this._setBtn);
         }
         if(Boolean(QuestManager.isAccepted(99)) && !QuestManager.isStepComplete(99,6) && Boolean(QuestMapHandler_99_80491.isClickQuest99_6))
         {
            DisplayObjectUtil.enableButton(this._setBtn);
         }
         this.setPointBtnEnable(false,0);
         this.setPointBtnEnable(false,1);
         this.clearPointProp();
         this.setPropUIListVisible(false);
      }
      
      private function clearPointProp() : void
      {
         var item:TextField = null;
         for each(item in this._setPropValList)
         {
            item.text = "";
         }
      }
      
      private function setRealData() : void
      {
         this._propRealVal = new Vector.<int>();
         this._propRealVal.push(this.createRealData(this._petInfo.getPetDefinition().atk,this._changedLearningPointVec[0],0));
         this._propRealVal.push(this.createRealData(this._petInfo.getPetDefinition().defence,this._changedLearningPointVec[1],1));
         this._propRealVal.push(this.createRealData(this._petInfo.getPetDefinition().specialAtk,this._changedLearningPointVec[2],2));
         this._propRealVal.push(this.createRealData(this._petInfo.getPetDefinition().specialDefence,this._changedLearningPointVec[3],3));
         this._propRealVal.push(this.createRealData(this._petInfo.getPetDefinition().speed,this._changedLearningPointVec[4],4));
         this._propRealVal.push(this.createRealData(this._petInfo.getPetDefinition().maxHp,this._changedLearningPointVec[5],5));
      }
      
      private function createMaxData(initNumber:int, number:int, index:int) : int
      {
         var com:int = 0;
         if(index != 5)
         {
            com = int(uint(((initNumber * 2 + 120) * 1 + 100 + 10 + 63.75) * 1.1));
         }
         else
         {
            com = int(uint((initNumber * 2 + 120) * 1 + 100 + 10 + 63.75));
         }
         return com;
      }
      
      private function setMaxData() : void
      {
         this._propMaxVal = new Vector.<int>();
         this._propMaxVal.push(this.createMaxData(this._petInfo.getPetDefinition().atk,this._originalLearingPointVec[0],0));
         this._propMaxVal.push(this.createMaxData(this._petInfo.getPetDefinition().defence,this._originalLearingPointVec[1],1));
         this._propMaxVal.push(this.createMaxData(this._petInfo.getPetDefinition().specialAtk,this._originalLearingPointVec[2],2));
         this._propMaxVal.push(this.createMaxData(this._petInfo.getPetDefinition().specialDefence,this._originalLearingPointVec[3],3));
         this._propMaxVal.push(this.createMaxData(this._petInfo.getPetDefinition().speed,this._originalLearingPointVec[4],4));
         this._propMaxVal.push(this.createMaxData(this._petInfo.getPetDefinition().maxHp,this._originalLearingPointVec[5],5));
      }
      
      private function createRealData(initNumber:int, number:int, index:int) : int
      {
         var comInit:int = 0;
         var potentialList:Vector.<int> = Vector.<int>([this._petInfo.potentialAtk,this._petInfo.potentialDef,this._petInfo.potentialSpAtk,this._petInfo.potentialSpDef,this._petInfo.potentialSpeed,this._petInfo.potentialHp]);
         if(index != 5)
         {
            comInit = int(uint(((initNumber * 2 + potentialList[index]) * (this._petInfo.level / 100) + this._petInfo.level + 10 + number / 4) * this._petInfo.characterArr[index]));
         }
         else
         {
            comInit = int(uint((initNumber * 2 + potentialList[index]) * (this._petInfo.level / 100) + this._petInfo.level + 10 + int(number / 4)));
         }
         return comInit;
      }
   }
}
