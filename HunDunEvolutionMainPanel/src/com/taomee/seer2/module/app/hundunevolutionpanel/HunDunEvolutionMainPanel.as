package com.taomee.seer2.module.app.hundunevolutionpanel
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.manager.CommonUseManager;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.net.parser.Parser_1142;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.serverBuffer.ServerBufferType;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.app.swap.special.SpecialInfo;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.module.Module;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.LifecycleType;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.utils.IDataInput;
   import org.taomee.utils.BitUtil;
   
   public class HunDunEvolutionMainPanel extends Module
   {
      private var playBtn:SimpleButton;
      
      private var petInfoBtn:SimpleButton;
      
      private var evolutionBtn:SimpleButton;
      
      private var fastBtn:SimpleButton;
      
      private var getPetBtn:SimpleButton;
      
      private var goBtnList:Vector.<SimpleButton>;
      
      private var markMcList:Vector.<MovieClip>;
      
      private var overMc:MovieClip;
      
      private const fullString:String = "HunDunEvolutionFull";
      
      private const goPanelArr:Array = ["HunDunEvolutionBattleOnePanel","HunDunEvolutionBattleTwoPanel","HunDunEvolutionBattleThreePanel","HunDunEvolutionBattleFourPanel"];
      
      private const RES_ID:int = 804;
      
      private const SWAP_EVO_ID:int = 4149;
      
      private const FOR_LIST:Array = [205964];
      
      private var evoBit:int;
      
      public function HunDunEvolutionMainPanel()
      {
         super();
         _lifecycleType = LifecycleType.GLOBAL;
      }
      
      override public function setup() : void
      {
         this.setMainUI(new HunDunEvolutionMainPanelUI());
         this.initSet();
      }
      
      private function initSet() : void
      {
         this.overMc = _mainUI["overMc"];
         this.playBtn = _mainUI["playBtn"];
         this.playBtn.addEventListener(MouseEvent.CLICK,this.onPlay);
         this.petInfoBtn = _mainUI["petInfoBtn"];
         this.petInfoBtn.addEventListener(MouseEvent.CLICK,this.onPetInfo);
         this.evolutionBtn = _mainUI["evolutionBtn"];
         this.evolutionBtn.addEventListener(MouseEvent.CLICK,this.onEvolution);
         this.fastBtn = _mainUI["fastBtn"];
         this.fastBtn.addEventListener(MouseEvent.CLICK,this.onFastGot);
         this.getPetBtn = _mainUI["getPetBtn"];
         this.getPetBtn.addEventListener(MouseEvent.CLICK,this.onGetPet);
         this.goBtnList = new Vector.<SimpleButton>();
         this.markMcList = new Vector.<MovieClip>();
         for(var i:int = 0; i < 4; i++)
         {
            this.goBtnList.push(_mainUI["goBtn" + i]);
            this.goBtnList[i].addEventListener(MouseEvent.CLICK,this.onGo);
            this.markMcList.push(_mainUI["markMc" + i]);
         }
      }
      
      private function onGetPet(e:MouseEvent) : void
      {
         ModuleManager.closeForName("HunDunEvolutionMainPanel");
         ModuleManager.showAppModule("ChaosKingPanel");
      }
      
      private function onFastGot(e:MouseEvent) : void
      {
         ModuleManager.closeForName("HunDunEvolutionMainPanel");
         ModuleManager.showAppModule("HunDunEvolutionFastPanel");
      }
      
      private function onPlay(e:MouseEvent) : void
      {
         MovieClipUtil.playFullScreen(URLUtil.getActivityFullScreen(this.fullString),null,true,true,2,true);
      }
      
      private function onPetInfo(e:MouseEvent) : void
      {
         ModuleManager.showAppModule("PetDetailInfoPanel",{"resId":980});
      }
      
      private function onEvolution(e:MouseEvent) : void
      {
         AlertManager.showPetBagSelectAlert("请选择一只100级【混沌大帝】",function(info:PetInfo):void
         {
            if(Boolean(info))
            {
               if(info.resourceId != RES_ID)
               {
                  AlertManager.showAlert("请选择一只【混沌大帝】哦!");
               }
               else if(info.level < 100)
               {
                  AlertManager.showAlert("【混沌大帝】需要满级才可以超进化哦!");
               }
               else
               {
                  SwapManager.swapItem(SWAP_EVO_ID,1,function(data:IDataInput):void
                  {
                     new SwapInfo(data);
                     ModuleManager.showAppModule("HunDunEvolutionMainPanel");
                  },null,new SpecialInfo(1,info.catchTime));
               }
            }
         });
      }
      
      private function onGo(e:MouseEvent) : void
      {
         var idx:int = int(this.goBtnList.indexOf(e.currentTarget as SimpleButton));
         ModuleManager.closeForName("HunDunEvolutionMainPanel");
         ModuleManager.showAppModule(this.goPanelArr[idx]);
      }
      
      public function updateDate() : void
      {
         this.resetStatus();
         ActiveCountManager.requestActiveCountList(this.FOR_LIST,function(par:Parser_1142):void
         {
            evoBit = par.infoVec[0];
            updateShow();
         });
      }
      
      private function updateShow() : void
      {
         var count:int = 0;
         for(var i:int = 4; i < 8; i++)
         {
            if(BitUtil.getBit(this.evoBit,i))
            {
               this.markMcList[i - 4].visible = true;
               DisplayObjectUtil.enableButton(this.goBtnList[count]);
               count++;
            }
         }
         if(count >= 4)
         {
            DisplayObjectUtil.enableButton(this.evolutionBtn);
         }
         else
         {
            DisplayObjectUtil.enableButton(this.goBtnList[count]);
            DisplayObjectUtil.disableButton(this.evolutionBtn);
         }
         if(BitUtil.getBit(this.evoBit,0))
         {
            this.overMc.visible = true;
            DisplayObjectUtil.disableButton(this.evolutionBtn);
         }
      }
      
      private function resetStatus() : void
      {
         for(var i:int = 0; i < this.markMcList.length; i++)
         {
            this.markMcList[i].visible = false;
            DisplayObjectUtil.disableButton(this.goBtnList[i]);
         }
         this.overMc.visible = false;
      }
      
      override public function show() : void
      {
         super.show();
         CommonUseManager.firstPlayFullScreen(ServerBufferType.HunDunWakeupStartFull_FIRST,this.fullString);
         StatisticsManager.newSendNovice("2015活动","混沌超进化","面板打开");
         this.updateDate();
      }
      
      override public function hide() : void
      {
         super.hide();
      }
   }
}

