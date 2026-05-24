package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="mainPanel")]
   public dynamic class mainPanel extends MovieClip
   {
      public var closeBtn:SimpleButton;
      
      public var nextBtn:SimpleButton;
      
      public var pageTxt:TextField;
      
      public var preBtn:SimpleButton;
      
      public function mainPanel()
      {
         super();
      }
   }
}

