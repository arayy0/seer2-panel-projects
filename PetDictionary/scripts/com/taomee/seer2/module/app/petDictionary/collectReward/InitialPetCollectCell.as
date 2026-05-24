package com.taomee.seer2.module.app.petDictionary.collectReward
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.manager.OnlyFlagManager;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.petDictionary.InitialPetCollecteCellUI;
   import com.taomee.seer2.module.app.petDictionary.config.PetDictionaryConfig;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.InitialPetRewardInfo;
   import com.taomee.seer2.module.app.petDictionary.data.PetDictionaryDataServer;
   import com.taomee.seer2.module.app.petDictionary.event.PetDictionaryEvent;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class InitialPetCollectCell extends Sprite
   {
       
      
      private var _initialInfo:InitialPetRewardInfo;
      
      private var _rewardBigIcon:IconDisplayer;
      
      private var _rewardSmallIcon:IconDisplayer;
      
      private var _initialIcon:IconDisplayer;
      
      private var _getRewardBtn:SimpleButton;
      
      private var _receivedBtn:MovieClip;
      
      private var _monsterIcon:MovieClip;
      
      private var _shineMC:MovieClip;
      
      private var _p:Sprite;
      
      public function InitialPetCollectCell(p:Sprite)
      {
         super();
         this._p = p;
         this._initialInfo = PetDictionaryConfig.initPetRewardInfo;
         this.createChildren();
         this.initEventListener();
         this.updataStatus();
      }
      
      private function createChildren() : void
      {
         var mainUI:InitialPetCollecteCellUI = new InitialPetCollecteCellUI();
         addChild(mainUI);
         mainUI.x = 58;
         mainUI.y = 88;
         this._initialIcon = new IconDisplayer();
         this._rewardBigIcon = new IconDisplayer();
         this._rewardSmallIcon = new IconDisplayer();
         this._initialIcon.scaleX = this._initialIcon.scaleY = 1.4912280701754386;
         this._rewardSmallIcon.scaleX = this._rewardSmallIcon.scaleY = 0.8421052631578947;
         this._rewardBigIcon.scaleX = this._rewardBigIcon.scaleY = 2.9473684210526314;
         this._rewardBigIcon.x = 100;
         this._rewardBigIcon.y = 150;
         this._initialIcon.setIconUrl(URLUtil.getPetIcon(this._initialInfo.resourceId));
         this._rewardBigIcon.setIconUrl(URLUtil.getPetIcon(this._initialInfo.rewardId));
         this._rewardSmallIcon.setIconUrl(URLUtil.getPetIcon(this._initialInfo.rewardId));
         mainUI["rewardPetName"].text = PetConfig.getPetDefinition(this._initialInfo.rewardId).name;
         mainUI["initialIcon"].addChild(this._initialIcon);
         mainUI["rewardIcon"].addChild(this._rewardSmallIcon);
         addChild(this._rewardBigIcon);
         this._getRewardBtn = mainUI["getRewardBtn"];
         this._receivedBtn = mainUI["receivedBtn"];
         this._monsterIcon = mainUI["monstIcon"];
         this._shineMC = mainUI["shineMC"];
         this._shineMC.mouseEnabled = false;
         this._shineMC.stop();
         this._shineMC.visible = false;
         TooltipManager.addCommonTip(this._initialIcon,"初始精灵超过60级");
         TooltipManager.addCommonTip(this._monsterIcon,"收集20种不同种类的精灵");
      }
      
      private function initEventListener() : void
      {
         this._getRewardBtn.addEventListener("click",this.onGetReward);
      }
      
      private function onGetReward(evt:MouseEvent) : void
      {
         PetDictionaryDataServer.getRewardByIndex(this._initialInfo.index,function():void
         {
            OnlyFlagManager.updataFlag(_initialInfo.onlyFlagIndex,1);
            _getRewardBtn.removeEventListener("click",onGetReward);
            _initialInfo.flag = 1;
            updata();
         });
      }
      
      public function updata() : void
      {
         this.updataStatus();
         this.updataBtn();
      }
      
      private function updataStatus() : void
      {
         var petGainedFlag:Boolean = false;
         var initialPetLevelFlag:Boolean = false;
         if(PetDictionaryDataServer.petGainedNum >= this._initialInfo.collectPetNum)
         {
            DisplayObjectUtil.recoverDisplayObject(this._monsterIcon);
            petGainedFlag = true;
         }
         else
         {
            DisplayObjectUtil.grayDisplayObject(this._monsterIcon);
         }
         if(PetInfoManager.getInitialPetInfo().level >= this._initialInfo.initialPetLevel)
         {
            DisplayObjectUtil.recoverDisplayObject(this._initialIcon);
            initialPetLevelFlag = true;
         }
         else
         {
            DisplayObjectUtil.grayDisplayObject(this._initialIcon);
         }
         if(petGainedFlag && initialPetLevelFlag)
         {
            DisplayObjectUtil.enableButton(this._getRewardBtn);
            this._shineMC.play();
            this._shineMC.visible = true;
            if(this._initialInfo.flag != 1)
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
      
      private function updataBtn() : void
      {
         if(this._initialInfo.flag == 1)
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
