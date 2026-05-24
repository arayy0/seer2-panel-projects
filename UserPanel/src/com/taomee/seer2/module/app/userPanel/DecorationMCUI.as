package com.taomee.seer2.module.app.userPanel
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol480")]
   public dynamic class DecorationMCUI extends MovieClip
   {
      
      public function DecorationMCUI()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

