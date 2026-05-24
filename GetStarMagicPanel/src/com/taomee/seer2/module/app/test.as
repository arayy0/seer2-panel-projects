package com.taomee.seer2.module.app
{
import com.taomee.seer2.app.activeCount.ActiveCountManager;
import com.taomee.seer2.app.actor.ActorManager;
import com.taomee.seer2.app.inventory.ItemManager;
import com.taomee.seer2.app.manager.StatisticsManager;
import com.taomee.seer2.app.net.CommandSet;
import com.taomee.seer2.app.net.Connection;
import com.taomee.seer2.app.net.parser.Parser_1142;
import com.taomee.seer2.app.popup.ServerMessager;
import com.taomee.seer2.app.shopManager.ShopManager;
import com.taomee.seer2.app.starMagic.StarInfo;
import com.taomee.seer2.app.starMagic.StarMagicManager;
import com.taomee.seer2.app.swap.SwapManager;
import com.taomee.seer2.core.module.Module;
import com.taomee.seer2.core.module.ModuleManager;
import com.taomee.seer2.core.net.MessageEvent;
import com.taomee.seer2.core.utils.DisplayObjectUtil;
import com.taomee.seer2.core.utils.URLUtil;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;
import org.taomee.utils.Tick;

public class test extends Module
{
    private static var STATE_STOP:int = 0;

    private static var STATE_MOVEONCE:int = 1;

    private static var STATE_SELL:int = 2;

    private static var STATE_GETALLSTAR:int = 3;

    private static var StarNum:int = 16;

    private static var FOR_MONEY:int = 204494;

    private static var FOR_BTN:int = 204491;

    private var _suo:Vector.<MovieClip>;

    private var _getBtn:Vector.<SimpleButton>;

    private var _icon:Vector.<StarMagicIcon>;

    private var pos:Vector.<MovieClip>;

    private var getState:int = STATE_STOP;

    private var _starMagicTip:StarMagicTip;

    private var needMoney:Array = [2000,3000,4000,8000,12000];

    private var _onceZhao:int = 0;

    private var _onceZhaoTime:int = 0;

    private var _onceZhaoIndex:int = 0;

    public var isOpen:Boolean;

    private var getPR:int = 0;

    private var myTimer:Timer;

    private var purpleTime:int = 0;

    private var purplePowerTime:int = 0;

    private var oncePowerTime:int = 0;

    private var powerType:int = 0;

    public function test()
    {
        super();
        _lifecycleType = "global";
    }

    override public function setup() : void
    {
        setMainUI(null);
        this.initSet();
    }

    override public function init(data:Object) : void
    {
    }

    override public function show() : void
    {
        super.show();
        _mainUI["superShow"].visible = false;
        StatisticsManager.newSendNovice("2014系统","星魂","获取星魂面板打开");
        this._onceZhao = 0;
        this.showMc();
        this.getState = STATE_STOP;
        this.addEvent();
        this.resetPos();
        this.getTempStar();
        this.update();
        this.updateVis();
        _mainUI["showMc"].gotoAndStop(1);
    }

    private function updateVis() : void
    {
        var i:int = 0;
        i = 0;
        while(i < this._icon.length)
        {
            this._icon[i].alpha = 1;
            this._icon[i].visible = true;
            this._icon[i].setmoveState(0);
            i++;
        }
    }

    override public function hide() : void
    {
        super.hide();
        this.removeEvent();
    }

    private function showMc() : void
    {
        var i:int = 0;
        i = 1;
        while(i < 5)
        {
            _mainUI["show" + i].gotoAndStop(1);
            i++;
        }
        Tick.instance.addRender(this.onTickShow,24);
    }

    private function initSet() : void
    {
        var i:int = 0;
        this._starMagicTip = new StarMagicTip();
        this._starMagicTip.mouseEnabled = false;
        this._starMagicTip.mouseChildren = false;
        this._starMagicTip.visible = false;
        _mainUI.addChild(this._starMagicTip);
        this._icon = new Vector.<StarMagicIcon>();
        this.pos = new Vector.<MovieClip>();
        this._suo = new Vector.<MovieClip>();
        this._getBtn = new Vector.<SimpleButton>();
        this._closeBtn = _mainUI["closeBtn"];
        this.myTimer = new Timer(514,114);
        _mainUI["ruleUI"].visible = false;
        _mainUI["more2Btn"].visible = false;
        _mainUI["oncePowerBtn"].visible = false;
        _mainUI["purplePowerBtn"].visible = false;
        ItemManager._getCoinsMessageSwitch = false;
        i = 0;
        while(i < StarNum)
        {
            this._icon[i] = new StarMagicIcon(0,0);
            this._icon[i].mouseChildren = false;
            _mainUI.addChild(this._icon[i]);
            this.pos.push(_mainUI["pos" + i]);
            i++;
        }
        i = 0;
        while(i < 5)
        {
            this._suo.push(_mainUI["suo" + i]);
            this._getBtn.push(_mainUI["getBtn" + i]);
            i++;
        }
        SimpleButton(_mainUI["buyBtn"]).addEventListener("click",this.onBuy);
    }

    private function onBuy(e:MouseEvent) : void
    {
        ShopManager.buyItemForId(606766,function(p:*):void
        {
            update();
        });
    }

    private function addEvent() : void
    {
        var i:int = 0;
        Tick.instance.addRender(this.onRender,24);
        _mainUI["bagBtn"].addEventListener("click",this.onClick);
        _mainUI["sellSuipianBtn"].addEventListener("click",this.onClick);
        _mainUI["getHunBtn"].addEventListener("click",this.onClick);
        _mainUI["onceGetBtn"].addEventListener("click",this.onClick);
        _mainUI["purpleBtn"].addEventListener("click",this.onPurple);
        _mainUI["ruleBtn"].addEventListener("click",this.openRule);
        _mainUI["ruleUI"]["close2"].addEventListener("click",this.closeRule);
        _mainUI["more0Btn"].addEventListener("click",this.onGetP);
        _mainUI["more1Btn"].addEventListener("click",this.onNo);
        _mainUI["more2Btn"].addEventListener("click",this.onNo);
        _mainUI["purplePowerBtn"].addEventListener("click",this.onPowerClick);
        _mainUI["oncePowerBtn"].addEventListener("click",this.onPowerClick);
        this._closeBtn.addEventListener("click",this.onClose);
        i = 0;
        while(i < 5)
        {
            this._getBtn[i].addEventListener("click",this.onClick);
            i++;
        }
        i = 0;
        while(i < this._icon.length)
        {
            this._icon[i].addEventListener("mouseOver",this.onMouseOver);
            this._icon[i].addEventListener("mouseOut",this.onMouseOut);
            i++;
        }
    }

    private function onMouseOver(e:MouseEvent) : void
    {
        var i:int = 0;
        i = 0;
        while(i < this._icon.length)
        {
            if(e.target == this._icon[i])
            {
                if(this._icon[i].indexId == 0)
                {
                    return;
                }
                this.addTip(this._icon[i].getInfo());
                break;
            }
            i++;
        }
        trace("覆盖ICON");
    }

    private function onMouseOut(e:MouseEvent) : void
    {
        trace("覆盖ICON");
        this.removeTip(null);
    }

    private function addTip(info:StarInfo) : void
    {
        this._starMagicTip.update(info);
        this._starMagicTip.visible = true;
        this._starMagicTip.x = mouseX - 10;
        this._starMagicTip.y = mouseY - 30;
        _mainUI.setChildIndex(this._starMagicTip,_mainUI.numChildren - 1);
    }

    private function removeTip(info:StarInfo) : void
    {
        this._starMagicTip.visible = false;
    }

    private function removeEvent() : void
    {
        var i:int = 0;
        Tick.instance.removeRender(this.onRender);
        _mainUI["sellSuipianBtn"].removeEventListener("click",this.onClick);
        _mainUI["getHunBtn"].removeEventListener("click",this.onClick);
        _mainUI["onceGetBtn"].removeEventListener("click",this.onClick);
        i = 0;
        while(i < 5)
        {
            this._getBtn[i].removeEventListener("click",this.onClick);
            i++;
        }
    }

    private function onClick(e:MouseEvent) : void
    {
        var i:int = 0;
        if(this.getState != 0 && this._onceZhao != 0)
        {
            return;
        }
        if(e.target == _mainUI["sellSuipianBtn"])
        {
            ItemManager._getCoinsMessageSwitch = false;
            this.onceGetHun(this.showOnceGet,this.showOnceGet);
            StarMagicManager.sellStar(2,2,2,this.showSellSuiPian,this.showSellSuiPian);
        }
        else
        {
            if(e.target == _mainUI["bagBtn"])
            {
                ItemManager._getCoinsMessageSwitch = true;
                ModuleManager.closeForName("GetStarMagicPanel");
                ModuleManager.showModule(URLUtil.getAppModule("StarMagicBagPanel"),"正在打开拔面板...");
                return;
            }
            if(e.target == _mainUI["getHunBtn"])
            {
                if(StarMagicManager.getTempStarNum(2) <= 0)
                {
                    ServerMessager.addMessage("目前没有可拾取的星魂!");
                    return;
                }
                if(StarMagicManager.getDepotStarNum() >= StarMagicManager.depotNum)
                {
                    ServerMessager.addMessage("星魂背包已满暂时无法拾取!");
                    return;
                }
                this.getState = STATE_MOVEONCE;
                this.onceGetHun(this.showOnceGet,this.showOnceGet);
            }
            else if(e.target == _mainUI["onceGetBtn"])
            {
                ItemManager._getCoinsMessageSwitch = false;
                if(StarMagicManager.getTempStarNum(2) + StarMagicManager.getTempStarNum(1) >= StarMagicManager.temporaryNum)
                {
                }
                if(ActorManager.actorInfo.coins < this.needMoney[0])
                {
                    ServerMessager.addMessage("赛尔豆不够!至少需要2000赛尔豆！");
                    return;
                }
                this.getState = STATE_MOVEONCE;
                this._onceZhao = 1;
                if(StarMagicManager.temporaryStarInfo.length != 0)
                {
                    this._onceZhaoIndex = StarMagicManager.temporaryStarInfo.length;
                }
                else
                {
                    this._onceZhaoIndex = 0;
                }
                this.onceGetHun(this.showOnceGet,this.showOnceGet);
                StarMagicManager.sellStar(2,2,2,this.showSellSuiPian,this.showSellSuiPian);
                this.getStar(0,2,this.update,this.update);
                this.sellStar(1,1,3,this.showSellSuiPian,this.showSellSuiPian);
                this.getStar(0,2,this.update,this.update);
                this.sellStar(1,1,3,this.showSellSuiPian,this.showSellSuiPian);
                this.getStar(0,2,this.update,this.update);
                this.sellStar(1,1,3,this.showSellSuiPian,this.showSellSuiPian);
                this.getStar(0,2,this.update,this.update);
                this.sellStar(1,1,3,this.showSellSuiPian,this.showSellSuiPian);
            }
            else
            {
                i = 0;
                while(i < 5)
                {
                    if(e.target == this._getBtn[i])
                    {
                        if(ActorManager.actorInfo.coins < this.needMoney[i])
                        {
                            ServerMessager.addMessage("赛尔豆不够!需要" + this.needMoney[i] + "赛尔豆");
                            return;
                        }
                        if(StarMagicManager.getTempStarNum(1) + StarMagicManager.getTempStarNum(2) >= 16)
                        {
                            ServerMessager.addMessage("目前圣域已满，无法抽取!");
                            return;
                        }
                        this.getState = STATE_MOVEONCE;
                        this.getStar(i,1,this.update,this.update);
                        break;
                    }
                    i++;
                }
            }
        }
    }

    private function update() : void
    {
        var getedVal:int = 0;
        var getedVal2:int = 0;
        ActiveCountManager.requestActiveCountList([FOR_MONEY,FOR_BTN],function(par:Parser_1142):void
        {
            var i:int = 0;
            getedVal = par.infoVec[0];
            getedVal2 = par.infoVec[1];
            StarMagicManager.starMoney = getedVal;
            _mainUI["money"].text = "" + StarMagicManager.starMoney;
            var getedState:Array = [];
            i = 0;
            while(i < 5)
            {
                getedState.push(Boolean(Math.pow(2,i) & getedVal2));
                i++;
            }
            updateBtn(getedState);
            getState = 0;
        });
        this.updateIcon();
        _mainUI["smoney"].text = "" + ActorManager.actorInfo.coins;
        if(this._onceZhao == 1)
        {
            this.showOnceGet2();
            return;
        }
    }

    private function updateBtn(array:Array) : void
    {
        var i:int = 0;
        i = 0;
        while(i < 5)
        {
            if(Boolean(array[i]))
            {
                this._suo[i].visible = false;
                if(i > 0)
                {
                    _mainUI["show" + i].gotoAndPlay(2);
                }
            }
            else
            {
                this._getBtn[i].mouseEnabled = false;
                this._suo[i].visible = true;
            }
            i++;
        }
        this._suo[0].visible = false;
        this._getBtn[0].mouseEnabled = true;
    }

    private function onTickShow(t:int) : void
    {
        var i:int = 0;
        i = 1;
        while(i < 5)
        {
            if(_mainUI["show" + i].currentFrame == _mainUI["show" + i].totalFrames)
            {
                _mainUI["show" + i].gotoAndStop(1);
                this._getBtn[i].mouseEnabled = true;
            }
            i++;
        }
    }

    private function showOnceGet() : void
    {
        var i:int = 0;
        i = 0;
        while(i < this._icon.length)
        {
            if(this._icon[i].type >= 1)
            {
                this._icon[i].toPath(_mainUI["bagBtn"].x + 10,_mainUI["bagBtn"].y + 10);
            }
            i++;
        }
    }

    private function showSellSuiPian() : void
    {
        StarMagicManager.getTemporaryStar(this.update,this.update);
    }

    private function showOneZhuan() : void
    {
        StarMagicManager.getTemporaryStar(this.update,this.update);
    }

    private function onceGetHun(func:Function, fune:Function) : void
    {
        StarMagicManager.oncePutStar(func,fune);
    }

    private function sellStar(pos:int, id:int, type:int, func:Function, fune:Function) : void
    {
        StarMagicManager.sellStar(pos,id,type,func,fune);
    }

    private function getStar(pos:int, type:int, func:Function, fune:Function) : void
    {
        StarMagicManager.getTempStar(pos,type,func,fune);
    }

    private function getTempStar() : void
    {
        StarMagicManager.getTemporaryStar(this.update,this.update);
    }

    private function updateIcon() : void
    {
        var i:int = 0;
        i = 0;
        while(i < StarNum)
        {
            if(i < StarMagicManager.temporaryStarInfo.length)
            {
                this._icon[i].updateDateInfo(StarMagicManager.temporaryStarInfo[i]);
            }
            else
            {
                this._icon[i].updateDateInfo(null);
            }
            i++;
        }
        this.resetPos();
    }

    private function resetPos() : void
    {
        var i:int = 0;
        i = 0;
        while(i < this._icon.length)
        {
            this._icon[i].x = this.pos[i].x + 4;
            this._icon[i].y = this.pos[i].y;
            this._icon[i].alpha = 1;
            this._icon[i].setmoveState(0);
            i++;
        }
        this.getState = STATE_STOP;
    }

    private function showOnceGet2() : void
    {
        var i:int = 0;
        i = this._onceZhaoIndex;
        while(i < 16)
        {
            this._icon[i].visible = false;
            i++;
        }
        this._onceZhao = 2;
        this._onceZhaoTime = 0;
    }

    private function onOnceGet2() : void
    {
        if(this._onceZhao == 2)
        {
            ++this._onceZhaoTime;
            if(this._onceZhaoIndex < 16)
            {
                this._onceZhaoTime = 0;
                this._icon[this._onceZhaoIndex].visible = true;
                this._icon[this._onceZhaoIndex].visible = true;
                ++this._onceZhaoIndex;
                if(this._onceZhaoIndex >= 16)
                {
                    this._onceZhao = 0;
                    this.getState = 0;
                }
            }
        }
    }

    private function onRender(t:int) : void
    {
        var i:int = 0;
        i = 0;
        while(i < this._icon.length)
        {
            this._icon[i].move();
            i++;
        }
        this.checkState();
        this.onOnceGet2();
    }

    private function checkState() : void
    {
        var i:int = 0;
        var over:Boolean = true;
        if(this.getState == STATE_MOVEONCE)
        {
            i = 0;
            while(i < this._icon.length)
            {
                if(this._icon[i].moveState() != -1 && this._icon[i].indexId >= 3 && this._icon[i].type != 0)
                {
                    over = false;
                }
                i++;
            }
            if(over)
            {
                this.getTempStar();
            }
        }
    }

    override protected function onClose(e:MouseEvent) : void
    {
        ItemManager._getCoinsMessageSwitch = true;
        ModuleManager.closeForInstance(this);
    }

    private function onPurple(e:MouseEvent) : void
    {
        SwapManager.swapItem(3466);
        SwapManager.swapItem(3466);
        SwapManager.swapItem(3466);
        SwapManager.swapItem(3466);
        SwapManager.swapItem(3466);
        SwapManager.swapItem(3466);
        SwapManager.swapItem(3466);
        SwapManager.swapItem(3466);
        SwapManager.swapItem(3466);
        SwapManager.swapItem(3466);
        SwapManager.swapItem(3466);
        SwapManager.swapItem(3466);
        SwapManager.swapItem(3466);
        SwapManager.swapItem(3466);
        SwapManager.swapItem(3466);
        SwapManager.swapItem(3466);
        SwapManager.swapItem(3466);
        Connection.addCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.sendSuc);
        Connection.addErrorHandler(CommandSet.ITEM_EXCHANGE_1055,this.sendErr);
        SwapManager.swapItem(3466);
    }

    private function onNo(e:MouseEvent) : void
    {
        if(e.target == _mainUI["more2Btn"])
        {
            _mainUI["more2Btn"].visible = false;
            _mainUI["oncePowerBtn"].visible = false;
            _mainUI["purplePowerBtn"].visible = false;
            _mainUI["sellSuipianBtn"].visible = true;
            _mainUI["getHunBtn"].visible = true;
            _mainUI["ruleBtn"].visible = true;
            _mainUI["more1Btn"].visible = true;
        }
        else if(e.target == _mainUI["more1Btn"])
        {
            _mainUI["more2Btn"].visible = true;
            _mainUI["oncePowerBtn"].visible = true;
            _mainUI["purplePowerBtn"].visible = true;
            _mainUI["sellSuipianBtn"].visible = false;
            _mainUI["getHunBtn"].visible = false;
            _mainUI["ruleBtn"].visible = false;
            _mainUI["more1Btn"].visible = false;
        }
    }

    private function onGetP(e:MouseEvent) : void
    {
        var timer2:Timer = new Timer(1000,1);
        ItemManager._getCoinsMessageSwitch = false;
        DisplayObjectUtil.disableButton(_mainUI["more0Btn"]);
        DisplayObjectUtil.disableButton(_mainUI["bagBtn"]);
        DisplayObjectUtil.disableButton(_mainUI["sellSuipianBtn"]);
        DisplayObjectUtil.disableButton(_mainUI["getHunBtn"]);
        DisplayObjectUtil.disableButton(_mainUI["onceGetBtn"]);
        DisplayObjectUtil.disableButton(_mainUI["purpleBtn"]);
        DisplayObjectUtil.disableButton(_mainUI["getBtn0"]);
        DisplayObjectUtil.disableButton(_mainUI["getBtn1"]);
        DisplayObjectUtil.disableButton(_mainUI["getBtn2"]);
        DisplayObjectUtil.disableButton(_mainUI["getBtn3"]);
        DisplayObjectUtil.disableButton(_mainUI["getBtn4"]);
        DisplayObjectUtil.disableButton(_mainUI["more1Btn"]);
        DisplayObjectUtil.disableButton(_mainUI["purplePowerBtn"]);
        DisplayObjectUtil.disableButton(_mainUI["oncePowerBtn"]);
        DisplayObjectUtil.disableButton(_mainUI["more2Btn"]);
        this.getState = STATE_MOVEONCE;
        this._onceZhao = 1;
        if(StarMagicManager.temporaryStarInfo.length != 0)
        {
            this._onceZhaoIndex = StarMagicManager.temporaryStarInfo.length;
        }
        else
        {
            this._onceZhaoIndex = 0;
        }
        this.onceGetHun(this.emptyFunc,this.emptyFunc);
        this.sellStar(2,2,2,this.showSellSuiPian,this.showSellSuiPian);
        this.getStar(0,2,this.update,this.update);
        this.sellStar(1,1,3,this.showSellSuiPian,this.showSellSuiPian);
        this.getStar(0,2,this.update,this.update);
        this.sellStar(1,1,3,this.showSellSuiPian,this.showSellSuiPian);
        this.getStar(0,2,this.update,this.update);
        this.sellStar(1,1,3,this.showSellSuiPian,this.showSellSuiPian);
        this.getStar(0,2,this.update,this.update);
        this.sellStar(1,1,3,this.showSellSuiPian,this.showSellSuiPian);
        this.getStar(0,2,this.update,this.update);
        this.sellStar(1,1,3,this.showSellSuiPian,this.showSellSuiPian);
        this.getStar(0,2,this.update,this.update);
        this.sellStar(1,1,3,this.showSellSuiPian,this.showSellSuiPian);
        timer2.addEventListener("timer",function(e:TimerEvent):void
        {
            onGetPurple(null);
        });
        timer2.reset();
        timer2.start();
    }

    private function onGetPurple(e:MessageEvent) : void
    {
        Connection.removeErrorHandler(CommandSet.CLI_EXP_TO_COIN_STARHUN_1264,this.onError);
        Connection.removeCommandListener(CommandSet.CLI_EXP_TO_COIN_STARHUN_1264,this.onGetPurple);
        this.purpleTime = 0;
        var i:int = 0;
        while(i < this._icon.length)
        {
            if(this._icon[i].type == 3 || this.purpleTime == 10)
            {
                this.purpleTime = 0;
                DisplayObjectUtil.enableButton(_mainUI["more0Btn"]);
                DisplayObjectUtil.enableButton(_mainUI["bagBtn"]);
                DisplayObjectUtil.enableButton(_mainUI["sellSuipianBtn"]);
                DisplayObjectUtil.enableButton(_mainUI["getHunBtn"]);
                DisplayObjectUtil.enableButton(_mainUI["onceGetBtn"]);
                DisplayObjectUtil.enableButton(_mainUI["purpleBtn"]);
                DisplayObjectUtil.enableButton(_mainUI["getBtn0"]);
                DisplayObjectUtil.enableButton(_mainUI["getBtn1"]);
                DisplayObjectUtil.enableButton(_mainUI["getBtn2"]);
                DisplayObjectUtil.enableButton(_mainUI["getBtn3"]);
                DisplayObjectUtil.enableButton(_mainUI["getBtn4"]);
                DisplayObjectUtil.enableButton(_mainUI["more1Btn"]);
                DisplayObjectUtil.enableButton(_mainUI["purplePowerBtn"]);
                DisplayObjectUtil.enableButton(_mainUI["oncePowerBtn"]);
                DisplayObjectUtil.enableButton(_mainUI["more2Btn"]);
                return;
            }
            i++;
        }
        this.getState = STATE_MOVEONCE;
        this._onceZhao = 1;
        if(StarMagicManager.temporaryStarInfo.length != 0)
        {
            this._onceZhaoIndex = StarMagicManager.temporaryStarInfo.length;
        }
        else
        {
            this._onceZhaoIndex = 0;
        }
        this.onceGetHun(this.emptyFunc,this.emptyFunc);
        this.sellStar(2,2,2,this.showSellSuiPian,this.showSellSuiPian);
        Connection.addCommandListener(CommandSet.CLI_EXP_TO_COIN_STARHUN_1264,this.ogp);
        Connection.addErrorHandler(CommandSet.CLI_EXP_TO_COIN_STARHUN_1264,this.onError);
    }

    private function closeRule(e:MouseEvent) : void
    {
        _mainUI["ruleUI"].visible = false;
    }

    private function openRule(e:MouseEvent) : void
    {
        _mainUI["ruleUI"].visible = true;
    }

    private function emptyFunc() : void
    {
    }

    private function onError(e:MessageEvent) : void
    {
        DisplayObjectUtil.enableButton(_mainUI["more0Btn"]);
        DisplayObjectUtil.enableButton(_mainUI["bagBtn"]);
        DisplayObjectUtil.enableButton(_mainUI["sellSuipianBtn"]);
        DisplayObjectUtil.enableButton(_mainUI["getHunBtn"]);
        DisplayObjectUtil.enableButton(_mainUI["onceGetBtn"]);
        DisplayObjectUtil.enableButton(_mainUI["purpleBtn"]);
        DisplayObjectUtil.enableButton(_mainUI["getBtn0"]);
        DisplayObjectUtil.enableButton(_mainUI["getBtn1"]);
        DisplayObjectUtil.enableButton(_mainUI["getBtn2"]);
        DisplayObjectUtil.enableButton(_mainUI["getBtn3"]);
        DisplayObjectUtil.enableButton(_mainUI["getBtn4"]);
        DisplayObjectUtil.enableButton(_mainUI["purplePowerBtn"]);
        DisplayObjectUtil.enableButton(_mainUI["oncePowerBtn"]);
        DisplayObjectUtil.enableButton(_mainUI["more1Btn"]);
        DisplayObjectUtil.enableButton(_mainUI["more2Btn"]);
    }

    private function ogp(e:MessageEvent) : void
    {
        Connection.removeErrorHandler(CommandSet.CLI_EXP_TO_COIN_STARHUN_1264,this.onError);
        Connection.removeCommandListener(CommandSet.CLI_EXP_TO_COIN_STARHUN_1264,this.ogp);
        this.purpleTime++;
        if(this.purpleTime == 3)
        {
            Connection.addCommandListener(CommandSet.CLI_EXP_TO_COIN_STARHUN_1264,this.onGetPurple);
            Connection.addErrorHandler(CommandSet.CLI_EXP_TO_COIN_STARHUN_1264,this.onError);
            this.purpleTime = 0;
        }
        else
        {
            Connection.addCommandListener(CommandSet.CLI_EXP_TO_COIN_STARHUN_1264,this.ogp);
            Connection.addErrorHandler(CommandSet.CLI_EXP_TO_COIN_STARHUN_1264,this.onError);
        }
        this.getStar(0,2,this.update,this.update);
        this.sellStar(1,1,3,this.showSellSuiPian,this.showSellSuiPian);
    }

    private function onPowerClick(e:MouseEvent) : void
    {
        ItemManager._getCoinsMessageSwitch = false;
        DisplayObjectUtil.disableButton(_mainUI["getBtn0"]);
        DisplayObjectUtil.disableButton(_mainUI["getBtn1"]);
        DisplayObjectUtil.disableButton(_mainUI["getBtn2"]);
        DisplayObjectUtil.disableButton(_mainUI["getBtn3"]);
        DisplayObjectUtil.disableButton(_mainUI["getBtn4"]);
        DisplayObjectUtil.disableButton(_mainUI["bagBtn"]);
        DisplayObjectUtil.disableButton(_mainUI["purplePowerBtn"]);
        DisplayObjectUtil.disableButton(_mainUI["oncePowerBtn"]);
        DisplayObjectUtil.disableButton(_mainUI["more0Btn"]);
        DisplayObjectUtil.disableButton(_mainUI["onceGetBtn"]);
        DisplayObjectUtil.disableButton(_mainUI["purpleBtn"]);
        DisplayObjectUtil.disableButton(_mainUI["more2Btn"]);
        if(e.target == _mainUI["purplePowerBtn"])
        {
            this.powerType = 1;
        }
        else if(e.target == _mainUI["oncePowerBtn"])
        {
            this.powerType = 2;
        }
        this.onPower(null);
    }

    private function onPower(e:MessageEvent) : void
    {
        Connection.removeErrorHandler(CommandSet.CLI_EXP_TO_COIN_STARHUN_1264,this.onError);
        Connection.removeCommandListener(CommandSet.CLI_EXP_TO_COIN_STARHUN_1264,this.onPower);
        if(this.powerType == 1)
        {
            if(this.purplePowerTime < 0)
            {
                this.powerType = 0;
                DisplayObjectUtil.enableButton(_mainUI["getBtn0"]);
                DisplayObjectUtil.enableButton(_mainUI["getBtn1"]);
                DisplayObjectUtil.enableButton(_mainUI["getBtn2"]);
                DisplayObjectUtil.enableButton(_mainUI["getBtn3"]);
                DisplayObjectUtil.enableButton(_mainUI["getBtn4"]);
                DisplayObjectUtil.enableButton(_mainUI["bagBtn"]);
                DisplayObjectUtil.enableButton(_mainUI["purplePowerBtn"]);
                DisplayObjectUtil.enableButton(_mainUI["oncePowerBtn"]);
                DisplayObjectUtil.enableButton(_mainUI["more0Btn"]);
                DisplayObjectUtil.enableButton(_mainUI["onceGetBtn"]);
                DisplayObjectUtil.enableButton(_mainUI["purpleBtn"]);
                DisplayObjectUtil.enableButton(_mainUI["more2Btn"]);
                return;
            }
            this.purplePowerTime++;
            SwapManager.swapItem(3466);
            SwapManager.swapItem(3466);
            SwapManager.swapItem(3466);
            SwapManager.swapItem(3466);
            SwapManager.swapItem(3466);
            SwapManager.swapItem(3466);
            SwapManager.swapItem(3466);
            SwapManager.swapItem(3466);
            SwapManager.swapItem(3466);
            SwapManager.swapItem(3466);
            SwapManager.swapItem(3466);
            SwapManager.swapItem(3466);
            SwapManager.swapItem(3466);
            SwapManager.swapItem(3466);
            SwapManager.swapItem(3466);
            SwapManager.swapItem(3466);
            SwapManager.swapItem(3466);
            SwapManager.swapItem(3466);
            this.onceGetHun(this.emptyFunc,this.emptyFunc);
            if(this.purplePowerTime >= 25)
            {
                this.purplePowerTime = 0;
                this.powerType = 0;
                DisplayObjectUtil.enableButton(_mainUI["getBtn0"]);
                DisplayObjectUtil.enableButton(_mainUI["getBtn1"]);
                DisplayObjectUtil.enableButton(_mainUI["getBtn2"]);
                DisplayObjectUtil.enableButton(_mainUI["getBtn3"]);
                DisplayObjectUtil.enableButton(_mainUI["getBtn4"]);
                DisplayObjectUtil.enableButton(_mainUI["bagBtn"]);
                DisplayObjectUtil.enableButton(_mainUI["purplePowerBtn"]);
                DisplayObjectUtil.enableButton(_mainUI["oncePowerBtn"]);
                DisplayObjectUtil.enableButton(_mainUI["more0Btn"]);
                DisplayObjectUtil.enableButton(_mainUI["onceGetBtn"]);
                DisplayObjectUtil.enableButton(_mainUI["purpleBtn"]);
                DisplayObjectUtil.enableButton(_mainUI["more2Btn"]);
                return;
            }
            Connection.addCommandListener(CommandSet.CLI_EXP_TO_COIN_STARHUN_1264,this.onPower);
            Connection.addErrorHandler(CommandSet.CLI_EXP_TO_COIN_STARHUN_1264,this.onError);
            this.sellStar(2,2,2,this.showSellSuiPian,this.showSellSuiPian);
        }
        else if(this.powerType == 2)
        {
            this.oncePowerTime++;
            this.getStar(0,2,this.update,this.update);
            this.sellStar(1,1,3,this.showSellSuiPian,this.showSellSuiPian);
            Connection.addCommandListener(CommandSet.CLI_EXP_TO_COIN_STARHUN_1264,this.sellStar222);
            Connection.addErrorHandler(CommandSet.CLI_EXP_TO_COIN_STARHUN_1264,this.onError);
            if(this.oncePowerTime >= 50)
            {
                this.oncePowerTime = 0;
                this.powerType = 0;
                DisplayObjectUtil.enableButton(_mainUI["getBtn0"]);
                DisplayObjectUtil.enableButton(_mainUI["getBtn1"]);
                DisplayObjectUtil.enableButton(_mainUI["getBtn2"]);
                DisplayObjectUtil.enableButton(_mainUI["getBtn3"]);
                DisplayObjectUtil.enableButton(_mainUI["getBtn4"]);
                DisplayObjectUtil.enableButton(_mainUI["bagBtn"]);
                DisplayObjectUtil.enableButton(_mainUI["purplePowerBtn"]);
                DisplayObjectUtil.enableButton(_mainUI["oncePowerBtn"]);
                DisplayObjectUtil.enableButton(_mainUI["more0Btn"]);
                DisplayObjectUtil.enableButton(_mainUI["onceGetBtn"]);
                DisplayObjectUtil.enableButton(_mainUI["purpleBtn"]);
                DisplayObjectUtil.enableButton(_mainUI["more2Btn"]);
                return;
            }
        }
    }

    private function sellStar222(e:MessageEvent) : void
    {
        Connection.removeCommandListener(CommandSet.CLI_EXP_TO_COIN_STARHUN_1264,this.sellStar222);
        Connection.removeErrorHandler(CommandSet.CLI_EXP_TO_COIN_STARHUN_1264,this.onError);
        this.onceGetHun(this.emptyFunc,this.emptyFunc);
        this.sellStar(2,2,2,this.showSellSuiPian,this.showSellSuiPian);
        Connection.addCommandListener(CommandSet.CLI_EXP_TO_COIN_STARHUN_1264,this.onPower);
        Connection.addErrorHandler(CommandSet.CLI_EXP_TO_COIN_STARHUN_1264,this.onError);
    }

    private function sendSuc(e:MessageEvent) : void
    {
        Connection.removeCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.sendSuc);
        Connection.removeErrorHandler(CommandSet.ITEM_EXCHANGE_1055,this.sendErr);
        ServerMessager.addMessage("操作成功");
    }

    private function sendErr(e:MessageEvent) : void
    {
        Connection.removeCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.sendSuc);
        Connection.removeErrorHandler(CommandSet.ITEM_EXCHANGE_1055,this.sendErr);
        if(e.message.statusCode == 100001)
        {
            ServerMessager.addMessage("操作成功");
        }
        else
        {
            ServerMessager.addMessage("操作失败");
        }
    }
}
}