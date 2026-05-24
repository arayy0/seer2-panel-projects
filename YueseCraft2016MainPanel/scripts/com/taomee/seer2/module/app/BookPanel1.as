package com.taomee.seer2.module.app
{
import com.taomee.seer2.app.activeCount.ActiveCountManager;
import com.taomee.seer2.app.manager.DayLimitListManager;
import com.taomee.seer2.app.swap.SwapManager;
import com.taomee.seer2.app.swap.special.SpecialInfo;
import com.taomee.seer2.app.net.parser.Parser_1142;
import com.taomee.seer2.app.popup.AlertManager;
import com.taomee.seer2.app.net.Command;
import com.taomee.seer2.app.net.Connection;
import com.taomee.seer2.app.info.DayLimitListInfo;
import com.taomee.seer2.app.vip.VipManager;
import com.taomee.seer2.core.net.MessageEvent;
import com.taomee.seer2.app.inventory.ItemManager;
import com.taomee.seer2.core.utils.DisplayObjectUtil;
import com.taomee.seer2.core.module.ModuleManager;
import com.taomee.seer2.core.ui.toolTip.TooltipManager;
import org.taomee.utils.BitUtil;
import flash.events.MouseEvent;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
public dynamic class BookPanel1 extends BookBase
{
    private var _mc:MovieClip;

    private var _bossMc:MovieClip;

    private var _swapPanel:MovieClip;

    private var _fightBtnVec:Vector.<SimpleButton>;

    private var _swapBtnVec:Vector.<SimpleButton>;

    private var _teamNumber:int;

    private var _bossTime:Array;

    private var _allTime:int;

    private const BOSS_ID_VEC:Array=[[1939,1940],[1938,1940],[1938,1939]];

    private const PET_SWAP_TEAM_VEC:Array = [[1,2],[0,2],[0,1]];
    public function BookPanel1()
    {
        super();
        this._mc = new BookUI1;
        this.initialize();
        this.initEvent();
    }

    private function initialize():void
    {
        var i:int;
        addChild(this._mc);
        this._bossMc = this._mc["bossMc"];
        this._bossMc.gotoAndStop(1);
        this._fightBtnVec = new Vector.<SimpleButton>();
        this._fightBtnVec.push(this._mc["btn20"]);
        this._fightBtnVec.push(this._mc["btn21"]);
        this._swapBtnVec = new Vector.<SimpleButton>();
        this._swapBtnVec.push(this._mc["btn23"]);
        this._swapBtnVec.push(this._mc["btn24"]);
        this._allTime = VipManager.vipInfo.isVip()?2:1;
        this._swapPanel = this._mc["swapPanel"];
        this._swapPanel.visible = false;
        this._swapPanel["petList"].gotoAndStop(1);
        TooltipManager.addCommonTip(this._swapPanel["xIcon"],"X勋章,积累登陆30天后在“约瑟传说5周年感恩大回馈”活动中兑换");
        TooltipManager.addCommonTip(this._swapPanel["yIcon"],"Y勋章,在商城“精灵购买-其他”分类中购买");
        TooltipManager.addCommonTip(this._swapPanel["zIcon"],"Z勋章,在本活动中一天内战胜两只BOSS后获得");
    }

    private function initEvent():void
    {
        var i:int;
        this._fightBtnVec[0].addEventListener("click",this.onFight);
        this._fightBtnVec[1].addEventListener("click",this.onFight);
        this._swapBtnVec[0].addEventListener("click",this.onSwap);
        this._swapBtnVec[1].addEventListener("click",this.onSwap);
        this._mc["swapPanel"]["closeSwap"].addEventListener("click",this.swapShow);
        this._mc["btn22"].addEventListener("click",this.swapShow);
        this._swapPanel["swap0"].addEventListener("click",this.onSwap);
        this._swapPanel["swap1"].addEventListener("click",this.onSwap);
    }

    private function onFight(e:MouseEvent):void
    {
        if(e.target == this._fightBtnVec[0])
        {
            if(this._mc["time0"].text == "0")
            {
                AlertManager.showAlert("今日次数耗尽");
                return;
            }
            Connection.send(Command.getCommand(1500),(this.BOSS_ID_VEC[this._teamNumber - 1][0] - 118));
        }
        else if(e.target == this._fightBtnVec[1])
        {
            if(this._mc["time1"].text == "0")
            {
                AlertManager.showAlert("今日次数耗尽");
                return;
            }
            Connection.send(Command.getCommand(1500),(this.BOSS_ID_VEC[this._teamNumber - 1][1] - 118));
        }
    }

    private function onSwap(e:MouseEvent):void
    {
        if(e.target == this._swapBtnVec[3 - 3])
        {
            ModuleManager.showAppModule("ChuanShuoZhuiSuBuyPanel");
        }
        else if(e.target == this._swapBtnVec[4 - 3])
        {
            SwapManager.swapItem(4560,1,null,function():void
            {
                AlertManager.showAlert("已经领取过");
            },new SpecialInfo(2,0,this._teamNumber-1));
        }
        else if(e.target == this._swapPanel["swap0"])
        {
            SwapManager.swapItem(4560,1,null,function():void
            {
                AlertManager.showAlert("还未集齐XYZ勋章");
            },new SpecialInfo(2,1,this.PET_SWAP_TEAM_VEC[this._teamNumber - 1][0]));
        }
        else if(e.target == this._swapPanel["swap1"])
        {
            SwapManager.swapItem(4560,1,null,function():void
            {
                AlertManager.showAlert("还未集齐XYZ勋章");
            },new SpecialInfo(2,1,this.PET_SWAP_TEAM_VEC[this._teamNumber - 1][1]));
        }
    }

    private function getLegends(e:MessageEvent):void
    {
        Connection.removeCommandListener(Command.getCommand(1055),this.getLegends);
        Connection.removeErrorHandler(Command.getCommand(1055),this.getLegends);
        SwapManager.swapItem(4560,1,null,function():void
        {
            AlertManager.showAlert("已经领取过");
        },new SpecialInfo(2,0,this._teamNumber-1));
    }

    private function swapShow(e:MouseEvent):void
    {
        if(e.target == this._mc["btn22"])
        {
            this._mc["swapPanel"].visible = true;
        }
        else if(e.target == this._mc["swapPanel"]["closeSwap"])
        {
            this._mc["swapPanel"].visible = false;
        }
    }

    private function resetPanel1():void
    {
        this._bossMc.gotoAndStop(this._teamNumber);
        if(this._teamNumber>0)
        {
            this._mc["time0"].text=(this._allTime - this._bossTime[0]).toString();
            this._mc["time1"].text=(this._allTime - this._bossTime[1]).toString();
            this._swapPanel["petList"].gotoAndStop(this._teamNumber);
        }
        this._swapPanel["xnum"].text = ItemManager.getItemQuantityByReferenceId(401275) + "";
        this._swapPanel["ynum"].text = ItemManager.getItemQuantityByReferenceId(401279) + "";
        this._swapPanel["znum"].text = ItemManager.getItemQuantityByReferenceId(401280) + "";
    }

    override public function resetData(e:MessageEvent = null):void
    {
        DayLimitListManager.getDaylimitList([1938,1939,1940,1941],function callback(info:DayLimitListInfo):void
        {
            ActiveCountManager.requestActiveCountList([206356,206371],function(par:Parser_1142):void
            {
                _teamNumber = par.infoVec[0];
                if(_teamNumber>0)
                {
                    _bossTime = [int(info.getCount(BOSS_ID_VEC[_teamNumber - 1][0])),int(info.getCount(BOSS_ID_VEC[_teamNumber - 1][1]))];
                }
                if(BitUtil.getBit(par.infoVec[1],4) != 0)
                {
                    DisplayObjectUtil.disableButton(_swapPanel["swap0"]);
                    DisplayObjectUtil.disableButton(_swapPanel["swap1"]);
                }
                else
                {
                    DisplayObjectUtil.enableButton(_swapPanel["swap0"]);
                    DisplayObjectUtil.enableButton(_swapPanel["swap1"]);
                }
                resetPanel1();
            });
        });
    }
}
}
