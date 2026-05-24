package com.taomee.seer2.module.app
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.arena.FightManager;
   import com.taomee.seer2.app.config.ActCalendarConfig;
   import com.taomee.seer2.app.config.info.ActDetailInfo;
   import com.taomee.seer2.app.net.Command;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.core.module.Module;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.SceneType;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.IDataInput;

   import org.taomee.filter.ColorFilter;
   import org.taomee.utils.DisplayUtil;
   
   public class ActCalendarPanel extends Module
   {
      private var pagesTxt:TextField;
      
      private var curActEffect:MovieClip;
      
      private var preDay:SimpleButton;
      
      private var nextDay:SimpleButton;
      
      private var prePage:SimpleButton;
      
      private var nextPage:SimpleButton;
      
      private var artTips:ArtActTips = new ArtActTips();
      
      private var actList:Vector.<MovieClip>;
      
      private var overList:Vector.<WillOverIcon>;
      
      private var petList:Vector.<PetActIcon>;
      
      private var currentBtn:SimpleButton;
      
      private var mainListInfo:Vector.<ActDetailInfo>;
      
      private var mode:int;
      
      private var currentPage:int;
      
      private var maxPage:int;
      
      private var onePageNum:int = 6;
      
      private var curActIndex:int = -1;

      private var modeMC:MovieClip;

      private var command:Command;

      private var cmdByte:LittleEndianByteArray;

      private var cmdTime:uint;

      private var curTime:uint;
      
      public function ActCalendarPanel()
      {
         super();
      }
      
      override public function setup() : void
      {
         this.setMainUI(new ActCalendarPanelUI());
         this.pagesTxt = _mainUI["pagesTxt"];
         this.preDay = _mainUI["preDay"];
         this.nextDay = _mainUI["nextDay"];
         this.prePage = _mainUI["prePage"];
         this.nextPage = _mainUI["nextPage"];
         this.modeMC = _mainUI["modeMC"];
         this.actList = new Vector.<MovieClip>();
         this.overList = new Vector.<WillOverIcon>();
         this.petList = new Vector.<PetActIcon>();
         for(var i:int = 0; i < this.onePageNum; i++)
         {
            this.actList.push(_mainUI["list" + i]);
            this.overList.push(new WillOverIcon());
            this.overList[i].x = 230;
            this.overList[i].y = 30;
            this.petList.push(new PetActIcon());
            this.overList[i].mouseChildren = this.overList[i].mouseEnabled = false;
            this.petList[i].mouseChildren = this.petList[i].mouseEnabled = false;
            this.petList[i].y = 10;
            this.actList[i]["actName"].mouseEnabled = false;
            this.actList[i]["actTime"].mouseEnabled = false;
            this.actList[i]["goBtn"].addEventListener(MouseEvent.CLICK,this.goHandler);
         }
         this.mode = 0;
         _mainUI["timeTxt"].visible = false;
         _mainUI["timeBg"].visible = false;
         this.getDayInfo();
         _mainUI["timeTxt"].addEventListener("focusIn",function (e:*):void{
            _mainUI["timeTxt"].text = "";
         });
         _mainUI["timeTxt"].addEventListener("focusOut",function (e:*):void{
            if(_mainUI["timeTxt"].text == "")
            {
               _mainUI["timeTxt"].text = "输入发包次数";
            }
         });
         this.preDay.addEventListener(MouseEvent.CLICK,this.changeDay);
         this.nextDay.addEventListener(MouseEvent.CLICK,this.changeDay);
         this.prePage.addEventListener(MouseEvent.CLICK,this.changePage);
         this.nextPage.addEventListener(MouseEvent.CLICK,this.changePage);
         this.mainListInfo = ActCalendarConfig.getActList(this.mode);
         //this.goCurActPage();
      }
      
      private function goCurActPage() : void
      {
         if(ActCalendarConfig.curActIndex == -1)
         {
            trace("暂时无推送活动哦");
         }
         else
         {
            this.curActIndex = ActCalendarConfig.curActIndex;
            this.currentPage = Math.ceil((ActCalendarConfig.curActIndex + 1) / this.onePageNum);
            this.updateUI();
         }
      }
      
      private function updateTips(event:MouseEvent) : void
      {
         var num:int = int(this.actList.indexOf(event.target.parent));
         var index:int = (this.currentPage - 1) * this.onePageNum + num;
         if(index < 0 || !this.mainListInfo)
         {
            return;
         }
         if(index >= this.mainListInfo.length)
         {
            return;
         }
         var info:ActDetailInfo = this.mainListInfo[index];
         this.artTips.setData(info);
      }
      
      private function showEffect(_parent:MovieClip) : void
      {
         this.hideEffect();
         if(!this.curActEffect)
         {
            this.curActEffect = new Effect();
         }
         this.curActEffect.mouseEnabled = this.curActEffect.mouseChildren = false;
         _parent.addChildAt(this.curActEffect,0);
      }
      
      private function hideEffect() : void
      {
         if(Boolean(this.curActEffect))
         {
            DisplayUtil.removeForParent(this.curActEffect);
         }
         this.curActEffect = null;
      }
      
      private function changePage(event:MouseEvent) : void
      {
         if(Boolean(this.currentBtn))
         {
            this.currentBtn.mouseEnabled = true;
         }
         this.currentBtn = event.target as SimpleButton;
         this.currentBtn.mouseEnabled = false;
         if(event.target == this.prePage)
         {
            if(this.currentPage == 1)
            {
               return;
            }
            --this.currentPage;
         }
         else
         {
            if(this.currentPage == this.maxPage)
            {
               return;
            }
            ++this.currentPage;
         }
         this.updateUI();
         if(Boolean(this.currentBtn))
         {
            this.currentBtn.mouseEnabled = true;
         }
      }
      
      private function goHandler(event:MouseEvent) : void
      {
         var num:int = int(this.actList.indexOf(event.target.parent));
         var index:int = (this.currentPage - 1) * this.onePageNum + num;
         var info:ActDetailInfo = this.mainListInfo[index];
         var mapId:int = int(info.go);
         if(this.mode == 0)//mode=0是活动
         {
            if(mapId != 0)
            {
               if(mapId == 50000)
               {
                  SceneManager.changeScene(SceneType.HOME,ActorManager.actorInfo.id,600,400);
               }
               else if(mapId == 70000)
               {
                  SceneManager.changeScene(SceneType.PLANT,ActorManager.actorInfo.id,600,400);
               }
               else
               {
                  SceneManager.changeScene(SceneType.LOBBY,mapId);
               }
            }
            else
            {
               ModuleManager.toggleModule(URLUtil.getAppModule(info.go),"匹配面板...");
            }
            ModuleManager.closeForInstance(this);
         }
         else if(this.mode == 1)//mode=1是对战
         {
            if(int(info.go) != 0)
            {
               FightManager.startFightWithWild(uint(info.go));
            }
            else
            {
               AlertManager.showAlert("对战码有误");
            }
         }
         else if(this.mode == 2)
         {
            if(info.go)
            {
               this.onFbSet(info.go);
            }
         }
      }
      
      private function changeDay(event:MouseEvent) : void
      {
         if(Boolean(this.currentBtn))
         {
            this.currentBtn.mouseEnabled = true;
         }
         this.currentBtn = event.target as SimpleButton;
         this.currentBtn.mouseEnabled = false;
         if(event.target == this.preDay)
         {
            if(this.mode == 0)
            {
               return;
            }
            --this.mode;
         }
         else
         {
            if(this.mode == 2)
            {
               return;
            }
            ++this.mode;
         }
         if(this.mode == 2)
         {
            _mainUI["timeTxt"].visible = true;
            _mainUI["timeBg"].visible = true;
         }
         else
         {
            _mainUI["timeTxt"].visible = false;
            _mainUI["timeBg"].visible = false;
         }
         this.getDayInfo();
      }
      
      private function getDayInfo() : void
      //本来用作更改日期,现在日期的功能变成不同功能模块的切换了
      {
         this.getDayList(this.mode);
      }
      
      private function getDayList(mode:int) : void
      {
         if(Boolean(this.currentBtn))
         {
            this.currentBtn.mouseEnabled = true;
         }
         this.mainListInfo = ActCalendarConfig.getActList(mode);
         this.modeMC.gotoAndStop(mode+1);
         this.currentPage = 1;
         if(Boolean(this.mainListInfo))
         {
            this.maxPage = Math.ceil(this.mainListInfo.length / 6);
         }
         if(this.maxPage == 0)
         {
            this.maxPage = 1;
         }
         this.updateUI();
      }
      
      private function clearList() : void
      {
         for(var i:int = 0; i < this.onePageNum; i++)
         {
            this.actList[i]["actName"].text = "";
            this.actList[i]["actTime"].text = "";
            this.actList[i]["goBtn"].visible = false;
            this.actList[i]["tipsZone"].removeEventListener(MouseEvent.MOUSE_OVER,this.updateTips);
            TooltipManager.remove(this.actList[i]["tipsZone"]);
            DisplayObjectUtil.removeFromParent(this.overList[i]);
            DisplayObjectUtil.removeFromParent(this.petList[i]);
         }
         this.preDay.filters = [];
         this.nextDay.filters = [];
         if(this.mode == 0)
         {
            ColorFilter.setGrayscale(this.preDay);
         }
         if(this.mode == 2)
         {
            ColorFilter.setGrayscale(this.nextDay);
         }
      }
      
      private function updateUI() : void
      {
         var index:int = 0;
         this.pagesTxt.text = this.currentPage + "/" + this.maxPage;
         this.clearList();
         if(!this.mainListInfo || this.mainListInfo.length == 0)
         {
            return;
         }
         for(var i:int = 0; i < this.onePageNum; i++)
         {
            index = (this.currentPage - 1) * this.onePageNum + i;
            if(index >= this.mainListInfo.length)
            {
               return;
            }
            if(Boolean(this.mainListInfo[index]))
            {
               this.actList[i]["actName"].text = this.mainListInfo[index].name;
               this.actList[i]["actTime"].text = this.mainListInfo[index].timeDes;
               this.actList[i]["goBtn"].visible = true;
               this.actList[i]["tipsZone"].addEventListener(MouseEvent.MOUSE_OVER,this.updateTips);
               TooltipManager.addArtTips(this.actList[i]["tipsZone"],this.artTips);
               if(this.mainListInfo[index].isPet)
               {
                  this.actList[i].addChild(this.petList[i]);
               }
               if(this.mainListInfo[index].willOver)
               {
                  this.actList[i].addChild(this.overList[i]);
               }
            }
         }
      }

      private function onFbSet(fb0Str:String):void
      {
         this.cmdTime = uint(_mainUI["timeTxt"].text);
         this.curTime = 0;
         if(this.cmdTime == 0)
         {
            this.cmdTime = 1;
         }
         var fb0Cmd:int = 0;
         var fb0Param:LittleEndianByteArray = new LittleEndianByteArray();
         var fbbyte:int = 0;
         var fb0Arr:Array;
         fb0Arr = fb0Str.split("");
         for(var i:int =0;i<fb0Arr.length;i++)
         {
            if(fb0Arr[i]==" "||fb0Arr[i]== "\n")
            {
               fb0Arr.splice(i,1);
            }
            if(!((fb0Arr[i]>="0"&&fb0Arr[i]<="9")||(fb0Arr[i]>="A"&&fb0Arr[i]<="F")))
            {
               AlertManager.showAlert("封包输入有误，请检查封包");
               return;
            }
            else if(fb0Arr[i]>="A"&&fb0Arr[i]<="F")
            {
               if(fb0Arr[i]=="A")
               {
                  fb0Arr[i] = 10;
               }
               if(fb0Arr[i]=="B")
               {
                  fb0Arr[i] = 11;
               }
               if(fb0Arr[i]=="C")
               {
                  fb0Arr[i] = 12;
               }
               if(fb0Arr[i]=="D")
               {
                  fb0Arr[i] = 13;
               }
               if(fb0Arr[i]=="E")
               {
                  fb0Arr[i] = 14;
               }
               if(fb0Arr[i]=="F")
               {
                  fb0Arr[i] = 15;
               }
            }
            if(i>=8 && i<=11)
            {
               if(i == 8)
               {
                  fb0Cmd+=int(fb0Arr[i])*16;
               }
               if(i == 9)
               {
                  fb0Cmd+=int(fb0Arr[i]);
               }
               if(i == 10)
               {
                  fb0Cmd+=int(fb0Arr[i])*16*16*16;
               }
               if(i == 11)
               {
                  fb0Cmd+=int(fb0Arr[i])*16*16;
               }
            }
            else if(i>=36)
            {
               if(i%2==0)
               {
                  fbbyte+=int(fb0Arr[i])*16;
               }
               else if(i%2 == 1)
               {
                  fbbyte+=int(fb0Arr[i]);
                  fb0Param.writeByte(uint(fbbyte));
                  fbbyte = 0;
               }
            }
         }
         this.command = Command.getCommand(uint(fb0Cmd));
         this.cmdByte = fb0Param;
         if(this.command == null||fb0Cmd == 0)
         {
            AlertManager.showAlert("协议不存在:" + uint(fb0Cmd));
            this.command = null;
            return;
         }
         this.onFbSend();
      }

      private function onFbSend():void
      {
         Connection.addCommandListener(this.command,this.onFbBack);
         Connection.addErrorHandler(this.command,this.onFbBack);
         Connection.send(this.command,this.cmdByte);
      }

      private function onFbBack(e:MessageEvent):void
      {
         Connection.removeCommandListener(this.command,this.onFbBack);
         Connection.addErrorHandler(this.command,this.onFbBack);
         if(this.command == CommandSet.ITEM_EXCHANGE_1055)
         {
            var data:IDataInput = e.message.getRawDataCopy();
            new SwapInfo(data);
         }
         this.curTime++;
         if(this.curTime < this.cmdTime)
         {
            this.onFbSend();
         }
      }
   }
}

import com.taomee.seer2.app.component.IconDisplayer;
import com.taomee.seer2.app.config.ItemConfig;
import com.taomee.seer2.app.config.info.ActDetailInfo;
import com.taomee.seer2.core.utils.URLUtil;
import com.taomee.seer2.module.app.ActDetailTips;

import flash.display.Loader;
import flash.net.URLRequest;

class ArtActTips extends ActDetailTips
{
   private var actIcon:Loader;
   
   private var rewardIcon:Vector.<IconDisplayer>;
   
   public function ArtActTips()
   {
      super();
      this.actIcon = new Loader();
      this.rewardIcon = new Vector.<IconDisplayer>();
      this.actIcon.x = 12;
      this.actIcon.y = 17;
      this.addChild(this.actIcon);
      for(var i:int = 0; i < 3; i++)
      {
         this.rewardIcon.push(new IconDisplayer());
         this.rewardIcon[i].scaleX = this.rewardIcon[i].scaleY = 0.5;
         this.rewardIcon[i].y = 97;
         this.rewardIcon[i].x = 70 + i * 45;
         this.addChild(this.rewardIcon[i]);
      }
   }
   
   public function setData(info:ActDetailInfo) : void
   {
      var url:String = null;
      var iconIds:Array = [];
      var rewards:Array = info.petReward.concat(info.itemReward);
      var num:int = rewards.length > 3 ? 3 : int(rewards.length);
      this.actName.text = info.name;
      this.des.text = info.detailDes;
      for(var i:int = 0; i < 3; i++)
      {
         this.rewardIcon[i].removeIcon();
         if(i < num)
         {
            if(i < info.petReward.length)
            {
               url = URLUtil.getPetIcon(rewards[i]);
            }
            else
            {
               url = ItemConfig.getItemIconUrl(rewards[i]);
            }
            this.rewardIcon[i].setIconUrl(url);
         }
      }
      url = URLUtil.getActivityNotice("calendar/" + info.iconId);
      this.actIcon.unload();
      this.actIcon.load(new URLRequest(url));
   }
}
