package com.taomee.seer2.module.app.birthSystem
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.BirthSystemPanel;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.IDataInput;
   import flash.utils.Timer;
   import org.taomee.utils.DisplayUtil;
   
   public class BirthIng
   {
      private var _mc:MovieClip;
      
      private var _animation:MovieClip;
      
      private var _openBirthBtn:SimpleButton;
      
      private var _closeBirthBtn:SimpleButton;
      
      private var _maleContent:MovieClip;
      
      private var _femaleContent:MovieClip;
      
      private var _date0:MovieClip;
      
      private var _date1:MovieClip;
      
      private var _date2:MovieClip;
      
      private var _malePetInfo:BirthIngInfo;
      
      private var _femalePetInfo:BirthIngInfo;
      
      private var _startTime:uint;
      
      private var _timer:Timer;
      
      private var _maleIcon:IconDisplayer;
      
      private var _femaleIcon:IconDisplayer;
      
      private var _cookbook:Function;
      
      public function BirthIng(mc:MovieClip)
      {
         super();
         this._mc = mc;
         this._animation = this._mc["animation"];
         this._animation.visible = false;
         this._openBirthBtn = this._mc["openBirthBtn"];
         this._closeBirthBtn = this._mc["closeBirthBtn"];
         this._maleContent = this._mc["maleContent"];
         this._femaleContent = this._mc["femaleContent"];
         this._date0 = this._mc["date0"];
         this._date1 = this._mc["date1"];
         this._date2 = this._mc["date2"];
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         this._openBirthBtn.addEventListener(MouseEvent.CLICK,this.onOpen);
         this._closeBirthBtn.addEventListener(MouseEvent.CLICK,this.onClose);
      }
      
      private function onOpen(event:MouseEvent) : void
      {
         Connection.addCommandListener(CommandSet.GET_TWO_PET_1208,this.onGetTwoPet);
         Connection.send(CommandSet.GET_TWO_PET_1208);
         StatisticsManager.sendNoviceAccountHttpd(StatisticsManager.ui_interact_69);
      }
      
      private function onGetTwoPet(event:MessageEvent) : void
      {
         var obj:Object = null;
         var total:uint = 0;
         Connection.removeCommandListener(CommandSet.GET_TWO_PET_1208,this.onGetTwoPet);
         var data:IDataInput = event.message.getRawData();
         var petId:uint = uint(data.readUnsignedInt());
         var petTime:uint = uint(data.readUnsignedInt());
         var skillId:uint = uint(data.readUnsignedInt());
         obj = new Object();
         obj.petId = petId;
         obj.petTime = petTime;
         obj.skillId = skillId;
         ModuleManager.closeForName("BirthSystemPanel");
         var bytes:LittleEndianByteArray = new LittleEndianByteArray();
         var bytes2:LittleEndianByteArray = new LittleEndianByteArray();
         bytes.writeUnsignedInt(this._malePetInfo.time);
         bytes2.writeUnsignedInt(this._femalePetInfo.time);
         if(this._malePetInfo.userId == ActorManager.actorInfo.id && this._femalePetInfo.userId == ActorManager.actorInfo.id)
         {
            total = 5;
            if(PetInfoManager.getAllBagPetInfo().length < total)
            {
               bytes.writeByte(1);
               bytes2.writeByte(1);
               Connection.send(CommandSet.PET_SET_STORAGE_STATUS_1020,bytes);
               Connection.send(CommandSet.PET_SET_STORAGE_STATUS_1020,bytes2);
            }
         }
         else if(this._malePetInfo.userId != ActorManager.actorInfo.id || this._femalePetInfo.userId != ActorManager.actorInfo.id)
         {
            total = 6;
            if(PetInfoManager.getAllBagPetInfo().length < total)
            {
               bytes.writeByte(1);
               bytes2.writeByte(1);
               if(this._malePetInfo.userId == ActorManager.actorInfo.id)
               {
                  Connection.send(CommandSet.PET_SET_STORAGE_STATUS_1020,bytes);
               }
               else if(this._femalePetInfo.userId == ActorManager.actorInfo.id)
               {
                  Connection.send(CommandSet.PET_SET_STORAGE_STATUS_1020,bytes2);
               }
            }
         }
         BirthSystemPanel._isBirthIng = false;
         ModuleManager.toggleModule(URLUtil.getAppModule("BirthSystemComplete"),"正在打开繁殖完成面板...",obj);
      }
      
      private function onClose(event:MouseEvent) : void
      {
         Connection.addCommandListener(CommandSet.CLOSE_BIRTH_1206,this.onCloseBirth);
         Connection.send(CommandSet.CLOSE_BIRTH_1206);
      }
      
      private function onCloseBirth(event:MessageEvent) : void
      {
         var total:uint = 0;
         Connection.removeCommandListener(CommandSet.CLOSE_BIRTH_1206,this.onCloseBirth);
         var date:IDataInput = event.message.getRawData();
         var bytes:LittleEndianByteArray = new LittleEndianByteArray();
         var bytes2:LittleEndianByteArray = new LittleEndianByteArray();
         bytes.writeUnsignedInt(this._malePetInfo.time);
         bytes2.writeUnsignedInt(this._femalePetInfo.time);
         if(this._malePetInfo.userId == ActorManager.actorInfo.id && this._femalePetInfo.userId == ActorManager.actorInfo.id)
         {
            total = 5;
            if(PetInfoManager.getAllBagPetInfo().length < total)
            {
               bytes.writeByte(1);
               bytes2.writeByte(1);
               Connection.send(CommandSet.PET_SET_STORAGE_STATUS_1020,bytes);
               Connection.send(CommandSet.PET_SET_STORAGE_STATUS_1020,bytes2);
            }
         }
         else if(this._malePetInfo.userId != ActorManager.actorInfo.id || this._femalePetInfo.userId != ActorManager.actorInfo.id)
         {
            total = 6;
            if(PetInfoManager.getAllBagPetInfo().length < total)
            {
               bytes.writeByte(1);
               bytes2.writeByte(1);
               if(this._malePetInfo.userId == ActorManager.actorInfo.id)
               {
                  Connection.send(CommandSet.PET_SET_STORAGE_STATUS_1020,bytes);
               }
               else if(this._femalePetInfo.userId == ActorManager.actorInfo.id)
               {
                  Connection.send(CommandSet.PET_SET_STORAGE_STATUS_1020,bytes2);
               }
            }
         }
         BirthSystemPanel._isBirthIng = false;
         this.dispose();
      }
      
      public function setTimer(maleId:uint, femaleId:uint, maleTime:uint, femaleTime:uint, maleUserID:uint, femaleUserId:uint, cookBook:Function) : void
      {
         this._startTime = 10800;
         this.entryTime();
         this._date0.gotoAndStop(uint(this._startTime / 3600) + 1);
         this._date1.gotoAndStop(uint(uint(uint(this._startTime % 3600) / 60) / 10) + 1);
         this._date2.gotoAndStop(uint(uint(uint(this._startTime % 3600) / 60) % 10) + 1);
         this.startTime();
         this._malePetInfo = new BirthIngInfo();
         this._femalePetInfo = new BirthIngInfo();
         this._malePetInfo.id = maleId;
         this._femalePetInfo.id = femaleId;
         this._malePetInfo.time = maleTime;
         this._femalePetInfo.time = femaleTime;
         this._malePetInfo.userId = maleUserID;
         this._femalePetInfo.userId = femaleUserId;
         this._cookbook = cookBook;
         this.showIcon();
         this.playAnimation();
      }
      
      private function playAnimation() : void
      {
         this._animation.visible = true;
         MovieClipUtil.playMc(this._animation,2,this._animation.totalFrames,function():void
         {
            _animation.visible = false;
         });
      }
      
      public function setInfo(data:IDataInput, cookBook:Function) : void
      {
         this._malePetInfo = new BirthIngInfo();
         this._femalePetInfo = new BirthIngInfo();
         var id1:uint = uint(data.readUnsignedInt());
         var sex1:uint = uint(data.readUnsignedInt());
         var time1:uint = uint(data.readUnsignedInt());
         var userId1:uint = uint(data.readUnsignedInt());
         var id2:uint = uint(data.readUnsignedInt());
         var sex2:uint = uint(data.readUnsignedInt());
         var time2:uint = uint(data.readUnsignedInt());
         var userId2:uint = uint(data.readUnsignedInt());
         var time:uint = uint(data.readUnsignedInt());
         if(sex1 == 1)
         {
            this._malePetInfo.id = id1;
            this._malePetInfo.sex = sex1;
            this._malePetInfo.time = time1;
            this._malePetInfo.userId = userId1;
            this._femalePetInfo.id = id2;
            this._femalePetInfo.sex = sex2;
            this._femalePetInfo.time = time2;
            this._femalePetInfo.userId = userId2;
         }
         else
         {
            this._femalePetInfo.id = id1;
            this._femalePetInfo.sex = sex1;
            this._femalePetInfo.time = time1;
            this._femalePetInfo.userId = userId1;
            this._malePetInfo.id = id2;
            this._malePetInfo.sex = sex2;
            this._malePetInfo.time = time2;
            this._malePetInfo.userId = userId2;
         }
         this._animation.gotoAndStop(1);
         this._animation.visible = false;
         this._startTime = 10920 - (TimeManager.getServerTime() - time);
         if(TimeManager.getServerTime() - time > 10920)
         {
            this._startTime = 0;
         }
         if(time > TimeManager.getServerTime())
         {
            this._startTime = 10920;
         }
         this.entryTime();
         if(this._startTime > 0)
         {
            this._date0.gotoAndStop(uint(this._startTime / 3600) + 1);
            this._date1.gotoAndStop(uint(uint(uint(this._startTime % 3600) / 60) / 10) + 1);
            this._date2.gotoAndStop(uint(uint(uint(this._startTime % 3600) / 60) % 10) + 1);
            if(this._startTime > 10800)
            {
               this._date0.gotoAndStop(4);
               this._date1.gotoAndStop(1);
               this._date2.gotoAndStop(1);
            }
            this.startTime();
         }
         this._cookbook = cookBook;
         this.showIcon();
      }
      
      private function showIcon() : void
      {
         this._maleIcon = new IconDisplayer();
         this._maleIcon.scaleY = this._maleIcon.scaleX = 1.5;
         this._maleIcon.x = this._maleContent.x - 40;
         this._maleIcon.y = this._maleContent.y - 40;
         this._mc.addChild(this._maleIcon);
         this._femaleIcon = new IconDisplayer();
         this._femaleIcon.scaleY = this._femaleIcon.scaleX = 1.5;
         this._femaleIcon.x = this._femaleContent.x - 40;
         this._femaleIcon.y = this._femaleContent.y - 40;
         this._mc.addChild(this._femaleIcon);
         var url:String = URLUtil.getPetIcon(this._malePetInfo.id);
         this._maleIcon.setIconUrl(url,this.onContentLoaded);
      }
      
      private function onContentLoaded() : void
      {
         var url:String = URLUtil.getPetIcon(this._femalePetInfo.id);
         this._femaleIcon.setIconUrl(url);
      }
      
      private function entryTime() : void
      {
         if(this._startTime <= 0)
         {
            this._openBirthBtn.visible = true;
            this._closeBirthBtn.visible = false;
            this._date0.gotoAndStop(1);
            this._date1.gotoAndStop(1);
            this._date2.gotoAndStop(1);
         }
         else
         {
            this._closeBirthBtn.visible = true;
            this._openBirthBtn.visible = false;
         }
      }
      
      private function startTime() : void
      {
         this._timer = new Timer(60000);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this._timer.start();
      }
      
      private function onTimer(event:TimerEvent) : void
      {
         if(this._startTime < 60)
         {
            this._startTime = 0;
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.entryTime();
            return;
         }
         this._startTime -= 60;
         if(this._startTime > 0)
         {
            this._date0.gotoAndStop(uint(this._startTime / 3600) + 1);
            this._date1.gotoAndStop(uint(uint(uint(this._startTime % 3600) / 60) / 10) + 1);
            this._date2.gotoAndStop(uint(uint(uint(this._startTime % 3600) / 60) % 10) + 1);
            if(this._startTime < 60)
            {
               this._startTime = 0;
               this._timer.stop();
               this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
               this.entryTime();
               return;
            }
            if(this._startTime > 10800)
            {
               this._date0.gotoAndStop(4);
               this._date1.gotoAndStop(1);
               this._date2.gotoAndStop(1);
            }
         }
         else
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.entryTime();
         }
      }
      
      public function get mc() : MovieClip
      {
         return this._mc;
      }
      
      public function dispose() : void
      {
         Connection.removeCommandListener(CommandSet.GET_TWO_PET_1208,this.onGetTwoPet);
         Connection.removeCommandListener(CommandSet.CLOSE_BIRTH_1206,this.onCloseBirth);
         DisplayUtil.removeForParent(this._maleIcon);
         DisplayUtil.removeForParent(this._femaleIcon);
         if(this._cookbook != null)
         {
            this._cookbook();
         }
         this._cookbook = null;
      }
   }
}

