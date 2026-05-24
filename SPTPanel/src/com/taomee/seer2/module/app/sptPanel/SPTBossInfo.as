package com.taomee.seer2.module.app.sptPanel
{
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.module.app.SPTPanel;
   
   public class SPTBossInfo
   {
      
      public var _bossID:uint;
      
      public var _score:int;
      
      public var _level:uint;
      
      public function SPTBossInfo(data:LittleEndianByteArray = null)
      {
         var sptInfo:SptInfo = null;
         super();
         if(Boolean(data))
         {
            this._bossID = data.readUnsignedInt();
            this._score = data.readUnsignedByte();
            sptInfo = SPTPanel.getSptInfo(this._bossID);
            if(sptInfo != null)
            {
               this._level = sptInfo.petLevel;
            }
         }
      }
      
      public function setInfo(bossID:uint, score:int) : void
      {
         this._bossID = bossID;
         this._score = score;
         this._level = SPTPanel.getSptInfo(this._bossID).petLevel;
      }
      
      public function get bossID() : uint
      {
         return this._bossID;
      }
      
      public function get score() : int
      {
         return this._score;
      }
      
      public function get level() : int
      {
         return this._level;
      }
   }
}

