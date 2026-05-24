package com.taomee.seer2.module.app.petDictionary.parser
{
   public class PetAttributeParser
   {
       
      
      public function PetAttributeParser()
      {
         super();
      }
      
      public static function parseWeightRange(weightStr:String) : String
      {
         var arr:Array = weightStr.split(" ");
         return arr[0] + " - " + arr[1] + " kg";
      }
      
      public static function parseHeightRange(heightStr:String) : String
      {
         var arr:Array = heightStr.split(" ");
         return arr[0] + " - " + arr[1] + " cm";
      }
      
      public static function parseGenderRange(genderStr:String) : String
      {
         if(genderStr.length == 1)
         {
            return genderStr + " 100%";
         }
         return genderStr.charAt(0) + " " + genderStr.charAt(1) + "0%" + genderStr.charAt(2) + " " + genderStr.charAt(3) + "0%";
      }
   }
}
