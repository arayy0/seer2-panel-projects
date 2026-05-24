package com.taomee.seer2.module.app.newPetDictionary
{
   import com.greensock.TweenLite;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class NewPetDictionaryTabBar extends Sprite
   {
      
      public static const PETLIST_TAB:String = "PETLIST_TAB";
      
      public static const PETSKIN_TAB:String = "PETSKIN_TAB";
      
      public static const COLLECTEREWARD_TAB:String = "COLLECTEREWARD_TAB";
      
      public static const THISWEEK_TAB:String = "THISWEEK_TAB";
      
      public static const ZHENYING_TAB:String = "ZHENYING_TAB";
       
      
      private var _tabBar:NewPetDicTabBarUI;
      
      private var _petListTabBtn:SimpleButton;
      
      private var _thisWeekTabBtn:SimpleButton;
      
      private var _collectRewardTabBtn:SimpleButton;
      
      private var _petSkinTabBtn:SimpleButton;
      
      private var _collectNewMark:MovieClip;
      
      private var _tabMaskMc:MovieClip;
      
      private var _collectShineMC:MovieClip;
      
      private var _trainShineMc:MovieClip;
      
      private var _currentTabBtn:SimpleButton;
      
      public function NewPetDictionaryTabBar()
      {
         super();
         this.initMC();
         this.initListener();
      }
      
      public function reset() : void
      {
         this.currentTab = this._petListTabBtn;
      }
      
      public function moveToTab(index:uint) : void
      {
         if(index >= 0 && index <= 4)
         {
            switch(int(index))
            {
               case 0:
                  this.currentTab = this._petListTabBtn;
                  dispatchEvent(new Event("PETLIST_TAB"));
                  break;
               case 1:
                  this.currentTab = this._thisWeekTabBtn;
                  dispatchEvent(new Event("THISWEEK_TAB"));
                  break;
               case 2:
                  this.currentTab = this._collectRewardTabBtn;
                  ServerBufferManager.updateServerBuffer(313,1,1);
                  this._collectNewMark.visible = false;
                  dispatchEvent(new Event("COLLECTEREWARD_TAB"));
                  break;
               case 3:
                  this.currentTab = this._petSkinTabBtn;
                  dispatchEvent(new Event("PETSKIN_TAB"));
            }
         }
      }
      
      public function showShineMC(name:String) : void
      {
         var target:MovieClip = null;
         target = name == "collect" ? this._collectShineMC : this._trainShineMc;
         target.visible = true;
         target.play();
      }
      
      public function hideShineMc(name:String) : void
      {
         var target:MovieClip = null;
         target = name == "collect" ? this._collectShineMC : this._trainShineMc;
         target.visible = false;
         target.stop();
      }
      
      private function initMC() : void
      {
         this._tabBar = new NewPetDicTabBarUI();
         this._tabBar.y = 20;
         this._tabBar.x = -3;
         addChild(this._tabBar);
         this._petListTabBtn = this._tabBar["petListTabBtn"];
         this._petSkinTabBtn = this._tabBar["petSkinTabBtn"];
         this._collectRewardTabBtn = this._tabBar["petCollecteRewardTabBtn"];
         this._thisWeekTabBtn = this._tabBar["thisWeekPetTabBtn"];
         this._collectNewMark = this._tabBar["collectNewMark"];
         this._collectNewMark.mouseEnabled = this._collectNewMark.mouseChildren = false;
         this.updateCollectNewMark();
         this._tabMaskMc = this._tabBar["tabMaskMc"];
         this._collectShineMC = this._tabBar["collectShineMC"];
         this._trainShineMc = this._tabBar["trainShineMC"];
         DisplayObjectUtil.disableSprite(this._tabMaskMc);
         DisplayObjectUtil.disableSprite(this._collectShineMC);
         DisplayObjectUtil.disableSprite(this._trainShineMc);
         this._collectShineMC.visible = this._trainShineMc.visible = false;
         this._collectShineMC.stop();
         this._trainShineMc.stop();
      }
      
      private function updateCollectNewMark() : void
      {
         ServerBufferManager.getServerBuffer(313,function(server:ServerBuffer):void
         {
            var _isPlay:Boolean = Boolean(server.readDataAtPostion(1));
            if(!_isPlay)
            {
               _collectNewMark.visible = true;
            }
            else
            {
               _collectNewMark.visible = false;
            }
         });
      }
      
      private function initListener() : void
      {
         this._petListTabBtn.addEventListener("click",this.onTabBarBtnClick);
         this._petSkinTabBtn.addEventListener("click",this.onTabBarBtnClick);
         this._collectRewardTabBtn.addEventListener("click",this.onTabBarBtnClick);
         this._thisWeekTabBtn.addEventListener("click",this.onTabBarBtnClick);
      }
      
      private function onTabBarBtnClick(e:MouseEvent) : void
      {
         this.currentTab = e.currentTarget as SimpleButton;
         trace("[---current target-----" + this._currentTabBtn.name + "]");
         switch(this._currentTabBtn.name)
         {
            case "petListTabBtn":
               dispatchEvent(new Event("PETLIST_TAB"));
               break;
            case "petSkinTabBtn":
               dispatchEvent(new Event("PETSKIN_TAB"));
               break;
            case "petCollecteRewardTabBtn":
               ServerBufferManager.updateServerBuffer(313,1,1);
               this._collectNewMark.visible = false;
               dispatchEvent(new Event("COLLECTEREWARD_TAB"));
               break;
            case "thisWeekPetTabBtn":
               dispatchEvent(new Event("THISWEEK_TAB"));
         }
      }
      
      private function set currentTab(tab:SimpleButton) : void
      {
         if(Boolean(this._currentTabBtn))
         {
            this._currentTabBtn.mouseEnabled = true;
         }
         this._currentTabBtn = tab;
         this._currentTabBtn.mouseEnabled = false;
         TweenLite.to(this._tabMaskMc,0.2,{
            "x":this._currentTabBtn.x,
            "width":this._currentTabBtn.width
         });
      }
   }
}
