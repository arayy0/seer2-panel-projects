package com.taomee.seer2.module.app
{
import flash.display.MovieClip;
import flash.display.SimpleButton;

[Embed(source="/_assets/assets.swf", symbol="TestPanelUI")]
public dynamic class TestPanelUI extends MovieClip
{

    public var closeBtn:SimpleButton;

    public var cover:MovieClip;

    public function TestPanelUI()
    {
        super();
    }
}
}
