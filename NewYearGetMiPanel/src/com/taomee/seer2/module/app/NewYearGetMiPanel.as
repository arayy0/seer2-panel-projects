package com.taomee.seer2.module.app {
import com.greensock.TweenNano;
import com.taomee.seer2.app.activeCount.ActiveCountManager;
import com.taomee.seer2.app.info.DayLimitListInfo;
import com.taomee.seer2.app.manager.DayLimitListManager;
import com.taomee.seer2.app.net.CommandSet;
import com.taomee.seer2.app.net.Connection;
import com.taomee.seer2.app.net.parser.Parser_1142;
import com.taomee.seer2.app.shopManager.ShopManager;
import com.taomee.seer2.app.swap.SwapManager;
import com.taomee.seer2.app.swap.info.SwapInfo;
import com.taomee.seer2.app.swap.special.SpecialInfo;
import com.taomee.seer2.app.utils.MovieClipUtil;
import com.taomee.seer2.core.manager.TimeManager;
import com.taomee.seer2.core.net.MessageEvent;
import com.taomee.seer2.core.ui.toolTip.TooltipManager;
import com.taomee.seer2.core.utils.DateUtil;
import com.taomee.seer2.core.utils.DisplayObjectUtil;
import com.taomee.seer2.module.core.TopModule;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.utils.IDataInput;
import org.taomee.manager.EventManager;
import org.taomee.utils.BitUtil;
import org.taomee.utils.Tick;
   
   public class NewYearGetMiPanel extends TopModule {
      private var _moveMC:MovieClip;
      private var _moveTxt:TextField;
      private var _openMc:MovieClip;
      private var _openBtn:SimpleButton;
      private var _canOpenNum:TextField;
      private var _scoreTxt:TextField;
      private var _getBtnList:Vector.<SimpleButton>;
      private var _getedMarkList:Vector.<MovieClip>;
      private var _itemList:Vector.<SimpleButton>;
      private var _cdUI:MovieClip;
      private var _cdTime:TextField;
      private const FOR_LIST:Array = [206215,206216];
      private const DAY_LIST:Array = [1853,1854];
      private const SWAP_LIST:Vector.<int> = Vector.<int>([4430,4431]);
      private const MI_ID_LIST:Vector.<uint> = Vector.<uint>([606782]);
      private const GAME_RULE:Vector.<int> = Vector.<int>([25,50,75,100,10]);
      private const AWARD_NAME_STR:Vector.<String> = Vector.<String>(["赛尔豆*666666","星钻碎片*7777","星钻*88"]); // 删除888星钻提示，以免引起不必要期待
      private const ITEM_TIP:Vector.<String> = Vector.<String>(["赛尔豆*10w","无敌学习精元(在物品背包中使用，可以\n使精灵的学习力增加510点)*1","无敌精灵精华(点击使用后一次性\n使精灵获得150万经验)*1","星钻*100"]);
      private const PUBLIC_KEY:int = 158;
      private var _moveNum:int;
      private var _leaveTime:int;
      
      public function NewYearGetMiPanel() {
         super();
      }
      
      override public function setup() : void {
         this.setMainUI(new NewYearGetMiUI());
         this.initSet();
         this.initEvent();
      }
      
      private function initSet() : void {
         this._moveMC = _mainUI["moveMC"];
         this._moveTxt = this._moveMC["moveTxt"];
         this._openMc = _mainUI["openMc"];
         this._openMc.mouseEnabled = this._openMc.mouseChildren = false;
         this._openBtn = _mainUI["openBtn"];
         this._canOpenNum = _mainUI["canOpenNum"];
         this._scoreTxt = _mainUI["scoreTxt"];
         this._getBtnList = new Vector.<SimpleButton>();
         this._getedMarkList = new Vector.<MovieClip>();
         this._itemList = new Vector.<SimpleButton>();
         for(var i:int = 0; i < 4; ++i) {
            this._getBtnList.push(_mainUI["getBtn" + i]);
            this._getedMarkList.push(_mainUI["getedMark" + i]);
            this._itemList.push(_mainUI["item" + i]);
            TooltipManager.addCommonTip(this._itemList[i],this.ITEM_TIP[i]);
         }
         this._cdUI = _mainUI["cdUI"];
         this._cdUI.buttonMode = true;
         this._cdTime = this._cdUI["cdTime"];
      }
      
      private function initEvent() : void {
         var item:SimpleButton = null;
         for each(item in this._getBtnList) {
            item.addEventListener(MouseEvent.CLICK,this.onGetBtn);
         }
         this._openBtn.addEventListener(MouseEvent.CLICK,this.onOpenBtn);
         this._cdUI.addEventListener(MouseEvent.CLICK,this.onCdPass);
      }
      
      private function onCdPass(evt:MouseEvent) : void {
         ShopManager.buyItemForId(this.MI_ID_LIST[0],function():void {
            update();
            EventManager.dispatchEvent(new Event("NewYearGetMi"));
         });
      }
      
      private function onGetBtn(evt:MouseEvent) : void {
         var index:int = this._getBtnList.indexOf(evt.currentTarget);
         SwapManager.swapItem(this.SWAP_LIST[1],1,function(data:IDataInput):void {
            new SwapInfo(data);
            update();
         },null,new SpecialInfo(1,index + 1));
      }
      
      private function onOpenBtn(evt:MouseEvent) : void {
         MovieClipUtil.playMc(this._openMc,2,this._openMc.totalFrames,function():void {
            _openMc.gotoAndStop(1);
            SwapManager.swapItem(SWAP_LIST[0],1,function(data:IDataInput):void {
               new SwapInfo(data);
               update();
               EventManager.dispatchEvent(new Event("NewYearGetMi"));
            });
         });
      }
      
      private function setFuncDisable() : void {
         var item:SimpleButton = null;
         this._openBtn.mouseEnabled = false;
         for each(item in this._getBtnList) {
            item.mouseEnabled = false;
         }
      }
      
      private function updateMove() : void {
         Connection.send(CommandSet.GET_TOTAL_VOTE_INFO_1219,this.PUBLIC_KEY,1,4);
         Connection.addCommandListener(CommandSet.GET_TOTAL_VOTE_INFO_1219,function getCallState(evt:MessageEvent):void {
            var _loc9_:int = 0;
            var key:uint = 0;
            var value:uint = 0;
            Connection.removeCommandListener(CommandSet.GET_TOTAL_VOTE_INFO_1219,getCallState);
            var data:IDataInput = evt.message.getRawData();
            var type:uint = data.readUnsignedInt();
            var count:uint = data.readUnsignedInt();
            var keyList:Vector.<uint> = Vector.<uint>([1,2,3,4]);
            var valList:Array = [0,0,0,0];
            for(var i:int = 0; i < count; i++) {
               key = data.readUnsignedInt();
               value = data.readUnsignedInt();
               if(keyList.indexOf(key) != -1) {
                  valList[keyList.indexOf(key)] = value;
               }
            }
            var str:String = "";
            var len:int = valList.length < AWARD_NAME_STR.length ? valList.length : AWARD_NAME_STR.length;
            // 删除888星钻提示，以免引起不必要期待，这里也要同步地限制
            for(i = 0; i < len; i++) {
               if(valList[i] != 0) {
                  if(_loc9_ == 0) {
                     str += "最新获得大奖的幸运玩家： ";
                  }
                  str += valList[i].toString() + "(" + AWARD_NAME_STR[i] + ")" + "  ";
                  _loc9_++;
               }
            }
            if(_loc9_ != 0) {
               _moveNum = 0;
               _moveTxt.text = str;
               startMove();
            }
         });
      }
      
      private function startMove() : void {
         this._moveTxt.width = 1500;
         this._moveTxt.x = 500;
         Tick.instance.addRender(this.move,30);
      }
      
      private function move(a:uint) : void {
         this._moveTxt.x -= 2;
         if(this._moveTxt.x < -870) {
            ++this._moveNum;
            this._moveTxt.x = 520;
            if(this._moveNum == 3) {
               Tick.instance.removeRender(this.move);
            }
         }
      }
      
      private function update(isMove:Boolean = false) : void {
         this.setFuncDisable();
         ActiveCountManager.requestActiveCountList(this.FOR_LIST,function(par:Parser_1142):void {
            DayLimitListManager.getDaylimitList(DAY_LIST,function(info:DayLimitListInfo):void {
               var curIndex:int;
               var i:int;
               _scoreTxt.text = par.infoVec[0].toString();
               curIndex = -1;
               for(i = 0; i < 4; i++) {
                  if(par.infoVec[0] < GAME_RULE[i]) {
                     break;
                  }
                  curIndex = i;
               }
               for(i = 0; i < 4; i++) {
                  if(i <= curIndex) {
                     if(BitUtil.getBit(par.infoVec[1],i)) {
                        DisplayObjectUtil.disableButton(_getBtnList[i]);
                        _getedMarkList[i].visible = true;
                     }
                     else {
                        DisplayObjectUtil.enableButton(_getBtnList[i]);
                        _getedMarkList[i].visible = false;
                     }
                  }
                  else {
                     DisplayObjectUtil.disableButton(_getBtnList[i]);
                     _getedMarkList[i].visible = false;
                  }
               }
               Tick.instance.removeRender(onTimeUpdate);
               _canOpenNum.text = (GAME_RULE[4] - info.getCount(DAY_LIST[0])).toString();
               if(GAME_RULE[4] - info.getCount(DAY_LIST[0]) <= 0) {
                  _openBtn.visible = true;
                  _cdUI.visible = false;
                  DisplayObjectUtil.disableButton(_openBtn);
               }
               else if(TimeManager.getPrecisionServerTime() >= info.getCount(DAY_LIST[1])) {
                  _openBtn.visible = true;
                  _cdUI.visible = false;
                  DisplayObjectUtil.enableButton(_openBtn);
               }
               else {
                  _openBtn.visible = false;
                  _cdUI.visible = true;
                  DisplayObjectUtil.disableButton(_openBtn);
                  _leaveTime = info.getCount(DAY_LIST[1]) - TimeManager.getPrecisionServerTime();
                  _cdTime.text = DateUtil.getMS(_leaveTime);
                  Tick.instance.addRender(onTimeUpdate,1000);
               }
               TweenNano.delayedCall(2,function():void {
                  if(isMove) {
                     updateMove();
                  }
               });
            });
         });
      }
      
      private function onTimeUpdate(val:int) : void {
         --this._leaveTime;
         this._cdTime.text = DateUtil.getMS(this._leaveTime);
         if(this._leaveTime <= 0) {
            Tick.instance.removeRender(this.onTimeUpdate);
            this.update();
         }
      }
      
      override public function show() : void {
         this.update(true);
         super.show();
      }
      
      override public function hide() : void {
         Tick.instance.removeRender(this.onTimeUpdate);
         super.hide();
         this._moveTxt.width = 10;
         this._moveTxt.x = 500;
      }
   }
}

