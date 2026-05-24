package com.taomee.seer2.module.app
{
   import com.taomee.seer2.app.activeCount.ActiveCountManager;
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.data.UserInfo;
   import com.taomee.seer2.app.guide.info.GudieDirectionType;
   import com.taomee.seer2.app.guide.manager.GuideManager;
   import com.taomee.seer2.app.inventory.item.EquipItem;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.net.parser.Parser_1142;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.quest.QuestManager;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.special.SpecialInfo;
   import com.taomee.seer2.core.inventory.Item;
   import com.taomee.seer2.core.manager.TimeManager;
   import com.taomee.seer2.core.module.Module;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.ui.WaitIndicator;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.LifecycleType;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.itemBag.ItemBagPanelUI;
   import com.taomee.seer2.module.app.itemBag.constant.ItemBagQueryType;
   import com.taomee.seer2.module.app.itemBag.data.ItemBagDataService;
   import com.taomee.seer2.module.app.itemBag.data.ItemBagQuery;
   import com.taomee.seer2.module.app.itemBag.events.ItemBagEvent;
   import com.taomee.seer2.module.app.itemBag.ui.ItemBagEquip;
   import com.taomee.seer2.module.app.itemBag.ui.ItemBagFilter;
   import com.taomee.seer2.module.app.itemBag.ui.ItemBagNick;
   import com.taomee.seer2.module.app.itemBag.ui.ItemBagPage;
   import com.taomee.seer2.module.app.itemBag.ui.ItemBagPreview;
   import com.taomee.seer2.module.app.itemBag.ui.ItemBagTab;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.IDataInput;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import org.taomee.manager.EventManager;
   import org.taomee.utils.DisplayUtil;
   
   public class ItemBagPanel extends Module
   {
       
      
      private var _itemBagNick:ItemBagNick;
      
      private var _itemBagPreview:ItemBagPreview;
      
      private var _itemBagEquip:ItemBagEquip;
      
      private var _itemBagTab:ItemBagTab;
      
      private var _itemBagPage:ItemBagPage;
      
      private var _itemBagFilter:ItemBagFilter;
      
      private var _busyIndicator:WaitIndicator;
      
      private var _dataService:ItemBagDataService;
      
      private var _zuanTxt:TextField;
      
      private var _coinsTxt:TextField;
      
      public function ItemBagPanel()
      {
         super();
         _lifecycleType = LifecycleType.GLOBAL;
      }
      
      override public function setup() : void
      {
         setMainUI(new ItemBagPanelUI());
         this._itemBagPreview = new ItemBagPreview();
         addChild(this._itemBagPreview);
         this._itemBagEquip = new ItemBagEquip();
         addChild(this._itemBagEquip);
         this._itemBagPreview.x = this._itemBagEquip.x = 4;
         this._itemBagPreview.y = this._itemBagEquip.y = 55;
         this._itemBagPage = new ItemBagPage();
         addChild(this._itemBagPage);
         this._itemBagTab = new ItemBagTab();
         addChild(this._itemBagTab);
         this._itemBagFilter = new ItemBagFilter();
         addChild(this._itemBagFilter);
         this._itemBagNick = new ItemBagNick();
         addChild(this._itemBagNick);
         this._busyIndicator = new WaitIndicator();
         this._busyIndicator.x = 420;
         this._busyIndicator.y = 150;
         this._dataService = new ItemBagDataService();
         this._zuanTxt = _mainUI["zuanTxt"];
         this._coinsTxt = _mainUI["conisTxt"];
         this.initEventListener();
      }
      
      private function initEventListener() : void
      {
         this._itemBagPage.addEventListener(ItemBagEvent.REQUEST_ADD_EQUIP,this.onRequestAddEquip);
         this._itemBagPage.addEventListener(ItemBagEvent.QUERY_ITEM_REFERES,this.onItemReferes);
         this._itemBagEquip.addEventListener(ItemBagEvent.REQUEST_REMOVE_EQUIP,this.onRequestRemoveEquip);
         this._itemBagFilter.addEventListener(ItemBagEvent.QUERY_SUIT,this.onQuerySuit);
         this._itemBagFilter.addEventListener(ItemBagEvent.QUERY_ITEM_LIST,this.onQueryItemList);
         this._itemBagFilter.addEventListener(ItemBagEvent.QUERY_SEARCH,this.onQuerySearch);
         this._itemBagTab.addEventListener(ItemBagTab.ACTIVE_TAB_CHANGE,this.onActiveTabChange);
      }
      
      private function onUser(event:MouseEvent) : void
      {
         ModuleManager.closeForName("ItemBagPanel");
         ModuleManager.showModule(URLUtil.getAppModule("UserPanel"),"",ActorManager.actorInfo.id);
      }
      
      private function onRequestAddEquip(evt:ItemBagEvent) : void
      {
         evt.stopPropagation();
         var b:Boolean = this.checkBeforeAddEquip();
         if(b == false)
         {
            AlertManager.showAlert("你当前正在使用其他坐骑，请先卸载再试试吧");
            return;
         }
         var item:EquipItem = evt.content as EquipItem;
         item.isEquiped = true;
         this._itemBagPreview.addEquip(item);
         this._dataService.addEquip(item,this.onRequestedEquip);
      }
      
      private function checkGudieEquipTask() : void
      {
         var $rect:Rectangle = null;
         trace(this._dataService.getEquipSuitList().length);
         if(Boolean(QuestManager.isAccepted(53)) && QuestManager.isStepComplete(53,1) == false)
         {
            $rect = new Rectangle(0,0,100,100);
            GuideManager.instance.addTarget($rect,4);
            GuideManager.instance.addGuide2Target($rect,0,4,new Point(508,132),false,false,GudieDirectionType.CONTENT);
            GuideManager.instance.startGuide(4);
         }
      }
      
      private function checkGudieEquipTaskAdd(equipVec:Vector.<EquipItem>) : void
      {
         var $rect:Rectangle = null;
         if(Boolean(QuestManager.isAccepted(53)) && QuestManager.isStepComplete(53,1) == false && equipVec.length >= 2)
         {
            $rect = new Rectangle(0,0,100,100);
            GuideManager.instance.addTarget($rect,5);
            GuideManager.instance.addGuide2Target($rect,0,5,new Point(441,117),false,false,GudieDirectionType.CONTENT);
            GuideManager.instance.startGuide(5);
         }
      }
      
      private function onRequestRemoveEquip(evt:ItemBagEvent) : void
      {
         evt.stopPropagation();
         var item:EquipItem = evt.content as EquipItem;
         item.isEquiped = false;
         this._itemBagPreview.removeEquip(item);
         this._dataService.removeEquip(item,this.onRequestedEquip);
      }
      
      private function onRequestedEquip(itemVec:Vector.<Item>, equipVec:Vector.<EquipItem>) : void
      {
         this.updateData(itemVec,equipVec,true);
         this.checkGudieEquipTaskAdd(equipVec);
      }
      
      private function onQuerySuit(evt:ItemBagEvent) : void
      {
         evt.stopPropagation();
         this._itemBagFilter.suitVec = this._dataService.getEquipSuitList();
      }
      
      private function onQueryItemList(evt:ItemBagEvent) : void
      {
         evt.stopPropagation();
         addChild(this._busyIndicator);
         DisplayObjectUtil.disableSprite(this);
         var query:ItemBagQuery = evt.content as ItemBagQuery;
         this._dataService.requestItemVec(query,this.onRequestItemVec);
      }

      private function onQuerySearch(evt:ItemBagEvent) : void
      {
         evt.stopPropagation();
         var query:ItemBagQuery = evt.content as ItemBagQuery;
         this._dataService.search(query,this.onRequestItemVec);
      }
      
      private function onRequestItemVec(itemVec:Vector.<Item>, equipVec:Vector.<EquipItem>) : void
      {
         DisplayUtil.removeForParent(this._busyIndicator);
         DisplayObjectUtil.enableSprite(this);
         this.updateData(itemVec,equipVec);
         this.checkGudieEquipTaskAdd(equipVec);
      }
      
      private function onActiveTabChange(evt:Event) : void
      {
         this._itemBagFilter.currentTab = this._itemBagTab.activeTab;
         if(this._itemBagTab.activeTab == 4)
         {
            EventManager.dispatchEvent(new Event("clickElement"));
         }
      }
      
      override public function show() : void
      {
         this.updateDisplay();
         LayerManager.focusOnUILayer();
         super.show();
      }
      
      private function updateDisplay() : void
      {
         var userInfo:UserInfo = ActorManager.actorInfo;
         this._zuanTxt.text = "余额:" + userInfo.moneyCount;
         this._coinsTxt.text = userInfo.coins.toString();
         this._itemBagNick.setData(userInfo);
         this._itemBagPreview.setData(userInfo);
         this._itemBagTab.reset();
         SwapManager.swapItem(2258,1,function(data:IDataInput):void
         {
            ActiveCountManager.requestActiveCountList([206409],function(param1:Parser_1142):void
            {
               _zuanTxt.text = "余额:" + userInfo.moneyCount + "  累计消费:" + param1.infoVec[0];
            });
         },null,new SpecialInfo(1,16));
      }
      
      private function onItemReferes(evt:ItemBagEvent) : void
      {
         var userInfo:UserInfo = ActorManager.actorInfo;
         this._itemBagPreview.setData(userInfo);
         this._itemBagTab.reset();
      }
      
      private function updateData(itemVec:Vector.<Item>, equipVec:Vector.<EquipItem>, isKeePageIndex:Boolean = false) : void
      {
         this._itemBagPage.setData(itemVec,isKeePageIndex);
         this._itemBagEquip.setData(equipVec);
      }
      
      private function checkBeforeAddEquip() : Boolean
      {
         var b:Boolean = false;
         var info:PetInfo = ActorManager.getActor().getInfo().ridingPetInfo;
         if(info == null)
         {
            return true;
         }
         if(ActorManager.actorInfo.vipInfo.isVip())
         {
            if(Boolean(info) && info.isPetRiding == true)
            {
               return false;
            }
            return true;
         }
         b = TimeManager.getServerTime() - info.chipPutOnTime < 7 * 24 * 60 * 60;
         if(b == false)
         {
            if(info.isPetRiding == true)
            {
               return false;
            }
            return true;
         }
         if(info.isPetRiding == true)
         {
            return false;
         }
         return true;
      }
      
      private function saveEquipToServer() : void
      {
         var data:LittleEndianByteArray = this._dataService.packEquipDataForServer();
         if(data != null)
         {
            Connection.addCommandListener(CommandSet.EQUIP_CHANGE_1098,this.onEquipChange);
            Connection.send(CommandSet.EQUIP_CHANGE_1098,data);
         }
      }
      
      private function onEquipChange(event:MessageEvent) : void
      {
         var query:ItemBagQuery = null;
         Connection.removeCommandListener(CommandSet.EQUIP_CHANGE_1098,this.onEquipChange);
         if(this.stage != null)
         {
            query = new ItemBagQuery(ItemBagQueryType.QUERY_LAST);
            this._dataService.requestItemVec(query,this.updateData);
         }
      }
      
      override public function hide() : void
      {
         this.saveEquipToServer();
         this._dataService.clear();
         LayerManager.resetOperation();
         super.hide();
      }
   }
}
