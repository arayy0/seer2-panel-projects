package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="NewPetDicsListCellUI")]
   public dynamic class NewPetDicsListCellUI extends MovieClip
   {
       
      
      public var petNumber:TextField;
      
      public var petName:TextField;
      
      public var starEffect:MovieClip;
      
      public var isOpen:MovieClip;
      
      public var isGained:MovieClip;
      
      public var iconHolder:MovieClip;
      
      public var isNew:MovieClip;
      
      public function NewPetDicsListCellUI()
      {
         super();
      }
   }
}
