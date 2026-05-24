package com.taomee.seer2.module.app.birthSystem
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.info.BirthSkillInfo;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.core.effects.MotionEffects;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.BirthItemUI;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class BirthCell extends Sprite
   {
      private var _container:MovieClip;
      
      private var _nameTxt:TextField;
      
      private var _levelBackground:Sprite;
      
      private var _levelTxt:TextField;
      
      private var _content:Sprite;
      
      private var _hotArea:Sprite;
      
      private var _selector:Sprite;
      
      private var _info:PetInfo;
      
      private var _birthInfo:BirthSkillInfo;
      
      private var _icon:IconDisplayer;
      
      private var _isPetInfo:Boolean;
      
      private var _petSexIcon:MovieClip;
      
      public var userID:uint;
      
      public function BirthCell()
      {
         super();
         this._container = new BirthItemUI();
         addChild(this._container);
         this._nameTxt = this._container["nameTxt"];
         this._content = this._container["content"];
         this._levelTxt = this._content["levelTxt"];
         this._levelBackground = this._content["levelBg"];
         this._selector = this._content["selector"];
         this._petSexIcon = this._container["petSexIcon"];
         this._nameTxt.mouseEnabled = false;
         this._nameTxt.visible = false;
         this._levelTxt.mouseEnabled = false;
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
      
      public function removeMouseOver() : void
      {
         this._hotArea.mouseChildren = false;
         this._hotArea.mouseEnabled = false;
         this._hotArea.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this._hotArea.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      private function onMouseOver(evt:MouseEvent) : void
      {
         MotionEffects.execElastic(this._content);
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
      
      public function setPetInfo(info:PetInfo, isPetInfo:Boolean = true, petSkillInfo:BirthSkillInfo = null) : void
      {
         this.reset();
         this._isPetInfo = isPetInfo;
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
         this._nameTxt.text = PetConfig.getPetDefinition(this._info.resourceId).name;
         this._petSexIcon.gotoAndStop(this._info.sex);
         if(this._info.sex != 1 && this._info.sex != 2)
         {
            this._petSexIcon.gotoAndStop(3);
         }
      }
      
      private function loadPreview() : void
      {
         var url:String = null;
         url = URLUtil.getPetIcon(this._info.resourceId);
         this._icon.setIconUrl(url,this.onContentLoaded);
      }
      
      private function onContentLoaded() : void
      {
         DisplayObjectUtil.enableSprite(this);
      }
      
      private function setChildrenVisible(visible:Boolean) : void
      {
         this._levelTxt.visible = visible;
         this._levelBackground.visible = visible;
         this._petSexIcon.visible = visible;
      }
      
      public function set selected(value:Boolean) : void
      {
         this._selector.visible = value;
      }
      
      public function get selected() : Boolean
      {
         return this._selector.visible;
      }
      
      public function get petInfo() : PetInfo
      {
         return this._info;
      }
      
      public function get birthInfo() : BirthSkillInfo
      {
         return this._birthInfo;
      }
   }
}

