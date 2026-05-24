package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   [Embed(source="/_assets/assets.swf", symbol="NewPetDicMainUI")]
   public dynamic class NewPetDicMainUI extends MovieClip
   {
       
      
      public var shuxing:SimpleButton;
      
      public var have:SimpleButton;
      
      public var search:MovieClip;
      
      public var nothave:SimpleButton;
      
      public var petLevel:MovieClip;
      
      public var closeBtn:SimpleButton;
      
      public function NewPetDicMainUI()
      {
         super();
      }
   }
}
