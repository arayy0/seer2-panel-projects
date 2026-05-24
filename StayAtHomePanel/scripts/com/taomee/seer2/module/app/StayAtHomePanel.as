package com.taomee.seer2.module.app
{
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.team.TeamManager;
   import com.taomee.seer2.core.module.Module;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.SceneType;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.LifecycleType;
   import com.taomee.seer2.module.app.lottery.StayAtHomePanelUI;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.setTimeout;
   
   public class StayAtHomePanel extends Module {

      private var _calendarPanel:calendarPanel;

      private var _dailyPanel:dailyPanel;

      private var _getPetPanel:getPetPanel;

      private var _missionPanel:missionPanel;

      private var _pvpPanel:pvpPanel;

      private var _calendarBtn:SimpleButton;

      private var _dailyBtn:SimpleButton;

      private var _getPetBtn:SimpleButton;

      private var _missionBtn:SimpleButton;

      private var _bagBtn:SimpleButton;

      private var _pvpBtn:SimpleButton;

      private var _shopBtn:SimpleButton;

      private var _teamBtn:SimpleButton;

      private var _warningMc:MovieClip;

      public function StayAtHomePanel()
      {
         super();
         _lifecycleType = LifecycleType.GLOBAL;
      }

      override public function setup():void
      {
         setMainUI(new StayAtHomePanelUI());
         this.initSet();
         this.initEvent();
      }

      private function initSet():void
      {
         this._calendarPanel = new calendarPanel();
         addChild(this._calendarPanel);
         this._calendarPanel.setVisible(false);
         this._dailyPanel = new dailyPanel();
         addChild(this._dailyPanel);
         this._dailyPanel.setVisible(false);
         this._getPetPanel = new getPetPanel();
         addChild(this._getPetPanel);
         this._getPetPanel.setVisible(false);
         this._missionPanel = new missionPanel();
         addChild(this._missionPanel);
         this._missionPanel.setVisible(false);
         this._pvpPanel = new pvpPanel();
         addChild(this._pvpPanel);
         this._pvpPanel.setVisible(false);
         this._calendarBtn = _mainUI["calendarBtn"];
         this._dailyBtn = _mainUI["dailyBtn"];
         this._getPetBtn = _mainUI["getPetBtn"];
         this._missionBtn = _mainUI["missionBtn"];
         this._pvpBtn = _mainUI["pvpBtn"];
         this._shopBtn = _mainUI["shopBtn"];
         this._bagBtn = _mainUI["bagBtn"];
         this._teamBtn = _mainUI["teamBtn"];
         this._warningMc = _mainUI["warning"];
         this._warningMc.gotoAndStop(1);
      }

      private function initEvent():void
      {
         _mainUI["closeBtn"].addEventListener("click",onClose);
         this._bagBtn.addEventListener("click",function (e:MouseEvent):void
         {
            ModuleManager.showAppModule("ItemBagPanel");
         });
         this._calendarBtn.addEventListener("click",function (e:MouseEvent):void
         {
            _calendarPanel.setVisible(true);
         });
         this._dailyBtn.addEventListener("click",function (e:MouseEvent):void
         {
            _dailyPanel.setVisible(true);
         });
         this._getPetBtn.addEventListener("click",function (e:MouseEvent):void
         {
            _getPetPanel.setVisible(true);
         });
         this._missionBtn.addEventListener("click",function (e:MouseEvent):void
         {
            _missionPanel.setVisible(true);
         });
         this._pvpBtn.addEventListener("click",function (e:MouseEvent):void
         {
            _pvpPanel.setVisible(true);
         });
         this._shopBtn.addEventListener("click",function (e:MouseEvent):void
         {
            ModuleManager.showAppModule("ShopPanel");
         });
         this._teamBtn.addEventListener("click",function (e:MouseEvent):void
         {
            if (TeamManager.teamId > 0)
            {
               ModuleManager.closeForInstance(this);
               SceneManager.changeScene(SceneType.TEAM, TeamManager.teamId);
            }
            else
            {
               AlertManager.showAlert("你还没有加入战队");
            }
         });
         this._teamBtn.addEventListener(MouseEvent.MOUSE_OVER,function(e:MouseEvent):void
         {
            _warningMc.gotoAndStop(2);
            (_warningMc["tipTxt"] as TextField).text = "前往战队基地，将离开小屋";
         });
         this._teamBtn.addEventListener(MouseEvent.MOUSE_OUT,function(e:MouseEvent):void
         {
            _warningMc.gotoAndStop(1);
         })
      }
   }
}
