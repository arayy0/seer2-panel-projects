package com.taomee.seer2.module.app.itemBag.element
{
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.config.info.EquipElementInfo;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.inventory.item.EquipItem;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.core.net.MessageEvent;
   import flash.utils.IDataInput;
   
   public class EquipElement
   {
      
      private static var _cookback:Function;
      
      private static var _errorBack:Function;
       
      
      public function EquipElement()
      {
         super();
      }
      
      public static function getStr(info:EquipElementInfo, resId:uint) : String
      {
         var level:uint = getLevel(info,resId);
         if(level == 100)
         {
            return "";
         }
         return ItemConfig.getItemName(resId) + "将会使\n" + info.nextObj + "对" + info.obj + "产生效果：\n" + "<font color=\'#00ff00\'>" + getTip(level,info) + "</font>";
      }
      
      private static function getTip(level:uint, info:EquipElementInfo) : String
      {
         var prevCount:Array = null;
         var str:String = "";
         var type:Array = info.elementType[level - 1];
         var count:Array = info.elementCount[level - 1];
         if(level > 1)
         {
            prevCount = info.elementCount[level - 2];
         }
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
            if(level > 1)
            {
               str += "+" + (count[i] - prevCount[i]).toString();
            }
            else if(level == 1)
            {
               str += "+" + count[i].toString();
            }
            if(i != type.length - 1)
            {
               str += "、";
            }
         }
         return str;
      }
      
      private static function getLevel(info:EquipElementInfo, resId:uint) : uint
      {
         var item:EquipItem = ItemManager.getItemByReferenceId(info.idVec[0]) as EquipItem;
         if(item.strengLevel >= info.levelMax)
         {
            return 100;
         }
         var itemLevel:uint = info.itemVec.indexOf(resId) + 1;
         var nextLevel:uint = itemLevel + item.strengLevel;
         if(nextLevel > info.levelMax)
         {
            nextLevel = uint(info.levelMax);
         }
         return nextLevel;
      }
      
      public static function start(info:EquipElementInfo, resId:uint, fun:Function, errFun:Function) : void
      {
         _cookback = fun;
         _errorBack = errFun;
         Connection.addCommandListener(CommandSet.ELEMENT_EQUIP_1236,onElement);
         Connection.addErrorHandler(CommandSet.ELEMENT_EQUIP_1236,onError);
         Connection.send(CommandSet.ELEMENT_EQUIP_1236,resId,info.idVec[0]);
      }
      
      private static function onError(event:MessageEvent) : void
      {
         var str:String = null;
         Connection.removeCommandListener(CommandSet.ELEMENT_EQUIP_1236,onElement);
         Connection.removeErrorHandler(CommandSet.ELEMENT_EQUIP_1236,onError);
         if(Boolean(event.message.statusCode))
         {
            str = "装备附魔已经到了最高级";
            AlertManager.showAlert(str);
         }
         if(_errorBack != null)
         {
            _errorBack();
         }
      }
      
      private static function onElement(event:MessageEvent) : void
      {
         var equipId:uint = 0;
         var isEquiped:int = 0;
         var equipTime:uint = 0;
         var equipLevel:uint = 0;
         var equipItem:EquipItem = null;
         Connection.removeCommandListener(CommandSet.ELEMENT_EQUIP_1236,onElement);
         Connection.removeErrorHandler(CommandSet.ELEMENT_EQUIP_1236,onError);
         var data:IDataInput = event.message.getRawData();
         var count:uint = uint(data.readUnsignedInt());
         for(var i:int = 0; i < count; i++)
         {
            equipId = uint(data.readUnsignedInt());
            isEquiped = int(data.readUnsignedByte());
            equipTime = uint(data.readUnsignedInt());
            equipLevel = uint(data.readUnsignedInt());
            equipItem = ItemManager.getEquipItem(equipId);
            equipItem.strengLevel = equipLevel;
         }
         if(_cookback != null)
         {
            _cookback();
         }
      }
   }
}
