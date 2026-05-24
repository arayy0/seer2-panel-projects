package com.taomee.seer2.module.app.versionOnePetBagPanel
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.arena.data.FightResultInfo;
   import com.taomee.seer2.app.arena.data.RevenueInfo;
   import com.taomee.seer2.app.config.EvolveConfig;
   import com.taomee.seer2.app.config.GadConfig;
   import com.taomee.seer2.app.config.PetRideShopConfig;
   import com.taomee.seer2.app.config.StoneConfig;
   import com.taomee.seer2.app.config.info.StoneInfo;
   import com.taomee.seer2.app.config.pet.PetDefinition;
   import com.taomee.seer2.app.event.LogicEvent;
   import com.taomee.seer2.app.guide.manager.GuideManager;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.inventory.events.ItemEvent;
   import com.taomee.seer2.app.inventory.item.PetItem;
   import com.taomee.seer2.app.manager.FightResultPanelWrapper;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.net.parser.Parser_1142;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.pet.events.PetInfoEvent;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.popup.ServerMessager;
   import com.taomee.seer2.app.processor.quest.handler.main.quest99.QuestMapHandler_99_80491;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.app.swap.special.SpecialInfo;
   import com.taomee.seer2.core.inventory.Item;
   import com.taomee.seer2.core.module.ModuleEvent;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.events.ModelLocator;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.appraisal.AppraisalResultPanel;
   import com.taomee.seer2.module.app.petBag.helper.PetBagLearningPointHelper;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.util.PetItemCell;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import org.taomee.utils.Tick;
   
   public class PetItemBagPanel extends Sprite
   {
      
      private static const PET_ITEM_TYPE_VECTOR:Vector.<int> = Vector.<int>([2,7,8,10,11,12,13,14,19,20,15,16,18,24]);
      
      private static const PAGE_SIZE:uint = 36;
      
      private static const FOR_LIST:Array = [204644];
      
      private static const FILTER_TYPE:Array = [[0],[11,7,16],[8,12],[14,20,19],[2,17,18],[10],[-1]];
      
      private static const doubleExpList:Array = [200574,200575,200576,200577,200578,200579];
      
      private static const shopItemList:Array = [201010,201011,201012];
       
      
      private var _bagPanel:PetBagPanel;
      
      private var _petTabPanel:PetTabPanel;
      
      private var _container:MovieClip;
      
      private var _nextBtn:SimpleButton;
      
      private var _prevBtn:SimpleButton;
      
      private var _pageTxt:TextField;
      
      private var _recovery:SimpleButton;
      
      private var _itemContainer:Sprite;
      
      private var _petItemCellVec:Vector.<PetItemCell>;
      
      private var _petItemDataVec:Vector.<Item>;
      
      private var _qualityItemNum:TextField;
      
      private var _searchTxt:TextField;
      
      private var _searchBtn:SimpleButton;
      
      private var _tabList:Vector.<MovieClip>;
      
      private var _pageIndex:uint;
      
      private var _pageCount:uint;
      
      private var _petInfo:PetInfo;
      
      private var _appResultPanel:AppraisalResultPanel;
      
      private var _curSortIndex:int = 0;
      
      private var _curStyle:int;
      
      private var _keepPage:Boolean;
      
      private var _currentUseItemId:int;
      
      private var petItem:PetItem;
      
      private var useNum:int = 1;
      
      private var _oldPetInfo:PetInfo;
      
      private var _data:ByteArray;
      
      private var _isRecover:Boolean = false;
      
      public function PetItemBagPanel(bagPanel:PetBagPanel, petTabPanel:PetTabPanel)
      {
         super();
         this._bagPanel = bagPanel;
         this._petTabPanel = petTabPanel;
         this.createChildren();
         this.initEvent();
      }
      
      private function createChildren() : void
      {
         var i:int = 0;
         var cell:PetItemCell = null;
         this._container = new PetItemBagUI();
         addChild(this._container);
         this._container.x = 856;
         this._container.y = 54;
         this._nextBtn = this._container["pageBar"]["nextBtn"];
         this._prevBtn = this._container["pageBar"]["prevBtn"];
         this._pageTxt = this._container["pageBar"]["pageTxt"];
         this._pageTxt.text = "";
         //this._recovery = this._container["recovery"];
         //this._recovery.addEventListener("click",this.onRecovery);
         //this._qualityItemNum = this._container["qualityItemNum"];
         this._itemContainer = new Sprite();
         this._itemContainer.x = 622;
         this._itemContainer.y = 115;
         addChild(this._itemContainer);
         var rowCount:int = 6;
         var horizontalPadding:int = 51;
         var verticalPadding:int = 51;
         this._petItemCellVec = new Vector.<PetItemCell>();
         for(i = 0; i < 36; )
         {
            (cell = new PetItemCell()).x = horizontalPadding * (i % rowCount) - 8;
            cell.y = verticalPadding * (int(i / rowCount));
            this._itemContainer.addChild(cell);
            cell.addEventListener("itemUse",this.onPetItemUse);
            this._petItemCellVec.push(cell);
            i++;
         }
         this._searchTxt = this._container["searchTxt"];
         this._searchTxt.text = "输入关键词";
         this._searchBtn = this._container["searchBtn"];
         this._tabList = new Vector.<MovieClip>();
         for(i = 0; i < 7; )
         {
            this._tabList.push(this._container["tab" + i]);
            this._tabList[i].buttonMode = true;
            this._tabList[i].gotoAndStop(1);
            i++;
         }
      }
      
      private function initEvent() : void
      {
         var item:MovieClip = null;
         this._prevBtn.addEventListener("click",this.onPrevBtnClick);
         this._nextBtn.addEventListener("click",this.onNextBtnClick);
         this._searchTxt.addEventListener("keyDown",this.onKeyDown);
         this._searchTxt.addEventListener("mouseDown",this.onMouseDown);
         this._searchBtn.addEventListener("click",this.onSearchBtn);
         for each(item in this._tabList)
         {
            item.addEventListener("click",this.onTabClick);
         }
      }
      
      private function onTabClick(evt:MouseEvent) : void
      {
         this._tabList[this._curSortIndex].gotoAndStop(1);
         if(Boolean(evt))
         {
            this._curSortIndex = this._tabList.indexOf(evt.currentTarget as MovieClip);
         }
         this._tabList[this._curSortIndex].gotoAndStop(2);
         if(evt != null)
         {
            this._curStyle = 0;
         }
         this.updateItem();
      }
      
      private function onKeyDown(evt:KeyboardEvent) : void
      {
         var tmpStr:String = this._searchTxt.text;
         tmpStr = tmpStr.replace("\n","");
         if(evt.keyCode == 13)
         {
            this._searchTxt.text = tmpStr;
            this.onSearchBtn(null);
         }
      }
      
      private function onMouseDown(evt:MouseEvent) : void
      {
         if(evt.currentTarget.text == "输入关键词")
         {
            evt.currentTarget.text = "";
         }
      }
      
      private function onSearchBtn(evt:MouseEvent) : void
      {
         var searchStr:String = this._searchTxt.text;
         var searchStrArr:Array = searchStr.split(/[\s,\/!\\]+/);
         if(searchStrArr.length == 0)
         {
            AlertManager.showAlert("请输入要搜索的关键字~");
            return;
         }
         this._curStyle = 1;
         this.updateItem();
      }
      
      private function onRecovery(evt:MouseEvent = null) : void
      {
         ModuleManager.addEventListener("QualityItemRecoveryPanel","hide",(function():*
         {
            var onRecoveryHide:Function;
            return onRecoveryHide = function(evt:ModuleEvent):void
            {
               ModuleManager.removeEventListener("GoSchoolSignPanel","hide",onRecoveryHide);
               //updateQualityVal();
            };
         })());
         ModuleManager.showAppModule("QualityItemRecoveryPanel");
      }
      
      private function onPetItemUse(evt:Event) : void
      {
         var item:Item = null;
         var cell:PetItemCell = null;
         var itemArr:Array = null;
         var indexArr:Array = null;
         var countArr:Array = null;
         var vipIndex:int = 0;
         var ob:Object = null;
         var itemIDs:Array = null;
         var counts:Array = null;
         var swapIDs:Array = null;
         var index:int = 0;
         var obj:Object = null;
         var specialItems:Array = null;
         var data:* = undefined;
         var currentCell:PetItemCell = evt.currentTarget as PetItemCell;
         item = currentCell.item;
         if(item.category == 2)
         {
            this.petItem = PetItem(item);
            if(this.petItem.type == 2)
            {
               if(this._petInfo.hp < this._petInfo.maxHp)
               {
                  this.usePetItem(this.petItem);
               }
               else
               {
                  AlertManager.showAlert("这只精灵不需要恢复体力");
               }
            }
            else if(this.petItem.type == 7 || this.petItem.type == 11)
            {
               if(this._petInfo.level < 100)
               {
                  if(this.petItem.experience == 0)
                  {
                     this.useNum = 1;
                     this.usePetItem(this.petItem);
                  }
                  else
                  {
                     this.showUseNumPane(currentCell);
                  }
               }
               else
               {
                  AlertManager.showAlert("你的精灵已经是最高等级");
               }
            }
            else if(this.petItem.type == 8)
            {
               itemArr = [200234,200235,200236,200637,201037,201038,200239,200240,200241];
               indexArr = [1440,1440,1440,1440,1440,1440,1440,1440,1440];
               countArr = [10,15,20,5,40,510,40,510,5];
               if(itemArr.indexOf(this.petItem.referenceId) != -1)
               {
                  vipIndex = itemArr.indexOf(this.petItem.referenceId);
                  ob = {};
                  ob.type = 5;
                  ob.index = indexArr[vipIndex];
                  ob.cost = 0;
                  ob.count = countArr[vipIndex];
                  ob.fun = null;
                  ModuleManager.toggleModule(URLUtil.getAppModule("VipPetBagPanel"),"正在打开vip精灵面板...",ob);
                  return;
               }
               if(PetBagLearningPointHelper.canChangeLearningPointByItem(this.petItem.referenceId))
               {
                  if(this._petInfo.learningInfo.pointAtk == 0 && this._petInfo.learningInfo.pointDefence == 0 && this._petInfo.learningInfo.pointSpecialAtk == 0 && this._petInfo.learningInfo.pointSpecialDefence == 0 && this._petInfo.learningInfo.pointHp == 0 && this._petInfo.learningInfo.pointSpeed == 0)
                  {
                     AlertManager.showAlert("这只精灵不需要重置学习力");
                  }
                  else
                  {
                     AlertManager.showConfirm("你确定要为这只精灵重置学习力吗？",function():void
                     {
                        _currentUseItemId = petItem.referenceId;
                        DisplayObjectUtil.disableSprite(this as Sprite);
                        PetInfoManager.addEventListener("petPropertiesChange",onPetPropertiesChange);
                        PetBagLearningPointHelper.changeLearningPointByItem(_petInfo.catchTime,_currentUseItemId);
                     });
                  }
               }
               else
               {
                  itemIDs = [200256];
                  counts = [720];
                  swapIDs = [4483];
                  index = itemIDs.indexOf(this.petItem.referenceId);
                  if(index != -1)
                  {
                     obj = {};
                     obj.type = 6;
                     obj.index = swapIDs[index];
                     obj.cost = 0;
                     obj.count = counts[index];
                     obj.fun = null;
                     ModuleManager.toggleModule(URLUtil.getAppModule("VipPetBagPanel"),"正在打开vip精灵面板...",obj);
                     return;
                  }
                  this.useAppraisalItem(this.petItem);
               }
            }
            else if(this.petItem.type == 10)
            {
               if(EvolveConfig.canEvolve(this._petInfo.resourceId,this._petInfo.level,item.referenceId))
               {
                  this.branchEvolute(this._petInfo.catchTime,item.referenceId);
               }
               else
               {
                  switch(int(EvolveConfig.getMonEvolveError(this._petInfo.resourceId,this._petInfo.level,item.referenceId)))
                  {
                     case 0:
                        AlertManager.showAlert("该精灵无法使用此芯片！");
                        break;
                     case 1:
                        AlertManager.showAlert("该精灵无法使用此芯片！");
                        break;
                     case 2:
                        AlertManager.showAlert("精灵等级达到<font color=\'#ff0000\'>" + EvolveConfig.getEvolveLevel(this._petInfo.resourceId) + "级</font>才可以使用进化芯片");
                        break;
                     default:
                        AlertManager.showAlert("该精灵无法使用此芯片！");
                  }
               }
            }
            else if(this.petItem.type == 12)
            {
               specialItems = [201119,208354];
               if(specialItems.indexOf(item.referenceId) != -1)
               {
                  data = {};
                  data.petInfo = this._petInfo;
                  data.callBack = function(index:int):void
                  {
                     SwapManager.swapItem(4558,1,function(data:IDataInput):void
                     {
                        reducePetItem(item.referenceId);
                        _petInfo.character = index;
                        updatePetBag();
                     },null,new SpecialInfo(2,_petInfo.catchTime,index));
                  };
                  ModuleManager.showAppModule("CharaSelectPanel",data);
               }
               else
               {
                  changeCharecter(_petInfo.catchTime,item.referenceId);
               }
            }
            else if(this.petItem.type == 18)
            {
               AlertManager.showConfirm("你确定要对这只精灵使用" + item.name + "吗？",function():void
               {
                  usePetItem(petItem);
               });
            }
            else if(this.petItem.type == 13)
            {
               this.showMedal(this.petItem.referenceId);
            }
            else if(this.petItem.type == 14)
            {
               this.showGad(this.petItem.referenceId);
            }
            else if(this.petItem.type == 24)
            {
               this.showPetRide(this.petItem.referenceId);
            }
            else if(this.petItem.type == 19)
            {
               this.showDecoration(this.petItem.referenceId);
            }
            else if(this.petItem.type == 20)
            {
               this.showStone(this.petItem.referenceId);
            }
            else if(this.petItem.type == 15)
            {
               this.exchangePetSoul(this.petItem);
            }
            else if(this.petItem.type == 16)
            {
               if(this.petItem.referenceId == 201012 && this._petInfo.learningInfo.pointTotal() >= 510)
               {
                  AlertManager.showAlert("这只精灵的学习力已经满了");
                  return;
               }
               if(this.petItem.referenceId == 201010 || this.petItem.referenceId == 201011)
               {
                  if(this._petInfo.level >= 100)
                  {
                     AlertManager.showAlert("你的精灵已经是最高等级");
                     return;
                  }
               }
               AlertManager.showConfirm("你确定要对这只精灵使用" + item.name + "吗？",function():void
               {
                  usePetItem(petItem);
               });
            }
            else
            {
               this.usePetItem(this.petItem);
            }
         }
         for each(cell in this._petItemCellVec)
         {
            if(cell == currentCell)
            {
               cell.isSelected = true;
            }
            else
            {
               cell.isSelected = false;
            }
         }
      }
      
      private function exchangePetSoul(petItem:PetItem) : void
      {
         SwapManager.swapItem(petItem.swapId,1,function(data:IDataInput):void
         {
            var swapInfo:SwapInfo = new SwapInfo(data);
            reducePetItem(petItem.referenceId);
         });
      }
      
      private function showUseNumPane(cell:PetItemCell) : void
      {
         ItemManager.addEventListener1("batch_use",this.usePetProp);
         var data:Object = {};
         data.petinfo = this._petInfo;
         data.item = cell.item;
         ModuleManager.toggleModule(URLUtil.getAppModule("BatchPanel"),"正在打开使用道具界面",data);
      }
      
      private function usePetProp(event:ItemEvent) : void
      {
         ItemManager.removeEventListener1("batch_use",this.usePetProp);
         this.useNum = event.content;
         this.usePetItem(this.petItem);
      }
      
      private function showMedal(id:uint) : void
      {
         var obj:Object = {};
         obj.fun = this.reducePetItem;
         obj.itemId = id;
         switch(int(id) - 200536)
         {
            case 0:
               obj.index = 1;
               ModuleManager.toggleModule(URLUtil.getAppModule("QuestSelectRewardPanel"),"正在打开主线任务奖励面板...",obj);
               break;
            case 1:
               obj.index = 2;
               ModuleManager.toggleModule(URLUtil.getAppModule("QuestSelectRewardPanel"),"正在打开主线任务奖励面板...",obj);
               break;
            case 2:
               obj.index = 3;
               ModuleManager.toggleModule(URLUtil.getAppModule("QuestSelectRewardPanel"),"正在打开主线任务奖励面板...",obj);
         }
      }
      
      private function showGad(id:uint) : void
      {
         var obj:Object = null;
         obj = {};
         obj.fun = this.updateItem;
         obj.is1079 = false;
         if(id == 200664 && PetInfoManager.getResPetInfo(820) && PetInfoManager.getResPetInfo(387) == null)
         {
            SwapManager.swapItem(3473,1,function(data:IDataInput):void
            {
               new SwapInfo(data,false);
               entryGad(obj,208228);
            });
         }
         else
         {
            this.entryGad(obj,id);
         }
      }
      
      private function entryGad(obj:Object, id:uint) : void
      {
         var petDefiniton:PetDefinition = null;
         var pet:PetInfo = null;
         var petInfo:PetInfo = null;
         var arr:Array = GadConfig.formIdGetGadInfo(id);
         obj.petId = arr[0];
         obj.swapId = arr[1];
         obj.sId = 0;
         obj.id = id;
         var petInfoVec:Vector.<PetInfo> = Vector.<PetInfo>([]);
         for each(petInfo in PetInfoManager.getTotalBagPetInfo())
         {
            if(petInfo.bunchId == obj.petId)
            {
               petInfoVec.push(petInfo);
            }
            else if(obj.petId == 147)
            {
               petInfoVec.push(petInfo);
            }
            else if(petInfo.resourceId == 388 && (id == 203038 || id == 200659))
            {
               petInfoVec.push(petInfo);
            }
         }
         if(petInfoVec.length <= 0)
         {
            AlertManager.showAlert("对不起，你的出战背包中没有该精灵");
            return;
         }
         petInfoVec.length = 0;
         petInfoVec = null;
         if(obj.petId != undefined)
         {
            ModuleManager.addEventListener("GadSelectPetPanel","dispose",this.onGadDispose);
            ModuleManager.toggleModule(URLUtil.getAppModule("GadSelectPetPanel"),"正在打开纹章兑换面板...",obj);
         }
      }
      
      private function onGadDispose(event:ModuleEvent) : void
      {
         if(event.name == "GadSelectPetPanel")
         {
            ModuleManager.removeEventListener("GadSelectPetPanel","dispose",this.onGadDispose);
            this.updatePetBag();
         }
      }
      
      private function showPetRide(id:uint) : void
      {
         var petInfo:PetInfo = null;
         var a:Boolean = false;
         var b:int = 0;
         var c:int = 0;
         var d:Boolean = false;
         var info:Object;
         (info = {}).callBack = this.updateItem;
         info.id = id;
         info.swapId = PetRideShopConfig.getSwapIdByItemId(id);
         var petVecs:Vector.<PetInfo> = new Vector.<PetInfo>([]);
         for each(petInfo in PetInfoManager.getTotalBagPetInfo())
         {
            a = Boolean(PetRideShopConfig.isCanRidePet(petInfo.resourceId));
            b = int(PetRideShopConfig.getFreeChipIdByPetId(petInfo.resourceId));
            c = int(PetRideShopConfig.getMiBiChipIdByPetId(petInfo.resourceId));
            d = petInfo.petRideChipId == 0 ? true : false;
            if(a == true && (b > 0 || c > 0) && d)
            {
               petVecs.push(petInfo);
            }
         }
         if(petVecs.length <= 0)
         {
            AlertManager.showAlert("您的背包中没有该精灵或该精灵已经拥有骑乘晶片");
            return;
         }
         ModuleManager.addEventListener("PetRideSelectPetPanel","dispose",this.onPetRideDispose);
         ModuleManager.toggleModule(URLUtil.getAppModule("PetRideSelectPetPanel"),"正在打开面板...",info);
      }
      
      private function onPetRideDispose(event:ModuleEvent) : void
      {
         if(event.name == "PetRideSelectPetPanel")
         {
            ModuleManager.removeEventListener("PetRideSelectPetPanel","dispose",this.onPetRideDispose);
            this.updatePetBag();
         }
      }
      
      private function showDecoration(id:uint) : void
      {
         var petDefiniton:PetDefinition = null;
         var pet:PetInfo = null;
         var petInfo:PetInfo = null;
         var obj:Object;
         (obj = {}).fun = this.updateItem;
         var arr:Array = GadConfig.formIdGetGadInfo(id);
         obj.petId = arr[0];
         obj.swapId = arr[1];
         obj.sId = 0;
         var petInfoVec:Vector.<PetInfo> = Vector.<PetInfo>([]);
         for each(petInfo in PetInfoManager.getAllBagPetInfo())
         {
            if(petInfo.bunchId == obj.petId)
            {
               petInfoVec.push(petInfo);
            }
         }
         if(petInfoVec.length <= 0)
         {
            AlertManager.showAlert("对不起，你的出战背包中没有该精灵");
            return;
         }
         petInfoVec.length = 0;
         petInfoVec = null;
         if(obj.petId != undefined)
         {
            ModuleManager.addEventListener("DecorationsSelectPetPanel","AddDecorationStrongOk",this.onSucessDecorationsPanel);
            ModuleManager.toggleModule(URLUtil.getAppModule("DecorationsSelectPetPanel"),"正在打开饰品兑换面板...",obj);
         }
      }
      
      private function showStone(id:uint) : void
      {
         var petDefiniton:PetDefinition = null;
         var pet:PetInfo = null;
         var petInfo:PetInfo = null;
         var stoneInfo:StoneInfo = StoneConfig.getInfo(id);
         var petInfoVec:Vector.<PetInfo> = Vector.<PetInfo>([]);
         for each(petInfo in PetInfoManager.getAllBagPetInfo())
         {
            if(petInfo.bunchId == stoneInfo.petId)
            {
               petInfoVec.push(petInfo);
            }
         }
         if(petInfoVec.length <= 0)
         {
            AlertManager.showAlert("对不起，你的出战背包中没有该精灵");
            return;
         }
         if(stoneInfo != null)
         {
            ModuleManager.addEventListener("StoneSelectPetPanel","StoneStrongOK",this.onSucessStonePanel);
            ModuleManager.toggleModule(URLUtil.getAppModule("StoneSelectPetPanel"),"正在打开强化石面板...",stoneInfo);
         }
      }
      
      private function onSucessStonePanel(evr:ModuleEvent) : void
      {
         ModuleManager.removeEventListener("StoneSelectPetPanel","StoneStrongOK",this.onSucessStonePanel);
         this.updatePetBag();
      }
      
      private function onSucessDecorationsPanel(evr:ModuleEvent) : void
      {
         ModuleManager.removeEventListener("DecorationsSelectPetPanel","AddDecorationStrongOk",this.onSucessDecorationsPanel);
         this.updatePetBag();
      }
      
      private function onPetPropertiesChange(evt:PetInfoEvent) : void
      {
         if(evt.info.catchTime == this._petInfo.catchTime)
         {
            ServerMessager.addMessage(this._petInfo.name + "的学习力被重置了可以重新分配");
            DisplayObjectUtil.enableSprite(this);
            PetInfoManager.removeEventListener("petPropertiesChange",this.onPetPropertiesChange);
            this.reducePetItem(this._currentUseItemId);
            this.setData(this._petInfo);
         }
      }
      
      private function branchEvolute(petId:uint, itemId:int) : void
      {
         this.reducePetItem(itemId);
         this._isRecover = false;
         PetInfoManager.addEventListener("petExperenceChange",this.onBranchEvolution);
         Connection.addCommandListener(CommandSet.BRANCH_EVOLUTION_1117,this.onEvolution);
         Connection.send(CommandSet.BRANCH_EVOLUTION_1117,petId,itemId);
      }
      
      private function onEvolution(evt:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.BRANCH_EVOLUTION_1117,this.onEvolution);
         this._data = evt.message.getRawData();
         var count:uint = this._data.readUnsignedInt();
         if(count == 0)
         {
            this._data.readUnsignedInt();
            this._isRecover = true;
         }
      }
      
      private function changeCharecter(petId:uint, itemId:int) : void
      {
         Connection.addCommandListener(CommandSet.CHANGE_CHARECTER_1169,this.onChangeCharecter);
         Connection.addErrorHandler(CommandSet.CHANGE_CHARECTER_1169,this.onError1169);
         Connection.send(CommandSet.CHANGE_CHARECTER_1169,petId,itemId);
      }
      
      private function onError1169(event:MessageEvent) : void
      {
         Connection.removeCommandListener(CommandSet.CHANGE_CHARECTER_1169,this.onChangeCharecter);
         Connection.removeErrorHandler(CommandSet.CHANGE_CHARECTER_1169,this.onError1169);
         if(event.message.statusCode == 200020)
         {
            AlertManager.showAlert("此精灵不能使用这个物品!");
         }
      }
      
      private function onChangeCharecter(evt:MessageEvent) : void
      {
         var data:ByteArray = null;
         var itemId:* = 0;
         var animation:* = null;
         Connection.removeErrorHandler(CommandSet.CHANGE_CHARECTER_1169,this.onError1169);
         Connection.removeCommandListener(CommandSet.CHANGE_CHARECTER_1169,this.onChangeCharecter);
         data = evt.message.getRawDataCopy();
         PetInfo.readBaseInfo(this._petInfo,data);
         itemId = data.readUnsignedInt();
         this.reducePetItem(itemId);
         updatePetBag();
         _petTabPanel.changeTab(0);
      }
      
      private function onBranchEvolution(evt:PetInfoEvent) : void
      {
         var wrapper:FightResultPanelWrapper = null;
         var resultInfo:FightResultInfo = evt.content.resultInfo;
         if(resultInfo.endReason == 106)
         {
            PetInfoManager.removeEventListener("petExperenceChange",this.onBranchEvolution);
            wrapper = new FightResultPanelWrapper();
            wrapper.show(Vector.<PetInfo>([this._petInfo]),null,resultInfo);
            wrapper.addEventListener("complete",this.updateEvolution);
         }
      }
      
      private function updateEvolution(evt:Event) : void
      {
         if(this._isRecover == true)
         {
            PetInfo.readPetInfo(this._petInfo,this._data);
         }
         this.updatePetBag();
      }
      
      private function updatePetBag(evt:Event = null) : void
      {
         if(Boolean(this._bagPanel))
         {
            this._bagPanel.updateSelectedPet();
         }
         if(Boolean(this._petTabPanel))
         {
            this._petTabPanel.updatePet();
         }
      }
      
      private function useAppraisalItem(petItem:PetItem) : void
      {
         var petBagItemPanel:PetItemBagPanel = null;
         var confirmHandler:Function = null;
         var gotoAppraisal:Function = function(id:uint):void
         {
            if(id != 200230 && id != 201035)
            {
               AlertManager.showConfirm("确定重新随机精灵资质吗？有资质变差的风险哦！",confirmHandler);
            }
            else
            {
               AlertManager.showConfirm("稳定提高1点资质，珍惜使用哦！",confirmHandler);
            }
         };
         confirmHandler = function():void
         {
            DisplayObjectUtil.disableSprite(petBagItemPanel);
            reducePetItem(petItem.referenceId);
            _currentUseItemId = petItem.referenceId;
            _oldPetInfo = clone(_petInfo);
            Connection.addCommandListener(CommandSet.ITEM_APPRISAL_1116,onUsedApprisalPetItem);
            Connection.send(CommandSet.ITEM_APPRISAL_1116,petItem.referenceId,_petInfo.catchTime);
         };
         AlertManager.showAlert("老的资质物品已经不能使用了哦，兑换新物品吧！",function():void
         {
            onRecovery();
         });
      }
      
      public function clone(petInfo:PetInfo) : PetInfo
      {
         var info:PetInfo = new PetInfo();
         info.atk = petInfo.atk;
         info.potential = petInfo.potential;
         info.defence = petInfo.defence;
         info.specialAtk = petInfo.specialAtk;
         info.specialDefence = petInfo.specialDefence;
         info.speed = petInfo.speed;
         info.hp = petInfo.hp;
         return info;
      }
      
      private function checkMainPet(petInfo:PetInfo) : Boolean
      {
         var petIds:Array = [1,2,4,5,7,8];
         if(petIds.indexOf(petInfo.resourceId) != -1)
         {
            return true;
         }
         return false;
      }
      
      private function onUsedApprisalPetItem(event:MessageEvent) : void
      {
         var data:IDataInput;
         var petInfo:PetInfo = null;
         var apprisalPetInfo:PetInfo = null;
         var anim:MovieClip = null;
         var onAnimiEnd:Function = null;
         onAnimiEnd = function(event:Event):void
         {
            if(Boolean(_bagPanel))
            {
               _bagPanel.removeChild(anim);
            }
            if(_currentUseItemId == 200230)
            {
               AlertManager.showAlert("恭喜你！" + petInfo.name + "的资质+1！",function():void
               {
                  showResultPanel(apprisalPetInfo,petInfo);
               });
            }
            else
            {
               showResultPanel(apprisalPetInfo,petInfo);
            }
         };
         Connection.removeCommandListener(CommandSet.ITEM_APPRISAL_1116,this.onUsedApprisalPetItem);
         data = event.message.getRawData().clone();
         petInfo = PetInfo.readPetInfo_1116(new PetInfo(),data);
         DisplayObjectUtil.enableSprite(this);
         apprisalPetInfo = this._petInfo;
         anim = new ApprisalAni();
         anim.addEventListener("animiEnd",onAnimiEnd);
         if(Boolean(this._bagPanel))
         {
            anim.x = 325;
            this._bagPanel.addChild(anim);
         }
         anim.gotoAndPlay(2);
      }
      
      private function showResultPanel(apprisalPetInfo:PetInfo, petInfo:PetInfo) : void
      {
         if(this._appResultPanel == null)
         {
            this._appResultPanel = new AppraisalResultPanel(this._petTabPanel);
            this._appResultPanel.x = 275;
            this._appResultPanel.y = 140;
         }
         PetInfo.updateBaseInfo(apprisalPetInfo,petInfo);
         apprisalPetInfo.potential = petInfo.potential;
         apprisalPetInfo.flag = petInfo.flag;
         this.updatePetBag();
         this._appResultPanel.updatePet(apprisalPetInfo,this._oldPetInfo);
         this._bagPanel.addChild(this._appResultPanel);
      }
      
      private function usePetItem(item:PetItem) : void
      {
         DisplayObjectUtil.disableSprite(this);
         PetInfoManager.addEventListener("petExperenceChange",this.onPetExperenceChange);
         Connection.addCommandListener(CommandSet.FIGHT_USE_MEDICINE_1048,this.onUsedPetItem);
         Connection.addErrorHandler(CommandSet.FIGHT_USE_MEDICINE_1048,this.onUsedPetError);
         Connection.send(CommandSet.FIGHT_USE_MEDICINE_1048,this._petInfo.catchTime,item.referenceId,this.useNum);
      }
      
      private function onUsedPetError(event:MessageEvent) : void
      {
         DisplayObjectUtil.enableSprite(this);
         if(event.message.statusCode == 205)
         {
            AlertManager.showAlert("精灵不喜欢吃这个");
         }
         if(event.message.statusCode == 206)
         {
            AlertManager.showAlert("你已经使用过相同道具咯！");
         }
         if(event.message.statusCode == 207)
         {
            AlertManager.showAlert("你已经使用过相同道具咯！");
         }
         if(event.message.statusCode == 208)
         {
            AlertManager.showAlert("已经有两倍学习力");
         }
         if(event.message.statusCode == 5010)
         {
            AlertManager.showAlert("这只精灵已经吃过同类型的药剂");
         }
         if(event.message.statusCode == 200020)
         {
            AlertManager.showAlert("这只精灵不能使用此物品");
         }
         this.useNum = 1;
      }
      
      private function onPetExperenceChange(evt:PetInfoEvent) : void
      {
         var revenueInfo:RevenueInfo = evt.content.revenueInfo;
         var resultInfo:FightResultInfo = evt.content.resultInfo;
         if(resultInfo.endReason == 102)
         {
            new FightResultPanelWrapper(this.updatePetBag).show(Vector.<PetInfo>([this._petInfo]),revenueInfo,resultInfo);
         }
      }
      
      private function onUsedPetItem(event:MessageEvent) : void
      {
         var data:LittleEndianByteArray;
         var itemId:uint = uint((data = event.message.getRawData().clone()).readUnsignedInt());
         this.reducePetItem(itemId);
         var petId:uint = uint(data.readUnsignedInt());
         var hp:uint = uint(data.readUnsignedInt());
         var petInfo:PetInfo;
         if((petInfo = PetInfoManager.getPetInfoFromBag(petId)) != null && petInfo.hp != hp)
         {
            petInfo.hp = hp;
            PetInfoManager.dispatchEvent("petCure",petInfo);
         }
         Tick.instance.addTimeout(100,this.onDelayTimer);
         this.useNum = 1;
         if(doubleExpList.indexOf(itemId) > -1)
         {
            ServerMessager.addMessage("使用物品成功,获得所有精灵半小时双倍经验增益效果。");
         }
         if(shopItemList.indexOf(itemId) > -1)
         {
            ServerMessager.addMessage("使用道具成功");
         }
      }
      
      private function reducePetItem(itemId:uint) : void
      {
         var cell:PetItemCell = null;
         ItemManager.reduceItemQuantity(itemId,this.useNum);
         var item:Item = ItemManager.getItemByReferenceId(itemId);
         for each(cell in this._petItemCellVec)
         {
            cell.isSelected = false;
            if(Boolean(cell.item) && Boolean(item) && cell.item.referenceId == itemId)
            {
               cell.setData(item);
            }
         }
         if(!item)
         {
            this.updateItem();
         }
      }
      
      private function onDelayTimer() : void
      {
         DisplayObjectUtil.enableSprite(this);
         this.clearItemCommandListener();
      }
      
      private function clearItemCommandListener() : void
      {
         PetInfoManager.removeEventListener("petExperenceChange",this.onPetExperenceChange);
         Connection.removeCommandListener(CommandSet.FIGHT_USE_MEDICINE_1048,this.onUsedPetItem);
         Connection.removeErrorHandler(CommandSet.FIGHT_USE_MEDICINE_1048,this.onUsedPetError);
      }
      
      private function onPrevBtnClick(event:MouseEvent) : void
      {
         --this._pageIndex;
         this.updateDisplay();
      }
      
      private function onNextBtnClick(event:MouseEvent) : void
      {
         ++this._pageIndex;
         this.updateDisplay();
      }
      
      public function setData(info:PetInfo) : void
      {
         this._petInfo = info;
         ModuleManager.removeEventListener("BuyPropPanel","dispose",this.onDispose);
         ModuleManager.addEventListener("BuyPropPanel","dispose",this.onDispose);
         ItemManager.requestItemList(this.onGetPetItemList);
      }
      
      public function dispose() : void
      {
         ModuleManager.removeEventListener("BuyPropPanel","dispose",this.onDispose);
      }
      
      private function onDispose(event:ModuleEvent) : void
      {
         this.updateItem();
      }
      
      public function keepPage(b:Boolean) : void
      {
         this._keepPage = b;
      }
      
      private function onGetPetItemList() : void
      {
         this.onTabClick(null);
         //this.updateQualityVal();
      }
      
      private function updateQualityVal() : void
      {
         ActiveCountManager.requestActiveCountList(FOR_LIST,function(par:Parser_1142):void
         {
            _qualityItemNum.text = par.infoVec[0].toString();
         });
      }
      
      private function updateItem() : void
      {
         if(this._curStyle == 0)
         {
            this._petItemDataVec = this.getCurPetRelateByType();
         }
         else
         {
            this._petItemDataVec = this.getCurPetRelateByName();
         }
         this._pageCount = Math.ceil(this._petItemDataVec.length / 36);
         if(this._pageCount == 0)
         {
            this._pageCount = 1;
         }
         if(!this._keepPage)
         {
            this._pageIndex = 0;
            this._keepPage = true;
         }
         if(this._pageIndex > this._pageCount - 1)
         {
            this._pageIndex = this._pageCount - 1;
         }
         this.updateDisplay();
      }
      
      private function getCurPetRelateByType() : Vector.<Item>
      {
         var allSortList:Vector.<int> = null;
         var petItem:PetItem = null;
         var type:int = 0;
         var petItem1:PetItem = null;
         var type1:int = 0;
         var resultVec:* = new Vector.<Item>();
         var allVec:Vector.<Item> = this.getAllRelateVec();
         if(this._curSortIndex == 0)
         {
            resultVec = allVec;
         }
         else if(this._curSortIndex == 6)
         {
            allSortList = Vector.<int>([11,7,16,8,12,14,20,19,2,17,18,10]);
            for each(petItem in allVec)
            {
               type = int(petItem.type);
               if(allSortList.indexOf(type) == -1)
               {
                  resultVec.push(petItem);
               }
            }
         }
         else
         {
            for each(petItem1 in allVec)
            {
               type1 = int(petItem1.type);
               if(this.isHaveType(FILTER_TYPE[this._curSortIndex] as Array,type1))
               {
                  resultVec.push(petItem1);
               }
            }
         }
         return resultVec;
      }
      
      private function isHaveType(list:Array, val:int) : Boolean
      {
         var item:int = 0;
         var result:Boolean = false;
         for each(item in list)
         {
            if(item == val)
            {
               result = true;
               break;
            }
         }
         return result;
      }
      
      private function getCurPetRelateByName() : Vector.<Item>
      {
         var i:int = 0;
         var j:int = 0;
         var resultVec:Vector.<Item> = new Vector.<Item>();
         var allVec:Vector.<Item> = this.getAllRelateVec();
         var searchStr:String = this._searchTxt.text;
         var searchStrArr:Array = searchStr.split(/[\s,\/!\\]+/);
         for(i = 0; i < allVec.length; )
         {
            for(j = 0; j < searchStrArr.length; )
            {
               if(searchStrArr[j] != "")
               {
                  if(allVec[i].name.search(searchStrArr[j]) != -1 || allVec[i].tip.search(searchStrArr[j]) != -1)
                  {
                     resultVec.push(allVec[i]);
                     break;
                  }
               }
               j++;
            }
            i++;
         }
         if(resultVec.length <= 0)
         {
            AlertManager.showAlert("没有你要搜索的物品");
            this._curStyle = 0;
         }
         return resultVec;
      }
      
      private function getAllRelateVec() : Vector.<Item>
      {
         var petItem:PetItem = null;
         var type:int = 0;
         var itemVec:Vector.<Item> = new Vector.<Item>();
         var petRelateVec:Vector.<PetItem> = ItemManager.getPetRelateVec();
         var clearItemArr:Array = [200231,201026,201033,201037,201029];
         for each(petItem in petRelateVec)
         {
            type = int(petItem.type);
            if(PET_ITEM_TYPE_VECTOR.indexOf(type) != -1 && clearItemArr.indexOf(petItem.referenceId) == -1)
            {
               itemVec.push(petItem);
            }
         }
         itemVec.sort(function(item1:Item, item2:Item):int
         {
            if(item1.referenceId == 200254)
            {
               return -1;
            }
            if(item2.referenceId == 200254)
            {
               return -1;
            }
            if(item1.getTime > item2.getTime)
            {
               return -1;
            }
            if(item1.getTime < item2.getTime)
            {
               return 1;
            }
            return 0;
         });
         return itemVec;
      }
      
      private function updateDisplay() : void
      {
         this.updateItemVec();
         this.updateButtonStatus();
         this._pageTxt.text = this._pageIndex + 1 + "/" + this._pageCount;
         this.newGuideShow();
      }
      
      private function newGuideShow() : void
      {
         var rect:Rectangle = null;
         if(Boolean(QuestManager.isAccepted(99)) && !QuestManager.isStepComplete(99,3) && Boolean(QuestMapHandler_99_80491.isClickQuest99_3))
         {
            rect = new Rectangle(0,0,49,49);
            GuideManager.instance.addTarget(rect,0);
            GuideManager.instance.addGuide2Target(rect,0,20,new Point(723,217),false,false,9,false,true,false,990,560);
            GuideManager.instance.startGuide(20);
            ModuleManager.addEventListener("BatchPanel","setup",this.onBatchSetup);
            ModuleManager.addEventListener("BatchPanel","dispose",this.onBatchDispose);
         }
      }
      
      private function onBatchSetup(evt:ModuleEvent) : void
      {
         ModuleManager.removeEventListener("BatchPanel","setup",this.onBatchSetup);
         GuideManager.instance.pause();
         var rect:Rectangle = new Rectangle(0,0,84,36);
         GuideManager.instance.addTarget(rect,0);
         GuideManager.instance.addGuide2Target(rect,0,21,new Point(555,427),false,false,9,false,true,false,422,290);
         GuideManager.instance.startGuide(21);
      }
      
      private function onBatchDispose(evt:ModuleEvent) : void
      {
         ModuleManager.removeEventListener("BatchPanel","dispose",this.onBatchDispose);
         GuideManager.instance.close();
         ModuleManager.closeForName("PetBagPanel");
         ModelLocator.getInstance().dispatchEvent(new LogicEvent("newGuideBroad3"));
      }
      
      private function updateItemVec() : void
      {
         var i:int = 0;
         var dataIndex:int = 0;
         var startIndex:int = this._pageIndex * 36;
         for(i = 0; i < 36; )
         {
            dataIndex = startIndex + i;
            if(dataIndex < this._petItemDataVec.length)
            {
               this._petItemCellVec[i].setData(this._petItemDataVec[dataIndex]);
            }
            else
            {
               this._petItemCellVec[i].setData(null);
            }
            i++;
         }
      }
      
      private function updateButtonStatus() : void
      {
         DisplayObjectUtil.enableButton(this._prevBtn);
         DisplayObjectUtil.enableButton(this._nextBtn);
         if(this._pageIndex == 0)
         {
            DisplayObjectUtil.disableButton(this._prevBtn);
         }
         if(this._pageIndex == this._pageCount - 1)
         {
            DisplayObjectUtil.disableButton(this._nextBtn);
         }
      }
      
      private function gerParser() : int
      {
         if(this._petInfo.resourceId == 3)
         {
            return 3;
         }
         if(this._petInfo.resourceId == 6)
         {
            return 4;
         }
         if(this._petInfo.resourceId == 9)
         {
            return 3;
         }
         return 0;
      }
      
      private function getPosition() : int
      {
         if(this._petInfo.resourceId == 3)
         {
            return 4;
         }
         if(this._petInfo.resourceId == 6)
         {
            return 5;
         }
         if(this._petInfo.resourceId == 9)
         {
            return 3;
         }
         return 0;
      }
   }
}
