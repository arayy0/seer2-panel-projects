package com.taomee.seer2.module.app.winterSignPanel.item
{
   import flash.display.MovieClip;
   
   public interface IWinterSignPanel
   {
      function setup(param1:MovieClip) : void;
      
      function setData(param1:*) : void;
      
      function show() : void;
      
      function hide() : void;
   }
}

