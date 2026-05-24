package com.taomee.seer2.module.app.itemBag.cell
{
   import com.taomee.seer2.app.config.EquipElementConfig;
   import com.taomee.seer2.app.config.info.EquipElementInfo;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.inventory.constant.ItemCategory;
   import com.taomee.seer2.app.inventory.item.EquipItem;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.app.vip.VipManager;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.itemBag.element.EquipElement;
   import com.taomee.seer2.module.app.itemBag.events.ItemBagEvent;
   import flash.events.MouseEvent;
   import flash.utils.IDataInput;
   
   public class ItemBagPageCell extends ItemBagCell
   {
       
      
      private var _isEquip:Boolean;
      
      private var _isFitForVip:Boolean;
      
      public function ItemBagPageCell()
      {
         super();
         _isChangeBackground = true;
      }
      
      override protected function onMouseClick(evt:MouseEvent) : void
      {
         var itemArr:Array;
         var indexArr:Array;
         var countArr:Array;
         var vipIndex:int = 0;
         var ob:Object = null;
         var obj:Object = null;
         var info:EquipElementInfo = null;
         var spItemList:Vector.<uint> = Vector.<uint>([200231,201026,200233,201033,400150,400151,201029,400141,400142,400143,400144,400145,400394]);
         var spSwapList:Vector.<uint> = Vector.<uint>([776,847,846,1002,1070,1071,1445,1836,1837,1838,1839,1840,2257]);
         if(spItemList.indexOf(_item.referenceId) != -1)
         {
            SwapManager.swapItem(spSwapList[spItemList.indexOf(_item.referenceId)],1,function(data:IDataInput):void
            {
               new SwapInfo(data);
               ModuleManager.closeForName("ItemBagPanel");
            });
            return;
         }
         itemArr = [200234,200235,200236,200637,201037,201038,200239,200240,200241];
         indexArr = [899,900,985,997,1439,1440,1437,1438,1555];
         countArr = [10,15,20,5,40,510,40,510,5];
         if(itemArr.indexOf(_item.referenceId) != -1)
         {
            vipIndex = itemArr.indexOf(_item.referenceId);
            ob = new Object();
            ob.type = 5;
            ob.index = indexArr[vipIndex];
            ob.cost = 0;
            ob.count = countArr[vipIndex];
            ob.fun = null;
            ModuleManager.toggleModule(URLUtil.getAppModule("VipPetBagPanel"),"正在打开vip精灵面板...",ob);
            ModuleManager.closeForName("ItemBagPanel");
         }
         if(_item.referenceId >= 205000 && _item.referenceId < 206999)
         {
            obj = new Object();
            obj.id = _item.referenceId;
            info = EquipElementConfig.getItemInfo(_item.referenceId);
            if(this.getHasElement(info) == false)
            {
               AlertManager.showAlert("只有凑齐套装才可以使用卷轴哟！");
               return;
            }
            if(this.getHasLevelElement(info) == false)
            {
               AlertManager.showAlert("附魔装备已经达到附魔巅峰");
               return;
            }
            AlertManager.showConfirm(EquipElement.getStr(info,_item.referenceId),function():void
            {
               EquipElement.start(info,_item.referenceId,function():void
               {
                  AlertManager.showAlert("附魔成功");
                  _item.quantity -= 1;
                  dispatchEvent(new ItemBagEvent(ItemBagEvent.QUERY_ITEM_REFERES,_item,true));
               },function():void
               {
                  AlertManager.showAlert("附魔失败");
               });
            },function():void
            {
            });
         }
         if(this._isEquip && this._isFitForVip)
         {
            dispatchEvent(new ItemBagEvent(ItemBagEvent.REQUEST_ADD_EQUIP,_item,true));
         }
      }
      
      private function getHasElement(info:EquipElementInfo) : Boolean
      {
         var id:uint = 0;
         var b:Boolean = true;
         for each(id in info.idVec)
         {
            if(ItemManager.getItemByReferenceId(id) == null)
            {
               b = false;
            }
         }
         return b;
      }
      
      private function getHasLevelElement(info:EquipElementInfo) : Boolean
      {
         var equip:EquipItem = ItemManager.getItemByReferenceId(info.idVec[0]) as EquipItem;
         if(equip.strengLevel >= info.levelMax)
         {
            return false;
         }
         return true;
      }
      
      override protected function updateData() : void
      {
         if(_item.category == ItemCategory.EQUIP)
         {
            _isShowNumber = false;
            this._isEquip = true;
            this._isFitForVip = !_item.isVipOnly || Boolean(VipManager.vipInfo.isVip());
            _isHandCursor = this._isFitForVip;
         }
         else
         {
            _isShowNumber = true;
            this._isEquip = false;
            this._isFitForVip = true;
            _isHandCursor = false;
            if(_item.referenceId == 200231)
            {
               _isHandCursor = true;
            }
            if(_item.referenceId >= 205000 && _item.referenceId < 206999)
            {
               _isHandCursor = true;
            }
         }
      }
      
      override protected function updateDisplay() : void
      {
         super.updateDisplay();
         if(this._isFitForVip)
         {
            DisplayObjectUtil.recoverDisplayObject(this);
         }
         else
         {
            DisplayObjectUtil.grayDisplayObject(this);
         }
      }
   }
}
