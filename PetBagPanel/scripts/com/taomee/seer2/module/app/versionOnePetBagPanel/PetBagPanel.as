package com.taomee.seer2.module.app.versionOnePetBagPanel
{
   import com.greensock.TweenNano;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.skill.PetSkillSettingDefinition;
   import com.taomee.seer2.app.controls.MapTitlePanel;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.inventory.events.ItemEvent;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.net.Command;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.pet.data.PetItemInfo;
   import com.taomee.seer2.app.pet.events.PetInfoEvent;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.app.utils.PetUtil;
   import com.taomee.seer2.core.module.Module;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.module.app.petBag.data.PetBagDataService;
   import com.taomee.seer2.module.app.petBag.event.PetBagEvent;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel.selectSkillPanel.GraspHideSkillPanel;

   import flash.utils.IDataInput;
   
   public class PetBagPanel extends Module
   {
      private var _petDemoPanel:PetDemoPanel;
      
      private var _petListPanel:PetListPanel;
      
      private var _petTabPanel:PetTabPanel;
      
      private var _dataService:PetBagDataService;
      
      private var _currPetInfo:PetInfo;
      
      public function PetBagPanel()
      {
         super();
         _lifecycleType = "global";
      }
      
      override public function setup() : void
      {
         setMainUI(new PetBagBgUI());
         this.initSet();
         this.initEvent();
      }
      
      override public function init(data:Object) : void
      {
         var type:int = 0;
         var subType:int = 0;
         if(Boolean(data))
         {
            type = int(data.type);
            subType = int(data.subType);
            this._petTabPanel.changeTab(type);
            TweenNano.delayedCall(0.1,function():void
            {
               _petTabPanel.changeCurPanelTab(type,subType);
            });
         }
      }
      
      override public function show() : void
      {
         super.show();
         StatisticsManager.sendNovice("0x10033859");
         ItemManager.addEventListener1("requestSpecialItemSuccess",this.onSeer);
         ItemManager.requestSpecialItemList();
      }
      
      override public function hide() : void
      {
         PetInfoManager.removeEventListener("petFightItem",this.petFightItem);
         this._dataService.clearEventListener();
         MapTitlePanel.show();
         super.hide();
         LayerManager.resetOperation();
      }
      
      private function initSet() : void
      {
         this._petDemoPanel = new PetDemoPanel();
         addChild(this._petDemoPanel);
         this._petDemoPanel.x = 284;
         this._petDemoPanel.y = 100;
         this._petListPanel = new PetListPanel();
         addChild(this._petListPanel);
         this._petListPanel.x = 52;
         this._petListPanel.y = 74;
         this._petTabPanel = new PetTabPanel(this);
         addChild(this._petTabPanel);
         this._dataService = new PetBagDataService();
      }
      
      private function initEvent() : void
      {
         this._petListPanel.addEventListener("petSelected",this.onPetSelected);
         this._dataService.addEventListener("petAddedHp",this.onPetAddedHp);
         Connection.addCommandListener(Command.getCommand(1215),this.onPetAddedHp2);
         this._dataService.addEventListener("petDataChange",this.onPetDataChange);
         this._dataService.addEventListener("petTrainingError",this.onPetTrainingError);
      }
      
      private function onPetAddedHp(e:PetBagEvent) : void
      {
         e.stopPropagation();
         this._petListPanel.updateDisplay();
         this._petDemoPanel.showHpAnnimation(e.petInfo);
      }
      
      private function onPetAddedHp2(e:MessageEvent) : void
      {
         this._petListPanel.updateDisplay();
         this._petDemoPanel.showHpAnnimation();
      }
      
      private function onPetDataChange(e:PetBagEvent) : void
      {
         this.updatePanel();
      }
      
      private function onPetTrainingError(e:PetBagEvent) : void
      {
         e.stopPropagation();
         this._petDemoPanel.updateButtonStatus();
      }
      
      private function onPetSelected(e:PetBagEvent) : void
      {
         e.stopPropagation();
         this._currPetInfo = e.petInfo;
         if(this._currPetInfo.level >= 60 && this.getPetHideSkillCount(this._currPetInfo) && this._currPetInfo.resourceId != 91 && this.getPetHideCount(this._currPetInfo) > 0)
         {
            this.checkBuff();
         }
         else
         {
            this._petDemoPanel.setData(this._currPetInfo);
            this._petTabPanel.setData(this._currPetInfo);
         }
      }
      
      private function getPetHideSkillCount(petInfo:PetInfo) : Boolean
      {
         if(PetUtil.getMaxStatusPet(petInfo.bunchId).resId == petInfo.resourceId)
         {
            return true;
         }
         return false;
      }
      
      private function getPetHideCount(petInfo:PetInfo) : uint
      {
         var skillInfo:PetSkillSettingDefinition = null;
         var count:uint = 0;
         for each(skillInfo in PetConfig.getPetSkillSettingDefinitionVec(petInfo.bunchId))
         {
            if(skillInfo.learningLv > 100)
            {
               count++;
            }
         }
         return count;
      }
      
      private function checkBuff() : void
      {
         ServerBufferManager.getServerBuffer(76,this.onUpdateServerBuf);
      }
      
      private function onUpdateServerBuf(ser:ServerBuffer) : void
      {
         GraspHideSkillPanel.newGuideOpen = false;
         this._petDemoPanel.setData(this._currPetInfo);
         this._petTabPanel.setData(this._currPetInfo);
      }
      
      public function updatePetInfoByPetInfoChange(curPetInfo:PetInfo) : void
      {
         this._currPetInfo = curPetInfo;
         this.updatePanel();
      }
      
      private function updatePanel() : void
      {
         this._petListPanel.setData(this._dataService.petInfoVec,this._dataService.petInfoStorageVec);
         this._petDemoPanel.setData(this._currPetInfo);
         if(Boolean(this._currPetInfo))
         {
            this._petTabPanel.setData(this._currPetInfo);
         }
      }
      
      private function onSeer(e:ItemEvent) : void
      {
         ItemManager.removeEventListener1("requestSpecialItemSuccess",this.onSeer);
         this.getPetItemList();
         PetInfoManager.addEventListener("petFightItem",this.petFightItem);
         LayerManager.focusOnUILayer();
      }
      
      private function getPetItemList() : void
      {
         Connection.addCommandListener(CommandSet.GET_PET_ITEM_INFO_1234,this.onGetPetItemList);
         Connection.send(CommandSet.GET_PET_ITEM_INFO_1234);
      }
      
      private function petFightItem(e:PetInfoEvent) : void
      {
         if(this._petDemoPanel.petInfo.catchTime == e.info.catchTime)
         {
            this._petDemoPanel.setData(e.info);
         }
      }
      
      private function onGetPetItemList(e:MessageEvent) : void
      {
         var petInfo:PetInfo = null;
         var count:uint = 0;
         var i:int = 0;
         Connection.removeCommandListener(CommandSet.GET_PET_ITEM_INFO_1234,this.onGetPetItemList);
         var data:IDataInput = e.message.getRawData();
         var petList:Vector.<PetInfo> = PetInfoManager.getAllBagPetInfo();
         for each(petInfo in petList)
         {
            petInfo.itemList = new Vector.<PetItemInfo>();
         }
         count = uint(data.readUnsignedInt());
         for(i = 0; i < count; )
         {
            this.updatePetItem(data);
            i++;
         }
         this.reset();
         this.updatePanel();
      }
      
      private function updatePetItem(data:IDataInput) : void
      {
         var petInfo:PetInfo = null;
         var count:uint = 0;
         var petItemInfo:PetItemInfo = null;
         var i:int = 0;
         var petId:uint = uint(data.readUnsignedInt());
         var petList:Vector.<PetInfo> = PetInfoManager.getAllBagPetInfo();
         for each(petInfo in petList)
         {
            if(petInfo.catchTime == petId)
            {
               count = uint(data.readUnsignedInt());
               for(i = 0; i < count; )
               {
                  (petItemInfo = new PetItemInfo()).itemId = data.readUnsignedInt();
                  petItemInfo.itemCurrCount = data.readUnsignedInt();
                  petInfo.itemList.push(petItemInfo);
                  i++;
               }
               return;
            }
         }
      }
      
      public function reset() : void
      {
         this._petListPanel.reset();
         this._petDemoPanel.reset();
         this._dataService.reloadEventListener();
      }
      
      public function updateSelectedPet() : void
      {
         this._petDemoPanel.updateDisplay();
         this._petListPanel.updateDisplay();
      }
   }
}
