package com.taomee.seer2.module.app.userPanel
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.data.UserInfo;
   import com.taomee.seer2.app.actor.group.UserGroupManager;
   import com.taomee.seer2.app.actor.group.UserGroupType;
   import com.taomee.seer2.app.actor.preview.ActorPreview;
   import com.taomee.seer2.app.chat.ChatManager;
   import com.taomee.seer2.app.component.TeamLogoDisplayer;
   import com.taomee.seer2.app.component.VipLogoDisplayer;
   import com.taomee.seer2.app.gameRule.ring.RingSupport;
   import com.taomee.seer2.app.manager.MapUserStatusManager;
   import com.taomee.seer2.app.manager.RankManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.net.parser.baseData.RankServerInfo;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.processor.activity.decoration.DecorationManager;
   import com.taomee.seer2.app.team.TeamManager;
   import com.taomee.seer2.app.team.TeamTitle;
   import com.taomee.seer2.app.vip.VipManager;
   import com.taomee.seer2.app.vip.data.VipInfo;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.scene.SceneType;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DateUtil;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.NumberUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.IDataInput;
   
   public class UserPanelDetail extends Sprite
   {
      
      private const vipTipList:Vector.<String> = Vector.<String>(["战斗伤害加成","对战经验加成","捕捉概率翻倍","免费随身仓库","专属绚丽射击","每周每月礼包","免费自动回血","拥有更多好友","星石兑换奖励","炫酷骑宠专享","专属尊贵场景","专属精品游戏","每月充值回馈","天天免费抽奖","免费机会加成","血量恢复五折"]);
      
      private var _container:MovieClip;
      
      private var _userIdTxt:TextField;
      
      private var _createTimeTxt:TextField;
      
      private var _trainerLevelTxt:TextField;
      
      private var _trainerExpMc:MovieClip;
      
      private var _trainerExpTxt:TextField;
      
      private var _trainerExpBar:MovieClip;
      
      private var _trainerIcon:Sprite;
      
      private var _petCountTips:Sprite;
      
      private var _petCountTxt:TextField;
      
      private var _petLevelTips:Sprite;
      
      private var _petLevelTxt:TextField;
      
      private var _sptCountTips:Sprite;
      
      private var _sptCountTxt:TextField;
      
      private var _talkBtn:SimpleButton;
      
      private var _addBuddyBtn:SimpleButton;
      
      private var _removeBuddyBtn:SimpleButton;
      
      private var _homeBtn:SimpleButton;
      
      private var _inviteTeamBtn:SimpleButton;
      
      private var _reportBtn:SimpleButton;
      
      private var _fightBtn:SimpleButton;
      
      private var _passWordBtn:SimpleButton;
      
      private var _actorPreview:ActorPreview;
      
      private var _userInfo:UserInfo;
      
      private var _vipInfo:VipInfo;
      
      private var _teamLogo:TeamLogoDisplayer;
      
      private var _vipLogo:VipLogoDisplayer;
      
      private var _decoration:MovieClip;
      
      private var _yearVipMC:MovieClip;
      
      private var _zuanTxt:TextField;
      
      private var _coinsTxt:TextField;
      
      private var _skyRankTxt:TextField;
      
      private var _petRankTxt:TextField;
      
      private var _vipIconList:Vector.<MovieClip>;
      
      private var _allNumList:Vector.<MovieClip>;
      
      private var _zhandou:MovieClip;
      
      public var fightBtnFlag:Boolean = true;
      
      private const rankList:Array = [132,138,144,150,156,162,168,174,180,186,192,198];
      
      public function UserPanelDetail()
      {
         super();
         this.x = 114;
         this.y = -173;
         this._container = new UserPanelDetailUI();
         addChild(this._container);
         this.createTextFields();
         this.createTextTips();
         this.createButtons();
         this._vipLogo = new VipLogoDisplayer();
         this._vipLogo.x = -70;
         this._vipLogo.y = 245;
         addChild(this._vipLogo);
      }
      
      private function getGrade(info:RankServerInfo) : void
      {
         this.updateAllPower();
         if(this._userInfo.id == ActorManager.actorInfo.id)
         {
            _skyRankTxt.text = (info.currRank + 1).toString();
            if(Boolean(ActorManager.actorInfo.isYearVip))
            {
               this._yearVipMC.visible = true;
            }
            else
            {
               this._yearVipMC.visible = false;
            }
         }
         else
         {
            _skyRankTxt.text = "???";
            this._yearVipMC.visible = false;
         }
         this._zuanTxt.text = ActorManager.actorInfo.moneyCount.toString();
         this._coinsTxt.text = ActorManager.actorInfo.coins.toString();
         RankManager.getActorRank(9,this.getGrade2,this._userInfo.id);
      }
      
      private function getGrade2(info:RankServerInfo) : void
      {
         ActiveCountManager.requestActiveCount(203233,function(type:uint, count:uint):void
         {
            if(count != 0)
            {
               _petRankTxt.text = (info.currRank + 1).toString();
            }
            else
            {
               _petRankTxt.text = "0";
            }
         });
      }
      
      private function get mainUI() : UserPanelDetailUI
      {
         return this._container as UserPanelDetailUI;
      }
      
      private function createTextFields() : void
      {
         this._userIdTxt = this._container["userId"];
         this._createTimeTxt = this._container["createTime"];
         this._trainerLevelTxt = this._container["trainerLevel"];
         this._trainerExpMc = this._container["trainerExpMC"];
         this._trainerExpBar = this._trainerExpMc["trainerExpBar"];
         this._trainerExpTxt = this._trainerExpMc["trainerExpTxt"];
         this._petCountTxt = this._container["petCount"];
         this._petLevelTxt = this._container["petLevel"];
         this._sptCountTxt = this._container["sptCount"];
         this._yearVipMC = this._container["yearVipMC"];
         this._zuanTxt = this._container["zuanTxt"];
         this._coinsTxt = this._container["conisTxt"];
         this._skyRankTxt = this._container["skyRankTxt"];
         this._petRankTxt = this._container["petRankTxt"];
         this._zhandou = this._container["zhandou"];
         this._allNumList = new Vector.<MovieClip>();
         var i:int = 0;
         while(i < 7)
         {
            this._allNumList.push(this._zhandou["allNum" + i]);
            this._allNumList[i].visible = false;
            i++;
         }
         this._vipIconList = Vector.<MovieClip>([]);
         var j:int = 0;
         while(j < 16)
         {
            this._vipIconList.push(this._container["vipIcon" + j]);
            TooltipManager.addCommonTip(this._vipIconList[j],this.vipTipList[j]);
            j++;
         }
      }
      
      private function createDecoration() : void
      {
         if(this._userInfo.birthdayInfo.isOpen)
         {
            if(this._decoration == null)
            {
               this._decoration = new DecorationMCUI();
               this._decoration.scaleX = 1.3;
               this._decoration.scaleY = 1.3;
            }
            this._decoration.visible = true;
            this._decoration.x = 210;
            this._decoration.y = 245;
            addChild(this._decoration);
            TooltipManager.addCommonTip(this._decoration,DecorationManager.getStr(this._userInfo) + "守护者");
            this._decoration.gotoAndStop(DecorationManager.getConstellation(String(this._userInfo.birthdayInfo.month),String(this._userInfo.birthdayInfo.day)) + 2);
         }
         else if(Boolean(this._decoration))
         {
            this._decoration.visible = false;
         }
      }
      
      private function createTextTips() : void
      {
         this._trainerIcon = this._container["trainerIcon"];
         TooltipManager.addCommonTip(this._trainerIcon,"训练师等级");
         this._petCountTips = this._container["petCountTips"];
         TooltipManager.addCommonTip(this._petCountTips,"拥有精灵种类");
         this._petLevelTips = this._container["petLevelTips"];
         TooltipManager.addCommonTip(this._petLevelTips,"精灵最高等级");
         this._sptCountTips = this._container["sptCountTips"];
         TooltipManager.addCommonTip(this._sptCountTips,"SPT击败数");
         this._passWordBtn = this._container["passWordBtn"];
         TooltipManager.addCommonTip(this._passWordBtn,"密码保护");
         this._passWordBtn.addEventListener(MouseEvent.CLICK,this.onPassWord);
      }
      
      private function createButtons() : void
      {
         this._talkBtn = this._container["talk"];
         TooltipManager.addCommonTip(this._talkBtn,"聊天");
         this._addBuddyBtn = this._container["addBuddy"];
         TooltipManager.addCommonTip(this._addBuddyBtn,"添加好友");
         this._removeBuddyBtn = this._container["removeBuddy"];
         TooltipManager.addCommonTip(this._removeBuddyBtn,"删除好友");
         this._homeBtn = this._container["home"];
         TooltipManager.addCommonTip(this._homeBtn,"小屋");
         this._inviteTeamBtn = this._container["inviteTeam"];
         TooltipManager.addCommonTip(this._inviteTeamBtn,"邀请加入战队");
         this._reportBtn = this._container["report"];
         TooltipManager.addCommonTip(this._reportBtn,"举报");
         this._fightBtn = this._container["fight"];
         TooltipManager.addCommonTip(this._fightBtn,"邀请对战");
         this._talkBtn.addEventListener(MouseEvent.CLICK,this.onTalkBtnClick);
         this._addBuddyBtn.addEventListener(MouseEvent.CLICK,this.onAddBuddyBtnClick);
         this._removeBuddyBtn.addEventListener(MouseEvent.CLICK,this.onRemoveBuddyBtnClick);
         this._homeBtn.addEventListener(MouseEvent.CLICK,this.onHomeBtnClick);
         this._inviteTeamBtn.addEventListener(MouseEvent.CLICK,this.onInviteTeamBtnClick);
         this._reportBtn.addEventListener(MouseEvent.CLICK,this.onReportBtnClick);
         this._fightBtn.addEventListener(MouseEvent.CLICK,this.onFightBtnClick);
      }
      
      private function onPassWord(event:MouseEvent) : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("PasswordDefendPanel"),"正在打开面板...");
      }
      
      private function updateAllPower() : void
      {
         var item:PetInfo = null;
         if(this._userInfo.id != ActorManager.actorInfo.id)
         {
            this._zhandou.visible = false;
         }
         else
         {
            this._zhandou.visible = true;
         }
         var petList:Vector.<PetInfo> = PetInfoManager.getAllBagPetInfo();
         var _allPower:int = 0;
         for each(item in petList)
         {
            _allPower += PetInfoManager.getPowerByPetInfo(item);
         }
         this.showAllNumList(_allPower);
      }
      
      private function showAllNumList(val:int) : void
      {
         var numDataList:Vector.<int> = NumberUtil.parseNumberToDigitVec(val);
         var i:int = 0;
         while(i < this._allNumList.length)
         {
            if(i < numDataList.length)
            {
               this._allNumList[i].gotoAndStop(numDataList[i] + 1);
               this._allNumList[i].visible = true;
            }
            else
            {
               this._allNumList[i].visible = false;
            }
            i++;
         }
      }
      
      private function onFightBtnClick(event:MouseEvent) : void
      {
         var onCheckComplete:Function = null;
         var isInFighting:Boolean = false;
         var activitydata:Vector.<uint> = null;
         var list:Vector.<uint> = null;
         var data:LittleEndianByteArray = null;
         var id:uint = 0;
         var clientActData:Array = null;
         onCheckComplete = function(evt:MessageEvent):void
         {
            fightBtnFlag = true;
            Connection.removeCommandListener(CommandSet.CHECK_ONLINE_1023,onCheckComplete);
            var isOnLine:Boolean = false;
            var data:IDataInput = evt.message.getRawData();
            var count:int = int(data.readUnsignedInt());
            var userId:uint = 0;
            var isOnLineData:uint = 0;
            var i:int = 0;
            while(i < count)
            {
               userId = uint(data.readUnsignedInt());
               isOnLineData = uint(data.readUnsignedShort());
               if(userId == _userInfo.id)
               {
                  isOnLine = isOnLineData != 0;
                  break;
               }
               i++;
            }
            if(isOnLine)
            {
               ModuleManager.closeForName("UserPanel");
               AlertManager.showInviteFightAlert(_userInfo.id);
            }
            else
            {
               AlertManager.showAlert("玩家【" + _userInfo.nick + "】当前不在线，不能被邀请对战!");
            }
         };
         if(this.fightBtnFlag)
         {
            if(RingSupport.getInstance().isRinger())
            {
               AlertManager.showAlert("您当前在擂台上不能邀请对战!");
               return;
            }
            if(this._userInfo.id == ActorManager.actorInfo.id)
            {
               AlertManager.showAlert("您不能邀请自己进行对战!");
               return;
            }
            if(this._userInfo.highestPetLevel < 25)
            {
               AlertManager.showAlert("玩家【" + this._userInfo.nick + "】的最高精灵等级低于25级不能被邀请对战!");
               return;
            }
            if(ActorManager.actorInfo.highestPetLevel < 25)
            {
               AlertManager.showAlert("您的最高精灵等级低于25级不能被邀请对战!");
               return;
            }
            isInFighting = Boolean(MapUserStatusManager.chcekUserIsInFight(this._userInfo.id));
            if(isInFighting)
            {
               AlertManager.showAlert("玩家[" + this._userInfo.nick + "]正在战斗中，不能接受邀请！");
            }
            else
            {
               activitydata = ActorManager.getRemoteActor(this._userInfo.id).getInfo().activityData;
               if(SceneManager.active.mapID == 1111 && activitydata && activitydata[4] && activitydata[4] == ActorManager.actorInfo.activityData[4])
               {
                  AlertManager.showAlert("你不能在此场景中跟自己的队友战斗");
                  return;
               }
               if(SceneManager.active.mapID == 984)
               {
                  clientActData = ActorManager.getRemoteActor(this._userInfo.id).getInfo().clientCacheData;
                  if(clientActData[0] != null)
                  {
                     if(!DateUtil.isInHourScope(13,15))
                     {
                        AlertManager.showAlert("当前不在时间活动范围内哦!请在13:00-15:00期间再挑战吧!");
                        return;
                     }
                     if([36,37].indexOf(clientActData[0]) == -1 || [36,37].indexOf(ActorManager.actorInfo.clientCacheData[0]) == -1)
                     {
                        AlertManager.showAlert("此活动需要双方都变身为神秘伊特或是超伊特才可以挑战哦!");
                        return;
                     }
                  }
               }
               list = Vector.<uint>([this._userInfo.id]);
               data = new LittleEndianByteArray();
               data.writeUnsignedInt(list.length);
               for each(id in list)
               {
                  data.writeUnsignedInt(id);
               }
               Connection.addCommandListener(CommandSet.CHECK_ONLINE_1023,onCheckComplete);
               Connection.send(CommandSet.CHECK_ONLINE_1023,data);
               this.fightBtnFlag = false;
            }
         }
      }
      
      private function onTalkBtnClick(evt:MouseEvent) : void
      {
         ChatManager.chatPanelPipe.show(this._userInfo.id,null);
      }
      
      private function onAddBuddyBtnClick(evt:MouseEvent) : void
      {
         AlertManager.showConfirm("是否要添加" + this._userInfo.nick + "为你的好友？",this.onAddBuddyConfirm);
      }
      
      private function onAddBuddyConfirm() : void
      {
         Connection.addCommandListener(CommandSet.BUDDY_ADD_1024,this.onAddedBuddy);
         Connection.send(CommandSet.BUDDY_ADD_1024,this._userInfo.id,LittleEndianByteArray.writeIntergerAsUnsignedByte(0));
      }
      
      private function onAddedBuddy(event:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.BUDDY_ADD_1024,this.onAddedBuddy);
         this._addBuddyBtn.visible = false;
         this._removeBuddyBtn.visible = true;
      }
      
      private function onRemoveBuddyBtnClick(evt:MouseEvent) : void
      {
         AlertManager.showConfirm("你是否要从好友列表中删除" + this._userInfo.nick,this.onRemoveBuddyConfirm);
      }
      
      private function onRemoveBuddyConfirm() : void
      {
         Connection.addCommandListener(CommandSet.BUDDY_REMOVE_1025,this.onRemovedBuddy);
         Connection.send(CommandSet.BUDDY_REMOVE_1025,this._userInfo.id,LittleEndianByteArray.writeIntergerAsUnsignedByte(0));
      }
      
      private function onRemovedBuddy(event:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.BUDDY_REMOVE_1025,this.onRemovedBuddy);
         this._addBuddyBtn.visible = true;
         this._removeBuddyBtn.visible = false;
      }
      
      private function onHomeBtnClick(evt:MouseEvent) : void
      {
         SceneManager.changeScene(SceneType.HOME,this._userInfo.id);
      }
      
      private function onInviteTeamBtnClick(evt:MouseEvent) : void
      {
         if(TeamManager.teamId == 0)
         {
            AlertManager.showAlert("你还没有加入战队");
         }
         else if(TeamManager.teamTitle != TeamTitle.CAPTAIN)
         {
            AlertManager.showAlert("你没有邀请别人加入战队的权限");
         }
         else
         {
            AlertManager.showConfirm("是否要邀请" + this._userInfo.nick + "加入你的战队",function():void
            {
               TeamManager.inviteTeam(_userInfo.id);
            });
         }
      }
      
      private function onReportBtnClick(evt:MouseEvent) : void
      {
         var data:Object = {
            "userID":this._userInfo.id,
            "userNick":this._userInfo.nick
         };
         ModuleManager.toggleModule(URLUtil.getAppModule("ReportUserPanel"),"正在打开举报面板...",data);
      }
      
      public function reset() : void
      {
         this.fightBtnFlag = true;
         this.clearTextFields();
         this.disableAllButtons();
         if(this._actorPreview != null)
         {
            this._actorPreview.dispose();
         }
      }
      
      public function setData(info:UserInfo) : void
      {
         this._userInfo = info;
         this._vipInfo = this._userInfo.vipInfo;
         if(this._userInfo != null)
         {
            this.enableAllButtons();
            RankManager.getActorRank(this.rankList[this.getMonth()],this.getGrade,this._userInfo.id);
            this.updateDisplay();
         }
      }
      
      public function updateDisplay() : void
      {
         var vipIcon:MovieClip = null;
         this._userIdTxt.text = String(this._userInfo.id);
         this._createTimeTxt.text = DateUtil.formatCalendarWithYearMonthDay(this._userInfo.createTime);
         this._trainerLevelTxt.text = String(this._userInfo.trainerLevel);
         this._trainerExpTxt.text = String(this._userInfo.currentLevelExp) + "/" + String(this._userInfo.nextLevelNeedExp);
         this._trainerExpBar.scaleX = this._userInfo.currentLevelExp / this._userInfo.nextLevelNeedExp;
         this._petCountTxt.text = String(this._userInfo.petCount);
         this._petLevelTxt.text = String(this._userInfo.petLevel);
         this._sptCountTxt.text = String(this._userInfo.sptCount);
         this.addPreview();
         this.updateButton();
         this._vipLogo.setVipFlag(this._vipInfo);
         for each(vipIcon in this._vipIconList)
         {
            vipIcon.visible = VipManager.vipInfo.isVip();
         }
         this.createDecoration();
      }
      
      private function addPreview() : void
      {
         this._actorPreview = new ActorPreview();
         this._actorPreview.setData(this._userInfo);
         this._actorPreview.x = 82;
         this._actorPreview.y = 555;
         addChildAt(this._actorPreview,0);
      }
      
      private function updateButton() : void
      {
         if(this.isSelf())
         {
            this.setAllButtonVisible(false);
            return;
         }
         this.setAllButtonVisible(true);
         if(this.isBuddy())
         {
            this._addBuddyBtn.visible = false;
            this._removeBuddyBtn.visible = true;
         }
         else
         {
            this._addBuddyBtn.visible = true;
            this._removeBuddyBtn.visible = false;
         }
      }
      
      private function isBuddy() : Boolean
      {
         return UserGroupManager.containsUser(UserGroupType.BUDDY,this._userInfo.id);
      }
      
      private function isSelf() : Boolean
      {
         return this._userInfo.id == ActorManager.actorInfo.id;
      }
      
      private function clearTextFields() : void
      {
         this._userIdTxt.text = "";
         this._createTimeTxt.text = "";
         this._trainerLevelTxt.text = "";
         this._petCountTxt.text = "";
         this._petLevelTxt.text = "";
         this._sptCountTxt.text = "";
      }
      
      private function setAllButtonVisible(visible:Boolean) : void
      {
         this._talkBtn.visible = visible;
         this._addBuddyBtn.visible = visible;
         this._removeBuddyBtn.visible = visible;
         this._homeBtn.visible = visible;
         this._inviteTeamBtn.visible = visible;
         this._reportBtn.visible = visible;
         this._fightBtn.visible = visible;
         this._passWordBtn.visible = !visible;
      }
      
      private function disableAllButtons() : void
      {
         DisplayObjectUtil.disableButton(this._talkBtn);
         DisplayObjectUtil.disableButton(this._addBuddyBtn);
         DisplayObjectUtil.disableButton(this._removeBuddyBtn);
         DisplayObjectUtil.disableButton(this._homeBtn);
         DisplayObjectUtil.disableButton(this._inviteTeamBtn);
         DisplayObjectUtil.disableButton(this._fightBtn);
         DisplayObjectUtil.disableButton(this._reportBtn);
      }
      
      private function enableAllButtons() : void
      {
         DisplayObjectUtil.enableButton(this._talkBtn);
         DisplayObjectUtil.enableButton(this._addBuddyBtn);
         DisplayObjectUtil.enableButton(this._removeBuddyBtn);
         DisplayObjectUtil.enableButton(this._homeBtn);
         DisplayObjectUtil.enableButton(this._inviteTeamBtn);
         DisplayObjectUtil.enableButton(this._fightBtn);
         DisplayObjectUtil.enableButton(this._reportBtn);
      }
      
      private function getMonth() : int
      {
         var _loc1_:Date = new Date(TimeManager.getPrecisionServerTime() * 1000);
         return _loc1_.month;
      }
   }
}

