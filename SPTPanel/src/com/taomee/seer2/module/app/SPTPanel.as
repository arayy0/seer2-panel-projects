package com.taomee.seer2.module.app
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.gameRule.spt.SPTBossID;
   import com.taomee.seer2.app.gameRule.spt.support.SptBossInfoManager;
   import com.taomee.seer2.core.module.Module;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.LifecycleType;
   import com.taomee.seer2.module.app.sptPanel.*;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import org.taomee.ds.HashMap;
   
   public class SPTPanel extends Module
   {
      
      private static var BOSS_LIST:Array;
      
      private static var SPTINFOS:HashMap = new HashMap();
      
      public static const NO_LEVEL:int = 1;
      
      public static const SCORE_NO_ALLCOMPLETE:int = 2;
      
      public static const SCORE_YES_ALLCOMPLETE:int = 3;
      
      init();
      
      private var _sptBossInfoPanel:SPTBossInfoPanel;
      
      private var _sptBossInfoMap:HashMap;
      
      private var _currentBossID:uint;
      
      public function SPTPanel()
      {
         super();
         _lifecycleType = LifecycleType.GLOBAL;
      }
      
      private static function init() : void
      {
         BOSS_LIST = [SPTBossID.Bulto,SPTBossID.AKanasi,SPTBossID.HuoKe,SPTBossID.MMdi,SPTBossID.MoGu,SPTBossID.ShaZhiHe,SPTBossID.KaniYa,SPTBossID.FeiYaSi,SPTBossID.Ailixisi,SPTBossID.Kadosh,SPTBossID.TeMiTi,SPTBossID.FanErNi,SPTBossID.SaLaiEr];
         SPTINFOS.add(17, new SptInfo(17, SPTBossInfoPanel0, "到达{0}级开启",Vector.<String>(["捕获布鲁托才算胜利","使用布鲁托击败布鲁托\n奖励：重量纹章","出战精灵等级都低于20级的条件下击败BOSS\n奖励：以小搏大勋章"]),311,89,142));
         SPTINFOS.add(31, new SptInfo(31, SPTBossInfoPanel1, "到达{0}级并击败布鲁托后开启",Vector.<String>(["捕获阿卡纳斯才算胜利","使用阿卡纳斯击败阿卡纳斯\n奖励：震击纹章","阿卡纳斯每次使用水纹屏障后的一回合内击破屏障 同一场战斗中累积5次后击败它\n奖励：激流突破勋章"]),154,292,193));
         SPTINFOS.add(38, new SptInfo(38, SPTBossInfoPanel2, "到达{0}级后并击败阿卡纳斯后开启",Vector.<String>(["捕获霍克努尔才算胜利","使用霍克努尔击败霍克努尔\n奖励：怒火纹章","只使用乔尼和大将岩浮出战且在对战中同种精灵不能持续在场超过3回合\n奖励：兄弟情义勋章"]),190,378,270));
         SPTINFOS.add(57, new SptInfo(57, SPTBossInfoPanel3, "到达{0}级并击败霍克努尔后开启",Vector.<String>(["捕获麦麦迪才算胜利","使用麦麦迪击败麦麦迪\n奖励：针灸纹章","在晴天环境下击败麦麦迪\n奖励：真命天子勋章"]),828,342,152));
         SPTINFOS.add(80, new SptInfo(80, SPTBossInfoPanel4, "到达{0}级并击败麦麦迪后开启",Vector.<String>(["捕获巨锤莫古才算胜利","使用巨锤莫古击败巨锤莫古\n奖励：必破纹章","在海市蜃楼的夜晚击败沙皇鸟和巨锤莫古\n奖励：沙地双壁勋章"]),478,199,530));
         SPTINFOS.add(82, new SptInfo(82, SPTBossInfoPanel5, "到达{0}级并击败巨锤莫古后开启",Vector.<String>(["捕获沙皇鸟才算胜利","使用沙皇鸟击败沙皇鸟\n奖励：沙鹤纹章","在海市蜃楼的夜晚击败沙皇鸟和巨锤莫古\n奖励：沙地双壁勋章"]),481,348,370));
         SPTINFOS.add(127,new SptInfo(127,SPTBossInfoPanel6, "到达{0}级并击败沙皇鸟后开启",Vector.<String>(["捕获卡尼娅才算胜利","使用卡尼娅击败卡尼娅\n奖励：安抚纹章","不破坏任何冰柱的情况下击败卡尼娅\n奖励：冰雪妖姬勋章"]),690,315,610));
         SPTINFOS.add(157,new SptInfo(157,SPTBossInfoPanel7, "到达{0}级并击败卡尼娅后开启",Vector.<String>(["捕获菲亚斯才算胜利","使用菲亚斯击败菲亚斯\n奖励：分身纹章","双精灵对战击败菲亚斯与其分身\n奖励：幻影分身勋章"]),654,323,710));
         SPTINFOS.add(215,new SptInfo(215,SPTBossInfoPanel8, "到达{0}级并击败菲亚斯后开启",Vector.<String>(["捕获艾丽希斯才算胜利","使用艾丽希斯击败艾丽希斯\n奖励：光武纹章","35回合内击败艾丽希斯\n奖励：光武守护勋章"]),654,323,790));
         SPTINFOS.add(248,new SptInfo(248,SPTBossInfoPanel9, "到达90级并击败艾丽希斯后开启",Vector.<String>(["捕获卡多斯才算胜利","使用卡多斯击败卡多斯\n奖励：劲风纹章","卡多斯复活一次后击败他\n奖励：风之化身勋章"]),654,323,910));
         SPTINFOS.add(401,new SptInfo(401,SPTBossInfoPanel10,"到达95级并击败卡多斯后开启",Vector.<String>(["捕获特米提才算胜利","使用特米提击败特米提\n奖励：蛾刺纹章","只使用草、冰、超能、光、暗影系精灵出战并击败特米提\n奖励：逆境强者勋章"]),654,323,1220));
         SPTINFOS.add(895,new SptInfo(895,SPTBossInfoPanel11,"到达100级并击败特米提后开启",Vector.<String>(["捕获梵尔尼才算胜利","使用梵尔尼击败梵尔尼\n奖励：源灵纹章","具有2层及以上灵能虚空状态时击败梵尔尼\n奖励：厚积薄发勋章"]),593,431,3830));
         SPTINFOS.add(997,new SptInfo(997,SPTBossInfoPanel12,"到达100级并击败梵尔尼后开启",Vector.<String>(["捕获撒莱尔才算胜利","使用撒莱尔击败撒莱尔\n奖励：威慑纹章","总回合数≥50且全场不使用特殊攻击技能击败撒莱尔\n 奖励：底线游走勋章"]),650,377,3854));
      }
      
      public static function getSptInfo(bossId:uint) : SptInfo
      {
         return SPTINFOS.getValue(bossId);
      }
      
      override public function setup() : void
      {
         setMainUI(new SPTPanelUI());
         this.initTabButton();
      }
      
      private function initTabButton() : void
      {
         (_mainUI["southTabBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK,this.southHandler);
         (_mainUI["northTabBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK,this.southHandler);
         (_mainUI["northTabBtn"] as SimpleButton).mouseEnabled = false;
         (_mainUI["southTabBtn"] as SimpleButton).mouseEnabled = true;
         this.hideNorth(false);
      }
      
      private function southHandler(event:MouseEvent) : void
      {
         if(event.currentTarget == _mainUI["southTabBtn"])
         {
            (_mainUI["southTabBtn"] as SimpleButton).mouseEnabled = false;
            (_mainUI["northTabBtn"] as SimpleButton).mouseEnabled = true;
            _mainUI["tabMcShadow"].x = _mainUI["southTabBtn"].x;
            _mainUI["tabMcShadow"].y = _mainUI["southTabBtn"].y;
            this.hideNorth(true);
         }
         else if(event.currentTarget == _mainUI["northTabBtn"])
         {
            (_mainUI["southTabBtn"] as SimpleButton).mouseEnabled = true;
            (_mainUI["northTabBtn"] as SimpleButton).mouseEnabled = false;
            _mainUI["tabMcShadow"].x = _mainUI["northTabBtn"].x;
            _mainUI["tabMcShadow"].y = _mainUI["northTabBtn"].y;
            this.hideNorth(false);
         }
      }
      
      private function setTabPanelShow(type:String) : void
      {
         if(type == "north")
         {
            (_mainUI["southTabBtn"] as SimpleButton).mouseEnabled = true;
            (_mainUI["northTabBtn"] as SimpleButton).mouseEnabled = false;
            _mainUI["tabMcShadow"].x = _mainUI["northTabBtn"].x;
            _mainUI["tabMcShadow"].y = _mainUI["northTabBtn"].y;
            this.hideNorth(false);
         }
         else if(type == "south")
         {
            (_mainUI["southTabBtn"] as SimpleButton).mouseEnabled = false;
            (_mainUI["northTabBtn"] as SimpleButton).mouseEnabled = true;
            _mainUI["tabMcShadow"].x = _mainUI["southTabBtn"].x;
            _mainUI["tabMcShadow"].y = _mainUI["southTabBtn"].y;
            this.hideNorth(true);
         }
      }
      
      override public function init(data:Object) : void
      {
         var onInitBossInfo:Function = null;
         onInitBossInfo = function(info:SptInfo):void
         {
            var sptBossInfo:SPTBossInfo = new SPTBossInfo();
            sptBossInfo.setInfo(info.bossId,0);
            _sptBossInfoMap.add(sptBossInfo.bossID,sptBossInfo);
         };
         this._sptBossInfoMap = new HashMap();
         SPTINFOS.eachValue(onInitBossInfo);
         SptBossInfoManager.getSptBossInfo(this.onGetBossInfo);
         if(Boolean(data) && Boolean(data.hasOwnProperty("type")))
         {
            this.setTabPanelShow(String(data["type"]));
         }
         else
         {
            this.setTabPanelShow("north");
         }
      }
      
      private function onGetBossInfo(data:LittleEndianByteArray) : void
      {
         var sptBossInfo:SPTBossInfo = null;
         var bossCount:uint = data.readUnsignedInt();
         for(var i:int = 0; i < bossCount; i++)
         {
            sptBossInfo = new SPTBossInfo(data);
            this._sptBossInfoMap.remove(sptBossInfo.bossID);
            this._sptBossInfoMap.add(sptBossInfo.bossID,sptBossInfo);
         }
         this.addBossMouseEventListener();
      }
      
      private function addBossMouseEventListener() : void
      {
         var onAddMouseEvent:Function = null;
         onAddMouseEvent = function(info:SptInfo):void
         {
            var bossID:uint = info.bossId;
            var bossMC:MovieClip = _mainUI["boss" + bossID];
            var labelIndex:uint = uint(getScore(bossID));
            bossMC.gotoAndStop(labelIndex);
            if(bossMC.currentFrame != NO_LEVEL)
            {
               bossMC.buttonMode = true;
               bossMC.addEventListener(MouseEvent.CLICK,onBossMouseClick);
            }
            else
            {
               TooltipManager.addCommonTip(bossMC,info.openTip);
            }
         };
         SPTINFOS.eachValue(onAddMouseEvent);
      }
      
      private function hideNorth(isVisible:Boolean) : void
      {
         var onShowFunction:Function = null;
         onShowFunction = function(info:SptInfo):void
         {
            var bossID:uint = info.bossId;
            var bossMC:MovieClip = _mainUI["boss" + bossID];
            bossMC.visible = !isVisible;
            (_mainUI["southLine"] as MovieClip).visible = !isVisible;
         };
         SPTINFOS.eachValue(onShowFunction);
         (_mainUI["northLine"] as MovieClip).visible = isVisible;
         (_mainUI["boss248"] as MovieClip).visible = isVisible;
         (_mainUI["boss401"] as MovieClip).visible = isVisible;
         (_mainUI["boss895"] as MovieClip).visible = isVisible;
         (_mainUI["boss997"] as MovieClip).visible = isVisible;
      }
      
      private function getScore(bossID:int = 0) : int
      {
         var preBossId:uint = 0;
         var superBossInfo:SPTBossInfo = null;
         var sptBossInfo:SPTBossInfo = this._sptBossInfoMap.getValue(bossID);
         var score:int = sptBossInfo.score;
         var level:uint = ActorManager.actorInfo.highestPetLevel;
         var index:uint = uint(BOSS_LIST.indexOf(bossID));
         if(index != -1 && index != 0)
         {
            preBossId = uint(BOSS_LIST[index - 1]);
            superBossInfo = this._sptBossInfoMap.getValue(preBossId);
            if(superBossInfo.score == 0)
            {
               return NO_LEVEL;
            }
         }
         if(level < sptBossInfo.level)
         {
            return NO_LEVEL;
         }
         if(score != 12)
         {
            return SCORE_NO_ALLCOMPLETE;
         }
         return SCORE_YES_ALLCOMPLETE;
      }
      
      private function removeBossMouseEventListener() : void
      {
         var onRemoveMouseEvent:Function = null;
         onRemoveMouseEvent = function(info:SptInfo):void
         {
            var bossID:uint = info.bossId;
            var bossMC:MovieClip = _mainUI["boss" + bossID];
            bossMC.removeEventListener(MouseEvent.CLICK,onBossMouseClick);
         };
         SPTINFOS.eachValue(onRemoveMouseEvent);
      }
      
      private function onBossMouseClick(event:MouseEvent) : void
      {
         var sptBossInfo:SPTBossInfo = null;
         this.hideBossInfoPanel();
         var bossMC:MovieClip = event.currentTarget as MovieClip;
         var bossName:String = event.currentTarget.name;
         if(this._currentBossID != int(bossName.slice(4,bossName.length)))
         {
            this._currentBossID = int(bossName.slice(4,bossName.length));
            sptBossInfo = this._sptBossInfoMap.getValue(this._currentBossID);
            this.showSPTBossInfoPanel(sptBossInfo,bossMC);
         }
         else
         {
            this._currentBossID = 0;
         }
      }
      
      private function showSPTBossInfoPanel(sptBossInfo:SPTBossInfo = null, bossMC:MovieClip = null) : void
      {
         if(this._sptBossInfoPanel != null)
         {
            this._sptBossInfoPanel.dispose();
            this._sptBossInfoPanel = null;
         }
         this._sptBossInfoPanel = new SPTBossInfoPanel();
         this._sptBossInfoPanel.setInfo(sptBossInfo);
         this._sptBossInfoPanel.setCallback(this.setCurrentBossId);
         addChild(this._sptBossInfoPanel);
      }
      
      public function setCurrentBossId() : void
      {
         this._currentBossID = 0;
      }
      
      private function hideBossInfoPanel() : void
      {
         if(Boolean(this._sptBossInfoPanel))
         {
            DisplayObjectUtil.removeFromParent(this._sptBossInfoPanel);
            this._sptBossInfoPanel = null;
         }
      }
      
      override public function hide() : void
      {
         this.removeBossMouseEventListener();
         if(Boolean(this._sptBossInfoPanel))
         {
            this.hideBossInfoPanel();
         }
         if(Boolean(this._sptBossInfoMap))
         {
            this._sptBossInfoMap.clear();
            this._sptBossInfoMap = null;
         }
         super.hide();
      }
   }
}

