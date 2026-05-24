package com.taomee.seer2.module.app.petDictionary.config
{
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.InitialPetRewardInfo;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.SuitInfo;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.SuitRewardInfo;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.ThirdPetRewardInfo;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.TrainRewardInfo;
   import org.taomee.ds.HashMap;
   
   public class PetDictionaryConfig
   {
      
      private static var _xmlClass:Class = PetDictionaryConfig__xmlClass;
      
      private static var _xml:XML;
      
      public static var trainRewardVec:Vector.<TrainRewardInfo>;
      
      public static var initPetRewardInfo:InitialPetRewardInfo;
      
      public static var thirdPetRewardInfo:ThirdPetRewardInfo;
      
      private static var _suitRewardMap:HashMap;
      
      private static var _suitMap:HashMap;
      
      {
         setup();
      }
      
      public function PetDictionaryConfig()
      {
         super();
      }
      
      public static function setup() : void
      {
         var xml:XML = null;
         var type:int = 0;
         trainRewardVec = new Vector.<TrainRewardInfo>();
         _suitRewardMap = new HashMap();
         _suitMap = new HashMap();
         _xml = XML(new _xmlClass());
         var xmlList:XMLList = _xml.descendants("HandBook");
         for each(xml in xmlList)
         {
            type = int(xml.attribute("type"));
            if(type == 1)
            {
               parserSuitReward(xml);
            }
            else if(type == 2)
            {
               parserInitialPetReward(xml);
            }
            else if(type == 3)
            {
               parserTrainReward(xml);
            }
            else if(type == 4)
            {
               parserThirdPetReward(xml);
            }
         }
      }
      
      private static function parserSuitReward(xml:XML) : void
      {
         var vec:Vector.<SuitRewardInfo> = null;
         var suitId:int = int(xml.attribute("SuitID"));
         var suiltInfo:SuitInfo;
         (suiltInfo = new SuitInfo()).suitName = xml.attribute("SuitName");
         var suitStr:String = xml.attribute("SuitVec");
         suiltInfo.suitVec = Vector.<int>(suitStr.split(" "));
         _suitMap.add(suitId,suiltInfo);
         if(_suitRewardMap.containsKey(suitId))
         {
            vec = _suitRewardMap.getValue(suitId);
         }
         else
         {
            vec = new Vector.<SuitRewardInfo>();
            _suitRewardMap.add(suitId,vec);
         }
         var info:SuitRewardInfo;
         (info = new SuitRewardInfo()).suitId = suitId;
         info.index = int(xml.attribute("Index"));
         info.onlyFlagIndex = int(xml.attribute("OnlyFlagIndex"));
         var petNumStr:String = xml.attribute("PetNumID");
         info.needPetVec = Vector.<int>(petNumStr.split(" "));
         var petIconStr:String = xml.attribute("PetIcon");
         info.neePetIconVec = Vector.<int>(petIconStr.split(" "));
         var itemXml:XML = xml.elements("Item")[0];
         info.rewardId = int(itemXml.attribute("ID"));
         info.rewardCount = int(itemXml.attribute("Count"));
         vec.push(info);
      }
      
      private static function parserInitialPetReward(xml:XML) : void
      {
         var itemXml:XML = null;
         var initialPetInfo:PetInfo = PetInfoManager.getInitialPetInfo();
         var petNumId:int;
         if((petNumId = int(xml.attribute("NumID"))) == initialPetInfo.bunchId)
         {
            initPetRewardInfo = new InitialPetRewardInfo();
            initPetRewardInfo.resourceId = (petNumId - 1) * 3 + 1;
            initPetRewardInfo.numId = petNumId;
            initPetRewardInfo.index = int(xml.attribute("Index"));
            initPetRewardInfo.onlyFlagIndex = int(xml.attribute("OnlyFlagIndex"));
            initPetRewardInfo.initialPetLevel = int(xml.attribute("InitMonLevel"));
            initPetRewardInfo.collectPetNum = int(xml.attribute("DoneCount"));
            itemXml = xml.elements("Item")[0];
            initPetRewardInfo.rewardId = int(itemXml.attribute("ID"));
            initPetRewardInfo.rewardLevel = int(itemXml.attribute("Level"));
         }
      }
      
      private static function parserThirdPetReward(xml:XML) : void
      {
         var itemXml:XML = null;
         var initialPetInfo:PetInfo = PetInfoManager.getInitialPetInfo();
         var petNumId:int;
         if((petNumId = int(xml.attribute("NumID"))) == initialPetInfo.bunchId)
         {
            thirdPetRewardInfo = new ThirdPetRewardInfo();
            thirdPetRewardInfo.index = int(xml.attribute("Index"));
            thirdPetRewardInfo.onlyFlagIndex = int(xml.attribute("OnlyFlagIndex"));
            thirdPetRewardInfo.firstPetId = (petNumId - 1) * 3 + 1;
            thirdPetRewardInfo.secondPetId = int(xml.attribute("secondPetID"));
            itemXml = xml.elements("Item")[0];
            thirdPetRewardInfo.rewardId = int(itemXml.attribute("ID"));
            thirdPetRewardInfo.rewardLevel = int(itemXml.attribute("Level"));
         }
      }
      
      private static function parserTrainReward(xml:XML) : void
      {
         var info:TrainRewardInfo = new TrainRewardInfo();
         info.index = int(xml.attribute("Index"));
         info.onlyFlagIndex = int(xml.attribute("OnlyFlagIndex"));
         info.needLevel = int(xml.attribute("NumLevel"));
         info.needCount = int(xml.attribute("NumCount"));
         info.tip = xml.attribute("tip");
         info.tip = info.tip.replace(/ /g,"\n");
         trainRewardVec.push(info);
      }
      
      public static function getSuitRewardVec(suitId:int) : Vector.<SuitRewardInfo>
      {
         if(_suitRewardMap.containsKey(suitId))
         {
            return _suitRewardMap.getValue(suitId);
         }
         return null;
      }
      
      public static function getSuitInfo(suitId:int) : SuitInfo
      {
         if(_suitMap.containsKey(suitId))
         {
            return _suitMap.getValue(suitId);
         }
         return null;
      }
      
      public static function getAllSuitReward() : Vector.<int>
      {
         return Vector.<int>(_suitRewardMap.getKeys());
      }
   }
}
