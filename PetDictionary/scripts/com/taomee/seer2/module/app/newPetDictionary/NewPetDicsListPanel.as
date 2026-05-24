package com.taomee.seer2.module.app.newPetDictionary
{
   import com.taomee.seer2.app.config.PetConfig;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class NewPetDicsListPanel extends Sprite
   {
       
      
      private const Row_Column:uint = 3;
      
      private const Cell_Width_Height:int = 92;
      
      private const HDistance:int = 20;
      
      private const VDistance:int = 30;
      
      private var _cellVec:Vector.<NewPetDicsListCell>;
      
      private var _petResouceVec:Vector.<int>;
      
      private var _isSpeak:Boolean;
      
      public function NewPetDicsListPanel()
      {
         super();
         this.initCellVec();
      }
      
      private function initCellVec() : void
      {
         var i:int = 0;
         var j:int = 0;
         var cell:NewPetDicsListCell = null;
         this._cellVec = new Vector.<NewPetDicsListCell>();
         for(i = 0; i < 3; )
         {
            for(j = 0; j < 4; )
            {
               cell = new NewPetDicsListCell();
               cell.addEventListener("click",this.onCellClick);
               cell.x = (92 + 20) * j - 35;
               cell.y = (92 + 30) * i + 15;
               addChild(cell);
               this._cellVec.push(cell);
               j++;
            }
            i++;
         }
      }
      
      public function setData(petResouceVec:Vector.<int>, isSpeak:Boolean = false) : void
      {
         this._isSpeak = isSpeak;
         this._petResouceVec = petResouceVec;
         this.refresh();
      }
      
      private function refresh() : void
      {
         this.clearCells();
         this.setCellData();
      }
      
      private function clearCells() : void
      {
         var i:int = 0;
         var cell:NewPetDicsListCell = null;
         for(i = 0; i < this._cellVec.length; )
         {
            cell = this._cellVec[i];
            cell.clear();
            i++;
         }
      }
      
      private function setCellData() : void
      {
         var i:int = 0;
         var cell:NewPetDicsListCell = null;
         var len:uint = 12;
         for(i = 0; i < len; )
         {
            cell = this._cellVec[i];
            if(i < this._petResouceVec.length)
            {
               cell.setData(this._petResouceVec[i],this._isSpeak);
            }
            else
            {
               cell.setData(0,this._isSpeak);
            }
            i++;
         }
      }
      
      private function onCellClick(evt:MouseEvent) : void
      {
         var cell:NewPetDicsListCell = evt.currentTarget as NewPetDicsListCell;
         if(PetConfig.getPetDefinition(cell.resourceID) != null)
         {
            dispatchEvent(new NewPetDicsEvent("showPetDetail",cell.resourceID));
         }
      }
   }
}
