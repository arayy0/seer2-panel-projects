package com.taomee.seer2.module.app.itemBag.data
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.config.item.SuitDefinition;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.inventory.constant.PetItemType;
   import com.taomee.seer2.app.inventory.item.CollectionItem;
   import com.taomee.seer2.app.inventory.item.EquipItem;
   import com.taomee.seer2.app.inventory.item.PetItem;
   import com.taomee.seer2.app.inventory.item.PetSpirtTrainItem;
import com.taomee.seer2.app.popup.AlertManager;
import com.taomee.seer2.core.inventory.Item;
   import com.taomee.seer2.core.log.LogLevel;
   import com.taomee.seer2.core.log.Logger;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.module.app.itemBag.constant.ItemBagQueryType;
   import flash.events.EventDispatcher;
   
   public class ItemBagDataService extends EventDispatcher
   {
       
      
      private var _originalEquipedItemVec:Vector.<EquipItem>;
      
      private var _originalUnEquipedItemVec:Vector.<EquipItem>;
      
      private var _localEquipedItemVec:Vector.<EquipItem>;
      
      private var _localUnEquipedItemVec:Vector.<EquipItem>;
      
      private var _collectionItemVec:Vector.<Item>;
      
      private var _petItemVec:Vector.<Item>;
      
      private var _emblemItemVec:Vector.<Item>;
      
      private var _petSpirtTrainItemVec:Vector.<Item>;
      
      private var _query:ItemBagQuery;
      
      private var _requestCallBack:Function;
      
      private var _logger:Logger;
      
      private var _isInitializedLocalEquip:Boolean;
      
      private var _hasInitData:Boolean = false;

      private var _searchStr:String;

      private var _onSearch:Boolean;
      
      public function ItemBagDataService()
      {
         super();
         this.initialize();
      }
      
      private function initialize() : void
      {
         this._logger = Logger.getLogger("ItemBagPanel");
         this._logger.setLevel(LogLevel.ERROR);
         this._isInitializedLocalEquip = false;
         this._localEquipedItemVec = new Vector.<EquipItem>();
         this._localUnEquipedItemVec = new Vector.<EquipItem>();
         this._onSearch = false;
      }
      
      public function requestItemVec(query:ItemBagQuery, callBack:Function) : void
      {
         this._requestCallBack = callBack;
         if(query.type != ItemBagQueryType.QUERY_LAST)
         {
            this._query = query;
         }
         if(!this._hasInitData)
         {
            ItemManager.requestEquipList(this.onRequestEquipVec);
         }
         else
         {
            this.callBackForRequest();
         }
      }

      public function search(query:ItemBagQuery, callBack:Function):void
      {
         this._requestCallBack = callBack;
         this._searchStr = query.content;
         if(!this._hasInitData)
         {
            ItemManager.requestEquipList(this.onRequestEquipVec);
         }
         else
         {
            this._onSearch = true;
            this.callBackForRequest();
         }
      }
      
      private function onRequestEquipVec() : void
      {
         var item:EquipItem = null;
         var itemVec:Vector.<EquipItem> = ItemManager.getEquipVec();
         this._originalEquipedItemVec = new Vector.<EquipItem>();
         this._originalUnEquipedItemVec = new Vector.<EquipItem>();
         for each(item in itemVec)
         {
            if(item.isEquiped == true)
            {
               this._originalEquipedItemVec.push(item);
            }
            else
            {
               this._originalUnEquipedItemVec.push(item);
            }
         }
         if(this._isInitializedLocalEquip == false)
         {
            this._isInitializedLocalEquip = true;
            this._localEquipedItemVec = this._originalEquipedItemVec.slice();
            this._localUnEquipedItemVec = this._originalUnEquipedItemVec.slice();
         }
         ItemManager.requestItemList(this.onRequestNonEquipVec);
      }
      
      private function onRequestNonEquipVec() : void
      {
         this._collectionItemVec = Vector.<Item>(ItemManager.getCollectionVec().slice());
         this._petSpirtTrainItemVec = Vector.<Item>(ItemManager.getPetSpirtTrainVec().slice());
         this._petItemVec = Vector.<Item>(ItemManager.getPetRelateVec().slice());
         this._emblemItemVec = new Vector.<Item>();
         this._hasInitData = true;
         this.callBackForRequest();
      }
      
      private function callBackForRequest() : void
      {
         this._requestCallBack(this.currentItemVec,this._localEquipedItemVec);
         this._requestCallBack = null;
      }
      
      private function get currentItemVec() : Vector.<Item>
      {
         var itemVec:Vector.<Item> = null;
         switch(this._query.type)
         {
            case ItemBagQueryType.QUERY_EQUIP:
               itemVec = Vector.<Item>(this._localUnEquipedItemVec).slice();
               break;
            case ItemBagQueryType.QUERY_EQUIP_BY_SLOT_INDEX:
               itemVec = this.getItemVecBySlotIndex(int(this._query.content));
               break;
            case ItemBagQueryType.QUERY_EQUIP_BY_SUIT_ID:
               itemVec = this.getItemVecBySuitId(int(this._query.content));
               break;
            case ItemBagQueryType.QUERY_COLLECTION:
               itemVec = this._collectionItemVec.slice();
               break;
            case ItemBagQueryType.QUERY_COLLECTION_BY_TYPE:
               itemVec = this.getItemVecByCollectionType(int(this._query.content));
               break;
            case ItemBagQueryType.QUERY_PET_ITEM:
               itemVec = this._petItemVec.concat(this._emblemItemVec);
               itemVec = this.updateItemPet(itemVec);
               break;
            case ItemBagQueryType.QUERY_PET_ITEM_BY_TYPE:
               itemVec = this.getItemVecByPetItemType(int(this._query.content));
               break;
            case ItemBagQueryType.QUERY_VIP_ITEM:
               itemVec = this.getVipItemList();
               break;
            case ItemBagQueryType.QUERY_ELEMENT:
               itemVec = this.getElementList(int(this._query.content));
               break;
            case ItemBagQueryType.QUERY_PET_SPIRT_TRAIN:
               itemVec = this._petSpirtTrainItemVec.slice();
               break;
            case ItemBagQueryType.QUERY_PET_SPIRT_TRAIN_BY_TYPE:
               itemVec = this.getItemVecByPetSpirtTrainType(int(this._query.content));
         }
         this.sortByGetTime(itemVec);
         if(this._onSearch)
         {
            this._onSearch = false;
            return this.sortByName(itemVec);
         }
         else
         {
            return itemVec;
         }
      }
      
      private function sortByGetTime(itemVec:Vector.<Item>) : void
      {
         itemVec.sort(function(compare1:Item, compare2:Item):int
         {
            if(compare1.getTime > compare2.getTime)
            {
               return -1;
            }
            if(compare1.getTime < compare2.getTime)
            {
               return 1;
            }
            return 0;
         });
      }

      private function sortByName(itemVec:Vector.<Item>) : Vector.<Item>
      {
         var i:int = 0;
         var j:int = 0;
         var resultVec:Vector.<Item> = new Vector.<Item>();
         var allVec:Vector.<Item> = itemVec;
         var searchStrArr:Array = this._searchStr.split(/[\s,\/!\\]+/);
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
         }
         return resultVec;
      }
      
      private function updateItemPet(itemVec:Vector.<Item>) : Vector.<Item>
      {
         var petItem:PetItem = null;
         var arr:Vector.<Item> = Vector.<Item>([]);
         for(var i:int = 0; i < itemVec.length; i++)
         {
            petItem = itemVec[i] as PetItem;
            if(itemVec[i].referenceId < 205000 || itemVec[i].referenceId > 206999)
            {
               arr.push(itemVec[i]);
            }
         }
         return arr;
      }
      
      private function getItemVecBySlotIndex(slotIndex:int) : Vector.<Item>
      {
         var item:EquipItem = null;
         var itemVec:Vector.<Item> = new Vector.<Item>();
         for each(item in this._localUnEquipedItemVec)
         {
            if(item.slotIndex == slotIndex)
            {
               itemVec.push(item);
            }
         }
         return itemVec;
      }
      
      private function getItemVecBySuitId(suitId:int) : Vector.<Item>
      {
         var item:EquipItem = null;
         var itemVec:Vector.<Item> = new Vector.<Item>();
         for each(item in this._localUnEquipedItemVec)
         {
            if(item.suitId == suitId)
            {
               itemVec.push(item);
            }
         }
         return itemVec;
      }
      
      private function getItemVecByCollectionType(type:int) : Vector.<Item>
      {
         var item:CollectionItem = null;
         var itemVec:Vector.<Item> = new Vector.<Item>();
         for each(item in this._collectionItemVec)
         {
            if(item.collectionType == type)
            {
               itemVec.push(item);
            }
         }
         return itemVec;
      }
      
      private function getItemVecByPetSpirtTrainType(type:int) : Vector.<Item>
      {
         var item:PetSpirtTrainItem = null;
         var itemVec:Vector.<Item> = new Vector.<Item>();
         for each(item in this._petSpirtTrainItemVec)
         {
            if(item.getType() == type)
            {
               itemVec.push(item);
            }
         }
         return itemVec;
      }
      
      private function getItemVecByPetItemType(type:int) : Vector.<Item>
      {
         var item:PetItem = null;
         var index:int = 0;
         if(type == int.MAX_VALUE)
         {
            return this._emblemItemVec.slice();
         }
         var itemVec:Vector.<Item> = new Vector.<Item>();
         var comboType:Vector.<int> = Vector.<int>([PetItemType.MAGIC_STONE,PetItemType.FIGHT_ITEM]);
         var comboTypeList:Array = [[19,20],[17,18]];
         for each(item in this._petItemVec)
         {
            if(comboType.indexOf(type) != -1)
            {
               index = comboType.indexOf(type);
               if((comboTypeList[index] as Array).indexOf(item.type) != -1)
               {
                  itemVec.push(item);
               }
            }
            else if(item.type == type)
            {
               itemVec.push(item);
            }
         }
         return itemVec;
      }
      
      private function getVipItemList() : Vector.<Item>
      {
         var item:Item = null;
         var arr:Array = [this._localUnEquipedItemVec,this._collectionItemVec,this._petItemVec,this._emblemItemVec];
         var resultVec:Vector.<Item> = new Vector.<Item>();
         for(var i:int = 0; i < arr.length; i++)
         {
            for each(item in arr[i])
            {
               if(item.isVipOnly)
               {
                  resultVec.push(item);
               }
            }
         }
         return resultVec;
      }
      
      private function getElementList(type:uint) : Vector.<Item>
      {
         var item:PetItem = null;
         var itemVec:Vector.<Item> = new Vector.<Item>();
         for each(item in this._petItemVec)
         {
            if(type == 0 && (item.type == 21 || item.type == 22 || item.type == 23))
            {
               itemVec.push(item);
            }
            else if(item.type == type)
            {
               itemVec.push(item);
            }
         }
         return itemVec;
      }
      
      public function getEquipSuitList() : Vector.<SuitDefinition>
      {
         var item:EquipItem = null;
         var suitId:int = 0;
         var suitVec:Vector.<SuitDefinition> = new Vector.<SuitDefinition>();
         for each(item in this._localUnEquipedItemVec)
         {
            suitId = int(item.suitId);
            if(this.containsSuitId(suitVec,suitId) == false)
            {
               this.addDefinitionToSuitVec(suitId,suitVec);
            }
         }
         return suitVec;
      }
      
      private function containsSuitId(suitVec:Vector.<SuitDefinition>, suitId:int) : Boolean
      {
         var count:int = int(suitVec.length);
         for(var i:int = 0; i < count; i++)
         {
            if(suitVec[i].id == suitId)
            {
               return true;
            }
         }
         return false;
      }
      
      private function addDefinitionToSuitVec(suitId:int, suitVec:Vector.<SuitDefinition>) : void
      {
         var definition:SuitDefinition = ItemConfig.getSuitDefinition(suitId);
         if(definition != null)
         {
            suitVec.push(definition);
         }
         else
         {
            this._logger.error("套装表还没有配置" + suitId + "项");
         }
      }
      
      public function addEquip(item:EquipItem, callBack:Function) : void
      {
         this._requestCallBack = callBack;
         this.removeLocalEquipBySlotIndex(item);
         this._localEquipedItemVec.push(item);
         this.removeEquipFromLocalEquipedItemVec(this._localUnEquipedItemVec,item);
         this.callBackForRequest();
      }
      
      public function removeEquip(item:EquipItem, callBack:Function) : void
      {
         this._requestCallBack = callBack;
         this._localUnEquipedItemVec.push(item);
         this.removeEquipFromLocalEquipedItemVec(this._localEquipedItemVec,item);
         this.callBackForRequest();
      }
      
      private function removeLocalEquipBySlotIndex(item:EquipItem) : void
      {
         var equipItem:EquipItem = null;
         var count:int = int(this._localEquipedItemVec.length);
         for(var i:int = count - 1; i >= 0; i--)
         {
            equipItem = this._localEquipedItemVec[i];
            if(equipItem.slotIndex == item.slotIndex)
            {
               this._localUnEquipedItemVec.push(equipItem);
               this._localEquipedItemVec.splice(i,1);
               item.isEquiped = true;
               equipItem.isEquiped = false;
               break;
            }
         }
      }
      
      private function removeEquipFromLocalEquipedItemVec(itemVec:Vector.<EquipItem>, item:Item) : void
      {
         var count:int = int(itemVec.length);
         for(var i:int = count - 1; i >= 0; i--)
         {
            if(itemVec[i].referenceId == item.referenceId)
            {
               itemVec.splice(i,1);
               break;
            }
         }
      }
      
      public function packEquipDataForServer() : LittleEndianByteArray
      {
         var item:Item = null;
         this.reassignLocalEquipItem();
         if(this.hasChangeEquip() == false)
         {
            return null;
         }
         var rawData:LittleEndianByteArray = new LittleEndianByteArray();
         rawData.writeUnsignedInt(this._localEquipedItemVec.length);
         for each(item in this._localEquipedItemVec)
         {
            rawData.writeUnsignedInt(item.referenceId);
         }
         rawData.writeUnsignedInt(1);
         rawData.writeUnsignedInt(ActorManager.getActor().getNono().nonoInfo.equipId);
         return rawData;
      }
      
      public function packEquipData() : Vector.<EquipItem>
      {
         return this._localEquipedItemVec;
      }
      
      private function reassignLocalEquipItem() : void
      {
         this._isInitializedLocalEquip = false;
      }
      
      private function hasChangeEquip() : Boolean
      {
         var orginalItem:EquipItem = null;
         var hasOrginalItem:Boolean = false;
         var item:EquipItem = null;
         if(this._originalEquipedItemVec.length != this._localEquipedItemVec.length)
         {
            return true;
         }
         var _loc4_:int = 0;
         var _loc5_:* = this._originalEquipedItemVec;
         do
         {
            for each(orginalItem in _loc5_)
            {
               hasOrginalItem = false;
               for each(item in this._localEquipedItemVec)
               {
                  if(orginalItem.referenceId == item.referenceId)
                  {
                     hasOrginalItem = true;
                     break;
                  }
               }
            }
            return false;
         }
         while(hasOrginalItem != false);
         
         return true;
      }
      
      public function clear() : void
      {
         this._originalEquipedItemVec = null;
         this._originalUnEquipedItemVec = null;
         this._collectionItemVec = null;
         this._petSpirtTrainItemVec = null;
         this._petItemVec = null;
         this._hasInitData = false;
      }
   }
}
