package com.taomee.seer2.module.app.birthSystem
{
   import com.taomee.seer2.app.config.BirthSkillListConfig;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.info.BirthSkillInfo;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.PetInfoManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.module.app.petBag.cell.PetBagPetCell;
   import com.taomee.seer2.module.app.petStorage.PetBagSelectPanelUI;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BirthPetSelectPanel extends Sprite
   {
      public static const SELECT_PET_SUCCESS:String = "selectPetSuccess";
      
      public static const SELECT_PET_FAIL:String = "selectPetFail";
      
      private static const MAX_NUM:int = 6;
      
      private var _container:MovieClip;
      
      private var _confirmBtn:SimpleButton;
      
      private var _cancelBtn:SimpleButton;
      
      private var _petCellVec:Vector.<PetBagPetCell>;
      
      private var _selectedPetInfo:PetInfo;
      
      public function BirthPetSelectPanel()
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
         this._container = new PetBagSelectPanelUI();
         addChild(this._container);
         this._confirmBtn = this._container["confirm"];
         this._cancelBtn = this._container["cancelBtn"];
         this.createPetCellVec();
      }
      
      private function createPetCellVec() : void
      {
         var colCount:int = 0;
         var petCell:PetBagPetCell = null;
         colCount = 3;
         var leftMargin:int = 33;
         var horizontalPadding:int = 98;
         var topMargin:int = 49;
         var verticalPadding:int = 128;
         this._petCellVec = new Vector.<PetBagPetCell>();
         for(var i:int = 0; i < MAX_NUM; i++)
         {
            petCell = new PetBagPetCell();
            petCell.x = leftMargin + i % colCount * horizontalPadding;
            petCell.y = topMargin + int(i / colCount) * verticalPadding;
            addChild(petCell);
            this._petCellVec.push(petCell);
         }
      }
      
      private function initEventListener() : void
      {
         for(var i:int = 0; i < MAX_NUM; i++)
         {
            this._petCellVec[i].addEventListener(MouseEvent.CLICK,this.onPetCellClick);
         }
         this._confirmBtn.addEventListener(MouseEvent.CLICK,this.onConfirmBtnClick);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.onCancelBtnClick);
      }
      
      private function onPetCellClick(evt:MouseEvent) : void
      {
         var petCell:PetBagPetCell = null;
         var target:PetBagPetCell = evt.currentTarget as PetBagPetCell;
         for(var i:int = 0; i < MAX_NUM; i++)
         {
            petCell = this._petCellVec[i];
            if(petCell == target)
            {
               this._selectedPetInfo = petCell.petInfo;
               petCell.selected = true;
            }
            else
            {
               petCell.selected = false;
            }
         }
      }
      
      private function onCancelBtnClick(evt:MouseEvent) : void
      {
         dispatchEvent(new Event(SELECT_PET_FAIL));
         this.hide();
      }
      
      private function onConfirmBtnClick(evt:MouseEvent) : void
      {
         var info:BirthSkillInfo = null;
         if(this._selectedPetInfo == null)
         {
            AlertManager.showAlert("请选择一个精灵繁殖");
            return;
         }
         if(this._selectedPetInfo.sex != 1 && this._selectedPetInfo.sex != 2)
         {
            AlertManager.showAlert("精灵无性别或者合体性别");
            return;
         }
         var list:Vector.<BirthSkillInfo> = BirthSkillListConfig.getList();
         var isMonster2:Boolean = false;
         for each(info in list)
         {
            if(PetConfig.getPetDefinition(info.id).bunchId == this._selectedPetInfo.bunchId)
            {
               isMonster2 = true;
            }
         }
         if(isMonster2 == false)
         {
            AlertManager.showAlert("对不起你的精灵并非可繁殖精灵");
            return;
         }
         if(this._selectedPetInfo.isTwoPet)
         {
            AlertManager.showAlert("选择的精灵已经是二代精灵");
            return;
         }
         if(this._selectedPetInfo.sex == 1 && this._selectedPetInfo.level < 60)
         {
            AlertManager.showAlert("雄性精灵等级必须大于60");
            return;
         }
         dispatchEvent(new Event(SELECT_PET_SUCCESS));
         this.hide();
      }
      
      public function show() : void
      {
         this.visible = true;
         this.updateDisplay();
      }
      
      public function hide() : void
      {
         this.visible = false;
      }
      
      public function getInfo() : PetInfo
      {
         return this._selectedPetInfo;
      }
      
      private function updateDisplay() : void
      {
         var petCell:PetBagPetCell = null;
         DisplayObjectUtil.enableSprite(this);
         var petInfoVec:Vector.<PetInfo> = PetInfoManager.getAllBagPetInfo().slice();
         for(var i:int = 0; i < MAX_NUM; i++)
         {
            petCell = this._petCellVec[i];
            petCell.selected = false;
            if(i < petInfoVec.length)
            {
               petCell.setPetInfo(petInfoVec[i]);
            }
            else
            {
               petCell.setPetInfo(null);
            }
         }
      }
   }
}

