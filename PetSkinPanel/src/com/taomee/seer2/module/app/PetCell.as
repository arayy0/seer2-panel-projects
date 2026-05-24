package com.taomee.seer2.module.app
{
    import com.taomee.seer2.app.component.IconDisplayer;
    import com.taomee.seer2.app.config.PetConfig;
    import com.taomee.seer2.app.config.PetSkinDefineConfig;
    import com.taomee.seer2.app.pet.data.PetInfo;
    import com.taomee.seer2.core.effects.MotionEffects;
    import com.taomee.seer2.core.utils.DisplayObjectUtil;
    import com.taomee.seer2.core.utils.URLUtil;
    import com.taomee.seer2.module.app.UI.PetCellUI;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    public class PetCell extends Sprite
    {

        private var _container:MovieClip;

        private var _nameTxt:TextField;

        private var _content:Sprite;

        private var _lightMc:MovieClip;

        private var _hotArea:Sprite;

        private var _selector:Sprite;

        private var _info:PetInfo;

        private var _skinId:uint;

        private var _icon:IconDisplayer;

        private var _skinType:Boolean;

        public function PetCell()
        {
            super();
            this._skinType = false;
            this._container = new PetCellUI();
            addChild(this._container);
            this._nameTxt = this._container["nameTxt"];
            this._content = this._container["content"];
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
            this._hotArea.addEventListener("mouseOver",this.onMouseOver);
            this._hotArea.addEventListener("mouseOut",this.onMouseOut);
        }

        private function onMouseOver(evt:MouseEvent) : void
        {
            if(Boolean(this._lightMc))
            {
                this._lightMc.addEventListener("enterFrame",this.onLightMcEnter);
                this._lightMc.gotoAndPlay(1);
            }
            MotionEffects.execElastic(this._content);
        }

        private function onLightMcEnter(evt:Event) : void
        {
            if(this._lightMc.currentFrame == this._lightMc.totalFrames)
            {
                this._lightMc.removeEventListener("enterFrame",this.onLightMcEnter);
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
            this._skinType = false;
            this._icon.removeIcon();
            this._nameTxt.text = "";
            this.mouseEnabled = false;
            this._info = null;
            this._skinId = 0;
            this.selected = false;
        }

        public function setPetInfo(info:PetInfo) : void
        {
            this.reset();
            this._skinType = false;
            this._info = info;
            if(this._info != null)
            {
                this.mouseEnabled = true;
                this.updateDisplay();
            }
        }

        public function setSkinInfo(petInfo:PetInfo,skinId:uint) : void
        {
            this.reset();
            this._skinType = true;
            this._info = petInfo;
            this._skinId = skinId;
            if(this._skinId != 0)
            {
                this.mouseEnabled = true;
                this.updateSkinDisplay();
            }
        }

        private function updateSkinDisplay() : void
        {
            this.loadPreview(this._skinId);
            this.updateSimpleInfo();
        }

        private function updateDisplay() : void
        {
            this.loadPreview(this._info.resourceId);
            this.updateSimpleInfo();
        }

        private function updateSimpleInfo() : void
        {
            if(this._skinType)
            {
                if(true)
                {
                    this._nameTxt.text = PetConfig.getPetDefinition(this._skinId).name;
                }
                else
                {
                    this._nameTxt.text = PetSkinDefineConfig.getSkinName(this._info.resourceId, this._skinId);
                }
            }
            else
            {
                this._nameTxt.text = PetConfig.getPetDefinition(this._info.resourceId).name;
            }
        }

        private function loadPreview(resId:uint) : void
        {
            var url:String = String(URLUtil.getPetIcon(resId));
            this._icon.setIconUrl(url,this.onContentLoaded);
        }

        private function onContentLoaded() : void
        {
            DisplayObjectUtil.enableSprite(this);
        }

        public function set selected(value:Boolean) : void
        {
            this._selector.visible = value;
        }

        public function get petInfo() : PetInfo
        {
            return this._info;
        }

        public function get skinId():uint
        {
            return this._skinId;
        }
    }
}
