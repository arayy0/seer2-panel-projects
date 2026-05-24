package com.taomee.analytics.info
{
   public dynamic class ErrorInfoBox
   {
      
      public function ErrorInfoBox(userid:Number, mapid:int, clientEdition:Number, onlineid:int, onlineIpPort:String, cdnip:String, cdnSpeed:int)
      {
         super();
         this.userid = userid;
         this.mapid = mapid;
         this.clientEdition = clientEdition;
         this.onlineid = onlineid;
         this.onlineIpPort = onlineIpPort;
         this.cdnip = cdnip;
         this.cdnSpeed = cdnSpeed;
      }
   }
}

