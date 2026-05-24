package com.taomee.seer2.module.app.sptPanel
{
   import com.taomee.seer2.app.gameRule.spt.support.SptBossInfoManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.SceneType;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.module.app.SPTPanel;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class SPTBossInfoPanel extends Sprite
   {
      
      private var _sptBossInfo:SPTBossInfo;
      
      private var _info:SptInfo;
      
      private var _container:Sprite;
      
      private var _goButton:SimpleButton;
      
      private var _closeBtn:SimpleButton;
      
      private var _fun:Function;
      
      public function SPTBossInfoPanel()
      {
         super();
      }
      
      public function dispose() : void
      {
         DisplayObjectUtil.removeFromParent(this);
         this._sptBossInfo = null;
         this._info = null;
         this._container = null;
         if(this._goButton != null && this._goButton.hasEventListener(MouseEvent.CLICK))
         {
            this._goButton.removeEventListener(MouseEvent.CLICK,this.onClick);
            this._goButton = null;
         }
         if(this._closeBtn != null && this._closeBtn.hasEventListener(MouseEvent.CLICK))
         {
            this._closeBtn.removeEventListener(MouseEvent.CLICK,this.onClose);
            this._closeBtn = null;
         }
      }
      
      public function setInfo(sptBossInfo:SPTBossInfo = null) : void
      {
         this._sptBossInfo = sptBossInfo;
         this._info = SPTPanel.getSptInfo(this._sptBossInfo.bossID);
         var cls:Class = this._info.panelClass;
         this._container = new cls();
         addChild(this._container);
         this.showScore();
         this._goButton = this._container["goBtn"];
         this._goButton.addEventListener(MouseEvent.CLICK,this.onClick);
         this._closeBtn = this._container["closeBtn"];
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         this.x = this._info.initX;
         this.y = this._info.initY;
      }
      
      public function setCallback(fun:Function) : void
      {
         this._fun = fun;
      }
      
      private function onClose(event:MouseEvent) : void
      {
         this.dispose();
         if(this._fun != null)
         {
            this._fun();
         }
      }
      
      private function onClick(event:MouseEvent) : void
      {
         SceneManager.changeScene(SceneType.LOBBY,this._info.targetMapId);
      }
      
      private function showScore() : void
      {
         var score:int = this._sptBossInfo.score;
         switch(score)
         {
            case SptBossInfoManager.UNWIN:
            case SptBossInfoManager.WIN:
               MovieClip(this._container["score0"]).gotoAndStop(2);
               MovieClip(this._container["score1"]).gotoAndStop(1);
               MovieClip(this._container["score2"]).gotoAndStop(1);
               break;
            case SptBossInfoManager.CATCH:
               MovieClip(this._container["score0"]).gotoAndStop(3);
               MovieClip(this._container["score1"]).gotoAndStop(2);
               MovieClip(this._container["score2"]).gotoAndStop(1);
               break;
            case SptBossInfoManager.CHALLENGE_RULE_1:
               MovieClip(this._container["score0"]).gotoAndStop(3);
               MovieClip(this._container["score1"]).gotoAndStop(3);
               MovieClip(this._container["score2"]).gotoAndStop(2);
               break;
            case SptBossInfoManager.CHALLENGE_RULE_2:
               MovieClip(this._container["score0"]).gotoAndStop(3);
               MovieClip(this._container["score1"]).gotoAndStop(3);
               MovieClip(this._container["score2"]).gotoAndStop(3);
         }
         this.showContainerTip();
      }
      
      private function showContainerTip() : void
      {
         var container:MovieClip = null;
         for(var i:int = 0; i < 3; i++)
         {
            container = this._container["score" + i];
            TooltipManager.addMultipleTip(container,SPTPanel.getSptInfo(this._sptBossInfo.bossID).bossTip[i]);
         }
      }
   }
}

