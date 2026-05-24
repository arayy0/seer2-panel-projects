package com.taomee.seer2.module.app.birthSystem
{
   import com.taomee.seer2.app.component.PetDemoDisplayer;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.pet.constant.PetCharactarNameMap;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.BirthDemoUI;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class BirthDemo extends Sprite
   {
      private var _mail:MovieClip;
      
      private var _petDemo:PetDemoDisplayer;
      
      private var _petInfo:PetInfo;
      
      private var _angerTxt:TextField;
      
      private var _petNameTxt:TextField;
      
      private var _currPractice:MovieClip;
      
      private var _cookbook:Function;
      
      public function BirthDemo()
      {
         super();
         this._mail = new BirthDemoUI();
         this._angerTxt = this._mail["angerTxt"];
         this._petNameTxt = this._mail["petNameTxt"];
         this._currPractice = this._mail["currPractice"];
         this._petDemo = new PetDemoDisplayer();
      }
      
      public function setInfo(petInfo:PetInfo, cookbook:Function) : void
      {
         this._petInfo = petInfo;
         this._cookbook = cookbook;
         this._petDemo.setUrl(URLUtil.getPetDemo(this._petInfo.resourceId),this.addPetToDemo,180);
      }
      
      private function addPetToDemo() : void
      {
         this._petDemo.x = 32;
         this._petDemo.y = 42;
         addChild(this._mail);
         addChild(this._petDemo);
         this.initInfo();
      }
      
      private function initInfo() : void
      {
         this._angerTxt.text = PetCharactarNameMap.getCharactarName(this._petInfo.character);
         this._petNameTxt.text = PetConfig.getPetDefinition(this._petInfo.resourceId).name;
         this._currPractice.gotoAndStop(this.getIconId(this._petInfo.potential) + 1);
         if(this._cookbook != null)
         {
            this._cookbook(this._petInfo.sex);
         }
         this._cookbook = null;
      }
      
      private function getIconId(potential:uint) : int
      {
         if(potential >= 0 && potential <= 11)
         {
            return 1;
         }
         if(potential >= 12 && potential <= 21)
         {
            return 2;
         }
         if(potential >= 22)
         {
            if(this._petInfo.isAggraisal)
            {
               if(potential >= 22 && potential <= 23)
               {
                  return 4;
               }
               if(potential >= 24 && potential <= 27)
               {
                  return 5;
               }
               if(potential >= 28 && potential <= 30)
               {
                  return 6;
               }
               return 7;
            }
            return 3;
         }
         return 0;
      }
      
      public function dispose() : void
      {
         DisplayUtil.removeForParent(this._petDemo);
         DisplayUtil.removeForParent(this._mail);
      }
   }
}

