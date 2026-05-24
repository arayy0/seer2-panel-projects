package com.taomee.seer2.module.app.itemBag.ui
{
   import com.taomee.seer2.app.actor.constant.EquipSlot;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.config.item.SuitDefinition;
   import com.taomee.seer2.app.inventory.constant.CollectionItemType;
   import com.taomee.seer2.app.inventory.constant.PetItemType;
   import com.taomee.seer2.app.inventory.constant.PetSpirtTrainItemType;
   import com.taomee.seer2.core.effects.SoundEffects;
   import com.taomee.seer2.module.app.itemBag.ItemBagSearchUI;
   import com.taomee.seer2.module.app.itemBag.constant.ItemBagQueryType;
   import com.taomee.seer2.module.app.itemBag.data.ItemBagQuery;
   import com.taomee.seer2.module.app.itemBag.events.ItemBagEvent;
   import com.taomee.seer2.module.app.itemBag.ui.filter.ItemBagFilterExtension;
   import com.taomee.seer2.module.app.itemBag.ui.filter.ItemBagFilterItem;
   import com.taomee.seer2.module.app.itemBag.ui.filter.ItemBagFilterMenu;
   import com.taomee.seer2.module.app.itemBag.ui.filter.ItemBagFilterPage;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;

import org.taomee.manager.EventManager;
   
   public class ItemBagFilter extends Sprite
   {
      
      private static const ALL_DESCRIPTION:String = "全部";
      
      private static const EQUIP_DESCRIPTION:Vector.<String> = Vector.<String>(["套装","头部","手部","坐骑","腰带","腿部","背部","表情"]);
      
      private static const COLLECTION_DESCRIPTION:Vector.<String> = Vector.<String>(["矿石","代币","鱼竿","鱼饵","鱼"]);
      
      private static const PET_ITEM_DESCRIPTION:Vector.<String> = Vector.<String>(["精灵胶囊","体力药剂","怒气药剂","经验芯片","纹章","魔能宝石","学习及资质","战斗药剂","进化芯片"]);
      
      private static const ELEMENT_DESCRIPTION:Vector.<String> = Vector.<String>(["初级附魔","高级附魔","附魔材料"]);
      
      private static const PET_SPIRT_TRAIN_DESCRIPTION:Vector.<String> = Vector.<String>(["精元","精元蛋"]);
       
      
      private var _filterMenu:ItemBagFilterMenu;
      
      private var _isShowDropDown:Boolean;
      
      private var _equipFilterPage:ItemBagFilterPage;
      
      private var _suitExtension:ItemBagFilterExtension;
      
      private var _collectionFilterPage:ItemBagFilterPage;
      
      private var _petItemFilterPage:ItemBagFilterPage;
      
      private var _elementFilterPage:ItemBagFilterPage;
      
      private var _petSpirtTrainFilterPage:ItemBagFilterPage;

      private var _searchUI:ItemBagSearchUI;

      private var _searchTxt:TextField;
      
      private var _currentTab:int;
      
      public function ItemBagFilter()
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
         this.x = 390;
         this.createFilterMenu();
         this.createEquipFilter();
         this.createCollectionFilter();
         this.createElement();
         this.createPetItemFilter();
         this.createPetSpirtTrainFilter();
         this.createSearch();
      }
      
      private function createFilterMenu() : void
      {
         this._filterMenu = new ItemBagFilterMenu();
         addChild(this._filterMenu);
         SoundEffects.setButton(this._filterMenu,false);
      }
      
      private function createEquipFilter() : void
      {
         var dataVec:Vector.<String> = new Vector.<String>();
         dataVec.push(ALL_DESCRIPTION);
         var len:int = int(EQUIP_DESCRIPTION.length);
         for(var i:int = 0; i < len; i++)
         {
            dataVec.push(EQUIP_DESCRIPTION[i]);
         }
         this._equipFilterPage = new ItemBagFilterPage(dataVec);
         addChild(this._equipFilterPage);
         this._suitExtension = new ItemBagFilterExtension();
         this._equipFilterPage.setExtension(this._suitExtension,1);
      }
      
      private function createCollectionFilter() : void
      {
         var dataVec:Vector.<String> = new Vector.<String>();
         dataVec.push(ALL_DESCRIPTION);
         var len:int = int(COLLECTION_DESCRIPTION.length);
         for(var i:int = 0; i < len; i++)
         {
            dataVec.push(COLLECTION_DESCRIPTION[i]);
         }
         this._collectionFilterPage = new ItemBagFilterPage(dataVec);
         addChild(this._collectionFilterPage);
      }
      
      private function createPetSpirtTrainFilter() : void
      {
         var dataVec:Vector.<String> = new Vector.<String>();
         dataVec.push(ALL_DESCRIPTION);
         var len:int = int(PET_SPIRT_TRAIN_DESCRIPTION.length);
         for(var i:int = 0; i < len; i++)
         {
            dataVec.push(PET_SPIRT_TRAIN_DESCRIPTION[i]);
         }
         this._petSpirtTrainFilterPage = new ItemBagFilterPage(dataVec);
         addChild(this._petSpirtTrainFilterPage);
      }
      
      private function createElement() : void
      {
         var dataVec:Vector.<String> = new Vector.<String>();
         dataVec.push(ALL_DESCRIPTION);
         var len:int = int(ELEMENT_DESCRIPTION.length);
         for(var i:int = 0; i < len; i++)
         {
            dataVec.push(ELEMENT_DESCRIPTION[i]);
         }
         this._elementFilterPage = new ItemBagFilterPage(dataVec);
         addChild(this._elementFilterPage);
      }
      
      private function createPetItemFilter() : void
      {
         var dataVec:Vector.<String> = new Vector.<String>();
         dataVec.push(ALL_DESCRIPTION);
         var len:int = int(PET_ITEM_DESCRIPTION.length);
         for(var i:int = 0; i < len; i++)
         {
            dataVec.push(PET_ITEM_DESCRIPTION[i]);
         }
         this._petItemFilterPage = new ItemBagFilterPage(dataVec);
         addChild(this._petItemFilterPage);
      }

      private function createSearch():void
      {
         this._searchUI = new ItemBagSearchUI();
         this._searchTxt = this._searchUI["searchTxt"];
         this._searchTxt.text = "输入关键词搜索";
         this._searchUI.x = 185;
         this._searchUI.y = 38;
         addChild(this._searchUI);
      }
      
      private function initEventListener() : void
      {
         this._filterMenu.buttonMode = true;
         this._filterMenu.addEventListener(MouseEvent.CLICK,this.onMenuClick);
         EventManager.addEventListener("firstOpenItemBag",this.onFirstOpen);
         this._suitExtension.addEventListener(ItemBagFilterExtension.SELECTED_ITEM_CHANGE,this.onExtensionItemChange);
         this._equipFilterPage.addEventListener(ItemBagFilterPage.SELECTED_ITEM_CHANGE,this.onPageSelectedItemChange);
         this._collectionFilterPage.addEventListener(ItemBagFilterPage.SELECTED_ITEM_CHANGE,this.onPageSelectedItemChange);
         this._petItemFilterPage.addEventListener(ItemBagFilterPage.SELECTED_ITEM_CHANGE,this.onPageSelectedItemChange);
         this._elementFilterPage.addEventListener(ItemBagFilterPage.SELECTED_ITEM_CHANGE,this.onPageSelectedItemChange);
         this._petSpirtTrainFilterPage.addEventListener(ItemBagFilterPage.SELECTED_ITEM_CHANGE,this.onPageSelectedItemChange);
         this._searchTxt.addEventListener("keyDown",function(evt:KeyboardEvent):void {
            var tmpStr:String = _searchTxt.text;
            tmpStr = tmpStr.replace("\n","");
            if(evt.keyCode == 13)
            {
               _searchTxt.text = tmpStr;
               onSearch(null);
            }
         });
         this._searchTxt.addEventListener("focusIn",function (e:*):void{
            _searchTxt.text = "";
         });
         this._searchTxt.addEventListener("focusOut",function (e:*):void{
            if(_searchTxt.text == "")
            {
               _searchTxt.text = "输入关键词搜索";
            }
         });
         this._searchUI["searchBtn"].addEventListener("click",this.onSearch)
      }

      private function onSearch(e:MouseEvent):void
      {
         if(this._searchTxt.text != "" && this._searchTxt.text != "输入关键词搜索")
         {
            var query:ItemBagQuery = new ItemBagQuery(-1,this._searchTxt.text);
            dispatchEvent(new ItemBagEvent(ItemBagEvent.QUERY_SEARCH,query));
         }
      }
      
      private function onFirstOpen(evt:Event) : void
      {
         EventManager.removeEventListener("firstOpenItemBag",this.onFirstOpen);
         this.onMenuClick(null);
      }
      
      private function onMenuClick(evt:MouseEvent) : void
      {
         switch(this._currentTab)
         {
            case ItemBagTab.EQUIP:
               this._equipFilterPage.toggle();
               break;
            case ItemBagTab.COLLECTION:
               this._collectionFilterPage.toggle();
               break;
            case ItemBagTab.PET_ITEM:
               this._petItemFilterPage.toggle();
               break;
            case ItemBagTab.ELEMENT:
               this._elementFilterPage.toggle();
               break;
            case ItemBagTab.PET_SPIRT_TRAIN:
               this._petSpirtTrainFilterPage.toggle();
         }
         this._filterMenu.toggle();
      }
      
      private function onExtensionItemChange(evt:Event) : void
      {
         var target:ItemBagFilterExtension = evt.currentTarget as ItemBagFilterExtension;
         var suitId:int = target.selectedSuitId;
         var suitDefinition:SuitDefinition = ItemConfig.getSuitDefinition(suitId);
         this._filterMenu.description = suitDefinition.name;
         this.collapseDropDown();
         var query:ItemBagQuery = new ItemBagQuery(ItemBagQueryType.QUERY_EQUIP_BY_SUIT_ID,suitId);
         dispatchEvent(new ItemBagEvent(ItemBagEvent.QUERY_ITEM_LIST,query));
      }
      
      private function onPageSelectedItemChange(evt:Event) : void
      {
         var query:ItemBagQuery = null;
         var target:ItemBagFilterPage = evt.currentTarget as ItemBagFilterPage;
         var selectedIndex:int = target.selectedItemIndex;
         var selectedItem:ItemBagFilterItem = target.selectedItem;
         if(this._currentTab == ItemBagTab.EQUIP && selectedIndex == 1)
         {
            dispatchEvent(new ItemBagEvent(ItemBagEvent.QUERY_SUIT));
            return;
         }
         if(selectedIndex == 0)
         {
            query = this.getQueryByCurrentTab();
         }
         else
         {
            query = this.getQueryBySelectedIndex(selectedIndex);
         }
         this._filterMenu.description = selectedItem.description;
         this.collapseDropDown();
         dispatchEvent(new ItemBagEvent(ItemBagEvent.QUERY_ITEM_LIST,query));
      }
      
      private function getQueryByCurrentTab() : ItemBagQuery
      {
         var queryType:int = 0;
         switch(this._currentTab)
         {
            case ItemBagTab.EQUIP:
               queryType = ItemBagQueryType.QUERY_EQUIP;
               break;
            case ItemBagTab.COLLECTION:
               queryType = ItemBagQueryType.QUERY_COLLECTION;
               break;
            case ItemBagTab.PET_ITEM:
               queryType = ItemBagQueryType.QUERY_PET_ITEM;
               break;
            case ItemBagTab.VIP_ITEM:
               queryType = ItemBagQueryType.QUERY_VIP_ITEM;
               break;
            case ItemBagTab.ELEMENT:
               queryType = ItemBagQueryType.QUERY_ELEMENT;
               break;
            case ItemBagTab.PET_SPIRT_TRAIN:
               queryType = ItemBagQueryType.QUERY_PET_SPIRT_TRAIN;
         }
         return new ItemBagQuery(queryType);
      }
      
      private function getQueryBySelectedIndex(index:int) : ItemBagQuery
      {
         var queryType:int = 0;
         var queryContent:int = 0;
         switch(this._currentTab)
         {
            case ItemBagTab.EQUIP:
               queryType = ItemBagQueryType.QUERY_EQUIP_BY_SLOT_INDEX;
               queryContent = this.getSlotIndexBySelectedIndex(index);
               break;
            case ItemBagTab.COLLECTION:
               queryType = ItemBagQueryType.QUERY_COLLECTION_BY_TYPE;
               queryContent = this.getCollectionTypeBySelectedIndex(index);
               break;
            case ItemBagTab.PET_ITEM:
               queryType = ItemBagQueryType.QUERY_PET_ITEM_BY_TYPE;
               queryContent = this.getPetItemTypeBySelectedIndex(index);
               break;
            case ItemBagTab.ELEMENT:
               queryType = ItemBagQueryType.QUERY_ELEMENT;
               queryContent = this.getElementTypeBySelectedIndex(index);
               break;
            case ItemBagTab.PET_SPIRT_TRAIN:
               queryType = ItemBagQueryType.QUERY_PET_SPIRT_TRAIN_BY_TYPE;
               queryContent = this.getPetSpirtTrainTypeBySelectedIndex(index);
         }
         return new ItemBagQuery(queryType,queryContent);
      }
      
      private function getSlotIndexBySelectedIndex(index:int) : int
      {
         var slotIndex:int = 0;
         switch(index)
         {
            case 2:
               slotIndex = int(EquipSlot.HEAD);
               break;
            case 3:
               slotIndex = int(EquipSlot.HAND_RIGHT);
               break;
            case 4:
               slotIndex = int(EquipSlot.DOGZ_RIGHT);
               break;
            case 5:
               slotIndex = int(EquipSlot.BELT);
               break;
            case 6:
               slotIndex = int(EquipSlot.FOOT_RIGHT);
               break;
            case 7:
               slotIndex = int(EquipSlot.WING);
               break;
            case 8:
               slotIndex = int(EquipSlot.EYE);
         }
         return slotIndex;
      }
      
      private function getCollectionTypeBySelectedIndex(index:int) : int
      {
         var collectionType:int = 0;
         switch(index)
         {
            case 0:
               break;
            case 1:
               collectionType = int(CollectionItemType.MINE);
               break;
            case 2:
               collectionType = int(CollectionItemType.TOKEN);
               break;
            case 3:
               collectionType = int(CollectionItemType.FISHROD);
               break;
            case 4:
               collectionType = int(CollectionItemType.FISHBAIT);
               break;
            case 5:
               collectionType = int(CollectionItemType.FISH);
         }
         return collectionType;
      }
      
      private function getPetSpirtTrainTypeBySelectedIndex(index:int) : int
      {
         var type:int = 0;
         switch(index)
         {
            case 0:
               break;
            case 1:
               type = int(PetSpirtTrainItemType.SPIRT);
               break;
            case 2:
               type = int(PetSpirtTrainItemType.EGG);
         }
         return type;
      }
      
      private function getPetItemTypeBySelectedIndex(index:int) : int
      {
         var petItemType:int = 0;
         switch(index)
         {
            case 0:
               break;
            case 1:
               petItemType = int(PetItemType.CAPSULE);
               break;
            case 2:
               petItemType = int(PetItemType.PHYSICAL_MEDICINE);
               break;
            case 3:
               petItemType = int(PetItemType.ANGER_MEDICINE);
               break;
            case 4:
               petItemType = int(PetItemType.CHIP);
               break;
            case 5:
               petItemType = int(PetItemType.GAD);
               break;
            case 6:
               petItemType = int(PetItemType.MAGIC_STONE);
               break;
            case 7:
               petItemType = int(PetItemType.APPRAISAL_MEDICINE);
               break;
            case 8:
               petItemType = int(PetItemType.FIGHT_ITEM);
               break;
            case 9:
               petItemType = int(PetItemType.EVOLUTE_MEDICINE);
               break;
            case 10:
               petItemType = int(PetItemType.CHARACTER_MEDICINE);
               break;
            case 11:
               petItemType = int.MAX_VALUE;
         }
         return petItemType;
      }
      
      private function getElementTypeBySelectedIndex(index:int) : int
      {
         var type:int = 0;
         switch(index)
         {
            case 0:
               break;
            case 1:
               type = int(PetItemType.ELEMENT_ONE);
               break;
            case 2:
               type = int(PetItemType.ELEMENT_TWO);
               break;
            case 3:
               type = int(PetItemType.ELEMENT_THREE);
         }
         return type;
      }
      
      private function reset() : void
      {
         this._filterMenu.reset();
         this._equipFilterPage.reset();
         this._collectionFilterPage.reset();
         this._petItemFilterPage.reset();
         this._elementFilterPage.reset();
         this._petSpirtTrainFilterPage.reset();
      }
      
      public function set currentTab(value:int) : void
      {
         this._currentTab = value;
         var query:ItemBagQuery = this.getQueryByCurrentTab();
         dispatchEvent(new ItemBagEvent(ItemBagEvent.QUERY_ITEM_LIST,query));
         this.reset();
      }
      
      public function set suitVec(value:Vector.<SuitDefinition>) : void
      {
         this._suitExtension.setData(value);
      }
      
      public function collapseDropDown() : void
      {
         this._equipFilterPage.hide();
         this._collectionFilterPage.hide();
         this._petItemFilterPage.hide();
         this._elementFilterPage.hide();
         this._petSpirtTrainFilterPage.hide();
         this._filterMenu.showUp();
      }
   }
}
