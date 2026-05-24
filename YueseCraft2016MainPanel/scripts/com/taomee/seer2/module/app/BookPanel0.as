package com.taomee.seer2.module.app
{
import com.taomee.seer2.app.activeCount.ActiveCountManager;
import com.taomee.seer2.app.actives.YueseCraft2016Act;
import com.taomee.seer2.app.net.Command;
import com.taomee.seer2.app.net.Connection;
import com.taomee.seer2.app.net.parser.Parser_1142;
import com.taomee.seer2.app.popup.AlertManager;
import com.taomee.seer2.app.swap.SwapManager;
import com.taomee.seer2.app.swap.special.SpecialInfo;
import com.taomee.seer2.core.utils.DisplayObjectUtil;
import com.taomee.seer2.core.net.MessageEvent;
import com.taomee.seer2.core.module.ModuleManager;
import com.taomee.seer2.core.scene.SceneManager;
import com.taomee.seer2.core.scene.SceneType;
import flash.events.MouseEvent;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
public class BookPanel0 extends BookBase
{
    private var _mc:MovieClip;

    private var _storyStep:int;

    private var _teamNumber:int;

    private var _lightMoney:int;

    private var _teamIcon:MovieClip;

    private var _teamPet:MovieClip;

    private var _btn0Vec:Vector.<SimpleButton>;

    public function BookPanel0()
    {
        super();
        this._mc = new BookUI0;
        this.initialize();
    }

    private function initialize():void
    {
        addChild(this._mc);
        this._teamIcon = this._mc["teamIcon"];
        this._teamPet = this._mc["teamPet"];
        this._teamIcon.gotoAndStop(1);
        this._teamPet.gotoAndStop(1);
        this._btn0Vec = new Vector.<SimpleButton>();
        for(var i:int = 0;i < 4;i++)
        {
            this._btn0Vec.push(this._mc["btn1"+i]);
        }
        this.resetData();
        this.initEvent();
    }

    private function initEvent():void
    {
        for(var i:int = 0;i < 4;i++)
        {
            this._btn0Vec[i].addEventListener("click",this.onClick1);
        }
    }

    private function onClick1(e:MouseEvent = null):void
    {
        this._mc.gotoAndStop(3);
        if(e.target == this._btn0Vec[0])
        {
            YueseCraft2016Act.instance.initStep1();
        }
        else if(e.target == this._btn0Vec[1])
        {
            YueseCraft2016Act.instance.initStep2();
        }
        else if(e.target == this._btn0Vec[2])
        {
            YueseCraft2016Act.instance.army = this._teamNumber;
            SceneManager.changeScene(SceneType.LOBBY,int(YueseCraft2016Act.instance.ARMY_MAP_IDS[this._teamNumber - 1]));
        }
        else if(e.target == this._btn0Vec[3])
        {
            SceneManager.changeScene(SceneType.LOBBY,3858);
        }
    }

    private function clean():void
    {
        for(var i:int = 0;i < 4;i++)
        {
            DisplayObjectUtil.disableButton(_btn0Vec[i]);
            _btn0Vec[i].visible = false;
        }
        _teamIcon.gotoAndStop(1);
        _teamPet.gotoAndStop(1);
    }

    private function resetPanel0():void
    {
        this.clean();
        YueseCraft2016Act.instance.army = this._teamNumber;
        _teamIcon.gotoAndStop(this._teamNumber + 1);
        _teamPet.gotoAndStop(this._teamNumber + 1);
        for(var j:int =0;j <= this._storyStep;j++)
        {
            _btn0Vec[j].visible = true;
        }
        DisplayObjectUtil.enableButton(_btn0Vec[this._storyStep]);
    }

    override public function resetData(e:MessageEvent = null):void
    {
        ActiveCountManager.requestActiveCountList([206356,206357],function(par:Parser_1142):void
        {
            _teamNumber = par.infoVec[0];
            _storyStep = par.infoVec[1];
            resetPanel0();
        });
    }

    private function onswap(e:MessageEvent = null):void
    {
        Connection.removeCommandListener(Command.getCommand(1055),this.onswap);
        SwapManager.swapItem(4560,1,null,null,new SpecialInfo(1,this._teamNumber));
    }
}
}
