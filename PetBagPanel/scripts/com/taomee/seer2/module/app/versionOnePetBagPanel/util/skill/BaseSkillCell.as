package com.taomee.seer2.module.app.versionOnePetBagPanel.util.skill {
   import com.taomee.seer2.app.pet.data.HideSkillInfo;
   import com.taomee.seer2.app.pet.data.SkillInfo;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
import com.taomee.seer2.core.utils.DisplayObjectUtil;

import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class BaseSkillCell extends Sprite {
      public static const CELL_CLICK:String = "cellClick";
      protected var _container:MovieClip;
      protected var _skillInfo:SkillInfo;
      protected var _isHide:Boolean;
      protected var _hasLearnSkill:Boolean;
      private var _nameTxt:TextField;
      private var _powerTxt:TextField;
      private var _background:MovieClip;
      private var _skillAnimation:MovieClip;
      private var _hideTips:Sprite;
      private var _isSelected:Boolean;
      private var _isInteractive:Boolean;
      private var _wlTxt:TextField;
      private var _nqTxt:TextField;

      public function BaseSkillCell() {
         super();
         this.initialize();
      }
      
      private function initialize() : void {
         this.createChildren();
         this.initEventListener();
      }
      
      private function createChildren() : void {
         this.createContainer();
         this.extractAssets();
      }
      
      protected function createContainer() : void {
      }
      
      protected function extractAssets() : void {
         this._nameTxt = this._container["nameTxt"];
         this._powerTxt = this._container["powerTxt"];
         this._wlTxt = this._container["wlTxt"];
         this._nqTxt = this._container["nqTxt"];
         this._hideTips = this._container["hideTips"];
         this._background = this._container["background"];
         this._background.gotoAndStop(1);
         this._skillAnimation = this._container["animation"];
         this._skillAnimation.gotoAndStop(1);
         DisplayObjectUtil.removeFromParent(this._skillAnimation);
         TooltipManager.addSkillTip(this);
      }
      
      private function initEventListener() : void {
         this.mouseChildren = false;
         this.addEventListener("click",this.onMouseClick);
      }
      
      private function onMouseClick(evt:MouseEvent) : void {
         if(this._isInteractive) {
            this.dispatchEvent(new Event("cellClick"));
         }
      }
      
      public function removeMouseClickEvent() : void {
         this.removeEventListener("click",this.onMouseClick);
      }
      
      public function reset() : void {
         this.changeTextFormat(this._nameTxt,false);
         this._nameTxt.text = "未习得";
         this._powerTxt.text = "";
         this._wlTxt.text = "";
         this._nqTxt.text = "";
         this._hideTips.visible = false;
         this._skillInfo = null;
         this._hasLearnSkill = false;
         this._isHide = false;
      }
      
      public function setSkillCellData(info:SkillInfo, hasLearnSkill:Boolean = false) : void {
         this.reset();
         this._skillInfo = info;
         this._hasLearnSkill = hasLearnSkill;
         if(this._skillInfo != null) {
            this._isHide = this._skillInfo.isHideSkill;
            this.updateDisplay();
            this.addSkillTips();
         }
         else {
            TooltipManager.setData(this,null);
         }
      }
      
      protected function updateDisplay() : void {
         this._hideTips.visible = this._isHide;
         if(!this._hasLearnSkill) {
            this.closeInteraction();
            return;
         }
         this.openInteraction();
         this.changeTextFormat(this._nameTxt,this._isHide);
         this.changeTextFormat(this._powerTxt,this._isHide);
         this.changeTextFormat(this._wlTxt,this._isHide);
         this.changeTextFormat(this._nqTxt,this._isHide);
         this._nameTxt.text = this._skillInfo.name;
         this._powerTxt.text = this._skillInfo.power.toString();
         this._wlTxt.text = "威力:";
         this._nqTxt.text = "怒气:";
      }
      
      protected function changeTextFormat(target:TextField, isHide:Boolean) : void {
         var txtFormat:TextFormat = target.defaultTextFormat;
         if(isHide) {
            txtFormat.color = 16777062;
         }
         else {
            txtFormat.color = 5432825;
         }
         target.defaultTextFormat = txtFormat;
      }
      
      private function addSkillTips() : void {
         var hideSkillInfo:HideSkillInfo = null;
         var tips:String = null;
         if(this._isHide && !this._hasLearnSkill) {
            hideSkillInfo = new HideSkillInfo(this._skillInfo.id);
            tips = String(hideSkillInfo.tips);
            TooltipManager.setData(this,{
               "name":this._skillInfo.name,
               "description":tips
            });
         }
         else {
            TooltipManager.setData(this,{
               "name":this._skillInfo.name,
               "description":this._skillInfo.description
            });
         }
      }
      
      protected function openInteraction() : void {
         this.buttonMode = true;
         this._isInteractive = true;
      }
      
      protected function closeInteraction() : void {
         this.buttonMode = false;
         this._isInteractive = false;
      }
      
      public function get skillInfo() : SkillInfo {
         return this._skillInfo;
      }
      
      public function set isSelected(value:Boolean) : void {
         this._isSelected = value;
         if(this._isSelected) {
            this._background.gotoAndStop(2);
         }
         else {
            this._background.gotoAndStop(1);
         }
      }
      
      public function get isSelected() : Boolean {
         return this._isSelected;
      }
      
      public function showReplaceAnimation() : void {
         this._skillAnimation.addEventListener("enterFrame",this.onSkillAnimationEnter);
         this.addChild(this._skillAnimation);
         this._skillAnimation.gotoAndPlay(1);
      }
      
      private function onSkillAnimationEnter(evt:Event) : void {
         if(this._skillAnimation.currentFrame == this._skillAnimation.totalFrames) {
            this._skillAnimation.removeEventListener("enterFrame",this.onSkillAnimationEnter);
            this._skillAnimation.gotoAndStop(1);
            DisplayObjectUtil.removeFromParent(this._skillAnimation);
         }
      }
      
      public function get hasLearnSkill() : Boolean {
         return this._hasLearnSkill;
      }
   }
}
