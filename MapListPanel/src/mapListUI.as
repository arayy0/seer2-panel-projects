package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="mapListUI")]
   public dynamic class mapListUI extends MovieClip
   {
      public var goBtn:SimpleButton;
      
      public var nameTxt:TextField;
      
      public function mapListUI()
      {
         super();
      }
   }
}

