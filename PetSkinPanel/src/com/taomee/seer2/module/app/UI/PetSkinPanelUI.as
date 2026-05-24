package com.taomee.seer2.module.app.UI
{
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.text.TextField;

[Embed(source="/_assets/assets.swf", symbol="PetSkinPanelUI")]
public dynamic class PetSkinPanelUI extends MovieClip
{
    public var changeBtn:SimpleButton;

    public var closeBtn:SimpleButton;

    public var dragMC:MovieClip;

    public var newSearchBtn:SimpleButton;

    public var nextBtn:SimpleButton;

    public var noSkinTip:MovieClip;

    public var petName:TextField;

    public var preBtn:SimpleButton;

    public var ruleBtn:SimpleButton;

    public var rulePanel:MovieClip;

    public var searchBtn:SimpleButton;

    public var searchTxt:TextField;

    public var searchBg:MovieClip;

    public var skinName:TextField;

    public var useBtn:SimpleButton;

    public function PetSkinPanelUI()
    {
        super();
    }
}
}

