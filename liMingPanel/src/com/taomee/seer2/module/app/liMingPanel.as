package com.taomee.seer2.module.app
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.net.parser.Parser_1142;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.module.Module;
   import com.taomee.seer2.core.module.ModuleManager;
import com.taomee.seer2.core.net.MessageEvent;
import com.taomee.seer2.core.utils.DisplayObjectUtil;
import com.taomee.seer2.core.utils.URLUtil;

import flash.display.DisplayObject;
import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
import flash.ui.Mouse;
import flash.utils.IDataInput;
   import org.taomee.filter.ColorFilter;
   
   public class liMingPanel extends Module
   {
      
      private static var havePlay:Boolean = false;
      
      private const GET_SWAP:int = 2951;
      
      private const PLAY_SWAP:int = 2952;
      
      private const MI_BUY_NUM_FOR:uint = 205947;
      
      private var curIndex:uint = 0;
      
      private var showTime:int = 4;
      
      private var path:uint = 0;
      
      private var nowFrame:uint = 1;
      
      private var showWin1:Array = [0,2,4,0,2,4];
      
      private var showWin2:Array = [1,3,5,1,3,5];
      
      private var money:Array = [200,1000,2000,5000,20000,20000];
      
      private var _titleMC:MovieClip;
      
      private var _movieMC:MovieClip;
      
      private var _showMcVec:Vector.<MovieClip>;
      
      private var _btnMcVec:Vector.<SimpleButton>;

      private var _choiceVec:Vector.<MovieClip>;

      private var _choice:int;

      private var _onceBtn:SimpleButton;

      private var _successTime:int = 0;
      
      public function liMingPanel()
      {
         super();
         _lifecycleType = "global";
      }
      
      override public function setup() : void
      {
         setMainUI(new liMingPanelUI());
         this.initset();
         this.addEvent();
      }
      
      private function initset() : void
      {
         var i:uint = 0;
         this._titleMC = _mainUI["title"];
         this._movieMC = _mainUI["movie"];
         this._onceBtn = _mainUI["onceBtn"];
         for(i = 0; i < 6; )
         {
            this._movieMC["show" + i].gotoAndStop(1);
            i++;
         }
         if(!this._showMcVec)
         {
            this._showMcVec = new Vector.<MovieClip>();
            for(i = 0; i < 5; )
            {
               this._showMcVec.push(_mainUI["show" + i]);
               i++;
            }
         }
         if(!this._btnMcVec)
         {
            this._btnMcVec = new Vector.<SimpleButton>();
            for(i = 0; i < 5; )
            {
               this._btnMcVec.push(_mainUI["btn" + i]);
               i++;
            }
         }
         if(!this._choiceVec)
         {
            this._choiceVec = new Vector.<MovieClip>();
            for(i = 0; i < 3; i++)
            {
               this._choiceVec.push(_mainUI["choice" + i]);
               this._choiceVec[i].gotoAndStop(1);
               this._choiceVec[i].addEventListener("click",function(e:MouseEvent):void
               {
                  for(var j:int = 0; j < 3; j++)
                  {
                     if(_choiceVec[j] != e.target)
                     {
                        _choiceVec[j].gotoAndStop(1);
                     }
                     else
                     {
                        _choiceVec[j].gotoAndStop(2);
                        _choice = j;
                     }
                  }
               });
            }
         }
         this._choiceVec[1].gotoAndStop(2);
         this._choice = 1;
      }
      
      private function addEvent() : void
      {
         var i:uint = 0;
         for(i = 0; i < 5; )
         {
            this._btnMcVec[i].addEventListener("click",this.onClick);
            i++;
         }
         this._onceBtn.addEventListener("click",this.onOnce);
      }
      
      private function onClick(e:MouseEvent) : void
      {
         var i:uint = 0;
         for(i = 0; i < 5; )
         {
            if(e.target == this._btnMcVec[i])
            {
               if(i == 0)
               {
                  if(ActorManager.actorInfo.coins >= this.money[this.curIndex])
                  {
                     StatisticsManager.newSendNovice("2014活动","猎命消耗赛尔豆","开始猎命");
                     SwapManager.swapItem(2952,1,function(data:IDataInput):void
                     {
                        havePlay = true;
                        new SwapInfo(data);
                        update();
                     },null,null);
                     break;
                  }
                  AlertManager.showAlert("需要" + this.money[this.curIndex] + "赛尔豆！");
                  break;
               }
               if(i == 1)
               {
                  if(ActorManager.actorInfo.coins >= this.money[this.curIndex])
                  {
                     StatisticsManager.newSendNovice("2014活动","猎命消耗赛尔豆","开始猎命");
                     SwapManager.swapItem(2952,1,function(data:IDataInput):void
                     {
                        havePlay = true;
                        new SwapInfo(data);
                        update();
                     },null,null);
                     break;
                  }
                  AlertManager.showAlert("需要" + this.money[this.curIndex] + "赛尔豆！");
                  break;
               }
               if(i == 2)
               {
                  ModuleManager.closeForName("liMingPanel");
                  break;
               }
               if(i == 3)
               {
                  if(this.curIndex > 0)
                  {
                     SwapManager.swapItem(2951,1,function(data:IDataInput):void
                     {
                        new SwapInfo(data);
                        update();
                     },null,null);
                     break;
                  }
                  AlertManager.showAlert("不能领奖");
                  break;
               }
               if(i == 4)
               {
                  if(this.curIndex > 0)
                  {
                     SwapManager.swapItem(2951,1,function(data:IDataInput):void
                     {
                        new SwapInfo(data);
                        update();
                     },null,null);
                     break;
                  }
                  AlertManager.showAlert("不能领奖");
               }
               break;
            }
            i = i + 1;
         }
      }
      
      private function firstPlayFullScreen() : void
      {
         ServerBufferManager.getServerBuffer(231,function(server:ServerBuffer):void
         {
            var _isPlay:Boolean = Boolean(server.readDataAtPostion(1));
            if(!_isPlay)
            {
               ServerBufferManager.updateServerBuffer(231,1,1);
               MovieClipUtil.playFullScreen(URLUtil.getActivityFullScreen("brackFull"),null,true,true,2,true);
            }
         });
      }
      
      override public function show() : void
      {
         havePlay = false;
         this._movieMC.visible = false;
         this._titleMC.visible = true;
         this.update();
         super.show();
      }
      
      private function showBtn() : void
      {
         var i:uint = 0;
         for(i = 0; i < 5; )
         {
            this._btnMcVec[i].visible = false;
            i++;
         }
         if(this.curIndex == 0)
         {
            this._btnMcVec[0].visible = true;
            this._btnMcVec[2].visible = true;
         }
         else if(this.curIndex <= 4)
         {
            this._btnMcVec[1].visible = true;
            this._btnMcVec[3].visible = true;
         }
         else
         {
            this._btnMcVec[4].visible = true;
         }
      }
      
      private function update() : void
      {
         var i:uint = 0;
         var newIndex:uint = 0;
         i = 0;
         ActiveCountManager.requestActiveCountList([205947],function(par:Parser_1142):void
         {
            var index:uint = 0;
            curIndex = par.infoVec[0];
            if(havePlay)
            {
               _movieMC.visible = true;
               _titleMC.visible = false;
               if(curIndex != 0)
               {
                  index = Math.random() * (showWin1.length / 2 - 1);
                  path = 18 + showWin1[index] - 1;
               }
               else
               {
                  index = Math.random() * (showWin2.length / 2 - 1);
                  path = 18 + showWin2[index] - 1;
               }
               nowFrame = 0;
               showTime = 2;
               for(i = 0; i < 4; )
               {
                  _btnMcVec[i].visible = false;
                  i = i + 1;
               }
               _movieMC.addEventListener("enterFrame",showChouJiang);
               havePlay = false;
            }
            else
            {
               ShowMc();
            }
         });
      }
      
      private function showChouJiangMc(index:int) : void
      {
         var i:* = 0;
         for(i = 0; i < 6; )
         {
            this._movieMC["show" + i].gotoAndStop(1);
            i++;
         }
         this._movieMC["show" + index].gotoAndStop(2);
      }
      
      private function showChouJiang(e:Event) : void
      {
         this.path = 0;
         this.showTime = 0;
         if(this.path != 0)
         {
            if(this.showTime != 0)
            {
               --this.showTime;
            }
            else
            {
               --this.path;
               this.showChouJiangMc(this.nowFrame);
               ++this.nowFrame;
               if(this.nowFrame > 5)
               {
                  this.nowFrame = 0;
               }
               if(this.path > 12)
               {
                  this.showTime = 1;
               }
               else if(this.path > 8)
               {
                  this.showTime = 4;
               }
               else if(this.path > 0)
               {
                  this.showTime = 7;
               }
               else if(this.path == 0)
               {
                  this.showTime = 25;
               }
            }
         }
         else
         {
            if(this.showTime != 0)
            {
               --this.showTime;
               return;
            }
            if(this.curIndex == 0)
            {
            }
            this._movieMC.removeEventListener("enterFrame",this.showChouJiang);
            this.ShowMc();
            this.path = 0;
         }
      }
      
      private function ShowMc() : void
      {
         var i:* = 0;
         this._titleMC.visible = true;
         this._movieMC.visible = false;
         for(i = 0; i < 5; )
         {
            this.setBtnEnable(this._showMcVec[i],false);
            if(this.curIndex > i)
            {
               this.setBtnEnable(this._showMcVec[i],true);
            }
            i++;
         }
         this.showBtn();
         this._titleMC.gotoAndStop(this.curIndex + 1);
      }

      private function onOnce(e:MouseEvent):void
      {
         if(ActorManager.actorInfo.coins < 10000000)
         {
            AlertManager.showAlert("请至少自备1000w赛尔豆!\n(改服赛尔豆很容易大量获取的啊喂)");
         }
         else
         {
            this.enableAllBtn(false);
            this.autoDraw1();
         }
      }

      private function autoDraw1(e:MessageEvent = null):void
      {
         if(this.curIndex < this._choice + 3)
         {
            SwapManager.swapItem(2952,1,function(data:IDataInput):void
            {
               new SwapInfo(data);
               autoDraw2();
            },function(e:MessageEvent):void
            {
               AlertManager.showAlert("抽奖异常中断，检查赛尔豆是否足够");
               update();
               enableAllBtn(true);
            },null);
         }
         else
         {
            SwapManager.swapItem(2951,1,function(data:IDataInput):void
            {
               new SwapInfo(data);
               update();
               enableAllBtn(true);
            },null,null);
         }
      }

      private function autoDraw2(e:MessageEvent = null):void
      {
         ActiveCountManager.requestActiveCountList([205947],function(par:Parser_1142):void
         {
            curIndex = par.infoVec[0];
            var i:int;
            for(i = 0; i < 5; )
            {
               setBtnEnable(_showMcVec[i],false);
               if(curIndex > i)
               {
                  setBtnEnable(_showMcVec[i],true);
               }
               i++;
            }
            autoDraw1();
         });
      }

      private function enableAllBtn(enable:Boolean = false) : void
      {
         var i:int;
         if(enable)
         {
            for(i = 0; i < 5; i++) {
               DisplayObjectUtil.enableButton(this._btnMcVec[i]);
            }
            DisplayObjectUtil.enableButton(this._onceBtn);
         }
         else
         {
            for(i = 0; i < 5; i++)
            {
               DisplayObjectUtil.disableButton(this._btnMcVec[i]);
            }
            DisplayObjectUtil.disableButton(this._onceBtn);
         }
         for(i = 0; i < 3; i++)
         {
            this.setBtnEnable(this._choiceVec[i], enable);
         }
      }
      
      private function setBtnEnable(target:MovieClip, val:Boolean) : void
      {
         if(val)
         {
            target.filters = [];
         }
         else
         {
            ColorFilter.setGrayscale(target);
         }
         target.mouseEnabled = val;
      }
      
      override public function hide() : void
      {
         this._movieMC.removeEventListener("enterFrame",this.showChouJiang);
         if(this.curIndex > 0)
         {
            SwapManager.swapItem(2951,1,function(data:IDataInput):void
            {
               new SwapInfo(data);
               update();
            },null,null);
         }
         havePlay = false;
         super.hide();
      }
   }
}

