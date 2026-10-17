package com.taomee.seer2.module.app.newPetStorage.view {
import com.taomee.seer2.app.component.PetDemoDisplayer;
import com.taomee.seer2.app.component.PetTypeIcon;
import com.taomee.seer2.app.config.PetConfig;
import com.taomee.seer2.app.config.PetEvolveConfig;
import com.taomee.seer2.app.config.info.PetEvolveStarInfo;
import com.taomee.seer2.app.config.pet.PetDefinition;
import com.taomee.seer2.app.net.CommandSet;
import com.taomee.seer2.app.net.Connection;
import com.taomee.seer2.app.pet.constant.PetCharactarNameMap;
import com.taomee.seer2.app.pet.data.PetInfo;
import com.taomee.seer2.app.pet.data.PetInfoManager;
import com.taomee.seer2.app.popup.AlertManager;
import com.taomee.seer2.app.starMagic.StarMagicIconDisplayer;
import com.taomee.seer2.app.starMagic.StarMagicManager;
import com.taomee.seer2.app.utils.PetUtil;
import com.taomee.seer2.core.manager.TimeManager;
import com.taomee.seer2.core.net.LittleEndianByteArray;
import com.taomee.seer2.core.net.MessageEvent;
import com.taomee.seer2.core.ui.toolTip.TooltipManager;
import com.taomee.seer2.core.utils.DateUtil;
import com.taomee.seer2.core.utils.URLUtil;
import com.taomee.seer2.core.utils.Util;
import com.taomee.seer2.module.app.moduleCommon.PetDecorationIcon;
import com.taomee.seer2.module.app.moduleCommon.PetEmblemIcon;
import com.taomee.seer2.module.app.moduleCommon.PetFeatureIcon;
import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.sampler.pauseSampling;
import flash.utils.setTimeout;
   
   public class PetInfoPanel extends StorageSubView {
      private var _petInfo:PetInfo;
      private var _petDemoDisplayer:PetDemoDisplayer;
      private var _emblemIcon:PetEmblemIcon;
      private var _decorationIcon:PetDecorationIcon;
      private var _icon:Vector.<StarMagicIconDisplayer>;
      private var _typeIcon:PetTypeIcon;
      private var _featureIcon:PetFeatureIcon;
      private var _basePetInfo:PetInfo;
      private const _5StarPetsFreeableList:Array = [503,693,728,734,746,757,787,788,799,800,803,804,827,836,881,892,897,910,913,916,918,939,941,942,946,948,949,950,952,955,957,960,961,965,967,971,972,973,977,982,984,990,991,993,2507,2518,2550,2551,2552,2555,2558,2559,2560];
      private const _under4StarsExtinctPetsList:Array = [618,632,640,902,914,997,2525,2561,2590];
      
      public function PetInfoPanel(ui:MovieClip) {
         super(ui);
         this.moduleData.listenTo("focus_pet",this.onFocusPetChange);
         this.moduleData.listenTo("pet_change_position",this.onPetListChange);
         this.moduleData.listenTo("pet_list",this.onPetListChange);
         this.init();
      }
      
      private function onPetListChange() : void {
         setTimeout(this.onFocusPetChange,200);
      }
      
      private function init() : void {
         var i:int;
         this._petDemoDisplayer = new PetDemoDisplayer();
         this._petDemoDisplayer.scaleX = this._petDemoDisplayer.scaleY = 0.7;
         this._petDemoDisplayer.mouseChildren = false;
         this._petDemoDisplayer.mouseEnabled = false;
         this._ui.addChildAt(this._petDemoDisplayer,0);
         this._ui.addChildAt(this._ui["bg"],0);
         this._ui.addChildAt(this._ui["evolveShadeMc"],0);
         this._petDemoDisplayer.x = 140;
         this._petDemoDisplayer.y = 130;
         this._typeIcon = new PetTypeIcon();
         this._ui.addChild(this._typeIcon);
         this._typeIcon.x = 335;
         this._typeIcon.y = 190;
         this._typeIcon.scaleX = this._typeIcon.scaleY = 0.7;
         this._emblemIcon = new PetEmblemIcon();
         this._ui.addChild(this._emblemIcon);
         this._emblemIcon.x = this._ui["emblem"].x - 15;
         this._emblemIcon.y = this._ui["emblem"].y - 15;
         this._featureIcon = new PetFeatureIcon();
         this._featureIcon.x = 218;
         this._featureIcon.y = 25;
         this._ui.addChild(this._featureIcon);
         this._decorationIcon = new PetDecorationIcon();
         this._ui.addChild(this._decorationIcon);
         this._decorationIcon.x = this._ui["decoration"].x - 15;
         this._decorationIcon.y = this._ui["decoration"].y - 15;
         eventListenerMgr.addEventListener(this._ui,"click",this.onClick);
         this._icon = new Vector.<StarMagicIconDisplayer>();
         for(i = 0; i < 5; ++i){
            this._icon[i] = new StarMagicIconDisplayer(0,0,false);
            this._icon[i].scaleX = this._icon[i].scaleY = 44 / 60;
            this._ui["pet" + i].addChildAt(this._icon[i], 0);
         }
      }
      
      private function onFocusPetChange() : void {
         this._petInfo = moduleData.focusePet;
         this._basePetInfo = this._petInfo;
         if(this._petInfo == null) {
            this._petDemoDisplayer.visible = false;
            return;
         }
         this._petDemoDisplayer.visible = true;
         Connection.removeCommandListener(CommandSet.PET_SIMPLE_INFO_1017,this.onGetPetSimpleInfo);
         if(moduleData.listDataService.isInStorage(this._petInfo.catchTime) || moduleData.listDataService.isInFreeList(this._petInfo.catchTime)) {
            Connection.addCommandListener(CommandSet.PET_SIMPLE_INFO_1017,this.onGetPetSimpleInfo);
            Connection.send(CommandSet.PET_SIMPLE_INFO_1017,this._petInfo.catchTime);
         }
         else {
            this.updateView();
         }
      }
      
      private function onGetPetSimpleInfo(event:MessageEvent) : void {
         Connection.removeCommandListener(CommandSet.PET_SIMPLE_INFO_1017,this.onGetPetSimpleInfo);
         var parser:NewParser_1017 = new NewParser_1017(event.message.getRawData());
         var info:PetInfo = parser.petInfo;
         if(this._petInfo != null && info.catchTime == this._petInfo.catchTime) {
            parser.readData(this._petInfo);
            this.updateView();
         }
      }
      
      private function onClick(e:MouseEvent) : void {
         var message:String = null;
         var btnName:String = String(e.target.name);
         switch(btnName) {
            case "trainingBtn":
               if(this._petInfo.level == 1000) {
                  AlertManager.showAlert("100级的精灵不需要训练");
                  return;
               }
               message = "你确定要把" + this._petInfo.name + "放回小屋训练吗?";
               this.showConfirm(message,function():void {
                  Connection.send(CommandSet.PET_TRAINING_START_1039,_petInfo.catchTime);
               });
               break;
            case "treasureStartBtn":
               break;
            case "releaseBtn":
               this.showConfirm("你确定要放生这只精灵吗？",function():void {
                  if(_petInfo.hasStar){ // hasStar不直接由服务器给出，可能只能手动检查然后设置，这里不一定有用
                     AlertManager.showAlert("精灵装备有星魂，请卸下星魂后再放生");
                  }
                  else if(_petInfo.getPetDefinition().starLevel <= 4) {
                     if(_under4StarsExtinctPetsList.indexOf(_petInfo.resourceId) != -1) {
                        AlertManager.showAlert("绝版精灵，暂不开放放生功能");
                     }
                     else {
                        _petInfo.resourceId = 18;
                        PetUtil.FreePet(_petInfo);
                     }
                  }
                  else
                  {
                     if(_5StarPetsFreeableList.indexOf(_petInfo.resourceId) == -1)
                     {
                        AlertManager.showAlert("贵重精灵，暂不开放放生功能");
                     }
                     else{
                        _petInfo.resourceId = 18;
                        PetUtil.FreePet(_petInfo);
                     }
                  }
               });
               break;
            case "putInBagBtn":
               PetUtil.putPetTobag(this._petInfo);
               break;
            case "putInStorageBtn":
               if(this._petInfo.isInStorageBag) {
                  PetInfoManager.requestAddToStorageFromBagStorage(this._petInfo.catchTime);
               } else if(moduleData.listDataService.isInFreeList(this._petInfo.catchTime)) {
                  var data:LittleEndianByteArray = new LittleEndianByteArray();
                  data.writeUnsignedInt(this._petInfo.catchTime);
                  data.writeUnsignedInt(this._petInfo.resourceId);
                  var putToStorageFlag:uint = 0;
                  data.writeByte(putToStorageFlag);
                  Connection.send(CommandSet.PET_SET_FREE_STATUS_1021,data);
               } else {
                  if(PetInfoManager.getAllBagPetInfo().length <= 1)
                  {
                     AlertManager.showAlert("至少要留一只精灵来保护你");
                     return;
                  }
                  if(this._petInfo.isPetRiding)
                  {
                     AlertManager.showAlert("精灵当前正在骑乘中，请先收回后再放入仓库吧");
                     return;
                  }
                  PetInfoManager.requestAddToStorageFromBag(this._petInfo.catchTime);
               }
         }
      }
      
      private function updateView() : void {
         var shenmohua:Array = null;
         if(this._ui == null) {
            return;
         }
         this._ui["genderMc"].gotoAndStop(this._petInfo.sex + 1);
         this._ui["erDaiMc"].visible = this._petInfo.isTwoPet;
         this._ui["trainingBtn"].visible = false;
         this._ui["treasureStartBtn"].visible = false;
         this._ui["releaseBtn"].visible = false;
         this._ui["putInBagBtn"].visible = false;
         this._ui["putInStorageBtn"].visible = false;
         this._ui["free"].visible = false;
         //判断是否可放生
         //var releaseBtnEnable:Boolean = Boolean(this._petInfo.getPetDefinition().isFreeable);
         var releaseBtnEnable:Boolean = false;
         if(this._petInfo.getPetDefinition().starLevel <= 4 || this._5StarPetsFreeableList.indexOf(this._petInfo.resourceId) != -1) {
            releaseBtnEnable = true;
         }
         Util.setEnabled(this._ui["releaseBtn"],releaseBtnEnable,!releaseBtnEnable);
         if(moduleData.listDataService.isInStorage(this._petInfo.catchTime)) {
            if(this._basePetInfo.freeTime > 0) {
               this.updateFreeTime();
               this._ui["putInStorageBtn"].visible = true;
            }
            else {
               this._ui["trainingBtn"].visible = true;
               this._ui["releaseBtn"].visible = true;
               this._ui["putInBagBtn"].visible = true;
            }
         }
         else if(moduleData.listDataService.isInFreeList(this._petInfo.catchTime)) {
            if(this._basePetInfo.freeTime > 0) {
               this.updateFreeTime();
            }
            this._ui["putInStorageBtn"].visible = true;
         }
         else if(PetInfoManager.getPetInfoFromBag(this._petInfo.catchTime) != null || PetInfoManager.getPetInfoFromBagStorage(this._petInfo.catchTime) != null) {
            this._ui["putInStorageBtn"].visible = true;
         }
         var i:int;
         this._ui["starLevel"].gotoAndStop(this._petInfo.getPetDefinition().starLevel);
         this._typeIcon.type = this._petInfo.type;
         if(this._petInfo.emblemId == 0) {
            this._emblemIcon.visible = false;
            this._ui["emblem"].visible = true;
         }
         else {
            this._emblemIcon.visible = true;
            this._emblemIcon.id = this._petInfo.emblemId;
         }
         if(this._petInfo.decorationId == 0) {
            this._decorationIcon.visible = false;
            this._ui["decoration"].visible = true;
         }
         else {
            this._decorationIcon.visible = true;
            this._decorationIcon.id = this._petInfo.decorationId;
         }
         this._ui["nameTxt"].text = this._petInfo.getPetDefinition().name;
         this._ui["idTxt"].text = this._petInfo.resourceId;
         this._ui["levelTxt"].text = this._petInfo.level;
         //this._ui["leftExpTxt"].text = this.getUpLevelExpStr();
         this._ui["natureTxt"].text = PetCharactarNameMap.getCharactarName(this._petInfo.character);
         this._ui["heightTxt"].text = this._petInfo.physicalHeight + "cm";
         this._ui["weightTxt"].text = this._petInfo.physicalWeight + "kg";
         this._ui["upgradeLevelTxt"].text = this.getUpgradeLevelStr();
         var date:Date = new Date(this._petInfo.catchTime * 1000);
         this._ui["catchTime"].text = date.fullYear + "年" + (date.month + 1) + "月" + date.date + "日";
         var pros:Array = [this._petInfo.atk,this._petInfo.defence,this._petInfo.specialAtk,this._petInfo.specialDefence,this._petInfo.speed,this._petInfo.maxHp];
         for(i = 0; i < pros.length; ++i) {
            this._ui["prop" + i].text = pros[i].toString();
         }
         var xuexili:Array = [this._petInfo.learningInfo.pointAtk,this._petInfo.learningInfo.pointDefence,this._petInfo.learningInfo.pointSpecialAtk,this._petInfo.learningInfo.pointSpecialDefence,this._petInfo.learningInfo.pointSpeed,this._petInfo.learningInfo.pointHp];
         for(i = 0; i < xuexili.length; ++i) {
            this._ui["xuexili" + i].text = xuexili[i].toString();
         }
         var zizhi:Array = [this._petInfo.potentialAtk,this._petInfo.potentialDef,this._petInfo.potentialSpAtk,this._petInfo.potentialSpDef,this._petInfo.potentialSpeed,this._petInfo.potentialHp];
         for(i = 0; i < zizhi.length; ++i) {
            this._ui["zizhi" + i].text = zizhi[i].toString();
         }
         var currentAdd:PetEvolveStarInfo;
         if((currentAdd = PetEvolveConfig.getStarInfo(this._petInfo.evolveLevel)) != null) {
            shenmohua = [currentAdd.Atk,currentAdd.Def,currentAdd.SpAtk,currentAdd.SpDef,currentAdd.Spd,currentAdd.Hp];
            for(i = 0; i < shenmohua.length; ) {
               this._ui["shenmohua" + i].text = "+" + shenmohua[i];
               i++;
            }
         }
         else {
            for(i = 0; i < 6; ++i) {
               this._ui["shenmohua" + i].text = "+0";
            }
         }
         for(i = 0; i < 6; ++i) {
            if(this._petInfo.characterArr[i] == 1) {
               this._ui["abup" + i].gotoAndStop(1);
            }
            else if (this._petInfo.characterArr[i] > 1){
               this._ui["abup" + i].gotoAndStop(2);
            }
            else {
               this._ui["abup" + i].gotoAndStop(3);
            }
         }
         this._petDemoDisplayer.newSetUrl(URLUtil.getPetDemo(this._petInfo.resourceId));
         this.resetPos();
         StarMagicManager.getPetStar(this._petInfo.catchTime,this.resetPos,this.resetPos);
         if(Boolean(this._petInfo.getPetDefinition()) && this._petInfo.getPetDefinition().chgMonId != 0) {
            this._ui["changPetBtn"].visible = true;
            try {
               TooltipManager.addCommonTip(this._ui["changPetBtn"],PetConfig.getPetDefinitionInfo(this._petInfo.resourceId).changeTip);
            }
            catch(e:*) {
            }
         }
         else {
            this._ui["changPetBtn"].visible = false;
         }
         if(Boolean(PetConfig.getPetDefinitionInfo(this._petInfo.resourceId)) && PetConfig.getPetDefinitionInfo(this._petInfo.resourceId).fetter != "") {
            this._ui["fetterMC"].visible = true;
            TooltipManager.addCommonTip(this._ui["fetterMC"],PetConfig.getPetDefinitionInfo(this._petInfo.resourceId).fetter);
         }
         else {
            this._ui["fetterMC"].visible = false;
         }
         this._featureIcon.setFeature(this._petInfo.getPetDefinition().featureId,this._petInfo.getPetDefinition().featureDescription);
         this.setStars();
      }
      
      private function updateFreeTime() : void {
         var currentTime:uint = 0;
         var petFreeSeconds:uint = 0;
         var freeDays:uint = 0;
         if(this._basePetInfo.freeTime > 0) {
            this._ui["free"].visible = true;
            currentTime = uint(TimeManager.getServerTime());
            if(currentTime < this._basePetInfo.freeTime) {
               currentTime = uint(this._basePetInfo.freeTime);
            }
            petFreeSeconds = currentTime - this._basePetInfo.freeTime;
            freeDays = 7 - DateUtil.convertSecondsToDays(petFreeSeconds);
            this._ui["free"]["days"].text = freeDays.toString();
         }
      }
      
      private function setStars() : void {
         var starNum:uint = 0;
         var i:int;
         if(this._petInfo.evolveLevel != 0) {
            starNum = uint(PetEvolveConfig.getStarNum(this._petInfo.evolveLevel));
            for(i = 0; i < 4; ++i) {
               this._ui["star" + i].visible = true;
               if(i < starNum) {
                  if(this._petInfo.evolveLevel <= 4) {
                     this._ui["star" + i].gotoAndStop(2);
                  }
                  else if(this._petInfo.evolveLevel <= 8) {
                     this._ui["star" + i].gotoAndStop(4);
                  }
                  else if(this._petInfo.evolveLevel <= 1004) {
                     this._ui["star" + i].gotoAndStop(6);
                  }
                  else {
                     this._ui["star" + i].gotoAndStop(8);
                  }
               }
               else if(this._petInfo.evolveLevel <= 4) {
                  this._ui["star" + i].gotoAndStop(1);
               }
               else if(this._petInfo.evolveLevel <= 8) {
                  this._ui["star" + i].gotoAndStop(3);
               }
               else if(this._petInfo.evolveLevel <= 1004) {
                  this._ui["star" + i].gotoAndStop(5);
               }
               else {
                  this._ui["star" + i].gotoAndStop(7);
               }
            }
            this._ui.evolveShadeMc.visible = true;
            if(this._petInfo.evolveLevel <= 4) {
               this._ui.evolveShadeMc.gotoAndStop(1);
            }
            else if(this._petInfo.evolveLevel <= 8) {
               this._ui.evolveShadeMc.gotoAndStop(2);
            }
            else if(this._petInfo.evolveLevel <= 1004) {
               this._ui.evolveShadeMc.gotoAndStop(3);
            }
            else {
               this._ui.evolveShadeMc.gotoAndStop(4);
            }
         }
         else {
            this._ui.evolveShadeMc.visible = false;
            for(i = 0; i < 4; ++i) {
               this._ui["star" + i].visible = false;
               this._ui["star" + i].gotoAndStop(1);
            }
         }
      }
      
      private function resetPos() : void {
         var i:int;
         for(i = 0; i < StarMagicManager.petNum; ++i) {
            if(i < StarMagicManager.curPet.length) {
               this._icon[i].updateDateInfo(StarMagicManager.curPet[i]);
            }
            else {
               this._icon[i].updateDateInfo(null);
            }
         }
         this._petInfo.hasStar = Boolean(StarMagicManager.curPet.length > 0);
      }
      
      private function getUpgradeLevelStr() : String {
         var petDefination:PetDefinition = PetConfig.getPetDefinition(this._petInfo.resourceId);
         var upgrageLevel:uint = uint(petDefination.evolvingLv);
         if(upgrageLevel == 0) {
            return "已满";
         }
         return String(petDefination.evolvingLv.toString());
      }

      override public function update() : void {
         this.onFocusPetChange();
      }
      
      override public function destory() : void {
         TooltipManager.remove(this._ui["changPetBtn"]);
         TooltipManager.remove(this._ui["fetterMC"]);
         this._petDemoDisplayer.clearDemo();
         this._petDemoDisplayer = null;
         super.destory();
      }
      
      private function showConfirm(txt:String, callback:Function) : void {
         this._ui.mouseEnabled = false;
         this._ui.mouseChildren = false;
         AlertManager.showConfirm(txt,function():void {
            _ui.mouseEnabled = true;
            _ui.mouseChildren = true;
            callback();
         },function():void {
            _ui.mouseEnabled = true;
            _ui.mouseChildren = true;
         });
      }
   }
}
