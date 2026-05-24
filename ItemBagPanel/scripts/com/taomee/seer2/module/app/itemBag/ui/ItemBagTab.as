package com.taomee.seer2.module.app.itemBag.ui
{
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.module.app.itemBag.ItemBagTabUI;
   import com.taomee.seer2.module.app.itemBag.constant.ItemBagQueryType;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Event(name="queryData",type="com.taomee.seer2.module.app.itemBag.events.ItemBagEvent")]
   public class ItemBagTab extends Sprite
   {
      
      public static const ACTIVE_TAB_CHANGE:String = "activeTabChange";
      
      public static const EQUIP:int = 0;
      
      public static const COLLECTION:int = 1;
      
      public static const PET_ITEM:int = 2;
      
      public static const VIP_ITEM:int = 3;
      
      public static const ELEMENT:int = 4;
      
      public static const PET_SPIRT_TRAIN:int = 5;
      
      private static const TAB_COUNT:int = 6;
       
      
      private var _container:MovieClip;
      
      private var _tabVec:Vector.<SimpleButton>;
      
      private var _backgroundVec:Vector.<MovieClip>;
      
      private var _activeTab:int;
      
      public function ItemBagTab()
      {
         super();
         this.createChildren();
         this.initEventListener();
      }
      
      private function createChildren() : void
      {
         this._container = new ItemBagTabUI();
         this._container.x = 395;
         this._container.y = 485;
         addChild(this._container);
         this._tabVec = new Vector.<SimpleButton>();
         this._tabVec[EQUIP] = this._container["equip"];
         TooltipManager.addCommonTip(this._tabVec[EQUIP],"装备");
         this._tabVec[COLLECTION] = this._container["collection"];
         TooltipManager.addCommonTip(this._tabVec[COLLECTION],"收集品");
         this._tabVec[PET_ITEM] = this._container["petRelate"];
         TooltipManager.addCommonTip(this._tabVec[PET_ITEM],"精灵道具");
         this._tabVec[VIP_ITEM] = this._container["vip"];
         TooltipManager.addCommonTip(this._tabVec[VIP_ITEM],"VIP道具");
         this._tabVec[ELEMENT] = this._container["element"];
         TooltipManager.addCommonTip(this._tabVec[ELEMENT],"附魔道具");
         this._tabVec[PET_SPIRT_TRAIN] = this._container["petSpirtTrain"];
         TooltipManager.addCommonTip(this._tabVec[PET_SPIRT_TRAIN],"精元道具");
         this._backgroundVec = new Vector.<MovieClip>();
         this._backgroundVec[EQUIP] = this._container["equipBackground"];
         this._backgroundVec[COLLECTION] = this._container["collectionBackground"];
         this._backgroundVec[PET_ITEM] = this._container["petRelateBackground"];
         this._backgroundVec[VIP_ITEM] = this._container["vipBackground"];
         this._backgroundVec[ELEMENT] = this._container["elementGround"];
         this._backgroundVec[PET_SPIRT_TRAIN] = this._container["petSpirtTrainGround"];
      }
      
      private function initEventListener() : void
      {
         this.mouseEnabled = false;
         for(var i:int = 0; i < TAB_COUNT; i++)
         {
            this._backgroundVec[i].mouseEnabled = false;
         }
         this.addEventListener(MouseEvent.CLICK,this.onTabClick);
      }
      
      private function onTabClick(evt:MouseEvent) : void
      {
         evt.stopPropagation();
         var target:SimpleButton = evt.target as SimpleButton;
         for(var i:int = 0; i < TAB_COUNT; i++)
         {
            if(target == this._tabVec[i])
            {
               this.activeTab = i;
               break;
            }
         }
      }
      
      public function set activeTab(value:int) : void
      {
         this._activeTab = value;
         this.updateTab();
      }
      
      public function get activeTab() : int
      {
         return this._activeTab;
      }
      
      public function get queryType() : int
      {
         var type:int = 0;
         switch(this._activeTab)
         {
            case EQUIP:
               type = ItemBagQueryType.QUERY_EQUIP;
               break;
            case COLLECTION:
               type = ItemBagQueryType.QUERY_COLLECTION;
               break;
            case PET_ITEM:
               type = ItemBagQueryType.QUERY_PET_ITEM;
               break;
            case PET_SPIRT_TRAIN:
               type = ItemBagQueryType.QUERY_PET_SPIRT_TRAIN;
         }
         return type;
      }
      
      private function updateTab() : void
      {
         for(var i:int = 0; i < TAB_COUNT; i++)
         {
            if(i == this._activeTab)
            {
               this._tabVec[i].mouseEnabled = false;
               this._backgroundVec[i].gotoAndStop(2);
               dispatchEvent(new Event(ACTIVE_TAB_CHANGE));
            }
            else
            {
               this._tabVec[i].mouseEnabled = true;
               this._backgroundVec[i].gotoAndStop(1);
            }
         }
      }
      
      public function reset() : void
      {
         this.activeTab = EQUIP;
      }
   }
}
