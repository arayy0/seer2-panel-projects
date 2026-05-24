package com.taomee.seer2.module.app.starMagic
{
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.starMagic.StarInfo;
   import com.taomee.seer2.app.starMagic.StarMagicConfig;
import com.taomee.seer2.app.starMagic.StarMagicIconDisplayer;
import com.taomee.seer2.app.starMagic.StarMagicManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.utils.Tick;
   
   public class StarMagicLevelPanel extends Sprite
   {
      private var _mc:MovieClip;
      
      private var starInfo:StarInfo;
      
      private var iconMc:MovieClip;
      
      private var level:int = 0;
      
      private var exp:int = 0;
      
      private var levelexp:int = 0;
      
      private var curIndex:int = 0;
      
      private var func:Function;
      
      private var clickTime:int = 0;
      
      private var type:int;
      
      private var _icon:StarMagicIconDisplayer;
      
      public function StarMagicLevelPanel(fun:Function)
      {
         super();
         this._mc = new starLevelUpPanel();
         this.addChild(this._mc);
         this._mc["choose1"].gotoAndStop(2);
         this._mc["choose2"].gotoAndStop(1);
         this._mc["okBtn"].addEventListener("click",this.onClick);
         this._mc["onceBtn"].addEventListener("click",this.onClick);
         this._mc["up1"].addEventListener("mouseUp",this.onMouseUp);
         this._mc["up2"].addEventListener("mouseUp",this.onMouseUp);
         this._mc["down1"].addEventListener("mouseDown",this.onMouseDown);
         this._mc["down2"].addEventListener("mouseDown",this.onMouseDown);
         this._mc["up1"].addEventListener("mouseDown",this.onMouseDown);
         this._mc["up2"].addEventListener("mouseDown",this.onMouseDown);
         this._mc["down1"].addEventListener("mouseUp",this.onMouseUp);
         this._mc["down2"].addEventListener("mouseUp",this.onMouseUp);
         this._mc["choose1"].addEventListener("click",this.onClick);
         this._mc["choose2"].addEventListener("click",this.onClick);
         this._mc["closeBtn"].addEventListener("click",this.onClick);
         this.addEventListener("enterFrame",this.onEnter);
         this.func = fun;
         this._mc["newShow6"].mouseEnabled = false;
         this._mc["newShow6"].mouseChildren = false;
         if(StarMagicManager.newTaskStop == 5)
         {
            this._mc["newShow6"].visible = true;
         }
         else
         {
            this._mc["newShow6"].visible = false;
         }
      }
      
      private function onEnter(t:Event) : void
      {
         if(uint(this._mc["input2"].text) >= StarMagicManager.starMoney)
         {
            this._mc["input2"].text = StarMagicManager.starMoney;
         }
      }
      
      private function timeUP(t:int) : void
      {
         ++this.clickTime;
         if(this.clickTime < 10)
         {
            return;
         }
         if(this.type == 1)
         {
            ++this.level;
            if(this.level >= 6)
            {
               this.level = 6;
            }
            this._mc["input1"].text = "" + this.level;
         }
         else if(this.type == 2)
         {
            this.exp = uint(this._mc["input2"].text);
            ++this.exp;
            if(this.exp >= StarMagicManager.starMoney)
            {
               this.exp = StarMagicManager.starMoney;
            }
            this._mc["input2"].text = "" + this.exp;
         }
         else if(this.type == 3)
         {
            --this.level;
            if(Boolean(this.starInfo))
            {
               if(this.level <= this.starInfo.level)
               {
                  this.level = this.starInfo.level;
                  this._mc["input1"].text = "" + this.level;
               }
            }
         }
         else if(this.type == 4)
         {
            this.exp = uint(this._mc["input2"].text);
            --this.exp;
            if(this.exp <= 0)
            {
               this.exp = 0;
            }
            this._mc["input2"].text = "" + this.exp;
         }
      }
      
      private function onMouseDown(e:MouseEvent) : void
      {
         ++this.clickTime;
         if(e.target == this._mc["up1"])
         {
            this.type = 1;
         }
         else if(e.target == this._mc["up2"])
         {
            this.type = 2;
            Tick.instance.addRender(this.timeUP,60);
         }
         else if(e.target == this._mc["down1"])
         {
            this.type = 3;
         }
         else if(e.target == this._mc["down2"])
         {
            this.type = 4;
            Tick.instance.addRender(this.timeUP,60);
         }
      }
      
      private function onMouseUp(e:MouseEvent) : void
      {
         Tick.instance.removeRender(this.timeUP);
         if(this.clickTime > 10)
         {
            this.clickTime = -1;
            return;
         }
         if(e.target == this._mc["up1"])
         {
            ++this.level;
            if(this.level >= 6)
            {
               this.level = 6;
            }
            this._mc["input1"].text = "" + this.level;
            this.updateLevel();
         }
         else if(e.target == this._mc["up2"])
         {
            ++this.exp;
            if(this.exp >= StarMagicManager.starMoney)
            {
               this.exp = StarMagicManager.starMoney;
            }
            this._mc["input2"].text = "" + this.exp;
         }
         else if(e.target == this._mc["down1"])
         {
            --this.level;
            if(Boolean(this.starInfo))
            {
               if(this.level <= this.starInfo.level + 1)
               {
                  this.level = this.starInfo.level + 1;
                  this._mc["input1"].text = "" + this.level;
               }
            }
            this.updateLevel();
         }
         else if(e.target == this._mc["down2"])
         {
            --this.exp;
            if(this.exp <= 0)
            {
               this.exp = 0;
            }
            this._mc["input2"].text = "" + this.exp;
         }
      }
      
      private function onClick(e:MouseEvent) : void
      {
         if(e.target == this._mc["okBtn"])
         {
            if(StarMagicManager.newTaskStop == 5)
            {
               if(this.curIndex == 1)
               {
                  if(this.exp < StarMagicManager.starMoney)
                  {
                     ServerMessager.addMessage("请升到第二级!");
                     return;
                  }
               }
               else if(this.levelexp > StarMagicManager.starMoney)
               {
                  ServerMessager.addMessage("请升到第二级!");
                  return;
               }
            }
            if(this.curIndex != 1)
            {
               if(this.levelexp > StarMagicManager.starMoney)
               {
                  ServerMessager.addMessage("经验不够!");
                  return;
               }
               if(this.levelexp > StarMagicManager.starMoney)
               {
                  this.levelexp = StarMagicManager.starMoney;
               }
               StarMagicManager.levelUpStar(this.levelexp,this.starInfo.pos,this.starInfo.id,this.func,this.func);
               this.visible = false;
               return;
            }
            if(this.exp > StarMagicManager.starMoney)
            {
               ServerMessager.addMessage("经验不够!");
               return;
            }
            if(this.exp > StarMagicManager.starMoney)
            {
               this.exp = StarMagicManager.starMoney;
            }
            this.exp = uint(this._mc["input2"].text);
            StarMagicManager.levelUpStar(this.exp,this.starInfo.pos,this.starInfo.id,this.func,this.func);
            this.visible = false;
         }
         else if(e.target == this._mc["onceBtn"])
         {
            this.level = 6;
            this._mc["input1"].text = "" + this.level;
            this.curIndex = 0;
            this._mc["choose1"].gotoAndStop(2);
            this._mc["choose2"].gotoAndStop(1);
            this.updateLevel();
            if(this.levelexp > StarMagicManager.starMoney)
            {
               ServerMessager.addMessage("经验不够!");
               this.level = 2;
               this._mc["input1"].text = "" + this.level;
               this.updateLevel();
               return;
            }
            StarMagicManager.levelUpStar(this.levelexp,this.starInfo.pos,this.starInfo.id,this.func,this.func);
            this.visible = false;
         }
         else if(e.target == this._mc["choose1"])
         {
            this.curIndex = 0;
            this._mc["choose1"].gotoAndStop(2);
            this._mc["choose2"].gotoAndStop(1);
         }
         else if(e.target == this._mc["choose2"])
         {
            this.curIndex = 1;
            this._mc["choose1"].gotoAndStop(1);
            this._mc["choose2"].gotoAndStop(2);
         }
         else if(e.target == this._mc["closeBtn"])
         {
            this.visible = false;
         }
      }
      
      public function update(info:StarInfo) : void
      {
         this.starInfo = info;
         if(this.starInfo == null)
         {
            return;
         }
         if(Boolean(this._icon))
         {
            this._mc["iconMc"].removeChild(this._icon);
            this._icon.x = 5;
            this._icon = null;
         }
         this._icon = new StarMagicIconDisplayer(this.starInfo.buffId,this.starInfo.type);
         this._icon.updateDateInfo(this.starInfo);
         this._icon.scaleX = this._icon.scaleY = 44 / 60;
         this._icon.x = 5;
         this._mc["iconMc"].addChild(this._icon);
         this._mc["levelTip"].text = "LV." + this.starInfo.level;
         this.level = this.starInfo.level + 1;
         this.exp = 0;
         this.levelexp = 0;
         this._mc["name2"].text = "" + StarMagicConfig.getInfo(this.starInfo.buffId,this.starInfo.type).nameT;
         this._mc["name1"].text = "" + StarMagicConfig.getInfo(this.starInfo.buffId,this.starInfo.type).nameT;
         if(StarMagicConfig.getInfo(this.starInfo.buffId,this.starInfo.type).type == 0)
         {
            this._mc["name2"].textColor = 16777215;
            this._mc["name1"].textColor = 16777215;
         }
         else if(StarMagicConfig.getInfo(this.starInfo.buffId,this.starInfo.type).type == 1)
         {
            this._mc["name2"].textColor = 65433;
            this._mc["name1"].textColor = 65433;
         }
         else if(StarMagicConfig.getInfo(this.starInfo.buffId,this.starInfo.type).type == 2)
         {
            this._mc["name2"].textColor = 776186;
            this._mc["name1"].textColor = 776186;
         }
         else if(StarMagicConfig.getInfo(this.starInfo.buffId,this.starInfo.type).type == 3)
         {
            this._mc["name2"].textColor = 14105826;
            this._mc["name1"].textColor = 14105826;
         }
         this._mc["expText"].text = "" + this.starInfo.exp + "/" + StarMagicConfig.getInfo(this.starInfo.buffId,this.starInfo.type).nextExpArr[this.starInfo.level];
         this._mc["xiliText"].text = "" + StarMagicManager.starMoney;
         this._mc["input1"].text = "" + (this.starInfo.level + 1);
         this._mc["input2"].text = "0";
         this._mc["input2"].restrict = "0-9";
         this.updateLevel();
      }
      
      private function updateLevel() : void
      {
         if(this.curIndex == 0)
         {
            this.levelexp = StarMagicConfig.getInfo(this.starInfo.buffId,this.starInfo.type).nextExpArr[this.level - 1];
            this.levelexp -= this.starInfo.exp;
            this._mc["willText"].text = "升到" + this.level + " 级需要 " + this.levelexp + " 经验";
            if(this.levelexp < StarMagicManager.starMoney)
            {
               this._mc["willText"].textColor = 776186;
            }
            else
            {
               this._mc["willText"].textColor = 16711680;
            }
         }
      }
      
      public function disposs() : void
      {
         this._mc["okBtn"].removeEventListener("click",this.onClick);
         this._mc["onceBtn"].removeEventListener("click",this.onClick);
         this._mc["up1"].removeEventListener("click",this.onClick);
         this._mc["up2"].removeEventListener("click",this.onClick);
         this._mc["down1"].removeEventListener("click",this.onClick);
         this._mc["down2"].removeEventListener("click",this.onClick);
         this._mc["choose1"].removeEventListener("click",this.onClick);
         this._mc["choose2"].removeEventListener("click",this.onClick);
      }
   }
}

