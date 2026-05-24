package com.taomee.seer2.module.app
{
import com.taomee.seer2.module.app.lottery.calendarPanelUI;
import com.taomee.seer2.core.module.ModuleManager;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;

public dynamic class calendarPanel extends childPanel
{

    private var _announceBtn:SimpleButton;

    private var _activeBtn:SimpleButton;

    private var _cheatBtn:SimpleButton;

    public function calendarPanel() {
        super();
        this._mc = new calendarPanelUI();
        this.initialize();
        this.initSet();
        this.initEvent();
    }

    private function initSet():void
    {
        this._announceBtn = this._mc["announceBtn"];
        this._activeBtn = this._mc["activeBtn"];
        this._cheatBtn = this._mc["cheatBtn"];
    }

    private function initEvent():void
    {
        this._announceBtn.addEventListener("click",function (e:MouseEvent):void
        {
            ModuleManager.showAppModule("WinterSignPanel");
        });
        this._activeBtn.addEventListener("click",function (e:MouseEvent):void
        {
            ModuleManager.showAppModule("ActCalendarPanel");
        });
        this._cheatBtn.addEventListener("click",function (e:MouseEvent):void
        {
            ModuleManager.showAppModule("GetedItemSwapPanel");
        });
    }
}
}
