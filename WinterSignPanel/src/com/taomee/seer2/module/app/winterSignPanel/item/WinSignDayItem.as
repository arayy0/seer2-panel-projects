package com.taomee.seer2.module.app.winterSignPanel.item
{
   import com.taomee.seer2.app.config.WinterSignConfig;
   import com.taomee.seer2.app.config.info.WinterSignInfo;
   import com.taomee.seer2.app.event.LogicEvent;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.app.swap.special.SpecialInfo;
   import com.taomee.seer2.app.vip.VipManager;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.events.ModelLocator;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DateUtil;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.IDataInput;
   import org.taomee.filter.ColorFilter;
   import org.taomee.utils.BitUtil;
   import org.taomee.utils.DisplayUtil;
   
   public class WinSignDayItem extends Sprite
   {
      private var _mc:MovieClip;
      
      private var _nameTxt:TextField;
      
      private var _getedMark:MovieClip;
      
      private var _funcBtn:MovieClip;
      
      private var _iconList:Vector.<WinSignIcon>;
      
      private var _info:WinterSignInfo;
      
      private var _dailyTime:int = 0;
      
      private var _sixStarTime:int = 0;

      public var _autoReward:Boolean = false;
      
      public function WinSignDayItem()
      {
         super();
         this._mc = new DaySignItemUI();
         addChild(this._mc);
         this.initSet();
         this.initEvent();
      }
      
      private function initSet() : void
      {
         this._nameTxt = this._mc["nameTxt"];
         this._iconList = Vector.<WinSignIcon>([]);
         this._getedMark = this._mc["getedMark"];
         this._funcBtn = this._mc["funcBtn"];
      }
      
      private function initEvent() : void
      {
         this._funcBtn.addEventListener("click",this.onFuncBtn);
      }
      
      private function onFuncBtn(evt:MouseEvent) : void
      {
         var swapId:int = 0;
         var canFreeNum:int = 0;
         if(Boolean(this._info))
         {
            if(this._funcBtn.currentFrame == 1)
            {
               if(this._info.type == "day")
               {
                  swapId = int(WinterSignConfig.swapList[0]);
               }
               else
               {
                  swapId = int(WinterSignConfig.swapList[1]);
               }
               SwapManager.swapItem(swapId,1,function(data:IDataInput):void
               {
                  new SwapInfo(data);
                  ModelLocator.getInstance().dispatchEvent(new LogicEvent("winterSignGetAward"));
                  if(_autoReward)
                  {
                     Connection.addCommandListener(CommandSet.ITEM_EXCHANGE_1055,daily3Diamonds);
                     Connection.addErrorHandler(CommandSet.ITEM_EXCHANGE_1055,dailyOperationsStart);
                     SwapManager.swapItem(2772);
                  }
               },null,new SpecialInfo(1,this._info.index));
            }
            else
            {
               canFreeNum = !!VipManager.vipInfo.isVip() ? int(WinterSignConfig.freeSign[1]) : int(WinterSignConfig.freeSign[0]);
               if(WinterSignConfig.par.infoVec[2] >= canFreeNum)
               {
                  if(VipManager.vipInfo.isVip())
                  {
                     ServerMessager.addMessage("补签机会已用完");
                  }
                  else
                  {
                     ModuleManager.showAppModule("SignVipPanel");
                  }
               }
               else
               {
                  SwapManager.swapItem(WinterSignConfig.swapList[2],1,function(data:IDataInput):void
                  {
                     new SwapInfo(data);
                     ModelLocator.getInstance().dispatchEvent(new LogicEvent("winterSignGetAward"));
                  },null,new SpecialInfo(1,this._info.index));
               }
            }
         }
      }
      
      private function dailyOperationsStart(e:MessageEvent = null) : void
      {
         if(e != null)
         {
            Connection.removeCommandListener(CommandSet.ITEM_EXCHANGE_1055,daily3Diamonds);
            Connection.removeErrorHandler(CommandSet.ITEM_EXCHANGE_1055,dailyOperationsStart);
         }
         this._dailyTime = 0;
         Connection.addCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.diamondSwap);
         Connection.addErrorHandler(CommandSet.ITEM_EXCHANGE_1055,this.leiShenAwakeSwap);
         Connection.send(CommandSet.ITEM_EXCHANGE_1055,2848,1,1,1);
      }
      
      private function daily3Diamonds(e:MessageEvent) : void
      {
         SwapManager.swapItem(2772);
      }
      
      private function diamondSwap(e:MessageEvent = null) : void
      {
         Connection.send(CommandSet.ITEM_EXCHANGE_1055,2848,1,1,1);
      }
      
      private function leiShenAwakeSwap(e:MessageEvent = null) : void
      {
         Connection.removeCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.diamondSwap);
         Connection.removeErrorHandler(CommandSet.ITEM_EXCHANGE_1055,this.leiShenAwakeSwap);
         Connection.addCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.Swap4658);
         Connection.addErrorHandler(CommandSet.ITEM_EXCHANGE_1055,this.SwapShengJing);
         SwapManager.swapItem(4169);
      }
      
      private function Swap4658(e:MessageEvent = null) : void
      {
         SwapManager.swapItem(4658);
      }
      
      private function SwapShengJing(e:MessageEvent = null) : void
      {
         Connection.removeCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.Swap4658);
         Connection.removeErrorHandler(CommandSet.ITEM_EXCHANGE_1055,this.SwapShengJing);
         Connection.addCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.SwapShengJingAct);
         Connection.addErrorHandler(CommandSet.ITEM_EXCHANGE_1055,this.SwapStarB);
         this._dailyTime = 0;
         Connection.send(CommandSet.ITEM_EXCHANGE_1055,2224,1,5,30,30,60,60,10);
      }
      
      private function SwapShengJingAct(e:MessageEvent = null) : void
      {
         if(this._dailyTime < 4)
         {
            Connection.send(CommandSet.ITEM_EXCHANGE_1055,2224,1,5,30,30,60,5,10);
            this._dailyTime++;
         }
         else
         {
            this._dailyTime = 0;
            this.SwapStarB();
         }
      }
      
      private function SwapStarB(e:MessageEvent = null) : void
      {
         Connection.removeCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.SwapShengJingAct);
         Connection.removeErrorHandler(CommandSet.ITEM_EXCHANGE_1055,this.SwapStarB);
         Connection.addCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.Swap1233MoonGod);
         Connection.addErrorHandler(CommandSet.ITEM_EXCHANGE_1055,this.Swap1233MoonGod);
         SwapManager.swapItem(613);
      }
      
      private function Swap1233MoonGod(e:MessageEvent = null) : void
      {
         Connection.removeCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.Swap1233MoonGod);
         Connection.removeErrorHandler(CommandSet.ITEM_EXCHANGE_1055,this.Swap1233MoonGod);
         Connection.addCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.Swap3990WolfGod);
         Connection.addErrorHandler(CommandSet.ITEM_EXCHANGE_1055,this.Swap3990WolfGod);
         SwapManager.swapItem(1233);
      }
      
      private function Swap3990WolfGod(e:MessageEvent = null) : void
      {
         Connection.removeCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.Swap3990WolfGod);
         Connection.removeErrorHandler(CommandSet.ITEM_EXCHANGE_1055,this.Swap3990WolfGod);
         Connection.addCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.SwapSixStarStart);
         Connection.addErrorHandler(CommandSet.ITEM_EXCHANGE_1055,this.SwapSixStarStart);
         SwapManager.swapItem(3990);
      }
      
      private function SwapSixStarStart(e:MessageEvent = null) : void
      {
         Connection.removeCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.SwapSixStarStart);
         Connection.removeErrorHandler(CommandSet.ITEM_EXCHANGE_1055,this.SwapSixStarStart);
         Connection.addCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.SwapSixStarGet);
         Connection.addErrorHandler(CommandSet.ITEM_EXCHANGE_1055,this.SwapStarStoneLotteryStart);
         this._sixStarTime = 0;
         SwapManager.swapItem(2932,1);
      }
      
      private function SwapSixStarGet(e:MessageEvent = null) : void
      {
         SwapManager.swapItem(2933,1,function(data:IDataInput):void
         {
            new SwapInfo(data);
         },null,new SpecialInfo(1,this._sixStarTime));
         this._sixStarTime++;
         if(this._sixStarTime > 5)
         {
            this.SwapStarStoneLotteryStart();
         }
      }
      
      private function SwapStarStoneLotteryStart(e:MessageEvent = null) : void
      {
         Connection.removeCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.SwapSixStarGet);
         Connection.removeErrorHandler(CommandSet.ITEM_EXCHANGE_1055,this.SwapStarStoneLotteryStart);
         Connection.addErrorHandler(CommandSet.DIGGER_MINE_1060,this.SwapStarStoneSign);
         Connection.addCommandListener(CommandSet.DIGGER_MINE_1060,this.SwapStarStoneLottery);
         Connection.send(CommandSet.DIGGER_MINE_1060,72);
      }
      
      private function SwapStarStoneLottery(e:MessageEvent = null) : void
      {
         Connection.send(CommandSet.DIGGER_MINE_1060,72);
      }
      
      private function SwapStarStoneSign(e:MessageEvent = null) : void
      {
         Connection.removeErrorHandler(CommandSet.DIGGER_MINE_1060,this.SwapStarStoneSign);
         Connection.removeCommandListener(CommandSet.DIGGER_MINE_1060,this.SwapStarStoneLottery);
         SwapManager.swapItem(459,1);
      }
      
      private function setFuncDisable() : void
      {
         DisplayObjectUtil.disableSprite(this._funcBtn);
      }
      
      public function setData(petMeleeWinInfo:WinterSignInfo, daySign:int, getState:int) : void
      {
         var curIndex:int = 0;
         var icon:WinSignIcon = null;
         var iconc:WinSignIcon = null;
         var i:int = 0;
         this.visible = true;
         this.setFuncDisable();
         this._info = petMeleeWinInfo;
         this._nameTxt.text = petMeleeWinInfo.tip;
         this._funcBtn.filters = [];
         this._funcBtn.visible = true;
         this._getedMark.visible = true;
         curIndex = this.getCurIndex();
         if(curIndex > petMeleeWinInfo.index - 1 && curIndex != -1)
         {
            if(BitUtil.getBit(getState,this._info.index - 1))
            {
               this._funcBtn.gotoAndStop(1);
               this._getedMark.visible = true;
               ColorFilter.setGrayscale(this._funcBtn);
               DisplayObjectUtil.disableSprite(this._funcBtn);
            }
            else
            {
               this._funcBtn.gotoAndStop(2);
               this._getedMark.visible = false;
               DisplayObjectUtil.enableSprite(this._funcBtn);
            }
         }
         else if(curIndex == petMeleeWinInfo.index - 1 && curIndex != -1)
         {
            if(Boolean(daySign))
            {
               this._funcBtn.gotoAndStop(1);
               this._getedMark.visible = true;
               ColorFilter.setGrayscale(this._funcBtn);
               DisplayObjectUtil.disableSprite(this._funcBtn);
            }
            else
            {
               this._funcBtn.gotoAndStop(1);
               this._getedMark.visible = false;
               DisplayObjectUtil.enableSprite(this._funcBtn);
            }
         }
         else
         {
            this._funcBtn.visible = false;
            this._getedMark.visible = false;
         }
         for each(icon in this._iconList)
         {
            icon.dispose();
            DisplayUtil.removeForParent(icon);
         }
         this._iconList = Vector.<WinSignIcon>([]);
         for(i = 0; i < petMeleeWinInfo.itemList.length; )
         {
            iconc = new WinSignIcon(petMeleeWinInfo.itemList[i],petMeleeWinInfo.countList[i]);
            iconc.x = 120 + 67 * i;
            iconc.y = 3;
            this._mc.addChild(iconc);
            this._iconList.push(iconc);
            i++;
         }
      }
      
      private function getCurIndex() : int
      {
         return DateUtil.getDateBtweenDays(new Date(WinterSignConfig.startTime[0],WinterSignConfig.startTime[1] - 1,WinterSignConfig.startTime[2]),new Date(TimeManager.getPrecisionServerTime() * 1000));
      }
      
      public function dispose() : void
      {
         this.visible = false;
      }
   }
}

