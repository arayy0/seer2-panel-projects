package com.taomee.seer2.module.app.versionOnePetBagPanel.petInfoPanel
{
   import com.taomee.seer2.app.component.PetPotentialityIcon;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.pet.PetDefinition;
   import com.taomee.seer2.app.event.LogicEvent;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.newGuidStatistics.NewGuidStatisManager;
   import com.taomee.seer2.app.pet.constant.PetCharactarNameMap;
   import com.taomee.seer2.app.pet.constant.PetGrowLevel;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.processor.quest.handler.main.quest83.QuestMapHandler_83_80351;
   import com.taomee.seer2.app.processor.quest.handler.main.quest99.QuestMapHandler_99_80491;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.shopManager.ShopManager;
   import com.taomee.seer2.app.starMagic.StarMagicManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.events.ModelLocator;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.module.app.moduleCommon.PetDecorationIcon;
   import com.taomee.seer2.module.app.moduleCommon.PetEmblemIcon;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.PetInfoPanel;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.taomee.manager.EventManager;
   
   public class BaseInfoPanel extends Sprite
   {
       
      
      private var _mainUI:MovieClip;
      
      private var _starTxt:TextField;
      
      private var _levelTxt:TextField;
      
      private var _characterTxt:TextField;
      
      private var _studyTxt:TextField;
      
      private var _funcUpList:Vector.<SimpleButton>;
      
      private var _testPower:SimpleButton;
      
      private var _embed_1:MovieClip;
      
      private var _embed_2:MovieClip;
      
      private var _emblemIcon:PetEmblemIcon;
      
      private var _decorationIcon:PetDecorationIcon;
      
      private var _potentialIcon:PetPotentialityIcon;
      
      private var _qualityTxt:TextField;
      
      private var _level:MovieClip;
      
      private var _petInfo:PetInfo;
      
      private var _thisParent:PetInfoPanel;
      
      private var _newQuestMC1:MovieClip;
      
      private var _newQuestMC2:MovieClip;
      
      private const MI_ID_LIST:Vector.<uint> = Vector.<uint>([201013,201005]);
      
      private var _charaBtn:SimpleButton;
      
      public function BaseInfoPanel(thisParent:PetInfoPanel)
      {
         super();
         this._thisParent = thisParent;
         this.initSet();
         this.initEvent();
      }
      
      private function initSet() : void
      {
         this._mainUI = new PetInfoUI();
         addChild(this._mainUI);
         this._levelTxt = this._mainUI["levelTxt"];
         this._charaBtn = this._mainUI["charaBtn"];
         this._characterTxt = this._mainUI["characterTxt"];
         this._studyTxt = this._mainUI["studyTxt"];
         this._starTxt = this._mainUI["starTxt"];
         this._funcUpList = new Vector.<SimpleButton>();
         var i:int = 0;
         while(i < 6)
         {
            this._funcUpList.push(this._mainUI["funcUp" + i]);
            i++;
         }
         this._embed_1 = this._mainUI["emblem0"];
         this._embed_2 = this._mainUI["emblem1"];
         this._emblemIcon = new PetEmblemIcon();
         this._emblemIcon.scaleX = this._emblemIcon.scaleY = 1.2;
         this._mainUI.addChild(this._emblemIcon);
         this._decorationIcon = new PetDecorationIcon();
         this._decorationIcon.scaleX = this._decorationIcon.scaleY = 1.2;
         this._mainUI.addChild(this._decorationIcon);
         this._potentialIcon = new PetPotentialityIcon();
         this._mainUI.addChild(this._potentialIcon);
         this._potentialIcon.x = 792;
         this._potentialIcon.y = 174;
         this._level = this._mainUI["level"];
         this._level.gotoAndStop(1);
         TooltipManager.addCommonTip(this._level,"default");
         this._newQuestMC1 = this._mainUI["newQuestMC1"];
         this._newQuestMC1.visible = false;
         this._newQuestMC2 = this._mainUI["newQuestMC2"];
         this._newQuestMC2.visible = false;
         this.onAllPowerCount();
      }
      
      private function initEvent() : void
      {
         var item:SimpleButton = null;
         for each(item in this._funcUpList)
         {
            item.addEventListener("click",this.onFuncUp);
         }
         this._charaBtn.addEventListener("click",this.onGoChara);
         EventManager.addEventListener("PetReCount",this.onAllPowerCount);
         EventManager.addEventListener("PetUpdate",this.onAllPowerCount);
         ModelLocator.getInstance().addEventListener("newGuideBroad7",this.onGetGuide);
      }
      
      private function onShowStarNum() : void
      {
         var starNum:int = 0;
         var i:int = 0;
         while(i < StarMagicManager.curPet.length)
         {
            switch(int(StarMagicManager.curPet[i].type) - 1)
            {
               case 0:
                  starNum += (StarMagicManager.curPet[i].level + 1) * 10;
                  break;
               case 1:
                  starNum += (StarMagicManager.curPet[i].level + 1) * 20;
                  break;
               case 2:
                  starNum += (StarMagicManager.curPet[i].level + 1) * 40;
                  break;
               case 3:
                  starNum += (StarMagicManager.curPet[i].level + 1) * 80;
                  break;
            }
            i++;
         }
         this._starTxt.text = starNum.toString();
      }
      
      private function onGetGuide(evt:LogicEvent) : void
      {
         this._newQuestMC2.visible = false;
         if(Boolean(QuestManager.isAccepted(99)) && Boolean(QuestManager.isStepComplete(99,5)) && !QuestManager.isStepComplete(99,6) && Boolean(QuestMapHandler_99_80491.isClickQuest99_6))
         {
            this._newQuestMC2.visible = true;
         }
      }
      
      private function onGoPerfect(evt:MouseEvent) : void
      {
         ModuleManager.closeForName("PetBagPanel");
         ModuleManager.showAppModule("SuperPetPracticePanel");
      }
      
      private function onAllPowerCount(evt:Event = null) : void
      {
         var item:PetInfo = null;
         var petList:Vector.<PetInfo> = PetInfoManager.getAllBagPetInfo();
         var _allPower:int = 0;
         for each(item in petList)
         {
            _allPower += PetInfoManager.getPowerByPetInfo(item);
         }
      }
      
      private function onFuncUp(evt:MouseEvent) : void
      {
         var index:int = this._funcUpList.indexOf(evt.currentTarget as SimpleButton);
         switch(index)
         {
            case 0:
               ModuleManager.showAppModule("PetDeityEvilSelectPanel");
               StatisticsManager.sendNovice("0x1003384A");
               break;
            case 1:
               ModuleManager.showAppModule("PetCharaPracticePanel",this._petInfo);
               StatisticsManager.sendNovice("0x1003384B");
               break;
            case 2:
               this.medalBuyHandle();
               break;
            case 3:
               this._thisParent.changePanelShow(2);
               NewGuidStatisManager.statisHandle(42);
               this._newQuestMC1.visible = false;
               break;
            case 4:
               this._thisParent.changePanelShow(1);
               this._newQuestMC2.visible = false;
               break;
            case 5:
               ModuleManager.closeForName("PetBagPanel");
               ModuleManager.showAppModule("GetStarMagicPanel");
         }
      }
      
      private function medalBuyHandle() : void
      {
         if(this._petInfo == null)
         {
            AlertManager.showAlert("精灵信息不存在");
            return;
         }
         var emblemId:uint = uint(this._petInfo.getPetDefinition().emblemId);
         if(emblemId == 0)
         {
            AlertManager.showAlert("该精灵无专属纹章");
            return;
         }
         if(!Boolean(ItemConfig.getEmblemDefinition(this._petInfo.getPetDefinition().emblemId)))
         {
            AlertManager.showAlert("该精灵无专属纹章");
            return;
         }
         var miBuyId:uint = uint(ItemConfig.getEmblemDefinition(emblemId).miBuyID);
         if(miBuyId == 0)
         {
            AlertManager.showAlert("该纹章暂不出售");
            return;
         }
         ShopManager.buyItemForId(miBuyId);
      }
      
      public function setData(info:PetInfo) : void
      {
         this.reset();
         this._petInfo = info;
         if(this._petInfo != null)
         {
            this.updateDisplay();
         }
         this._newQuestMC1.visible = false;
         if(Boolean(QuestManager.isAccepted(83)) && Boolean(QuestManager.isStepComplete(83,8)) && !QuestManager.isStepComplete(83,9) && Boolean(QuestMapHandler_83_80351.isClickQuest83))
         {
            this._newQuestMC1.visible = true;
         }
         if(Boolean(QuestManager.isAccepted(99)) && Boolean(QuestManager.isStepComplete(99,4)) && !QuestManager.isStepComplete(99,5) && Boolean(QuestMapHandler_99_80491.isClickQuest99_5))
         {
            this._newQuestMC1.visible = true;
         }
         StarMagicManager.getPetStar(this._petInfo.catchTime,this.onShowStarNum,this.onShowStarNum);
      }
      
      private function updateDisplay() : void
      {
         this._levelTxt.text = String(this._petInfo.level);
         this._characterTxt.text = PetCharactarNameMap.getCharactarName(this._petInfo.character);
         this._studyTxt.text = this._petInfo.learningInfo.pointTotal().toString();
         trace("背包中当前精灵战斗力:",PetInfoManager.getPowerByPetInfo(this._petInfo),";精灵库中战斗力:",PetInfoManager.getPowerByPetInfo(PetInfoManager.getPetInfoFromAllBag(this._petInfo.catchTime)));
         var embedNum:int = 0;
         if(this._petInfo.getPetDefinition().emblem2Id != 0)
         {
            embedNum = 2;
            if(this._petInfo.decorationId == 0)
            {
               this._embed_2.visible = true;
               this._decorationIcon.visible = false;
               if(Boolean(this._petInfo.getPetDefinition().emblem2Id) && Boolean(ItemConfig.getEmblemDefinition(this._petInfo.getPetDefinition().emblem2Id)))
               {
                  TooltipManager.addCommonTip(this._embed_2,ItemConfig.getItemDefinition(this._petInfo.getPetDefinition().emblem2Id).name + "(未拥有):" + ItemConfig.getEmblemDefinition(this._petInfo.getPetDefinition().emblem2Id).tip);
               }
               else
               {
                  TooltipManager.remove(this._embed_2);
               }
            }
            else
            {
               this._embed_2.visible = false;
               this._decorationIcon.visible = true;
               this._decorationIcon.id = this._petInfo.decorationId;
               this._decorationIcon.x = this._embed_2.x - 6;
               this._decorationIcon.y = this._embed_2.y - 6;
            }
         }
         else
         {
            embedNum = 1;
            this._embed_2.visible = false;
            this._decorationIcon.visible = false;
         }
         if(this._petInfo.emblemId == 0)
         {
            this._emblemIcon.visible = false;
            this._embed_1.visible = true;
            trace("111");
            if(Boolean(this._petInfo.getPetDefinition().emblemId) && Boolean(ItemConfig.getEmblemDefinition(this._petInfo.getPetDefinition().emblemId)))
            {
               TooltipManager.addCommonTip(this._embed_1,ItemConfig.getEmblemDefinition(this._petInfo.getPetDefinition().emblemId).name + "(未拥有):" + ItemConfig.getEmblemDefinition(this._petInfo.getPetDefinition().emblemId).tip);
               trace("222");
            }
            else
            {
               TooltipManager.addCommonTip(this._embed_1,"无专属纹章");
               trace("333");
            }
         }
         else
         {
            trace("444");
            this._embed_1.visible = false;
            this._emblemIcon.id = this._petInfo.emblemId;
            this._emblemIcon.visible = true;
            this._emblemIcon.x = this._embed_1.x - 6;
            this._emblemIcon.y = this._embed_1.y - 6;
         }
         TooltipManager.changeTip(this._level,"当前资质:" + (this._petInfo.potentialAtk + this._petInfo.potentialDef + this._petInfo.potentialSpAtk + this._petInfo.potentialSpDef + this._petInfo.potentialSpeed + this._petInfo.potentialHp).toString());
         this._level.gotoAndStop(PetInfoManager.getQualityLevel(this._petInfo.potentialAtk + this._petInfo.potentialDef + this._petInfo.potentialSpAtk + this._petInfo.potentialSpDef + this._petInfo.potentialSpeed + this._petInfo.potentialHp) + 1);
      }
      
      private function expShow() : void
      {
         var totalExp:uint = uint(PetGrowLevel.GROW_TOTAL_EXP[this._petInfo.getPetDefinition().growthType - 1][this._petInfo.level - 1]);
      }
      
      private function getUpLevelExpStr() : String
      {
         if(!this._petInfo)
         {
            return "";
         }
         if(this._petInfo.level == 100)
         {
            return "升级所需经验:已满级";
         }
         return "升级所需经验:" + String(this._petInfo.expToLevelUp);
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
      
      private function reset() : void
      {
         this._levelTxt.text = "";
         this._characterTxt.text = "";
         this._decorationIcon.dispose();
      }
      
      private function onGoChara(param1:MouseEvent) : void
      {
         ModuleManager.showAppModule("NewGuidelinesOld",{
            "type":"BattleEncyclopedia",
            "subType":"PetCharater"
         });
      }
   }
}
