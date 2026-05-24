package com.taomee.seer2.module.app.kingFightTrailTaskPanel.item
{
   import flash.display.MovieClip;
   
   public interface IKingFightTaskPanel
   {
      function setup(param1:MovieClip) : void;
      
      function setData(param1:*) : void;
      
      function show() : void;
      
      function hide() : void;
   }
}

