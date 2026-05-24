package com.taomee.seer2.module.app.moduleCommon
{
import com.taomee.seer2.app.component.IconDisplayer;

import com.taomee.seer2.core.ui.toolTip.TooltipManager;
import com.taomee.seer2.core.utils.URLUtil;

import flash.display.Sprite;

public class PetFeatureIcon extends Sprite
{


    private var _featureIcon:IconDisplayer;

    public function PetFeatureIcon()
    {
        super();
        this.initialize();
        scaleY = 0.9;
        scaleX = 0.9;
    }

    private function initialize() : void
    {
        this.createChildren();
    }

    private function createChildren() : void
    {
        this._featureIcon = new IconDisplayer();
        this._featureIcon.setBoundary(45,21);
        TooltipManager.addCommonTip(this._featureIcon,"");
        addChild(this._featureIcon);
    }

    public function setFeature(id:int, tip:String) : void
    {
        if(id == 0)
        {
            id = 1999;
            this._featureIcon.mouseEnabled = false;
            this._featureIcon.mouseChildren = false;
            this._featureIcon.buttonMode = false;
        }
        else
        {
            this._featureIcon.mouseEnabled = true;
            this._featureIcon.mouseChildren = true;
            this._featureIcon.buttonMode = true;
        }
        this._featureIcon.setIconUrl(URLUtil.getFeatureIcon(id));
        TooltipManager.changeTip(this._featureIcon,tip);
    }
}
}
