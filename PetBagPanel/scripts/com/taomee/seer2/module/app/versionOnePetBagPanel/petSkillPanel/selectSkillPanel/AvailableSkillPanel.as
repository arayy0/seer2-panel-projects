package com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel.selectSkillPanel
{
   import com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel.BaseSkillPanel;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.util.skill.BaseSkillCell;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.util.skill.CriticalSkillCell;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.util.skill.NoramlSkillCell;
   
   public class AvailableSkillPanel extends BaseSkillPanel
   {
       
      
      private var _container:AvailableSkillUI;
      
      public function AvailableSkillPanel()
      {
         super();
      }
      
      override protected function createContainer() : void
      {
         this.y = -78;
         this._container = new AvailableSkillUI();
         addChild(this._container);
      }
      
      override protected function createSkillVec() : void
      {
         var cell:BaseSkillCell = null;
         var rowCount:int = 4;
         var horizontalPadding:int = 135;
         var verticalPadding:int = 68;
         _normalSkillCellVec = new Vector.<BaseSkillCell>();
         var i:int = 0;
         while(i < 4)
         {
            (cell = new NoramlSkillCell()).x = 12 + horizontalPadding * (i % rowCount);
            cell.y = 33 + verticalPadding * (int(i / rowCount));
            addChild(cell);
            _normalSkillCellVec.push(cell);
            i++;
         }
         _criticalSkillCell = new CriticalSkillCell();
         _criticalSkillCell2 = new CriticalSkillCell();
         _criticalSkillCell2.visible = false;
         _criticalSkillCell.x = 580;
         _criticalSkillCell.y = 38;
         addChild(_criticalSkillCell);
      }
      
      override protected function updateData() : void
      {
         updateSkillInfo(_petInfo.skillInfo.skillInfoVec);
      }
      
      override protected function updateDisplay() : void
      {
         this.updateSkillVec();
      }
      
      private function updateSkillVec() : void
      {
         var skillCell:BaseSkillCell = null;
         var i:int = 0;
         while(i < 4)
         {
            skillCell = _normalSkillCellVec[i];
            if(i < _normalSkillInfoVec.length)
            {
               skillCell.setSkillCellData(_normalSkillInfoVec[i],true);
            }
            else
            {
               skillCell.setSkillCellData(null);
            }
            i++;
         }
         _criticalSkillCell.setSkillCellData(_criticalSkillInfo,true);
      }
   }
}
