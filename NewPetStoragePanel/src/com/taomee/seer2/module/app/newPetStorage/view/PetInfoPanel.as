package com.taomee.seer2.module.app.newPetStorage.view
{
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
   import com.taomee.seer2.module.app.starMagic.StarMagicIcon;
   import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
   import flash.events.EventDispatcher;
   import flash.utils.setTimeout;
   
   public class PetInfoPanel extends StorageSubView
   {
       
      
      private var _petInfo:PetInfo;
      
      private var _petDemoDisplayer:PetDemoDisplayer;
      
      private var _emblemIcon:PetEmblemIcon;
      
      private var _decorationIcon:PetDecorationIcon;
      
      private var _icon:Vector.<StarMagicIcon>;
      
      private var _typeIcon:PetTypeIcon;
      
      private var _featureIcon:PetFeatureIcon;
      
      private var _basePetInfo:PetInfo;
      
      private var _lastUpdateFun:Function;

      private var _5StarPetsFreeableList:Array = [503,693,728,734,746,757,787,788,799,800,803,804,836,881,892,897,910,913,916,918,941,942,949,957,960,967];

      private var _under4StarsExtinctPetsList:Array = [902,914,997,2525,2561,2590];
      
      public function PetInfoPanel(ui:MovieClip)
      {
         super(ui);
         moduleData.listenTo("focus_pet",this.onFocusPetChange);
         moduleData.listenTo("pet_change_position",this.onPetListChange);
         moduleData.listenTo("pet_list",this.onPetListChange);
         this.init();
      }
      
      private function onPetListChange() : void
      {
         setTimeout(this.onFocusPetChange,200);
      }
      
      private function init() : void
      {
         var i:int = 0;
         this._petDemoDisplayer = new PetDemoDisplayer();
         this._petDemoDisplayer.scaleX = this._petDemoDisplayer.scaleY = 0.7;
         this._petDemoDisplayer.mouseChildren = false;
         this._petDemoDisplayer.mouseEnabled = false;
         _ui.addChildAt(this._petDemoDisplayer,0);
         _ui.addChildAt(_ui["bg"],0);
         _ui.addChildAt(_ui["evolveShadeMc"],0);
         this._petDemoDisplayer.x = 100;
         this._petDemoDisplayer.y = 130;
         this._typeIcon = new PetTypeIcon();
         _ui.addChild(this._typeIcon);
         this._typeIcon.x = 260;
         this._typeIcon.y = 186;
         this._typeIcon.scaleX = this._typeIcon.scaleY = 0.7;
         this._emblemIcon = new PetEmblemIcon();
         _ui["emblem"].addChild(this._emblemIcon);
         this._emblemIcon.x = -15;
         this._emblemIcon.y = -15;
         this._featureIcon = new PetFeatureIcon();
         this._featureIcon.x = 155;
         this._featureIcon.y = 0;
         _ui.addChild(this._featureIcon);
         this._decorationIcon = new PetDecorationIcon();
         _ui["decoration"].addChild(this._decorationIcon);
         this._decorationIcon.x = -15;
         this._decorationIcon.y = -15;
         eventListenerMgr.addEventListener(_ui,"click",this.onClick);
         this._icon = new Vector.<StarMagicIcon>();
         for(i = 0; i < 5; )
         {
            this._icon[i] = new StarMagicIcon(0,0);
            this._icon[i].scaleX = this._icon[i].scaleY = 45 / 60;
            _ui["pet" + i].addChild(this._icon[i]);
            i++;
         }
      }
      
      private function onFocusPetChange() : void
      {
         var onGetPetSimpleInfo:Function = null;
         this._petInfo = moduleData.focusePet;
         this._basePetInfo = this._petInfo;
         if(this._petInfo == null)
         {
            this._petDemoDisplayer.visible = false;
            return;
         }
         this._petDemoDisplayer.visible = true;
         Connection.removeCommandListener(CommandSet.PET_SIMPLE_INFO_1017,this.onGetPetSimpleInfo);
         if(moduleData.listDataService.isInStorage(this._petInfo.catchTime) || moduleData.listDataService.isInFreeList(this._petInfo.catchTime))
         {
            if(this._lastUpdateFun != null)
            {
               Connection.removeCommandListener(CommandSet.PET_SIMPLE_INFO_1017,this._lastUpdateFun);
            }
            onGetPetSimpleInfo = function(event:MessageEvent):void
            {
               Connection.removeCommandListener(CommandSet.PET_SIMPLE_INFO_1017,onGetPetSimpleInfo);
               var info:PetInfo = new NewParser_1017(event.message.getRawData()).petInfo;
               if(_petInfo != null && info.catchTime == _petInfo.catchTime)
               {
                  _petInfo = info;
                  updateView();
               }
            };
            this._lastUpdateFun = onGetPetSimpleInfo;
            Connection.addCommandListener(CommandSet.PET_SIMPLE_INFO_1017,onGetPetSimpleInfo);
            Connection.send(CommandSet.PET_SIMPLE_INFO_1017,this._petInfo.catchTime);
         }
         else
         {
            this.updateView();
         }
      }
      
      private function onGetPetSimpleInfo(event:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.PET_SIMPLE_INFO_1017,this.onGetPetSimpleInfo);
         var info:PetInfo = new NewParser_1017(event.message.getRawData()).petInfo;
         if(this._petInfo != null && info.catchTime == this._petInfo.catchTime)
         {
            this._petInfo = info;
            this.updateView();
         }
      }
      
      private function onClick(e:MouseEvent) : void
      {
         var message:String = null;
         var btnName:String = String(e.target.name);
         switch(btnName)
         {
            case "trainingBtn":
               if(this._petInfo.level == 1000)
               {
                  AlertManager.showAlert("100级的精灵不需要训练");
                  return;
               }
               message = "你确定要把" + this._petInfo.name + "放回小屋训练吗?";
               this.showConfirm(message,function():void
               {
                  Connection.send(CommandSet.PET_TRAINING_START_1039,_petInfo.catchTime);
               });
               break;
            case "treasureStartBtn":
               break;
            case "releaseBtn":
               this.showConfirm("你确定要放生这只精灵吗？",function():void
               {
                  if(_petInfo.hasStar){
                     AlertManager.showAlert("精灵装备有星魂，请卸下星魂后再放生");
                  }
                  else if(_petInfo.getPetDefinition().starLevel <= 4)
                  {
                     if(_under4StarsExtinctPetsList.indexOf(_petInfo.resourceId) != -1)
                     {
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
                  if(this._petInfo.isPetRiding == true)
                  {
                     AlertManager.showAlert("精灵当前正在骑乘中，请先收回后再放入仓库吧");
                     return;
                  }
                  PetInfoManager.requestAddToStorageFromBag(this._petInfo.catchTime);
               }
         }
      }
      
      private function updateView() : void
      {
         var shenmohua:Array = null;
         if(_ui == null)
         {
            return;
         }
         _ui["genderMc"].gotoAndStop(this._petInfo.sex + 1);
         _ui["erDaiMc"].visible = this._petInfo.isTwoPet;
         _ui["trainingBtn"].visible = false;
         _ui["treasureStartBtn"].visible = false;
         _ui["releaseBtn"].visible = false;
         _ui["putInBagBtn"].visible = false;
         _ui["putInStorageBtn"].visible = false;
         _ui["free"].visible = false;
         //判断是否可放生
         //var releaseBtnEnable:Boolean = Boolean(this._petInfo.getPetDefinition().isFreeable);
         var releaseBtnEnable:Boolean = false;
         if(this._petInfo.getPetDefinition().starLevel <= 4 || this._5StarPetsFreeableList.indexOf(this._petInfo.resourceId) != -1)
         {
            releaseBtnEnable = true;
         }
         Util.setEnabled(_ui["releaseBtn"],releaseBtnEnable,!releaseBtnEnable);
         if(moduleData.listDataService.isInStorage(this._petInfo.catchTime))
         {
            if(this._basePetInfo.freeTime > 0)
            {
               this.updateFreeTime();
               _ui["putInStorageBtn"].visible = true;
            }
            else
            {
               _ui["trainingBtn"].visible = true;
               _ui["releaseBtn"].visible = true;
               _ui["putInBagBtn"].visible = true;
            }
         }
         else if(moduleData.listDataService.isInFreeList(this._petInfo.catchTime))
         {
            if(this._basePetInfo.freeTime > 0)
            {
               this.updateFreeTime();
            }
            _ui["putInStorageBtn"].visible = true;
         }
         else if(PetInfoManager.getPetInfoFromBag(this._petInfo.catchTime) != null || PetInfoManager.getPetInfoFromBagStorage(this._petInfo.catchTime) != null)
         {
            _ui["putInStorageBtn"].visible = true;
         }
         var i:int = 0;
         _ui["starLevel"].gotoAndStop(this._petInfo.getPetDefinition().starLevel);
         this._typeIcon.type = this._petInfo.type;
         this._petDemoDisplayer.newSetUrl(URLUtil.getPetDemo(this._petInfo.resourceId));
         if(this._petInfo.emblemId == 0)
         {
            _ui["emblem"].visible = false;
         }
         else
         {
            _ui["emblem"].visible = true;
            this._emblemIcon.id = this._petInfo.emblemId;
         }
         if(this._petInfo.decorationId == 0)
         {
            _ui["decoration"].visible = false;
         }
         else
         {
            _ui["decoration"].visible = true;
            this._decorationIcon.id = this._petInfo.decorationId;
         }
         _ui["nameTxt"].text = this._petInfo.name;
         _ui["idTxt"].text = this._petInfo.resourceId;
         _ui["levelTxt"].text = this._petInfo.level;
         _ui["leftExpTxt"].text = this.getUpLevelExpStr();
         _ui["natureTxt"].text = PetCharactarNameMap.getCharactarName(this._petInfo.character);
         _ui["hegihtTxt"].text = this._petInfo.physicalHeight + "cm";
         _ui["weightTxt"].text = this._petInfo.physicalWeight + "kg";
         _ui["upgradeLevelTxt"].text = this.getUpgradeLevelStr();
         var date:Date = new Date(this._petInfo.catchTime * 1000);
         _ui["cachTime"].text = date.fullYear + "年" + (date.month + 1) + "月" + date.date + "日";
         var pros:Array = [this._petInfo.atk,this._petInfo.defence,this._petInfo.specialAtk,this._petInfo.specialDefence,this._petInfo.speed,this._petInfo.maxHp];
         for(i = 0; i < pros.length; )
         {
            _ui["prop" + i].text = pros[i].toString();
            i++;
         }
         var xuexili:Array = [this._petInfo.learningInfo.pointAtk,this._petInfo.learningInfo.pointDefence,this._petInfo.learningInfo.pointSpecialAtk,this._petInfo.learningInfo.pointSpecialDefence,this._petInfo.learningInfo.pointSpeed,this._petInfo.learningInfo.pointHp];
         for(i = 0; i < xuexili.length; )
         {
            _ui["xuexili" + i].text = xuexili[i].toString();
            i++;
         }
         var zizhi:Array = [this._petInfo.potentialAtk,this._petInfo.potentialDef,this._petInfo.potentialSpAtk,this._petInfo.potentialSpDef,this._petInfo.potentialSpeed,this._petInfo.potentialHp];
         for(i = 0; i < zizhi.length; )
         {
            _ui["zizhi" + i].text = zizhi[i].toString();
            i++;
         }
         var currentAdd:PetEvolveStarInfo;
         if((currentAdd = PetEvolveConfig.getStarInfo(this._petInfo.evolveLevel)) != null)
         {
            shenmohua = [currentAdd.Atk,currentAdd.Def,currentAdd.SpAtk,currentAdd.SpDef,currentAdd.Spd,currentAdd.Hp];
            for(i = 0; i < shenmohua.length; )
            {
               this._ui["shenmohua" + i].text = "+" + shenmohua[i];
               i++;
            }
         }
         else
         {
            for(i = 0; i < 6; )
            {
               this._ui["shenmohua" + i].text = "+0";
               i++;
            }
         }
         this.resetPos();
         StarMagicManager.getPetStar(this._petInfo.catchTime,this.resetPos,this.resetPos);
         if(Boolean(this._petInfo.getPetDefinition()) && this._petInfo.getPetDefinition().chgMonId != 0)
         {
            _ui["changPetBtn"].visible = true;
            try
            {
               TooltipManager.addCommonTip(_ui["changPetBtn"],PetConfig.getPetDefinitionInfo(this._petInfo.resourceId).changeTip);
            }
            catch(e:*)
            {
            }
         }
         else
         {
            _ui["changPetBtn"].visible = false;
         }
         if(Boolean(PetConfig.getPetDefinitionInfo(this._petInfo.resourceId)) && PetConfig.getPetDefinitionInfo(this._petInfo.resourceId).fetter != "")
         {
            _ui["fetterMC"].visible = true;
            TooltipManager.addCommonTip(_ui["fetterMC"],PetConfig.getPetDefinitionInfo(this._petInfo.resourceId).fetter);
         }
         else
         {
            _ui["fetterMC"].visible = false;
         }
         this._featureIcon.setFeature(this._petInfo.getPetDefinition().featureId,this._petInfo.getPetDefinition().featureDescription);
         this.setStars();
      }
      
      private function updateFreeTime() : void
      {
         var currentTime:uint = 0;
         var petFreeSeconds:uint = 0;
         var freeDays:uint = 0;
         if(this._basePetInfo.freeTime > 0)
         {
            _ui["free"].visible = true;
            currentTime = uint(TimeManager.getServerTime());
            if(currentTime < this._basePetInfo.freeTime)
            {
               currentTime = uint(this._basePetInfo.freeTime);
            }
            petFreeSeconds = currentTime - this._basePetInfo.freeTime;
            freeDays = 7 - DateUtil.convertSecondsToDays(petFreeSeconds);
            _ui["free"]["days"].text = freeDays.toString();
         }
      }
      
      private function setStars() : void
      {
         var starNum:uint = 0;
         var i:int = 0;
         if(this._petInfo.evolveLevel != 0)
         {
            starNum = uint(PetEvolveConfig.getStarNum(this._petInfo.evolveLevel));
            for(i = 0; i < 4; )
            {
               _ui["star" + i].visible = true;
               if(i < starNum)
               {
                  if(this._petInfo.evolveLevel <= 4)
                  {
                     _ui["star" + i].gotoAndStop(2);
                  }
                  else if(this._petInfo.evolveLevel <= 8)
                  {
                     _ui["star" + i].gotoAndStop(4);
                  }
                  else if(this._petInfo.evolveLevel <= 1004)
                  {
                     _ui["star" + i].gotoAndStop(6);
                  }
                  else
                  {
                     _ui["star" + i].gotoAndStop(8);
                  }
               }
               else if(this._petInfo.evolveLevel <= 4)
               {
                  _ui["star" + i].gotoAndStop(1);
               }
               else if(this._petInfo.evolveLevel <= 8)
               {
                  _ui["star" + i].gotoAndStop(3);
               }
               else if(this._petInfo.evolveLevel <= 1004)
               {
                  _ui["star" + i].gotoAndStop(5);
               }
               else
               {
                  _ui["star" + i].gotoAndStop(7);
               }
               i++;
            }
            _ui.evolveShadeMc.visible = true;
            if(this._petInfo.evolveLevel <= 4)
            {
               _ui.evolveShadeMc.gotoAndStop(1);
            }
            else if(this._petInfo.evolveLevel <= 8)
            {
               _ui.evolveShadeMc.gotoAndStop(2);
            }
            else if(this._petInfo.evolveLevel <= 1004)
            {
               _ui.evolveShadeMc.gotoAndStop(3);
            }
            else
            {
               _ui.evolveShadeMc.gotoAndStop(4);
            }
         }
         else
         {
            _ui.evolveShadeMc.visible = false;
            for(i = 0; i < 4; )
            {
               _ui["star" + i].visible = false;
               _ui["star" + i].gotoAndStop(1);
               i++;
            }
         }
      }
      
      private function resetPos() : void
      {
         var i:int = 0;
         for(i = 0; i < StarMagicManager.petNum; )
         {
            if(i < StarMagicManager.curPet.length)
            {
               this._icon[i].updateDateInfo(StarMagicManager.curPet[i]);
            }
            else
            {
               this._icon[i].updateDateInfo(null);
            }
            i++;
         }
      }
      
      private function getUpLevelExpStr() : String
      {
         if(this._petInfo.level == 100)
         {
            return "--";
         }
         return String(this._petInfo.expToLevelUp);
      }
      
      private function getUpgradeLevelStr() : String
      {
         var petDefination:PetDefinition = PetConfig.getPetDefinition(this._petInfo.resourceId);
         var upgrageLevel:uint = uint(petDefination.evolvingLv);
         if(upgrageLevel == 0)
         {
            return "已满";
         }
         return String(petDefination.evolvingLv.toString());
      }
      
      override public function destory() : void
      {
         TooltipManager.remove(_ui["changPetBtn"]);
         TooltipManager.remove(_ui["fetterMC"]);
         this._petDemoDisplayer.clearDemo();
         this._petDemoDisplayer = null;
         super.destory();
      }
      
      private function showConfirm(txt:String, callback:Function) : void
      {
         _ui.mouseEnabled = false;
         _ui.mouseChildren = false;
         AlertManager.showConfirm(txt,function():void
         {
            _ui.mouseEnabled = true;
            _ui.mouseChildren = true;
            callback();
         },function():void
         {
            _ui.mouseEnabled = true;
            _ui.mouseChildren = true;
         });
      }
   }
}
