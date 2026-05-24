package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="moon_2")]
   public dynamic class moon_2 extends MovieClip
   {
       
      
      public function moon_2()
      {
         super();
         addFrameScript(60,this.frame61);
      }
      
      internal function frame61() : *
      {
         stop();
      }
   }
}
