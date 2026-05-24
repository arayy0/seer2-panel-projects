package com.taomee.seer2.module.app
{
import com.taomee.seer2.core.module.ModuleManager;
import com.taomee.seer2.core.scene.SceneManager;
import com.taomee.seer2.core.scene.SceneType;
import com.taomee.seer2.module.app.lottery.getPetPanelUI;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;

public dynamic class getPetPanel extends childPanel
{
    private var _dreamBtn:SimpleButton;

    private var _dictionaryBtn:SimpleButton;
    public function getPetPanel()
    {
        super();
        this._mc = new getPetPanelUI();
        this.initialize();
        this.initSet();
        this.initEvent();
    }

    private function initSet():void
    {
        this._dreamBtn = this._mc["dreamBtn"];
        this._dictionaryBtn = this._mc["dictionaryBtn"];
    }

    private function initEvent():void
    {
        this._dreamBtn.addEventListener("click",function(e:MouseEvent):void
        {
            SceneManager.changeScene(SceneType.LOBBY,3840);
        });
        this.initWarningEvent(this._dreamBtn,"需要前往永恒梦境，将离开小屋");
        this._dictionaryBtn.addEventListener("click",function(e:MouseEvent):void
        {
            ModuleManager.showAppModule("PetDictionary");
        });
        this.initWarningEvent(this._dictionaryBtn,"精灵图鉴中某些精灵获取方式可能需要离开小屋");
    }
}
}
