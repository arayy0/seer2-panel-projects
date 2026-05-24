package com.taomee.seer2.module.app.itemBag.ui.filter
{
   import com.taomee.seer2.module.app.itemBag.ItemBagFilterMenuUI;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class ItemBagFilterMenu extends Sprite
   {
       
      
      private var _container:MovieClip;
      
      private var _descriptionTxt:TextField;
      
      private var _indicatorMc:MovieClip;
      
      private var _isShowDropDown:Boolean;
      
      public function ItemBagFilterMenu()
      {
         super();
         this.mouseChildren = false;
         this.createChildren();
      }
      
      private function createChildren() : void
      {
         this._container = new ItemBagFilterMenuUI();
         addChild(this._container);
         this._container.x = 35;
         this._container.y = 38;
         this._indicatorMc = this._container["indicator"];
         this._descriptionTxt = this._container["description"];
      }
      
      public function reset() : void
      {
         this._descriptionTxt.text = "全部";
         this.showUp();
      }
      
      public function set description(value:String) : void
      {
         this._descriptionTxt.text = value;
      }
      
      public function toggle() : void
      {
         if(this._isShowDropDown)
         {
            this._indicatorMc.gotoAndStop(2);
         }
         else
         {
            this._indicatorMc.gotoAndStop(1);
         }
         this._isShowDropDown = !this._isShowDropDown;
      }
      
      public function showUp() : void
      {
         this._isShowDropDown = false;
         this.toggle();
      }
   }
}
