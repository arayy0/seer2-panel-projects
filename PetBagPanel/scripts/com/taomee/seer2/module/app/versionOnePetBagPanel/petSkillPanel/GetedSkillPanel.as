package com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel
{
   import com.taomee.seer2.module.app.versionOnePetBagPanel.util.skill.BaseSkillCell;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.util.skill.CriticalSkillCell;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.util.skill.NoramlSkillCell;
   
   public class GetedSkillPanel extends BaseSkillPanel
   {
       
      
      public function GetedSkillPanel()
      {
         super();
      }
      
      override protected function createSkillVec() : void
      {
         var cell:BaseSkillCell = null;
         var rowCount:int = 2;
         var horizontalPadding:int = 135;
         var verticalPadding:int = 68;
         _normalSkillCellVec = new Vector.<BaseSkillCell>();
         var i:int = 0;
         while(i < 4)
         {
            (cell = new NoramlSkillCell()).x = (horizontalPadding + 5) * (i % rowCount);
            cell.y = (verticalPadding + 15) * (int(i / rowCount));
            addChild(cell);
            cell.removeMouseClickEvent();
            _normalSkillCellVec.push(cell);
            i++;
         }
         _criticalSkillCell = new CriticalSkillCell();
         _criticalSkillCell2 = new CriticalSkillCell();
         _criticalSkillCell2.visible = false;
         _criticalSkillCell.x = 68;
         _criticalSkillCell.y = 210;
         addChild(_criticalSkillCell);
         _criticalSkillCell.mouseChildren = true;
         _criticalSkillCell.removeMouseClickEvent();
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
