package com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel.selectSkillPanel {
   import com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel.BaseSkillPanel;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.util.skill.BaseSkillCell;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.util.skill.CriticalSkillCell;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.util.skill.NoramlSkillCell;
   
   public class AvailableSkillPanel extends BaseSkillPanel {
      private var _container:AvailableSkillUI;
      
      public function AvailableSkillPanel() {
         super();
      }
      
      override protected function createContainer() : void {
         this._container = new AvailableSkillUI();
         this._container.x = 98;
         this._container.y = 0;
         this.addChild(this._container);
      }
      
      override protected function createSkillVec() : void {
         var cell:BaseSkillCell = null;
         var padding:int = 150;
         _normalSkillCellVec = new Vector.<BaseSkillCell>();
         for(var i:int = 0; i < 4; ++i) {
            cell = new NoramlSkillCell();
            cell.x = 90 + padding * i;
            cell.y = 45;
            this.addChild(cell);
            this._normalSkillCellVec.push(cell);
         }
         this._criticalSkillCell = new CriticalSkillCell();
         this._criticalSkillCell2 = null;
         this._criticalSkillCell.x = 734;
         this._criticalSkillCell.y = 45;
         this.addChild(_criticalSkillCell);
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
