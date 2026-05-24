package com.taomee.seer2.module.app.petBag.helper
{
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.events.Event;
   import flash.utils.IDataInput;
   import org.taomee.manager.EventManager;
   
   public class PetBagLearningPointHelper
   {
       
      
      public function PetBagLearningPointHelper()
      {
         super();
      }
      
      public static function canChangeLearningPointSvr(changedVec:Vector.<int>, originalVec:Vector.<int>) : Boolean
      {
         return getLearningPointChangedVec(changedVec,originalVec).length > 0;
      }
      
      public static function changeLearningPointSvr(catchTime:uint, changedVec:Vector.<int>, originalVec:Vector.<int>) : void
      {
         var i:int = 0;
         var index:int = 0;
         var changedIndexVec:Vector.<int> = getLearningPointChangedVec(changedVec,originalVec);
         var data:LittleEndianByteArray = new LittleEndianByteArray();
         var length:int = int(changedIndexVec.length);
         data.writeUnsignedInt(catchTime);
         data.writeUnsignedInt(length);
         for(i = 0; i < length; )
         {
            index = changedIndexVec[i];
            data.writeByte(index);
            data.writeShort(changedVec[index] - originalVec[index]);
            i++;
         }
         Connection.addCommandListener(CommandSet.PET_ADD_LEARNING_POINT_1033,onAddedLearningPoint);
         Connection.send(CommandSet.PET_ADD_LEARNING_POINT_1033,data);
      }
      
      private static function onAddedLearningPoint(evt:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.PET_ADD_LEARNING_POINT_1033,onAddedLearningPoint);
         updatePetLearningPoint(evt.message.getRawDataCopy());
      }
      
      private static function getLearningPointChangedVec(changedVec:Vector.<int>, originalVec:Vector.<int>) : Vector.<int>
      {
         var i:int = 0;
         var changedIndexVec:Vector.<int> = new Vector.<int>();
         for(i = 0; i < 6; )
         {
            if(originalVec[i] != changedVec[i])
            {
               changedIndexVec.push(i);
            }
            i++;
         }
         return changedIndexVec;
      }
      
      private static function updatePetLearningPoint(data:IDataInput) : void
      {
         var i:int = 0;
         var index:int = 0;
         var abilityValue:int = 0;
         var learningPoint:int = 0;
         var petId:uint = uint(data.readUnsignedInt());
         var petInfo:PetInfo = PetInfoManager.getPetInfoFromAllBag(petId);
         if(petInfo == null)
         {
            return;
         }
         var count:int = int(data.readUnsignedInt());
         for(i = 0; i < count; )
         {
            index = int(data.readUnsignedByte());
            abilityValue = int(data.readUnsignedShort());
            learningPoint = int(data.readUnsignedShort());
            updatePetAbilityValueRecord(petInfo,index,abilityValue,learningPoint);
            i++;
         }
         petInfo.learningInfo.pointUnused = data.readUnsignedShort();
         ServerMessager.addMessage("学习力分配成功!");
         PetInfoManager.dispatchEvent("petPropertiesChange",petInfo);
         EventManager.dispatchEvent(new Event("PetUpdate"));
      }
      
      private static function updatePetAbilityValueRecord(info:PetInfo, index:int, abilityValue:int, learningPoint:int) : void
      {
         switch(index)
         {
            case 0:
               info.atk = abilityValue;
               info.learningInfo.pointAtk = learningPoint;
               break;
            case 1:
               info.defence = abilityValue;
               info.learningInfo.pointDefence = learningPoint;
               break;
            case 2:
               info.specialAtk = abilityValue;
               info.learningInfo.pointSpecialAtk = learningPoint;
               break;
            case 3:
               info.specialDefence = abilityValue;
               info.learningInfo.pointSpecialDefence = learningPoint;
               break;
            case 4:
               info.speed = abilityValue;
               info.learningInfo.pointSpeed = learningPoint;
               break;
            case 5:
               info.maxHp = abilityValue;
               info.learningInfo.pointHp = learningPoint;
         }
      }
      
      public static function canChangeLearningPointByItem(itemId:int) : Boolean
      {
         return itemId == 200224 || itemId == 201004;
      }
      
      public static function changeLearningPointByItem(catchTime:uint, itemId:int) : void
      {
         var data:LittleEndianByteArray = new LittleEndianByteArray();
         data.writeUnsignedInt(itemId);
         data.writeUnsignedInt(catchTime);
         Connection.addCommandListener(CommandSet.PET_WASH_LEARNING_POINT_1159,onWashedLearningPoint);
         Connection.send(CommandSet.PET_WASH_LEARNING_POINT_1159,data);
      }
      
      private static function onWashedLearningPoint(evt:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.PET_WASH_LEARNING_POINT_1159,onWashedLearningPoint);
         updatePetLearningPoint(evt.message.getRawDataCopy());
      }
   }
}
