package com.taomee.seer2.module.app
{
import com.taomee.seer2.module.core.TopModule;
import com.taomee.seer2.app.manager.DayLimitListManager;
import com.taomee.seer2.app.activeCount.ActiveCountManager;
import com.taomee.seer2.app.info.DayLimitListInfo;
import com.taomee.seer2.app.net.Command;
import com.taomee.seer2.app.net.Connection;
import com.taomee.seer2.app.net.parser.Parser_1142;
import com.taomee.seer2.core.net.MessageEvent;
import com.taomee.seer2.core.utils.DisplayObjectUtil;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;

public class YueseCraft2016MainPanel extends TopModule
{
    private var _bookPanelVec:Vector.<BookBase>;

    private var _btnVec:Vector.<SimpleButton>;

    private var _signStep:int;

    private var _team:int;

    public function YueseCraft2016MainPanel()
    {
        super();
        _lifecycleType = "global";
    }

    override public function setup():void
    {
        setMainUI(new YueseCraft2016MainUI);
        this.initSet();
        this.initEvent();
    }

    private function initSet():void
    {
        var i:int = 0;
        this._bookPanelVec = new Vector.<BookBase>();
        this._bookPanelVec.push(new BookPanel0());
        this._bookPanelVec.push(new BookPanel1());
        this._bookPanelVec.push(new BookPanel2());
        this._bookPanelVec.push(new BookPanel3());
        for(i = 0;i<_bookPanelVec.length;i++)
        {
            addChild(this._bookPanelVec[i]);
            this._bookPanelVec[i].x=25;
            this._bookPanelVec[i].y=90;
            this._bookPanelVec[i].visible = false;
        }
        this._btnVec = new Vector.<SimpleButton>();
        for(i = 0; i < 4; i++)
        {
            this._btnVec.push(_mainUI["btn" + i]);
        }
        ActiveCountManager.requestActiveCountList([206356,206357],function(par:Parser_1142):void
        {
            _team = par.infoVec[0];
            _signStep = par.infoVec[1];
            if(_signStep < 2)
            {
                DisplayObjectUtil.disableButton(_btnVec[1]);
                DisplayObjectUtil.disableButton(_btnVec[2]);
            }
            else
            {
                DisplayObjectUtil.enableButton(_btnVec[0]);
                DisplayObjectUtil.enableButton(_btnVec[1]);
                DisplayObjectUtil.enableButton(_btnVec[2]);
                DisplayObjectUtil.enableButton(_btnVec[3]);
            }
        });
        this._bookPanelVec[3].visible = true;
    }

    private function initEvent():void
    {
        _mainUI["closeBtn"].addEventListener("click",onClose);
        for(var i:int = 0;i < this._btnVec.length;i++)
        {
            this._btnVec[i].addEventListener("click",this.onClick);
        }
        Connection.addCommandListener(Command.getCommand(1055),this.onReset);
    }

    private function onClick(e:MouseEvent):void
    {
        for(var i:int = 0;i < this._btnVec.length; i++)
        {
            if(e.target == this._btnVec[i])
            {
                this._bookPanelVec[i].resetData();
                this._bookPanelVec[i].visible = true;
            }
            else
            {
                this._bookPanelVec[i].visible = false;
            }
        }
    }

    private function resetData():void
    {
        DisplayObjectUtil.disableButton(_btnVec[0]);
        DisplayObjectUtil.disableButton(_btnVec[1]);
        DisplayObjectUtil.disableButton(_btnVec[2]);
        DisplayObjectUtil.disableButton(_btnVec[3]);
        ActiveCountManager.requestActiveCountList([206356,206357],function(par:Parser_1142):void
        {
            _team = par.infoVec[0];
            _signStep = par.infoVec[1];
            if(_signStep < 2)
            {
                DisplayObjectUtil.enableButton(_btnVec[0]);
                DisplayObjectUtil.enableButton(_btnVec[3]);
            }
            else
            {
                DisplayObjectUtil.enableButton(_btnVec[0]);
                DisplayObjectUtil.enableButton(_btnVec[1]);
                DisplayObjectUtil.enableButton(_btnVec[2]);
                DisplayObjectUtil.enableButton(_btnVec[3]);
            }
        });
    }

    private function onReset(e:MessageEvent = null):void
    {
        this.resetData();
        for(var i:int = 0;i<this._bookPanelVec.length;i++)
        {
            this._bookPanelVec[i].resetData();
        }
    }

    override public function dispose():void
    {
        for(var i:int = 0;i < this._btnVec.length;i++)
        {
            this._btnVec[i].removeEventListener("click",this.onClick);
        }
        Connection.removeCommandListener(Command.getCommand(1055),this.onReset);
        super.dispose();
    }
}
}
