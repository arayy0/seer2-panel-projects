package com.taomee.seer2.module.app.versionOnePetBagPanel
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.event.LogicEvent;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.pet.events.PetInfoEvent;
   import com.taomee.seer2.app.processor.quest.handler.main.quest99.QuestMapHandler_99_80491;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.app.vip.VipManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.events.ModelLocator;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.petBag.event.PetBagEvent;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.util.PetCell;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class PetListPanel extends Sprite
   {
       
      
      private const MAX_NUM:int = 12;
      
      private var _mainUI:MovieClip;
      
      private var _goBlood:SimpleButton;
      
      private var _goVipStore:SimpleButton;
      
      private var _newGuideMc:MovieClip;
      
      private var _newGuideMc1:MovieClip;
      
      private var _petCellVec:Vector.<PetCell>;
      
      private var _petInfoVec:Vector.<PetInfo>;
      
      private var _selectedPetInfo:PetInfo;
      
      public function PetListPanel()
      {
         super();
         this.initSet();
         this.initEvent();
      }
      
      private function initSet() : void
      {
         var cell:PetCell = null;
         this._mainUI = new PetListUI();
         this.addChild(this._mainUI);
         this._goBlood = this._mainUI["goBlood"];
         this._goVipStore = this._mainUI["goVipStore"];
         this._newGuideMc = this._mainUI["newGuideMc"];
         this._newGuideMc.visible = false;
         this._newGuideMc1 = this._mainUI["newGuideMc1"];
         this._newGuideMc1.visible = false;
         this._petCellVec = new Vector.<PetCell>();
         var i:int = 0;
         while(i < 12)
         {
            if(i <= 5)
            {
               if(i == 0)
               {
                  cell = new PetCell(new PetCellResUI(),false,"first");
               }
               else
               {
                  cell = new PetCell(new PetCellResUI(),false,"fight");
               }
            }
            else
            {
               cell = new PetCell(new PetCellResUI(),false,"select");
               if(VipManager.vipInfo.level >= i - 6 && VipManager.vipInfo.leftDay > 0 || i <= 6)
               {
                  cell.openStateMC.visible = false;
               }
               else
               {
                  cell.openStateMC.visible = true;
                  cell.openStateMC.gotoAndStop(i - 6);
               }
            }
            if(i <= 5)
            {
               cell.scaleX = cell.scaleY = 0.95;
               if(i % 2 == 0)
               {
                  cell.x = 21;
               }
               else
               {
                  cell.x = 114;
               }
               cell.y = 24 + (Math.ceil((i + 1) / 2) - 1) * 93;
            }
            else
            {
               cell.scaleX = cell.scaleY = 0.65;
               if(i % 3 == 0)
               {
                  cell.x = 20;
               }
               else if(i % 3 == 1)
               {
                  cell.x = 79.8;
               }
               else
               {
                  cell.x = 139.6;
               }
               cell.y = 305 + (Math.ceil((i - 5) / 3) - 1) * 59;
            }
            this._mainUI.addChild(cell);
            this._petCellVec.push(cell);
            i++;
         }
      }
      
      private function initEvent() : void
      {
         this._goBlood.addEventListener("click",this.onGoBlood);
         this._goVipStore.addEventListener("click",this.onGoVipStore);
      }
      
      private function onGoBlood(evt:MouseEvent) : void
      {
         var needCoins:int = 0;
         var onPetCureSuccess:* = null;
         var onCancelCurePet:* = null;
         this.recoverAllPetBagPet();
      }
      
      private function onGoVipStore(evt:MouseEvent) : void
      {
         StatisticsManager.sendNovice("0x10033867");
         if(true)
         {
            ModuleManager.closeForName("NewPetBagPanel");
            ModuleManager.closeForName("PetBagPanel");
            ServerBufferManager.getServerBuffer(461,function(server:ServerBuffer):void
            {
               var isUseNew:Boolean = Boolean(server.readDataAtPostion(8));
               if(isUseNew)
               {
                  ModuleManager.showModule(URLUtil.getAppModule("NewPetStoragePanel"),"正在打开...");
               }
               else
               {
                  ModuleManager.showModule(URLUtil.getAppModule("PetStoragePanel"),"正在打开...");
               }
            });
         }
      }
      
      private function addPetInfoEventListener() : void
      {
         PetInfoManager.addEventListener("petPropertiesChange",this.onPetPropetiesChange);
      }
      
      private function removePetInfoEventListener() : void
      {
         PetInfoManager.removeEventListener("petPropertiesChange",this.onPetPropetiesChange);
      }
      
      private function onPetPropetiesChange(evt:PetInfoEvent) : void
      {
         var cell:PetCell = null;
         var i:uint = 0;
         while(i < this._petCellVec.length)
         {
            cell = this._petCellVec[i];
            if(cell.petInfo == evt.info)
            {
               cell.setPetInfo(evt.info);
               this._petInfoVec[i] = evt.info;
               break;
            }
            i++;
         }
      }
      
      private function sortPetInfoVec() : void
      {
         var petInfo:PetInfo = null;
         var len:int = int(this._petInfoVec.length);
         var i:int = 0;
         while(i < len)
         {
            petInfo = this._petInfoVec[i];
            if(Boolean(petInfo) && Boolean(petInfo.isStarting))
            {
               this._petInfoVec.splice(i,1);
               this._petInfoVec.unshift(petInfo);
               break;
            }
            i++;
         }
      }
      
      private function addCellEventListener(cell:PetCell) : void
      {
         cell.buttonMode = true;
         cell.addEventListener("click",this.onCellClick);
      }
      
      private function removeCellEventListener(cell:PetCell) : void
      {
         cell.buttonMode = false;
         cell.removeEventListener("click",this.onCellClick);
      }
      
      private function onCellClick(event:MouseEvent) : void
      {
         var cell:PetCell = event.currentTarget as PetCell;
         var petInfo:PetInfo = cell.petInfo;
         if(this._selectedPetInfo.catchTime != petInfo.catchTime)
         {
            this.selectedPetInfo = petInfo;
         }
      }
      
      private function clearAllCellEventListener() : void
      {
         var cell:PetCell = null;
         for each(cell in this._petCellVec)
         {
            this.removeCellEventListener(cell);
         }
      }
      
      private function updatePetCell() : void
      {
         var cell:PetCell = null;
         var info:PetInfo = null;
         var i:uint = 0;
         while(i < 12)
         {
            cell = this._petCellVec[i];
            if(i < this._petInfoVec.length)
            {
               info = this._petInfoVec[i];
               this.addCellEventListener(cell);
               cell.setPetInfo(info);
            }
            else
            {
               cell.setPetInfo(null);
            }
            i++;
         }
      }
      
      private function selectPetCell() : void
      {
         if(this._petInfoVec.length == 0)
         {
            return;
         }
         this.selectedPetInfo = this._petInfoVec[0];
      }
      
      private function set selectedPetInfo(value:PetInfo) : void
      {
         var petCell:PetCell = null;
         var petInfo:PetInfo = null;
         this._selectedPetInfo = value;
         var i:int = 0;
         while(i < 12)
         {
            petCell = this._petCellVec[i];
            petInfo = petCell.petInfo;
            if(Boolean(petInfo) && petInfo.catchTime == this._selectedPetInfo.catchTime)
            {
               petCell.selected = true;
            }
            else
            {
               petCell.selected = false;
            }
            i++;
         }
         dispatchEvent(new PetBagEvent("petSelected",this._selectedPetInfo));
      }
      
      public function setData(petInfoVec:Vector.<PetInfo>, petStorageInfoVec:Vector.<PetInfo>) : void
      {
         this._petInfoVec = Vector.<PetInfo>([null,null,null,null,null,null,null,null,null,null,null,null]);
         var hasPet:Boolean = false;
         var i:int = 0;
         while(i < 6)
         {
            if(petInfoVec.length - 1 >= i)
            {
               this._petInfoVec[i] = petInfoVec[i];
               hasPet = true;
            }
            i++;
         }
         i = 6;
         while(i < 12)
         {
            if(Boolean(petStorageInfoVec) && petStorageInfoVec.length - 1 >= i - 6)
            {
               this._petInfoVec[i] = petStorageInfoVec[i - 6];
               hasPet = true;
            }
            i++;
         }
         if(hasPet)
         {
            this.addPetInfoEventListener();
         }
         this.sortPetInfoVec();
         this.updateDisplay();
         this.selectPetCell();
      }
      
      public function updateDisplay() : void
      {
         this.clearAllCellEventListener();
         this.updatePetCell();
         this.updateGuide();
         this.updateGuide1();
      }
      
      private function updateGuide() : void
      {
         this._newGuideMc.visible = false;
         if(Boolean(QuestManager.isAccepted(99)) && !QuestManager.isStepComplete(99,3) && Boolean(QuestMapHandler_99_80491.isClickQuest99_3))
         {
            this._newGuideMc.visible = true;
            this._mainUI.addChild(this._newGuideMc);
            this._newGuideMc.removeEventListener("click",this.onGuideClick);
            this._newGuideMc.addEventListener("click",this.onGuideClick);
         }
      }
      
      private function updateGuide1() : void
      {
         this._newGuideMc1.visible = false;
         if(Boolean(QuestManager.isAccepted(99)) && !QuestManager.isStepComplete(99,6) && Boolean(QuestMapHandler_99_80491.isClickQuest99_6))
         {
            this._newGuideMc1.visible = true;
            this._mainUI.addChild(this._newGuideMc1);
            this._newGuideMc1.removeEventListener("click",this.onGuideClick1);
            this._newGuideMc1.addEventListener("click",this.onGuideClick1);
         }
      }
      
      private function onGuideClick(evt:MouseEvent) : void
      {
         this._newGuideMc.removeEventListener("click",this.onGuideClick);
         this._newGuideMc.visible = false;
         var targetInfo:PetInfo = this.getPetInfoById(7);
         if(Boolean(targetInfo))
         {
            this.selectedPetInfo = targetInfo;
            ModelLocator.getInstance().dispatchEvent(new LogicEvent("newGuideBroad2"));
         }
      }
      
      private function onGuideClick1(evt:MouseEvent) : void
      {
         this._newGuideMc1.removeEventListener("click",this.onGuideClick1);
         this._newGuideMc1.visible = false;
         var targetInfo:PetInfo = this.getPetInfoById(824);
         if(Boolean(targetInfo))
         {
            this.selectedPetInfo = targetInfo;
            ModelLocator.getInstance().dispatchEvent(new LogicEvent("newGuideBroad7"));
         }
      }
      
      private function getPetInfoById(resId:int) : PetInfo
      {
         var info:PetInfo = null;
         var result:* = null;
         for each(info in PetInfoManager.getAllBagPetInfo())
         {
            if(info.resourceId == resId)
            {
               result = info;
               break;
            }
         }
         return result;
      }
      
      public function reset() : void
      {
         var len:int = int(this._petCellVec.length);
         var i:int = 0;
         while(i < len)
         {
            this._petCellVec[i].reset();
            i++;
         }
         this.removePetInfoEventListener();
      }
      
      private function recoverAllPetBagPet() : void
      {
         Connection.addCommandListener(CommandSet.TREAT_ALL_PET_1215,this.onAddAllPetBlood);
         Connection.send(CommandSet.TREAT_ALL_PET_1215);
      }
      
      private function onAddAllPetBlood(event:MessageEvent) : void
      {
         var petInfo:PetInfo = null;
         var newCoinNum:int = 0;
         Connection.removeCommandListener(CommandSet.TREAT_ALL_PET_1215,this.onAddAllPetBlood);
         var petInfoVec:Vector.<PetInfo> = PetInfoManager.getAllBagPetInfo();
         for each(petInfo in petInfoVec)
         {
            petInfo.hp = petInfo.maxHp;
            PetInfoManager.dispatchEvent("petPropertiesChange",petInfo);
         }
         newCoinNum = int(event.message.getRawData().readUnsignedInt());
         ActorManager.actorInfo.coins = newCoinNum;
      }
   }
}
