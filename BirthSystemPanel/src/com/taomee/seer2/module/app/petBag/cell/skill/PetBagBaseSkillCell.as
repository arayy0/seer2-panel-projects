package com.taomee.seer2.module.app.petBag.cell.skill
{
   import com.taomee.seer2.app.pet.data.HideSkillInfo;
   import com.taomee.seer2.app.pet.data.SkillInfo;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.StringConstants;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class PetBagBaseSkillCell extends Sprite
   {
      public static const CELL_CLICK:String = "cellClick";
      
      protected var _container:MovieClip;
      
      private var _nameTxt:TextField;
      
      private var _powerTxt:TextField;
      
      private var _background:MovieClip;
      
      private var _skillAnnimation:MovieClip;
      
      private var _hideTips:Sprite;
      
      protected var _skillInfo:SkillInfo;
      
      protected var _isHide:Boolean;
      
      protected var _hasLearnSkill:Boolean;
      
      private var _isSelected:Boolean;
      
      private var _isInteractive:Boolean;
      
      public function PetBagBaseSkillCell()
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
         this.createContainer();
         this.extractAssets();
      }
      
      protected function createContainer() : void
      {
      }
      
      protected function extractAssets() : void
      {
         this._nameTxt = this._container["nameTxt"];
         this._powerTxt = this._container["powerTxt"];
         this._hideTips = this._container["hideTips"];
         this._background = this._container["background"];
         this._background.gotoAndStop(1);
         this._skillAnnimation = this._container["annimation"];
         this._skillAnnimation.gotoAndStop(1);
         TooltipManager.addSkillTip(this);
      }
      
      private function initEventListener() : void
      {
         this.mouseChildren = false;
         this.addEventListener(MouseEvent.CLICK,this.onMouseClick);
      }
      
      private function onMouseClick(evt:MouseEvent) : void
      {
         if(this._isInteractive)
         {
            dispatchEvent(new Event(CELL_CLICK));
         }
      }
      
      public function reset() : void
      {
         this._nameTxt.text = "";
         this._powerTxt.text = "";
         this._hideTips.visible = false;
         this._skillInfo = null;
         this.closeInteraction();
      }
      
      public function setSkillCellData(info:SkillInfo, hasLearnSkill:Boolean = false) : void
      {
         this.reset();
         this._skillInfo = info;
         if(this._skillInfo != null)
         {
            this._isHide = this._skillInfo.isHideSkill;
            this._hasLearnSkill = hasLearnSkill;
            this.updateDisplay();
            this.addSkillTips();
         }
         else
         {
            TooltipManager.setData(this,null);
         }
      }
      
      protected function updateDisplay() : void
      {
         this._hideTips.visible = this._isHide;
         if(this._hasLearnSkill == false)
         {
            return;
         }
         this.openInteraction();
         this.changeTextFormat(this._nameTxt,this._isHide);
         this.changeTextFormat(this._powerTxt,this._isHide);
         this._nameTxt.text = this._skillInfo.name;
         this._powerTxt.text = "威力" + StringConstants.COLON + this._skillInfo.power;
      }
      
      protected function changeTextFormat(target:TextField, isHide:Boolean) : void
      {
         var txtFormat:TextFormat = target.defaultTextFormat;
         if(this._isHide)
         {
            txtFormat.color = 16777062;
         }
         else
         {
            txtFormat.color = 5432825;
         }
         target.defaultTextFormat = txtFormat;
      }
      
      private function addSkillTips() : void
      {
         var hideSkillInfo:HideSkillInfo = null;
         var tips:String = null;
         if(this._isHide == true && this._hasLearnSkill == false)
         {
            hideSkillInfo = new HideSkillInfo(this._skillInfo.id);
            tips = hideSkillInfo.tips;
            TooltipManager.setData(this,{
               "name":this._skillInfo.name,
               "description":tips
            });
         }
         else
         {
            TooltipManager.setData(this,{
               "name":this._skillInfo.name,
               "description":this._skillInfo.description
            });
         }
      }
      
      protected function openInteraction() : void
      {
         this.buttonMode = true;
         this._isInteractive = true;
      }
      
      protected function closeInteraction() : void
      {
         this.buttonMode = false;
         this._isInteractive = false;
      }
      
      public function get skillInfo() : SkillInfo
      {
         return this._skillInfo;
      }
      
      public function set isSelected(value:Boolean) : void
      {
         this._isSelected = value;
         if(this._isSelected)
         {
            this._background.gotoAndStop(2);
         }
         else
         {
            this._background.gotoAndStop(1);
         }
      }
      
      public function get isSelected() : Boolean
      {
         return this._isSelected;
      }
      
      public function showReplaceAnnimation() : void
      {
         this._skillAnnimation.addEventListener(Event.ENTER_FRAME,this.onSkillAnnimationEnter);
         this._skillAnnimation.gotoAndPlay(1);
      }
      
      private function onSkillAnnimationEnter(evt:Event) : void
      {
         if(this._skillAnnimation.currentFrame == this._skillAnnimation.totalFrames)
         {
            this._skillAnnimation.removeEventListener(Event.ENTER_FRAME,this.onSkillAnnimationEnter);
            this._skillAnnimation.gotoAndStop(1);
         }
      }
      
      public function get hasLearnSkill() : Boolean
      {
         return this._hasLearnSkill;
      }
   }
}

