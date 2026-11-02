package com.taomee.seer2.module.app.versionOnePetBagPanel {
import com.taomee.seer2.app.actor.ActorManager;
import com.taomee.seer2.app.event.LogicEvent;
import com.taomee.seer2.app.manager.StatisticsManager;
import com.taomee.seer2.app.net.CommandSet;
import com.taomee.seer2.app.net.Connection;
import com.taomee.seer2.app.pet.data.PetInfo;
import com.taomee.seer2.app.pet.data.PetInfoHelper;
import com.taomee.seer2.app.pet.data.PetInfoManager;
import com.taomee.seer2.app.pet.events.PetInfoEvent;
import com.taomee.seer2.app.popup.AlertManager;
import com.taomee.seer2.app.processor.quest.handler.main.quest99.QuestMapHandler_99_80491;
import com.taomee.seer2.app.quest.QuestManager;
import com.taomee.seer2.app.serverBuffer.ServerBuffer;
import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
import com.taomee.seer2.app.vip.VipManager;
import com.taomee.seer2.core.module.ModuleManager;
import com.taomee.seer2.core.net.MessageEvent;
import com.taomee.seer2.core.scene.events.ModelLocator;
import com.taomee.seer2.core.utils.URLUtil;
import com.taomee.seer2.module.app.petBag.event.PetBagEvent;
import com.taomee.seer2.module.app.versionOnePetBagPanel.util.PetCell;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;
   
   public class PetListPanel extends Sprite {
      private const MAX_NUM:int = 12;
      private var _guideUI:MovieClip;
      private var _newGuideMc:MovieClip;
      private var _newGuideMc1:MovieClip;
      private var _petCellVec:Vector.<PetCell>;
      private var _petInfoVec:Vector.<PetInfo>;
      private var _selectedPetInfo:PetInfo;
      
      public function PetListPanel() {
         super();
         this.initSet();
      }
      
      private function initSet() : void {
         var cell:PetCell = null;
         this._guideUI = new PetListGuideUI();
         this._newGuideMc = this._guideUI["newGuideMc"];
         this._newGuideMc.visible = false;
         this._newGuideMc1 = this._guideUI["newGuideMc1"];
         this._newGuideMc1.visible = false;
         this._petCellVec = new Vector.<PetCell>();
         for(var i:int = 0; i < 12; ++i) {
            if(i <= 5) {
               if(i == 0) {
                  cell = new PetCell(new PetCellResUI(),false,"first");
               }
               else {
                  cell = new PetCell(new PetCellResUI(),false,"fight");
               }
               cell.x = 39 + (i % 2) * 100;
               cell.y = 20 + int(i / 2) * 95;
            }
            else {
               cell = new PetCell(new PetCellResUI(),false,"select");
               if(VipManager.vipInfo.level >= i - 6 && VipManager.vipInfo.leftDay > 0 || i <= 6) {
                  cell.openStateMC.visible = false;
               }
               else {
                  cell.openStateMC.visible = true;
                  cell.openStateMC.gotoAndStop(i - 6);
               }
               cell.scaleX = cell.scaleY = 0.7;
               if(i % 3 == 0) {
                  cell.x = 36;
               }
               else if(i % 3 == 1) {
                  cell.x = 101;
               }
               else {
                  cell.x = 166;
               }
               cell.y = 305 + int((i - 6) / 3) * 65;
            }
            this.addChild(cell);
            this._petCellVec.push(cell);
         }
      }
      
      private function addPetInfoEventListener() : void {
         PetInfoManager.addEventListener("petPropertiesChange",this.onPetPropetiesChange);
      }
      
      private function removePetInfoEventListener() : void {
         PetInfoManager.removeEventListener("petPropertiesChange",this.onPetPropetiesChange);
      }
      
      private function onPetPropetiesChange(evt:PetInfoEvent) : void {
         var cell:PetCell = null;
         var i:uint = 0;
         while(i < this._petCellVec.length) {
            cell = this._petCellVec[i];
            if(cell.petInfo == evt.info) {
               cell.setPetInfo(evt.info);
               this._petInfoVec[i] = evt.info;
               break;
            }
            i++;
         }
      }
      
      private function sortPetInfoVec() : void {
         var petInfo:PetInfo = null;
         var len:int = int(this._petInfoVec.length);
         var i:int = 0;
         while(i < len) {
            petInfo = this._petInfoVec[i];
            if(Boolean(petInfo) && Boolean(petInfo.isStarting)) {
               this._petInfoVec.splice(i,1);
               this._petInfoVec.unshift(petInfo);
               break;
            }
            i++;
         }
      }
      
      private function addCellEventListener(cell:PetCell) : void {
         cell.buttonMode = true;
         cell.addEventListener("click",this.onCellClick);
      }
      
      private function removeCellEventListener(cell:PetCell) : void {
         cell.buttonMode = false;
         cell.removeEventListener("click",this.onCellClick);
      }
      
      private function onCellClick(event:MouseEvent) : void {
         var cell:PetCell = event.currentTarget as PetCell;
         var petInfo:PetInfo = cell.petInfo;
         if(this._selectedPetInfo.catchTime != petInfo.catchTime) {
            this.selectedPetInfo = petInfo;
         }
      }
      
      private function clearAllCellEventListener() : void {
         var cell:PetCell = null;
         for each(cell in this._petCellVec) {
            this.removeCellEventListener(cell);
         }
      }
      
      private function updatePetCell() : void {
         var cell:PetCell = null;
         var info:PetInfo = null;
         var i:uint = 0;
         while(i < 12) {
            cell = this._petCellVec[i];
            if(i < this._petInfoVec.length) {
               info = this._petInfoVec[i];
               this.addCellEventListener(cell);
               cell.setPetInfo(info);
            }
            else {
               cell.setPetInfo(null);
            }
            i++;
         }
      }
      
      private function selectPetCell() : void {
         if(this._petInfoVec.length == 0) {
            return;
         }
         this.selectedPetInfo = this._petInfoVec[0];
      }
      
      private function set selectedPetInfo(value:PetInfo) : void {
         var petCell:PetCell = null;
         var petInfo:PetInfo = null;
         this._selectedPetInfo = value;
         var i:int = 0;
         while(i < 12) {
            petCell = this._petCellVec[i];
            petInfo = petCell.petInfo;
            petCell.selected = Boolean(petInfo) && (petInfo.catchTime == this._selectedPetInfo.catchTime);
            i++;
         }
         dispatchEvent(new PetBagEvent("petSelected",this._selectedPetInfo));
      }
      
      public function setData(petInfoVec:Vector.<PetInfo>, petStorageInfoVec:Vector.<PetInfo>) : void {
         this._petInfoVec = new Vector.<PetInfo>;
         var hasPet:Boolean = false;
         var i:int = 0;
         while(i < 6) {
            if(petInfoVec.length > i) {
               this._petInfoVec.push(petInfoVec[i]);
               hasPet = true;
            }
            else {
               this._petInfoVec.push(null);
            }
            i++;
         }
         i = 6;
         while(i < 12) {
            if(Boolean(petStorageInfoVec) && petStorageInfoVec.length > i - 6) {
               this._petInfoVec.push(petStorageInfoVec[i - 6]);
               hasPet = true;
            }
            i++;
         }
         if(hasPet) {
            this.addPetInfoEventListener();
         }
         this.sortPetInfoVec();
         this.updateDisplay();
         this.selectPetCell();
      }
      
      public function updateDisplay() : void {
         this.clearAllCellEventListener();
         this.updatePetCell();
         this.updateGuide();
         this.updateGuide1();
      }
      
      private function updateGuide() : void {
         this._newGuideMc.visible = false;
         if(Boolean(QuestManager.isAccepted(99)) && !QuestManager.isStepComplete(99,3) && Boolean(QuestMapHandler_99_80491.isClickQuest99_3)) {
            this._newGuideMc.visible = true;
            this.addChild(this._newGuideMc);
            this._newGuideMc.removeEventListener("click",this.onGuideClick);
            this._newGuideMc.addEventListener("click",this.onGuideClick);
         }
      }
      
      private function updateGuide1() : void {
         this._newGuideMc1.visible = false;
         if(Boolean(QuestManager.isAccepted(99)) && !QuestManager.isStepComplete(99,6) && Boolean(QuestMapHandler_99_80491.isClickQuest99_6)) {
            this._newGuideMc1.visible = true;
            this.addChild(this._newGuideMc1);
            this._newGuideMc1.removeEventListener("click",this.onGuideClick1);
            this._newGuideMc1.addEventListener("click",this.onGuideClick1);
         }
      }
      
      private function onGuideClick(evt:MouseEvent) : void {
         this._newGuideMc.removeEventListener("click",this.onGuideClick);
         this._newGuideMc.visible = false;
         var targetInfo:PetInfo = this.getPetInfoById(7);
         if(Boolean(targetInfo)) {
            this.selectedPetInfo = targetInfo;
            ModelLocator.getInstance().dispatchEvent(new LogicEvent("newGuideBroad2"));
         }
      }
      
      private function onGuideClick1(evt:MouseEvent) : void {
         this._newGuideMc1.removeEventListener("click",this.onGuideClick1);
         this._newGuideMc1.visible = false;
         var targetInfo:PetInfo = this.getPetInfoById(824);
         if(Boolean(targetInfo)) {
            this.selectedPetInfo = targetInfo;
            ModelLocator.getInstance().dispatchEvent(new LogicEvent("newGuideBroad7"));
         }
      }
      
      private function getPetInfoById(resId:int) : PetInfo {
         var info:PetInfo = null;
         var result:* = null;
         for each(info in PetInfoManager.getAllBagPetInfo()) {
            if(info.resourceId == resId) {
               result = info;
               break;
            }
         }
         return result;
      }
      
      public function reset() : void {
         var len:int = int(this._petCellVec.length);
         var i:int = 0;
         while(i < len) {
            this._petCellVec[i].reset();
            i++;
         }
         this.removePetInfoEventListener();
      }
      
      private function recoverAllPetBagPet() : void {
         function onAddAllPetBlood(event:MessageEvent) : void {
            var petInfo:PetInfo = null;
            Connection.removeCommandListener(CommandSet.TREAT_ALL_PET_1215,onAddAllPetBlood);
            var petInfoVec:Vector.<PetInfo> = PetInfoManager.getAllBagPetInfo();
            for each(petInfo in petInfoVec) {
               petInfo.hp = petInfo.maxHp;
               PetInfoManager.dispatchEvent("petPropertiesChange",petInfo);
            }
            var newCoinNum:int = int(event.message.getRawData().readUnsignedInt());
            ActorManager.actorInfo.coins = newCoinNum;
         }
         Connection.addCommandListener(CommandSet.TREAT_ALL_PET_1215,onAddAllPetBlood);
         Connection.send(CommandSet.TREAT_ALL_PET_1215);
      }

      public function requestAddAllPetBlood(e:MouseEvent = null):void {
         this.recoverAllPetBagPet();
         if (!this._petInfoVec) {
            return;
         }
         var curPetInfo:PetInfo;
         var needCoins:int = 0;
         for (var i:int = 6; i < this._petInfoVec.length; ++i) {
            curPetInfo = this._petInfoVec[i];
            PetInfoManager.requestCurePet(curPetInfo);
            needCoins += int(PetInfoHelper.getCoinsForCure(curPetInfo));
            curPetInfo.hp = curPetInfo.maxHp;
            PetInfoManager.dispatchEvent("petPropertiesChange",curPetInfo);
         }
         ActorManager.actorInfo.coins -= needCoins;
      }
   }
}
