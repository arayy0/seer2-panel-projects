package com.taomee.seer2.module.app.versionOnePetBagPanel.petAbilityPanel
{
   import com.taomee.seer2.app.config.PetEvolveConfig;
   import com.taomee.seer2.app.config.info.PetEvolveStarInfo;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.PetAbilityPanel;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class BasePetAblilityPanel extends Sprite
   {
       
      
      private var _mainUI:MovieClip;
      
      private var _propList:Vector.<TextField>;
      
      private var _studyPointList:Vector.<TextField>;
      
      private var _potentionList:Vector.<TextField>;
      
      private var _barList:Vector.<MovieClip>;
      
      private var _charactorList:Vector.<TextField>;
      
      private var _addAttTxt:TextField;
      
      private var _addDefTxt:TextField;
      
      private var _addSpeAttTxt:TextField;
      
      private var _addSpeDefTxt:TextField;
      
      private var _addSpeedTxt:TextField;
      
      private var _addHpTxt:TextField;
      
      private var _petInfo:PetInfo;
      
      private var _studyPointValList:Vector.<int>;
      
      private var _thisParent:PetAbilityPanel;
      
      public function BasePetAblilityPanel(thisParent:PetAbilityPanel)
      {
         super();
         this._thisParent = thisParent;
         this.initSet();
      }
      
      private function initSet() : void
      {
         var i:int = 0;
         this._mainUI = new BasePetAblilityUI();
         addChild(this._mainUI);
         this._mainUI.x = 586;
         this._mainUI.y = 104;
         this._propList = new Vector.<TextField>();
         this._studyPointList = new Vector.<TextField>();
         this._potentionList = new Vector.<TextField>();
         this._barList = new Vector.<MovieClip>();
         this._charactorList = new Vector.<TextField>();
         for(i = 0; i < 6; )
         {
            this._propList.push(this._mainUI["prop" + i]);
            this._studyPointList.push(this._mainUI["studyPoint" + i]);
            this._potentionList.push(this._mainUI["potention" + i]);
            this._barList.push(this._mainUI["bar" + i]);
            this._charactorList.push(this._mainUI["charactor" + i]);
            i++;
         }
         this._addAttTxt = this._mainUI["addAttTxt"];
         this._addDefTxt = this._mainUI["addDefTxt"];
         this._addSpeAttTxt = this._mainUI["addSpeAttTxt"];
         this._addSpeDefTxt = this._mainUI["addSpeDefTxt"];
         this._addSpeedTxt = this._mainUI["addSpeedTxt"];
         this._addHpTxt = this._mainUI["addHpTxt"];
         this._addAttTxt.visible = this._addDefTxt.visible = this._addSpeAttTxt.visible = this._addSpeDefTxt.visible = this._addSpeedTxt.visible = this._addHpTxt.visible = false;
      }
      
      public function setData(info:PetInfo) : void
      {
         this._petInfo = info;
         this._studyPointValList = new Vector.<int>();
         this._studyPointValList.push(this._petInfo.learningInfo.pointAtk);
         this._studyPointValList.push(this._petInfo.learningInfo.pointDefence);
         this._studyPointValList.push(this._petInfo.learningInfo.pointSpecialAtk);
         this._studyPointValList.push(this._petInfo.learningInfo.pointSpecialDefence);
         this._studyPointValList.push(this._petInfo.learningInfo.pointSpeed);
         this._studyPointValList.push(this._petInfo.learningInfo.pointHp);
         if(this._petInfo != null)
         {
            this.updateDisplay();
         }
      }
      
      private function updateDisplay() : void
      {
         var i:int = 0;
         var currentAdd:PetEvolveStarInfo = null;
         var potentialList:Vector.<int> = Vector.<int>([this._petInfo.potentialAtk,this._petInfo.potentialDef,this._petInfo.potentialSpAtk,this._petInfo.potentialSpDef,this._petInfo.potentialSpeed,this._petInfo.potentialHp]);
         for(i = 0; i < this._propList.length; )
         {
            this._studyPointList[i].text = this._studyPointValList[i].toString();
            this._potentionList[i].text = potentialList[i] + "/" + "120";
            this._barList[i].scaleX = potentialList[i] / 120;
            this._charactorList[i].text = this._petInfo.characterArr[i] + "倍";
            i++;
         }
         this._propList[0].text = this._petInfo.atk.toString();
         this._propList[1].text = this._petInfo.defence.toString();
         this._propList[2].text = this._petInfo.specialAtk.toString();
         this._propList[3].text = this._petInfo.specialDefence.toString();
         this._propList[4].text = this._petInfo.speed.toString();
         this._propList[5].text = this._petInfo.maxHp.toString();
         this.clearEvolveTip();
         if(this._petInfo.evolveLevel == 0)
         {
            this._addAttTxt.visible = this._addDefTxt.visible = this._addSpeAttTxt.visible = this._addSpeDefTxt.visible = this._addSpeedTxt.visible = this._addHpTxt.visible = false;
         }
         else
         {
            this._addAttTxt.visible = this._addDefTxt.visible = this._addSpeAttTxt.visible = this._addSpeDefTxt.visible = this._addSpeedTxt.visible = this._addHpTxt.visible = true;
            currentAdd = PetEvolveConfig.getStarInfo(this._petInfo.evolveLevel);
            this._addHpTxt.text = currentAdd != null ? "+" + currentAdd.Hp : "";
            this._addAttTxt.text = currentAdd != null ? "+" + currentAdd.Atk : "";
            this._addDefTxt.text = currentAdd != null ? "+" + currentAdd.Def : "";
            this._addSpeAttTxt.text = currentAdd != null ? "+" + currentAdd.SpAtk : "";
            this._addSpeDefTxt.text = currentAdd != null ? "+" + currentAdd.SpDef : "";
            this._addSpeedTxt.text = currentAdd != null ? "+" + currentAdd.Spd : "";
         }
         this.addEvolveTip();
      }
      
      private function clearEvolveTip() : void
      {
         TooltipManager.remove(this._addHpTxt);
         TooltipManager.remove(this._addAttTxt);
         TooltipManager.remove(this._addDefTxt);
         TooltipManager.remove(this._addSpeAttTxt);
         TooltipManager.remove(this._addSpeDefTxt);
         TooltipManager.remove(this._addSpeedTxt);
      }
      
      private function addEvolveTip() : void
      {
         TooltipManager.addCommonTip(this._addHpTxt,this.getCurEvolveTip());
         TooltipManager.addCommonTip(this._addAttTxt,this.getCurEvolveTip());
         TooltipManager.addCommonTip(this._addDefTxt,this.getCurEvolveTip());
         TooltipManager.addCommonTip(this._addSpeAttTxt,this.getCurEvolveTip());
         TooltipManager.addCommonTip(this._addSpeDefTxt,this.getCurEvolveTip());
         TooltipManager.addCommonTip(this._addSpeedTxt,this.getCurEvolveTip());
      }
      
      private function getCurEvolveTip() : String
      {
         var result:String = "";
         var starId:uint = uint(this._petInfo.evolveLevel);
         if(starId > 0 && starId < 1000)
         {
            if(starId <= 4)
            {
               result = "神化加成";
            }
            else
            {
               result = "圣化加成";
            }
         }
         else if(starId > 1000)
         {
            if(starId <= 1004)
            {
               result = "魔化加成";
            }
            else
            {
               result = "冥化加成";
            }
         }
         return result;
      }
   }
}
