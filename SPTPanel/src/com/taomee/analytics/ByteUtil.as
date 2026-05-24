package com.taomee.analytics
{
   import flash.utils.ByteArray;
   
   internal class ByteUtil
   {
      
      public function ByteUtil()
      {
         super();
      }
      
      public static function toString(b:ByteArray) : String
      {
         var t:String = null;
         var s:String = "";
         var op:uint = b.position;
         b.position = 0;
         while(Boolean(b.bytesAvailable))
         {
            t = b.readUnsignedByte().toString(16);
            s += t.length == 1 ? "0" + t : t;
         }
         b.position = op;
         return s;
      }
   }
}

