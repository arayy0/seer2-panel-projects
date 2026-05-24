package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   [Embed(source="/_assets/assets.swf", symbol="NewPetDicTabBarUI")]
   public dynamic class NewPetDicTabBarUI extends MovieClip
   {
       
      
      public var petCollecteRewardTabBtn:SimpleButton;
      
      public var petTrainRewardTabBtn:SimpleButton;
      
      public var thisWeekPetTabBtn:SimpleButton;
      
      public var tabMaskMc:MovieClip;
      
      public var collectShineMC:MovieClip;
      
      public var trainShineMC:MovieClip;
      
      public var collectNewMark:MovieClip;
      
      public var petListTabBtn:SimpleButton;
      
      public function NewPetDicTabBarUI()
      {
         super();
      }
   }
}
