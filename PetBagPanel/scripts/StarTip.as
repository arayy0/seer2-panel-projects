package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="StarTip")]
   public dynamic class StarTip extends MovieClip
   {
       
      
      public var shuxing:TextField;
      
      public var sell:TextField;
      
      public var nameT:TextField;
      
      public var level:TextField;
      
      public var exp:TextField;
      
      public var value:TextField;
      
      public var __checkFontName_:String;
      
      public var __cacheXMLSettings:Object;
      
      public function StarTip()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
