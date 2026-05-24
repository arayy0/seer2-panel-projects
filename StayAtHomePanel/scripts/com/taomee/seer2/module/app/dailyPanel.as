package com.taomee.seer2.module.app
{
import com.taomee.seer2.module.app.lottery.dailyPanelUI;
import com.taomee.seer2.core.module.ModuleManager;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;

public dynamic class dailyPanel extends childPanel
{

    private var _packageBtn:SimpleButton;

    private var _redpackageBtn:SimpleButton;

    private var _rewardBtn:SimpleButton;

    private var _wishBtn:SimpleButton;
    public function dailyPanel()
    {
        super();
        this._mc = new dailyPanelUI();
        this.initialize();
        this.initSet();
        this.initEvent();
    }

    private function initSet():void
    {
        this._packageBtn = this._mc["packageBtn"];
        this._redpackageBtn = this._mc["redpackageBtn"];
        this._rewardBtn = this._mc["rewardBtn"];
        this._wishBtn = this._mc["wishBtn"];
    }

    private function initEvent():void
    {
        this._packageBtn.addEventListener("click",function(e:MouseEvent):void
        {
            ModuleManager.showAppModule("HalloweenScreamPanel");
        });
        this._redpackageBtn.addEventListener("click",function(e:MouseEvent):void
        {
            ModuleManager.showAppModule("NewYearGetMiPanel");
        });
        this._rewardBtn.addEventListener("click",function(e:MouseEvent):void
        {
            ModuleManager.showAppModule("OnlineRewardPanel");
        });
        this._wishBtn.addEventListener("click",function(e:MouseEvent):void
        {
            ModuleManager.showAppModule("TwoYearWishPanel");
        });
    }
}
}
