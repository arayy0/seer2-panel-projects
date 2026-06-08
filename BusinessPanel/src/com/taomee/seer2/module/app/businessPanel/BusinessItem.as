package com.taomee.seer2.module.app.businessPanel
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.component.ItemToolTip;
   import com.taomee.seer2.app.config.item.CollectionItemDefinition;
   import com.taomee.seer2.app.config.item.PetItemDefinition;
   import com.taomee.seer2.core.inventory.Item;
   import com.taomee.seer2.core.ui.UINumberGenerator;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.BusinessPanelItemUI;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BusinessItem extends Sprite
   {
      
      public static const ITEM_USE:String = "itemUseBusiness";
      
      private static const DEFAULT_SIZE:int = 60;
      
      private var _container:MovieClip;
      
      private var _iconDisplayer:IconDisplayer;
      
      private var _itemNumSpr:Sprite;
      
      private var _bgMc:MovieClip;
      
      private var _item:Item;
      
      private var _definition:PetItemDefinition;
      
      private var _conDefinition:CollectionItemDefinition;
      
      public function BusinessItem()
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
         this._container = new BusinessPanelItemUI();
         addChild(this._container);
         this._iconDisplayer = new IconDisplayer();
         addChild(this._iconDisplayer);
         this._itemNumSpr = new Sprite();
         this._itemNumSpr.x = 60;
         this._itemNumSpr.y = 43;
         addChild(this._itemNumSpr);
         this._container.gotoAndStop(1);
      }
      
      private function initEventListener() : void
      {
         this.mouseChildren = false;
         this.addEventListener(MouseEvent.CLICK,this.onMouseClick);
         this.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      private function onMouseClick(evt:MouseEvent) : void
      {
         dispatchEvent(new Event(ITEM_USE));
      }
      
      private function onMouseOver(evt:MouseEvent) : void
      {
         ItemToolTip.show(this._item);
      }
      
      private function onMouseOut(evt:MouseEvent) : void
      {
         ItemToolTip.hide();
      }
      
      public function setData(item:Item) : void
      {
         this.reset();
         this._item = item;
         if(this._item != null)
         {
            this.buttonMode = true;
            this.mouseEnabled = true;
            this._iconDisplayer.setIconUrl(this._item.iconUrl,this.onLoadComplete);
         }
      }
      
      public function setDefinition(item:PetItemDefinition) : void
      {
         this.reset();
         this._definition = item;
         if(this._definition != null)
         {
            this.buttonMode = true;
            this.mouseEnabled = true;
            this._iconDisplayer.setIconUrl(URLUtil.getPetRelateIcon(this._definition.id),function():void
            {
               _iconDisplayer.x = (DEFAULT_SIZE - _iconDisplayer.width) / 2;
               _iconDisplayer.y = (DEFAULT_SIZE - _iconDisplayer.height) / 2;
            });
         }
      }
      
      public function setConDefinition(item:CollectionItemDefinition) : void
      {
         this.reset();
         this._conDefinition = item;
         if(this._conDefinition != null)
         {
            this.buttonMode = true;
            this.mouseEnabled = true;
            this._iconDisplayer.setIconUrl(URLUtil.getCollectionIcon(this._conDefinition.id),function():void
            {
               _iconDisplayer.x = (DEFAULT_SIZE - _iconDisplayer.width) / 2;
               _iconDisplayer.y = (DEFAULT_SIZE - _iconDisplayer.height) / 2;
            });
         }
      }
      
      public function reset() : void
      {
         this.buttonMode = false;
         this.mouseEnabled = false;
         this._iconDisplayer.removeIcon();
         DisplayObjectUtil.removeAllChildren(this._itemNumSpr);
         this._container.gotoAndStop(1);
      }
      
      private function onLoadComplete() : void
      {
         this._iconDisplayer.x = (DEFAULT_SIZE - this._iconDisplayer.width) / 2;
         this._iconDisplayer.y = (DEFAULT_SIZE - this._iconDisplayer.height) / 2;
         this.addItemNumber();
      }
      
      private function addItemNumber() : void
      {
         var itemNumber:Sprite = UINumberGenerator.generateItemNumber(this._item.quantity);
         itemNumber.x = -itemNumber.width;
         this._itemNumSpr.addChild(itemNumber);
         addChild(this._itemNumSpr);
      }
      
      public function isShowNumSpr(value:Boolean) : void
      {
         if(value)
         {
            this._itemNumSpr.visible = true;
         }
         else
         {
            this._itemNumSpr.visible = false;
         }
      }
      
      public function set isSelected(value:Boolean) : void
      {
         if(value)
         {
            this._container.gotoAndStop(2);
         }
         else
         {
            this._container.gotoAndStop(1);
         }
      }
      
      public function get item() : Item
      {
         return this._item;
      }
      
      public function get definition() : PetItemDefinition
      {
         return this._definition;
      }
      
      public function get conDefinition() : CollectionItemDefinition
      {
         return this._conDefinition;
      }
   }
}

