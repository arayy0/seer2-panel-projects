package com.taomee.seer2.module.app.winterSignPanel.item
{
   import com.taomee.seer2.app.component.Scroller;
   import com.taomee.seer2.app.config.WinterSignConfig;
   import com.taomee.seer2.app.config.info.WinterSignInfo;
   import com.taomee.seer2.app.net.parser.Parser_1142;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.utils.BitUtil;
   import org.taomee.utils.DisplayUtil;
   
   public class WinSignForPanel implements IWinterSignPanel
   {
      private var _mc:MovieClip;
      
      private var _data:Vector.<WinterSignInfo>;
      
      private var _winList:Vector.<WinSignForItem>;
      
      private var _scrollBar:Scroller;
      
      private var _par:Parser_1142;
      
      public function WinSignForPanel()
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
         this.update();
      }
      
      private function initScrollInit() : void
      {
         this._scrollBar = new Scroller(this._mc["scroll"]);
         this._scrollBar.x = 0;
         this._scrollBar.y = 0;
         this._scrollBar.pageSize = 2;
         DisplayUtil.removeForParent(this._mc["scroll"]);
         this._mc.addChild(this._scrollBar);
         this._scrollBar.visible = false;
      }
      
      private function initRankingList() : void
      {
         var i:int = 0;
         var item:WinSignForItem = null;
         this.clrarRankingList();
         this._winList = Vector.<WinSignForItem>([]);
         for(i = 0; i < 2; )
         {
            item = new WinSignForItem();
            item.setAwardIndex(i + 1);
            item.x = -193;
            item.y = 170 * i;
            this._mc.addChild(item);
            this._winList.push(item);
            i++;
         }
      }
      
      private function clrarRankingList() : void
      {
         var item:WinSignForItem = null;
         for each(item in this._winList)
         {
            DisplayUtil.removeForParent(item);
         }
         this._winList = Vector.<WinSignForItem>([]);
      }
      
      private function update() : void
      {
         this.initScroll();
      }
      
      private function initScroll() : void
      {
         this._scrollBar.maxScrollPosition = this._data.length;
         this.setCurPos();
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
      
      private function setCurPos() : void
      {
         var i:int = 0;
         var curIndex:* = 0;
         for(i = 0; i < this._data.length; )
         {
            if(!BitUtil.getBit(this._par.infoVec[1],i))
            {
               curIndex = i;
               break;
            }
            i++;
         }
         this._scrollBar.scrollPosition = int((curIndex + 1) / 2) * 2;
      }
      
      private function onScrollMove(e:Event) : void
      {
         this.updateItemVec();
      }
      
      private function updateItemVec() : void
      {
         var i:int = 0;
         var infoIndex:int = 0;
         var startIndex:int = int(this._scrollBar.scrollPosition);
         for(i = 0; i < 2; )
         {
            infoIndex = startIndex + i;
            if(infoIndex < this._data.length)
            {
               this._winList[i].setData(this._data[infoIndex],this.getSignDays(),this._par.infoVec[1]);
            }
            else
            {
               this._winList[i].dispose();
            }
            i++;
         }
      }
      
      private function getSignDays() : int
      {
         var i:int = 0;
         var result:int = 0;
         for(i = 0; i < WinterSignConfig.getDayInfoVec().length; )
         {
            if(BitUtil.getBit(this._par.infoVec[0],i))
            {
               result++;
            }
            i++;
         }
         return result;
      }
   }
}

