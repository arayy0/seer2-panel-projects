package com.taomee.seer2.module.app
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.config.pet.PetDefinition;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.PetPowerUpdate;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.module.Module;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.utils.LifecycleType;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.honor.HonorPetSelectUI;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.IDataInput;
   import org.taomee.manager.EventManager;
   
   public class GadSelectPetPanel extends Module
   {
       
      
      private var _info:Object;
      
      private var _petVec:Vector.<PetInfo>;
      
      private var _count:int;
      
      private var _petIconVec:Vector.<Sprite>;
      
      private var _select:Sprite;
      
      private var _selectPet:PetInfo;
      
      private var _okBtn:SimpleButton;
      
      private var _noBtn:SimpleButton;
      
      private var _callback:Function;
      
      private var _url:String;
      
      private var _is1097:Boolean;
      
      private var _loadIConDisplay:Vector.<IconDisplayer>;
      
      private var _icon:IconDisplayer;
      
      private var _iconTemp:Sprite;
      
      public function GadSelectPetPanel()
      {
         super();
         _lifecycleType = LifecycleType.NONCE;
      }
      
      override public function setup() : void
      {
         setMainUI(new HonorPetSelectUI());
         this.initUI();
         this.addEvent();
      }
      
      override public function init(data:Object) : void
      {
         this._info = data;
         this._is1097 = this._info.is1079;
         this._callback = this._info.fun;
         this.setData();
      }
      
      private function addEvent() : void
      {
         this._okBtn.addEventListener(MouseEvent.CLICK,this.onOk);
         this._noBtn.addEventListener(MouseEvent.CLICK,this.onNo);
      }
      
      private function removeEvent() : void
      {
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.onOk);
         this._noBtn.removeEventListener(MouseEvent.CLICK,this.onNo);
      }
      
      private function initUI() : void
      {
         this._petVec = Vector.<PetInfo>([]);
         this._petIconVec = Vector.<Sprite>([]);
         this._okBtn = _mainUI["yesBtn"];
         this._noBtn = _mainUI["noBtn"];
         this._count = 0;
         this._loadIConDisplay = new Vector.<IconDisplayer>([]);
         this._icon = new IconDisplayer();
      }
      
      private function setData() : void
      {
         var petDefiniton:PetDefinition = null;
         var pet:PetInfo = null;
         var petInfo:PetInfo = null;
         for each(petInfo in PetInfoManager.getTotalBagPetInfo())
         {
            if(petInfo.bunchId == this._info.petId)
            {
               this._petVec.push(petInfo);
            }
            else if(this._info.petId == 147)
            {
               //玩家ID限制
               //if(ActorManager.actorInfo.id == 0){
               if(true){
                  this._petVec.push(petInfo);
               }
            }
            else if(petInfo.resourceId == 388 && (this._info.id == 203038 || this._info.id == 200659))
            {
               this._petVec.push(petInfo);
            }
         }
         if(this._petVec.length <= 0)
         {
            onClose(new MouseEvent(MouseEvent.CLICK));
            AlertManager.showAlert("对不起，你的背包中没有精灵");
         }
         else
         {
            this._count = 0;
            this.setupPetIcon();
         }
      }
      
      private function onOk(event:MouseEvent) : void
      {
         var byteData:LittleEndianByteArray = null;
         this.removeEvent();
         if(Boolean(this._selectPet))
         {
            if(this._is1097)
            {
               byteData = new LittleEndianByteArray();
               byteData.writeInt(this._info.sId);
               byteData.writeShort(1);
               byteData.writeInt(this._selectPet.catchTime);
               Connection.addCommandListener(CommandSet.HONOR_EXCHANGE_1097,this.onHonorExchange);
               Connection.addErrorHandler(CommandSet.HONOR_EXCHANGE_1097,this.onHonorError);
               Connection.send(CommandSet.HONOR_EXCHANGE_1097,byteData);
            }
            else
            {
               SwapManager.swapItem(this._info.swapId,this._selectPet.catchTime,function(data:IDataInput):void
               {
                  var swap:SwapInfo = new SwapInfo(data,false);
                  if(_callback != null)
                  {
                     _callback();
                  }
                  AlertManager.showAlert("精灵添加纹章成功！");
                  EventManager.dispatchEvent(new Event(PetPowerUpdate.PET_UPDATE));
                  if(_info.swapId == 1092 || _info.swapId == 1094)
                  {
                     nextAnimation(1092);
                  }
                  if(_info.swapId == 1095 || _info.swapId == 1093)
                  {
                     nextAnimation(1093);
                  }
                  onClose(new MouseEvent(MouseEvent.CLICK));
               },function(statusCode:int):void
               {
                  switch(statusCode)
                  {
                     case 33:
                        AlertManager.showAlert("精灵不在背包里");
                        break;
                     case 126:
                        AlertManager.showAlert("此精灵已经有纹章啦");
                        break;
                     case 52:
                        AlertManager.showAlert("没有权限使用纹章");
                  }
                  onClose(new MouseEvent(MouseEvent.CLICK));
               });
            }
         }
      }
      
      private function nextAnimation(swapId:uint) : void
      {
         MovieClipUtil.playFullScreen(URLUtil.getActivityFullScreen("gad/" + swapId),null,true,false,2);
      }
      
      private function onHonorExchange(msg:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.HONOR_EXCHANGE_1097,this.onHonorExchange);
         Connection.removeErrorHandler(CommandSet.HONOR_EXCHANGE_1097,this.onHonorError);
         var data:IDataInput = msg.message.getRawData();
         var id:uint = uint(data.readUnsignedInt());
         var count:uint = uint(data.readUnsignedShort());
         var time:uint = uint(data.readUnsignedInt());
         var petTime:uint = uint(data.readUnsignedInt());
         var honorNum:uint = uint(data.readUnsignedInt());
         var petInfo:PetInfo = PetInfoManager.getPetInfoFromAllBag(petTime);
         petInfo.emblemId = id;
         onClose(new MouseEvent(MouseEvent.CLICK));
         EventManager.dispatchEvent(new Event(PetPowerUpdate.PET_UPDATE));
      }
      
      private function onHonorError(msg:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.HONOR_EXCHANGE_1097,this.onHonorExchange);
         Connection.removeErrorHandler(CommandSet.HONOR_EXCHANGE_1097,this.onHonorError);
         if(msg.message.statusCode == 6)
         {
            ServerMessager.addMessage("找不到此物品");
         }
         if(msg.message.statusCode == 33)
         {
            ServerMessager.addMessage("精灵不在精灵背包里");
         }
         if(msg.message.statusCode == 52)
         {
            ServerMessager.addMessage("没有权限使用此纹章");
         }
         if(msg.message.statusCode == 124)
         {
         }
         if(msg.message.statusCode == 125)
         {
         }
         if(msg.message.statusCode == 126)
         {
            ServerMessager.addMessage("此精灵已设置纹章，不能再设置");
         }
         if(msg.message.statusCode == 127)
         {
         }
         if(msg.message.statusCode == 104358)
         {
         }
         onClose(new MouseEvent(MouseEvent.CLICK));
      }
      
      private function onNo(event:MouseEvent) : void
      {
         this.removeEvent();
         onClose(new MouseEvent(MouseEvent.CLICK));
      }
      
      private function setupPetIcon() : void
      {
         if(this._count >= this._petVec.length)
         {
            return;
         }
         this._url = URLUtil.getPetIcon(this._petVec[this._count].resourceId);
         var icon:IconDisplayer = new IconDisplayer();
         this._loadIConDisplay.push(icon);
         icon.setIconUrl(this._url,this.onContentLoaded);
      }
      
      private function onContentLoaded() : void
      {
         var potentialIcon:IconDisplayer = null;
         var rect:Rectangle = null;
         var icon:IconDisplayer = this._loadIConDisplay[this._count];
         icon.x = 46 + int(this._count % 3) * (icon.width + 40);
         icon.y = 76 + int(this._count / 3) * 150;
         _mainUI.addChild(icon);
         icon.buttonMode = true;
         if(this._petVec[this._count].emblemId > 0)
         {
            potentialIcon = new IconDisplayer();
            potentialIcon.setIconUrl(ItemConfig.getItemIconUrl(this._petVec[this._count].emblemId));
            icon.addChild(potentialIcon);
            rect = potentialIcon.getBounds(potentialIcon);
            potentialIcon.x = icon.width - 10;
            potentialIcon.y = icon.height - 10;
            potentialIcon.mouseEnabled = false;
         }
         icon.addEventListener(MouseEvent.CLICK,this.confirmDialog);
         this._petIconVec.push(icon);
         if(this._select == null)
         {
            this._select = new HonorSelectBoxUI();
            this._select.x = this._petIconVec[0].x - 15;
            this._select.y = this._petIconVec[0].y - 15;
            this._select.mouseChildren = false;
            this._select.mouseEnabled = false;
            this._selectPet = this._petVec[0];
            _mainUI.addChild(this._select);
         }
         ++this._count;
         this.setupPetIcon();
      }
      
      private function confirmDialog(event:MouseEvent) : void
      {
         this._iconTemp = event.currentTarget as Sprite;
         AlertManager.showConfirm("你确定要使用该纹章吗？",this.yesHandler,this.cancelHandler);
      }
      
      private function yesHandler(param:* = null) : void
      {
         if(Boolean(this._iconTemp))
         {
            this.onMouseClickIcon(this._iconTemp);
         }
      }
      
      private function cancelHandler(param:* = null) : void
      {
         this._iconTemp = null;
      }
      
      private function onMouseClickIcon(iconTemp:Sprite) : void
      {
         var icon:Sprite = iconTemp;
         var index:int = this._petIconVec.indexOf(icon);
         if(Boolean(this._select))
         {
            this._select.x = this._petIconVec[index].x - 15;
            this._select.y = this._petIconVec[index].y - 15;
         }
         this._selectPet = this._petVec[index];
      }
   }
}
