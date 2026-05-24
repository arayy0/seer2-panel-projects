package com.taomee.seer2.module.app.starMagic
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.component.PetDemoDisplayer;
   import com.taomee.seer2.app.dialog.NpcDialog;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.net.parser.Parser_1142;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.starMagic.StarInfo;
   import com.taomee.seer2.app.starMagic.StarMagicConfig;
   import com.taomee.seer2.app.starMagic.StarMagicManager;
import com.taomee.seer2.app.starMagic.StarMagicIconDisplayer;
   import com.taomee.seer2.app.vip.VipManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.quest.events.QuestEvent;
import com.taomee.seer2.core.utils.DisplayObjectUtil;
import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.core.TopModule;

import flash.display.DisplayObject;
import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.taomee.manager.EventManager;
   import org.taomee.utils.Tick;
   
   public class StarMagicBagPanel extends TopModule
   {
      private static var FOR_MONEY:int = 204494;
      
      private static var STOP:uint = 1;
      
      private static var YIJIANHECHEN:uint = 2;
      
      private static var MOVE:uint = 3;
      
      private var petPos:Vector.<MovieClip>;
      
      private var bagPos:Vector.<MovieClip>;
      
      private var depotPos:Vector.<MovieClip>;
      
      private var _icon:Vector.<StarMagicIconDisplayer>;
      
      private var _yiJianBtn:SimpleButton;
      
      private var _getStarHunBtn:SimpleButton;
      
      private var _tuJianBtn:SimpleButton;
      
      private var _bagState:int;
      
      private var currentIndex:int;
      
      private var _petBtn:MovieClip;
      
      private var _bagBtn:MovieClip;
      
      private var _depotBtn:MovieClip;
      
      private var _currentPet:PetInfo;
      
      private var _currentIndex:int = -1;
      
      private var _stagState:int = 0;
      
      private var _starMagicLevelPanel:StarMagicLevelPanel;
      
      private var _starMagicTip:StarMagicTip;
      
      private var _demoDisplayer:PetDemoDisplayer;
      
      private var _curPage:int = 0;
      
      private var _curMaxPage:int = 0;
      
      private var _curPetIndex:int = 0;
      
      private var _petIcon:Vector.<IconDisplayer>;
      
      private var _allPet:Vector.<PetInfo> = new Vector.<PetInfo>();
      
      private var vipNum:int;
      
      private var _starMagicPicPanel:StarMagicPicPanel;
      
      private var change:Boolean = true;
      
      private var btnShowMc:Array = [];
      
      private var NewTaskpos:int = -1;
      
      private var haveFinishTaskStep:int;

      private var _warningMc:MovieClip;
      
      public function StarMagicBagPanel()
      {
         super();
         _lifecycleType = "global";
      }
      
      override public function setup() : void
      {
         setMainUI(new StarMagicBagUI());
         this.initSet();
      }
      
      override public function init(data:Object) : void
      {
      }
      
      override protected function onClose(event:MouseEvent) : void
      {
         super.onClose(event);
         ModuleManager.showAppModule("PetBagPanel");
      }
      
      override public function show() : void
      {
         super.show();
         this._petBtn.visible = false;
         this._depotBtn.visible = false;
         this.updatePetPage();
         this.showPet();
         this.showCurPet();
         this.getCurPetStar();
         this.addEvent();
         this.getTempStar();
         StatisticsManager.newSendNovice("2014系统","星魂","星魂背包打开");
         DisplayObjectUtil.removeFromParent(_mainUI["warningMc"]);
         _mainUI["zhezhuMc"].visible = false;
         this._starMagicTip.visible = false;
         if(Boolean(this._starMagicPicPanel))
         {
            this._starMagicPicPanel.visible = false;
         }
         this._bagState = STOP;
         if(VipManager.vipInfo.isVip())
         {
            this.vipNum = StarMagicManager.bagNum + VipManager.vipInfo.level;
            if(this.vipNum >= 5)
            {
               this.vipNum = 5;
            }
         }
         else
         {
            this.vipNum = 0;
         }
         this.hideShowBtn();
         this.newTask();
      }
      
      private function addShowBtn() : void
      {
      }
      
      override public function hide() : void
      {
         super.hide();
      }
      
      private function showMc() : void
      {
         var i:int = 0;
         for(i = 1; i < 5; )
         {
            _mainUI["show" + i].gotoAndStop(1);
            i++;
         }
      }
      
      private function addEvent() : void
      {
         var i:int = 0;
         for(i = 0; i < this._icon.length; )
         {
            this._icon[i].index = i;
            this._icon[i].mouseChildren = false;
            this._icon[i].addEventListener("mouseDown",this.onMouseDown);
            this._icon[i].addEventListener("mouseUp",this.onMouseUp);
            this._icon[i].addEventListener("mouseOver",this.onMouseOver);
            this._icon[i].addEventListener("mouseOut",this.onMouseOut);
            _mainUI.addEventListener("click",this.onMouseClick);
            i++;
         }
         for(i = 0; i < 2; )
         {
            this._petBtn["btn" + i].addEventListener("click",this.onMouseClick);
            i++;
         }
         for(i = 0; i < 3; )
         {
            z;
            this._bagBtn["btn" + i].addEventListener("click",this.onMouseClick);
            i++;
         }
         for(i = 0; i < 4; )
         {
            this._depotBtn["btn" + i].addEventListener("click",this.onMouseClick);
            i++;
         }
         this._tuJianBtn.addEventListener("click",this.onMouseClick);
         _mainUI["getStarHun"].addEventListener("click",this.onMouseClick);
         _mainUI["yiJianBtn"].addEventListener("click",this.onMouseClick);
         _mainUI["pageDown"].addEventListener("click",this.onMouseClick);
         _mainUI["pageUp"].addEventListener("click",this.onMouseClick);
         this._warningMc["canclBtn"].addEventListener("click",this.onMouseClick);
         this._warningMc["okBtn"].addEventListener("click",this.onMouseClick);
         this._warningMc["closeBtn"].addEventListener("click",this.onMouseClick);
         for(i = 0; i < 6; )
         {
            this._petIcon[i].addEventListener("click",this.onMouseClick);
            i++;
         }
      }
      
      private function onYijianHechen() : void
      {
         this.getTempStar();
      }
      
      private function onPetMoveStar() : void
      {
         this.getCurPetStar();
         this.getTempStar();
      }
      
      private function checkPet(info:StarInfo) : Boolean
      {
         return StarMagicManager.checkStar(StarMagicConfig.getInfo(info.buffId,info.type).buffSwf);
      }
      
      private function moveStar(tag:int, num:int, info:StarInfo, pos:int = 0) : Boolean
      {
         var vip:int = 0;
         if(!this.change)
         {
            return false;
         }
         if(tag == 4 || tag == 6)
         {
            if(this.checkPet(info))
            {
               ServerMessager.addMessage("已有同类星魂!");
               return false;
            }
            if(this.getCurPetStarNum() >= 5)
            {
               ServerMessager.addMessage("宠物星魂已满!");
               return false;
            }
            if(this._allPet[this._curPetIndex].isInStorageBag)
            {
               vip = 2;
            }
            else
            {
               vip = 1;
            }
            this._bagState = MOVE;
            StarMagicManager.movePetStar(tag,1,info,this.onPetMoveStar,this.onPetMoveStar,this._allPet[this._curPetIndex].catchTime,vip,this.getCurPetStarNum() + 1);
         }
         else if(tag == 2)
         {
            if(StarMagicManager.getBagStarNum() >= StarMagicManager.bagNum + this.vipNum)
            {
               ServerMessager.addMessage("星魂收藏已满!");
               return false;
            }
            this._bagState = MOVE;
            StarMagicManager.moveStar(tag,1,info,this.onMove,this.onMove);
         }
         else if(tag == 3)
         {
            if(StarMagicManager.getDepotStarNum() >= StarMagicManager.depotNum)
            {
               ServerMessager.addMessage("星魂背包已满!");
               return false;
            }
            this._bagState = MOVE;
            StarMagicManager.moveStar(tag,1,info,this.onMove,this.onMove);
         }
         else if(tag == 5)
         {
            if(StarMagicManager.getDepotStarNum() >= StarMagicManager.depotNum)
            {
               ServerMessager.addMessage("星魂背包已满!");
               return false;
            }
            if(this._allPet[this._curPetIndex].isInStorageBag)
            {
               vip = 2;
            }
            else
            {
               vip = 1;
            }
            this._bagState = MOVE;
            StarMagicManager.moveStar(tag,1,info,this.onPetMoveStar,this.onPetMoveStar,vip,pos);
         }
         else if(tag == 7)
         {
            if(StarMagicManager.getBagStarNum() >= StarMagicManager.bagNum + this.vipNum)
            {
               ServerMessager.addMessage("星魂收藏已满!");
               return false;
            }
            if(this._allPet[this._curPetIndex].isInStorageBag)
            {
               vip = 2;
            }
            else
            {
               vip = 1;
            }
            this._bagState = MOVE;
            StarMagicManager.moveStar(tag,1,info,this.onPetMoveStar,this.onPetMoveStar,vip,pos);
         }
         return true;
      }
      
      private function addPicPanel() : void
      {
         if(!this._starMagicPicPanel)
         {
            this._starMagicPicPanel = new StarMagicPicPanel();
            this._starMagicPicPanel.x = 300;
            this._starMagicPicPanel.y = 110;
            this.addChild(this._starMagicPicPanel);
         }
         else
         {
            this._starMagicPicPanel.visible = true;
            this._starMagicPicPanel.resetInfo();
         }
      }
      
      private function onMouseClick(e:MouseEvent) : void
      {
         var vip:int = 0;
         var i:int = 0;
         trace("点击ICON");
         var curPetIndex:int = this.getCurPetStarNum() + 1;
         if(this._bagState != STOP)
         {
            return;
         }
         if(!(e.target is StarMagicIconDisplayer))
         {
            this._petBtn.visible = false;
            this._bagBtn.visible = false;
            this._depotBtn.visible = false;
         }
         if(e.target == _mainUI["yiJianBtn"])
         {
            if(StarMagicManager.newTaskStop != 4 && StarMagicManager.newTaskStop != 0)
            {
               return;
            }
            if(StarMagicManager.newTaskStop == 4)
            {
               this.haveFinishTaskStep = 4;
            }
            if(StarMagicManager.getDepotStarNum() <= 0)
            {
               return;
            }
            if(StarMagicManager.checkOnceStar(3))
            {
               this.addChild(this._warningMc);
               return;
            }
            this._bagState = YIJIANHECHEN;
            StarMagicManager.sellStar(2,2,2,this.onYijianHechen,this.onYijianHechen);
         }
         else if(e.target is SimpleButton)
         {
            if(e.target == _mainUI["pageUp"])
            {
               if(this._curPage <= 0)
               {
                  return;
               }
               --this._curPage;
               this.showPet();
               return;
            }
            if(e.target == this._warningMc["canclBtn"])
            {
               DisplayObjectUtil.removeFromParent(this._warningMc);
            }
            else if(e.target == this._warningMc["okBtn"])
            {
               this._bagState = YIJIANHECHEN;
               StarMagicManager.sellStar(2,2,2,this.onYijianHechen,this.onYijianHechen);
               DisplayObjectUtil.removeFromParent(this._warningMc);
            }
            else if(e.target == this._warningMc["closeBtn"])
            {
               DisplayObjectUtil.removeFromParent(this._warningMc);
            }
            else
            {
               if(e.target == _mainUI["getStarHun"])
               {
                  if(StarMagicManager.newTaskStop != 0)
                  {
                     return;
                  }
                  ModuleManager.closeForName("StarMagicBagPanel");
                  ModuleManager.showModule(URLUtil.getAppModule("GetStarMagicPanel"),"正在打开拔保护熊游戏面板...");
                  return;
               }
               if(e.target == _mainUI["tuJianBtn"])
               {
                  StatisticsManager.newSendNovice("2014系统","星魂","星魂图鉴打开");
                  this.addPicPanel();
                  return;
               }
               if(e.target == _mainUI["pageDown"])
               {
                  ++this._curPage;
                  if(this._curPage >= this._curMaxPage - 1)
                  {
                     this._curPage = this._curMaxPage - 1;
                  }
                  this.showPet();
                  return;
               }
            }
            i = 0;
            while(i < 2)
            {
               if(e.target == this._petBtn["btn" + i])
               {
                  if(StarMagicManager.newTaskStop != 0)
                  {
                     return;
                  }
                  if(i == 0)
                  {
                     this.addLevelUpPanel();
                  }
                  else if(i == 1)
                  {
                     this.moveStar(7,1,this._icon[this.currentIndex].info,this._icon[this.currentIndex].index + 1);
                  }
                  break;
               }
               i++;
            }
            i = 0;
            while(i < 3)
            {
               if(e.target == this._bagBtn["btn" + i])
               {
                  if(i == 0)
                  {
                     if(StarMagicManager.newTaskStop != 0 && StarMagicManager.newTaskStop != 5)
                     {
                        return;
                     }
                     if(StarMagicManager.newTaskStop == 5)
                     {
                        this.haveFinishTaskStep = 5;
                     }
                     this.addLevelUpPanel();
                  }
                  else if(i == 1)
                  {
                     if(StarMagicManager.newTaskStop != 0 && StarMagicManager.newTaskStop != 7)
                     {
                        return;
                     }
                     if(StarMagicManager.newTaskStop == 7)
                     {
                        this.haveFinishTaskStep = 7;
                     }
                     this.moveStar(6,1,this._icon[this.currentIndex].info);
                  }
                  else if(i == 2)
                  {
                     if(StarMagicManager.newTaskStop != 0)
                     {
                        return;
                     }
                     this.moveStar(3,1,this._icon[this.currentIndex].info);
                  }
                  break;
               }
               i++;
            }
            i = 0;
            while(i < 4)
            {
               if(e.target == this._depotBtn["btn" + i])
               {
                  if(i == 0)
                  {
                     if(StarMagicManager.newTaskStop != 0)
                     {
                        return;
                     }
                     this.addLevelUpPanel();
                  }
                  else if(i == 1)
                  {
                     if(StarMagicManager.newTaskStop != 0)
                     {
                        return;
                     }
                     this.moveStar(4,1,this._icon[this.currentIndex].info);
                  }
                  else if(i == 2)
                  {
                     if(StarMagicManager.newTaskStop != 0)
                     {
                        return;
                     }
                     this._bagState = MOVE;
                     StarMagicManager.sellStar(this._icon[this.currentIndex].info.pos,this._icon[this.currentIndex].info.id,1,this.onYijianHechen,this.onYijianHechen);
                  }
                  else if(i == 3)
                  {
                     if(StarMagicManager.newTaskStop != 0 && StarMagicManager.newTaskStop != 2)
                     {
                        return;
                     }
                     if(StarMagicManager.newTaskStop == 2)
                     {
                        this.haveFinishTaskStep = 2;
                     }
                     this.moveStar(2,1,this._icon[this.currentIndex].info);
                  }
                  break;
               }
               i++;
            }
         }
         else
         {
            i = 0;
            while(i < this._petIcon.length)
            {
               if(e.target == this._petIcon[i])
               {
                  this._curPetIndex = this._curPage * 6 + i;
                  this.change = false;
                  _mainUI["chooseShow"].x = _mainUI["pethead" + i].x - 1;
                  _mainUI["chooseShow"].y = _mainUI["pethead" + i].y - 1;
                  this.getCurPetStar();
                  this.showCurPet();
                  break;
               }
               i++;
            }
         }
      }
      
      private function onLevel() : void
      {
         this.getTempStar();
         this.getCurPetStar();
      }
      
      private function addLevelUpPanel() : void
      {
         var info:StarInfo = this._icon[this._currentIndex].info;
         if(Boolean(this._starMagicLevelPanel))
         {
            this.removeChild(this._starMagicLevelPanel);
            this._starMagicLevelPanel == null;
         }
         this._starMagicLevelPanel = new StarMagicLevelPanel(this.onLevel);
         this._starMagicLevelPanel.update(info);
         this.addChild(this._starMagicLevelPanel);
      }
      
      private function onMouseOver(e:MouseEvent) : void
      {
         var info:StarInfo = null;
         if(e.target is StarMagicIconDisplayer)
         {
            if((e.target as StarMagicIconDisplayer).indexId == 0)
            {
               return;
            }
            this._currentIndex = (e.target as StarMagicIconDisplayer).index;
            info = (e.target as StarMagicIconDisplayer).info;
            this.addTip(info);
         }
         trace("覆盖ICON");
      }
      
      private function onMouseOut(e:MouseEvent) : void
      {
         trace("覆盖ICON");
         this.removeTip(null);
      }
      
      private function onMouseDown(e:MouseEvent) : void
      {
         if(this._bagState != STOP)
         {
            return;
         }
         if((e.target as StarMagicIconDisplayer).indexId == 0)
         {
            return;
         }
         Tick.instance.addRender(this.stagTime,20);
         if(this._stagState > 15)
         {
            (e.target as StarMagicIconDisplayer).removeEventListener("click",this.onMouseClick);
         }
         if(StarMagicManager.newTaskStop == 0)
         {
            (e.target as StarMagicIconDisplayer).startDrag();
            (e.target as StarMagicIconDisplayer).setmoveState(1);
         }
         this.currentIndex = (e.target as StarMagicIconDisplayer).index;
      }
      
      private function onMouseUp(e:MouseEvent) : void
      {
         var i:int = 0;
         if(this._bagState != STOP)
         {
            return;
         }
         Tick.instance.removeRender(this.stagTime);
         (e.target as StarMagicIconDisplayer).stopDrag();
         (e.target as StarMagicIconDisplayer).setmoveState(2);
         if(this._stagState < 3)
         {
            for(i = 0; i < this._icon.length; )
            {
               if(e.target == this._icon[i])
               {
                  if(this._icon[i].indexId == 0)
                  {
                     return;
                  }
                  if(i < 5)
                  {
                     if(StarMagicManager.newTaskStop != 0)
                     {
                        return;
                     }
                     this._petBtn.x = this._icon[i].x;
                     this._petBtn.y = this._icon[i].y;
                     this._petBtn.visible = true;
                     if(this._icon[i].info.level >= StarMagicConfig.getInfo(this._icon[i].info.buffId,this._icon[i].info.type).maxLevel)
                     {
                        this._petBtn["btn0"].visible = false;
                     }
                     else
                     {
                        this._petBtn["btn0"].visible = true;
                     }
                     _mainUI.setChildIndex(this._petBtn,_mainUI.numChildren - 1);
                  }
                  else if(i < 17)
                  {
                     if(StarMagicManager.newTaskStop != 0 && StarMagicManager.newTaskStop != 5 && StarMagicManager.newTaskStop != 7)
                     {
                        return;
                     }
                     if(StarMagicManager.newTaskStop == 5)
                     {
                        if(i != 5 + this.NewTaskpos)
                        {
                           return;
                        }
                     }
                     else if(StarMagicManager.newTaskStop == 7)
                     {
                        if(i != 5 + this.NewTaskpos)
                        {
                           return;
                        }
                     }
                     this._bagBtn.x = this._icon[i].x;
                     this._bagBtn.y = this._icon[i].y;
                     this._bagBtn.visible = true;
                     if(this._icon[i].info.level >= StarMagicConfig.getInfo(this._icon[i].info.buffId,this._icon[i].info.type).maxLevel)
                     {
                        this._bagBtn["btn0"].visible = false;
                     }
                     else
                     {
                        this._bagBtn["btn0"].visible = true;
                     }
                     _mainUI.setChildIndex(this._bagBtn,_mainUI.numChildren - 1);
                  }
                  else if(i < 35)
                  {
                     if(StarMagicManager.newTaskStop != 0 && StarMagicManager.newTaskStop != 2)
                     {
                        return;
                     }
                     if(StarMagicManager.newTaskStop == 2)
                     {
                        if(i != 17 + this.NewTaskpos)
                        {
                           return;
                        }
                        this.haveFinishTaskStep = 2;
                     }
                     this._depotBtn.x = this._icon[i].x - 30;
                     this._depotBtn.y = this._icon[i].y - 20;
                     if(this._icon[i].info.level >= StarMagicConfig.getInfo(this._icon[i].info.buffId,this._icon[i].info.type).maxLevel)
                     {
                        this._depotBtn["btn0"].visible = false;
                     }
                     else
                     {
                        this._depotBtn["btn0"].visible = true;
                     }
                     this._depotBtn.visible = true;
                     _mainUI.setChildIndex(this._depotBtn,_mainUI.numChildren - 1);
                  }
                  break;
               }
               i++;
            }
         }
         else
         {
            if(StarMagicManager.newTaskStop != 0)
            {
               this._stagState = 0;
               return;
            }
            this.checkHisTextObject();
         }
         this._stagState = 0;
      }
      
      private function initSet() : void
      {
         var i:int = 0;
         this._demoDisplayer = new PetDemoDisplayer();
         _mainUI["pet"].addChild(this._demoDisplayer);
         this._demoDisplayer.x = 112;
         this._demoDisplayer.y = 124;
         this._starMagicTip = new StarMagicTip();
         this._starMagicTip.mouseEnabled = false;
         this._starMagicTip.mouseChildren = false;
         _mainUI.addChild(this._starMagicTip);
         this._starMagicTip.visible = false;
         this._yiJianBtn = _mainUI["yiJianBtn"];
         this._getStarHunBtn = _mainUI["getStarHunBtn"];
         this._tuJianBtn = _mainUI["tuJianBtn"];
         this._petBtn = _mainUI["petBtn"];
         this._bagBtn = _mainUI["bagBtn"];
         this._depotBtn = _mainUI["depotBtn"];
         this._warningMc = _mainUI["warningMc"];
         this._icon = new Vector.<StarMagicIconDisplayer>();
         this.petPos = new Vector.<MovieClip>();
         this.bagPos = new Vector.<MovieClip>();
         this.depotPos = new Vector.<MovieClip>();
         this._petIcon = new Vector.<IconDisplayer>();
         for(i = 0; i < 6; )
         {
            this._petIcon[i] = new IconDisplayer();
            _mainUI["pethead" + i].addChild(this._petIcon[i]);
            this._petIcon[i].scaleX = 1.08;
            this._petIcon[i].scaleY = 1.08;
            i++;
         }
         for(i = 0; i < 5; )
         {
            this.petPos.push(_mainUI["pet" + i]);
            i++;
         }
         for(i = 0; i < 12; )
         {
            this.bagPos.push(_mainUI["bag" + i]);
            i++;
         }
         for(i = 0; i < 18; )
         {
            this.depotPos.push(_mainUI["depot" + i]);
            i++;
         }
         for(i = 0; i < 35; )
         {
            this._icon[i] = new StarMagicIconDisplayer(0,0);
            this._icon[i].x = this._icon[i].y = 0;
            this._icon[i].scaleX = this._icon[i].scaleY = 44 / 60;
            _mainUI.addChild(this._icon[i]);
            i++;
         }
         this.resetPos();
         this.btnShowMc.push(_mainUI["newShow1"]);
         this.btnShowMc.push(this._depotBtn["newShow2"]);
         this.btnShowMc.push(_mainUI["newShow3"]);
         this.btnShowMc.push(_mainUI["newShow4"]);
         this.btnShowMc.push(this._bagBtn["newShow5"]);
         this.btnShowMc.push(this._bagBtn["newShow6"]);
         for(i = 0; i < this.btnShowMc.length; )
         {
            this.btnShowMc[i].mouseChildren = false;
            this.btnShowMc[i].mouseEnabled = false;
            i++;
         }
         trace("xxx");
      }
      
      private function resetPos() : void
      {
         var i:int = 0;
         for(i = 0; i < 5; )
         {
            this._icon[i].x = this.petPos[i].x;
            this._icon[i].y = this.petPos[i].y;
            this._icon[i].setmoveState(0);
            i++;
         }
         for(i = 5; i < 17; )
         {
            this._icon[i].x = this.bagPos[i - 5].x;
            this._icon[i].y = this.bagPos[i - 5].y;
            this._icon[i].setmoveState(0);
            i++;
         }
         for(i = 17; i < 35; )
         {
            this._icon[i].x = this.depotPos[i - 17].x;
            this._icon[i].y = this.depotPos[i - 17].y;
            this._icon[i].setmoveState(0);
            i++;
         }
         this._petBtn.visible = false;
         this._bagBtn.visible = false;
         this._depotBtn.visible = false;
         this._bagState = STOP;
      }
      
      private function addTip(info:StarInfo) : void
      {
         this._starMagicTip.update(info);
         this._starMagicTip.visible = true;
         this._starMagicTip.x = mouseX - 10;
         this._starMagicTip.y = mouseY + 10;
         _mainUI.setChildIndex(this._starMagicTip,_mainUI.numChildren - 1);
      }
      
      private function removeTip(info:StarInfo) : void
      {
         this._starMagicTip.visible = false;
      }
      
      private function getTempStar() : void
      {
         StarMagicManager.getTemporaryStar(this.update,this.update);
      }
      
      private function getCurPetStar() : void
      {
         StarMagicManager.getPetStar(this._allPet[this._curPetIndex].catchTime,this.updatePetIcon,this.updatePetIcon);
      }
      
      private function getCurPetStarNum() : int
      {
         return StarMagicManager.curPet.length;
      }
      
      private function update() : void
      {
         var i:int;
         var getedVal:int = 0;
         this.updateBagIcon();
         this.updateDepotIcon();
         ActiveCountManager.requestActiveCountList([FOR_MONEY],function(par:Parser_1142):void
         {
            getedVal = par.infoVec[0];
            StarMagicManager.starMoney = getedVal;
            _mainUI["starmoney"].text = "" + StarMagicManager.starMoney;
         });
         for(i = 0; i < 5; )
         {
            if(i < VipManager.vipInfo.level)
            {
               _mainUI["vip" + i].visible = false;
            }
            else
            {
               _mainUI["vip" + i].visible = true;
            }
            i++;
         }
         this._bagState = STOP;
         this.resetPos();
         if(this.haveFinishTaskStep != 0)
         {
            if(StarMagicManager.newTaskStop == 2)
            {
               QuestManager.addEventListener("stepComplete",this.onStepComplete);
               QuestManager.completeStep(10246,4);
               StarMagicManager.TASK = 1;
            }
            else if(StarMagicManager.newTaskStop == 4)
            {
               QuestManager.addEventListener("stepComplete",this.onStepComplete);
               QuestManager.completeStep(10246,6);
               StarMagicManager.TASK = 1;
            }
            else if(StarMagicManager.newTaskStop == 5)
            {
               QuestManager.addEventListener("stepComplete",this.onStepComplete);
               QuestManager.completeStep(10246,7);
               StarMagicManager.TASK = 1;
            }
            else if(StarMagicManager.newTaskStop == 7)
            {
               QuestManager.addEventListener("stepComplete",this.onStepComplete);
               StarMagicManager.TASK = 2;
               QuestManager.completeStep(10246,8);
            }
         }
         this.showState();
      }
      
      private function updatePetIcon() : void
      {
         var i:int = 0;
         var def:StarInfo = null;
         this.change = true;
         for(i = 0; i < StarMagicManager.petNum; )
         {
            if(i < StarMagicManager.curPet.length)
            {
               def = StarMagicConfig.getInfo(StarMagicManager.curPet[i].buffId,StarMagicManager.curPet[i].type);
               this._icon[i].updateDateInfo(StarMagicManager.curPet[i]);
               switch(StarMagicManager.curPet[i].buffSwf)
               {
                  case 0:
                  case 1:
                  case 2:
                  case 3:
                  case 4:
                  case 8:
                  case 10:
                     _mainUI["starText" + i].text = def.nameT + ":LV." + StarMagicManager.curPet[i].level + " 使精灵 " + def.effdesc + " 增加" + def.effvalue[0][StarMagicManager.curPet[i].level];
                     break;
                  case 5:
                  case 6:
                  case 7:
                  case 9:
                  case 100:
                  case 101:
                  case 102:
                  case 103:
                     _mainUI["starText" + i].text = def.nameT + ":LV." + StarMagicManager.curPet[i].level + " 使精灵 " + def.effdesc + " 增加" + def.effvalue[0][StarMagicManager.curPet[i].level] + "%";
               }
               if(StarMagicManager.curPet[i].type == 0)
               {
                  _mainUI["starText" + i].textColor = 16777215;
               }
               else if(StarMagicManager.curPet[i].type == 1)
               {
                  _mainUI["starText" + i].textColor = 65433;
               }
               else if(StarMagicManager.curPet[i].type == 2)
               {
                  _mainUI["starText" + i].textColor = 776186;
               }
               else if(StarMagicManager.curPet[i].type == 3)
               {
                  _mainUI["starText" + i].textColor = 14105826;
               }
               else if(StarMagicManager.curPet[i].type == 4)
               {
                  _mainUI["starText" + i].textColor = 16751360;
               }
            }
            else
            {
               this._icon[i].updateDateInfo(null);
               _mainUI["starText" + i].text = "";
            }
            i++;
         }
         PetInfoManager.updateStarPetInfo(this._allPet[this._curPetIndex].catchTime,StarMagicManager.curPet);
         EventManager.dispatchEvent(new Event("PetUpdate"));
      }
      
      private function updateBagIcon() : void
      {
         var i:int = 0;
         for(i = 0; i < StarMagicManager.bagNum + 5; )
         {
            if(i < StarMagicManager.bagStarInfo.length)
            {
               this._icon[i + 5].updateDateInfo(StarMagicManager.bagStarInfo[i]);
            }
            else
            {
               this._icon[i + 5].updateDateInfo(null);
            }
            i++;
         }
      }
      
      private function updateDepotIcon() : void
      {
         var i:int = 0;
         for(i = 0; i < StarMagicManager.depotNum; )
         {
            if(i < StarMagicManager.depotStarInfo.length)
            {
               this._icon[i + 17].updateDateInfo(StarMagicManager.depotStarInfo[i]);
            }
            else
            {
               this._icon[i + 17].updateDateInfo(null);
            }
            i++;
         }
      }
      
      private function checkHisTextObject(t:int = 0) : void
      {
         var i:int = 0;
         var j:int = 0;
         if(this._bagState != STOP)
         {
            return;
         }
         var haveHit:Boolean = false;
         for(j = 0; j < this._icon.length; )
         {
            if(j != this.currentIndex)
            {
               if(this._icon[this.currentIndex].icon.hitTestObject(this._icon[j].icon))
               {
                  this._icon[this.currentIndex].setmoveState(0);
                  this.handleIcon(this._icon[this.currentIndex],this._icon[j]);
                  haveHit = true;
                  break;
               }
            }
            j++;
         }
         if(!haveHit)
         {
            this.update();
         }
      }
      
      private function handleIcon(sIcon:StarMagicIconDisplayer, tIcon:StarMagicIconDisplayer) : void
      {
         var curPetIndex:int = 0;
         var vip:int = 0;
         var i:int = 0;
         var type:int = 0;
         if(this._allPet[this._curPetIndex].isInStorageBag)
         {
            vip = 2;
         }
         else
         {
            vip = 1;
         }
         for(curPetIndex = this.getCurPetStarNum() + 1; i < this._icon.length; )
         {
            if(tIcon == this._icon[i] && sIcon.info.pos != tIcon.info.pos)
            {
               if(sIcon.info.pos == 4 && tIcon.info.pos == 2)
               {
                  type = 5;
               }
               else if(sIcon.info.pos == 4 && tIcon.info.pos == 3)
               {
                  type = 7;
               }
               else if(sIcon.info.pos == 4 && tIcon.info.pos == 0)
               {
                  if(i < 5)
                  {
                     this.update();
                     return;
                  }
                  if(i < 17)
                  {
                     type = 7;
                  }
                  else if(i < 35)
                  {
                     type = 5;
                  }
               }
               else if(sIcon.info.pos == 2 && tIcon.info.pos == 3)
               {
                  type = 2;
               }
               else if(sIcon.info.pos == 2 && tIcon.info.pos == 4)
               {
                  type = 4;
               }
               else if(sIcon.info.pos == 2 && tIcon.info.pos == 0)
               {
                  if(i < 5)
                  {
                     type = 4;
                  }
                  else if(i < 17)
                  {
                     type = 2;
                  }
                  else if(i < 35)
                  {
                     this.update();
                     return;
                  }
               }
               else if(sIcon.info.pos == 3 && tIcon.info.pos == 2)
               {
                  type = 3;
               }
               else if(sIcon.info.pos == 3 && tIcon.info.pos == 4)
               {
                  type = 6;
               }
               else if(sIcon.info.pos == 3 && tIcon.info.pos == 0)
               {
                  if(i < 5)
                  {
                     type = 6;
                  }
                  else
                  {
                     if(i < 17)
                     {
                        this.update();
                        return;
                     }
                     if(i < 35)
                     {
                        type = 3;
                     }
                  }
               }
               if(this._bagState == STOP)
               {
                  this._bagState = MOVE;
                  trace("移动" + type + "ICON");
                  if(type == 0)
                  {
                     this.update();
                     return;
                  }
                  if(!this.moveStar(type,1,sIcon.info,sIcon.index + 1))
                  {
                     this.update();
                     return;
                  }
                  return;
               }
               this.update();
               return;
            }
            i++;
         }
         this.update();
      }
      
      private function onMove() : void
      {
         this.getTempStar();
      }
      
      private function stagTime(k:int) : void
      {
         ++this._stagState;
         trace("数字" + this._stagState);
      }
      
      private function updatePetPage() : void
      {
         var i:int = 0;
         while(this._allPet.length)
         {
            this._allPet.pop();
         }
         for(i = 0; i < PetInfoManager.getTotalBagPetInfo().length; )
         {
            this._allPet.push(PetInfoManager.getTotalBagPetInfo()[i]);
            i++;
         }
         var len:int = int(this._allPet.length);
         this._curMaxPage = len / 6;
         if(len % 6 > 0)
         {
            ++this._curMaxPage;
         }
      }
      
      private function showCurPet() : void
      {
         var _info:PetInfo = this._allPet[this._curPetIndex];
         this._demoDisplayer.newSetUrl(URLUtil.getPetDemo(_info.resourceId),218,204);
      }
      
      private function showPet() : void
      {
         var i:int = 0;
         var _info:PetInfo = null;
         var url:String = null;
         for(i = 0; i < 6; )
         {
            if(i + this._curPage * 6 < this._allPet.length)
            {
               _info = this._allPet[i + this._curPage * 6];
               url = String(URLUtil.getPetIcon(_info.resourceId));
               this._petIcon[i].setIconUrl(url);
            }
            else
            {
               this._petIcon[i].dispose();
            }
            i++;
         }
      }
      
      private function onComplete(event:QuestEvent) : void
      {
         StarMagicManager.newTaskStop = 0;
         StarMagicManager.TASK = 2;
         this.hideShowBtn();
      }
      
      private function onStepComplete(event:QuestEvent) : void
      {
         if(!QuestManager.isStepComplete(10246,3) && Boolean(QuestManager.isStepComplete(10246,2)))
         {
            StarMagicManager.TASK = 1;
            StarMagicManager.newTaskStop = 1;
            this.talk1();
         }
         else if(!QuestManager.isStepComplete(10246,4) && Boolean(QuestManager.isStepComplete(10246,3)))
         {
            StarMagicManager.TASK = 1;
            StarMagicManager.newTaskStop = 2;
         }
         else if(!QuestManager.isStepComplete(10246,5) && Boolean(QuestManager.isStepComplete(10246,4)))
         {
            StarMagicManager.TASK = 1;
            StarMagicManager.newTaskStop = 3;
            this.talk2();
         }
         else if(!QuestManager.isStepComplete(10246,6) && Boolean(QuestManager.isStepComplete(10246,5)))
         {
            StarMagicManager.TASK = 1;
            StarMagicManager.newTaskStop = 4;
         }
         else if(!QuestManager.isStepComplete(10246,7) && Boolean(QuestManager.isStepComplete(10246,6)))
         {
            StarMagicManager.TASK = 1;
            StarMagicManager.newTaskStop = 5;
         }
         else if(!QuestManager.isStepComplete(10246,8) && Boolean(QuestManager.isStepComplete(10246,7)))
         {
            StarMagicManager.TASK = 1;
            StarMagicManager.newTaskStop = 6;
            this.talk3();
         }
         else if(QuestManager.isStepComplete(10246,8))
         {
            this.talk4();
         }
         this.showState();
         this.haveFinishTaskStep = 0;
      }
      
      private function onAccepted10247(event:QuestEvent) : void
      {
         QuestManager.removeEventListener("complete",this.onAccepted10247);
         QuestManager.addEventListener("complete",this.onComplete);
         QuestManager.completeStep(10247,1);
      }
      
      private function newTask() : void
      {
         if(QuestManager.isComplete(10247))
         {
            this.hideShowBtn();
            StarMagicManager.TASK = 2;
            return;
         }
         if(QuestManager.isComplete(10246))
         {
            this.hideShowBtn();
            StarMagicManager.TASK = 2;
            return;
         }
         if(!QuestManager.isStepComplete(10246,3) && Boolean(QuestManager.isStepComplete(10246,2)))
         {
            StarMagicManager.TASK = 1;
            StarMagicManager.newTaskStop = 1;
            this.talk1();
         }
         else if(!QuestManager.isStepComplete(10246,4) && Boolean(QuestManager.isStepComplete(10246,3)))
         {
            StarMagicManager.TASK = 1;
            StarMagicManager.newTaskStop = 2;
         }
         else if(!QuestManager.isStepComplete(10246,5) && Boolean(QuestManager.isStepComplete(10246,4)))
         {
            StarMagicManager.TASK = 1;
            StarMagicManager.newTaskStop = 3;
            this.talk2();
         }
         else if(!QuestManager.isStepComplete(10246,6) && Boolean(QuestManager.isStepComplete(10246,5)))
         {
            StarMagicManager.TASK = 1;
            StarMagicManager.newTaskStop = 4;
         }
         else if(!QuestManager.isStepComplete(10246,7) && Boolean(QuestManager.isStepComplete(10246,6)))
         {
            StarMagicManager.TASK = 1;
            StarMagicManager.newTaskStop = 5;
            this.talk2();
         }
         else if(!QuestManager.isStepComplete(10246,8) && Boolean(QuestManager.isStepComplete(10246,7)))
         {
            StarMagicManager.TASK = 1;
            StarMagicManager.newTaskStop = 6;
            this.talk3();
         }
         this.showState();
      }
      
      private function hideShowBtn() : void
      {
         var i:int = 0;
         for(i = 0; i < this.btnShowMc.length; )
         {
            this.btnShowMc[i].visible = false;
            this.btnShowMc[i].mouseChildren = false;
            i++;
         }
      }
      
      private function showState() : void
      {
         var i:int = 0;
         this.hideShowBtn();
         if(StarMagicManager.newTaskStop == 2)
         {
            for(i = 0; i < StarMagicManager.depotStarInfo.length; )
            {
               trace("星魂" + StarMagicManager.depotStarInfo[i].buffId);
               if(StarMagicManager.depotStarInfo[i].buffId == 11116)
               {
                  this.NewTaskpos = i;
                  this.btnShowMc[0].x = this.depotPos[i].x;
                  this.btnShowMc[0].y = this.depotPos[i].y;
                  this.btnShowMc[0].visible = true;
                  this.btnShowMc[1].visible = true;
                  break;
               }
               i++;
            }
         }
         else if(StarMagicManager.newTaskStop == 3 || StarMagicManager.newTaskStop == 4)
         {
            this.btnShowMc[2].visible = true;
         }
         else if(StarMagicManager.newTaskStop == 5)
         {
            for(i = 0; i < StarMagicManager.bagStarInfo.length; )
            {
               if(StarMagicManager.bagStarInfo[i].buffId == 11116)
               {
                  this.NewTaskpos = i;
                  this.btnShowMc[3].x = this.bagPos[i].x;
                  this.btnShowMc[3].y = this.bagPos[i].y;
                  this.btnShowMc[3].visible = true;
                  this.btnShowMc[4].visible = true;
                  break;
               }
               i++;
            }
         }
         else if(StarMagicManager.newTaskStop == 6)
         {
            for(i = 0; i < StarMagicManager.bagStarInfo.length; )
            {
               if(StarMagicManager.bagStarInfo[i].buffId == 11116)
               {
                  this.NewTaskpos = i;
                  this.btnShowMc[3].x = this.bagPos[i].x;
                  this.btnShowMc[3].y = this.bagPos[i].y;
                  this.btnShowMc[3].visible = true;
                  this.btnShowMc[5].visible = true;
                  break;
               }
               i++;
            }
         }
         else if(StarMagicManager.newTaskStop == 7)
         {
            for(i = 0; i < StarMagicManager.bagStarInfo.length; )
            {
               if(StarMagicManager.bagStarInfo[i].buffId == 11116)
               {
                  this.NewTaskpos = i;
                  this.btnShowMc[3].x = this.bagPos[i].x;
                  this.btnShowMc[3].y = this.bagPos[i].y;
                  this.btnShowMc[3].visible = true;
                  this.btnShowMc[5].visible = true;
                  break;
               }
               i++;
            }
         }
      }
      
      private function talk1() : void
      {
         NpcDialog.show(113,"超级NONO",[[0,"现在我们把获得的“神灵”星魂收藏起来吧！之后来对它进行升级！~"]],[" 收藏？"],[function():void
         {
            QuestManager.addEventListener("stepComplete",onStepComplete);
            QuestManager.completeStep(10246,3);
            StarMagicManager.TASK = 1;
         }]);
      }
      
      private function talk2() : void
      {
         NpcDialog.show(113,"超级NONO",[[0,"这样就收藏成功咯！现在把背包里其他的星魂都变成“神灵”的经验吧！点击“一键合成”将星魂变成经验！然后升级“神灵”吧！~"]],[" 好的！"],[function():void
         {
            QuestManager.addEventListener("stepComplete",onStepComplete);
            QuestManager.completeStep(10246,5);
            StarMagicManager.TASK = 1;
         }]);
      }
      
      private function talk3() : void
      {
         NpcDialog.show(113,"超级NONO",[[0,"好！最后一步！把升级好的“神灵”星魂装备在精灵身上吧！~"]],[" 好的！"],[function():void
         {
            StarMagicManager.newTaskStop = 7;
            StarMagicManager.TASK = 1;
         }]);
      }
      
      private function talk4() : void
      {
         NpcDialog.show(113,"超级NONO",[[0,"现在精灵就装备有星魂咯！作为第一次你的表现还是很不错的！这个神灵星魂就送你咯！~"]],["   谢谢！"],[function():void
         {
            NpcDialog.show(113,"超级NONO",[[0,"哈哈，希望你以后能获得更稀有、更强大的星魂！~"]],["   好的！"],[function():void
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
            }]);
         }]);
      }
   }
}

