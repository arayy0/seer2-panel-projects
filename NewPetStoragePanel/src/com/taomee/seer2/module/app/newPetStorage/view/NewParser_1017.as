package com.taomee.seer2.module.app.newPetStorage.view {
   import com.taomee.seer2.app.pet.data.PetInfo;
   import flash.utils.IDataInput;
   
   public class NewParser_1017 {
      private var data:IDataInput;
      public var petInfo:PetInfo;
      
      public function NewParser_1017(param1:IDataInput) {
         super();
         this.data = param1;
         this.petInfo = new PetInfo();
         this.petInfo.catchTime = param1.readUnsignedInt();
      }

      public function readData(param:PetInfo = null) : void {
         var targetInfo:PetInfo = this.petInfo;
         if (param != null) {
            targetInfo = param;
         }
         PetInfo.readBaseBaseInfo(targetInfo,this.data);
         PetInfo.readDetailInfo(targetInfo,this.data);
         targetInfo.learningInfo.pointUnused = this.data.readUnsignedShort();
         targetInfo.learningInfo.pointHp = this.data.readUnsignedShort();
         targetInfo.learningInfo.pointAtk = this.data.readUnsignedShort();
         targetInfo.learningInfo.pointSpecialAtk = this.data.readUnsignedShort();
         targetInfo.learningInfo.pointDefence = this.data.readUnsignedShort();
         targetInfo.learningInfo.pointSpecialDefence = this.data.readUnsignedShort();
         targetInfo.learningInfo.pointSpeed = this.data.readUnsignedShort();
         this.data.readUnsignedInt();
         targetInfo.potentialAtk = this.data.readUnsignedInt();
         targetInfo.potentialDef = this.data.readUnsignedInt();
         targetInfo.potentialSpAtk = this.data.readUnsignedInt();
         targetInfo.potentialSpDef = this.data.readUnsignedInt();
         targetInfo.potentialSpeed = this.data.readUnsignedInt();
         targetInfo.potentialHp = this.data.readUnsignedInt();
      }
   }
}
