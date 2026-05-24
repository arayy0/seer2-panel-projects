package com.taomee.seer2.module.app.userPanel
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.data.UserInfo;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.utils.Util;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import org.taomee.utils.StringUtil;
   
   public class UserPanelSignature extends Sprite
   {
      
      private static const CHANGE:String = "change";
      
      private static const SAVE:String = "save";
      
      private var _container:MovieClip;
      
      private var _background:Sprite;
      
      private var _changeBtn:SimpleButton;
      
      private var _signatureTxt:TextField;
      
      private var _signatureStr:String;
      
      private var _changedSignatureStr:String;
      
      private var _userId:uint;
      
      private var _status:String;
      
      public function UserPanelSignature()
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
         this.x = 423;
         this.y = 115;
         this._container = new UserPanelSignatureUI();
         addChild(this._container);
         this._signatureTxt = this._container["signature"];
         this._signatureTxt.maxChars = 36;
         this._background = this._container["bg"];
         this._changeBtn = this._container["change"];
      }
      
      private function initEventListener() : void
      {
         this._changeBtn.addEventListener(MouseEvent.CLICK,this.onChangeClick);
      }
      
      private function onChangeClick(evt:MouseEvent) : void
      {
         if(this._status == CHANGE)
         {
            this.setStatus(SAVE);
         }
         else if(this._status == SAVE)
         {
            this.saveDataToServer();
            this.updateSignatureTxt();
            this.setStatus(CHANGE);
         }
      }
      
      private function saveDataToServer() : void
      {
         this._changedSignatureStr = StringUtil.trim(this._signatureTxt.text);
         if(this._changedSignatureStr != this._signatureStr)
         {
            Connection.addCommandListener(CommandSet.USER_CHANGE_SIGNATURE_1029,this.onChangedSignature);
            Connection.send(CommandSet.USER_CHANGE_SIGNATURE_1029,this.packSignatureData());
         }
      }
      
      private function onChangedSignature(event:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.USER_CHANGE_SIGNATURE_1029,this.onChangedSignature);
         if(this._userId == ActorManager.actorInfo.id)
         {
            this._signatureStr = this._changedSignatureStr;
            this.updateSignatureTxt();
         }
      }
      
      private function packSignatureData() : LittleEndianByteArray
      {
         var result:LittleEndianByteArray = new LittleEndianByteArray();
         var msgData:LittleEndianByteArray = new LittleEndianByteArray();
         msgData.writeUTFBytes(this._changedSignatureStr);
         msgData.position = 0;
         var msgLen:int = int(msgData.length);
         result.writeUnsignedInt(msgLen);
         result.writeBytes(msgData,0,msgLen);
         return result;
      }
      
      public function reset() : void
      {
         this._changeBtn.visible = false;
         this._background.visible = false;
         this._signatureTxt.text = "";
      }
      
      public function setData(userInfo:UserInfo) : void
      {
         this._userId = userInfo.id;
         this._signatureStr = userInfo.signature;
         if(userInfo.id == ActorManager.actorInfo.id)
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
         this._changeBtn.visible = true;
         this.updateSignatureTxt();
         this.setStatus(CHANGE);
      }
      
      private function updateSignatureTxt() : void
      {
         this._signatureTxt.text = Util.pad(this._signatureStr," ",this._signatureStr.length + 4,false);
      }
      
      private function setStatus(value:String) : void
      {
         this._status = value;
         if(this._status == CHANGE)
         {
            this._background.visible = false;
            this._signatureTxt.selectable = false;
            this._signatureTxt.type = TextFieldType.DYNAMIC;
         }
         else if(this._status == SAVE)
         {
            this._background.visible = true;
            this._signatureTxt.selectable = true;
            this._signatureTxt.type = TextFieldType.INPUT;
         }
      }
      
      private function updateForOther() : void
      {
         this.updateSignatureTxt();
         this._changeBtn.visible = false;
         this._background.visible = false;
         this._signatureTxt.selectable = false;
         this._signatureTxt.type = TextFieldType.DYNAMIC;
      }
   }
}

