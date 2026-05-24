package com.taomee.seer2.module.app
{
import com.taomee.seer2.core.module.ModuleManager;
import com.taomee.seer2.module.app.lottery.missionPanelUI;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;

public dynamic class missionPanel extends childPanel
{

    private var _trainerBtn:SimpleButton;

    private var _mainmissionBtn:SimpleButton;
    public function missionPanel()
    {
        super();
        this._mc = new missionPanelUI();
        this.initialize();
        this.initSet();
        this.initEvent();
    }

    private function initSet():void
    {
        this._mainmissionBtn = this._mc["mainmissionBtn"];
        this._trainerBtn = this._mc["trainerBtn"];
    }

    private function initEvent():void
    {
        this._trainerBtn.addEventListener("click",function(e:MouseEvent):void
        {
           ModuleManager.showAppModule("TrainerPanel");
        });
        this.initWarningEvent(this._trainerBtn,"训练师手册中任务可能需要离开小屋");
        this._mainmissionBtn.addEventListener("click",function(e:MouseEvent):void
        {
            ModuleManager.showAppModule("QuestPanel");
        });
        this.initWarningEvent(this._mainmissionBtn,"某些任务可能需要离开小屋");
    }
}
}
