package com.taomee.seer2.module.app.petStorage.data
{
   import com.taomee.seer2.app.config.PetRideShopConfig;
   import com.taomee.seer2.app.home.data.TrainingPetInfo;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.pet.events.PetInfoEvent;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.module.app.petStorage.PetStorageTreasureHelper;
   import com.taomee.seer2.module.app.petStorage.event.PetStorageEvent;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   
   public class PetStorageDataService extends EventDispatcher
   {
      
      private static const SET_FREE_FLAG:int = 1;
      
      private static const PUT_TO_BAG_FLAG:int = 1;
       
      
      private var _storageInfoVec:Vector.<PetInfo>;
      
      private var _freeInfoVec:Vector.<PetInfo>;
      
      private var _currentInfoVec:Vector.<PetInfo>;
      
      private var _currentQuery:PetStorageQuery;
      
      private var _currentCallBack:Function;
      
      private var _includeBagPet:Boolean;
      
      private var _customFilter:Function;
      
      public function PetStorageDataService()
      {
         super();
      }
      
      public function set includeBagPet(value:Boolean) : void
      {
         this._includeBagPet = value;
      }
      
      public function setCustomFilter(func:Function) : void
      {
         this._customFilter = func;
      }
      
      public function queryPetList(query:PetStorageQuery, callBack:Function) : void
      {
         this._currentQuery = query;
         this._currentCallBack = callBack;
         if(query.dataType == 0)
         {
            this.queryStoragePetList();
         }
         else
         {
            this.queryFreePetList();
         }
      }
      
      private function queryStoragePetList() : void
      {
         var i:int = 0;
         if(this._storageInfoVec == null)
         {
            this._storageInfoVec = new Vector.<PetInfo>();
            if(this._includeBagPet)
            {
               for(i = 0; i < PetInfoManager.getTotalBagPetInfo().length; )
               {
                  this._storageInfoVec.push(PetInfoManager.getTotalBagPetInfo()[i]);
                  i++;
               }
            }
            PetInfoManager.getStoragePetInfos(this.onGetStorageList,true);
         }
         else
         {
            this.processQuery();
         }
      }
      
      private function onGetStorageList(petInfos:Vector.<PetInfo>) : void
      {
         var i:* = 0;
         var len:uint = petInfos.length;
         for(i = 0; i < len; )
         {
            this._storageInfoVec.push(petInfos[i]);
            i++;
         }
         this.processQuery();
      }
      
      private function queryFreePetList() : void
      {
         if(this._freeInfoVec == null)
         {
            Connection.addCommandListener(CommandSet.PET_GET_FREE_LIST_1022,this.onGetFreeList);
            Connection.send(CommandSet.PET_GET_FREE_LIST_1022);
         }
         else
         {
            this.processQuery();
         }
      }
      
      private function onGetFreeList(event:MessageEvent) : void
      {
         var i:int = 0;
         var info:PetInfo = null;
         Connection.removeCommandListener(CommandSet.PET_GET_FREE_LIST_1022,this.onGetFreeList);
         var data:LittleEndianByteArray = event.message.getRawData();
         var count:int = int(data.readUnsignedInt());
         this._freeInfoVec = new Vector.<PetInfo>();
         for(i = 0; i < count; )
         {
            info = new PetInfo();
            PetInfo.readBaseSimpleInfo(info,data);
            PetInfo.readFreeTime(info,data);
            info.evolveLevel = data.readUnsignedInt();
            this._freeInfoVec.push(info);
            i++;
         }
         this.processQuery();
      }
      
      private function processQuery() : void
      {
         if(this._currentQuery.dataType == 0)
         {
            this._currentInfoVec = this._storageInfoVec.slice();
         }
         else if(this._currentQuery.dataType == 1)
         {
            this._currentInfoVec = this._freeInfoVec.slice();
         }
         this.filterInfoVec();
         this.sortInfoVec();
         this.handlerCallBack();
      }
      
      private function filterInfoVec() : void
      {
         switch(this._currentQuery.filterType)
         {
            case 1:
               this.filterInfoVecByResourceId(this._currentQuery.filterContent);
               break;
            case 2:
               this.filterInfoVecByPetName(this._currentQuery.filterContent);
               break;
            case 0:
               this.filterInfoVecByPetType(this._currentQuery.filterContent);
               break;
            case 10000:
               this.filterInfoVecByPetRide();
               break;
            case 4:
               this.filterInfoVecByCustom();
         }
      }
      
      private function filterInfoVecByCustom() : void
      {
         var i:int = 0;
         var length:int = int(this._currentInfoVec.length);
         for(i = length - 1; i >= 0; )
         {
            if(this._customFilter(this._currentInfoVec[i]))
            {
               this._currentInfoVec.splice(i,1);
            }
            i--;
         }
      }
      
      private function filterInfoVecByResourceId(resourceId:int) : void
      {
         var i:int = 0;
         var length:int = int(this._currentInfoVec.length);
         for(i = length - 1; i >= 0; )
         {
            if(this._currentInfoVec[i].resourceId != resourceId)
            {
               this._currentInfoVec.splice(i,1);
            }
            i--;
         }
      }
      
      private function filterInfoVecByPetName(petName:String) : void
      {
         var i:int = 0;
         var length:int = int(this._currentInfoVec.length);
         for(i = length - 1; i >= 0; )
         {
            if(this._currentInfoVec[i].name.indexOf(petName) == -1)
            {
               this._currentInfoVec.splice(i,1);
            }
            i--;
         }
      }
      
      private function filterInfoVecByPetType(petType:int) : void
      {
         var i:int = 0;
         var length:int = int(this._currentInfoVec.length);
         for(i = length - 1; i >= 0; )
         {
            if(this._currentInfoVec[i].type != petType)
            {
               this._currentInfoVec.splice(i,1);
            }
            i--;
         }
      }
      
      private function filterInfoVecByPetRide() : void
      {
         var i:int = 0;
         var length:int = int(this._currentInfoVec.length);
         for(i = length - 1; i >= 0; )
         {
            if(PetRideShopConfig.isCanRidePet(this._currentInfoVec[i].resourceId) == false)
            {
               this._currentInfoVec.splice(i,1);
            }
            i--;
         }
      }
      
      private function sortInfoVec() : void
      {
         switch(this._currentQuery.sortType)
         {
            case 0:
               this._currentInfoVec.sort(this.sortByCatchTime);
               break;
            case 1:
               this._currentInfoVec.sort(this.sortByFreeTime);
               break;
            case 2:
               this._currentInfoVec.sort(this.sortByPetLevel);
               break;
            case 3:
               this.sortTreasureTime();
         }
         if(this._currentQuery.sortType != 3 && this._currentQuery.isAscending == false)
         {
            this._currentInfoVec.reverse();
         }
      }
      
      private function sortByCatchTime(a:PetInfo, b:PetInfo) : int
      {
         if(a.catchTime < b.catchTime)
         {
            return -1;
         }
         if(a.catchTime > b.catchTime)
         {
            return 1;
         }
         return 0;
      }
      
      private function sortByFreeTime(a:PetInfo, b:PetInfo) : int
      {
         if(a.freeTime < b.freeTime)
         {
            return -1;
         }
         if(a.freeTime > b.freeTime)
         {
            return 1;
         }
         return 0;
      }
      
      private function sortByPetLevel(a:PetInfo, b:PetInfo) : int
      {
         if(a.level > b.level)
         {
            return -1;
         }
         if(a.level < b.level)
         {
            return 1;
         }
         return 0;
      }
      
      private function sortTreasureTime() : void
      {
         var petInfo:PetInfo = null;
         var treasuredVec:Vector.<PetInfo> = new Vector.<PetInfo>();
         var untreasuredVec:Vector.<PetInfo> = new Vector.<PetInfo>();
         for each(petInfo in this._currentInfoVec)
         {
            if(petInfo.treasureTime > 0)
            {
               treasuredVec.push(petInfo);
            }
            else
            {
               untreasuredVec.push(petInfo);
            }
         }
         untreasuredVec.sort(this.sortByCatchTime);
         untreasuredVec.reverse();
         this._currentInfoVec = treasuredVec.concat(untreasuredVec);
      }
      
      private function handlerCallBack() : void
      {
         if(this._currentCallBack != null)
         {
            this._currentCallBack(this._currentInfoVec);
            this._currentCallBack = null;
         }
      }
      
      public function getInfoVec() : Vector.<PetInfo>
      {
         return this._currentInfoVec;
      }
      
      public function get storageLength() : int
      {
         if(this._storageInfoVec != null)
         {
            return this._storageInfoVec.length;
         }
         return 0;
      }
      
      public function get freeLength() : int
      {
         if(this._freeInfoVec != null)
         {
            return this._freeInfoVec.length;
         }
         return 0;
      }
      
      public function reset() : void
      {
         this.addCommandListeners();
         PetStorageTreasureHelper.reset(this);
      }
      
      public function clear() : void
      {
         this.removeCommandListeners();
         this._storageInfoVec = null;
         this._freeInfoVec = null;
         this._currentInfoVec = null;
         PetStorageTreasureHelper.clear();
      }
      
      private function addCommandListeners() : void
      {
         Connection.addCommandListener(CommandSet.PET_SET_FREE_STATUS_1021,this.onSetFreeStatus);
         Connection.addCommandListener(CommandSet.PET_TRAINING_START_1039,this.onStartTrainingPet);
         PetInfoManager.addEventListener("petPutToBag",this.onPetPutToBag);
         PetInfoManager.addEventListener("petPutToBagStorage",this.onPetPutToBag);
         PetInfoManager.addEventListener("petPutToStorage",this.onPetPutToStorage);
      }
      
      private function removeCommandListeners() : void
      {
         Connection.removeCommandListener(CommandSet.PET_SET_FREE_STATUS_1021,this.onSetFreeStatus);
         Connection.removeCommandListener(CommandSet.PET_TRAINING_START_1039,this.onStartTrainingPet);
         PetInfoManager.removeEventListener("petPutToBag",this.onPetPutToBag);
         PetInfoManager.removeEventListener("petPutToBagStorage",this.onPetPutToBag);
         PetInfoManager.removeEventListener("petPutToStorage",this.onPetPutToStorage);
      }
      
      private function onSetFreeStatus(event:MessageEvent) : void
      {
         var data:ByteArray;
         var petId:uint = (data = event.message.getRawDataCopy()).readUnsignedInt();
         var flag:int = int(data.readUnsignedByte());
         var freeTime:uint = data.readUnsignedInt();
         if(flag == 1)
         {
            this.movePetStroageSimpleInfoById(this._storageInfoVec,this._freeInfoVec,petId,freeTime);
         }
         else
         {
            this.movePetStroageSimpleInfoById(this._freeInfoVec,this._storageInfoVec,petId,freeTime);
         }
         this.dispatchDataChange();
      }
      
      private function onPetPutToBag(evt:PetInfoEvent) : void
      {
         var petId:uint = uint(evt.info.catchTime);
         this.removeFromStorageVec(petId);
         this.dispatchDataChange();
      }
      
      private function onPetPutToStorage(evt:PetInfoEvent) : void
      {
         var petInfo:PetInfo = evt.info;
         this._storageInfoVec.push(petInfo);
         this.dispatchDataChange();
      }
      
      private function onStartTrainingPet(event:MessageEvent) : void
      {
         var data:ByteArray = event.message.getRawDataCopy();
         var startingtPetId:uint = data.readUnsignedInt();
         var info:TrainingPetInfo = new TrainingPetInfo(data);
         this.removeFromStorageVec(info.id);
         this.dispatchDataChange();
      }
      
      private function movePetStroageSimpleInfoById(source:Vector.<PetInfo>, destination:Vector.<PetInfo>, petId:uint, freeTime:uint) : void
      {
         var i:int = 0;
         var info:PetInfo = null;
         for(i = int(source.length) - 1; i >= 0; i--)
         {
            if((info = source[i]).catchTime == petId)
            {
               source.splice(i,1);
               break;
            }
         }
         info.freeTime = freeTime;
         if(destination != null)
         {
            destination.push(info);
         }
      }
      
      private function removeFromStorageVec(petId:uint) : void
      {
         var i:int = 0;
         var info:PetInfo = null;
         var len:int = int(this._storageInfoVec.length);
         for(i = len - 1; i >= 0; )
         {
            if((info = this._storageInfoVec[i]).catchTime == petId)
            {
               this._storageInfoVec.splice(i,1);
               break;
            }
            i--;
         }
      }
      
      public function isInStorage(catchTime:uint) : Boolean
      {
         var i:int = 0;
         if(this._storageInfoVec == null)
         {
            return false;
         }
         i = 0;
         while(i < this._storageInfoVec.length)
         {
            if(this._storageInfoVec[i].catchTime == catchTime)
            {
               return true;
            }
            i++;
         }
         return false;
      }
      
      public function isInFreeList(catchTime:uint) : Boolean
      {
         var i:int = 0;
         if(this._freeInfoVec == null)
         {
            return false;
         }
         i = 0;
         while(i < this._freeInfoVec.length)
         {
            if(this._freeInfoVec[i].catchTime == catchTime)
            {
               return true;
            }
            i++;
         }
         return false;
      }
      
      public function updateTreasureTime(catchTime:uint, treasureTime:uint) : void
      {
         var petInfo:PetInfo = null;
         for each(petInfo in this._storageInfoVec)
         {
            if(petInfo.catchTime == catchTime)
            {
               petInfo.treasureTime = treasureTime;
               this.dispatchDataChange();
               break;
            }
         }
      }

      public function resetFreeList():void
      {
         this._freeInfoVec = null;
         this.queryFreePetList();
      }
      
      private function dispatchDataChange() : void
      {
         this.processQuery();
         dispatchEvent(new PetStorageEvent("petStorageDataChange"));
      }
   }
}
