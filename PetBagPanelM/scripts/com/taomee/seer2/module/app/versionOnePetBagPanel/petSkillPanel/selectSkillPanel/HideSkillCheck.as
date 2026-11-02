package com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel.selectSkillPanel
{
   import com.taomee.seer2.app.config.skill.PetSkillSettingDefinition;
   
   public class HideSkillCheck
   {

      //这个vec用来储存有隐藏技能，但是因为bug显示了多于正常的隐藏技能的精灵，例如神奇拉会显示两个形态共8个隐藏技能但是实际自己只应该有4个的
      private static const _noHidePetSkillList:Vector.<Array> = Vector.<Array>([[524,[13478,13479,13480,13481]],[534,[13437,13438,13439,13440]],[668,[14638]],[716,[15233]],[733,[17471,17472,17473,17474]],[751,[17444,17445,17446,17447]],[760,[17591,17592,17593,17594]],[769,[15697]],[777,[15774]],[791,[17526,17527,17528,17529]],[813,[16095]],[950,[11618]],[955,[12908]],[961,[17071]],[963,[17163]],[965,[17070]],[973,[17068]],[977,[17072]],[982,[11619,17069]],[975,[16077]],[980,[16079]],[986,[16078]]]);

      private static const _hasHidePetList:Vector.<uint> = Vector.<uint>([215,349,524,534,583,598,668,700,716,733,751,760,769,777,791,813,832,834,842,905,950,955,961,963,965,973,977,975,980,982,986]);

      public function HideSkillCheck()
      {
         super();
      }

      public static function checkHasHideSkill(petId:uint):Boolean
      {
         return _hasHidePetList.indexOf(petId) != -1;
      }

      public static function checkSkillHideable(petInfoId:uint, checkingSkillId:uint) : Boolean
      {
         var i:int = 0;
         var j:int = 0;
         for(i = 0; i < _noHidePetSkillList.length; )
         {
            if(petInfoId == _noHidePetSkillList[i][0])
            {
               for(j = 0; j < _noHidePetSkillList[i][1].length; )
               {
                  if(_noHidePetSkillList[i][1][j] == -1)
                  {
                     return false;
                  }
                  if(_noHidePetSkillList[i][1][j] == checkingSkillId)
                  {
                     return false;
                  }
                  j++;
               }
            }
            i++;
         }
         return true;
      }
      
      public static function hideSkillCoveredRepair(petId:uint, vec:Vector.<PetSkillSettingDefinition>) : Vector.<PetSkillSettingDefinition>
      {
         //这个类也能处理隐藏技能被超进化形态顶掉的情况，例如艾丽希斯自己隐藏技能需要手动学，但是有超进化形态把隐藏技能顶掉了导致看不见
         //这个是少数精灵的问题，不放到前面统一修正的地方
         if(petId == 215)
         {
            vec.push(new PetSkillSettingDefinition(11160,2198,"12_1_003","12_1_001"));
            vec.push(new PetSkillSettingDefinition(11161,2199,"12_1_001","12_1_002"));
            vec.push(new PetSkillSettingDefinition(11162,2001,"12_1_002","12_1_001"));
            vec.push(new PetSkillSettingDefinition(11163,2185,"12_1_003","12_1_003"));
         }
         else if(petId == 349)
         {
            vec.push(new PetSkillSettingDefinition(12256,2003,"08_1_002","08_1_011"));
            vec.push(new PetSkillSettingDefinition(12257,2372,"08_2_003","08_1_005"));
            vec.push(new PetSkillSettingDefinition(12258,2371,"08_3_002","08_3_001"));
            vec.push(new PetSkillSettingDefinition(12259,2006,"08_2_001","08_2_005"));
         }
         else if(petId == 583)
         {
            vec.push(new PetSkillSettingDefinition(13763,2001,"07_3_002","07_3_018"));
            vec.push(new PetSkillSettingDefinition(13764,2003,"07_3_003","07_3_018"));
            vec.push(new PetSkillSettingDefinition(13765,2006,"07_3_001","01_3_012"));
            vec.push(new PetSkillSettingDefinition(13766,2235,"07_2_003","07_2_005"));
         }
         else if(petId == 598)
         {
            vec.push(new PetSkillSettingDefinition(13896,2001,"05_2_002","05_2_003"));
            vec.push(new PetSkillSettingDefinition(13897,2003,"05_3_003","05_3_010"));
            vec.push(new PetSkillSettingDefinition(13898,2006,"05_3_002","05_3_010"));
            vec.push(new PetSkillSettingDefinition(13899,2235,"05_2_001","05_2_003"));
         }
         else if(petId == 700)
         {
            vec.push(new PetSkillSettingDefinition(15186,2001,"01_3_003","13_3_007"));
            vec.push(new PetSkillSettingDefinition(15187,2016,"01_3_003","13_3_007"));
            vec.push(new PetSkillSettingDefinition(15188,2021,"01_2_003","13_2_012"));
            vec.push(new PetSkillSettingDefinition(15189,2185,"01_2_003","13_2_012"));
         }
         else if(petId == 832)
         {
            vec.push(new PetSkillSettingDefinition(16354,2001,"12_3_001","12_3_011"));
            vec.push(new PetSkillSettingDefinition(16355,2016,"12_3_003","12_3_011"));
            vec.push(new PetSkillSettingDefinition(16356,2021,"12_2_002","12_2_019"));
            vec.push(new PetSkillSettingDefinition(16357,2185,"12_2_001","12_2_019"));
         }
         else if(petId == 834)
         {
            vec.push(new PetSkillSettingDefinition(16386,2001,"01_3_001","15_3_017"));
            vec.push(new PetSkillSettingDefinition(16387,2016,"01_3_003","15_3_017"));
            vec.push(new PetSkillSettingDefinition(16388,2021,"01_1_002","15_1_010"));
            vec.push(new PetSkillSettingDefinition(16389,2185,"01_1_002","15_1_010"));
         }
         else if(petId == 842)
         {
            vec.push(new PetSkillSettingDefinition(16432,2001,"01_3_001","17_3_013"));
            vec.push(new PetSkillSettingDefinition(16433,2016,"01_1_003","17_1_004"));
            vec.push(new PetSkillSettingDefinition(16434,2021,"01_1_002","17_1_004"));
            vec.push(new PetSkillSettingDefinition(16435,2185,"01_2_001","17_2_016"));
         }
         else if(petId == 905)
         {
            vec.push(new PetSkillSettingDefinition(17031,2001,"01_3_001","18_3_012"));
            vec.push(new PetSkillSettingDefinition(17032,2016,"01_2_003","18_2_002"));
            vec.push(new PetSkillSettingDefinition(17033,2021,"01_3_002","18_3_012"));
            vec.push(new PetSkillSettingDefinition(17163,2555,"01_2_002","18_3_012"));
         }
         return vec;
      }
   }
}
