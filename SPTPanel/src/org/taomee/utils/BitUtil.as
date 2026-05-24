package org.taomee.utils
{
   public class BitUtil
   {
      
      public function BitUtil()
      {
         super();
      }
      
      public static function setBit(v:uint, index:int, bool:Boolean) : uint
      {
         if(bool)
         {
            v |= 1 << index;
         }
         else
         {
            v &= ~(1 << index);
         }
         return v;
      }
      
      public static function toBitArray(v:uint, len:int) : Array
      {
         var arr:Array = [];
         for(var i:int = 0; i < len; i++)
         {
            arr[i] = Boolean(v & 1);
            v >>= 1;
         }
         return arr;
      }
      
      public static function getBit(v:uint, index:int) : Boolean
      {
         return v == (v | 1 << index);
      }
   }
}

