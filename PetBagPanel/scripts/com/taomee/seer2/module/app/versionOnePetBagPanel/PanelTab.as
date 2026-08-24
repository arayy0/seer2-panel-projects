package com.taomee.seer2.module.app.versionOnePetBagPanel {
   import com.taomee.seer2.app.event.LogicEvent;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.events.ModelLocator;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.manager.EventManager;
   
   public class PanelTab extends Sprite {
      public static const ACTIVE_TAB_CHANGE:String = "activeTabChange";
      public static const INFO_TAB:int = 0;
      public static const ABILITY_TAB:int = 1;
      public static const SKILL_TAB:int = 2;
      public static const MAGIC_TAB:int = 3;
      public static const ITEM_TAB:int = 4;
      private var _mainUI:MovieClip;
      private var _btnVec:Vector.<MovieClip>;
      private var _introduceBtn:SimpleButton;
      private var _newGuideMc:PanelTabGuideUI;
      private var _activeTabIndex:int;
      
      public function PanelTab() {
         super();
         this._mainUI = new TabUI();
         this.initialize();
      }
      
      private function initialize() : void {
         this.createChildren();
         this.initEventListener();
      }
      
      private function createChildren() : void {
         this.addChild(this._mainUI);
         this._btnVec = new Vector.<MovieClip>();
         this._btnVec.push(this._mainUI["infoTabBtn"]);
         this._btnVec.push(this._mainUI["abilityTabBtn"]);
         this._btnVec.push(this._mainUI["skillTabBtn"]);
         this._btnVec.push(this._mainUI["magicTabBtn"]);
         this._btnVec.push(this._mainUI["itemTabBtn"]);
         this._introduceBtn = this._mainUI["introduceBtn"];
         this._newGuideMc = null;

      }
      
      private function onGuideTipShow(evt:LogicEvent) : void {
         this._newGuideMc = new PanelTabGuideUI();
         this.addChild(this._newGuideMc);
      }
      
      private function onIntroduce(e:MouseEvent) : void {
         ModuleManager.showAppModule("NewGuidelinesOld",{
            "type":"Menu",
            "subType":"PetCharater"
         });
      }
      
      private function initEventListener() : void {
         var len:int = int(this._btnVec.length);
         for(var i:int = 0; i < len; ++i) {
            this._btnVec[i].buttonMode = true;
            this._btnVec[i].addEventListener("click",this.onTabClick);
         }
         this._introduceBtn.addEventListener("click",this.onIntroduce);
         EventManager.addEventListener("firstOpenPetbag",this.onFirstOpen);
         ModelLocator.getInstance().addEventListener("newGuideBroad2",this.onGuideTipShow);
      }
      
      private function onFirstOpen(evt:Event) : void {
         EventManager.removeEventListener("firstOpenPetbag",this.onFirstOpen);
         this.changeTab(this._mainUI["infoTabBtn"]);
      }
      
      private function onTabClick(evt:MouseEvent) : void {
         var target:MovieClip = evt.currentTarget as MovieClip;
         this.changeTab(target);
         if (this._newGuideMc) {
            this.removeChild(this._newGuideMc);
            this._newGuideMc = null;
         }

      }
      
      private function changeTab(btn:MovieClip) : void {
         var selectedIndex:* = 0;
         var len:int = int(this._btnVec.length);
         for(var i:int = 0; i < len; ++i) {
            if(this._btnVec[i] == btn) {
               selectedIndex = i;
               break;
            }
         }
         this.activeTabIndex = selectedIndex;
      }
      
      public function set activeTabIndex(value:int) : void {
         var len:int = int(this._btnVec.length);
         for(var i:int = 0; i < len; ++i) {
            if(i == value) {
               this._btnVec[i].mouseEnabled = this._btnVec[i].mouseChildren = false;
               this._btnVec[i].gotoAndStop(2);
               this._activeTabIndex = i;
               this.dispatchEvent(new Event("activeTabChange"));
            }
            else {
               this._btnVec[i].mouseEnabled = this._btnVec[i].mouseChildren = true;
               this._btnVec[i].gotoAndStop(1);
            }
         }
      }
      
      public function get activeTabIndex() : int {
         return this._activeTabIndex;
      }
      
      public function reset() : void {
         this.activeTabIndex = 0;
      }
   }
}
