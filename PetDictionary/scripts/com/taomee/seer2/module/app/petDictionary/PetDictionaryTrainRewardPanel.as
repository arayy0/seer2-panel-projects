package com.taomee.seer2.module.app.petDictionary
{
   import com.taomee.seer2.module.app.moduleCommon.PageBar;
   import com.taomee.seer2.module.app.petDictionary.config.PetDictionaryConfig;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.TrainRewardInfo;
   import com.taomee.seer2.module.app.petDictionary.event.PetDictionaryEvent;
   import com.taomee.seer2.module.app.petDictionary.trainReward.TrainRewardCell;

import flash.display.MovieClip;
import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class PetDictionaryTrainRewardPanel extends Sprite
   {
       
      
      private const PAGESIZE:int = 8;
      
      private var _pageBar:PageBar;
      
      private var _trainRewardVec:Vector.<TrainRewardInfo>;
      
      private var _trainCellVec:Vector.<TrainRewardCell>;

      private var _mainUI:MovieClip;

      public var _page:int;
      
      public function PetDictionaryTrainRewardPanel()
      {
         super();
         this.createChildren();
         this.createCells();
         this.onChangePage();
      }
      
      private function createChildren() : void
      {
         this._trainRewardVec = PetDictionaryConfig.trainRewardVec;
         this._mainUI = new PetsCollectionPanelUI();
         addChild(this._mainUI);
         var preBtn:SimpleButton = _mainUI["preBtn"];
         var nextBtn:SimpleButton = _mainUI["nextBtn"];
         this._pageBar = new PageBar(preBtn,nextBtn,Math.ceil(this._trainRewardVec.length / 8));
         this._pageBar.addEventListener("pageChange",this.onChangePage);
      }
      
      private function createCells() : void
      {
         var i:int = 0;
         var cell:TrainRewardCell = null;
         this._trainCellVec = new Vector.<TrainRewardCell>();
         for(i = 0; i < 8; )
         {
            cell = new TrainRewardCell();
            cell.x = 57 + 208 * (int(i % 4));
            cell.y = 77 + 208 * (int(i / 4));
            addChild(cell);
            this._trainCellVec.push(cell);
            i++;
         }
      }
      
      private function onChangePage(evt:Event = null) : void
      {
         this.setData();
         this._mainUI["preBtn"].visible = true;
         this._mainUI["nextBtn"].visible = true;
         if(this._pageBar.currentPage == 1)
         {
            this._mainUI["preBtn"].visible = false;
         }
         else if(this._pageBar.currentPage == 2)
         {
            this._mainUI["nextBtn"].visible = false;
         }
         dispatchEvent(new Event("TRAIN_PANEL_PAGE_CHANGE"));
      }
      
      private function setData() : void
      {
         var i:int = 0;
         var offset:int = (this._pageBar.currentPage - 1) * 8;
         this._page = this._pageBar.currentPage;
         for(i = 0; i < this._trainCellVec.length; )
         {
            if(offset + i < this._trainRewardVec.length)
            {
               this._trainCellVec[i].visible = true;
               this._trainCellVec[i].setData(this._trainRewardVec[offset + i]);
               this._trainCellVec[i].updata();
            }
            else
            {
               this._trainCellVec[i].visible = false;
            }
            i++;
         }
      }
      
      public function update(isCheckReward:Boolean = false) : void
      {
         var i:int = 0;
         var j:int = 0;
         for(i = 0; i < this._trainCellVec.length; )
         {
            this._trainCellVec[i].updata();
            i++;
         }
         if(isCheckReward)
         {
            for(j = 0; j < this._trainRewardVec.length; )
            {
               if(this._trainRewardVec[j].flag != 1 && this._trainRewardVec[j].status == 1)
               {
                  dispatchEvent(new PetDictionaryEvent("trainPetShine"));
                  break;
               }
               j++;
            }
         }
      }
   }
}
