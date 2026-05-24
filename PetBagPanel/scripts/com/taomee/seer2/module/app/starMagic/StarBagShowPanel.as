package com.taomee.seer2.module.app.starMagic
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.component.PetDemoDisplayer;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.net.parser.Parser_1142;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.serverBuffer.ServerBuffer;
   import com.taomee.seer2.app.serverBuffer.ServerBufferManager;
   import com.taomee.seer2.app.starMagic.StarInfo;
   import com.taomee.seer2.app.starMagic.StarMagicManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.IDataInput;
   
   public class StarBagShowPanel extends Sprite
   {
       
      
      private var _mc:MovieClip;
      
      private var _icon:Vector.<StarMagicIcon>;
      
      private var _starMagicTip:StarMagicTip;
      
      private var _mc1:MovieClip;
      
      private var _btnShow:MovieClip;
      
      public function StarBagShowPanel()
      {
         super();
         this._mc = new bagShowPanel();
         this.addChild(this._mc);
         this.initSet();
         this.addListener();
      }
      
      public function setData(info:PetInfo) : void
      {
         this._btnShow.visible = false;
         if(QuestManager.isComplete(10247))
         {
            this._btnShow.visible = false;
            StarMagicManager.TASK = 2;
         }
         else if(QuestManager.isComplete(10246))
         {
            this._btnShow.visible = false;
            StarMagicManager.TASK = 2;
         }
         else if(!QuestManager.isAccepted(10246))
         {
            SwapManager.swapItem(3434,1,function(data:IDataInput):void
            {
               new SwapInfo(data);
               update();
            },null,null);
         }
         else if(!QuestManager.isComplete(10246))
         {
            StarMagicManager.TASK = 1;
            if(!QuestManager.isStepComplete(10246,1))
            {
               this._btnShow.visible = false;
               this.talk1();
            }
            else if(!QuestManager.isStepComplete(10246,2) && Boolean(QuestManager.isStepComplete(10246,1)))
            {
               this._btnShow.visible = false;
               this.step1();
            }
            else if(!QuestManager.isStepComplete(10246,3) && Boolean(QuestManager.isStepComplete(10246,2)))
            {
               ModuleManager.closeForName("PetBagPanel");
               ModuleManager.showModule(URLUtil.getAppModule("StarMagicBagPanel"),"正在打开拔保护面板...");
            }
            else if(QuestManager.isStepComplete(10246,3))
            {
               if(QuestManager.isAccepted(10247))
               {
                  QuestManager.addEventListener("complete",this.onComplete);
                  QuestManager.completeStep(10247,1);
               }
               else
               {
                  QuestManager.addEventListener("accept",this.onAccepted10247);
                  QuestManager.accept(10247);
               }
            }
         }
         StarMagicManager.getPetStar(info.catchTime,this.resetPos,this.resetPos);
         SwapManager.swapItem(3063,1,function(data:IDataInput):void
         {
            ActiveCountManager.requestActiveCountList([204536,204537,204538],function(param1:Parser_1142):void
            {
               _mc["money"].text = int(param1.infoVec[0] + param1.infoVec[1] + param1.infoVec[2]);
            });
         });
      }
      
      private function initSet() : void
      {
         var i:int = 0;
         this._btnShow = this._mc["_btnShow"];
         this._btnShow.mouseChildren = false;
         this._btnShow.mouseEnabled = false;
         this._btnShow.visible = false;
         this._icon = new Vector.<StarMagicIcon>();
         i = 0;
         while(i < 5)
         {
            this._icon[i] = new StarMagicIcon(0,0);
            this._icon[i].x = 5;
            this._mc["pet" + i].addChild(this._icon[i]);
            this._icon[i].addEventListener("mouseOver",this.onMouseOver);
            this._icon[i].addEventListener("mouseOut",this.onMouseOut);
            i++;
         }
         this._starMagicTip = new StarMagicTip();
         this._starMagicTip.mouseEnabled = false;
         this._starMagicTip.mouseChildren = false;
         this._mc.addChild(this._starMagicTip);
         this._starMagicTip.visible = false;
         ServerBufferManager.getServerBuffer(326,function(server:ServerBuffer):void
         {
            var _isPlay:Boolean = Boolean(server.readDataAtPostion(1));
            if(!_isPlay)
            {
               ServerBufferManager.updateServerBuffer(326,1,1);
            }
         });
      }
      
      private function addTip(info:StarInfo) : void
      {
         this._starMagicTip.update(info);
         this._starMagicTip.visible = true;
         this._starMagicTip.x = mouseX - 10;
         this._starMagicTip.y = mouseY + 10;
         this._mc.setChildIndex(this._starMagicTip,this._mc.numChildren - 1);
      }
      
      private function removeTip(info:StarInfo) : void
      {
         this._starMagicTip.visible = false;
      }
      
      private function onMouseOver(e:MouseEvent) : void
      {
         var info:StarInfo = null;
         if(e.target is StarMagicIcon)
         {
            if((e.target as StarMagicIcon).indexId == 0)
            {
               return;
            }
            info = (e.target as StarMagicIcon).getInfo();
            this.addTip(info);
         }
         trace("覆盖ICON");
      }
      
      private function onMouseOut(e:MouseEvent) : void
      {
         trace("覆盖ICON");
         this.removeTip(null);
      }
      
      private function resetPos() : void
      {
         var i:int = 0;
         while(i < StarMagicManager.petNum)
         {
            if(i < StarMagicManager.curPet.length)
            {
               this._icon[i].updateDateInfo(StarMagicManager.curPet[i]);
            }
            else
            {
               this._icon[i].updateDateInfo(null);
            }
            i++;
         }
      }
      
      private function addListener() : void
      {
         this._mc["bagBtn"].addEventListener("click",this.onMouseClick2);
         this._mc["goBag"].addEventListener("click",this.onMouseClick);
      }
      
      private function onMouseClick(e:MouseEvent) : void
      {
         if(StarMagicManager.TASK != 2)
         {
            return;
         }
         ModuleManager.closeForName("PetBagPanel");
         ModuleManager.showModule(URLUtil.getAppModule("StarMagicBagPanel"),"正在打开拔保护面板...");
      }
      
      private function onMouseClick2(e:MouseEvent) : void
      {
         if(StarMagicManager.TASK <= 1 && !QuestManager.isStepComplete(10246,2) && Boolean(QuestManager.isStepComplete(10246,1)))
         {
            this.step1();
            return;
         }
         ModuleManager.closeForName("PetBagPanel");
         ModuleManager.showModule(URLUtil.getAppModule("GetStarMagicPanel"),"正在打开拔保护面板...");
      }
      
      private function update() : void
      {
         ActiveCountManager.requestActiveCountList([205142],function(par:Parser_1142):void
         {
            if(par.infoVec[0] == 0)
            {
               if(QuestManager.isAccepted(10247))
               {
                  QuestManager.addEventListener("complete",onComplete);
                  QuestManager.completeStep(10247,1);
               }
               else
               {
                  QuestManager.addEventListener("accept",onAccepted10247);
                  QuestManager.accept(10247);
               }
            }
            else
            {
               NewTaskZhiYing();
            }
         });
      }
      
      private function NewTaskZhiYing() : void
      {
         if(!QuestManager.isAccepted(10246))
         {
            QuestManager.addEventListener("accept",this.onAccepted);
            QuestManager.accept(10246);
         }
      }
      
      private function onAccepted10247(event:QuestEvent) : void
      {
         QuestManager.removeEventListener("complete",this.onAccepted10247);
         QuestManager.addEventListener("complete",this.onComplete);
         QuestManager.completeStep(10247,1);
      }
      
      private function onAccepted(event:QuestEvent) : void
      {
         QuestManager.removeEventListener("complete",this.onAccepted);
         this.talk1();
      }
      
      private function onComplete(event:QuestEvent) : void
      {
         QuestManager.removeEventListener("complete",this.onComplete);
         StarMagicManager.TASK = 2;
      }
      
      private function onStepComplete(event:QuestEvent) : void
      {
         QuestManager.removeEventListener("complete",this.onComplete);
         if(!QuestManager.isStepComplete(10246,2) && Boolean(QuestManager.isStepComplete(10246,1)))
         {
            this._btnShow.visible = true;
            this._btnShow.mouseChildren = false;
         }
         else if(!QuestManager.isStepComplete(10246,3) && Boolean(QuestManager.isStepComplete(10246,2)))
         {
            SwapManager.swapItem(3435,1,function(data:IDataInput):void
            {
               new SwapInfo(data);
               _mc1.parent.removeChild(_mc1);
               ModuleManager.closeForName("PetBagPanel");
               ModuleManager.showModule(URLUtil.getAppModule("StarMagicBagPanel"),"正在打开拔保护面板...");
            },null,null);
         }
      }
      
      private function onFrame(e:Event) : void
      {
         if(this._mc1.currentFrame == 21)
         {
            this._mc1.gotoAndStop(22);
            this.talk2();
         }
         else if(this._mc1.currentFrame == 59)
         {
            this._mc1.gotoAndStop(60);
            this.talk3();
         }
         else if(this._mc1.currentFrame == 99)
         {
            this._mc1.gotoAndStop(100);
            this.talk4();
         }
         else if(this._mc1.currentFrame == 138)
         {
            this._mc1.gotoAndStop(139);
            this.talk5();
         }
         else if(this._mc1.currentFrame == 229)
         {
            this._mc1.gotoAndStop(230);
            this.talk6();
         }
         else if(this._mc1.currentFrame == 302)
         {
            this._mc1.gotoAndStop(303);
            this.talk7();
         }
         else if(this._mc1.currentFrame == 364)
         {
            this._mc1.gotoAndStop(365);
            QuestManager.addEventListener("stepComplete",this.onStepComplete);
            QuestManager.completeStep(10246,2);
         }
      }
      
      private function onClick(event:MouseEvent) : void
      {
         this._mc1["btn"].removeEventListener("click",this.onClick);
         if(this._mc1.currentFrame == 22)
         {
            this._mc1.play();
         }
         else if(this._mc1.currentFrame == 60)
         {
            this._mc1.play();
         }
         else if(this._mc1.currentFrame == 100)
         {
            this._mc1.play();
         }
         else if(this._mc1.currentFrame == 139)
         {
            this._mc1.play();
         }
         else if(this._mc1.currentFrame == 230)
         {
            this._mc1.play();
         }
         else if(this._mc1.currentFrame == 303)
         {
            this._mc1.play();
         }
      }
      
      private function talk1() : void
      {
         NpcDialog.show(113,"超级NONO",[[0,"这是你第一次使用“星魂”哦！星魂可以使精灵变得更加强大！~"]],[" 星魂？！"],[function():void
         {
            NpcDialog.show(113,"超级NONO",[[0,"现在就让我来帮助你获得第一个珍贵的星魂吧！首先点击“获取星魂”按钮。~"]],["好的！"],[function():void
            {
               QuestManager.addEventListener("stepComplete",onStepComplete);
               QuestManager.completeStep(10246,1);
               StarMagicManager.TASK = 1;
            }]);
         }]);
      }
      
      private function talk2() : void
      {
         NpcDialog.show(113,"超级NONO",[[0,"星魂获取一共有5种等级，等级越高的方式获得的星魂质量也越好！当然，召唤星魂需要大量赛尔豆。快试试最简单的“冥想”获取吧！~"]],[" 好的！"],[function():void
         {
            NpcDialog.hide();
            _mc1["btn"].addEventListener("click",onClick);
         }]);
      }
      
      private function talk3() : void
      {
         NpcDialog.show(113,"超级NONO",[[0,"好诶！成功进阶到了光华阶段了！还获得了一块大碎片——碎片虽然没有实际作用，但是没有实际作用哦！~"]],[" 我去，那不就是占格子的垃圾吗"],[function():void
         {
            NpcDialog.show(113,"超级NONO",[[0,"你说得对，但是官服就是这样的。点击光华继续吧！~"]],["好！"],[function():void
            {
               NpcDialog.hide();
               _mc1["btn"].addEventListener("click",onClick);
            }]);
         }]);
      }
      
      private function talk4() : void
      {
         NpcDialog.show(113,"超级NONO",[[0,"光华进阶到了神启！虽然吊用没有，但是这是教程，还得把流程走完~"]],[" 忍者听了都忍不了了.jpg！"],[function():void
         {
            NpcDialog.show(113,"超级NONO",[[0,"同时你也获得了一个星魂——百均，继续走流程吧。~"]],[" 坏！"],[function():void
            {
               NpcDialog.hide();
               _mc1["btn"].addEventListener("click",onClick);
            }]);
         }]);
      }
      
      private function talk5() : void
      {
         NpcDialog.show(113,"超级NONO",[[0,"看来这次神启的进阶失败了。你应该看出来了，单次召唤很麻烦，而且吊用没有。~"]],[" 你说得对"],[function():void
         {
            NpcDialog.show(113,"超级NONO",[[0,"再来试试一键召唤吧！点击一键召唤就能连续召唤满16个星魂格哦！~"]],[" 这个还挺好"],[function():void
            {
               NpcDialog.hide();
               _mc1["btn"].addEventListener("click",onClick);
            }]);
         }]);
      }
      
      private function talk6() : void
      {
         NpcDialog.show(113,"超级NONO",[[0,"那有什么，改服功能比这还方便！我们先把没用的碎片分解吧！点击出售碎片按钮~"]],["好好"],[function():void
         {
            NpcDialog.hide();
            _mc1["btn"].addEventListener("click",onClick);
         }]);
      }
      
      private function talk7() : void
      {
         NpcDialog.show(113,"超级NONO",[[0,"使用改服功能前记得阅读注意事项。好了，现在把这次获得的星魂都放到星魂背包里，然后进星魂背包来升级星魂吧！"]],["好"],[function():void
         {
            NpcDialog.hide();
            _mc1["btn"].addEventListener("click",onClick);
         }]);
      }
      
      private function step1() : void
      {
         MovieClipUtil.getSwfContent(URLUtil.getQuestFullScreenAnimation("10246_1"),function(mc:MovieClip):void
         {
            ModuleManager.closeForName("PetBagPanel");
            _mc1 = mc;
            _mc1.mouseEnabled = true;
            LayerManager.topLayer.addChild(_mc1);
            _mc1.addEventListener("enterFrame",onFrame);
            _mc1.play();
         },"加载全屏资源");
      }
   }
}
