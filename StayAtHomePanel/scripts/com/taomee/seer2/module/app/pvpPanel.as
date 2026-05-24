package com.taomee.seer2.module.app
{
import com.taomee.seer2.core.module.ModuleManager;
import com.taomee.seer2.core.scene.SceneManager;
import com.taomee.seer2.core.scene.SceneType;
import com.taomee.seer2.module.app.lottery.pvpPanelUI;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;

public dynamic class pvpPanel extends childPanel
{

    private var _skyBtn:SimpleButton;

    private var _spaceBtn:SimpleButton;

    private var _tenBtn:SimpleButton;

    private var _randomBtn:SimpleButton;

    private var _windBtn:SimpleButton;

    private var _nobirdBtn:SimpleButton;

    public function pvpPanel()
    {
        super();
        this._mc = new pvpPanelUI();
        this.initialize();
        this.initSet();
        this.initEvent();
    }

    private function initSet():void
    {
        this._nobirdBtn = this._mc["nobirdBtn"];
        this._randomBtn = this._mc["randomBtn"];
        this._skyBtn = this._mc["skyBtn"];
        this._spaceBtn = this._mc["spaceBtn"];
        this._tenBtn = this._mc["tenBtn"];
        this._windBtn = this._mc["windBtn"];
    }

    private function initEvent():void
    {
        this._nobirdBtn.addEventListener("click",function(e:MouseEvent):void
        {
            ModuleManager.showAppModule("NoPoultryBattleFieldMainPanel");
        });
        this._randomBtn.addEventListener("click",function(e:MouseEvent):void
        {
            ModuleManager.showAppModule("PetMeleePanel");
        });
        this._skyBtn.addEventListener("click",function(e:MouseEvent):void
        {
            ModuleManager.showAppModule("SkySportsPanel");
        });
        this._spaceBtn.addEventListener("click",function(e:MouseEvent):void
        {
            ModuleManager.showAppModule("SpaceAltrlMainPanel");
        });
        this._tenBtn.addEventListener("click",function(e:MouseEvent):void
        {
            ModuleManager.showAppModule("PetMelee2Panel");
        });
        this._windBtn.addEventListener("click",function(e:MouseEvent):void
        {
            ModuleManager.showAppModule("YufengPvpPanel");
        });
        this.initWarningEvent(this._windBtn,"御风竞技必须要在御风赛场进行，将离开小屋前往御风赛场");
    }
}
}
