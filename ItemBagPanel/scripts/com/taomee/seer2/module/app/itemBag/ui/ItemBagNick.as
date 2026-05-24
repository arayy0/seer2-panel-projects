package com.taomee.seer2.module.app.itemBag.ui
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.data.UserInfo;
   import com.taomee.seer2.app.component.VipLogoDisplayer;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.processor.activity.decoration.DecorationManager;
   import com.taomee.seer2.app.vip.VipManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.itemBag.ItemBagNickUI;
   import com.taomee.seer2.module.app.userPanel.UserPanelTitle;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.utils.ByteArray;
   import org.taomee.utils.StringUtil;
   
   public class ItemBagNick extends Sprite
   {
      
      private static const CHANGE_NICK:String = "changeNick";
      
      private static const SHOW_NICK:String = "showNick";
       
      
      private var _container:MovieClip;
      
      private var _nickTxt:TextField;
      
      private var _saveNickMC:SimpleButton;
      
      private var _changeNickMC:SimpleButton;
      
      private var _userID:uint;
      
      private var _nick:String;
      
      private var _nickChanged:String;
      
      private var _state:String;
      
      private var _userPanelTitle:UserPanelTitle;
      
      private var _vipLogo:VipLogoDisplayer;
      
      private var _yearVipMC:MovieClip;
      
      private var _passWordBtn:SimpleButton;
      
      private var _decoration:MovieClip;
      
      private var _idTxt:TextField;
      
      public function ItemBagNick()
      {
         super();
         this.createChildren();
         this.initEventListener();
      }
      
      private static function validateNick(source:String) : Boolean
      {
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUTFBytes(source);
         if(byteArray.length > UserInfo.NICK_DATA_LEN)
         {
            return false;
         }
         return true;
      }
      
      private function createChildren() : void
      {
         this._container = new ItemBagNickUI();
         this._container.x = 80;
         this._container.y = 55;
         addChild(this._container);
         this._nickTxt = this._container["nick"];
         this._nickTxt.maxChars = 8;
         this._idTxt = this._container["userId"];
         this._saveNickMC = this._container["saveNick"];
         this._changeNickMC = this._container["changeNick"];
         this._yearVipMC = this._container["yearVipMC"];
         this._userPanelTitle = new UserPanelTitle();
         addChild(this._userPanelTitle);
         this._userPanelTitle.x = 93;
         this._userPanelTitle.y = 440;
         this._vipLogo = new VipLogoDisplayer();
         this._vipLogo.x = 40;
         this._vipLogo.y = 30;
         addChild(this._vipLogo);
         this._passWordBtn = this._container["passWordBtn"];
         TooltipManager.addCommonTip(this._passWordBtn,"密码保护");
         this._passWordBtn.addEventListener(MouseEvent.CLICK,this.onPassWord);
         this._decoration = this._container["decorationMC"];
         TooltipManager.addCommonTip(this._decoration,DecorationManager.getStr(ActorManager.actorInfo) + "守护者");
         this._decoration.gotoAndStop(DecorationManager.getConstellation(String(ActorManager.actorInfo.birthdayInfo.month),String(ActorManager.actorInfo.birthdayInfo.day)) + 2);
      }
      
      private function onPassWord(event:MouseEvent) : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("PasswordDefendPanel"),"正在打开面板...");
      }
      
      private function initEventListener() : void
      {
         this._saveNickMC.addEventListener(MouseEvent.CLICK,this.onSaveClick);
         this._changeNickMC.addEventListener(MouseEvent.CLICK,this.onChangeClick);
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
      
      public function setData(info:UserInfo) : void
      {
         this._userID = info.id;
         this._nick = info.nick;
         this.updateDisplay();
      }
      
      private function updateDisplay() : void
      {
         this._nickTxt.text = this._nick;
         this._idTxt.text = (this._userID).toString();
         this.state = SHOW_NICK;
         this._userPanelTitle.setData(ActorManager.actorInfo);
         this._vipLogo.setVipFlag(VipManager.vipInfo);
         if(Boolean(ActorManager.actorInfo.isYearVip))
         {
            this._yearVipMC.visible = true;
         }
         else
         {
            this._yearVipMC.visible = false;
         }
      }
      
      private function set state(value:String) : void
      {
         this._state = value;
         if(this._state == SHOW_NICK)
         {
            this._changeNickMC.visible = true;
            this._saveNickMC.visible = false;
            this._nickTxt.type = TextFieldType.DYNAMIC;
            this._nickTxt.selectable = false;
         }
         else
         {
            this._changeNickMC.visible = false;
            this._saveNickMC.visible = true;
            this._nickTxt.type = TextFieldType.INPUT;
            this._nickTxt.selectable = true;
         }
      }
   }
}
