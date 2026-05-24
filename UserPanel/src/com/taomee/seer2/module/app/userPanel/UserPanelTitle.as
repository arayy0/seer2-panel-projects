package com.taomee.seer2.module.app.userPanel
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.data.UserInfo;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.config.item.MedalItemDefinition;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.inventory.item.MedalItem;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class UserPanelTitle extends Sprite
   {
      
      private var _container:MovieClip;
      
      private var _titleBackGround:Sprite;
      
      private var _titleTxt:TextField;
      
      private var _selectMc:MovieClip;
      
      private var _titleList:UserPanelTitleList;
      
      private var _userInfo:UserInfo;
      
      private var _isSelf:Boolean;
      
      public function UserPanelTitle()
      {
         super();
         this.initialize();
      }
      
      private function initialize() : void
      {
         this.createChildren();
         this.initEventListener();
      }
      
      private function createChildren() : void
      {
         this.x = 123;
         this.y = 72;
         this._container = new UserPanelTitleUI();
         addChild(this._container);
         this._titleBackGround = this._container["titleBg"];
         this._titleTxt = this._container["title"];
         this._selectMc = this._container["select"];
         this.createTitleList();
      }
      
      private function createTitleList() : void
      {
         this._titleList = new UserPanelTitleList();
         this._titleList.y = 24;
         addChild(this._titleList);
      }
      
      private function initEventListener() : void
      {
         this._selectMc.buttonMode = true;
         this._selectMc.addEventListener(MouseEvent.CLICK,this.onSelectClick);
         this._titleList.addEventListener(UserPanelTitleList.USER_TITLE_CHANGE,this.onTitleChange);
      }
      
      private function onSelectClick(evt:MouseEvent) : void
      {
         this._titleList.toggle();
      }
      
      private function onTitleChange(evt:Event) : void
      {
         this._titleList.hide();
         var selectedId:int = this._titleList.selectedMedalId;
         Connection.addCommandListener(CommandSet.USER_CHANGE_MEDAL_1008,this.onUserChangedMedal);
         Connection.send(CommandSet.USER_CHANGE_MEDAL_1008,selectedId);
      }
      
      private function onUserChangedMedal(event:MessageEvent) : void
      {
         var medalId:uint = 0;
         var rawData:ByteArray = event.message.getRawData();
         rawData.position = 0;
         var userId:uint = rawData.readUnsignedInt();
         var myUserInfo:UserInfo = ActorManager.actorInfo;
         if(userId == myUserInfo.id)
         {
            Connection.removeCommandListener(CommandSet.USER_CHANGE_MEDAL_1008,this.onUserChangedMedal);
            medalId = rawData.readUnsignedInt();
            myUserInfo.medalId = medalId;
            this.setData(myUserInfo);
         }
      }
      
      public function reset() : void
      {
         this._titleList.hide();
         this._titleBackGround.visible = false;
         this._selectMc.visible = false;
         this._titleTxt.text = "";
      }
      
      public function setData(info:UserInfo) : void
      {
         this._userInfo = info;
         this._isSelf = this._userInfo.id == ActorManager.actorInfo.id;
         ItemManager.requestItemList(this.onGetMedalList);
      }
      
      private function onGetMedalList() : void
      {
         var slectedMedalId:int = int(this._userInfo.medalId);
         this._titleList.setData(ItemManager.getMedalVec(),slectedMedalId);
         this.updateDisplay();
      }
      
      private function updateDisplay() : void
      {
         var itemDefinition:MedalItemDefinition = null;
         this._titleList.hide();
         if(this._isSelf && this.hasTitle())
         {
            this._titleBackGround.visible = true;
            this._selectMc.visible = true;
         }
         else
         {
            this._titleBackGround.visible = false;
            this._selectMc.visible = false;
         }
         var medalId:int = int(this._userInfo.medalId);
         if(medalId == 0)
         {
            this._titleTxt.text = "无";
         }
         else
         {
            itemDefinition = ItemConfig.getMedalDefinition(medalId);
            if(itemDefinition != null)
            {
               this._titleTxt.text = itemDefinition.title;
            }
            else
            {
               this._titleTxt.text = "无";
            }
         }
      }
      
      private function hasTitle() : Boolean
      {
         var medalItem:MedalItem = null;
         for each(medalItem in ItemManager.getMedalVec())
         {
            if(medalItem.hasTitle())
            {
               return true;
            }
         }
         return false;
      }
   }
}

