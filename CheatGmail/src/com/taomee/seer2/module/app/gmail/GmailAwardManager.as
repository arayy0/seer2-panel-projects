package com.taomee.seer2.module.app.gmail
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.mail.GmailDataManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.utils.IDataInput;
   
   public class GmailAwardManager
   {
      
      private static var _mailId:int;
      
      private static var _success:Function;
      
      private static var _fail:Function;
      
      private static var _isProcessing:Boolean;
      
      private static var _waitList:Array = [];
      
      public function GmailAwardManager()
      {
         super();
      }
      
      public static function getMailAward(mailId:int, callBack:Function, fail:Function) : void
      {
         _waitList.push({
            "id":mailId,
            "success":callBack,
            "fail":fail
         });
         processNext();
      }
      
      private static function processNext() : void
      {
         var obj:Object = null;
         if(_waitList.length > 0 && _isProcessing == false)
         {
            obj = _waitList.shift();
            _mailId = obj.id;
            _success = obj.success;
            _fail = obj.fail;
            Connection.addCommandListener(CommandSet.GET_MAIL_AWARD_1257,onGetAward);
            Connection.send(CommandSet.GET_MAIL_AWARD_1257,ActorManager.actorInfo.id,_mailId);
         }
      }
      
      private static function onGetAward(e:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.GET_MAIL_AWARD_1257,onGetAward);
         var data:IDataInput = e.message.getRawData();
         var _symble:int = int(data.readUnsignedInt());
         var _itemId:int = int(data.readUnsignedInt());
         if(_symble == 0)
         {
            GmailDataManager.getInstance().getMailDataById(_mailId).attachmentArray = [];
            GmailDataManager.getInstance().getMailDataById(_mailId).attachmentSymble = false;
            _success();
            _success = null;
            _fail = null;
            _mailId = 0;
         }
         else
         {
            _success = null;
            _fail();
            _fail = null;
            _mailId = 0;
            AlertManager.showAlert(ItemConfig.getItemName(_itemId) + "的数量已经超过上限");
         }
         processNext();
      }
   }
}

