package com.taomee.seer2.module.app.versionOnePetBagPanel.util.skill
{
   import com.taomee.seer2.app.component.PetTypeIcon;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.SkillInfo;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class GraspSkillCell extends BaseSkillCell
   {
       
      
      private var _btn:MovieClip;
      
      private var _petInfo:PetInfo;
      
      private var _clickBtnFun:Function;
      
      private var _categoryTxt:TextField;
      
      private var _typeIcon:PetTypeIcon;
      
      private var _angerTxt:TextField;
      
      private var _mainUI:MovieClip;
      
      public function GraspSkillCell(petInfo:PetInfo, clickBtnFun:Function, mainUI:MovieClip)
      {
         this._mainUI = mainUI;
         this._petInfo = petInfo;
         this._clickBtnFun = clickBtnFun;
         super();
         this._btn = new GraspSkillGetUI();
         this._btn.y = 120;
         this._btn.addEventListener("click",this.onBtn);
         this._mainUI.addChild(this._btn);
      }
      
      public function setBtnX(value:Number) : void
      {
         this._btn.x = value;
      }
      
      override protected function createContainer() : void
      {
         _container = new NormalSkillCellUI();
         addChild(_container);
         this.addTypeIcon();
      }
      
      private function addTypeIcon() : void
      {
         this._typeIcon = new PetTypeIcon();
         this._typeIcon.x = 4;
         this._typeIcon.y = 5;
         addChild(this._typeIcon);
      }
      
      override protected function extractAssets() : void
      {
         super.extractAssets();
         this._categoryTxt = _container["categoryTxt"];
         this._angerTxt = _container["angerTxt"];
      }
      
      override public function reset() : void
      {
         super.reset();
         this._typeIcon.clear();
         this._angerTxt.text = "";
         this._categoryTxt.text = "";
      }
      
      override protected function updateDisplay() : void
      {
         super.updateDisplay();
         if(_hasLearnSkill == true)
         {
            this._categoryTxt.text = _skillInfo.category;
            changeTextFormat(this._angerTxt,_isHide);
            this._angerTxt.text = _skillInfo.anger.toString();
            this._typeIcon.type = _skillInfo.typeId;
         }
      }
      
      private function onBtn(event:MouseEvent) : void
      {
         if(this._clickBtnFun != null)
         {
            this._clickBtnFun(_skillInfo);
         }
      }
      
      override public function setSkillCellData(info:SkillInfo, hasLearnSkill:Boolean = false) : void
      {
         super.setSkillCellData(info,hasLearnSkill);
      }
      
      public function checkHasSkill() : int
      {
         if(Boolean(this._petInfo.skillInfo.hasSkillInfo(_skillInfo)) || Boolean(this._petInfo.skillInfo.hasCandidateSkillInfo(_skillInfo)))
         {
            this._btn.mouseChildren = false;
            this._btn.mouseEnabled = false;
            this._btn.gotoAndStop(3);
         }
         else if(Boolean(ItemManager.getSpecialItem(603035)) && ItemManager.getSpecialItem(603035).quantity > 0)
         {
            this._btn.mouseChildren = true;
            this._btn.mouseEnabled = true;
            this._btn.gotoAndStop(2);
         }
         else
         {
            this._btn.mouseChildren = true;
            this._btn.mouseEnabled = true;
            this._btn.gotoAndStop(1);
         }
         return this._btn.currentFrame;
      }
      
      public function dispose() : void
      {
         DisplayUtil.removeForParent(this._btn);
      }
   }
}
