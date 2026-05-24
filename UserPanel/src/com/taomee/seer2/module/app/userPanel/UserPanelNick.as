package com.taomee.seer2.module.app.userPanel
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.data.UserInfo;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.utils.ByteArray;
   import org.taomee.utils.StringUtil;
   
   public class UserPanelNick extends Sprite
   {
      
      private static const CHANGE_NICK:String = "changeNick";
      
      private static const SHOW_NICK:String = "showNick";
      
      private var _container:MovieClip;
      
      private var _nickTxt:TextField;
      
      private var _saveNickBtn:SimpleButton;
      
      private var _changeNickBtn:SimpleButton;
      
      private var _userID:uint;
      
      private var _nick:String;
      
      private var _nickChanged:String;
      
      private var _state:String;
      
      public function UserPanelNick()
      {
         super();
         this.initialize();
      }
      
      private static function validateNick(source:String) : Boolean
      {
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUTFBytes(source);
         if(byteArray.length > 16)
         {
            return false;
         }
         return true;
      }
      
      private function initialize() : void
      {
         this.createChildren();
         this.initEventListener();
      }
      
      private function createChildren() : void
      {
         this.x = 170;
         this.y = 43;
         this._container = new UserPanelNickUI();
         addChild(this._container);
         this._nickTxt = this._container["nick"];
         this._nickTxt.maxChars = 16;
         this._saveNickBtn = this._container["saveNick"];
         this._changeNickBtn = this._container["changeNick"];
      }
      
      private function initEventListener() : void
      {
         this._saveNickBtn.addEventListener(MouseEvent.CLICK,this.onSaveClick);
         this._changeNickBtn.addEventListener(MouseEvent.CLICK,this.onChangeClick);
      }
      
      private function onSaveClick(evt:MouseEvent) : void
      {
         this.state = SHOW_NICK;
         this._nickChanged = StringUtil.trim(this._nickTxt.text);
         this._nickTxt.text = this._nick;
         if(this._nickChanged == this._nick)
         {
            return;
         }
         if(validateNick(this._nickChanged) == false)
         {
            AlertManager.showAlert("你输入的昵称太长了");
            return;
         }
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUTFBytes(this._nickChanged);
         byteArray.length = UserInfo.NICK_DATA_LEN;
         Connection.addCommandListener(CommandSet.USER_CHANGE_NICK_1099,this.onChangedNick);
         Connection.send(CommandSet.USER_CHANGE_NICK_1099,byteArray);
      }
      
      private function onChangedNick(event:MessageEvent) : void
      {
         var rawData:ByteArray = event.message.getRawDataCopy();
         var userID:uint = rawData.readUnsignedInt();
         var nick:String = rawData.readUTFBytes(UserInfo.NICK_DATA_LEN);
         if(userID == this._userID)
         {
            this._nick = nick;
            this._nickTxt.text = nick;
            Connection.removeCommandListener(CommandSet.USER_CHANGE_NICK_1099,this.onChangedNick);
         }
      }
      
      private function onChangeClick(evt:MouseEvent) : void
      {
         this.state = CHANGE_NICK;
      }
      
      public function reset() : void
      {
         this._nickTxt.text = "";
         this._changeNickBtn.visible = false;
         this._saveNickBtn.visible = false;
      }
      
      public function setData(info:UserInfo) : void
      {
         this._userID = info.id;
         this._nick = info.nick;
         this.updateDisplay();
      }
      
      private function updateDisplay() : void
      {
         this._nickTxt.text = this._nick;
         if(this._userID == ActorManager.actorInfo.id)
         {
            this.updateForSelf();
         }
         else
         {
            this.updateForOther();
         }
      }
      
      private function updateForSelf() : void
      {
         this._changeNickBtn.visible = true;
         this._saveNickBtn.visible = true;
         this.state = SHOW_NICK;
      }
      
      private function updateForOther() : void
      {
         this._changeNickBtn.visible = false;
         this._saveNickBtn.visible = false;
      }
      
      private function set state(value:String) : void
      {
         this._state = value;
         if(this._state == SHOW_NICK)
         {
            this._changeNickBtn.visible = true;
            this._saveNickBtn.visible = false;
            this._nickTxt.type = TextFieldType.DYNAMIC;
            this._nickTxt.selectable = true;
         }
         else
         {
            this._changeNickBtn.visible = false;
            this._saveNickBtn.visible = true;
            this._nickTxt.type = TextFieldType.INPUT;
            this._nickTxt.selectable = true;
         }
      }
   }
}

