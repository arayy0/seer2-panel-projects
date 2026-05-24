package com.taomee.seer2.module.app.newPetStorage.view
{
   import com.taomee.seer2.app.pet.data.PetInfo;
   import flash.utils.IDataInput;
   
   public class NewParser_1017
   {
       
      
      public var petInfo:PetInfo;
      
      public function NewParser_1017(param1:IDataInput, param2:PetInfo = null)
      {
         super();
         if(param2 != null)
         {
            this.petInfo = param2;
         }
         else
         {
            this.petInfo = new PetInfo();
         }
         PetInfo.readBaseInfo(this.petInfo,param1);
         PetInfo.readDetailInfo(this.petInfo,param1);
         this.petInfo.learningInfo.pointUnused = param1.readUnsignedShort();
         this.petInfo.learningInfo.pointHp = param1.readUnsignedShort();
         this.petInfo.learningInfo.pointAtk = param1.readUnsignedShort();
         this.petInfo.learningInfo.pointSpecialAtk = param1.readUnsignedShort();
         this.petInfo.learningInfo.pointDefence = param1.readUnsignedShort();
         this.petInfo.learningInfo.pointSpecialDefence = param1.readUnsignedShort();
         this.petInfo.learningInfo.pointSpeed = param1.readUnsignedShort();
         param1.readUnsignedInt();
         this.petInfo.potentialAtk = param1.readUnsignedInt();
         this.petInfo.potentialDef = param1.readUnsignedInt();
         this.petInfo.potentialSpAtk = param1.readUnsignedInt();
         this.petInfo.potentialSpDef = param1.readUnsignedInt();
         this.petInfo.potentialSpeed = param1.readUnsignedInt();
         this.petInfo.potentialHp = param1.readUnsignedInt();
      }
   }
}
