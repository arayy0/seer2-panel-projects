package com.taomee.seer2.module.app.birthSystem
{
   import com.taomee.seer2.app.config.BirthSkillListConfig;
   import com.taomee.seer2.app.config.info.BirthSkillInfo;
   import com.taomee.seer2.app.pet.data.SkillInfo;
   import com.taomee.seer2.module.app.BirthSkillListlUI;
   import com.taomee.seer2.module.app.petBag.cell.skill.PetBagNoramlSkillCell;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import org.taomee.utils.DisplayUtil;
   
   public class BirthSkillList extends Sprite
   {
      private var _mc:MovieClip;
      
      private var _skillListMC:Vector.<PetBagNoramlSkillCell>;
      
      private var _info:BirthSkillInfo;
      
      public function BirthSkillList()
      {
         super();
         this._mc = new BirthSkillListlUI();
         addChild(this._mc);
         this._skillListMC = Vector.<PetBagNoramlSkillCell>([]);
      }
      
      public function setInfo(id:uint) : void
      {
         var skillInfo:SkillInfo = null;
         var skillCell:PetBagNoramlSkillCell = null;
         this._info = BirthSkillListConfig.getInfo(id);
         var length:uint = uint(this._info.skillList.length);
         for(var i:int = 0; i < length; i++)
         {
            skillInfo = new SkillInfo(this._info.skillList[i]);
            skillCell = new PetBagNoramlSkillCell();
            skillCell.setSkillCellData(skillInfo,true);
            skillCell.x = 7 + 135 * i;
            skillCell.y = 40;
            this._mc.addChild(skillCell);
            this._skillListMC.push(skillCell);
         }
      }
      
      public function dispose() : void
      {
         var skillCell:PetBagNoramlSkillCell = null;
         for each(skillCell in this._skillListMC)
         {
            DisplayUtil.removeForParent(skillCell);
         }
         DisplayUtil.removeForParent(this._mc);
      }
   }
}

