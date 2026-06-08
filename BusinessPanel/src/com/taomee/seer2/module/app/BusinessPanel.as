package com.taomee.seer2.module.app
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.config.item.CollectionItemDefinition;
   import com.taomee.seer2.app.config.item.PetItemDefinition;
   import com.taomee.seer2.app.guide.info.GudieDirectionType;
   import com.taomee.seer2.app.guide.manager.GuideManager;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.inventory.events.ItemEvent;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.core.inventory.Item;
   import com.taomee.seer2.core.module.Module;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.LifecycleType;
   import com.taomee.seer2.module.app.businessPanel.BusinessItem;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class BusinessPanel extends Module
   {
      
      private var _type:uint;
      
      private var _currIndex:uint;
      
      private var _businessItemVec:Vector.<BusinessItem>;
      
      private var _petItemDataVec:Vector.<Item>;
      
      private var _petGetItemDataVec:Vector.<PetItemDefinition>;
      
      private var _petConGetItemDataVec:Vector.<CollectionItemDefinition>;
      
      private var _pageCount:uint;
      
      private var _pageIndex:uint;
      
      private var _itemContainer:Sprite;
      
      private var _item:Item;
      
      private var _definition:PetItemDefinition;
      
      private var _conDefinition:CollectionItemDefinition;
      
      private var _titleMC:MovieClip;
      
      private var _selectedTabMc:MovieClip;
      
      private var _purchaseTabBtn:SimpleButton;
      
      private var _sellTabBtn:SimpleButton;
      
      private var _purchaseMC:MovieClip;
      
      private var _nameTxt:TextField;
      
      private var _purchasePriceTxt:TextField;
      
      private var _countTxt:TextField;
      
      private var _totalPriceTxt:TextField;
      
      private var _descriptionTxt:TextField;
      
      private var _thisConisTxt:TextField;
      
      private var _next:SimpleButton;
      
      private var _prev:SimpleButton;
      
      private var _purchaseBtn:MovieClip;
      
      public function BusinessPanel()
      {
         super();
         _lifecycleType = LifecycleType.NONCE;
      }
      
      override public function setup() : void
      {
         setMainUI(new BusinessPanelUI());
         StatisticsManager.sendNovice(StatisticsManager.ui_interact_222);
      }
      
      override public function init(data:Object) : void
      {
         this._type = uint(data.shopType);
         ItemManager.requestItemList(function():void
         {
            initialize();
            initItem();
            initEvent();
            setStatus();
            updateItemDataVec();
            setInitItem();
         });
      }
      
      private function initialize() : void
      {
         this._titleMC = _mainUI["titleMC"];
         this._selectedTabMc = _mainUI["selectedTabMc"];
         this._purchaseTabBtn = _mainUI["purchaseTabBtn"];
         this._sellTabBtn = _mainUI["sellTabBtn"];
         this._purchaseMC = _mainUI["purchaseMC"];
         this._nameTxt = _mainUI["nameTxt"];
         this._purchasePriceTxt = _mainUI["purchasePriceTxt"];
         this._countTxt = _mainUI["countTxt"];
         this._countTxt.restrict = "0-9";
         this._countTxt.maxChars = 2;
         this._totalPriceTxt = _mainUI["totalPriceTxt"];
         this._descriptionTxt = _mainUI["descriptionTxt"];
         this._thisConisTxt = _mainUI["thisConisTxt"];
         this._next = _mainUI["next"];
         this._prev = _mainUI["prev"];
         this._purchaseBtn = _mainUI["purchaseBtn"];
      }
      
      private function initEvent() : void
      {
         this._countTxt.addEventListener(Event.CHANGE,this.changePosition);
         this._purchaseTabBtn.addEventListener(MouseEvent.CLICK,this.onPurchaseTab);
         this._sellTabBtn.addEventListener(MouseEvent.CLICK,this.onSellTab);
         this._next.addEventListener(MouseEvent.CLICK,this.onNext);
         this._prev.addEventListener(MouseEvent.CLICK,this.onPrev);
         this._purchaseBtn.addEventListener(MouseEvent.CLICK,this.onPurchase);
      }
      
      private function initItem() : void
      {
         var item:BusinessItem = null;
         this._itemContainer = new Sprite();
         this._itemContainer.x = 225;
         this._itemContainer.y = 84;
         _mainUI.addChild(this._itemContainer);
         var rowCount:int = 3;
         var horizontalPadding:int = 68;
         var verticalPadding:int = 66;
         this._businessItemVec = new Vector.<BusinessItem>();
         for(var i:int = 0; i < 9; i++)
         {
            item = new BusinessItem();
            item.x = horizontalPadding * (i % rowCount);
            item.y = verticalPadding * int(i / rowCount);
            this._itemContainer.addChild(item);
            item.addEventListener(BusinessItem.ITEM_USE,this.onPetItemUse);
            this._businessItemVec.push(item);
         }
      }
      
      private function onPetItemUse(event:Event) : void
      {
         var businessItem:BusinessItem = null;
         this.checkSelectItemGudieTask();
         var currentItem:BusinessItem = event.currentTarget as BusinessItem;
         if(this._currIndex == 1)
         {
            if(this._type == 1)
            {
               this._definition = currentItem.definition;
            }
            else
            {
               this._conDefinition = currentItem.conDefinition;
            }
         }
         else
         {
            this._item = currentItem.item;
         }
         for each(businessItem in this._businessItemVec)
         {
            if(businessItem == currentItem)
            {
               businessItem.isSelected = true;
            }
            else
            {
               businessItem.isSelected = false;
            }
         }
         this.refreshItemInfo();
      }
      
      private function changePosition(event:Event) : void
      {
         if(this._currIndex == 1)
         {
            if(this._type == 1)
            {
               if(Boolean(this._definition))
               {
                  this._totalPriceTxt.text = String(uint(this._countTxt.text) * this._definition.price);
               }
            }
            else if(Boolean(this._conDefinition))
            {
               this._totalPriceTxt.text = String(uint(this._countTxt.text) * this._conDefinition.price);
            }
         }
         else if(Boolean(this._item))
         {
            this._totalPriceTxt.text = String(uint(this._countTxt.text) * ItemConfig.getPetDefinition(this._item.referenceId).sellPrice);
         }
      }
      
      private function refreshItemInfo() : void
      {
         if(this._currIndex == 1)
         {
            if(this._type == 1)
            {
               this._nameTxt.text = this._definition.name;
               this._purchasePriceTxt.text = String(this._definition.price);
               this._countTxt.text = "1";
               this._totalPriceTxt.text = String(uint(this._countTxt.text) * this._definition.price);
               this._descriptionTxt.text = this._definition.tip;
            }
            else
            {
               this._nameTxt.text = this._conDefinition.name;
               this._purchasePriceTxt.text = String(this._conDefinition.price);
               this._countTxt.text = "1";
               this._totalPriceTxt.text = String(uint(this._countTxt.text) * this._conDefinition.price);
               this._descriptionTxt.text = this._conDefinition.tip;
            }
         }
         else
         {
            this._nameTxt.text = this._item.name;
            if(this._type == 1)
            {
               this._purchasePriceTxt.text = String(ItemConfig.getPetDefinition(this._item.referenceId).sellPrice);
               this._countTxt.text = "1";
               this._totalPriceTxt.text = String(uint(this._countTxt.text) * ItemConfig.getPetDefinition(this._item.referenceId).sellPrice);
               this._descriptionTxt.text = ItemConfig.getPetDefinition(this._item.referenceId).tip;
            }
            else
            {
               this._purchasePriceTxt.text = String(ItemConfig.getCollectionDefinition(this._item.referenceId).sellPrice);
               this._countTxt.text = "1";
               this._totalPriceTxt.text = String(uint(this._countTxt.text) * ItemConfig.getCollectionDefinition(this._item.referenceId).sellPrice);
               this._descriptionTxt.text = ItemConfig.getCollectionDefinition(this._item.referenceId).tip;
            }
         }
      }
      
      private function updateItemDataVec() : void
      {
         this._thisConisTxt.text = ActorManager.actorInfo.coins.toString();
         if(this._currIndex == 1)
         {
            if(this._type == 1)
            {
               this._petGetItemDataVec = this.getPetDefinitionVec();
               this._pageCount = Math.ceil(this._petGetItemDataVec.length / 9);
            }
            else
            {
               this._petConGetItemDataVec = this.getConDefinitionVec();
               this._pageCount = Math.ceil(this._petConGetItemDataVec.length / 9);
            }
         }
         else
         {
            this._petItemDataVec = this.getPetRelateVec();
            this._pageCount = Math.ceil(this._petItemDataVec.length / 9);
         }
         if(this._pageCount == 0)
         {
            this._pageCount = 1;
         }
         if(this._pageIndex > this._pageCount - 1)
         {
            this._pageIndex = this._pageCount - 1;
         }
         this.updateDisplay();
      }
      
      private function getConDefinitionVec() : Vector.<CollectionItemDefinition>
      {
         var item:CollectionItemDefinition = null;
         var itemVec:Vector.<CollectionItemDefinition> = new Vector.<CollectionItemDefinition>();
         var petRelateVec:Vector.<CollectionItemDefinition> = ItemConfig.getAllCollectionDefinition();
         for each(item in petRelateVec)
         {
            if(uint(item.id / 100000) == 4 && (item.tradability == 1 || item.tradability == 3) && (item.vipTradability == 1 || item.vipTradability == 3) && (item.id != 200201 && item.id != 200202))
            {
               itemVec.push(item);
            }
         }
         return itemVec;
      }
      
      private function getPetDefinitionVec() : Vector.<PetItemDefinition>
      {
         var item:PetItemDefinition = null;
         var itemVec:Vector.<PetItemDefinition> = new Vector.<PetItemDefinition>();
         var petRelateVec:Vector.<PetItemDefinition> = ItemConfig.getAllPetItemDefinition();
         for each(item in petRelateVec)
         {
            if(uint(item.id / 100000) == 2 && (item.tradability == 1 || item.tradability == 3) && (item.vipTradability == 1 || item.vipTradability == 3) && (item.id != 200201 && item.id != 200202))
            {
               itemVec.push(item);
            }
         }
         return itemVec;
      }
      
      private function getPetRelateVec() : Vector.<Item>
      {
         var item:Item = null;
         var itemVec:Vector.<Item> = new Vector.<Item>();
         var itemInfoVec:Array = ItemManager.getItemArr();
         for each(item in itemInfoVec)
         {
            if(uint(item.referenceId / 100000) == 2 && (item.tradability == 2 || item.tradability == 3) && (item.vipTradability == 2 || item.vipTradability == 3))
            {
               itemVec.push(item);
            }
         }
         return itemVec;
      }
      
      private function updateDisplay() : void
      {
         this.updateItemVec();
         this.updateButtonStatus();
      }
      
      private function updateItemVec() : void
      {
         var dataIndex:int = 0;
         var startIndex:int = this._pageIndex * 9;
         for(var i:int = 0; i < 9; i++)
         {
            dataIndex = startIndex + i;
            if(this._currIndex == 2)
            {
               if(dataIndex < this._petItemDataVec.length)
               {
                  this._businessItemVec[i].setData(this._petItemDataVec[dataIndex]);
                  this._businessItemVec[i].isShowNumSpr(true);
               }
               else
               {
                  this._businessItemVec[i].setData(null);
               }
            }
            else if(this._type == 1)
            {
               if(dataIndex < this._petGetItemDataVec.length)
               {
                  this._businessItemVec[i].setDefinition(this._petGetItemDataVec[dataIndex]);
                  this._businessItemVec[i].isShowNumSpr(false);
               }
               else
               {
                  this._businessItemVec[i].setDefinition(null);
               }
            }
            else if(dataIndex < this._petConGetItemDataVec.length)
            {
               this._businessItemVec[i].setConDefinition(this._petConGetItemDataVec[dataIndex]);
               this._businessItemVec[i].isShowNumSpr(false);
            }
            else
            {
               this._businessItemVec[i].setDefinition(null);
            }
         }
      }
      
      private function updateButtonStatus() : void
      {
         DisplayObjectUtil.enableButton(this._prev);
         DisplayObjectUtil.enableButton(this._next);
         if(this._pageIndex == 0)
         {
            DisplayObjectUtil.disableButton(this._prev);
         }
         if(this._pageIndex == this._pageCount - 1)
         {
            DisplayObjectUtil.disableButton(this._next);
         }
      }
      
      private function onPurchaseTab(event:MouseEvent) : void
      {
         this._currIndex = 1;
         this.refresh();
         this.updateItemDataVec();
         this.setInitItem();
      }
      
      private function onSellTab(event:MouseEvent) : void
      {
         this._currIndex = 2;
         this.refresh();
         this.updateItemDataVec();
         this.setInitItem();
      }
      
      private function onNext(event:MouseEvent) : void
      {
         ++this._pageIndex;
         this.updateDisplay();
      }
      
      private function onPrev(event:MouseEvent) : void
      {
         --this._pageIndex;
         this.updateDisplay();
      }
      
      private function checkSelectItemGudieTask() : void
      {
         var $rect:Rectangle = null;
         if(Boolean(QuestManager.isAccepted(68)) && !QuestManager.isStepComplete(68,1))
         {
            $rect = new Rectangle(0,0,40,40);
            GuideManager.instance.addTarget($rect,13);
            GuideManager.instance.addGuide2Target($rect,0,13,new Point(794,160),false,false,GudieDirectionType.CONTENT,false,true);
            GuideManager.instance.startGuide(13);
         }
         if(Boolean(QuestManager.isAccepted(83)) && Boolean(QuestManager.isStepComplete(83,4)) && !QuestManager.isStepComplete(83,5))
         {
            $rect = new Rectangle(0,0,91,40);
            GuideManager.instance.addTarget($rect,13);
            GuideManager.instance.addGuide2Target($rect,0,13,new Point(694,451),false,false,GudieDirectionType.CONTENT,false,true);
            GuideManager.instance.startGuide(13);
         }
      }
      
      private function checkBuyItemGudieTask() : void
      {
         var $rect:Rectangle = null;
         if(Boolean(QuestManager.isAccepted(83)) && Boolean(QuestManager.isStepComplete(83,4)) && !QuestManager.isStepComplete(83,5))
         {
            $rect = new Rectangle(0,0,91,40);
            GuideManager.instance.addTarget($rect,14);
            GuideManager.instance.addGuide2Target($rect,0,14,new Point(497,351),false,false,GudieDirectionType.CONTENT,true,true,true);
            GuideManager.instance.startGuide(14);
         }
      }
      
      private function checkCompleteGudieBuyItemTask() : void
      {
         var $rect:Rectangle = null;
         if(Boolean(QuestManager.isAccepted(83)) && Boolean(QuestManager.isStepComplete(83,4)) && !QuestManager.isStepComplete(83,5))
         {
            $rect = new Rectangle(0,0,91,40);
            GuideManager.instance.addTarget($rect,15);
            GuideManager.instance.addGuide2Target($rect,0,15,new Point(553,352),false,false,GudieDirectionType.CONTENT,true,true,true);
            GuideManager.instance.startGuide(15);
         }
      }
      
      private function onPurchase(event:MouseEvent) : void
      {
         if(Boolean(QuestManager.isAccepted(83)) && Boolean(QuestManager.isStepComplete(83,4)) && !QuestManager.isStepComplete(83,5))
         {
            if(uint(this._countTxt.text) > this._definition.quantityLimit - ItemManager.getItemQuantityByReferenceId(this._definition.id))
            {
               AlertManager.showAlert("你无法携带那么多哦");
               return;
            }
            ItemManager.addEventListener1(ItemEvent.REQUEST_ADD_ITEM_SUCCESS,this.onRequestSuccess);
            ItemManager.addEventListener1(ItemEvent.REQUEST_ADD_ITEM_FAIL,this.onRequestFail);
            ItemManager.requestAddItem(this._definition.id,uint(this._countTxt.text));
            return;
         }
         this.checkBuyItemGudieTask();
         if(this._currIndex == 1)
         {
            AlertManager.showConfirm("你确定要购买此物品吗？",function():void
            {
               if(ActorManager.actorInfo.coins < uint(_totalPriceTxt.text))
               {
                  AlertManager.showAlert("你没有足够赛尔豆购买");
                  return;
               }
               if(_type == 1)
               {
                  if(uint(_countTxt.text) > _definition.quantityLimit - ItemManager.getItemQuantityByReferenceId(_definition.id))
                  {
                     AlertManager.showAlert("你无法携带那么多哦");
                     return;
                  }
                  ItemManager.addEventListener1(ItemEvent.REQUEST_ADD_ITEM_SUCCESS,onRequestSuccess);
                  ItemManager.addEventListener1(ItemEvent.REQUEST_ADD_ITEM_FAIL,onRequestFail);
                  ItemManager.requestAddItem(_definition.id,uint(_countTxt.text));
               }
               else
               {
                  if(uint(_countTxt.text) > _conDefinition.quantityLimit - ItemManager.getItemQuantityByReferenceId(_conDefinition.id))
                  {
                     AlertManager.showAlert("你无法携带那么多哦");
                     return;
                  }
                  ItemManager.addEventListener1(ItemEvent.REQUEST_ADD_ITEM_SUCCESS,onRequestSuccess);
                  ItemManager.addEventListener1(ItemEvent.REQUEST_ADD_ITEM_FAIL,onRequestFail);
                  ItemManager.requestAddItem(_conDefinition.id,uint(_countTxt.text));
               }
            });
         }
         else
         {
            AlertManager.showConfirm("你确定要出售此物品吗？",function():void
            {
               if(uint(_countTxt.text) > ItemManager.getItemQuantityByReferenceId(_item.referenceId))
               {
                  AlertManager.showAlert("你根本就没有这么多" + _item.name);
                  return;
               }
               ItemManager.addEventListener1(ItemEvent.ITEM_SELLOUT,onSetPageInfo);
               ItemManager.requestReduceItemQuantity(_item.referenceId,uint(_countTxt.text));
            });
         }
      }
      
      private function onSetPageInfo(event:ItemEvent) : void
      {
         ItemManager.removeEventListener1(ItemEvent.ITEM_SELLOUT,this.onSetPageInfo);
         AlertManager.showAlert("出售成功");
         this._thisConisTxt.text = ActorManager.actorInfo.coins.toString();
         this.updateItemDataVec();
      }
      
      private function onRequestSuccess(evt:ItemEvent) : void
      {
         ItemManager.removeEventListener1(ItemEvent.REQUEST_ADD_ITEM_SUCCESS,this.onRequestSuccess);
         ItemManager.removeEventListener1(ItemEvent.REQUEST_ADD_ITEM_FAIL,this.onRequestFail);
         if(Boolean(QuestManager.isAccepted(83)) && Boolean(QuestManager.isStepComplete(83,4)) && !QuestManager.isStepComplete(83,5))
         {
            ModuleManager.closeForName("BusinessPanel");
         }
         else
         {
            AlertManager.showAlert("购买成功",this.buySuccess);
            this.checkCompleteGudieBuyItemTask();
            this._thisConisTxt.text = ActorManager.actorInfo.coins.toString();
         }
      }
      
      private function buySuccess() : void
      {
         var $rect:Rectangle = null;
         if(Boolean(QuestManager.isAccepted(83)) && Boolean(QuestManager.isStepComplete(83,4)) && !QuestManager.isStepComplete(83,5))
         {
            $rect = new Rectangle(0,0,39,39);
            GuideManager.instance.addTarget($rect,16);
            GuideManager.instance.addGuide2Target($rect,0,16,new Point(798,167),false,false,GudieDirectionType.CONTENT,false,true);
            GuideManager.instance.startGuide(16);
         }
      }
      
      private function onRequestFail(evt:ItemEvent) : void
      {
         ItemManager.removeEventListener1(ItemEvent.REQUEST_ADD_ITEM_SUCCESS,this.onRequestSuccess);
         ItemManager.removeEventListener1(ItemEvent.REQUEST_ADD_ITEM_FAIL,this.onRequestFail);
      }
      
      private function setStatus() : void
      {
         if(this._type == 1)
         {
            this._currIndex = 1;
            this._titleMC.gotoAndStop(1);
         }
         if(this._type == 2)
         {
            this._currIndex = 1;
            this._selectedTabMc.visible = false;
            this._sellTabBtn.visible = false;
            this._titleMC.gotoAndStop(2);
         }
         this.refresh();
      }
      
      private function refresh() : void
      {
         this._nameTxt.text = "";
         this._purchasePriceTxt.text = "";
         this._countTxt.text = "";
         this._totalPriceTxt.text = "";
         this._descriptionTxt.text = "";
         if(this._currIndex == 1)
         {
            this._selectedTabMc.x = this._purchaseTabBtn.x - 35;
            this._purchaseMC.gotoAndStop(1);
            this._purchaseBtn.gotoAndStop(1);
         }
         else if(this._currIndex == 2)
         {
            this._selectedTabMc.x = this._sellTabBtn.x - 35;
            this._purchaseMC.gotoAndStop(2);
            this._purchaseBtn.gotoAndStop(2);
         }
      }
      
      private function setInitItem() : void
      {
         if(this._currIndex == 1)
         {
            this._businessItemVec[0].isSelected = true;
            if(this._type == 1)
            {
               this._definition = this._businessItemVec[0].definition;
            }
            else
            {
               this._conDefinition = this._businessItemVec[0].conDefinition;
            }
            this.refreshItemInfo();
         }
         else if(this._currIndex == 2)
         {
            if(this._petItemDataVec.length > 0)
            {
               this._businessItemVec[0].isSelected = true;
               this._item = this._businessItemVec[0].item;
               this.refreshItemInfo();
            }
         }
      }
      
      override public function dispose() : void
      {
         var item:BusinessItem = null;
         this.refresh();
         for each(item in this._businessItemVec)
         {
            DisplayUtil.removeForParent(item);
            item.removeEventListener(BusinessItem.ITEM_USE,this.onPetItemUse);
            item.reset();
         }
         DisplayUtil.removeForParent(this._itemContainer);
         ItemManager.removeEventListener(ItemEvent.ITEM_SELLOUT,this.onSetPageInfo);
         ItemManager.removeEventListener1(ItemEvent.REQUEST_ADD_ITEM_SUCCESS,this.onRequestSuccess);
         ItemManager.removeEventListener1(ItemEvent.REQUEST_ADD_ITEM_FAIL,this.onRequestFail);
         this._countTxt.removeEventListener(Event.CHANGE,this.changePosition);
         this._purchaseTabBtn.removeEventListener(MouseEvent.CLICK,this.onPurchaseTab);
         this._sellTabBtn.removeEventListener(MouseEvent.CLICK,this.onSellTab);
         this._next.removeEventListener(MouseEvent.CLICK,this.onNext);
         this._prev.removeEventListener(MouseEvent.CLICK,this.onPrev);
         this._purchaseBtn.removeEventListener(MouseEvent.CLICK,this.onPurchase);
         GuideManager.instance.pause();
         this._titleMC = null;
         this._selectedTabMc = null;
         this._purchaseTabBtn = null;
         this._sellTabBtn = null;
         this._purchaseMC = null;
         this._nameTxt = null;
         this._purchasePriceTxt = null;
         this._countTxt = null;
         this._totalPriceTxt = null;
         this._descriptionTxt = null;
         this._thisConisTxt = null;
         this._next = null;
         this._prev = null;
         this._purchaseBtn = null;
         this._itemContainer = null;
         super.dispose();
      }
   }
}

