package com.taomee.seer2.module.app
{
import com.taomee.seer2.app.activeCount.ActiveCountManager;
import com.taomee.seer2.app.actor.ActorManager;
import com.taomee.seer2.app.manager.StatisticsManager;
import com.taomee.seer2.app.net.parser.Parser_1142;
import com.taomee.seer2.app.popup.ServerMessager;
import com.taomee.seer2.app.shopManager.ShopManager;
import com.taomee.seer2.app.starMagic.StarInfo;
import com.taomee.seer2.app.starMagic.StarMagicManager;
import com.taomee.seer2.core.module.Module;
import com.taomee.seer2.core.module.ModuleManager;
import com.taomee.seer2.core.utils.LifecycleType;
import com.taomee.seer2.core.utils.URLUtil;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;
import org.taomee.utils.Tick;

public class test2 extends Module
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

    public function test2()
    {
        super();
        _lifecycleType = LifecycleType.GLOBAL;
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
        for(i = 0; i < this._icon.length; i++)
        {
            this._icon[i].alpha = 1;
            this._icon[i].visible = true;
            this._icon[i].setmoveState(0);
        }
    }

    override public function hide() : void
    {
        super.hide();
        this.removeEvent();
    }

    private function showMc() : void
    {
        for(var i:int = 1; i < 5; i++)
        {
            _mainUI["show" + i].gotoAndStop(1);
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
        for(i = 0; i < StarNum; i++)
        {
            this._icon[i] = new StarMagicIcon(0,0);
            this._icon[i].mouseChildren = false;
            _mainUI.addChild(this._icon[i]);
            this.pos.push(_mainUI["pos" + i]);
        }
        for(i = 0; i < 5; i++)
        {
            this._suo.push(_mainUI["suo" + i]);
            this._getBtn.push(_mainUI["getBtn" + i]);
        }
        SimpleButton(_mainUI["buyBtn"]).addEventListener(MouseEvent.CLICK,this.onBuy);
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
        _mainUI["bagBtn"].addEventListener(MouseEvent.CLICK,this.onClick);
        _mainUI["sellSuipianBtn"].addEventListener(MouseEvent.CLICK,this.onClick);
        _mainUI["getHunBtn"].addEventListener(MouseEvent.CLICK,this.onClick);
        _mainUI["onceGetBtn"].addEventListener(MouseEvent.CLICK,this.onClick);
        for(i = 0; i < 5; i++)
        {
            this._getBtn[i].addEventListener(MouseEvent.CLICK,this.onClick);
        }
        for(i = 0; i < this._icon.length; i++)
        {
            this._icon[i].addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            this._icon[i].addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
        }
    }

    private function onMouseOver(e:MouseEvent) : void
    {
        var i:int = 0;
        for(i = 0; i < this._icon.length; i++)
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
        _mainUI["sellSuipianBtn"].removeEventListener(MouseEvent.CLICK,this.onClick);
        _mainUI["getHunBtn"].removeEventListener(MouseEvent.CLICK,this.onClick);
        _mainUI["onceGetBtn"].removeEventListener(MouseEvent.CLICK,this.onClick);
        for(i = 0; i < 5; i++)
        {
            this._getBtn[i].removeEventListener(MouseEvent.CLICK,this.onClick);
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
            if(StarMagicManager.getTempStarNum(1) <= 0)
            {
                ServerMessager.addMessage("目前没有可卖出的碎片!");
                return;
            }
            this.sellStar(1,1,3,this.showSellSuiPian,this.showSellSuiPian);
        }
        else
        {
            if(e.target == _mainUI["bagBtn"])
            {
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
                if(StarMagicManager.getTempStarNum(2) + StarMagicManager.getTempStarNum(1) >= StarMagicManager.temporaryNum)
                {
                    ServerMessager.addMessage("临时背包已满!");
                    return;
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
                this.getStar(0,2,this.update,this.update);
            }
            else
            {
                for(i = 0; i < 5; i++)
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
            getedVal = par.infoVec[0];
            getedVal2 = par.infoVec[1];
            StarMagicManager.starMoney = getedVal;
            var getedState:Array = [];
            for(var i:int = 0; i < 5; i++)
            {
                getedState.push(Boolean(Math.pow(2,i) & getedVal2));
            }
            updateBtn(getedState);
            getState = 0;
        });
        this.updateIcon();
        _mainUI["money"].text = "" + ActorManager.actorInfo.moneyCount;
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
        for(i = 0; i < 5; i++)
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
        }
        this._suo[0].visible = false;
        this._getBtn[0].mouseEnabled = true;
    }

    private function onTickShow(t:int) : void
    {
        var i:int = 0;
        for(i = 1; i < 5; i++)
        {
            if(_mainUI["show" + i].currentFrame == _mainUI["show" + i].totalFrames)
            {
                _mainUI["show" + i].gotoAndStop(1);
                this._getBtn[i].mouseEnabled = true;
            }
        }
    }

    private function showOnceGet() : void
    {
        var i:int = 0;
        for(i = 0; i < this._icon.length; i++)
        {
            if(this._icon[i].type >= 1)
            {
                this._icon[i].toPath(_mainUI["bagBtn"].x + 10,_mainUI["bagBtn"].y + 10);
            }
        }
    }

    private function showSellSuiPian() : void
    {
        _mainUI["showMc"].play();
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
        for(i = 0; i < StarNum; i++)
        {
            if(i < StarMagicManager.temporaryStarInfo.length)
            {
                this._icon[i].updateDateInfo(StarMagicManager.temporaryStarInfo[i]);
            }
            else
            {
                this._icon[i].updateDateInfo(null);
            }
        }
        this.resetPos();
    }

    private function resetPos() : void
    {
        var i:int = 0;
        for(i = 0; i < this._icon.length; i++)
        {
            this._icon[i].x = this.pos[i].x + 4;
            this._icon[i].y = this.pos[i].y;
            this._icon[i].alpha = 1;
            this._icon[i].setmoveState(0);
        }
        this.getState = STATE_STOP;
    }

    private function showOnceGet2() : void
    {
        for(var i:int = this._onceZhaoIndex; i < 16; i++)
        {
            this._icon[i].visible = false;
        }
        this._onceZhao = 2;
        this._onceZhaoTime = 0;
    }

    private function onOnceGet2() : void
    {
        if(this._onceZhao == 2)
        {
            ++this._onceZhaoTime;
            if(this._onceZhaoTime == 3)
            {
                this._onceZhaoTime = 0;
                _mainUI["superShow"].scaleX = 1.2;
                _mainUI["superShow"].scaleY = 1.2;
                _mainUI["superShow"].x = this._icon[this._onceZhaoIndex].x - 19;
                _mainUI["superShow"].y = this._icon[this._onceZhaoIndex].y - 19;
                _mainUI.setChildIndex(_mainUI["superShow"],_mainUI.numChildren - 1);
                _mainUI["superShow"].gotoAndPlay(1);
                _mainUI["superShow"].visible = true;
                this._icon[this._onceZhaoIndex].visible = true;
                this._icon[this._onceZhaoIndex].visible = true;
                ++this._onceZhaoIndex;
                if(this._onceZhaoIndex == 16)
                {
                    _mainUI["superShow"].visible = false;
                    this._onceZhao = 0;
                    this.getState = 0;
                }
            }
        }
    }

    private function onRender(t:int) : void
    {
        var i:int = 0;
        for(i = 0; i < this._icon.length; i++)
        {
            this._icon[i].move();
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
            for(i = 0; i < this._icon.length; i++)
            {
                if(this._icon[i].moveState() != -1 && this._icon[i].indexId >= 3 && this._icon[i].type != 0)
                {
                    over = false;
                }
            }
            if(over)
            {
                this.getTempStar();
            }
        }
    }
}
}