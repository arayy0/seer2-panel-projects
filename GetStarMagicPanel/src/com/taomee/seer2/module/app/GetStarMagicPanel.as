package com.taomee.seer2.module.app
{
import com.taomee.seer2.app.activeCount.ActiveCountManager;
import com.taomee.seer2.app.actor.ActorManager;
import com.taomee.seer2.app.inventory.ItemManager;
import com.taomee.seer2.app.net.CommandSet;
import com.taomee.seer2.app.net.Connection;
import com.taomee.seer2.app.net.parser.Parser_1142;
import com.taomee.seer2.app.popup.AlertManager;
import com.taomee.seer2.app.popup.ServerMessager;
import com.taomee.seer2.app.starMagic.StarInfo;
import com.taomee.seer2.app.starMagic.StarMagicManager;
import com.taomee.seer2.app.swap.SwapManager;
import com.taomee.seer2.core.module.Module;
import com.taomee.seer2.core.module.ModuleManager;
import com.taomee.seer2.core.net.MessageEvent;
import com.taomee.seer2.core.utils.DisplayObjectUtil;
import com.taomee.seer2.core.utils.URLUtil;
import com.taomee.seer2.module.app.ui.GetStarMagicPanelUI;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.utils.IDataInput;

public class GetStarMagicPanel extends Module {

    private const STARNUM:uint = 16;

    private const NEEDMONEY:Array = [2000,3000,4000,8000,12000];

    private var _totalStarNum:int = 0;

    private var _starMagicTip:StarMagicTip;

    private var _starIconVec:Vector.<StarMagicIcon>;

    private var _posVec:Vector.<MovieClip>;

    private var _suoVec:Vector.<MovieClip>;

    private var _getBtnVec:Vector.<SimpleButton>;

    private var _ruleUI:MovieClip;

    private var _oneDrawBtn:SimpleButton;

    private var _oneChangeBtn:SimpleButton;

    private var _oneSmoneyBtn:SimpleButton;

    private var _purpleSmoneyBtn:SimpleButton;

    private var _drawPurpleBtn:SimpleButton;

    private var _onePurpleBtn:SimpleButton;

    private var _getStarBtn:SimpleButton;

    private var _ruleBtn:SimpleButton;

    private var _bagBtn:SimpleButton;

    private var _smoneyTxt:TextField;

    private var _moneyTxt:TextField;

    private var _purpleSmoneyTime:int;

    public function GetStarMagicPanel()
    {
        super();
        _lifecycleType = "global";
    }

    override public function setup() : void
    {
        setMainUI(new GetStarMagicPanelUI());
        this.initSet();
        this.initEvent();
    }

    private function initSet() : void
    {
        var i:int;
        this._starMagicTip = new StarMagicTip();
        this._starMagicTip.mouseEnabled = false;
        this._starMagicTip.mouseChildren = false;
        this._starMagicTip.visible = false;
        _mainUI.addChild(this._starMagicTip);
        this._starIconVec = new Vector.<StarMagicIcon>();
        this._posVec = new Vector.<MovieClip>();
        this._suoVec = new Vector.<MovieClip>();
        this._getBtnVec = new Vector.<SimpleButton>();
        this._closeBtn = _mainUI["closeBtn"];
        this._ruleUI = _mainUI["ruleUI"];
        DisplayObjectUtil.removeFromParent(_mainUI["ruleUI"]);
        this._ruleUI.x = (1200 - this._ruleUI.width) / 2;
        this._ruleUI.y = (660 - this._ruleUI.height) / 2;
        this._oneDrawBtn = _mainUI["oneDrawBtn"];
        this._oneChangeBtn = _mainUI["oneChangeBtn"];
        this._oneSmoneyBtn = _mainUI["oneSmoneyBtn"];
        this._purpleSmoneyBtn = _mainUI["purpleSmoneyBtn"];
        this._drawPurpleBtn = _mainUI["drawPurpleBtn"];
        this._onePurpleBtn = _mainUI["onePurpleBtn"];
        this._getStarBtn = _mainUI["getStarBtn"];
        this._ruleBtn = _mainUI["ruleBtn"];
        this._bagBtn = _mainUI["bagBtn"];
        this._smoneyTxt = _mainUI["smoney"];
        this._moneyTxt = _mainUI["money"];
        ItemManager._getCoinsMessageSwitch = false;
        i = 0;
        while(i < this.STARNUM)
        {
            this._starIconVec[i] = new StarMagicIcon(0,0);
            this._starIconVec[i].mouseChildren = false;
            _mainUI.addChild(this._starIconVec[i]);
            this._posVec.push(_mainUI["pos" + i]);
            i++;
        }
        i = 0;
        while(i < 5)
        {
            this._suoVec.push(_mainUI["suo" + i]);
            this._getBtnVec.push(_mainUI["getBtn" + i]);
            i++;
        }
        this._purpleSmoneyTime = 0;
    }

    private function initEvent():void
    {
        var i:int = 0;
        while(i < this._starIconVec.length)
        {
            this._starIconVec[i].addEventListener("mouseOver",this.onMouseOver);
            this._starIconVec[i].addEventListener("mouseOut",this.onMouseOut);
            i++;
        }
        i = 0;
        while(i < 5)
        {
            this._getBtnVec[i].addEventListener("click",this.onGetBtn);
            i++;
        }
        this._getStarBtn.addEventListener("click",this.getStar);
        this._bagBtn.addEventListener("click",this.onNormalClick);
        this._ruleBtn.addEventListener("click",this.onNormalClick);
        this._ruleUI["closeBtn"].addEventListener("click",this.onNormalClick);
        this._onePurpleBtn.addEventListener("click",this.onePurple);
        this._oneDrawBtn.addEventListener("click",this.oneDrawStar);
        this._oneChangeBtn.addEventListener("click",this.oneChange);
        this._drawPurpleBtn.addEventListener("click",this.drawPurple);
        this._oneSmoneyBtn.addEventListener("click",this.oneSmoney);
        this._purpleSmoneyBtn.addEventListener("click",this.purpleSmoney)
    }

    private function onMouseOver(e:MouseEvent):void
    {
        var i:int = 0;
        var info:StarInfo;
        while(i < this._starIconVec.length)
        {
            if(e.target == this._starIconVec[i])
            {
                if(this._starIconVec[i].indexId == 0)
                {
                    return;
                }
                info = this._starIconVec[i].getInfo();
                this._starMagicTip.update(info);
                this._starMagicTip.visible = true;
                this._starMagicTip.x = mouseX - 10;
                this._starMagicTip.y = mouseY - 30;
                _mainUI.setChildIndex(this._starMagicTip,_mainUI.numChildren - 1);
                break;
            }
            i++;
        }
    }

    private function onMouseOut(e:MouseEvent):void
    {
        this._starMagicTip.visible = false;
    }

    private function onGetBtn(e:MouseEvent):void
    {
        var i:int = 0;
        while(i < 5)
        {
            if(e.target == this._getBtnVec[i])
            {
                if(ActorManager.actorInfo.coins < this.NEEDMONEY[i])
                {
                    ServerMessager.addMessage("赛尔豆不够，需要" + this.NEEDMONEY[i] + "赛尔豆");
                    return;
                }
                if(StarMagicManager.getTempStarNum(1) + StarMagicManager.getTempStarNum(2) >= 16)
                {
                    ServerMessager.addMessage("寄存背包已满，无法抽取");
                    return;
                }
                this.drawStar(i,1,this.update,this.update);
                break;
            }
            i++;
        }
    }

    private function onNormalClick(e:MouseEvent):void
    //处理跳转背包、规则面板的开与关
    {
        if(e.target == this._bagBtn)
        {
            ModuleManager.closeForName("GetStarMagicPanel");
            ModuleManager.showModule(URLUtil.getAppModule("StarMagicBagPanel"),"正在打开面板...");
        }
        else if(e.target == this._ruleBtn)
        {
            DisplayObjectUtil.removeFromParent(this._ruleUI);
            _mainUI.addChild(this._ruleUI);
            this._ruleUI.visible = true;
        }
        else if(e.target == this._ruleUI["closeBtn"])
        {
            this._ruleUI.visible = false;
        }
    }

    private function onePurple(e:MouseEvent):void
    {
        if(!this.checkStarNum())
        {
            return;
        }
        if(StarMagicManager.getDepotStarNum() > 0)
        {
            AlertManager.showConfirm("星魂背包未清空，请前往处理",function():void
            {
                _bagBtn.dispatchEvent(new MouseEvent("click"));
            },null);
            return;
        }
        var i:int = 0;
        while(i < 17)
        {
            SwapManager.swapItem(3466);
            i++;
        }
        Connection.addCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.onePurpleSuc);
        Connection.addErrorHandler(CommandSet.ITEM_EXCHANGE_1055,this.onePurpleErr);
        SwapManager.swapItem(3466);
    }

    private function onePurpleSuc(e:MessageEvent):void
    {
        Connection.removeCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.onePurpleSuc);
        Connection.removeErrorHandler(CommandSet.ITEM_EXCHANGE_1055,this.onePurpleErr);
        ServerMessager.addMessage("获得紫魂前置奖励");
    }

    private function onePurpleErr(e:MessageEvent) : void
    {
        Connection.removeCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.onePurpleSuc);
        Connection.removeErrorHandler(CommandSet.ITEM_EXCHANGE_1055,this.onePurpleErr);
        if(e.message.statusCode == 100001)
        {
            ServerMessager.addMessage("操作成功");
        }
        else
        {
            ServerMessager.addMessage("操作失败");
        }
    }

    private function drawPurple(e:MouseEvent = null,func:Function = null,fune:Function = null):void
    {
        if(!this.checkStarNum())
        {
            return;
        }
        if(StarMagicManager.getDepotStarNum() > 0)
        {
            AlertManager.showConfirm("星魂背包未清空，请前往处理",function():void
            {
                _bagBtn.dispatchEvent(new MouseEvent("click"));
            },null);
            this.update();
            return;
        }
        if(ActorManager.actorInfo.coins < 1000000)
        {
            ServerMessager.addMessage("该功能为自动抽取，建议拥有100w赛尔豆后再使用");
            return;
        }
        this.enableAllBtn(false);
        func = (func == null) ? this.endFunc : func;
        fune = (fune == null) ? this.endFunc : fune;
        var drawTime:int = 0;
        var drawstar:Function = function():void
        {
            drawTime++;
            oneDrawStar(null,sellstar,fune);
        }
        var checkstar:Function = function():Boolean
        {
            var infovec:Vector.<StarInfo> = StarMagicManager.temporaryStarInfo;
            var info:StarInfo;
            var i:int = 0;
            while(i < infovec.length)
            {
                info = infovec[i];
                if(info.type >= 3)
                {
                    return true;
                }
                i++;
            }
            return false;
        }
        var sellstar:Function = function():void
        {
            update();
            if(checkstar() || drawTime >= 20)
            {
                func();
            }
            else
            {
                getStar(null,function():void
                {
                    sellStar(2,2,2,drawstar,fune);
                },function():void
                {
                    sellStar(2,2,2,drawstar,fune);
                });
            }
        }
        drawstar();
    }

    private function oneChange(e:MouseEvent = null,func:Function = null,fune:Function = null):void
    {
        if(StarMagicManager.getDepotStarNum() > 0)
        {
            AlertManager.showConfirm("星魂背包未清空，请前往处理",function():void
            {
                _bagBtn.dispatchEvent(new MouseEvent("click"));
            },null);
            this.update();
            return;
        }
        func = (func == null) ? this.update : func;
        fune = (fune == null) ? this.update : fune;
        var getStarEnd:Function = function():void
        {
            sellStar(2,2,2,func,fune);
        }
        var sellStarEnd:Function = function():void
        {
            getStar(null,getStarEnd,getStarEnd);
        }
        this.sellStar(1,1,3,sellStarEnd,sellStarEnd);
    }

    private function getStar(e:MouseEvent = null,func:Function = null,fune:Function = null):void
    {
        if(!(func || fune))
        {
            this.update();
            if(StarMagicManager.getTempStarNum(2) <= 0)
            {
                ServerMessager.addMessage("目前没有可拾取的星魂!");
                return;
            }
            if(StarMagicManager.getDepotStarNum() >= StarMagicManager.depotNum)
            {
                ServerMessager.addMessage("星魂背包已满，暂时无法拾取!");
                return;
            }
        }
        func = (func == null) ? this.update : func;
        fune = (fune == null) ? this.update : fune;
        StarMagicManager.oncePutStar(func,fune);
    }

    private function oneDrawStar(e:MouseEvent = null,func:Function = null,fune:Function = null):void
    {
        if(!this.checkStarNum())
        {
            return;
        }
        if(!(func || fune))
        {
            this.update();
            if(StarMagicManager.getTempStarNum(2) + StarMagicManager.getTempStarNum(1) >= StarMagicManager.temporaryNum)
            {
                ServerMessager.addMessage("临时背包已满!");
                return;
            }
            if(ActorManager.actorInfo.coins < 100000)
            {
                ServerMessager.addMessage("赛尔豆不够!最好拥有10w赛尔豆后再使用该功能");
                return;
            }
        }
        this.enableAllBtn(false);
        func = (func == null) ? this.endFunc : func;
        fune = (fune == null) ? this.endFunc : fune;
        var drawTime:int = 0;
        var draw:Function = function():void
        {
            drawStar(0,2,sell,fune);
        }
        var sell:Function = function():void
        {
            if(drawTime < 3)
            {
                drawTime++;
                sellStar(1,1,3,draw,fune);
            }
            else
            {
                sellStar(1,1,3,func,fune);
            }
        }
        draw();
    }

    private function oneSmoney(e:MouseEvent = null,func:Function = null,fune:Function = null):void
    {
        if(StarMagicManager.getDepotStarNum() > 0)
        {
            AlertManager.showConfirm("星魂背包未清空，请前往处理",function():void
            {
                _bagBtn.dispatchEvent(new MouseEvent("click"));
            },null);
            return;
        }
        if(ActorManager.actorInfo.coins < 1000000)
        {
            ServerMessager.addMessage("该功能为自动抽取，建议拥有100w赛尔豆后再使用");
            return;
        }
        this.enableAllBtn(false);
        func = (func == null) ? this.endFunc : func;
        fune = (fune == null) ? this.endFunc : fune;
        var drawTime:int = 0;
        var draw:Function = function():void
        {
            update();
            oneDrawStar(null,sell,fune);
        }
        var sell:Function = function():void
        {
            getStar(null,function():void
            {
                if(drawTime < 20)
                {
                    drawTime++;
                    sellStar(2,2,2,draw,fune);
                }
                else
                {
                    sellStar(2,2,2,func,fune);
                }
            },fune);
        }
        AlertManager.showAlert("刷取中，请耐心等待,待按钮亮起后则为刷取完毕");
        draw();
    }

    private function purpleSmoney(e:* = null):void
    {
        if(StarMagicManager.getDepotStarNum() > 0)
        {
            AlertManager.showConfirm("星魂背包未清空，请前往处理",function():void
            {
                _bagBtn.dispatchEvent(new MouseEvent("click"));
            },null);
            return;
        }
        this.enableAllBtn(false);
        if(this._purpleSmoneyTime >= 20)
        {
            this._purpleSmoneyTime = 0;
            this.endFunc();
            return;
        }
        this._purpleSmoneyTime++;
        this.update();
        var i:int = 0;
        while(i < 17)
        {
            SwapManager.swapItem(3466);
            i++;
        }
        Connection.addCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.purpleSmoneySuc);
        Connection.addErrorHandler(CommandSet.ITEM_EXCHANGE_1055,this.purpleSmoneyErr);
        SwapManager.swapItem(3466);
    }

    private function purpleSmoneySuc(e:MessageEvent):void
    {
        Connection.removeCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.purpleSmoneySuc);
        Connection.removeErrorHandler(CommandSet.ITEM_EXCHANGE_1055,this.purpleSmoneyErr);
        ServerMessager.addMessage("获得紫魂前置奖励,退出紫色星力功能");
        this._purpleSmoneyTime = 0;
        this.enableAllBtn(true);
    }

    private function purpleSmoneyErr(e:MessageEvent) : void
    {
        Connection.removeCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.purpleSmoneySuc);
        Connection.removeErrorHandler(CommandSet.ITEM_EXCHANGE_1055,this.purpleSmoneyErr);
        if(e.message.statusCode == 100001)
        {
            this.sellStar(2,2,2,this.purpleSmoney,this.purpleSmoney);
        }
        else
        {
            ServerMessager.addMessage("紫色星魂功能失效,退出紫色星力功能");
            this._purpleSmoneyTime = 0;
            this.enableAllBtn(true);
        }
    }

    private function endFunc():void
    {
        this.enableAllBtn(true);
        this.update();
        this.updateStarNum();
    }

    private function update() : void
    {
        var getedVal:int = 0;
        var getedVal2:int = 0;
        ActiveCountManager.requestActiveCountList([204494,204491],function(par:Parser_1142):void
        {
            var i:int = 0;
            getedVal = par.infoVec[0];
            getedVal2 = par.infoVec[1];
            StarMagicManager.starMoney = getedVal;
            _smoneyTxt.text = "" + StarMagicManager.starMoney;
            var getedState:Array = [];
            while(i < 5)
            {
                getedState.push(Boolean(Math.pow(2,i) & getedVal2));
                i++;
            }
            updateGetBtn(getedState);
        });
        this.updateStar(this.updateStarIcon,this.updateStarIcon);
        _mainUI["money"].text = "" + ActorManager.actorInfo.coins;
    }

    private function updateStar(func:Function,fune:Function):void
    {
        //拉取同步星魂数据
        StarMagicManager.getTemporaryStar(func,fune);
    }

    private function updateStarIcon() : void
    {
        var i:int = 0;
        var info:Vector.<StarInfo> = StarMagicManager.temporaryStarInfo;
        while(i < this.STARNUM)
        {
            if(i < info.length)
            {
                this._starIconVec[i].updateDateInfo(info[i]);
            }
            else
            {
                this._starIconVec[i].updateDateInfo(null);
            }
            i++;
        }
        this.resetPos();
    }

    private function resetPos() : void
    {
        var i:int = 0;
        while(i < this._starIconVec.length)
        {
            this._starIconVec[i].x = this._posVec[i].x;
            this._starIconVec[i].y = this._posVec[i].y;
            this._starIconVec[i].alpha = 1;
            i++;
        }
    }

    private function updateGetBtn(data:Array):void
    {
        var i:int = 0;
        while(i < 5)
        {
            if(Boolean(data[i]))
            {
                this._suoVec[i].visible = false;
                this._getBtnVec[i].mouseEnabled = true;
            }
            else
            {
                this._getBtnVec[i].mouseEnabled = false;
                this._suoVec[i].visible = true;
            }
            i++;
        }
        this._suoVec[0].visible = false;
        this._getBtnVec[0].mouseEnabled = true;
    }

    private function enableAllBtn(b:Boolean):void
    {
        var i:int = 0;
        var btn:SimpleButton = null;
        if(b)
        {
            DisplayObjectUtil.enableButton(this._bagBtn);
            DisplayObjectUtil.enableButton(this._ruleBtn);
            DisplayObjectUtil.enableButton(this._getStarBtn);
            DisplayObjectUtil.enableButton(this._onePurpleBtn);
            DisplayObjectUtil.enableButton(this._drawPurpleBtn);
            DisplayObjectUtil.enableButton(this._purpleSmoneyBtn);
            DisplayObjectUtil.enableButton(this._oneSmoneyBtn);
            DisplayObjectUtil.enableButton(this._oneChangeBtn);
            DisplayObjectUtil.enableButton(this._oneDrawBtn);
            while(i < 5)
            {
                btn = this._getBtnVec[i];
                DisplayObjectUtil.enableButton(btn);
                i++;
            }
            this.update();
            this.updateStarNum();
        }
        else
        {
            DisplayObjectUtil.disableButton(this._bagBtn);
            DisplayObjectUtil.disableButton(this._ruleBtn);
            DisplayObjectUtil.disableButton(this._getStarBtn);
            DisplayObjectUtil.disableButton(this._onePurpleBtn);
            DisplayObjectUtil.disableButton(this._drawPurpleBtn);
            DisplayObjectUtil.disableButton(this._purpleSmoneyBtn);
            DisplayObjectUtil.disableButton(this._oneSmoneyBtn);
            DisplayObjectUtil.disableButton(this._oneChangeBtn);
            DisplayObjectUtil.disableButton(this._oneDrawBtn);
            while(i < 5)
            {
                btn = this._getBtnVec[i];
                DisplayObjectUtil.disableButton(btn);
                i++;
            }
        }
    }

    private function drawStar(Pos:int, Type:int, Func:Function, Fune:Function) : void
    //该方法是用来获取星魂的。type=1时单次召唤，此时pos确定抽哪个格子。type=2时一键抽，此时pos固定为0
    {
        StarMagicManager.getTempStar(Pos,Type,Func,Fune);
    }

    private function sellStar(Pos:int, Id:int, Type:int, Func:Function, Fune:Function) : void
    //113是卖碎片，222是把星魂背包里的星魂转换为星力
    {
        StarMagicManager.sellStar(Pos,Id,Type,Func,Fune);
    }

    private function checkStarNum():Boolean
    {
        //每次点击按钮前检测星魂总数，防止大于4999炸号，并在每次召唤完星魂后调用update更新星魂数量
        if(this._totalStarNum >= 4900)
        {
            AlertManager.showAlert("星魂数量过多!星魂达到5000将会导致数据异常无法登录!禁止召唤星魂!");
            return false;
        }
        else if(this._totalStarNum >= 4000)
        {
            ServerMessager.addMessage("星魂数量大于4000,请及时清理!星魂数量过多将导致数据异常无法登录!");
        }
        return true;
    }

    private function updateStarNum():void
    {
        //获取并更新星魂总数，方便检测星魂总数
        SwapManager.swapItem(3063,1,function(data:IDataInput):void
        {
            ActiveCountManager.requestActiveCountList([204536,204537,204538],function(param1:Parser_1142):void
            {
                _totalStarNum = int(param1.infoVec[0] + param1.infoVec[1] + param1.infoVec[2]);
            });
        });
    }

    override public function show():void
    {
        super.show();
        this.update();
        this.updateStarNum();
        ItemManager._getCoinsMessageSwitch = false;
    }

    override protected function onClose(e:MouseEvent) : void
    {
        ItemManager._getCoinsMessageSwitch = true;
        ModuleManager.closeForInstance(this);
    }
}
}