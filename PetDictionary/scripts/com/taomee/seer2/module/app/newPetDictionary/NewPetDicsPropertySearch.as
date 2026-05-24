package com.taomee.seer2.module.app.newPetDictionary
{
   import com.taomee.seer2.app.arena.util.SkillFieldTable;
   import com.taomee.seer2.app.config.NewPetDicThisWeekListConfig;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.pet.PetDefinition;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.module.app.petDictionary.data.PetDictionaryDataServer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class NewPetDicsPropertySearch extends Sprite
   {
      
      private static var _property:int;
      
      public static const CLICK_ITEM:String = "CLICK_ITEM";
      
      private static var _dataOfAll:Array;
      
      private static var _dataOfThisWeek:Array;
      
      private static var _thisWeekPetsID:Vector.<int> = NewPetDicThisWeekListConfig.getPetIDForDic();
       
      
      private var _mainUI:Sprite;
      
      private var _btnVec:Vector.<MovieClip>;
      
      public function NewPetDicsPropertySearch()
      {
         super();
         this.createChildren();
      }
      
      private static function findDataByPropertyOfAll(property:int) : void
      {
         var petdefinition:PetDefinition = null;
         var petids:Vector.<int> = null;
         var i:int = 0;
         if(!_dataOfAll)
         {
            _dataOfAll = [];
         }
         if(property == 0)
         {
            _dataOfAll[property] = PetDictionaryDataServer.getAllPets();
         }
         else
         {
            (petids = new Vector.<int>())[0] = 0;
            for(i = 0; i <= PetConfig.getPetCount(); )
            {
               if(i < 9999)
               {
                  petdefinition = PetConfig.getPetDefinition(i);
                  if(Boolean(petdefinition) && petdefinition.type == property && Boolean(PetConfig.getPetDefinitionInfo(i)))
                  {
                     petids.push(petdefinition.resId);
                  }
               }
               i++;
            }
            _dataOfAll[property] = petids;
         }
      }
      
      public static function getDataByPropertyOfAll() : Vector.<int>
      {
         if(Boolean(_dataOfAll) && Boolean(_dataOfAll[_property]))
         {
            return _dataOfAll[_property];
         }
         findDataByPropertyOfAll(_property);
         return _dataOfAll[_property];
      }
      
      private static function findDataByPropertyOfThisWeek(property:int) : void
      {
         var petdefinition:PetDefinition = null;
         var petids:Vector.<int> = null;
         var i:int = 0;
         if(!_dataOfThisWeek)
         {
            _dataOfThisWeek = [];
         }
         if(property == 0)
         {
            _dataOfThisWeek[property] = PetDictionaryDataServer.thisWeekPets;
         }
         else
         {
            (petids = new Vector.<int>())[0] = 0;
            for(i = 0; i < _thisWeekPetsID.length; )
            {
               petdefinition = PetConfig.getPetDefinition(_thisWeekPetsID[i]);
               if(Boolean(petdefinition) && petdefinition.type == property)
               {
                  petids.push(petdefinition.resId);
               }
               i++;
            }
            _dataOfThisWeek[property] = petids;
         }
      }
      
      public static function getDataByPropertyOfThisWeek() : Vector.<int>
      {
         if(Boolean(_dataOfThisWeek) && Boolean(_dataOfThisWeek[_property]))
         {
            return _dataOfThisWeek[_property];
         }
         findDataByPropertyOfThisWeek(_property);
         return _dataOfThisWeek[_property];
      }
      
      private function createChildren() : void
      {
         var i:int = 0;
         this._mainUI = new NewPetDicsPropertySearchUI();
         addChild(this._mainUI);
         this._btnVec = new Vector.<MovieClip>();
         for(i = 0; i < 22; )
         {
            this._btnVec.push(this._mainUI["btn" + i]);
            this._btnVec[i].buttonMode = true;
            if(i == 0)
            {
               TooltipManager.addCommonTip(this._btnVec[i],"全部");
            }
            else
            {
               TooltipManager.addCommonTip(this._btnVec[i],SkillFieldTable.getTypeName(i));
            }
            this._btnVec[i].addEventListener("click",this.onClick);
            i++;
         }
      }
      
      private function onClick(e:MouseEvent) : void
      {
         e.stopPropagation();
         var index:int = this._btnVec.indexOf(e.currentTarget as MovieClip);
         if(index == 0)
         {
            _property = 0;
         }
         else
         {
            _property = index;
         }
         dispatchEvent(new Event("CLICK_ITEM"));
      }
   }
}
