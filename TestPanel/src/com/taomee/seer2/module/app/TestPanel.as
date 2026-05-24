package com.taomee.seer2.module.app
{
import com.taomee.seer2.app.component.IconDisplayer;
import com.taomee.seer2.core.module.Module;
import com.taomee.seer2.core.utils.URLUtil;

import flash.display.MovieClip;

public class TestPanel extends Module
{
    private var _iconCover:MovieClip;

    private var _displayer:IconDisplayer;

    public function TestPanel()
    {
        super();
        _lifecycleType = "global";
    }

    override public function setup() : void
    {
        setMainUI(new TestPanelUI());
        this.initSet();
        this.initEvent();
    }

    private function initSet() : void
    {
        this._iconCover = _mainUI["cover"];
        this._displayer = new IconDisplayer();
        this._displayer.x = this._iconCover.x;
        this._displayer.y = this._iconCover.y;
        addChild(this._displayer);
        this._displayer.mask = this._iconCover;
        var url:String = String(URLUtil.getPetIcon(8));
        this._displayer.setIconUrl(url);
    }

    private function initEvent() : void
    {

    }
}
}
