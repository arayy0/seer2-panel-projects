package com.taomee.seer2.module.app.newPetStorage.view.bagList
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.vip.VipManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.newPetStorage.view.StorageSubView;
   import flash.display.MovieClip;
   
   public class PetCell extends StorageSubView
   {
       
      
      private var _petInfo:PetInfo;
      
      private var _index:int;
      
      private var _icon:IconDisplayer;
      
      public function PetCell(ui:MovieClip, index:int)
      {
         this._index = index;
         super(ui);
         this.init();
      }
      
      private function init() : void
      {
         _ui.mouseChildren = false;
         _ui.buttonMode = true;
         if((VipManager.vipInfo.level >= this._index - 6 && VipManager.vipInfo.leftDay > 0) || this._index <= 6)
         {
            _ui.openStateMC.visible = false;
         }
         else
         {
            _ui.openStateMC.visible = true;
            _ui.openStateMC.gotoAndStop(this._index - 6);
         }
         this._icon = new IconDisplayer();
         this._icon.scaleX = this._icon.scaleY = 1.2;
         this._icon.x = this._icon.y = 3;
         _ui.addChildAt(this._icon,1);
         _ui["bar"].gotoAndStop(1);
         eventListenerMgr.addEventListener(_ui,"click",this.onClick);
      }
      
      public function setPetInfo(info:PetInfo) : void
      {
         this._petInfo = info;
         this.updateView();
      }
      
      private function updateView() : void
      {
         if(this._petInfo == null)
         {
            this._icon.removeIcon();
            _ui.mouseEnabled = false;
            _ui["hp"].text = "0/0";
            _ui["bar"].gotoAndStop(1);
            _ui["levelBar"]["levelTxt"].text = "";
            return;
         }
         _ui.mouseEnabled = true;
         var url:String = String(URLUtil.getPetIcon(this._petInfo.resourceId));
         this._icon.setIconUrl(url);
         _ui["hp"].text = this._petInfo.hp.toString() + "/" + this._petInfo.maxHp.toString();
         _ui["bar"].gotoAndStop(Math.ceil(100 * this._petInfo.hp / this._petInfo.maxHp));
         _ui["levelBar"]["levelTxt"].text = this._petInfo.level;
      }
      
      private function onClick(e:* = null) : void
      {
         moduleData.setData("focus_pet",this._petInfo);
      }
      
      override public function destory() : void
      {
         this._icon.dispose();
         this._icon = null;
         super.destory();
      }
   }
}
