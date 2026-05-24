package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   [Embed(source="/_assets/assets.swf", symbol="GraspSkillGetUI")]
   public dynamic class GraspSkillGetUI extends MovieClip
   {
       
      
      public var resetBtn:SimpleButton;
      
      public function GraspSkillGetUI()
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
