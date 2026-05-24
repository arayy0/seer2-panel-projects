package com.taomee.seer2.module.app.winterSignPanel.item
{
   import com.taomee.seer2.app.component.Scroller;
   import com.taomee.seer2.app.config.WinterSignConfig;
   import com.taomee.seer2.app.config.info.WinterSignInfo;
   import com.taomee.seer2.app.info.DayLimitListInfo;
   import com.taomee.seer2.app.net.parser.Parser_1142;
import com.taomee.seer2.app.popup.AlertManager;
import com.taomee.seer2.core.cookie.SharedObjectManager;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.utils.DateUtil;
   import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.media.SoundMixer;
   import flash.net.SharedObject;

   import org.taomee.utils.DisplayUtil;
   
   public class WinSignDayPanel implements IWinterSignPanel
   {
      private var _mc:MovieClip;
      
      private var _data:Vector.<WinterSignInfo>;
      
      private var _winList:Vector.<WinSignDayItem>;
      
      private var _scrollBar:Scroller;
      
      private var _par:Parser_1142;
      
      private var _info:DayLimitListInfo;
      
      private var _dayFinishState:Vector.<int>;
      
      private var _curFiniswhNum:int;
      
      private var _newFinishNum:int;

      private var _autoBtn:SimpleButton;

      private var _autoReward:Boolean;
      
      public function WinSignDayPanel()
      {
         super();
      }
      
      public function setup(mc:MovieClip) : void
      {
         this._mc = mc;
         this.initScrollInit();
         this.initRankingList();
      }
      
      public function show() : void
      {
         this._mc.visible = true;
      }
      
      public function hide() : void
      {
         this._mc.visible = false;
      }
      
      public function setData(data:*) : void
      {
         var dat:Array = data as Array;
         this._data = dat[0];
         this._par = dat[1];
         this._info = dat[2];
         this.update();
      }
      
      private function initScrollInit() : void
      {
         this._scrollBar = new Scroller(this._mc["scroll"]);
         this._scrollBar.x = 0;
         this._scrollBar.y = 0;
         this._scrollBar.pageSize = 7;
         DisplayUtil.removeForParent(this._mc["scroll"]);
         this._mc.addChild(this._scrollBar);
      }
      
      private function initRankingList() : void
      {
         this._autoBtn = this._mc["autoBtn"];
         this._autoBtn.addEventListener("click",function(e:MouseEvent):void{
            AlertManager.showConfirm("改服特供一键签到,开启后追加奖励:每日3钻,星钻合成,亚伦游戏,月神抽签,神雷抽奖,狼王抽奖,每日星币,六星豪礼,星石抽奖,星石签到,养成材料.点击确认按钮表示了解功能并开启,也可以随时返回此处点击取消关闭功能",
                    function():void {
               writeAutoCookie(true);
            },function():void {
               writeAutoCookie(false);
            })
         })
         this.readAutoCookie();
         this.resetRankList();
      }
      
      private function clrarRankingList() : void
      {
         var item:WinSignDayItem = null;
         for each(item in this._winList)
         {
            DisplayUtil.removeForParent(item);
         }
         this._winList = Vector.<WinSignDayItem>([]);
      }

      private function resetRankList():void
      {
         var i:int = 0;
         var item:WinSignDayItem = null;
         this.clrarRankingList();
         this._winList = Vector.<WinSignDayItem>([]);
         for(i = 0; i < 7; )
         {
            item = new WinSignDayItem();
            item.x = -220;
            item.y = 5 + 59 * i;
            item._autoReward = this._autoReward;
            this._mc.addChild(item);
            this._winList.push(item);
            i++;
         }
         this.updateItemData();
      }
      
      private function update() : void
      {
         this.initScroll();
      }
      
      private function initScroll() : void
      {
         this._scrollBar.maxScrollPosition = this._data.length;
         this.setTodayPos();
         var percent:Number = this._scrollBar.scrollPosition / (this._scrollBar.maxScrollPosition - this._scrollBar.pageSize);
         if(this._scrollBar.maxScrollPosition <= this._scrollBar.pageSize)
         {
            this._scrollBar.scrollPosition = 0;
         }
         else
         {
            this._scrollBar.scrollPosition = (this._scrollBar.maxScrollPosition - this._scrollBar.pageSize) * percent;
         }
         this.updateItemVec();
         this._scrollBar.addEventListener("move",this.onScrollMove);
      }

      private function readAutoCookie():void {
         var _loc1_:SharedObject = SharedObjectManager.getUserSharedObject(SharedObjectManager.USER_SETTING);
         if (_loc1_.data["WinSignAuto"] == null || _loc1_.data["WinSignAuto"] == 0) {
            _loc1_.data["WinSignAuto"] = 0;
            this._autoReward = false;
         } else {
            this._autoReward = true;
         }
      }

      private function writeAutoCookie(param1:Boolean):void {
         var _loc2_:SharedObject = SharedObjectManager.getUserSharedObject(SharedObjectManager.USER_SETTING);
         _loc2_.data["WinSignAuto"] = param1 ? 1 : 0;
         this._autoReward = param1;
         this.resetRankList();
      }
      
      private function setTodayPos() : void
      {
         var daysIndex:int = int(DateUtil.getDateBtweenDays(new Date(WinterSignConfig.startTime[0],WinterSignConfig.startTime[1] - 1,WinterSignConfig.startTime[2]),new Date(TimeManager.getPrecisionServerTime() * 1000)));
         if(daysIndex < 0)
         {
            daysIndex = 0;
         }
         this._scrollBar.scrollPosition = int((daysIndex + 1) / 7) * 7;
      }
      
      private function onScrollMove(e:Event) : void
      {
         this.updateItemVec();
      }
      
      private function updateItemVec() : void
      {
         var i:int = 0;
         var curNum:int = 0;
         var infoIndex:int = 0;
         var startIndex:int = int(this._scrollBar.scrollPosition);
         this._newFinishNum = this._info.getCount(WinterSignConfig.dayList[7]);
         for(i = 0; i < 7; )
         {
            infoIndex = startIndex + i;
            if(infoIndex < this._data.length)
            {
               this._winList[i].setData(this._data[infoIndex],this._info.getCount(WinterSignConfig.dayList[0]),this._par.infoVec[0]);
            }
            else
            {
               this._winList[i].dispose();
            }
            i++;
         }
      }

      private function updateItemData():void
      {
         if(!this._data)
         {
            return;
         }
         for(var i:int = 0; i < 7; )
         {
            if(i < this._data.length)
            {
               this._winList[i].setData(this._data[i],this._info.getCount(WinterSignConfig.dayList[0]),this._par.infoVec[0]);
            }
            else
            {
               this._winList[i].dispose();
            }
            i++;
         }
      }
   }
}

