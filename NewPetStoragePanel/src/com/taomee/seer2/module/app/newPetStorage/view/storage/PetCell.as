package com.taomee.seer2.module.app.newPetStorage.view.storage
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.newPetStorage.view.StorageSubView;
   import flash.display.MovieClip;
   
   public class PetCell extends StorageSubView
   {
       
      
      private var _index:int;
      
      private var _petInfo:PetInfo;
      
      private var _icon:IconDisplayer;
      
      public function PetCell(ui:MovieClip, index:int)
      {
         this._index = index;
         super(ui);
         ui.mouseChildren = false;
         ui.buttonMode = true;
         eventListenerMgr.addEventListener(ui,"click",function(e:* = null):void
         {
            moduleData.setData("focus_pet",_petInfo);
         });
      }
      
      public function setPetInfo(petInfo:PetInfo) : void
      {
         this._petInfo = petInfo;
         if(this._petInfo == null)
         {
            _ui.visible = false;
            return;
         }
         _ui.visible = true;
         if(this._icon == null)
         {
            this._icon = new IconDisplayer();
            _ui.addChild(this._icon);
            this._icon.y = -27;
            this._icon.x = -27;
         }
         var url:String = String(URLUtil.getPetIcon(this._petInfo.resourceId));
         this._icon.setIconUrl(url);
         _ui["levelBar"]["levelTxt"].text = petInfo.level + "";
         _ui.addChild(_ui["levelBar"]);
      }
      
      override public function destory() : void
      {
         if(this._icon != null)
         {
            this._icon.dispose();
            this._icon = null;
         }
         super.destory();
      }
   }
}
