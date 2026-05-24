package com.taomee.seer2.module.app.newPetDictionary
{
   import com.taomee.seer2.app.config.NewPetDicThisWeekListConfig;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.info.PetDictionaryInfo;
   import com.taomee.seer2.app.config.pet.PetDefinition;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.core.module.Module;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.module.app.petDictionary.PetDictionaryCollectRewardPanel;
   import com.taomee.seer2.module.app.petDictionary.PetDictionaryTrainRewardPanel;
   import com.taomee.seer2.module.app.petDictionary.data.PetDictionaryDataServer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.taomee.utils.StringUtil;
   
   public class PetDictionary extends Module
   {
       
      
      private var _tabBar:NewPetDictionaryTabBar;
      
      private var _contentPanel:Sprite;
      
      private var _initTabIndex:uint = 0;
      
      private var _showNewPetId:uint = 0;
      
      private var _isCollectShine:Boolean = false;
      
      private var _isTrainShine:Boolean = false;
      
      private var _shuxingBtn:SimpleButton;
      
      private var _petLevel:MovieClip;
      
      private var _hasBtn:SimpleButton;
      
      private var _notHasBtn:SimpleButton;
      
      private var _currentPanel:Sprite;
      
      private var _propertySearch:NewPetDicsPropertySearch;
      
      private var _isPropertySearchOn:Boolean;
      
      private var _petListPanel:NewPetDicsListAndDetailPanel;
      
      private var _thisWeekPanel:NewPetDicsListAndDetailPanel;
      
      private var _collectRewardPanel:PetDictionaryCollectRewardPanel;
      
      private var _petSkinPanel:NewPetDicsListAndDetailPanel;
      
      private var _petIdInputTxt:TextField;
      
      private var _queryBtn:SimpleButton;
      
      public function PetDictionary()
      {
         super();
         _lifecycleType = "global";
      }
      
      override public function setup() : void
      {
         setMainUI(new NewPetDicMainUI());
         this.initmc();
         this.initListener();
      }
      
      override public function show() : void
      {
         PetDictionaryDataServer.getDataFromServer(this.onGetGiftStatus,this.onGetPetDictionary,this.onGetRewardStatus);
         super.show();
         this._tabBar.moveToTab(this._initTabIndex);
         ServerBufferManager.getServerBuffer(313,function(server:ServerBuffer):void
         {
            var _isPlay:Boolean = Boolean(server.readDataAtPostion(2));
            if(!_isPlay)
            {
               ServerBufferManager.updateServerBuffer(313,2,1);
               ModuleManager.showAppModule("PetNewFuncGuidePanel");
            }
         });
         this._petLevel.gotoAndStop(1);
      }
      
      override public function init(data:Object) : void
      {
         super.init(data);
         if(data != null)
         {
            this._initTabIndex = data["tabIndex"];
            this._showNewPetId = data["showNewPetId"];
         }
      }
      
      private function reset() : void
      {
         this._tabBar.reset();
         this.changeContent(this._petListPanel);
         this._petListPanel.x = 60;
         this._petListPanel.y = 135;
      }
      
      private function onGetGiftStatus() : void
      {
         this._collectRewardPanel.updata();
      }
      
      private function onGetPetDictionary() : void
      {
         this._petListPanel.setData(PetDictionaryDataServer.getAllPets());
      }
      
      private function onGetRewardStatus() : void
      {
         this._collectRewardPanel.updata();
      }
      
      private function initmc() : void
      {
         this._contentPanel = new Sprite();
         addChild(this._contentPanel);
         this._tabBar = new NewPetDictionaryTabBar();
         this._tabBar.x = 65;
         this._tabBar.y = 33;
         addChild(this._tabBar);
         this._petListPanel = new NewPetDicsListAndDetailPanel();
         this._thisWeekPanel = new NewPetDicsListAndDetailPanel();
         this._propertySearch = new NewPetDicsPropertySearch();
         this._collectRewardPanel = new PetDictionaryCollectRewardPanel();
         this._petSkinPanel = new NewPetDicsListAndDetailPanel();
         this._shuxingBtn = _mainUI["shuxing"];
         this._hasBtn = _mainUI["have"];
         this._notHasBtn = _mainUI["nothave"];
         this._petIdInputTxt = _mainUI["search"]["petIdInputTxt"];
         this._queryBtn = _mainUI["search"]["queryBtn"];
         this._petLevel = _mainUI["petLevel"];
         this._petLevel.buttonMode = true;
      }
      
      private function initListener() : void
      {
         this._tabBar.addEventListener("PETLIST_TAB",this.onPetListTab);
         this._tabBar.addEventListener("THISWEEK_TAB",this.onThisWeekTab);
         this._tabBar.addEventListener("COLLECTEREWARD_TAB",this.onCollectRewardTab);
         this._tabBar.addEventListener("PETSKIN_TAB",this.onPetSkinTab);
         this._shuxingBtn.addEventListener("click",this.onShuxingBtn);
         this._petLevel.addEventListener("click",this.onPetLevel);
         this._hasBtn.addEventListener("click",this.onHasClick);
         this._notHasBtn.addEventListener("click",this.onNotHadClick);
         this._propertySearch.addEventListener("CLICK_ITEM",this.onPropetyClick);
         this._collectRewardPanel.addEventListener("collectPetShine",this.onCollectShine,true);
         this._petIdInputTxt.addEventListener("focusIn",this.onFocusIn);
         this._petIdInputTxt.addEventListener("focusOut",this.onFucusOut);
         this._queryBtn.addEventListener("click",this.onQuery);
      }
      
      private function onFocusIn(evt:FocusEvent) : void
      {
         this._petIdInputTxt.text = "";
      }
      
      private function onFucusOut(evt:FocusEvent) : void
      {
         var idInputStr:String = String(StringUtil.trim(this._petIdInputTxt.text));
         if(idInputStr == "")
         {
            this.resetPetIdInput();
         }
      }
      
      private function resetPetIdInput() : void
      {
         this._petIdInputTxt.text = "搜索名字或者ID";
      }
      
      private function __onQuery(evt:MouseEvent) : void
      {
         var _selectPetID:* = 0;
         var max:int = 0;
         var petDefinition:PetDefinition = null;
         var petDicInfo:PetDictionaryInfo = null;
         var i:int = 0;
         var idInputStr:String = String(StringUtil.trim(this._petIdInputTxt.text));
         if(idInputStr == "" || idInputStr == "搜索名字或者ID")
         {
            return;
         }
         if(StringUtil.isInteger(idInputStr))
         {
            _selectPetID = int(idInputStr);
         }
         else
         {
            max = int(PetConfig.getPetCount());
            for(i = 1; i <= max; )
            {
               if(i <= 1000 || i >= 2000 && i <= 2600)
               {
                  petDefinition = PetConfig.getPetDefinition(i);
                  if((petDicInfo = PetConfig.getPetDefinitionInfo(i)) && petDefinition && petDefinition.name == idInputStr)
                  {
                     _selectPetID = i;
                     break;
                  }
               }
               i++;
            }
         }
         if(PetConfig.getPetDefinition(_selectPetID) != null && PetConfig.getPetDefinitionInfo(_selectPetID) != null)
         {
            this._petListPanel.detailPanel.setData(_selectPetID);
         }
         else
         {
            AlertManager.showAlert("尚未发现该序号的精灵");
         }
      }
      
      private function onQuery(evt:MouseEvent) : void
      {
         var _selectPetID:int;
         var matchedPets:Vector.<int>;
         var idInputStr:String = String(StringUtil.trim(this._petIdInputTxt.text));
         if(idInputStr == "" || idInputStr == "搜索名字或者ID")
         {
            this._petListPanel.dispose();
            this.onGetPetDictionary();
            return;
         }
         _selectPetID = 0;
         if(StringUtil.isInteger(idInputStr))
         {
            _selectPetID = int(idInputStr);
         }
         matchedPets = PetDictionaryDataServer.getAllPets().filter(function(id:int, param2:int, param3:Vector.<int>):Boolean
         {
            var p:PetDefinition = PetConfig.getPetDefinition(id);
            return id == 0 || Boolean(p) && (p.name.indexOf(idInputStr) != -1 || _selectPetID == p.resId);
         });
         this._petListPanel.dispose();
         if(matchedPets.length > 1)
         {
            this._petListPanel.setData(matchedPets);
         }
         else
         {
            matchedPets = PetDictionaryDataServer.getAllSkins().filter(function (id:int, param2:int, param3:Vector.<int>):Boolean
            {
               var p:PetDefinition = PetConfig.getPetDefinition(id);
               return id == 0 || Boolean(p) && (p.name.indexOf(idInputStr) != -1 || _selectPetID == p.resId);
            });
            if (matchedPets.length > 1)
            {
               this._petListPanel.setData(matchedPets);
            }
            else
            {
               AlertManager.showAlert("尚未发现该精灵");
            }
         }
      }
      
      private function onCollectShine(e:Event) : void
      {
         if(this._isCollectShine == false)
         {
            this._tabBar.showShineMC("collect");
            this._isCollectShine = true;
         }
      }
      
      private function onTrainShine(e:Event) : void
      {
         if(this._isTrainShine == false)
         {
            this._tabBar.showShineMC("train");
            this._isTrainShine = true;
         }
      }
      
      private function onPropetyClick(e:Event) : void
      {
         if(this._currentPanel == this._petListPanel)
         {
            this._petListPanel.dispose();
            this._petListPanel.setData(NewPetDicsPropertySearch.getDataByPropertyOfAll());
         }
         if(this._currentPanel == this._thisWeekPanel)
         {
            this._thisWeekPanel.dispose();
            this._thisWeekPanel.setData(NewPetDicsPropertySearch.getDataByPropertyOfThisWeek());
         }
      }
      
      protected function onNotHadClick(event:MouseEvent) : void
      {
         if(this._currentPanel == this._petListPanel)
         {
            this._petListPanel.dispose();
            this._petListPanel.setData(PetDictionaryDataServer.getNotGainedPets());
         }
         if(this._currentPanel == this._thisWeekPanel)
         {
            this._thisWeekPanel.dispose();
            this._thisWeekPanel.setData(PetDictionaryDataServer.getthisWeekNotGained());
         }
      }
      
      protected function onHasClick(event:MouseEvent) : void
      {
         if(this._currentPanel == this._petListPanel)
         {
            this._petListPanel.dispose();
            this._petListPanel.setData(PetDictionaryDataServer.getGainedPets());
         }
         if(this._currentPanel == this._thisWeekPanel)
         {
            this._thisWeekPanel.dispose();
            this._thisWeekPanel.setData(PetDictionaryDataServer.getthisWeekGained());
         }
      }
      
      private function onPetLevel(evt:MouseEvent) : void
      {
         var i:int = 0;
         if(this._petLevel.currentFrame == 1)
         {
            if(this._isPropertySearchOn)
            {
               this._isPropertySearchOn = !this._isPropertySearchOn;
               if(Boolean(this._propertySearch) && Boolean(this._propertySearch.parent))
               {
                  this._propertySearch.parent.removeChild(this._propertySearch);
               }
            }
            this._petLevel.gotoAndStop(2);
            for(i = 0; i < 7; )
            {
               (this._petLevel["petLevel_" + i] as MovieClip).buttonMode = true;
               (this._petLevel["petLevel_" + i] as MovieClip).addEventListener("mouseOver",this.onLevelOver);
               (this._petLevel["petLevel_" + i] as MovieClip).addEventListener("click",this.onLevelClick);
               (this._petLevel["petLevel_" + i] as MovieClip).gotoAndStop(2);
               i++;
            }
            (this._petLevel["back"] as SimpleButton).addEventListener("click",this.onPetLevelClose);
         }
      }
      
      private function onLevelOver(evt:MouseEvent) : void
      {
         var i:int = 0;
         var index:int = int((evt.currentTarget as MovieClip).name.split("_")[1]);
         for(i = 0; i < 7; )
         {
            if(i <= index)
            {
               (this._petLevel["petLevel_" + i] as MovieClip).gotoAndStop(2);
            }
            else
            {
               (this._petLevel["petLevel_" + i] as MovieClip).gotoAndStop(1);
            }
            i++;
         }
      }
      
      private function onLevelClick(evt:MouseEvent) : void
      {
         var index:int = int((evt.currentTarget as MovieClip).name.split("_")[1]);
         if(this._currentPanel == this._petListPanel)
         {
            this._petListPanel.dispose();
            if(index <= 5)
            {
               this._petListPanel.setData(PetDictionaryDataServer.getPetsByLevel(index + 1));
            }
            else
            {
               this._petListPanel.setData(PetDictionaryDataServer.getAllPets());
            }
         }
         if(this._currentPanel == this._thisWeekPanel)
         {
            this._thisWeekPanel.dispose();
            if(index <= 5)
            {
               this._thisWeekPanel.setData(PetDictionaryDataServer.getPetsByLevel(index + 1));
            }
            else
            {
               this._thisWeekPanel.setData(PetDictionaryDataServer.getAllPets());
            }
         }
      }
      
      private function onPetLevelClose(evt:MouseEvent) : void
      {
         var i:int = 0;
         evt.stopImmediatePropagation();
         for(i = 0; i < 5; )
         {
            (this._petLevel["petLevel_" + i] as MovieClip).removeEventListener("rollOver",this.onLevelOver);
            (this._petLevel["petLevel_" + i] as MovieClip).removeEventListener("click",this.onLevelClick);
            i++;
         }
         (this._petLevel["back"] as SimpleButton).removeEventListener("click",this.onPetLevelClose);
         this._petLevel.gotoAndStop(1);
      }
      
      protected function onShuxingBtn(event:MouseEvent = null) : void
      {
         trace("[hello]--[_shuxingBtn.x = " + this._shuxingBtn.x + "]");
         if(this._isPropertySearchOn)
         {
            this._isPropertySearchOn = !this._isPropertySearchOn;
            if(Boolean(this._propertySearch) && Boolean(this._propertySearch.parent))
            {
               this._propertySearch.parent.removeChild(this._propertySearch);
            }
         }
         else
         {
            this._isPropertySearchOn = !this._isPropertySearchOn;
            addChild(this._propertySearch);
            this._propertySearch.x = -100;
            this._propertySearch.y = 50;
            if(this._petLevel.currentFrame == 2)
            {
               this._petLevel.gotoAndStop(1);
            }
         }
      }
      
      protected function onPetSkinTab(event:Event) : void
      {
         this.changeContent(this._petSkinPanel);
         this._petSkinPanel.x = 60;
         this._petSkinPanel.y = 135;
         this._petSkinPanel.setData(PetDictionaryDataServer.getAllSkins());
         this._tabBar.hideShineMc("train");
         this._isTrainShine = true;
      }
      
      protected function onCollectRewardTab(event:Event) : void
      {
         this.changeContent(this._collectRewardPanel);
         this._collectRewardPanel.x = 23;
         this._collectRewardPanel.y = 16;
         this._tabBar.hideShineMc("collect");
         this._isCollectShine = true;
      }
      
      protected function onThisWeekTab(event:Event) : void
      {
         this.changeContent(this._thisWeekPanel);
         this._thisWeekPanel.setData(NewPetDicThisWeekListConfig.getPetIDForDic());
         this._thisWeekPanel.x = 60;
         this._thisWeekPanel.y = 135;
      }
      
      protected function onPetListTab(event:Event) : void
      {
         this.changeContent(this._petListPanel);
         this._petListPanel.setData(PetDictionaryDataServer.getAllPets());
         this._petListPanel.x = 60;
         this._petListPanel.y = 135;
      }
      
      private function changeContent(content:Sprite) : void
      {
         DisplayObjectUtil.removeAllChildren(this._contentPanel);
         this._contentPanel.addChild(content);
         this._currentPanel = content;
         this.disposePageBar();
         _mainUI["search"].visible = this._currentPanel == this._petListPanel ? true : false;
      }
      
      private function disposePageBar() : void
      {
         if(this._currentPanel == this._petListPanel)
         {
            this._thisWeekPanel.dispose();
         }
         else if(this._currentPanel == this._thisWeekPanel)
         {
            this._petListPanel.dispose();
         }
         else
         {
            this._petListPanel.dispose();
            this._thisWeekPanel.dispose();
         }
      }
      
      override public function hide() : void
      {
         this.disposePageBar();
         this._initTabIndex = 0;
         this._showNewPetId = 0;
         this._isCollectShine = false;
         this._isTrainShine = false;
         super.hide();
         if(this._isPropertySearchOn)
         {
            this.onShuxingBtn();
         }
      }
   }
}
