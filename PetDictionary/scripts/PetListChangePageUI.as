package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="PetListChangePageUI")]
   public dynamic class PetListChangePageUI extends MovieClip
   {
       
      
      public var preBtn:SimpleButton;
      
      public var currentPageTxt:TextField;
      
      public var nextBtn:SimpleButton;
      
      public var totalPageTxt:TextField;

      public var goBtn:SimpleButton;
      
      public function PetListChangePageUI()
      {
         super();
      }
   }
}
