package com.taomee.seer2.module.app.newPetStorage.view.storage
{
   import com.taomee.seer2.app.component.PetTypeIcon;
   import com.taomee.seer2.app.pet.constant.PetTypeNameMap;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.module.app.newPetStorage.view.StorageSubView;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class PetTypeIconsPanel extends StorageSubView
   {
       
      
      private const MAX_NUM:int = 21;
      
      public function PetTypeIconsPanel(ui:MovieClip)
      {
         super(ui);
         this.init();
      }
      
      private function init() : void
      {
         var i:int = 0;
         var typeIcon:PetTypeIcon = null;
         var icon:MovieClip = null;
         for(i = 0; i < 21; )
         {
            typeIcon = new PetTypeIcon();
            icon = _ui["icon" + i];
            icon.buttonMode = true;
            typeIcon.x = typeIcon.y = 6;
            typeIcon.type = i + 1;
            icon.addChild(typeIcon);
            this.addEvent(icon,i + 1);
            typeIcon.scaleX = typeIcon.scaleY = 0.8;
            i++;
         }
      }
      
      private function addEvent(icon:DisplayObject, type:int) : void
      {
         TooltipManager.addCommonTip(icon as InteractiveObject,PetTypeNameMap.getTypeName(type));
         eventListenerMgr.addEventListener(icon,"click",function(e:MouseEvent):void
         {
            moduleData.query.filterType = 0;
            moduleData.query.filterContent = type;
            moduleData.emit("query");
         });
      }
      
      override public function destory() : void
      {
         var i:int = 0;
         for(i = 0; i < 21; )
         {
            TooltipManager.remove(_ui["icon" + i]);
            i++;
         }
         super.destory();
      }
   }
}
