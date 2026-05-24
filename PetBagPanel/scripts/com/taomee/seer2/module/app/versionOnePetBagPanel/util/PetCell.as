package com.taomee.seer2.module.app.versionOnePetBagPanel.util
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.core.effects.MotionEffects;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.ui.UIManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.moduleCommon.PetEmblemIcon;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class PetCell extends Sprite
   {
      
      public static const FIRST:String = "first";
      
      public static const FIGHT:String = "fight";
      
      public static const SELECT:String = "select";
       
      
      private var _mainUI:MovieClip;
      
      private var _content:Sprite;
      
      private var _levelTxt:TextField;
      
      private var _hpBar:Sprite;
      
      private var _hpTxt:TextField;
      
      private var _levelBackground:Sprite;
      
      private var _lightMc:MovieClip;
      
      private var _selector:MovieClip;
      
      private var _bgCell:Sprite;
      
      private var _fightStateMC:MovieClip;
      
      private var _openStateMC:MovieClip;
      
      private var _icon:IconDisplayer;
      
      private var _hotArea:Sprite;
      
      private var _info:PetInfo;
      
      private var _isBigUI:Boolean;
      
      private var _fightState:String;
      
      private var border:MovieClip;
      
      private var embIcon:PetEmblemIcon;
      
      public function PetCell(mc:MovieClip, isBigUI:Boolean = false, fightState:String = "select")
      {
         super();
         this._mainUI = mc;
         this._isBigUI = isBigUI;
         this._fightState = fightState;
         this.createChildren();
      }
      
      private function createChildren() : void
      {
         addChild(this._mainUI);
         this._content = this._mainUI["content"];
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
         this._bgCell = this._content["bgCell"];
         this._icon = new IconDisplayer();
         this._icon.scaleX = this._icon.scaleY = 1.5;
         if(this._isBigUI)
         {
            this._icon.x = 25;
            this._icon.y = 30;
         }
         else
         {
            this._icon.x = this._icon.y = -40;
            this._icon.x = -42;
         }
         this._content.addChildAt(this._icon,1);
         this._mainUI.mouseChildren = this._mainUI.mouseEnabled = false;
         this.embIcon = new PetEmblemIcon();
         this.embIcon.scaleX = 1;
         this.embIcon.scaleY = 1;
         this.embIcon.x = -45;
         this.embIcon.y = -43;
         this._content.addChild(this.embIcon);
         this._hotArea = DisplayObjectUtil.createHotArea(this._bgCell.width,this._bgCell.height);
         this._hotArea.buttonMode = true;
         addChild(this._hotArea);
         this._hotArea.addEventListener("mouseOver",this.onMouseOver);
         this._hotArea.addEventListener("mouseOut",this.onMouseOut);
         this._fightStateMC = this._mainUI["fightStateMC"];
         this._fightStateMC.gotoAndStop(this._fightState);
         this._openStateMC = this._content["openStateMC"];
         if(this._fightState != "select")
         {
            this._openStateMC.visible = false;
         }
      }
      
      private function onMouseOver(e:MouseEvent) : void
      {
         if(Boolean(this._lightMc))
         {
            this._lightMc.addEventListener("enterFrame",this.onLightMcEnter);
            this._lightMc.gotoAndPlay(1);
         }
         MotionEffects.execElastic(this._content);
      }
      
      public function get() : void
      {
      }
      
      private function onMouseOut(e:MouseEvent) : void
      {
         MotionEffects.resetScale(this._content);
      }
      
      private function onLightMcEnter(evt:Event) : void
      {
         if(this._lightMc.currentFrame == this._lightMc.totalFrames)
         {
            this._lightMc.removeEventListener("enterFrame",this.onLightMcEnter);
            this._lightMc.gotoAndStop(1);
         }
      }
      
      private function updateDisplay() : void
      {
         var name:String = null;
         var lev:uint = 0;
         this.updatePreview();
         this.updateSimpleInfo();
         this.setChildrenVisible(true);
         if(Boolean(this.border))
         {
            DisplayObjectUtil.removeFromParent(this.border);
            this._bgCell.visible = true;
         }
         //屏蔽了神魔头像框
         /*
         if(this._info.evolveLevel != -1)
         {
            name = "";
            lev = this._info.evolveLevel > 1000 ? uint(this._info.evolveLevel - 1000) : uint(this._info.evolveLevel);
            if(lev > 0)
            {
               if(lev < 5)
               {
                  name = "UI_AgBorder";
               }
               else if(lev < 7)
               {
                  name = "UI_GoldBorder";
               }
               else
               {
                  name = "UI_PurpleBorder";
               }
               if(name.length > 0)
               {
                  this.border = UIManager.getMovieClip(name);
                  this.border.x = -this.border.width / 2;
                  this.border.y = -this.border.height / 2;
                  this.border.mouseEnabled = this.border.mouseChildren = false;
                  this._bgCell.visible = false;
                  if(this._isBigUI)
                  {
                     this.border.width = 115;
                     this.border.height = 120;
                     this.border.x = 10;
                     this.border.y = 0;
                     this._content.addChildAt(this.border,3);
                     this._selector.visible = false;
                  }
                  else
                  {
                     this.border.width += 6;
                     this.border.x -= 3;
                     this._content.addChildAt(this.border,2);
                  }
               }
            }
         }
         */
      }
      
      private function updatePreview() : void
      {
         var url:String = String(URLUtil.getPetIcon(this._info.resourceId));
         this._icon.setIconUrl(url,this.onContentLoaded);
         this.embIcon.id = 0;
         this.embIcon.visible = false;
         if(this._info.emblemId != 0)
         {
            this.embIcon.visible = false;
            this.embIcon.id = this._info.emblemId;
         }
      }
      
      private function updateSimpleInfo() : void
      {
         this._levelTxt.text = String(this._info.level);
         this._hpTxt.text = this._info.hp.toString() + "/" + this._info.maxHp.toString();
         this._hpBar.scaleX = this._info.hp / this._info.maxHp;
         if(this._hpBar.scaleX > 1)
         {
            this._hpBar.scaleX = 1;
         }
      }
      
      public function get openStateMC() : MovieClip
      {
         return this._openStateMC;
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
      
      private function onPetRideIcon(e:MouseEvent) : void
      {
         AlertManager.showConfirm("是否前往骑宠驯化场？",function():void
         {
            if(SceneManager.active.mapID != 1600)
            {
               SceneManager.changeScene(1,1600);
            }
            ModuleManager.closeForName("PetBagPanel");
         });
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
      
      public function reset() : void
      {
         DisplayObjectUtil.disableSprite(this);
         this._icon.removeIcon();
         this.setChildrenVisible(false);
         this.mouseEnabled = false;
         this._bgCell.visible = true;
         this.embIcon.visible = false;
         this.embIcon.id = 0;
         if(Boolean(this.border))
         {
            DisplayObjectUtil.removeFromParent(this.border);
         }
         this._info = null;
      }
      
      public function set selected(value:Boolean) : void
      {
         this._selector.visible = value;
         if(Boolean(this._info) && this._info.getPetDefinition().chgMonId != 0)
         {
            this._selector.gotoAndStop(2);
         }
         else
         {
            this._selector.gotoAndStop(1);
         }
      }
      
      public function get petInfo() : PetInfo
      {
         return this._info;
      }
   }
}
