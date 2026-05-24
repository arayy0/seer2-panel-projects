package com.taomee.seer2.module.app.itemBag.ui.filter
{
   import com.taomee.seer2.module.app.itemBag.ItemBagFilterItemUI;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class ItemBagFilterItem extends Sprite
   {
       
      
      private var _container:MovieClip;
      
      private var _backgroundMc:MovieClip;
      
      private var _descriptionTxt:TextField;
      
      private var _extension:ItemBagFilterExtension;
      
      private var _description:String;
      
      public function ItemBagFilterItem()
      {
         super();
         this.createChildren();
      }
      
      private function createChildren() : void
      {
         this._container = new ItemBagFilterItemUI();
         addChild(this._container);
         this._backgroundMc = this._container["bg"];
         this._backgroundMc.mouseEnabled = false;
         this._backgroundMc.gotoAndStop(1);
         this._descriptionTxt = this._container["description"];
         this._descriptionTxt.mouseEnabled = false;
      }
      
      public function setData(value:String) : void
      {
         this._description = value;
         this._descriptionTxt.text = this._description;
         this.visible = true;
         this.mouseEnabled = true;
      }
      
      public function reset() : void
      {
         this.visible = false;
         this.mouseEnabled = false;
      }
      
      public function set isSelected(value:Boolean) : void
      {
         if(value)
         {
            this._backgroundMc.gotoAndStop(1);
            this.mouseEnabled = false;
            this.buttonMode = false;
            if(Boolean(this._extension))
            {
               this._extension.show();
            }
         }
         else
         {
            this._backgroundMc.gotoAndStop(1);
            this.mouseEnabled = true;
            this.buttonMode = true;
            if(Boolean(this._extension))
            {
               this._extension.hide();
            }
         }
      }
      
      public function set extension(value:ItemBagFilterExtension) : void
      {
         this._extension = value;
         this.addChild(this._extension);
      }
      
      public function get description() : String
      {
         return this._description;
      }
   }
}
