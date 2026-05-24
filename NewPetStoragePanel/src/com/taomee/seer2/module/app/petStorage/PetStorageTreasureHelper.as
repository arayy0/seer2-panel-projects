package com.taomee.seer2.module.app.petStorage
{
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.module.app.petStorage.data.PetStorageDataService;
   import flash.utils.ByteArray;
   
   public class PetStorageTreasureHelper
   {
      
      public static const NONE:int = 0;
      
      public static const PROGRESS:int = 1;
      
      public static const FINISH:int = 2;
      
      private static var _dataService:PetStorageDataService;
       
      
      public function PetStorageTreasureHelper()
      {
         super();
      }
      
      public static function reset(dataService:PetStorageDataService) : void
      {
         _dataService = dataService;
      }
      
      public static function clear() : void
      {
         _dataService = null;
      }
      
      public static function treasureStart(catchTime:uint) : void
      {
         syncPetStorageTreasure(catchTime,0);
      }
      
      public static function treasureQuit(catchTime:uint) : void
      {
         syncPetStorageTreasure(catchTime,1);
      }
      
      public static function treasureFinish(catchTime:uint) : void
      {
         syncPetStorageTreasure(catchTime,2);
      }
      
      private static function syncPetStorageTreasure(catchTime:uint, type:int) : void
      {
         var data:LittleEndianByteArray = new LittleEndianByteArray();
         data.writeUnsignedInt(catchTime);
         data.writeByte(type);
         Connection.addCommandListener(CommandSet.PET_STORAGE_TREASURE_1130,onPetStorageTreasure);
         Connection.addErrorHandler(CommandSet.PET_STORAGE_TREASURE_1130,onPetStorageTreasureErr);
         Connection.send(CommandSet.PET_STORAGE_TREASURE_1130,data);
      }
      
      private static function onPetStorageTreasure(evt:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.PET_STORAGE_TREASURE_1130,onPetStorageTreasure);
         Connection.removeCommandListener(CommandSet.PET_STORAGE_TREASURE_1130,onPetStorageTreasureErr);
         var data:ByteArray;
         var catchTime:uint = (data = evt.message.getRawData()).readUnsignedInt();
         var flag:int = int(data.readUnsignedByte());
         var treasureTime:uint = data.readUnsignedInt();
         _dataService.updateTreasureTime(catchTime,treasureTime);
      }
      
      private static function onPetStorageTreasureErr(evt:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.PET_STORAGE_TREASURE_1130,onPetStorageTreasure);
         Connection.removeCommandListener(CommandSet.PET_STORAGE_TREASURE_1130,onPetStorageTreasureErr);
         switch(evt.message.statusCode)
         {
            case 66:
               AlertManager.showAlert("今天寻宝已经10次啦，明天再寻宝吧！");
               break;
            case 153:
               AlertManager.showAlert("今天已经有4个精灵在寻宝了！");
         }
      }
      
      public static function hasMeetPetTreasureLimit() : Boolean
      {
         var petInfo:PetInfo = null;
         var count:int = 0;
         for each(petInfo in _dataService.getInfoVec())
         {
            if(petInfo.treasureTime > 0)
            {
               count++;
            }
         }
         return count >= 4;
      }
      
      public static function getTreasureStatus(info:PetInfo) : int
      {
         if(info.treasureTime > 0)
         {
            if(getTreasureMinutes(info) >= 15)
            {
               return 2;
            }
            return 1;
         }
         return 0;
      }
      
      public static function getTreasureMinutes(info:PetInfo) : int
      {
         return (TimeManager.getServerTime() - info.treasureTime) / 60;
      }
   }
}
