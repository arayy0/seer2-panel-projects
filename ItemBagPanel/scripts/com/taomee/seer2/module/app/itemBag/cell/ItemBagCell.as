package com.taomee.seer2.module.app.itemBag.cell
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.component.ItemToolTip;
   import com.taomee.seer2.app.config.EquipElementConfig;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.config.item.PetSpirtTrainItemDefinition;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.inventory.item.EquipItem;
   import com.taomee.seer2.core.inventory.Item;
   import com.taomee.seer2.core.ui.UINumberGenerator;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.module.app.itemBag.ItemBagCellUI;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ItemBagCell extends Sprite
   {
       
      
      private var _mainMc:MovieClip;
      
      private var _backgroundMC:MovieClip;
      
      private var _itemNumSpr:Sprite;
      
      private var _iconDisplayer:IconDisplayer;
      
      private var _vipFlag:MovieClip;
      
      protected var _item:Item;
      
      protected var _isChangeBackground:Boolean;
      
      protected var _isShowNumber:Boolean;
      
      protected var _isHandCursor:Boolean;
      
      public function ItemBagCell()
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
         this.createBackground();
         this.createIconDisplayer();
         this.createItemNumber();
      }
      
      private function createBackground() : void
      {
         this._mainMc = new ItemBagCellUI();
         this._backgroundMC = this._mainMc["bg"];
         this._backgroundMC.gotoAndStop(1);
         addChild(this._backgroundMC);
         this._vipFlag = this._mainMc["vipFlag"];
         addChild(this._vipFlag);
         this._vipFlag.visible = false;
      }
      
      private function createIconDisplayer() : void
      {
         this._iconDisplayer = new IconDisplayer();
         this._iconDisplayer.x = 1;
         this._iconDisplayer.y = 1;
         addChild(this._iconDisplayer);
      }
      
      private function createItemNumber() : void
      {
         this._itemNumSpr = new Sprite();
         this._itemNumSpr.x = 60;
         this._itemNumSpr.y = 43;
         addChild(this._itemNumSpr);
      }
      
      private function initEventListener() : void
      {
         this.mouseChildren = false;
         this.addEventListener(MouseEvent.CLICK,this.onMouseClick);
      }
      
      protected function onMouseClick(e:MouseEvent) : void
      {
      }
      
      private function onMouseOver(e:MouseEvent) : void
      {
         if(this._isChangeBackground)
         {
            this._backgroundMC.gotoAndStop(2);
         }
         var item:Item = ItemManager.getItemByReferenceId(this._item.referenceId);
         if(item != null)
         {
            this._item.expiryTime = item.expiryTime;
            ItemToolTip.show(this._item);
         }
      }
      
      private function onMouseOut(e:MouseEvent) : void
      {
         if(this._isChangeBackground)
         {
            this._backgroundMC.gotoAndStop(1);
         }
         ItemToolTip.hide();
      }
      
      public function setData(item:Item) : void
      {
         this._item = item;
         this.reset();
         if(Boolean(this._item))
         {
            this.updateData();
            this.updateDisplay();
         }
      }
      
      protected function updateData() : void
      {
      }
      
      protected function updateDisplay() : void
      {
         var tipStr:String = null;
         var resId:uint = 0;
         this.mouseEnabled = true;
         this.buttonMode = this._isHandCursor;
         if(this._item.name == "默认眼睛2")
         {
            trace("xxxxxxxxxxxxxx" + this._item.referenceId);
            trace("xxxxxxxxxxxxxx" + this._item.iconUrl);
         }
         this._iconDisplayer.setIconUrl(this._item.iconUrl,this.onIconLoadComplete);
         addChildAt(this._vipFlag,this.numChildren - 1);
         this._vipFlag.visible = this._item.isVipOnly;
         if(this._item.referenceId >= 801000 && this._item.referenceId <= 802999)
         {
            resId = uint((ItemConfig.getItemDefinition(this._item.referenceId) as PetSpirtTrainItemDefinition).breedMonID);
            tipStr = String(ItemConfig.getItemDefinition(this._item.referenceId).tip);
            TooltipManager.addIconTip(this,resId,true,tipStr);
         }
         else
         {
            tipStr = this.getFilterTip();
            TooltipManager.addIconTip(this,this._item.referenceId,false,tipStr);
         }
      }
      
      private function getFilterTip() : String
      {
         var leftDay:int = 0;
         var tipStr:String = "";
         if(this._item is EquipItem && Boolean((this._item as EquipItem).strengLevel))
         {
            tipStr = this.getUpdateElement(this._item as EquipItem) + "";
         }
         if(this._item is EquipItem && this._item.price > 0)
         {
            leftDay = int((this._item as EquipItem).leftDay);
            tipStr += leftDay == 0 ? "永久不过期" : "剩余" + leftDay + "天到期\n";
         }
         return tipStr + ItemConfig.getItemDefinition(this._item.referenceId).tip;
      }
      
      private function getUpdateElement(item:EquipItem) : String
      {
         var str:String = "";
         item.elementInfo = EquipElementConfig.getInfo(item.referenceId);
         if(item.elementInfo != null)
         {
            if(item.elementInfo.idVec.length > 1)
            {
               str = "套装效果:";
            }
            else
            {
               str = "装备效果";
            }
            str += "使" + item.elementInfo.obj + "的";
            str += this.getElementType(item.elementInfo.elementType,item.elementInfo.elementCount,item.strengLevel);
            if(this.isEquiped(item))
            {
               switch(item.strengLevel)
               {
                  case 1:
                     str = "<font color=\'#FFFFFF\'>" + str + "</font>";
                     break;
                  case 2:
                     str = "<font color=\'#00ff00\'>" + str + "</font>";
                     break;
                  case 3:
                     str = "<font color=\'#0072FA\'>" + str + "</font>";
                     break;
                  case 4:
                     str = "<font color=\'#EE5812\'>" + str + "</font>";
                     break;
                  case 5:
                     str = "<font color=\'#EECD02\'>" + str + "</font>";
               }
            }
            else
            {
               str = "<font color=\'#99918E\'>" + str + "</font>";
            }
         }
         return str;
      }
      
      private function isEquiped(item:EquipItem) : Boolean
      {
         var id:uint = 0;
         var b:Boolean = true;
         for each(id in item.elementInfo.idVec)
         {
            if(ItemManager.getItemByReferenceId(id) == null || (ItemManager.getItemByReferenceId(id) as EquipItem).isEquiped == false)
            {
               b = false;
            }
         }
         return b;
      }
      
      private function getElementType(typeArr:Array, countArr:Array, strengLevel:uint) : String
      {
         var str:String = "";
         var type:Array = typeArr[strengLevel - 1];
         var count:Array = countArr[strengLevel - 1];
         for(var i:int = 0; i < type.length; i++)
         {
            switch(type[i])
            {
               case 1:
                  str += "物攻值";
                  break;
               case 2:
                  str += "物防值";
                  break;
               case 3:
                  str += "特攻值";
                  break;
               case 4:
                  str += "特防值";
                  break;
               case 5:
                  str += "速度值";
                  break;
               case 6:
                  str += "体力值";
                  break;
               case 7:
                  str += "全能力值";
                  break;
            }
            str += "+" + count[i].toString();
            if(i != type.length - 1)
            {
               str += ",";
            }
         }
         return str + "点\n";
      }
      
      public function reset() : void
      {
         this.mouseEnabled = false;
         this.buttonMode = false;
         this._iconDisplayer.removeIcon();
         TooltipManager.remove(this);
         DisplayObjectUtil.removeAllChildren(this._itemNumSpr);
         DisplayObjectUtil.recoverDisplayObject(this);
         this._vipFlag.visible = false;
      }
      
      private function onIconLoadComplete() : void
      {
         var itemNumber:Sprite = null;
         if(this._isShowNumber)
         {
            itemNumber = UINumberGenerator.generateItemNumber(this._item.quantity);
            itemNumber.x = -itemNumber.width;
            this._itemNumSpr.addChild(itemNumber);
            addChild(this._itemNumSpr);
         }
      }
   }
}
