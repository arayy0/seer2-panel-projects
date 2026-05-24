package com.taomee.seer2.module.app {
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
public class BookPanel3 extends BookBase
{
    private var _mc:MovieClip;
    public function BookPanel3()
    {
        super();
        this._mc = new BookUI3;
        this.initialize();
    }

    private function initialize():void
    {
        addChild(this._mc);
    }
}
}
