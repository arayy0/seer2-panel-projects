package com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel {
   import com.taomee.seer2.module.app.versionOnePetBagPanel.util.skill.BaseSkillCell;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.util.skill.CriticalSkillCell;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.util.skill.NoramlSkillCell;
   
   public class GetedSkillPanel extends BaseSkillPanel {
      
      public function GetedSkillPanel() {
         super();
      }
      
      override protected function createSkillVec() : void {
         var cell:BaseSkillCell = null;
         var rowCount:int = 2;
         var horizontalPadding:int = 144;
         var verticalPadding:int = 84;
         this._normalSkillCellVec = new Vector.<BaseSkillCell>();
         for(var i:int = 0; i < 4; ++i) {
            cell = new NoramlSkillCell();
            cell.x = horizontalPadding * (i % rowCount) + 22;
            cell.y = verticalPadding * int(i / rowCount) + 80;
            this.addChild(cell);
            cell.removeMouseClickEvent();
            this._normalSkillCellVec.push(cell);
         }
         this._criticalSkillCell = new CriticalSkillCell();
         this._criticalSkillCell2 = new CriticalSkillCell();
         this._criticalSkillCell2.visible = false;
         this._criticalSkillCell.x = 94;
         this._criticalSkillCell.y = 284;
         this.addChild(this._criticalSkillCell);
         this._criticalSkillCell.mouseChildren = true;
         this._criticalSkillCell.removeMouseClickEvent();
      }
      
      override protected function updateData() : void {
         this.updateSkillInfo(this._petInfo.skillInfo.skillInfoVec);
      }
      
      override protected function updateDisplay() : void {
         this.updateSkillVec();
      }
      
      private function updateSkillVec() : void {
         var skillCell:BaseSkillCell = null;
         for(var i:int = 0; i < 4; ++i) {
            skillCell = this._normalSkillCellVec[i];
            if(i < this._normalSkillInfoVec.length) {
               skillCell.setSkillCellData(this._normalSkillInfoVec[i],true);
            }
            else {
               skillCell.setSkillCellData(null);
            }
         }
         this._criticalSkillCell.setSkillCellData(this._criticalSkillInfo,true);
      }
   }
}
