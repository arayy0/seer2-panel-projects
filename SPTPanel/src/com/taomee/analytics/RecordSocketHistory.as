package com.taomee.analytics
{
   internal class RecordSocketHistory
   {
      
      public static const TAG_SYSTEM_BUSY:String = "SystemBusy";
      
      public static const TAG_DB_TIMEOUT:String = "DBTimeOut";
      
      public static const ACTION_WRITE:String = "write";
      
      public static const ACTION_READ:String = "read";
      
      public static var actionHistory:Array = [];
      
      public static var recordCount:int = 40;
      
      private static var oldTimer:Number = 0;
      
      public function RecordSocketHistory()
      {
         super();
      }
      
      public static function pushInActionHistory(cmd:int, type:String) : void
      {
         var newTimer:Number = new Date().time;
         var interval:int = newTimer - (oldTimer == 0 ? newTimer : oldTimer);
         actionHistory.push(cmd + ":" + String(interval) + "/" + type);
         if(actionHistory.length > recordCount)
         {
            actionHistory.shift();
         }
         oldTimer = newTimer;
      }
      
      public static function pushInTagHistory(cmd:int, tag:String) : void
      {
         var newTimer:Number = new Date().time;
         var interval:int = newTimer - (oldTimer == 0 ? newTimer : oldTimer);
         actionHistory.push(cmd + ":" + tag + "-" + String(interval) + "/Tag");
         if(actionHistory.length > recordCount)
         {
            actionHistory.shift();
         }
         oldTimer = newTimer;
      }
   }
}

