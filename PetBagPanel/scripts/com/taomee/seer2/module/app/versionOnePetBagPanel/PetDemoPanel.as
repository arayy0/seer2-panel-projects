package com.taomee.seer2.module.app.versionOnePetBagPanel
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.arena.data.FightResultInfo;
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.component.PetDemoDisplayer;
   import com.taomee.seer2.app.component.PetTypeIcon;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.PetEvolveConfig;
   import com.taomee.seer2.app.config.PetRideShopConfig;
   import com.taomee.seer2.app.config.PetSkinConfig;
   import com.taomee.seer2.app.config.PetSkinDefineConfig;
   import com.taomee.seer2.app.config.pet.PetDefinition;
   import com.taomee.seer2.app.inventory.item.EquipItem;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.constant.PetTypeNameMap;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.pet.events.PetInfoEvent;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.utils.MovieClipUtil;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DateUtil;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.moduleCommon.PetFeatureIcon;
   import com.taomee.seer2.module.app.petRide.PetRideHelper;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.taomee.filter.ColorFilter;
   import org.taomee.utils.DisplayUtil;
   
   public class PetDemoPanel extends Sprite
   {
       
      
      private var _petInfo:PetInfo;
      
      private var _showPetDefinition:PetDefinition;
      
      private var _mainUI:MovieClip;
      
      private var _setFirstBtn:SimpleButton;
      
      private var _goFight:SimpleButton;
      
      private var _followBtn:SimpleButton;
      
      private var _trainingBtn:SimpleButton;
      
      private var _putInStorageBtn:SimpleButton;
      
      private var _takeBackBtn:SimpleButton;
      
      private var _starLevel:MovieClip;
      
      private var _sexIcon:MovieClip;
      
      private var _petTypeIcon:PetTypeIcon;
      
      private var _featureIcon:PetFeatureIcon;
      
      private var _petRideIcon:MovieClip;
      
      private var _nameTxt:TextField;
      
      private var _itemIconList:Vector.<IconDisplayer>;
      
      private var _starList:Vector.<MovieClip>;
      
      private var _twoMC:MovieClip;
      
      private var _skinMC:MovieClip;
      
      private var _petDemoDisplayer:PetDemoDisplayer;
      
      private var _addHpAnnimation:MovieClip;
      
      private var _petRideBtn:SimpleButton;
      
      private var _petRideBackBtn:SimpleButton;
      
      private var _tipArea:MovieClip;
      
      private var _petTipUI:MovieClip;
      
      private var _petFetterMC:MovieClip;
      
      private var _changPetBtn:SimpleButton;
      
      private var _isChangePet:Boolean;
      
      private var _prevPetId:uint;
      
      private var _goBtn:SimpleButton;
      
      private var _lastBtn:SimpleButton;
      
      private var _nextBtn:SimpleButton;
      
      private var _goTxt:TextField;
      
      private var _curTxt:TextField;
      
      private var _stateTxt:TextField;
      
      private var _curIndex:int = 0;
      
      private var _currResId:int;
      
      private var _nameBack:MovieClip;
      
      private const _expDataList:Array = ["200763","200605","201012"];
      
      private var _realFirstBtn:SimpleButton;
      
      private var _skinBtn:SimpleButton;
      
      public function PetDemoPanel()
      {
         super();
         this.initSet();
         this.initEvent();
      }
      
      private function get mainUI() : PetDemoUI
      {
         return this._mainUI as PetDemoUI;
      }
      
      private function initSet() : void
      {
         var i:int = 0;
         this._mainUI = new PetDemoUI();
         addChild(this._mainUI);
         this._petDemoDisplayer = new PetDemoDisplayer();
         this._petDemoDisplayer.mouseEnabled = true;
         this._mainUI.addChild(this._petDemoDisplayer);
         this._petDemoDisplayer.x = 148;
         this._petDemoDisplayer.y = 225;
         this._setFirstBtn = this._mainUI["setFirstBtn"];
         this._goFight = this._mainUI["goFight"];
         this._trainingBtn = this._mainUI["trainingBtn"];
         this._sexIcon = this._mainUI["petSexIcon"];
         this._sexIcon.x = 1;
         this._sexIcon.y = 40;
         DisplayObjectUtil.removeFromParent(this._mainUI["petSexIcon"]);
         addChild(this._sexIcon);
         this._realFirstBtn = this._mainUI["realFirst"];
         TooltipManager.addCommonTip(this._realFirstBtn,"用于设置御风赛场、天空竞技场等PVP赛场中的默认首发精灵");
         this._followBtn = this._mainUI["followBtn"];
         this._putInStorageBtn = this._mainUI["putInStorageBtn"];
         this._takeBackBtn = this._mainUI["takeBackBtn"];
         this._nameBack = this._mainUI["nameBack"];
         DisplayUtil.removeForParent(this._mainUI["nameBack"]);
         addChild(this._nameBack);
         this._nameTxt = this._mainUI["nameTxt"];
         DisplayObjectUtil.removeFromParent(this._mainUI["nameTxt"]);
         addChild(this._nameTxt);
         this._twoMC = this._mainUI["twoMC"];
         DisplayObjectUtil.removeFromParent(this._mainUI["twoMC"]);
         addChild(this._twoMC);
         TooltipManager.addCommonTip(this._twoMC,"二代精灵");
         this._skinMC = this._mainUI["skinMC"];
         DisplayObjectUtil.removeFromParent(this._mainUI["skinMC"]);
         addChild(this._skinMC);
         TooltipManager.addCommonTip(this._skinMC,"正在使用皮肤");
         this._petRideBtn = this._mainUI["petRideBtn"];
         this._petRideBackBtn = this._mainUI["petRideBackBtn"];
         this._petRideIcon = this._mainUI["petRideIcon"];
         this._petRideIcon.gotoAndStop(1);
         DisplayObjectUtil.removeFromParent(this._mainUI["petRideIcon"]);
         addChild(this._petRideIcon);
         this._tipArea = this._mainUI["tipArea"];
         this._tipArea.buttonMode = true;
         this._petFetterMC = this._mainUI["fetterMC"];
         DisplayObjectUtil.removeFromParent(this._mainUI["fetterMC"]);
         addChild(this._petFetterMC);
         this._petTipUI = this._mainUI["petTipUI"];
         this._changPetBtn = this._mainUI["changPetBtn"];
         this._skinBtn = this._mainUI["skinBtn"];
         (this._petTipUI["petName"] as TextField).text = "";
         this._petTipUI.mouseChildren = false;
         this._petTipUI.mouseEnabled = false;
         this._takeBackBtn.visible = false;
         this._petRideBackBtn.visible = false;
         this._addHpAnnimation = this._mainUI["addHp"];
         this._addHpAnnimation.gotoAndStop(1);
         DisplayObjectUtil.removeFromParent(this._mainUI["addHp"]);
         addChild(this._addHpAnnimation);
         this._petTypeIcon = new PetTypeIcon();
         this._petTypeIcon.x = 35;
         this._petTypeIcon.y = 37;
         addChild(this._petTypeIcon);
         this._petTypeIcon.buttonMode = true;
         this._featureIcon = new PetFeatureIcon();
         this._featureIcon.x = 260;
         this._featureIcon.y = 43;
         addChild(this._featureIcon);
         this._itemIconList = new Vector.<IconDisplayer>();
         this._starList = new Vector.<MovieClip>();
         i = 0;
         while(i < 4)
         {
            this._starList.push(this.mainUI["star" + i]);
            DisplayUtil.removeForParent(this._mainUI["star" + i]);
            this._starList[i].visible = false;
            this._starList[i].gotoAndStop(1);
            addChild(this._starList[i]);
            i++;
         }
         this._starLevel = this._mainUI["starLevel"];
         DisplayObjectUtil.removeFromParent(this._mainUI["starLevel"]);
         addChild(this._starLevel);
      }
      
      private function initEvent() : void
      {
         this._setFirstBtn.addEventListener("click",this.onBtnClick);
         this._trainingBtn.addEventListener("click",this.onBtnClick);
         this._followBtn.addEventListener("click",this.onBtnClick);
         this._putInStorageBtn.addEventListener("click",this.onBtnClick);
         this._takeBackBtn.addEventListener("click",this.onBtnClick);
         this._petRideBackBtn.addEventListener("click",this.onBtnClick);
         this._petRideBtn.addEventListener("click",this.onBtnClick);
         this._petTypeIcon.addEventListener("click",this.onPetType);
         TooltipManager.addExternalTip(this._tipArea,this._petTipUI);
         this._tipArea.addEventListener("rollOver",this.onTipShow);
         this._tipArea.addEventListener("rollOut",this.onTipHide);
         this._goFight.addEventListener("click",this.onGoFight);
         this._changPetBtn.addEventListener("click",this.onChangPet);
         this._realFirstBtn.addEventListener("click",this.onSetRealFirst);
         this._skinBtn.addEventListener("click",function(e:MouseEvent):void
         {
            ModuleManager.showModule(URLUtil.getAppModule("PetSkinPanel"),"正在打开...");
         });
      }
      
      private function onChangPet(event:MouseEvent) : void
      {
         trace("ikee debug:   =====>pre  _currResId:" + this._currResId + " _prevPetId:" + this._prevPetId + " _isChangePet:" + this._isChangePet);
         if(this._isChangePet)
         {
            this._currResId = this._prevPetId;
            this.showPetCurIndex();
         }
         else
         {
            if(this._currResId == 0)
            {
               this._currResId = this._petInfo.resourceId;
            }
            this._prevPetId = this._currResId;
            this._currResId = this._petInfo.getPetDefinition().chgMonId;
            this.showPetCurIndex();
         }
         this._isChangePet = !this._isChangePet;
         trace("ikee debug:   =====>end  _currResId:" + this._currResId + " _prevPetId:" + this._prevPetId + " _isChangePet:" + this._isChangePet);
      }
      
      private function onGoFight(evt:MouseEvent) : void
      {
         var bagPetInfoVec:Vector.<PetInfo> = PetInfoManager.getAllBagPetInfo().slice();
         if(this._petInfo.isInStorageBag)
         {
            if(bagPetInfoVec.length < 6){
               Connection.send(CommandSet.CLI_EXCHANGE_MON_BETWEEN_BAG_AND_VIP_BAG_1261,0,_petInfo.catchTime);
               return;
            }
            AlertManager.showPetBagSelectAlert("选择进入出战的精灵哦",function(info:PetInfo):void
            {
               trace("背包交互----","普通背包checkTime:",info != null ? info.catchTime : 0,";vip背包checkTime:",_petInfo.catchTime);
               if(info)
               {
                  if(info.isStarting)
                  {
                     AlertManager.showAlert("只可以替换非首发精灵哦!");
                     return;
                  }
                  if(info.isFollowing)
                  {
                     AlertManager.showAlert("要替换的精灵正在跟随哦，取消跟随再替换吧!");
                     return;
                  }
                  if(info.isPetRiding)
                  {
                     AlertManager.showAlert("要替换的精灵正被骑乘，取消骑乘再替换吧!");
                     return;
                  }
               }
               Connection.send(CommandSet.CLI_EXCHANGE_MON_BETWEEN_BAG_AND_VIP_BAG_1261,info != null ? info.catchTime : 0,_petInfo.catchTime);
            });
         }
         else
         {
            AlertManager.showAlert("选择精灵仓库的精灵设置出战吧！");
         }
      }
      
      private function onTipShow(evt:MouseEvent) : void
      {
         if((this._petTipUI["petName"] as TextField).text == "")
         {
            this.updateTipInfo();
         }
      }
      
      private function onTipHide(evt:MouseEvent) : void
      {
         (this._petTipUI["petName"] as TextField).text = "";
      }
      
      private function updateTipInfo() : void
      {
         var skinId:int = 0;
         if(this._showPetDefinition)
         {
            skinId = int(PetSkinConfig.getSkinId(this._showPetDefinition.resId));
            /*if(skinId && skinId > 9999)
            {
               (this._petTipUI["petName"] as TextField).text = PetConfig.getPetDefinition(skinId).name;
               (this._petTipUI["introduceTxt"] as TextField).text = PetConfig.getPetDefinition(skinId) == null ? "" : String(PetConfig.getPetDefinition(skinId).description);
            }
            else
            {
               (this._petTipUI["petName"] as TextField).text = this._showPetDefinition.name;
               (this._petTipUI["introduceTxt"] as TextField).text = this._showPetDefinition == null ? "" : String(this._showPetDefinition.description);
            }*/
            (this._petTipUI["petName"] as TextField).text = this._showPetDefinition.name;
            (this._petTipUI["introduceTxt"] as TextField).text = this._showPetDefinition == null ? "" : String(this._showPetDefinition.description);
            (this._petTipUI["heightTxt"] as TextField).text = this._petInfo.physicalHeight + "cm";
            (this._petTipUI["weightTxt"] as TextField).text = this._petInfo.physicalWeight + "kg";
            (this._petTipUI["catchTimeTxt"] as TextField).text = DateUtil.formatCalendarWithYearMonthDay(this._petInfo.catchTime).toString();
            (this._petTipUI["getWayTxt"] as TextField).text = "" + this._showPetDefinition.resId;
         }
      }
      
      private function onBtnClick(e:MouseEvent) : void
      {
         var target:SimpleButton = e.currentTarget as SimpleButton;
         switch(target)
         {
            case this._setFirstBtn:
               this.onSetFirstBtnClick();
               break;
            case this._followBtn:
               this.onFollowBtnClick();
               break;
            case this._trainingBtn:
               this.onTrainingBtnClick();
               break;
            case this._putInStorageBtn:
               this.onPutInStorageBtnClick();
               break;
            case this._takeBackBtn:
               this.onTakeBackBtnClick();
               break;
            case this._petRideBackBtn:
               this.onPetRideBack();
               break;
            case this._petRideBtn:
               this.onPetRide();
         }
      }
      
      private function onPetRide() : void
      {
         var info:PetInfo;
         var tempItem:EquipItem;
         if(PetRideShopConfig.isRidePetBunch(this._petInfo.bunchId) == true && PetRideShopConfig.isCanRidePet(this._petInfo.resourceId) == false)
         {
            AlertManager.showAlert("你当前的精灵还没有达到骑乘精灵形态，升级以后再来试试吧");
            return;
         }
         trace("系统时间",TimeManager.getServerTime(),"安装时间",this._petInfo.chipPutOnTime);
         if(ActorManager.actorInfo.vipInfo.isVip() == false)
         {
            if(TimeManager.getServerTime() - this._petInfo.chipPutOnTime > 604800)
            {
               AlertManager.showAlert("普通用户只有7天试骑时间，现在已经过期，成为VIP后能够永久拥有");
               return;
            }
         }
         if(PetRideShopConfig.isCanRidePet(this._petInfo.resourceId) == true && (this._petInfo.chipPutOnTime == 0 || this._petInfo.petRideChipId == 0))
         {
            return;
         }
         info = PetInfoManager.getFollowingPetInfo();
         if(info && info.catchTime == this.petInfo.catchTime)
         {
            AlertManager.showConfirm("精灵当前正在跟随中，请先收回再骑乘吧",function():void
            {
               this.onTakeBackBtnClick();
            });
            return;
         }
         tempItem = PetRideHelper.getInstance().getNormalRideEquip();
         if(tempItem)
         {
            AlertManager.showAlert("对不起，你当前正在使用其他坐骑装备，请先收回再试试吧");
            return;
         }
         DisplayObjectUtil.disableButton(this._petRideBtn);
         PetInfoManager.addEventListener("PET_SET_RIDE",this.onChangeRideStatusSuccess);
         PetInfoManager.requestSetPetRide(this._petInfo.catchTime,3);
      }
      
      private function onPetRideBack() : void
      {
         DisplayObjectUtil.disableButton(this._petRideBackBtn);
         PetInfoManager.addEventListener("PET_SET_RIDE",this.onChangeRideStatusSuccess);
         PetInfoManager.requestSetPetRide(this._petInfo.catchTime,2);
      }
      
      private function onChangeRideStatusSuccess(e:PetInfoEvent) : void
      {
         PetInfoManager.removeEventListener("PET_SET_RIDE",this.onChangeRideStatusSuccess);
         var info:PetInfo = e.info;
         if(info.catchTime != this._petInfo.catchTime)
         {
            return;
         }
         if(int(e.content) == ActorManager.actorInfo.id)
         {
            if(info.isPetRiding == true)
            {
               this._petRideBtn.visible = false;
               this._petRideBackBtn.visible = true;
               DisplayObjectUtil.enableButton(this._petRideBackBtn);
            }
            else
            {
               this._petRideBtn.visible = true;
               this._petRideBackBtn.visible = false;
               DisplayObjectUtil.enableButton(this._petRideBtn);
            }
         }
      }
      
      private function onSuperPet() : void
      {
         StatisticsManager.sendNovice("0x1003390C");
         ModuleManager.closeForName("PetBagPanel");
         ModuleManager.showModule(URLUtil.getAppModule("SuperPetPracticePanel"),"正在打开...");
      }
      
      private function onSetFirstBtnClick() : void
      {
         DisplayObjectUtil.disableButton(this._setFirstBtn);
         PetInfoManager.requestSetFirst(this._petInfo.catchTime);
      }
      
      private function onSetRealFirst(e:MouseEvent) : void
      {
         var info:* = null;
         var i:int = 0;
         var catchTimeList:Vector.<uint> = new Vector.<uint>();
         for each(info in PetInfoManager.getAllBagPetInfo())
         {
            catchTimeList.push(info.catchTime);
         }
         PetInfoManager.requestSetFirst(this._petInfo.catchTime);
         for(i = 0; i < catchTimeList.length; )
         {
            if(catchTimeList[i] != this._petInfo.catchTime)
            {
               this.takeOutPetAgain(catchTimeList[i]);
            }
            i++;
         }
      }
      
      private function takeOutPetAgain(petCatchTime:uint) : void
      {
         var byteArray:LittleEndianByteArray = null;
         byteArray = new LittleEndianByteArray();
         byteArray.writeUnsignedInt(petCatchTime);
         byteArray.writeByte(0);
         Connection.addCommandListener(CommandSet.PET_SET_STORAGE_STATUS_1020,(function():*
         {
            var putPetToStorage:Function;
            return putPetToStorage = function(event:MessageEvent):void
            {
               Connection.removeCommandListener(CommandSet.PET_SET_STORAGE_STATUS_1020,putPetToStorage);
               byteArray.clear();
               byteArray.writeUnsignedInt(petCatchTime);
               byteArray.writeByte(1);
               Connection.addCommandListener(CommandSet.PET_SET_STORAGE_STATUS_1020,(function():*
               {
                  var putPetToBag:Function;
                  return putPetToBag = function(event:MessageEvent):void
                  {
                     Connection.removeCommandListener(CommandSet.PET_SET_STORAGE_STATUS_1020,putPetToBag);
                  };
               })());
               Connection.send(CommandSet.PET_SET_STORAGE_STATUS_1020,byteArray);
            };
         })());
         Connection.send(CommandSet.PET_SET_STORAGE_STATUS_1020,byteArray);
      }
      
      private function onSetSecondBtnClick() : void
      {
      }
      
      private function onFollowBtnClick() : void
      {
         if(this._petInfo.isPetRiding == true)
         {
            AlertManager.showAlert("你当前选择精灵正在骑乘中，请先收回再设置跟随吧");
            return;
         }
         DisplayObjectUtil.disableButton(this._followBtn);
         PetInfoManager.addEventListener("petSetFollow",this.onChangeFollowStatusSuccess);
         PetInfoManager.requestSetPetFollow(this._petInfo.catchTime,1);
      }
      
      private function onTakeBackBtnClick() : void
      {
         DisplayObjectUtil.disableButton(this._takeBackBtn);
         PetInfoManager.addEventListener("petSetFollow",this.onChangeFollowStatusSuccess);
         PetInfoManager.requestSetPetFollow(this._petInfo.catchTime,0);
      }
      
      private function onChangeFollowStatusSuccess(e:PetInfoEvent) : void
      {
         PetInfoManager.removeEventListener("petSetFollow",this.onChangeFollowStatusSuccess);
         var info:PetInfo = e.info;
         if(info.catchTime != this._petInfo.catchTime)
         {
            return;
         }
         if(info.isFollowing == true)
         {
            this._followBtn.visible = false;
            this._takeBackBtn.visible = true;
            DisplayObjectUtil.enableButton(this._takeBackBtn);
         }
         else
         {
            this._followBtn.visible = true;
            this._takeBackBtn.visible = false;
            DisplayObjectUtil.enableButton(this._followBtn);
         }
      }
      
      private function onTrainingBtnClick() : void
      {
         var message:String;
         var onConfirmTrainingPet:Function = null;
         var onCancelTrainingPet:Function = null;
         onConfirmTrainingPet = function():void
         {
            PetInfoManager.requestStartTrainingPet(_petInfo.catchTime);
         };
         onCancelTrainingPet = function():void
         {
            DisplayObjectUtil.enableButton(_trainingBtn);
         };
         if(PetInfoManager.getAllBagPetInfo().length <= 1)
         {
            AlertManager.showAlert("至少要留一只精灵保护你");
            return;
         }
         if(this._petInfo.level == 100)
         {
            AlertManager.showAlert("100级的精灵不需要训练");
            return;
         }
         message = "你确定要把" + this._petInfo.name + "放回小屋训练吗?";
         DisplayObjectUtil.disableButton(this._trainingBtn);
         AlertManager.showConfirm(message,onConfirmTrainingPet,onCancelTrainingPet);
      }
      
      private function onPutInStorageBtnClick() : void
      {
         if(PetInfoManager.getAllBagPetInfo().length <= 1)
         {
            AlertManager.showAlert("至少要留一只精灵保护你");
            return;
         }
         if(this._petInfo.isPetRiding)
         {
            AlertManager.showAlert("精灵当前正在骑乘中，请先收回后再放入仓库吧");
            return;
         }
         DisplayObjectUtil.disableButton(this._putInStorageBtn);
         if(this._petInfo.isInStorageBag)
         {
            PetInfoManager.requestAddToStorageFromBagStorage(this._petInfo.catchTime);
         }
         else
         {
            PetInfoManager.requestAddToStorageFromBag(this._petInfo.catchTime);
         }
      }
      
      private function onOpenStorageBtnClick() : void
      {
         StatisticsManager.sendNovice("0x10033867");
         if(true)
         {
            ModuleManager.closeForName("NewPetBagPanel");
            ModuleManager.closeForName("PetBagPanel");
            ModuleManager.showModule(URLUtil.getAppModule("PetStoragePanel"),"正在打开...");
         }
      }
      
      private function onPetType(e:MouseEvent) : void
      {
         ModuleManager.showAppModule("NewGuidelinesOld",{
            "type":"BattleEncyclopedia",
            "subType":"NatureRestriction"
         });
      }
      
      private function addPetDemoPlayer() : void
      {
         this._mainUI.addChild(this._petDemoDisplayer);
         this._petDemoDisplayer.x = 0;
         this._petDemoDisplayer.y = 60;
      }
      
      private function updateItemdisplay() : void
      {
         var index:int = 0;
         var petItemInfo:* = null;
         var itemIcon:* = null;
         var count:* = 0;
         this.removeItemdisplay();
         if(this._petInfo != null && this._petInfo.itemList.length != 0)
         {
            index = 0;
            for each(petItemInfo in this._petInfo.itemList)
            {
               if(petItemInfo.itemId != 0 && petItemInfo.itemCurrCount > 0)
               {
                  itemIcon = new IconDisplayer();
                  itemIcon.setIconUrl(ItemConfig.getItemIconUrl(petItemInfo.itemId));
                  itemIcon.x = 3 + 38 * (index % 8);
                  itemIcon.y = 324 + 38 * (int(index / 8));
                  itemIcon.scaleX = 0.6;
                  itemIcon.scaleY = 0.6;
                  addChild(itemIcon);
                  count = uint(petItemInfo.itemCurrCount);
                  TooltipManager.addCommonTip(itemIcon,ItemConfig.getItemName(petItemInfo.itemId) + ":还剩下" + "<font color=\'#FF0000\'>" + count + "</font>" + "场");
                  this._itemIconList.push(itemIcon);
                  index++;
               }
            }
         }
         if(this._petInfo != null && this._petInfo.level < 100)
         {
            Connection.addErrorHandler(CommandSet.FIGHT_USE_MEDICINE_1048,this.Err1048);
            Connection.addCommandListener(CommandSet.FIGHT_END_1507,this.Suc1507);
            Connection.send(CommandSet.FIGHT_USE_MEDICINE_1048,this._petInfo.catchTime,200202,0);
         }
      }
      
      private function Err1048(e:MessageEvent = null) : void
      {
         Connection.removeErrorHandler(CommandSet.FIGHT_USE_MEDICINE_1048,this.Err1048);
         Connection.removeCommandListener(CommandSet.FIGHT_END_1507,this.Suc1507);
      }
      
      private function Suc1507(e:MessageEvent) : void
      {
         var callBackData:FightResultInfo;
         var studyIcon:*;
         var time:*;
         var thisPetInfo:PetInfo;
         var expTimeVec:Array;
         var index:int;
         var setExpData:Function;
         var i:int;
         Connection.removeErrorHandler(CommandSet.FIGHT_USE_MEDICINE_1048,this.Err1048);
         Connection.removeCommandListener(CommandSet.FIGHT_END_1507,this.Suc1507);
         callBackData = new FightResultInfo(e.message.getRawDataCopy());
         studyIcon = null;
         time = null;
         thisPetInfo = null;
         index = 0;
         setExpData = function(i:uint):void
         {
            studyIcon = new IconDisplayer();
            studyIcon.setIconUrl(ItemConfig.getItemIconUrl(_expDataList[i].toString()));
            studyIcon.x = 2 + 38 * index;
            studyIcon.y = 360;
            studyIcon.scaleX = 0.6;
            studyIcon.scaleY = 0.6;
            addChild(studyIcon);
            time = expTimeVec[i];
            TooltipManager.addCommonTip(studyIcon,ItemConfig.getItemName(_expDataList[i]) + ":还剩下" + "<font color=\'#FF0000\'>" + time + "</font>" + "场");
            _itemIconList.push(studyIcon);
         };
         for(i = 0; i < callBackData.changedPetInfoVec.length; )
         {
            thisPetInfo = callBackData.changedPetInfoVec[i];
            if(thisPetInfo.catchTime == this._petInfo.catchTime)
            {
               break;
            }
            i++;
         }
         expTimeVec = [thisPetInfo.twoExp,thisPetInfo.threeExp,thisPetInfo.twoStudy];
         if(thisPetInfo.twoExp != 0)
         {
            setExpData(0);
            index++;
         }
         else if(thisPetInfo.threeExp != 0)
         {
            setExpData(1);
            index++;
         }
         else if(thisPetInfo.twoStudy != 0)
         {
            setExpData(2);
         }
      }
      
      private function removeItemdisplay() : void
      {
         var item:* = null;
         for each(item in this._itemIconList)
         {
            item.dispose();
            DisplayUtil.removeForParent(item);
         }
         this._itemIconList = new Vector.<IconDisplayer>();
      }
      
      private function onHpAnnimationEnter(e:Event) : void
      {
         if(this._addHpAnnimation.currentFrame == this._addHpAnnimation.totalFrames)
         {
            this._addHpAnnimation.removeEventListener("enterFrame",this.onHpAnnimationEnter);
            this._addHpAnnimation.stop();
            this._addHpAnnimation.visible = false;
         }
      }
      
      private function disableAllButton() : void
      {
         DisplayObjectUtil.disableButton(this._setFirstBtn);
         DisplayObjectUtil.disableButton(this._trainingBtn);
         DisplayObjectUtil.disableButton(this._followBtn);
         DisplayObjectUtil.disableButton(this._putInStorageBtn);
         DisplayObjectUtil.disableButton(this._takeBackBtn);
         DisplayObjectUtil.disableButton(this._petRideBackBtn);
         DisplayObjectUtil.disableButton(this._petRideBtn);
      }
      
      private function enabledAllButton() : void
      {
         DisplayObjectUtil.enableButton(this._setFirstBtn);
         DisplayObjectUtil.enableButton(this._trainingBtn);
         DisplayObjectUtil.enableButton(this._followBtn);
         DisplayObjectUtil.enableButton(this._putInStorageBtn);
         DisplayObjectUtil.enableButton(this._takeBackBtn);
         DisplayObjectUtil.enableButton(this._petRideBackBtn);
         DisplayObjectUtil.enableButton(this._petRideBtn);
      }
      
      private function onPetRideIcon(e:MouseEvent) : void
      {
         AlertManager.showConfirm("是否前往骑宠驯化场？",function():void
         {
            if(SceneManager.active.mapID != 1600)
            {
               SceneManager.changeScene(1,1600);
            }
            ModuleManager.closeForName("PetBagPanel");
         });
      }
      
      public function setData(info:PetInfo) : void
      {
         this.reset();
         this._petInfo = info;
         this._showPetDefinition = this._petInfo.getPetDefinition();
         this._isChangePet = false;
         this._currResId = 0;
         trace("ikee debug: ===>  reset _isChangePet = false");
         this.updateDisplay();
         this.updateItemdisplay();
         if(PetConfig.getPetDefinitionInfo(this._petInfo.resourceId) && PetConfig.getPetDefinitionInfo(this._petInfo.resourceId).fetter != "")
         {
            this._petFetterMC.visible = true;
            TooltipManager.addCommonTip(this._petFetterMC,PetConfig.getPetDefinitionInfo(this._petInfo.resourceId).fetter);
         }
         else
         {
            this._petFetterMC.visible = false;
         }
         if(this._petInfo.getPetDefinition() && this._petInfo.getPetDefinition().chgMonId != 0)
         {
            this._changPetBtn.visible = true;
            TooltipManager.addCommonTip(this._changPetBtn,PetConfig.getPetDefinitionInfo(this._petInfo.resourceId).changeTip);
         }
         else
         {
            this._changPetBtn.visible = false;
         }
      }
      
      private function initTest() : void
      {
         if(this._goBtn == null)
         {
            this._goBtn = this._mainUI["goBtn"];
            this._lastBtn = this._mainUI["lastBtn"];
            this._nextBtn = this._mainUI["nextBtn"];
            this._goTxt = this._mainUI["goTxt"];
            this._curTxt = this._mainUI["curTxt"];
            this._stateTxt = this._mainUI["stateTxt"];
            this._goBtn.addEventListener("click",this.onGoBtn);
            this._lastBtn.addEventListener("click",this.onLastBtn);
            this._nextBtn.addEventListener("click",this.onNextBtn);
            this._curIndex = 0;
            this.showPetByCurIndex();
         }
      }
      
      private function onGoBtn(evt:MouseEvent) : void
      {
         var index:int = this.getCurIndexByResId(int(this._goTxt.text));
         if(index == -1)
         {
            AlertManager.showAlert("当前输入的精灵id:" + int(this._goTxt.text) + "配置表中没有配置，请验证下!");
            return;
         }
         this._curIndex = index;
         this.showPetByCurIndex();
      }
      
      private function getCurIndexByResId(id:int) : int
      {
         var i:int = 0;
         var index:* = -1;
         var petMap:Array = PetConfig.petDefinitionMap.getValues();
         i = 0;
         while(i < petMap.length)
         {
            if((petMap[i] as PetDefinition).resId == id)
            {
               index = i;
               break;
            }
            i++;
         }
         return index;
      }
      
      private function onLastBtn(evt:MouseEvent) : void
      {
         if(this._curIndex == 0)
         {
            return;
         }
         --this._curIndex;
         this.showPetByCurIndex();
      }
      
      private function onNextBtn(evt:MouseEvent) : void
      {
         if(this._curIndex > PetConfig.petDefinitionMap.getValues().length - 1)
         {
            return;
         }
         ++this._curIndex;
         this.showPetByCurIndex();
      }
      
      private function showPetByCurIndex() : void
      {
         this._currResId = (PetConfig.petDefinitionMap.getValues()[this._curIndex] as PetDefinition).resId;
         this._curTxt.text = this._currResId.toString();
         this._stateTxt.text = (this._curIndex + 1).toString() + "/" + PetConfig.petDefinitionMap.getValues().length.toString();
         this.showPetCurIndex();
      }
      
      private function showPetCurIndex() : void
      {
         this._petDemoDisplayer.newSetUrl(URLUtil.getPetDemo(this._currResId));
         this._showPetDefinition = PetConfig.getPetDefinition(this._currResId);
         this.updateDisplay();
      }
      
      public function updateDisplay() : void
      {
         var skinName:String = null;
         var i:int = 0;
         var starNum:* = 0;
         if(this._petInfo == null)
         {
            return;
         }
         if(this._showPetDefinition == null)
         {
            return;
         }
         this.funBtnsChange();
         if(PetRideShopConfig.isCanRidePet(this._petInfo.resourceId))
         {
            this._petRideIcon.visible = true;
            if(this._petInfo.petRideChipId == 0)
            {
               this._petRideIcon.gotoAndStop(1);
               if(this._petRideIcon.hasEventListener("click") == false)
               {
                  this._petRideIcon.addEventListener("click",this.onPetRideIcon);
               }
            }
            else
            {
               this._petRideIcon.visible = true;
               this._petRideIcon.gotoAndStop(2);
            }
         }
         else
         {
            this._petRideIcon.visible = false;
         }
         if(this._petInfo.evolveLevel != 0)
         {
            starNum = uint(PetEvolveConfig.getStarNum(this._petInfo.evolveLevel));
            i = 0;
            while(i < 4)
            {
               this._starList[i].visible = true;
               if(i < starNum)
               {
                  if(this._petInfo.evolveLevel <= 4)
                  {
                     this._starList[i].gotoAndStop(2);
                  }
                  else if(this._petInfo.evolveLevel <= 8)
                  {
                     this._starList[i].gotoAndStop(4);
                  }
                  else if(this._petInfo.evolveLevel <= 1004)
                  {
                     this._starList[i].gotoAndStop(6);
                  }
                  else
                  {
                     this._starList[i].gotoAndStop(8);
                  }
               }
               else if(this._petInfo.evolveLevel <= 4)
               {
                  this._starList[i].gotoAndStop(1);
               }
               else if(this._petInfo.evolveLevel <= 8)
               {
                  this._starList[i].gotoAndStop(3);
               }
               else if(this._petInfo.evolveLevel <= 1004)
               {
                  this._starList[i].gotoAndStop(5);
               }
               else
               {
                  this._starList[i].gotoAndStop(7);
               }
               i++;
            }
            this.mainUI.evolveShadeMc.visible = true;
            if(this._petInfo.evolveLevel <= 4)
            {
               this.mainUI.evolveShadeMc.gotoAndStop(1);
            }
            else if(this._petInfo.evolveLevel <= 8)
            {
               this.mainUI.evolveShadeMc.gotoAndStop(2);
            }
            else if(this._petInfo.evolveLevel <= 1004)
            {
               this.mainUI.evolveShadeMc.gotoAndStop(3);
            }
            else
            {
               this.mainUI.evolveShadeMc.gotoAndStop(4);
            }
         }
         else
         {
            this.mainUI.evolveShadeMc.visible = false;
            i = 0;
            while(i < 4)
            {
               this._starList[i].visible = false;
               this._starList[i].gotoAndStop(1);
               i++;
            }
         }
         this._nameTxt.text = this._showPetDefinition.name;
         if(PetSkinConfig.getSkinId(this._showPetDefinition.resId) && PetSkinConfig.getSkinId(this._showPetDefinition.resId) != this._showPetDefinition.resId)
         {
            /*skinName = String(PetSkinDefineConfig.getSkinName(this._showPetDefinition.resId,uint(PetSkinConfig.getSkinId(this._showPetDefinition.resId))));
            if(skinName != "未知" && skinName != "")
            {
               this._nameTxt.text = skinName;
            }*/
            skinName = PetConfig.getPetDefinition(PetSkinConfig.getSkinId(uint(this._showPetDefinition.resId))).name;
         }
         this._petDemoDisplayer.newSetUrl(URLUtil.getPetDemo(this._showPetDefinition.resId));
         this._petTypeIcon.type = this._showPetDefinition.type;
         TooltipManager.addCommonTip(this._petTypeIcon,PetTypeNameMap.getTypeName(this._showPetDefinition.type));
         this._sexIcon.gotoAndStop(this._petInfo.sex + 1);
         TooltipManager.addCommonTip(this._sexIcon,PetTypeNameMap.getPetSex(this._petInfo.sex));
         if(this._petInfo.isInStorageBag)
         {
            this.funBtnsChange();
         }
         else
         {
            this.updateButtonStatus();
         }
         var petDefinition:PetDefinition = this._showPetDefinition;
         this._featureIcon.setFeature(petDefinition.featureId,petDefinition.featureDescription);
         this._twoMC.visible = this._petInfo.isTwoPet == true ? true : false;
         TooltipManager.remove(this._skinMC);
         this._skinMC.visible = false;
         if(PetSkinConfig.getSkinId(uint(this._showPetDefinition.resId)) != 0 && PetSkinConfig.getSkinId(uint(this._showPetDefinition.resId)) != this._showPetDefinition.resId)
         {
            this._skinMC.visible = true;
            if(PetSkinConfig.getSkinId(uint(this._showPetDefinition.resId)) < 10000)
            {
               TooltipManager.addCommonTip(this._skinMC,"精灵 " + this._showPetDefinition.name + " 正在使用皮肤 " + skinName);
            }
            else
            {
               TooltipManager.addCommonTip(this._skinMC,"精灵 " + this._showPetDefinition.name + " 正在使用皮肤 " + skinName);
            }
         }
         this._starLevel.gotoAndStop(this._showPetDefinition.starLevel);
      }
      
      private function funBtnsChange() : void
      {
         DisplayObjectUtil.disableButton(this._setFirstBtn);
         DisplayObjectUtil.disableButton(this._trainingBtn);
         DisplayObjectUtil.disableButton(this._followBtn);
         DisplayObjectUtil.disableButton(this._takeBackBtn);
         DisplayObjectUtil.disableButton(this._petRideBackBtn);
         DisplayObjectUtil.disableButton(this._petRideBtn);
         DisplayObjectUtil.enableButton(this._putInStorageBtn);
         DisplayObjectUtil.enableButton(this._goFight);
      }
      
      public function get petInfo() : PetInfo
      {
         return this._petInfo;
      }
      
      public function reset() : void
      {
         this._nameTxt.text = "";
         this._sexIcon.gotoAndStop(1);
         this._addHpAnnimation.visible = false;
         this._petTypeIcon.clear();
         this.disableAllButton();
      }
      
      public function updateButtonStatus() : void
      {
         this.enabledAllButton();
         DisplayObjectUtil.disableButton(this._goFight);
         if(this._petInfo.isFollowing)
         {
            this._followBtn.visible = false;
            this._takeBackBtn.visible = true;
            DisplayObjectUtil.enableButton(this._takeBackBtn);
         }
         else
         {
            this._followBtn.visible = true;
            this._takeBackBtn.visible = false;
            DisplayObjectUtil.enableButton(this._followBtn);
         }
         if(this._petInfo.isStarting)
         {
            DisplayObjectUtil.disableButton(this._setFirstBtn);
         }
         if(this._petInfo.isPetRiding)
         {
            this._petRideBtn.filters = [];
            this._petRideBackBtn.visible = true;
            this._petRideBtn.visible = false;
            DisplayObjectUtil.enableButton(this._petRideBackBtn);
         }
         else if(this._petInfo.petRideChipId != 0)
         {
            this._petRideBackBtn.visible = false;
            this._petRideBtn.visible = true;
            DisplayObjectUtil.enableButton(this._petRideBtn);
         }
         else if(PetRideShopConfig.isCanRidePet(this._petInfo.resourceId))
         {
            this._petRideBackBtn.visible = false;
            this._petRideBtn.visible = true;
            ColorFilter.setGrayscale(this._petRideBtn);
         }
         else
         {
            this._petRideBackBtn.visible = false;
            this._petRideBtn.visible = true;
            DisplayObjectUtil.disableButton(this._petRideBtn);
         }
      }
      
      public function showHpAnnimation(info:PetInfo = null) : void
      {
         if(this._petInfo != null && info != null && info.catchTime == this._petInfo.catchTime)
         {
            this._addHpAnnimation.visible = true;
            this._addHpAnnimation.addEventListener("enterFrame",this.onHpAnnimationEnter);
            this._addHpAnnimation.gotoAndPlay(1);
         }
         else
         {
            this._addHpAnnimation.visible = true;
            MovieClipUtil.playMc(this._addHpAnnimation,1,this._addHpAnnimation.totalFrames,function():void
            {
               _addHpAnnimation.visible = true;
            });
         }
      }
      
      public function dispose() : void
      {
      }
   }
}
