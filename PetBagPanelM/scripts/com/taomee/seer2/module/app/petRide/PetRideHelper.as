package com.taomee.seer2.module.app.petRide
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.inventory.item.EquipItem;
   
   public class PetRideHelper
   {
      
      private static var _instance:PetRideHelper;
       
      
      public function PetRideHelper()
      {
         super();
         if(_instance != null)
         {
            throw new Error("实例化单例类出错，只能有一个实例");
         }
      }
      
      public static function getInstance() : PetRideHelper
      {
         if(_instance == null)
         {
            _instance = new PetRideHelper();
         }
         return _instance;
      }
      
      public function getNormalRideEquip() : EquipItem
      {
         var i:int = 0;
         var equipList:Vector.<EquipItem> = ActorManager.actorInfo.equipVec;
         if(Boolean(equipList))
         {
            for(i = 0; i < equipList.length; )
            {
               if(equipList[i].slotIndex == 11 || equipList[i].slotIndex == 3)
               {
                  return equipList[i];
               }
               i++;
            }
         }
         return null;
      }
   }
}
