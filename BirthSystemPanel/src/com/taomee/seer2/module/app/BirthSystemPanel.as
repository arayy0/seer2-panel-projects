package com.taomee.seer2.module.app
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.config.BirthSkillListConfig;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.info.BirthSkillInfo;
   import com.taomee.seer2.app.home.HomeScene;
   import com.taomee.seer2.app.manager.DayLimitManager;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.core.module.Module;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.utils.LifecycleType;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.birthSystem.BirthCell;
   import com.taomee.seer2.module.app.birthSystem.BirthDemo;
   import com.taomee.seer2.module.app.birthSystem.BirthIng;
   import com.taomee.seer2.module.app.birthSystem.BirthPetSelectPanel;
   import com.taomee.seer2.module.app.birthSystem.BirthSkillList;
   import com.taomee.seer2.module.app.birthSystem.BirthStorage;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.IDataInput;
   import flash.utils.setTimeout;
   import org.taomee.utils.DisplayUtil;
   
   public class BirthSystemPanel extends Module
   {
      public static var _isBirthIng:Boolean;
      
      private static const MALE_CONTENT_BOUNDARY:Rectangle = new Rectangle(215,70,220,200);
      
      private static const FEMALE_CONTENT_BOUNDARY:Rectangle = new Rectangle(523,70,220,200);
      
      private const randomPetList:Vector.<uint> = Vector.<uint>([15,21,27,29,33,36,40,42,45,48,50,52,54,60,64,66,69,71,73,76,78,85,87,89,110,112,114,116,29,33,36,40,42,45,48,50,52]);
      
      private var _petCellVec:Vector.<BirthCell>;
      
      private var _birthType:uint;
      
      private var _birthStorage:BirthStorage;
      
      private var _maleSelectedPet:BirthCell;
      
      private var _femaleSelectedPet:BirthCell;
      
      private var _malePetDemoDisplayer:BirthDemo;
      
      private var _femalePetDemoDisplayer:BirthDemo;
      
      private var _startBirthBtn:SimpleButton;
      
      private var _skillList:BirthSkillList;
      
      private var _birthIng:BirthIng;
      
      private var _birthBg:MovieClip;
      
      private var _storageInfo:MovieClip;
      
      private var _apiBtn:SimpleButton;
      
      private var _storageCell:BirthCell;
      
      private var _storageBtn:SimpleButton;
      
      private var _birthPetSelectPanel:BirthPetSelectPanel;
      
      private var _storageGetBtn:SimpleButton;
      
      private var _type3PetInfo:PetInfo;
      
      private var _isMap20:Boolean;
      
      private var _isMaleDemo:Boolean;
      
      private var _isFemaleDemo:Boolean;
      
      private var _selectMaleTime:uint;
      
      private var _selectFemaleTime:uint;
      
      public function BirthSystemPanel()
      {
         super();
         _lifecycleType = LifecycleType.NONCE;
      }
      
      override public function setup() : void
      {
         setMainUI(new BirthPanelUI());
      }
      
      override public function init(data:Object) : void
      {
         StatisticsManager.sendNovice(StatisticsManager.ui_interact_287);
         this._birthType = data.birthType;
         this.getBirthPetInfo();
      }
      
      private function getBirthPetInfo() : void
      {
         Connection.addCommandListener(CommandSet.GET_BIRTH_SYSTEM_INFO_1204,this.onGetBirthInfo);
         Connection.send(CommandSet.GET_BIRTH_SYSTEM_INFO_1204);
      }
      
      private function onGetBirthInfo(event:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.GET_BIRTH_SYSTEM_INFO_1204,this.onGetBirthInfo);
         var data:IDataInput = event.message.getRawData();
         var count:uint = uint(data.readUnsignedInt());
         this.initVariable();
         if(count == 0)
         {
            this._birthIng.mc.visible = false;
            this._startBirthBtn.visible = true;
            this._birthBg.visible = true;
            _isBirthIng = false;
         }
         else
         {
            this._startBirthBtn.visible = false;
            this._birthBg.visible = false;
            this._birthIng.mc.visible = true;
            _isBirthIng = true;
            this.birthStatus(false);
            this._birthIng.setInfo(data,this.closeBirthIng);
         }
      }
      
      private function closeBirthIng() : void
      {
         this._birthIng.mc.visible = false;
         this._startBirthBtn.visible = true;
         this._birthBg.visible = true;
         _isBirthIng = false;
         this.birthStatus(true);
         this.startBtnCheck();
         setTimeout(function():void
         {
            updateDisplay();
            for(var i:int = 0; i < 6; i++)
            {
               _petCellVec[i].addEventListener(MouseEvent.CLICK,onPetCellClick);
               endCell(_petCellVec[i]);
            }
         },300);
      }
      
      private function initVariable() : void
      {
         this.initStorage();
         this.initPetCellVec();
         this.updateDisplay();
         this.initMC();
         this.initEvent();
      }
      
      private function initMC() : void
      {
         this._startBirthBtn = _mainUI["startBirthBtn"];
         this.startBtnCheck();
         this._skillList = new BirthSkillList();
         this._birthIng = new BirthIng(_mainUI["birthing"]);
         this._birthBg = _mainUI["birthBg"];
         this._apiBtn = _mainUI["apiBtn"];
      }
      
      private function initEvent() : void
      {
         for(var i:int = 0; i < 6; i++)
         {
            this._petCellVec[i].addEventListener(MouseEvent.CLICK,this.onPetCellClick);
            this.endCell(this._petCellVec[i]);
         }
         this._startBirthBtn.addEventListener(MouseEvent.CLICK,this.onStart);
         this._apiBtn.addEventListener(MouseEvent.CLICK,this.onApi);
      }
      
      private function onStart(event:MouseEvent) : void
      {
         StatisticsManager.sendNoviceAccountHttpd(StatisticsManager.ui_interact_68);
         DayLimitManager.getDoCount(371,function(cnt:int):void
         {
            if(cnt >= 3)
            {
               AlertManager.showAlert("今天已经繁殖三次啦");
               return;
            }
            if(SceneManager.active.mapID == 20)
            {
               sendBrith();
            }
            else
            {
               if(HomeScene(SceneManager.active).homeInfo.suleAwardCount >= 5)
               {
                  AlertManager.showAlert("这只精灵今天已经繁殖五次啦");
                  return;
               }
               sendBrith();
            }
         });
      }
      
      private function sendBrith() : void
      {
         if(ActorManager.actorInfo.coins < 2000)
         {
            AlertManager.showAlert("赛尔豆不足2000");
            return;
         }
         if(this._maleSelectedPet.petInfo.bunchId == this._femaleSelectedPet.petInfo.bunchId)
         {
            AlertManager.showAlert("同种类的精灵不能繁殖");
            return;
         }
         if(PetInfoManager.getAllBagPetInfo().length < 2)
         {
            AlertManager.showAlert("背包里的精灵必须还剩一只");
            return;
         }
         if(this._storageCell.selected == false && PetInfoManager.getAllBagPetInfo().length < 3)
         {
            AlertManager.showAlert("背包里的精灵必须还剩一只");
            return;
         }
         AlertManager.showConfirm("是否消耗2000赛尔豆开始培育？",function():void
         {
            _selectMaleTime = 0;
            _selectFemaleTime = 0;
            var meal:uint = uint(_maleSelectedPet.petInfo.catchTime);
            if(_isMap20)
            {
               meal = 1;
            }
            else
            {
               _selectMaleTime = meal;
            }
            _selectFemaleTime = _femaleSelectedPet.petInfo.catchTime;
            Connection.addCommandListener(CommandSet.START_BIRTH_PET_1205,onStartBirthPet);
            Connection.send(CommandSet.START_BIRTH_PET_1205,_femaleSelectedPet.petInfo.catchTime,meal);
         });
      }
      
      private function onStartBirthPet(event:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.START_BIRTH_PET_1205,this.onStartBirthPet);
         var data:IDataInput = event.message.getRawData();
         var femaleId:uint = uint(data.readUnsignedInt());
         var maleId:uint = uint(data.readUnsignedInt());
         var time:uint = uint(data.readUnsignedInt());
         var money:uint = uint(data.readUnsignedInt());
         if(time != 0)
         {
            PetInfoManager.setFirst(time);
         }
         this._startBirthBtn.visible = false;
         this._birthBg.visible = false;
         this._birthIng.mc.visible = true;
         this.birthStatus(false);
         PetInfoManager.removePetInfoFromBagById(this._selectFemaleTime);
         this._femaleSelectedPet.petInfo.isBirthIng = true;
         if(this._selectMaleTime != 0)
         {
            PetInfoManager.removePetInfoFromBagById(this._selectMaleTime);
            this._maleSelectedPet.petInfo.isBirthIng = true;
         }
         ActorManager.actorInfo.coins = money;
         this._isMaleDemo = false;
         this._isFemaleDemo = false;
         this._birthIng.setTimer(maleId,femaleId,this._maleSelectedPet.petInfo.catchTime,this._femaleSelectedPet.petInfo.catchTime,this._maleSelectedPet.userID,this._femaleSelectedPet.userID,this.closeBirthIng);
      }
      
      private function startBtnCheck() : void
      {
         if(this._isMaleDemo && this._isFemaleDemo)
         {
            this._startBirthBtn.alpha = 1;
            this._startBirthBtn.mouseEnabled = true;
            this._startBirthBtn.addEventListener(MouseEvent.CLICK,this.onStart);
         }
         else
         {
            this._startBirthBtn.alpha = 0.5;
            this._startBirthBtn.mouseEnabled = false;
         }
      }
      
      private function initStorage() : void
      {
         if(this._birthType == 1)
         {
            this.type1();
         }
         else if(this._birthType == 2)
         {
            this.type2();
         }
         else if(this._birthType == 3)
         {
            this.type3();
         }
      }
      
      private function type1() : void
      {
         Connection.addCommandListener(CommandSet.GET_DAY_RANDOM_PET_1210,this.onGetDayRandomPet);
         Connection.send(CommandSet.GET_DAY_RANDOM_PET_1210);
      }
      
      private function onGetDayRandomPet(event:MessageEvent) : void
      {
         var petInfo:PetInfo = null;
         Connection.removeCommandListener(CommandSet.GET_DAY_RANDOM_PET_1210,this.onGetDayRandomPet);
         var data:IDataInput = event.message.getRawData();
         var petInfoNum:int = int(data.readUnsignedInt());
         for(var i:int = 0; i < petInfoNum; i++)
         {
            petInfo = new PetInfo();
            PetInfo.readPetInfo(petInfo,data);
            this.initStorageInfo(petInfo);
         }
      }
      
      private function initStorageInfo(petInfo:PetInfo, isPetInfo:Boolean = true, skillInfo:BirthSkillInfo = null) : void
      {
         this._storageInfo = _mainUI["storageInfo0"];
         this._storageInfo.visible = true;
         _mainUI["storageInfo1"].visible = false;
         _mainUI["storageInfo2"].visible = false;
         if(this._storageCell == null)
         {
            this._storageCell = new BirthCell();
            this._storageCell.x = 5;
            this._storageCell.y = 15;
            this._storageCell.selected = false;
         }
         this._storageInfo.addChild(this._storageCell);
         this._storageCell.setPetInfo(petInfo);
         this._storageCell.addEventListener(MouseEvent.CLICK,this.onStroageCell);
      }
      
      private function onStroageCell(event:MouseEvent) : void
      {
         var cell:BirthCell = null;
         var currMap:Boolean = false;
         if(_isBirthIng)
         {
            return;
         }
         var petCell:BirthCell = event.currentTarget as BirthCell;
         if(BirthSkillListConfig.getInfo(petCell.petInfo.resourceId) == null)
         {
            AlertManager.showAlert("寄放的精灵不是可繁殖精灵");
            return;
         }
         if(petCell.petInfo.sex == 1)
         {
            this._maleSelectedPet = event.currentTarget as BirthCell;
            this._maleSelectedPet.userID = 4124123;
         }
         else if(petCell.petInfo.sex == 2)
         {
            this._femaleSelectedPet = event.currentTarget as BirthCell;
            this._femaleSelectedPet.userID = 4124123;
         }
         for each(cell in this._petCellVec)
         {
            cell.selected = false;
         }
         if(SceneManager.active.mapID == 20)
         {
            currMap = true;
            this._maleSelectedPet.userID = 4124123;
         }
         else
         {
            currMap = false;
         }
         if(petCell.petInfo.sex == 1)
         {
            this._maleSelectedPet.selected = true;
            this.showPetDemoDisplayer(1,currMap);
         }
         else if(petCell.petInfo.sex == 2)
         {
            this._femaleSelectedPet.selected = true;
            this.showPetDemoDisplayer(2,currMap);
         }
      }
      
      private function type2() : void
      {
         if(HomeScene(SceneManager.active).homeInfo.birthPetInfo == null)
         {
            this._storageInfo = _mainUI["storageInfo1"];
            this._storageInfo.visible = true;
            _mainUI["storageInfo0"].visible = false;
            _mainUI["storageInfo2"].visible = false;
            this._storageBtn = this._storageInfo["storageBtn"];
            this._storageBtn.addEventListener(MouseEvent.CLICK,this.onStorageClick);
            this._storageCell = new BirthCell();
            this._storageCell.x = 5;
            this._storageCell.y = 15;
            this._storageInfo.addChild(this._storageCell);
            this._storageCell.selected = false;
            this._storageCell.setPetInfo(null);
         }
         else
         {
            this.entryType3(HomeScene(SceneManager.active).homeInfo.birthPetInfo);
         }
      }
      
      private function onStorageClick(event:MouseEvent) : void
      {
         if(this._birthPetSelectPanel == null)
         {
            this._birthPetSelectPanel = new BirthPetSelectPanel();
         }
         _mainUI.addChild(this._birthPetSelectPanel);
         this._birthPetSelectPanel.x = 240;
         this._birthPetSelectPanel.y = 60;
         this._birthPetSelectPanel.addEventListener(BirthPetSelectPanel.SELECT_PET_SUCCESS,this.onSelectSuccess);
         this._birthPetSelectPanel.show();
      }
      
      private function entryType3(petInfo:PetInfo) : void
      {
         this._type3PetInfo = petInfo;
         this._storageInfo = _mainUI["storageInfo2"];
         this._storageInfo.visible = true;
         _mainUI["storageInfo0"].visible = false;
         _mainUI["storageInfo1"].visible = false;
         this._storageGetBtn = this._storageInfo["storageBtn"];
         if(this._storageCell == null)
         {
            this._storageCell = new BirthCell();
            this._storageCell.x = 5;
            this._storageCell.y = 15;
            this._storageCell.selected = false;
         }
         this._storageInfo.addChild(this._storageCell);
         this._storageCell.setPetInfo(this._type3PetInfo);
         if(BirthSkillListConfig.getInfo(this._type3PetInfo.resourceId) == null)
         {
            this.onStorageGetBtn(null);
         }
         this._storageGetBtn.addEventListener(MouseEvent.CLICK,this.onStorageGetBtn);
      }
      
      private function onStorageGetBtn(event:MouseEvent) : void
      {
         Connection.addCommandListener(CommandSet.SET_BIRTH_HOME_1207,this.onSetBirthHomePet);
         Connection.send(CommandSet.SET_BIRTH_HOME_1207,0,this._type3PetInfo.catchTime);
      }
      
      private function onSetBirthHomePet(event:MessageEvent) : void
      {
         var data:IDataInput;
         var time:uint;
         var bytes:LittleEndianByteArray;
         Connection.removeCommandListener(CommandSet.SET_BIRTH_HOME_1207,this.onSetBirthHomePet);
         data = event.message.getRawData();
         time = uint(data.readUnsignedInt());
         bytes = new LittleEndianByteArray();
         bytes.writeUnsignedInt(this._type3PetInfo.catchTime);
         if(PetInfoManager.isBagFull())
         {
            bytes.writeByte(0);
         }
         else
         {
            bytes.writeByte(1);
         }
         Connection.send(CommandSet.PET_SET_STORAGE_STATUS_1020,bytes);
         this._type3PetInfo.isSetBirth = false;
         HomeScene(SceneManager.active).homeInfo.birthPetInfo = null;
         setTimeout(function():void
         {
            updateDisplay();
            for(var i:int = 0; i < 6; i++)
            {
               _petCellVec[i].addEventListener(MouseEvent.CLICK,onPetCellClick);
               endCell(_petCellVec[i]);
            }
         },300);
         this.type2();
      }
      
      private function onSelectSuccess(event:Event) : void
      {
         if(this._maleSelectedPet && this._maleSelectedPet.petInfo && this._birthPetSelectPanel.getInfo().catchTime == this._maleSelectedPet.petInfo.catchTime)
         {
            if(Boolean(this._malePetDemoDisplayer))
            {
               this._malePetDemoDisplayer.dispose();
            }
            DisplayUtil.removeForParent(this._malePetDemoDisplayer);
            this._maleSelectedPet.selected = false;
            this._maleSelectedPet.userID = 0;
            this._isMaleDemo = false;
         }
         if(this._femaleSelectedPet && this._femaleSelectedPet.petInfo && this._birthPetSelectPanel.getInfo().catchTime == this._femaleSelectedPet.petInfo.catchTime)
         {
            if(Boolean(this._femalePetDemoDisplayer))
            {
               this._femalePetDemoDisplayer.dispose();
            }
            DisplayUtil.removeForParent(this._femalePetDemoDisplayer);
            this._femaleSelectedPet.selected = false;
            this._femaleSelectedPet.userID = 0;
            this._isFemaleDemo = false;
         }
         this.startBtnCheck();
         Connection.addCommandListener(CommandSet.SET_BIRTH_HOME_1207,this.onSetBirthHome);
         Connection.send(CommandSet.SET_BIRTH_HOME_1207,1,this._birthPetSelectPanel.getInfo().catchTime);
      }
      
      private function onSetBirthHome(event:MessageEvent) : void
      {
         var petCell:BirthCell = null;
         Connection.removeCommandListener(CommandSet.SET_BIRTH_HOME_1207,this.onSetBirthHome);
         var data:IDataInput = event.message.getRawData();
         var time:uint = uint(data.readUnsignedInt());
         if(time != 0)
         {
            PetInfoManager.setFirst(time);
         }
         this._birthPetSelectPanel.getInfo().isSetBirth = true;
         PetInfoManager.removePetInfoFromBagById(this._birthPetSelectPanel.getInfo().catchTime);
         HomeScene(SceneManager.active).homeInfo.birthPetInfo = this._birthPetSelectPanel.getInfo();
         this.entryType3(this._birthPetSelectPanel.getInfo());
         for each(petCell in this._petCellVec)
         {
            if(petCell.petInfo.resourceId == this._birthPetSelectPanel.getInfo().resourceId)
            {
               petCell.setPetInfo(null);
               return;
            }
         }
         this.updateDisplay();
         this.initStorageInfo(this._birthPetSelectPanel.getInfo());
      }
      
      private function type3() : void
      {
         if(Boolean(HomeScene(SceneManager.active).homeInfo.birthPetInfo))
         {
            this.initStorageInfo(HomeScene(SceneManager.active).homeInfo.birthPetInfo);
         }
         else
         {
            this._storageInfo = _mainUI["storageInfo0"];
            _mainUI["storageInfo1"].visible = false;
            _mainUI["storageInfo2"].visible = false;
            if(this._storageCell == null)
            {
               this._storageCell = new BirthCell();
               this._storageCell.x = 5;
               this._storageCell.y = 15;
               this._storageInfo.addChild(this._storageCell);
               this._storageCell.selected = false;
               this._storageCell.setPetInfo(null);
            }
         }
      }
      
      private function birthStatus(b:Boolean) : void
      {
         var i:int = 0;
         if(b)
         {
            this.initEvent();
            if(Boolean(this._storageCell) && Boolean(this._storageCell.petInfo))
            {
               this._storageCell.addEventListener(MouseEvent.CLICK,this.onStroageCell);
            }
         }
         else
         {
            for(i = 0; i < 6; i++)
            {
               this._petCellVec[i].removeEventListener(MouseEvent.CLICK,this.onPetCellClick);
            }
            this._startBirthBtn.removeEventListener(MouseEvent.CLICK,this.onStart);
            if(Boolean(this._malePetDemoDisplayer))
            {
               this._malePetDemoDisplayer.dispose();
            }
            if(Boolean(this._femalePetDemoDisplayer))
            {
               this._femalePetDemoDisplayer.dispose();
            }
            if(Boolean(this._storageCell))
            {
               this._storageCell.removeEventListener(MouseEvent.CLICK,this.onStroageCell);
            }
         }
      }
      
      private function initPetCellVec() : void
      {
         var petCell:BirthCell = null;
         this._petCellVec = Vector.<BirthCell>([]);
         var colCount:int = 2;
         var leftMargin:int = 16;
         var horizontalPadding:int = 98;
         var topMargin:int = 15;
         var verticalPadding:int = 100;
         for(var i:int = 0; i < 6; i++)
         {
            petCell = new BirthCell();
            petCell.x = leftMargin + i % colCount * horizontalPadding;
            petCell.y = topMargin + int(i / 2) * verticalPadding;
            _mainUI.addChild(petCell);
            this._petCellVec.push(petCell);
         }
         this._malePetDemoDisplayer = new BirthDemo();
         this._femalePetDemoDisplayer = new BirthDemo();
      }
      
      private function updateDisplay() : void
      {
         var petCell:BirthCell = null;
         var petInfoVec:Vector.<PetInfo> = PetInfoManager.getAllBagPetInfo().slice();
         for(var i:int = 0; i < 6; i++)
         {
            petCell = this._petCellVec[i];
            petCell.selected = false;
            if(i < petInfoVec.length)
            {
               petCell.setPetInfo(petInfoVec[i]);
            }
            else
            {
               petCell.setPetInfo(null);
            }
         }
      }
      
      private function onPetCellClick(event:MouseEvent) : void
      {
         var petCell:BirthCell = null;
         var target:BirthCell = event.currentTarget as BirthCell;
         if(target.petInfo == null)
         {
            return;
         }
         var sex:uint = uint(target.petInfo.sex);
         for(var i:int = 0; i < 6; i++)
         {
            petCell = this._petCellVec[i];
            if(petCell == target)
            {
               if(this.selectError(petCell))
               {
                  if(petCell.petInfo.sex == 1)
                  {
                     this._maleSelectedPet = petCell;
                     this._maleSelectedPet.userID = ActorManager.actorInfo.id;
                     if(SceneManager.active.mapID == 20)
                     {
                        this._storageCell.selected = false;
                     }
                     if(Boolean(this._storageCell.petInfo) && this._storageCell.petInfo.sex == 1)
                     {
                        this._storageCell.selected = false;
                     }
                  }
                  else if(petCell.petInfo.sex == 2)
                  {
                     this._femaleSelectedPet = petCell;
                     this._femaleSelectedPet.userID = ActorManager.actorInfo.id;
                     if(Boolean(this._storageCell.petInfo) && this._storageCell.petInfo.sex == 2)
                     {
                        this._storageCell.selected = false;
                     }
                  }
                  petCell.selected = true;
                  this.showPetDemoDisplayer(sex);
               }
               else
               {
                  petCell.selected = false;
               }
            }
            else if(Boolean(petCell.petInfo) && petCell.petInfo.sex == sex)
            {
               petCell.selected = false;
            }
         }
      }
      
      private function selectError(petCell:BirthCell) : Boolean
      {
         var info:BirthSkillInfo = null;
         if(petCell.petInfo && petCell.petInfo.sex != 1 && petCell.petInfo.sex != 2)
         {
            AlertManager.showAlert("精灵无性别或者合体性别");
            return false;
         }
         var list:Vector.<BirthSkillInfo> = BirthSkillListConfig.getList();
         var isMonster2:Boolean = false;
         for each(info in list)
         {
            if(PetConfig.getPetDefinition(info.id).bunchId == petCell.petInfo.bunchId)
            {
               isMonster2 = true;
            }
         }
         //if(isMonster2 == false)
         if(false)
         {
            AlertManager.showAlert("对不起你的精灵并非二代精灵");
            return false;
         }
         if(petCell.petInfo.sex == 1 && petCell.petInfo.level < 60)
         {
            AlertManager.showAlert("雄性精灵等级必须大于60");
            return false;
         }
         return true;
      }
      
      private function endCell(petCell:BirthCell) : void
      {
         var info:BirthSkillInfo = null;
         if(petCell.petInfo == null)
         {
            this.mouseEndCell(petCell);
            petCell.removeMouseOver();
            return;
         }
         if(petCell.petInfo.sex != 1 && petCell.petInfo.sex != 2)
         {
            this.mouseEndCell(petCell);
            petCell.removeMouseOver();
            return;
         }
         if(petCell.petInfo.isTwoPet)
         {
            this.mouseEndCell(petCell);
            petCell.removeMouseOver();
            return;
         }
         var list:Vector.<BirthSkillInfo> = BirthSkillListConfig.getList();
         var isMonster2:Boolean = false;
         for each(info in list)
         {
            if(PetConfig.getPetDefinition(info.id).bunchId == petCell.petInfo.bunchId)
            {
               isMonster2 = true;
            }
         }
         //if(isMonster2 == false)
         if(false)
         {
            this.mouseEndCell(petCell);
            petCell.removeMouseOver();
            return;
         }
         if(petCell.petInfo.sex == 1 && petCell.petInfo.level < 60)
         {
            this.mouseEndCell(petCell);
            petCell.removeMouseOver();
            return;
         }
         petCell.mouseChildren = true;
         petCell.mouseEnabled = true;
         petCell.alpha = 1;
         petCell.addEventListener(MouseEvent.CLICK,this.onPetCellClick);
      }
      
      private function mouseEndCell(petCell:BirthCell) : void
      {
         petCell.mouseChildren = false;
         petCell.mouseEnabled = false;
         petCell.alpha = 0.5;
         petCell.removeEventListener(MouseEvent.CLICK,this.onPetCellClick);
      }
      
      private function showPetDemoDisplayer(sex:uint, isMap20:Boolean = false) : void
      {
         if(sex == 1)
         {
            this._isMap20 = isMap20;
            if(Boolean(this._malePetDemoDisplayer))
            {
               this._malePetDemoDisplayer.dispose();
            }
            DisplayUtil.removeForParent(this._malePetDemoDisplayer);
            this._malePetDemoDisplayer.setInfo(this._maleSelectedPet.petInfo,this.addPetToDemo);
            if(Boolean(this._skillList))
            {
               this._skillList.dispose();
            }
            DisplayUtil.removeForParent(this._skillList);
            this._skillList = new BirthSkillList();
            this._skillList.setInfo(this._maleSelectedPet.petInfo.resourceId);
            this._skillList.x = 218;
            this._skillList.y = 312;
            _mainUI.addChild(this._skillList);
         }
         else if(sex == 2)
         {
            if(Boolean(this._femalePetDemoDisplayer))
            {
               this._femalePetDemoDisplayer.dispose();
            }
            DisplayUtil.removeForParent(this._femalePetDemoDisplayer);
            this._femalePetDemoDisplayer.setInfo(this._femaleSelectedPet.petInfo,this.addPetToDemo);
         }
      }
      
      private function addPetToDemo(sex:uint) : void
      {
         if(sex == 1)
         {
            this._malePetDemoDisplayer.x = (MALE_CONTENT_BOUNDARY.width - this._malePetDemoDisplayer.width) / 2 + MALE_CONTENT_BOUNDARY.x;
            this._malePetDemoDisplayer.y = (MALE_CONTENT_BOUNDARY.height - this._malePetDemoDisplayer.height) / 2 + MALE_CONTENT_BOUNDARY.y;
            _mainUI.addChild(this._malePetDemoDisplayer);
            this._malePetDemoDisplayer.buttonMode = true;
            this._isMaleDemo = true;
            this.startBtnCheck();
            this._malePetDemoDisplayer.addEventListener(MouseEvent.CLICK,this.onClickMaleDemo);
         }
         else if(sex == 2)
         {
            this._femalePetDemoDisplayer.x = (FEMALE_CONTENT_BOUNDARY.width - this._femalePetDemoDisplayer.width) / 2 + FEMALE_CONTENT_BOUNDARY.x;
            this._femalePetDemoDisplayer.y = (FEMALE_CONTENT_BOUNDARY.height - this._femalePetDemoDisplayer.height) / 2 + FEMALE_CONTENT_BOUNDARY.y;
            _mainUI.addChild(this._femalePetDemoDisplayer);
            this._femalePetDemoDisplayer.buttonMode = true;
            this._isFemaleDemo = true;
            this.startBtnCheck();
            this._femalePetDemoDisplayer.addEventListener(MouseEvent.CLICK,this.onClickMaleFemale);
         }
      }
      
      private function onClickMaleDemo(event:MouseEvent) : void
      {
         if(Boolean(this._malePetDemoDisplayer))
         {
            this._malePetDemoDisplayer.dispose();
         }
         DisplayUtil.removeForParent(this._malePetDemoDisplayer);
         this._maleSelectedPet.selected = false;
         this._isMaleDemo = false;
         this._isMap20 = false;
         this.startBtnCheck();
         if(Boolean(this._skillList))
         {
            this._skillList.dispose();
         }
         this._maleSelectedPet.userID = 0;
         DisplayUtil.removeForParent(this._skillList);
      }
      
      private function onClickMaleFemale(event:MouseEvent) : void
      {
         if(Boolean(this._femalePetDemoDisplayer))
         {
            this._femalePetDemoDisplayer.dispose();
         }
         DisplayUtil.removeForParent(this._femalePetDemoDisplayer);
         this._femaleSelectedPet.selected = false;
         this._isFemaleDemo = false;
         this._femaleSelectedPet.userID = 0;
         this.startBtnCheck();
      }
      
      private function onApi(event:MouseEvent) : void
      {
         ModuleManager.toggleModule(URLUtil.getAppModule("BirthSystemPanelAPT"),"正在打开繁殖说明...");
      }
      
      override public function dispose() : void
      {
         var petCell:BirthCell = null;
         Connection.removeCommandListener(CommandSet.GET_DAY_RANDOM_PET_1210,this.onGetDayRandomPet);
         Connection.removeCommandListener(CommandSet.START_BIRTH_PET_1205,this.onStartBirthPet);
         Connection.removeCommandListener(CommandSet.GET_BIRTH_SYSTEM_INFO_1204,this.onGetBirthInfo);
         if(Boolean(this._birthIng))
         {
            this._birthIng.dispose();
         }
         if(Boolean(this._skillList))
         {
            this._skillList.dispose();
         }
         DisplayUtil.removeForParent(this._malePetDemoDisplayer);
         DisplayUtil.removeForParent(this._skillList);
         DisplayUtil.removeForParent(this._femalePetDemoDisplayer);
         DisplayUtil.removeForParent(this._storageCell);
         DisplayUtil.removeForParent(this._birthPetSelectPanel);
         for each(petCell in this._petCellVec)
         {
            DisplayUtil.removeForParent(petCell);
         }
         super.dispose();
      }
   }
}

