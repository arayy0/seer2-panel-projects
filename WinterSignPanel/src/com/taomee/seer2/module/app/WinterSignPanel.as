package com.taomee.seer2.module.app
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.component.Scroller;
   import com.taomee.seer2.app.config.WinterSignConfig;
   import com.taomee.seer2.app.config.info.WinterSignInfo;
   import com.taomee.seer2.app.event.LogicEvent;
   import com.taomee.seer2.app.info.DayLimitListInfo;
   import com.taomee.seer2.app.manager.DayLimitListManager;
   import com.taomee.seer2.app.net.parser.Parser_1142;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.module.Module;
   import com.taomee.seer2.core.scene.events.ModelLocator;
   import com.taomee.seer2.module.app.kingFightTrailTaskPanel.item.IKingFightTaskPanel;
   import com.taomee.seer2.module.app.winterSignPanel.item.WinSignDayPanel;
   import com.taomee.seer2.module.app.winterSignPanel.item.WinSignForPanel;
   import flash.events.Event;
   import flash.text.TextField;
   import org.taomee.utils.BitUtil;
   import org.taomee.utils.DisplayUtil;
   import seer2.next.entry.DynSwitch;
   
   public class WinterSignPanel extends Module
   {
      private var _panel:IKingFightTaskPanel;
      
      private var _actTime:TextField;
      
      private var _signDayNum:TextField;
      
      private const FOR_LIST:Array = [71,73,72];
      
      private const DAY_LIST:Array = [5018];
      
      private const SWAP_LIST:Vector.<int> = Vector.<int>([4426,4427,4428]);
      
      private const MI_ID_LIST:Vector.<uint> = Vector.<uint>([605583]);
      
      private var _par:Parser_1142;
      
      private var _info:DayLimitListInfo;
      
      private var _panel1:WinSignDayPanel;
      
      private var _panel2:WinSignForPanel;
      
      private var _panel1Data:Object;
      
      private var _mainTxt:TextField;
      
      private var _timeTxt:TextField;
      
      private var _scroller:Scroller;
      
      public function WinterSignPanel()
      {
         super();
         _lifecycleType = "global";
      }
      
      override public function setup() : void
      {
         setMainUI(new WinterSignUI());
         this.initSet();
         this.initEvent();
      }
      
      private function initSet() : void
      {
         var curDate:Date = null;
         var starTimeVal:Number = NaN;
         var i:int = 0;
         var curIndex:int = 0;
         var tmpDate:Date = null;
         this._panel1 = new WinSignDayPanel();
         this._panel2 = new WinSignForPanel();
         this._panel1.setup(_mainUI["panel0"]);
         this._panel2.setup(_mainUI["panel1"]);
         this._actTime = _mainUI["actTime"];
         this._signDayNum = _mainUI["signDayNum"];
         this._mainTxt = _mainUI["bg"]["maintxt"];
         this._timeTxt = _mainUI["bg"]["timetxt"];
         this._scroller = new Scroller(_mainUI["bg"]["scroll"]);
         this._scroller.pageSize = 0;
         this._scroller.x = 922;
         this._scroller.y = 45;
         this._scroller.scaleX = 1.25;
         this._scroller.scaleY = 1.25;
         DisplayUtil.removeForParent(_mainUI["bg"]["scroll"]);
         _mainUI.addChild(this._scroller);
         this._mainTxt.text = DynSwitch.changeLogAnnouncement;
         this._timeTxt.text = DynSwitch.changeLogModifyTime;
         var curTimeVal:Number = TimeManager.getPrecisionServerTime() * 1000;
         curDate = new Date(curTimeVal);
         if(curDate.day == 0)
         {
            curIndex = 7;
         }
         else
         {
            curIndex = curDate.day;
         }
         starTimeVal = curTimeVal - (curIndex - 1) * 86400000;
         var endTimeVal:Number = starTimeVal + 518400000;
         var startDate:Date = new Date(starTimeVal);
         WinterSignConfig.startTime = [startDate.fullYear,startDate.month + 1,startDate.date];
         var endDate:Date = new Date(endTimeVal);
         WinterSignConfig.endTime = [endDate.fullYear,endDate.month + 1,endDate.date];
         var daylist:Vector.<WinterSignInfo> = WinterSignConfig.getDayInfoVec();
         for(i = 0; i < 7; )
         {
            tmpDate = new Date(starTimeVal + i * 86400000);
            daylist[i].tip = tmpDate.month + 1 + "月" + tmpDate.date + "日";
            i++;
         }
         this._actTime.text = startDate.month + 1 + "月" + startDate.date + "日" + (endDate.month + 1) + "月" + endDate.date + "日";
         this._scroller.maxScrollPosition = this._mainTxt.maxScrollV - 1;
         if(this._scroller.maxScrollPosition <= this._scroller.pageSize)
         {
            this._scroller.scrollPosition = 0;
         }
         else
         {
            this._scroller.scrollPosition = 0;
         }
         this.onScrollerMove();
      }
      
      private function initEvent() : void
      {
         ModelLocator.getInstance().addEventListener("winterSignGetAward",this.onGetUpdate);
         this._scroller.addEventListener("move",this.onScrollerMove);
      }
      
      private function onGetUpdate(evt:LogicEvent) : void
      {
         this.update();
      }
      
      private function updateSelect() : void
      {
         this._panel1.show();
         this._panel2.show();
      }
      
      private function onScrollerMove(e:Event = null) : void
      {
         this._mainTxt.scrollV = this._scroller.scrollPosition + 1;
      }
      
      private function update() : void
      {
         DayLimitListManager.getDaylimitList(this.DAY_LIST,function(info:DayLimitListInfo):void
         {
            ActiveCountManager.requestActiveCountList(FOR_LIST,function(par:Parser_1142):void
            {
               var i:int = 0;
               WinterSignConfig.par = par;
               WinterSignConfig.info = info;
               var data1:Array = [WinterSignConfig.getDayInfoVec(),par,info];
               var data2:Array = [WinterSignConfig.getForInfoVec(),par];
               _panel1.setData(data1);
               _panel2.setData(data2);
               updateSelect();
               var signNum:int = 0;
               for(i = 0; i < WinterSignConfig.getDayInfoVec().length; )
               {
                  if(BitUtil.getBit(par.infoVec[0],i))
                  {
                     signNum++;
                  }
                  i++;
               }
               _signDayNum.text = signNum.toString();
            });
         });
      }
      
      override public function show() : void
      {
         this.update();
         super.show();
      }
   }
}

