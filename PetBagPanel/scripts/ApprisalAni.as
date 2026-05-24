package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="ApprisalAni")]
   public dynamic class ApprisalAni extends MovieClip
   {
       
      
      public function ApprisalAni()
      {
         super();
         addFrameScript(0,this.frame1,82,this.frame83);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame83() : *
      {
         this.dispatchEvent(new Event("animiEnd"));
      }
   }
}
