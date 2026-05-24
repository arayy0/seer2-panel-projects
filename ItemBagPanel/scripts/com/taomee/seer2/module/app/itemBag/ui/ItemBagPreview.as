package com.taomee.seer2.module.app.itemBag.ui
{
   import com.taomee.seer2.app.actor.data.UserInfo;
   import com.taomee.seer2.app.actor.preview.ActorPreview;
   import com.taomee.seer2.app.inventory.item.EquipItem;
   import flash.display.Sprite;
   
   public class ItemBagPreview extends Sprite
   {
       
      
      private var _preview:ActorPreview;
      
      public function ItemBagPreview()
      {
         super();
         this.createChildren();
      }
      
      private function createChildren() : void
      {
         this._preview = new ActorPreview();
         this._preview.x = 180;
         this._preview.y = 300;
         addChild(this._preview);
      }
      
      public function setData(userInfo:UserInfo) : void
      {
         this._preview.setData(userInfo);
      }
      
      public function addEquip(item:EquipItem) : void
      {
         this._preview.addEquip(item.referenceId);
      }
      
      public function removeEquip(item:EquipItem) : void
      {
         this._preview.removeEquip(item.referenceId);
      }
   }
}
