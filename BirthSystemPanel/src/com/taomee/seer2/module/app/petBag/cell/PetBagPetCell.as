package com.taomee.seer2.module.app.petBag.cell
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.core.effects.MotionEffects;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.petBag.PetCellUI;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class PetBagPetCell extends Sprite
   {
      private var _container:MovieClip;
      
      private var _nameTxt:TextField;
      
      private var _levelBackground:Sprite;
      
      private var _levelTxt:TextField;
      
      private var _hpBar:Sprite;
      
      private var _hpTxt:TextField;
      
      private var _content:Sprite;
      
      private var _lightMc:MovieClip;
      
      private var _hotArea:Sprite;
      
      private var _selector:Sprite;
      
      private var _info:PetInfo;
      
      private var _icon:IconDisplayer;
      
      public function PetBagPetCell()
      {
         super();
         this._container = new PetCellUI();
         addChild(this._container);
         this._nameTxt = this._container["nameTxt"];
         this._content = this._container["content"];
         this._levelTxt = this._content["levelTxt"];
         this._hpBar = this._content["HP"];
         this._hpTxt = this._content["hpText"];
         this._levelBackground = this._content["levelBg"];
         this._lightMc = this._content["light"];
         if(Boolean(this._lightMc))
         {
            this._lightMc.gotoAndStop(1);
         }
         this._selector = this._content["selector"];
         this._icon = new IconDisplayer();
         this._icon.scaleY = this._icon.scaleX = 1.5;
         this._icon.x = this._icon.y = -40;
         this._content.addChildAt(this._icon,1);
         this._container.mouseEnabled = false;
         this._container.mouseChildren = false;
         this._hotArea = DisplayObjectUtil.createHotArea(85,85);
         this._hotArea.buttonMode = true;
         addChild(this._hotArea);
         this._hotArea.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this._hotArea.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      private function onMouseOver(evt:MouseEvent) : void
      {
         if(Boolean(this._lightMc))
         {
            this._lightMc.addEventListener(Event.ENTER_FRAME,this.onLightMcEnter);
            this._lightMc.gotoAndPlay(1);
         }
         MotionEffects.execElastic(this._content);
      }
      
      private function onLightMcEnter(evt:Event) : void
      {
         if(this._lightMc.currentFrame == this._lightMc.totalFrames)
         {
            this._lightMc.removeEventListener(Event.ENTER_FRAME,this.onLightMcEnter);
            this._lightMc.gotoAndStop(1);
         }
      }
      
      private function onMouseOut(evt:MouseEvent) : void
      {
         MotionEffects.resetScale(this._content);
      }
      
      public function reset() : void
      {
         DisplayObjectUtil.disableSprite(this);
         this._icon.removeIcon();
         this.setChildrenVisible(false);
         this._nameTxt.text = "未知";
         this.mouseEnabled = false;
         this._info = null;
      }
      
      public function setPetInfo(info:PetInfo) : void
      {
         this.reset();
         this._info = info;
         if(this._info != null)
         {
            this.mouseEnabled = true;
            this.updateDisplay();
         }
      }
      
      private function updateDisplay() : void
      {
         this.updatePreview();
         this.updateSimpleInfo();
         this.setChildrenVisible(true);
      }
      
      private function updatePreview() : void
      {
         this.loadPreview();
      }
      
      private function updateSimpleInfo() : void
      {
         this._levelTxt.text = String(this._info.level);
         this._nameTxt.text = this._info.name;
         this._hpTxt.text = this._info.hp.toString() + "/" + this._info.maxHp.toString();
         this._hpBar.scaleX = this._info.hp / this._info.maxHp;
         if(this._hpBar.scaleX > 1)
         {
            this._hpBar.scaleX = 1;
         }
      }
      
      private function loadPreview() : void
      {
         var url:String = URLUtil.getPetIcon(this._info.resourceId);
         this._icon.setIconUrl(url,this.onContentLoaded);
      }
      
      private function onContentLoaded() : void
      {
         DisplayObjectUtil.enableSprite(this);
      }
      
      private function setChildrenVisible(visible:Boolean) : void
      {
         this._hpBar.visible = visible;
         this._levelTxt.visible = visible;
         this._levelBackground.visible = visible;
         this._hpTxt.visible = visible;
      }
      
      public function set selected(value:Boolean) : void
      {
         this._selector.visible = value;
      }
      
      public function get petInfo() : PetInfo
      {
         return this._info;
      }
   }
}

