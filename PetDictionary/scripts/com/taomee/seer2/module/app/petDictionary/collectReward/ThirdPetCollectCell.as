package com.taomee.seer2.module.app.petDictionary.collectReward
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.manager.OnlyFlagManager;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.petDictionary.InitialPetCollecteCellUI_1;
   import com.taomee.seer2.module.app.petDictionary.config.PetDictionaryConfig;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.ThirdPetRewardInfo;
   import com.taomee.seer2.module.app.petDictionary.data.PetDictionaryDataServer;
   import com.taomee.seer2.module.app.petDictionary.event.PetDictionaryEvent;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ThirdPetCollectCell extends Sprite
   {
       
      
      private var _rewardBigIcon:IconDisplayer;
      
      private var _rewardSmallIcon:IconDisplayer;
      
      private var _firstPetIcon:IconDisplayer;
      
      private var _secondPetIcon:IconDisplayer;
      
      private var _getRewardBtn:SimpleButton;
      
      private var _receivedBtn:MovieClip;
      
      private var _monsterIcon:MovieClip;
      
      private var _info:ThirdPetRewardInfo;
      
      private var _shineMC:MovieClip;
      
      private var _p:Sprite;
      
      public function ThirdPetCollectCell(p:Sprite)
      {
         super();
         this._p = p;
         this._info = PetDictionaryConfig.thirdPetRewardInfo;
         this.createChildren();
         this.initEventListener();
      }
      
      private function createChildren() : void
      {
         var mainUI:InitialPetCollecteCellUI_1 = new InitialPetCollecteCellUI_1();
         mainUI.x = 58;
         mainUI.y = 88;
         addChild(mainUI);
         this._firstPetIcon = new IconDisplayer();
         this._secondPetIcon = new IconDisplayer();
         this._rewardBigIcon = new IconDisplayer();
         this._rewardSmallIcon = new IconDisplayer();
         this._firstPetIcon.scaleX = this._firstPetIcon.scaleY = 1.4912280701754386;
         this._secondPetIcon.scaleX = this._secondPetIcon.scaleY = 1.4912280701754386;
         this._rewardSmallIcon.scaleX = this._rewardSmallIcon.scaleY = 0.8421052631578947;
         this._rewardBigIcon.scaleX = this._rewardBigIcon.scaleY = 2.9473684210526314;
         this._rewardBigIcon.x = 100;
         this._rewardBigIcon.y = 150;
         this._firstPetIcon.setIconUrl(URLUtil.getPetIcon(this._info.firstPetId));
         this._secondPetIcon.setIconUrl(URLUtil.getPetIcon(this._info.secondPetId));
         this._rewardBigIcon.setIconUrl(URLUtil.getPetIcon(this._info.rewardId));
         this._rewardSmallIcon.setIconUrl(URLUtil.getPetIcon(this._info.rewardId));
         mainUI["rewardPetName"].text = PetConfig.getPetDefinition(this._info.rewardId).name;
         mainUI["initialIcon"].addChild(this._firstPetIcon);
         mainUI["initialIcon_1"].addChild(this._secondPetIcon);
         mainUI["rewardIcon"].addChild(this._rewardSmallIcon);
         addChild(this._rewardBigIcon);
         this._getRewardBtn = mainUI["getRewardBtn"];
         this._receivedBtn = mainUI["receivedBtn"];
         this._monsterIcon = mainUI["monstIcon"];
         this._shineMC = mainUI["shineMC"];
         this._shineMC.mouseEnabled = false;
         this._shineMC.stop();
         this._shineMC.visible = false;
         TooltipManager.addCommonTip(this._firstPetIcon,"初始精灵超过100级");
         TooltipManager.addCommonTip(this._secondPetIcon,"第二只主宠超过60级");
         TooltipManager.addCommonTip(this._monsterIcon,"收集40种不同种类的精灵");
      }
      
      private function initEventListener() : void
      {
         this._getRewardBtn.addEventListener("click",this.onGetReward);
      }
      
      private function onGetReward(evt:MouseEvent) : void
      {
         PetDictionaryDataServer.getRewardByIndex(this._info.index,function():void
         {
            _getRewardBtn.removeEventListener("click",onGetReward);
            OnlyFlagManager.updataFlag(_info.onlyFlagIndex,1);
            _info.flag = 1;
            updata();
         });
      }
      
      private function updataStatus() : void
      {
         var secondPetInfo:* = null;
         var info:PetInfo = null;
         var petGainedFlag:Boolean = false;
         var firstPetLevelFlag:Boolean = false;
         var secondPetLevelFlag:Boolean = false;
         if(PetDictionaryDataServer.petGainedNum >= this._info.collectPetNum)
         {
            DisplayObjectUtil.recoverDisplayObject(this._monsterIcon);
            petGainedFlag = true;
         }
         else
         {
            DisplayObjectUtil.grayDisplayObject(this._monsterIcon);
         }
         if(PetInfoManager.getInitialPetInfo().level >= 100)
         {
            DisplayObjectUtil.recoverDisplayObject(this._firstPetIcon);
            firstPetLevelFlag = true;
         }
         else
         {
            DisplayObjectUtil.grayDisplayObject(this._firstPetIcon);
         }
         var InitialPetInfoVec:Vector.<PetInfo> = PetInfoManager.getInitialPetInfoVec();
         for each(info in InitialPetInfoVec)
         {
            if(info.bunchId == PetConfig.getPetDefinition(this._info.secondPetId).bunchId)
            {
               secondPetInfo = info;
               break;
            }
         }
         if(secondPetInfo != null && secondPetInfo.level >= 60)
         {
            DisplayObjectUtil.recoverDisplayObject(this._secondPetIcon);
            secondPetLevelFlag = true;
         }
         else
         {
            DisplayObjectUtil.grayDisplayObject(this._secondPetIcon);
         }
         if(petGainedFlag && firstPetLevelFlag && secondPetLevelFlag)
         {
            DisplayObjectUtil.enableButton(this._getRewardBtn);
            this._shineMC.play();
            this._shineMC.visible = true;
            if(this._info.flag != 1)
            {
               this._p.dispatchEvent(new PetDictionaryEvent("collectPetShine"));
            }
         }
         else
         {
            DisplayObjectUtil.disableButton(this._getRewardBtn);
            this._shineMC.stop();
            this._shineMC.visible = false;
         }
      }
      
      public function updata() : void
      {
         this.updataStatus();
         this.updataBtn();
      }
      
      private function updataBtn() : void
      {
         if(this._info.flag == 1)
         {
            this._receivedBtn.visible = true;
            this._getRewardBtn.visible = false;
            this._shineMC.stop();
            this._shineMC.visible = false;
         }
         else
         {
            this._receivedBtn.visible = false;
            this._getRewardBtn.visible = true;
         }
      }
   }
}
