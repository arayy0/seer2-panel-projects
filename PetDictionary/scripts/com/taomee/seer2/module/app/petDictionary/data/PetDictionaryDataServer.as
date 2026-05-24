package com.taomee.seer2.module.app.petDictionary.data
{
   import com.taomee.seer2.app.config.NewPetDicThisWeekListConfig;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.info.PetDictionaryInfo;
   import com.taomee.seer2.app.config.pet.PetDefinition;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.manager.OnlyFlagManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.module.app.petDictionary.config.PetDictionaryConfig;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.SuitRewardInfo;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.TrainRewardInfo;
   import flash.utils.ByteArray;
   import org.taomee.ds.HashMap;
   
   public class PetDictionaryDataServer
   {
      
      public static const PAGE_SIZE:int = 12;
      
      public static var petGainedNum:uint;
      
      private static var _petDictionaryMap:HashMap;
      
      private static var _onGetPetDictionary:Function;
      
      private static var _onGetRewardStatus:Function;
      
      private static var _onGetReward:Function;
      
      private static var _onGetGiftStatus:Function;
      
      public static const thisWeekPets:Vector.<int> = NewPetDicThisWeekListConfig.getPetIDForDic();
       
      
      public function PetDictionaryDataServer()
      {
         super();
      }
      
      public static function getDataFromServer(onGetGiftStatusFun:Function, onGetPetDictionaryFun:Function, onGetRewardStatusFun:Function) : void
      {
         _onGetGiftStatus = onGetGiftStatusFun;
         _onGetPetDictionary = onGetPetDictionaryFun;
         _onGetRewardStatus = onGetRewardStatusFun;
         Connection.addCommandListener(CommandSet.PET_GET_DICTIONARY_LIST_1034,onGetPetDictionary);
         Connection.send(CommandSet.PET_GET_DICTIONARY_LIST_1034);
      }
      
      private static function onGetGiftStatus(evt:MessageEvent) : void
      {
         var index:uint = 0;
         var j:int = 0;
         Connection.removeCommandListener(CommandSet.GET_GIFT_CANGET_1124,onGetGiftStatus);
         var data:ByteArray = evt.message.getRawDataCopy();
         var count:uint = data.readUnsignedInt();
         var vec:Vector.<TrainRewardInfo> = PetDictionaryConfig.trainRewardVec;
         var i:int = 0;
         while(i < count)
         {
            index = data.readUnsignedInt();
            j = 0;
            while(j < vec.length)
            {
               if(vec[j].index == index)
               {
                  vec[j].status = 1;
               }
               j++;
            }
            i++;
         }
         OnlyFlagManager.RequestFlag(onGetRewardsStatus);
      }
      
      private static function onGetPetDictionary(evt:MessageEvent) : void
      {
         var resourceId:uint = 0;
         var flag:uint = 0;
         Connection.removeCommandListener(CommandSet.PET_GET_DICTIONARY_LIST_1034,onGetPetDictionary);
         _petDictionaryMap = new HashMap();
         var data:ByteArray;
         petGainedNum = (data = evt.message.getRawDataCopy()).readUnsignedInt();
         var count:uint = data.readUnsignedInt();
         var i:int = 0;
         while(i < count)
         {
            resourceId = data.readUnsignedInt();
            flag = data.readUnsignedByte();
            _petDictionaryMap.add(resourceId,flag);
            i++;
         }
         Connection.addCommandListener(CommandSet.GET_GIFT_CANGET_1124,onGetGiftStatus);
         Connection.send(CommandSet.GET_GIFT_CANGET_1124);
      }
      
      private static function onGetRewardsStatus() : void
      {
         var vec:Vector.<SuitRewardInfo> = null;
         var m:int = 0;
         var info:SuitRewardInfo = null;
         var trainInfo:TrainRewardInfo = null;
         var allSuitVec:Vector.<int> = PetDictionaryConfig.getAllSuitReward();
         var i:int = 0;
         while(i < allSuitVec.length)
         {
            vec = PetDictionaryConfig.getSuitRewardVec(allSuitVec[i]);
            m = 0;
            while(m < vec.length)
            {
               (info = vec[m]).flag = OnlyFlagManager.getFlag(info.onlyFlagIndex);
               m++;
            }
            i++;
         }
         PetDictionaryConfig.initPetRewardInfo.flag = OnlyFlagManager.getFlag(PetDictionaryConfig.initPetRewardInfo.onlyFlagIndex);
         PetDictionaryConfig.thirdPetRewardInfo.flag = OnlyFlagManager.getFlag(PetDictionaryConfig.thirdPetRewardInfo.onlyFlagIndex);
         var obj:Vector.<TrainRewardInfo> = new Vector.<TrainRewardInfo>();
         var j:int = 0;
         while(j < PetDictionaryConfig.trainRewardVec.length)
         {
            trainInfo = PetDictionaryConfig.trainRewardVec[j];
            trainInfo.flag = OnlyFlagManager.getFlag(trainInfo.onlyFlagIndex);
            obj.push(trainInfo);
            j++;
         }
         _onGetGiftStatus();
         _onGetGiftStatus = null;
         _onGetPetDictionary();
         _onGetPetDictionary = null;
         _onGetRewardStatus();
         _onGetRewardStatus = null;
      }
      
      public static function getRewardByIndex(index:int, onGetRewardFun:Function) : void
      {
         _onGetReward = onGetRewardFun;
         Connection.addCommandListener(CommandSet.GET_REWARDS_HANDBOOK_1036,onGetRewards);
         Connection.send(CommandSet.GET_REWARDS_HANDBOOK_1036,index);
      }
      
      private static function onGetRewards(evt:MessageEvent) : void
      {
         var itemID:uint = 0;
         var count:uint = 0;
         var resouceId:uint = 0;
         var id:uint = 0;
         Connection.removeCommandListener(CommandSet.GET_REWARDS_HANDBOOK_1036,onGetRewards);
         if(_onGetReward != null)
         {
            _onGetReward();
            _onGetReward = null;
         }
         var data:ByteArray = evt.message.getRawDataCopy();
         var itemCount:uint = data.readUnsignedInt();
         var i:int = 0;
         while(i < itemCount)
         {
            itemID = data.readUnsignedInt();
            count = data.readUnsignedInt();
            ItemManager.addItem(itemID,count,0);
            AlertManager.showItemGainedAlert(itemID,count);
            i++;
         }
         var petCount:uint = data.readUnsignedInt();
         var j:int = 0;
         while(j < petCount)
         {
            resouceId = data.readUnsignedInt();
            id = data.readUnsignedInt();
            PetInfoManager.requestAddToBagFromStorage(id,resouceId);
            j++;
         }
      }
      
      public static function getPetListByPageIndex(index:uint) : Vector.<int>
      {
         var offset:int = (index - 1) * 12 + 1;
         var petResouceVec:Vector.<int> = new Vector.<int>();
         var i:* = offset;
         while(i < offset + 12)
         {
            petResouceVec.push(i);
            i++;
         }
         return petResouceVec;
      }
      
      public static function getPetFlag(resourceID:int) : int
      {
         if(Boolean(_petDictionaryMap) && Boolean(_petDictionaryMap.containsKey(resourceID)))
         {
            return _petDictionaryMap.getValue(resourceID);
         }
         return 0;
      }
      
      public static function getAllPets() : Vector.<int>
      {
         var petDefinition:PetDefinition = null;
         var petDicInfo:PetDictionaryInfo = null;
         var pets:Vector.<int> = new Vector.<int>();
         pets.push(0);
         trace("总精灵长度:",PetConfig.getPetCount());
         var i:int = 1;
         while(i <= PetConfig.getPetCount())
         {
            if(i < 9999)
            {
               petDefinition = PetConfig.getPetDefinition(i);
               petDicInfo = PetConfig.getPetDefinitionInfo(i);
               if(Boolean(petDicInfo) && Boolean(petDefinition))
               {
                  pets.push(i);
               }
            }
            i++;
         }
         return pets;
      }

      public static function getAllSkins():Vector.<int>
      {
         var petDefinition:PetDefinition = null;
         var petDicInfo:PetDictionaryInfo = null;
         var pets:Vector.<int> = new Vector.<int>();
         pets.push(0);
         var i:int = 10000;
         while(i <= PetConfig.getPetCount())
         {
            petDefinition = PetConfig.getPetDefinition(i);
            petDicInfo = PetConfig.getPetDefinitionInfo(i);
            if(Boolean(petDicInfo) && Boolean(petDefinition))
            {
               pets.push(i);
            }
            i++;
         }
         return pets;
      }
      
      public static function getGainedPets() : Vector.<int>
      {
         var gained:Vector.<int> = new Vector.<int>();
         gained.push(0);
         var i:int = 1;
         while(i <= PetConfig.getPetCount())
         {
            if(getPetFlag(i) == 2)
            {
               gained.push(i);
            }
            i++;
         }
         return gained;
      }
      
      public static function getNotGainedPets() : Vector.<int>
      {
         var notgained:Vector.<int> = new Vector.<int>();
         notgained.push(0);
         var petDefinition:PetDefinition = null;
         var petDicInfo:PetDictionaryInfo = null;
         var i:int = 1;
         while(i <= 9999)
         {
            if(getPetFlag(i) != 2)
            {
               petDefinition = PetConfig.getPetDefinition(i);
               petDicInfo = PetConfig.getPetDefinitionInfo(i);
               if(Boolean(petDicInfo) && Boolean(petDefinition))
               {
                  notgained.push(i);
               }
            }
            i++;
         }
         return notgained;
      }
      
      public static function getPetsByLevel(level:int) : Vector.<int>
      {
         var result:Vector.<int> = new Vector.<int>();
         result.push(0);
         var i:int = 1;
         while(i <= PetConfig.getPetCount())
         {
            if(Boolean(PetConfig.getPetDefinition(i)) && Boolean(PetConfig.getPetDefinitionInfo(i)) && PetConfig.getPetDefinition(i).starLevel == level)
            {
               if(i < 9999)
               {
                  result.push(i);
               }
            }
            i++;
         }
         return result;
      }
      
      public static function getthisWeekGained() : Vector.<int>
      {
         var gained:Vector.<int> = new Vector.<int>();
         gained.push(0);
         var i:int = 0;
         while(i < thisWeekPets.length)
         {
            if(getPetFlag(thisWeekPets[i]) == 2)
            {
               gained.push(thisWeekPets[i]);
            }
            i++;
         }
         return gained;
      }
      
      public static function getthisWeekNotGained() : Vector.<int>
      {
         var notgained:Vector.<int> = new Vector.<int>();
         var i:int = 0;
         while(i < thisWeekPets.length)
         {
            if(getPetFlag(thisWeekPets[i]) != 2)
            {
               notgained.push(thisWeekPets[i]);
            }
            i++;
         }
         return notgained;
      }
      
      public static function getPageData(data:Vector.<int>, pageIndex:int) : Vector.<int>
      {
         var offset:int = (pageIndex - 1) * 12 + 1;
         var petResouceVec:Vector.<int> = new Vector.<int>();
         var i:* = offset;
         while(i < offset + 12)
         {
            petResouceVec.push(data[i]);
            i++;
         }
         return petResouceVec;
      }
   }
}
