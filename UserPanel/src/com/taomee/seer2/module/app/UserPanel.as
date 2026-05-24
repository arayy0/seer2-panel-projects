package com.taomee.seer2.module.app
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.data.UserInfo;
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.gameRule.door.core.vo.HomeHonorInfo;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.net.helper.UserInfoParseHelper;
   import com.taomee.seer2.app.processor.activity.decoration.BirthdayInfo;
   import com.taomee.seer2.core.module.Module;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.LifecycleType;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.userPanel.UserPanelDetail;
   import com.taomee.seer2.module.app.userPanel.UserPanelMainUI;
   import com.taomee.seer2.module.app.userPanel.UserPanelNick;
   import com.taomee.seer2.module.app.userPanel.UserPanelSignature;
   import com.taomee.seer2.module.app.userPanel.UserPanelTitle;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class UserPanel extends Module
   {
      
      private var _userPanelDetail:UserPanelDetail;
      
      private var _userPanelNick:UserPanelNick;
      
      private var _userPanelTitle:UserPanelTitle;
      
      private var _userPanelSignature:UserPanelSignature;
      
      private var _userId:uint;
      
      private var _userMediaList:Vector.<IconDisplayer>;
      
      private var _nextMediaBtn:SimpleButton;
      
      private var _prevMediaBtn:SimpleButton;
      
      private var _pageTxt:TextField;
      
      private var _currPageIndex:int;
      
      private var _honorInfo:HomeHonorInfo;
      
      private var _bagBtn:SimpleButton;
      
      public function UserPanel()
      {
         super();
         _lifecycleType = LifecycleType.GLOBAL;
      }
      
      override public function setup() : void
      {
         setMainUI(new UserPanelMainUI());
         this._userPanelDetail = new UserPanelDetail();
         addChild(this._userPanelDetail);
         this._userPanelNick = new UserPanelNick();
         addChild(this._userPanelNick);
         this._userPanelTitle = new UserPanelTitle();
         addChild(this._userPanelTitle);
         this._userPanelSignature = new UserPanelSignature();
         addChild(this._userPanelSignature);
         this._nextMediaBtn = _mainUI["nextMediaBtn"];
         this._prevMediaBtn = _mainUI["prevMediaBtn"];
         this._userMediaList = Vector.<IconDisplayer>([]);
         for(var i:int = 0; i < 10; i++)
         {
            this._userMediaList.push(new IconDisplayer());
            _mainUI["medalMC" + i].addChild(this._userMediaList[i]);
            this._userMediaList[i].scaleX = this._userMediaList[i].scaleY = 0.5;
            this._userMediaList[i].x = 4;
            this._userMediaList[i].y = 4;
            TooltipManager.addCommonTip(this._userMediaList[i],"");
         }
         this._prevMediaBtn.addEventListener(MouseEvent.CLICK,this.onPrev);
         this._nextMediaBtn.addEventListener(MouseEvent.CLICK,this.onNext);
         this._bagBtn = _mainUI["bagBtn"];
         this._bagBtn.addEventListener(MouseEvent.CLICK,this.onBag);
         this._pageTxt = _mainUI["pageTxt"];
      }
      
      private function onBag(event:MouseEvent) : void
      {
         ModuleManager.closeForName("UserPanel");
         ModuleManager.showModule(URLUtil.getAppModule("ItemBagPanel"),"");
      }
      
      private function onPrev(event:MouseEvent) : void
      {
         --this._currPageIndex;
         this.checkPage();
      }
      
      private function onNext(event:MouseEvent) : void
      {
         ++this._currPageIndex;
         this.checkPage();
      }
      
      private function checkPage() : void
      {
         var medalInt:int = 0;
         var max:int = 0;
         DisplayObjectUtil.disableButton(this._prevMediaBtn);
         DisplayObjectUtil.disableButton(this._nextMediaBtn);
         var medalVec:Vector.<int> = Vector.<int>([]);
         for each(medalInt in this._honorInfo.medalVec)
         {
            if(medalInt < 500063 || medalInt > 500074)
            {
               medalVec.push(medalInt);
            }
         }
         max = Math.ceil(medalVec.length / 10);
         if(this._currPageIndex != 0)
         {
            DisplayObjectUtil.enableButton(this._prevMediaBtn);
         }
         if(max != 0)
         {
            if(this._currPageIndex < max - 1)
            {
               DisplayObjectUtil.enableButton(this._nextMediaBtn);
            }
         }
         this._pageTxt.text = this._currPageIndex + 1 + "/" + max;
         var startIndex:uint = uint(this._currPageIndex * 10);
         var endIndex:uint = medalVec.length - (this._currPageIndex + 1) * 10 > 0 ? uint(10 * (this._currPageIndex + 1)) : uint(this._currPageIndex * 10 + (medalVec.length - this._currPageIndex * 10));
         var index:int = 0;
         this.chearIconList();
         for(var i:int = int(startIndex); i < endIndex; i++)
         {
            this._userMediaList[index].setIconUrl(ItemConfig.getItemIconUrl(medalVec[i]));
            TooltipManager.changeTip(this._userMediaList[index],ItemConfig.getItemName(medalVec[i]));
            index++;
         }
      }
      
      private function chearIconList() : void
      {
         var icon:IconDisplayer = null;
         for each(icon in this._userMediaList)
         {
            icon.removeIcon();
            TooltipManager.changeTip(icon,"");
         }
      }
      
      override public function init(data:Object) : void
      {
         this._userId = uint(data);
      }
      
      private function onQueryHomeHonor(evt:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.HOME_GET_HONOR_INFO_1052,this.onQueryHomeHonor);
         this._honorInfo = new HomeHonorInfo(evt.message.getRawData());
         this._currPageIndex = 0;
         this.checkPage();
      }
      
      override public function show() : void
      {
         super.show();
         this.reset();
         this.requestUserInfo();
         Connection.addCommandListener(CommandSet.HOME_GET_HONOR_INFO_1052,this.onQueryHomeHonor);
         Connection.send(CommandSet.HOME_GET_HONOR_INFO_1052,this._userId);
      }
      
      private function reset() : void
      {
         this._userPanelDetail.reset();
         this._userPanelNick.reset();
         this._userPanelTitle.reset();
      }
      
      private function requestUserInfo() : void
      {
         Connection.addCommandListener(CommandSet.USER_GET_DETAIL_INFO_1010,this.onGetDetailInfo);
         Connection.send(CommandSet.USER_GET_DETAIL_INFO_1010,this._userId);
      }
      
      private function onGetDetailInfo(event:MessageEvent) : void
      {
         var bInfo:BirthdayInfo = null;
         var userInfo:UserInfo = null;
         var data:IDataInput = event.message.getRawData();
         var userId:uint = uint(data.readUnsignedInt());
         if(userId == this._userId)
         {
            bInfo = new BirthdayInfo();
            bInfo.isOpen = false;
            if(userId == ActorManager.actorInfo.id)
            {
               if(Boolean(ActorManager.actorInfo) && Boolean(ActorManager.actorInfo.birthdayInfo))
               {
                  bInfo = ActorManager.actorInfo.birthdayInfo;
               }
            }
            else if(ActorManager.getRemoteActor(this._userId) && ActorManager.getRemoteActor(this._userId).getInfo() && Boolean(ActorManager.getRemoteActor(this._userId).getInfo().birthdayInfo))
            {
               bInfo = ActorManager.getRemoteActor(this._userId).getInfo().birthdayInfo;
            }
            Connection.removeCommandListener(CommandSet.USER_GET_DETAIL_INFO_1010,this.onGetDetailInfo);
            ByteArray(data).position = 0;
            userInfo = new UserInfo();
            UserInfoParseHelper.parseUserDetailInfo(userInfo,data);
            userInfo.birthdayInfo = bInfo;
            this._userPanelDetail.setData(userInfo);
            this._userPanelNick.setData(userInfo);
            this._userPanelTitle.setData(userInfo);
            this._userPanelSignature.setData(userInfo);
         }
      }
   }
}

