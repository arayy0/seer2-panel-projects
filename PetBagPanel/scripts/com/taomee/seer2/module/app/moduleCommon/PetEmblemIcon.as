package com.taomee.seer2.module.app.moduleCommon
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.config.item.EmblemItemDefinition;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.Sprite;
   
   public class PetEmblemIcon extends Sprite
   {
       
      
      private var _icon:IconDisplayer;
      
      public function PetEmblemIcon()
      {
         super();
         this.initialize();
      }
      
      private function initialize() : void
      {
         this.createChildren();
      }
      
      private function createChildren() : void
      {
         this._icon = new IconDisplayer();
         TooltipManager.addCommonTip(this._icon,"");
         addChild(this._icon);
      }
      
      public function set id(id:int) : void
      {
         var url:String = null;
         var tip:String = null;
         var emblemItemDefinition:EmblemItemDefinition = null;
         if(id == 0)
         {
            this._icon.mouseEnabled = false;
            this._icon.mouseChildren = false;
            this._icon.buttonMode = false;
            this._icon.visible = false;
            return;
         }
         this._icon.mouseEnabled = true;
         this._icon.mouseChildren = true;
         this._icon.buttonMode = true;
         this._icon.visible = true;
         url = String(URLUtil.getEmblemIcon(id));
         this._icon.setIconUrl(url);
         tip = "";
         if((emblemItemDefinition = ItemConfig.getEmblemDefinition(id)) != null)
         {
            tip = emblemItemDefinition.name + ":" + emblemItemDefinition.tip;
         }
         TooltipManager.changeTip(this._icon,tip);
      }
   }
}
