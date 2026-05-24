package com.taomee.seer2.module.app.appraisal
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.component.PetPotentialityIcon;
   import com.taomee.seer2.app.component.PetTypeIcon;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class AppraisalResultPanel extends Sprite
   {
       
      
      private var _container:IResetable;
      
      private var _closeButton:SimpleButton;
      
      private var _petSex:MovieClip;
      
      private var _petCanvas:MovieClip;
      
      private var _petId:TextField;
      
      private var _petName:TextField;
      
      private var _petLevel:TextField;
      
      private var _petChar:TextField;
      
      private var _petAtk:TextField;
      
      private var _petDef:TextField;
      
      private var _petSpAtk:TextField;
      
      private var _petSpDef:TextField;
      
      private var _petSpeed:TextField;
      
      private var _petHp:TextField;
      
      private var _petDes:TextField;
      
      private var _petLevel2:TextField;
      
      private var ui:MovieClip;
      
      private var _petTypeIcon:PetTypeIcon;
      
      private var _potIcon:PetPotentialityIcon;
      
      private var _icon:IconDisplayer;
      
      public function AppraisalResultPanel(container:IResetable)
      {
         super();
         this._container = container;
         this.initUI();
      }
      
      private function initUI() : void
      {
         this.ui = new AppraisalResultPanelUI() as MovieClip;
         addChild(this.ui);
         this._closeButton = this.ui["closeBtn"];
         this._closeButton.addEventListener("click",this.onClosePanel);
         this._petSex = this.ui["petSex"];
         this._petSex.gotoAndStop(1);
         this._petId = this.ui["petId"];
         this._petName = this.ui["petName"];
         this._petLevel = this.ui["petLevel"];
         this._petChar = this.ui["petChar"];
         this._petAtk = this.ui["petAtk"];
         this._petDef = this.ui["petDef"];
         this._petSpAtk = this.ui["petSpAtk"];
         this._petSpDef = this.ui["petSpDef"];
         this._petSpeed = this.ui["petSpeed"];
         this._petHp = this.ui["petHp"];
         this._petCanvas = this.ui["petCanvas"];
         this._petDes = this.ui["petDes"];
         this._petLevel2 = this.ui["petLevel2"];
      }
      
      private function onClosePanel(event:MouseEvent) : void
      {
         this.reset();
         this._container.resetMouseable();
      }
      
      public function reset() : void
      {
         DisplayObjectUtil.removeFromParent(this);
      }
      
      private function updateFlg(petInfo:PetInfo, oldPetInfo:PetInfo) : void
      {
         this.judge(petInfo.potential,oldPetInfo.potential,0);
         this.judge(petInfo.atk,oldPetInfo.atk,1);
         this.judge(petInfo.defence,oldPetInfo.defence,2);
         this.judge(petInfo.specialAtk,oldPetInfo.specialAtk,3);
         this.judge(petInfo.specialDefence,oldPetInfo.specialDefence,4);
         this.judge(petInfo.speed,oldPetInfo.speed,5);
         this.judge(petInfo.hp,oldPetInfo.hp,6);
      }
      
      private function judge(param1:int, param2:int, index:int) : void
      {
         if(param1 > param2)
         {
            (this.ui["flg_" + index] as MovieClip).gotoAndStop(1);
         }
         else if(param1 < param2)
         {
            (this.ui["flg_" + index] as MovieClip).gotoAndStop(2);
         }
         else
         {
            (this.ui["flg_" + index] as MovieClip).gotoAndStop(3);
         }
      }
      
      public function updatePet(petInfo:PetInfo, oldPetInfo:PetInfo = null) : void
      {
         this._petSex.gotoAndStop(petInfo.sex);
         this._petId.text = String(petInfo.catchTime);
         this._petName.text = petInfo.name;
         this._petLevel.text = String(petInfo.level);
         this._petChar.text = petInfo.characterName;
         this._petAtk.text = String(petInfo.atk);
         this._petDef.text = String(petInfo.defence);
         this._petSpAtk.text = String(petInfo.specialAtk);
         this._petSpDef.text = String(petInfo.specialDefence);
         this._petSpeed.text = String(petInfo.speed);
         this._petHp.text = String(petInfo.hp);
         this._petDes.text = petInfo.description;
         this._petLevel2.text = String(petInfo.level);
         if(oldPetInfo != null)
         {
            this.updateFlg(petInfo,oldPetInfo);
         }
         this._petTypeIcon = this.getChildByName("petTypeIcon") as PetTypeIcon;
         this._potIcon = this.getChildByName("potIcon") as PetPotentialityIcon;
         this._icon = this._petCanvas.getChildByName("petIcon") as IconDisplayer;
         DisplayObjectUtil.removeFromParent(this._petTypeIcon);
         DisplayObjectUtil.removeFromParent(this._potIcon);
         DisplayObjectUtil.removeFromParent(this._icon);
         if(this._petTypeIcon == null)
         {
            this._petTypeIcon = new PetTypeIcon();
            this._petTypeIcon.name = "petTypeIcon";
            this._petTypeIcon.x = 35;
            this._petTypeIcon.y = 45;
         }
         this.addChild(this._petTypeIcon);
         this._petTypeIcon.type = petInfo.type;
         if(this._icon == null)
         {
            this._icon = new IconDisplayer();
            this._icon.name = "petIcon";
            this._icon.scaleY = this._icon.scaleX = 1.5;
            this._icon.x = this._icon.y = 10;
         }
         var url:String = String(URLUtil.getPetIcon(petInfo.resourceId));
         this._icon.setIconUrl(url);
         this._petCanvas.addChild(this._icon);
         if(this._potIcon == null)
         {
            this._potIcon = new PetPotentialityIcon();
            this._potIcon.name = "potIcon";
            this._potIcon.x = 250;
            this._potIcon.y = 50;
         }
         this.addChild(this._potIcon);
         this._potIcon.setPotential(petInfo.potential,petInfo.isAggraisal);
      }
      
      public function dispose() : void
      {
         this._closeButton.removeEventListener("click",this.onClosePanel);
         this._closeButton = null;
         this._container = null;
         this._petSex = null;
         this._petCanvas = null;
         this._petId = null;
         this._petName = null;
         this._petLevel = null;
         this._petChar = null;
         this._petAtk = null;
         this._petDef = null;
         this._petSpAtk = null;
         this._petSpDef = null;
         this._petSpeed = null;
         this._petHp = null;
         this._petDes = null;
         this._petLevel2 = null;
      }
   }
}
