package com.taomee.seer2.module.app.winterSignPanel.item
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class WinSignIcon extends Sprite
   {
      private var _mc:MovieClip;
      
      private var _numTxt:TextField;
      
      private var _id:uint;
      
      private var _iconDisplayer:IconDisplayer;
      
      private var _petMask:MovieClip;
      
      public function WinSignIcon(id:uint, count:uint)
      {
         super();
         this._mc = new WinterSignIconUI();
         addChild(this._mc);
         this._id = id;
      }
      
      public function clear() : void
      {
      }
      
      public function dispose() : void
      {
      }
   }
}

