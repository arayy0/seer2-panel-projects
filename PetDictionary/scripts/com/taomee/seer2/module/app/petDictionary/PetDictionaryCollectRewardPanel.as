package com.taomee.seer2.module.app.petDictionary
{
import com.taomee.seer2.core.net.MessageEvent;
import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.module.app.moduleCommon.PageBar;
   import com.taomee.seer2.module.app.petDictionary.collectReward.InitialPetCollectCell;
   import com.taomee.seer2.module.app.petDictionary.collectReward.SuitCollectPanel;
   import com.taomee.seer2.module.app.petDictionary.collectReward.ThirdPetCollectCell;
   import com.taomee.seer2.module.app.petDictionary.config.PetDictionaryConfig;
import com.taomee.seer2.module.app.petDictionary.event.PetDictionaryEvent;

import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class PetDictionaryCollectRewardPanel extends Sprite
   {
       
      
      private var _allSuitReward:Vector.<int>;
      
      private var _pageBar:PageBar;
      
      private var _initialPanel:InitialPetCollectCell;
      
      private var _thirdPanel:ThirdPetCollectCell;
      
      private var _suitPanel:SuitCollectPanel;

      private var _trainPanel:PetDictionaryTrainRewardPanel;
      
      private var _currentPanel:Sprite;

      private var _mainUI:MovieClip;
      
      public function PetDictionaryCollectRewardPanel()
      {
         super();
         this._allSuitReward = PetDictionaryConfig.getAllSuitReward();
         this.createChildren();
      }
      
      private function createChildren() : void
      {
         this._mainUI = new PetsCollectionPanelUI();
         addChild(this._mainUI);
         this._pageBar = new PageBar(this._mainUI["preBtn"],this._mainUI["nextBtn"],this._allSuitReward.length + 3,this._mainUI["currentPageTxt"],this._mainUI["totalPageTxt"]);
         this._pageBar.addEventListener("pageChange",this.onPageChange);
         this._suitPanel = new SuitCollectPanel();
         this._allSuitReward.splice(this._allSuitReward.indexOf(266),1);
         this._allSuitReward.unshift(266);
         this._suitPanel.setData(this._allSuitReward[0]);
         this._suitPanel.newMc.visible = true;
         this._initialPanel = new InitialPetCollectCell(this._suitPanel);
         this._thirdPanel = new ThirdPetCollectCell(this._suitPanel);
         this._trainPanel = new PetDictionaryTrainRewardPanel();
         this._trainPanel.addEventListener("TARIN_PANEL_PAGE_CHANGE",this.trainPanelUpdate);
         this._trainPanel.addEventListener("trainPetShine",function(e:MessageEvent = null):void
         {
            dispatchEvent(new PetDictionaryEvent("collectPetShine"));
         });
         this._currentPanel = this._suitPanel;
         addChild(this._currentPanel);
      }
      
      private function onPageChange(evt:Event) : void
      {
         DisplayObjectUtil.removeFromParent(this._currentPanel);
         var currentPage:int = this._pageBar.currentPage;
         this._mainUI["preBtn"].visible = true;
         this._mainUI["nextBtn"].visible = true;
         if(currentPage == this._allSuitReward.length + 1)
         {
            this._currentPanel = this._initialPanel;
         }
         else if(currentPage == this._allSuitReward.length + 2)
         {
            this._currentPanel = this._thirdPanel;
         }
         else if(currentPage == this._allSuitReward.length + 3)
         {
            this._currentPanel = this._trainPanel;
         }
         else
         {
            this._suitPanel.setData(this._allSuitReward[currentPage - 1]);
            this._suitPanel.newMc.visible = currentPage == 1 ? true : false;
            this._currentPanel = this._suitPanel;
         }
         addChild(this._currentPanel);
      }

      private function trainPanelUpdate(e:MessageEvent = null):void
      {
         if(this._trainPanel._page == 2)
         {
            this._mainUI["preBtn"].visible = false;
         }
         else if(this._trainPanel._page == 1)
         {
            this._mainUI["nextBtn"].visible = false;
         }
      }
      
      public function updata() : void
      {
         this._suitPanel.updata();
         this._initialPanel.updata();
         this._thirdPanel.updata();
         this._trainPanel.update();
         this._suitPanel.updateShine(this._allSuitReward);
      }
   }
}
