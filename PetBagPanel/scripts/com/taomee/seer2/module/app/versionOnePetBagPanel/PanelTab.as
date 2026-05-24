package com.taomee.seer2.module.app.versionOnePetBagPanel
{
   import com.taomee.seer2.app.event.LogicEvent;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.events.ModelLocator;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.manager.EventManager;
   
   public class PanelTab extends Sprite
   {
      
      public static const ACTIVE_TAB_CHANGE:String = "activeTabChange";
      
      public static const INFO_TAB:int = 0;
      
      public static const ABILITY_TAB:int = 1;
      
      public static const SKILL_TAB:int = 2;
      
      public static const MAGIC_TAB:int = 3;
      
      public static const ITEM_TAB:int = 4;
       
      
      private var _mainUI:MovieClip;
      
      private var _btnVec:Vector.<MovieClip>;
      
      private var _introduceBtn:SimpleButton;
      
      private var _newGuideMc:MovieClip;
      
      private var _activeTabIndex:int;
      
      public function PanelTab()
      {
         super();
         this._mainUI = new TabUI();
         this.initialize();
      }
      
      private function initialize() : void
      {
         this.createChildren();
         this.initEventListener();
      }
      
      private function createChildren() : void
      {
         addChild(this._mainUI);
         this._btnVec = new Vector.<MovieClip>();
         this._btnVec.push(this._mainUI["infoTabBtn"]);
         this._btnVec.push(this._mainUI["abilityTabBtn"]);
         this._btnVec.push(this._mainUI["skillTabBtn"]);
         this._btnVec.push(this._mainUI["magicTabBtn"]);
         this._btnVec.push(this._mainUI["itemTabBtn"]);
         this._introduceBtn = this._mainUI["introduceBtn"];
         this._introduceBtn.addEventListener("click",this.onIntroduce);
         this._newGuideMc = this._mainUI["newGuideMc"];
         this._newGuideMc.visible = false;
         ModelLocator.getInstance().addEventListener("newGuideBroad2",this.onGuideTipShow);
      }
      
      private function onGuideTipShow(evt:LogicEvent) : void
      {
         this._newGuideMc.visible = true;
      }
      
      private function onIntroduce(e:MouseEvent) : void
      {
         ModuleManager.showAppModule("NewGuidelinesOld",{
            "type":"Menu",
            "subType":"PetCharater"
         });
      }
      
      private function initEventListener() : void
      {
         var i:int = 0;
         var len:int = int(this._btnVec.length);
         for(i = 0; i < len; )
         {
            this._btnVec[i].buttonMode = true;
            this._btnVec[i].addEventListener("click",this.onTabClick);
            i++;
         }
         EventManager.addEventListener("firstOpenPetbag",this.onFirstOpen);
      }
      
      private function onFirstOpen(evt:Event) : void
      {
         EventManager.removeEventListener("firstOpenPetbag",this.onFirstOpen);
         this.changeTab(this._mainUI["infoTabBtn"]);
      }
      
      private function onTabClick(evt:MouseEvent) : void
      {
         var target:MovieClip = evt.currentTarget as MovieClip;
         this.changeTab(target);
         this._newGuideMc.visible = false;
      }
      
      private function changeTab(btn:MovieClip) : void
      {
         var i:int = 0;
         var selectedIndex:* = 0;
         var len:int = int(this._btnVec.length);
         for(i = 0; i < len; )
         {
            if(this._btnVec[i] == btn)
            {
               selectedIndex = i;
               break;
            }
            i++;
         }
         this.activeTabIndex = selectedIndex;
         if(this.activeTabIndex == 1 || this._activeTabIndex == 4)
         {
            this._introduceBtn.visible = true;
         }
         else
         {
            this._introduceBtn.visible = true;
         }
      }
      
      public function set activeTabIndex(value:int) : void
      {
         var i:int = 0;
         var len:int = int(this._btnVec.length);
         for(i = 0; i < len; )
         {
            if(i == value)
            {
               this._btnVec[i].mouseEnabled = this._btnVec[i].mouseChildren = false;
               this._btnVec[i].gotoAndStop(2);
               this._activeTabIndex = i;
               dispatchEvent(new Event("activeTabChange"));
            }
            else
            {
               this._btnVec[i].mouseEnabled = this._btnVec[i].mouseChildren = true;
               this._btnVec[i].gotoAndStop(1);
            }
            i++;
         }
      }
      
      public function get activeTabIndex() : int
      {
         return this._activeTabIndex;
      }
      
      public function reset() : void
      {
         this.activeTabIndex = 0;
      }
   }
}
