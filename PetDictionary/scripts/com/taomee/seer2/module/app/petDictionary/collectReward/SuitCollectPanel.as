package com.taomee.seer2.module.app.petDictionary.collectReward
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.actor.data.UserInfo;
   import com.taomee.seer2.app.actor.preview.ActorPreview;
   import com.taomee.seer2.app.actor.util.ActorEquipAssembler;
   import com.taomee.seer2.app.inventory.item.EquipItem;
   import com.taomee.seer2.module.app.petDictionary.config.PetDictionaryConfig;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.SuitInfo;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.SuitRewardInfo;
   import com.taomee.seer2.module.app.petDictionary.data.PetDictionaryDataServer;
   import com.taomee.seer2.module.app.petDictionary.event.PetDictionaryEvent;
   import com.taomee.seer2.module.app.petDictionary.suitCollectePanelUI;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class SuitCollectPanel extends Sprite
   {
       
      
      private var _suitVec:Vector.<SuitRewardInfo>;
      
      private var _suitCellVec:Vector.<SuitCollectCell>;
      
      private var _actorPreview:ActorPreview;
      
      private var _suitNameTxt:TextField;
      
      private var _newMC:MovieClip;
      
      public function SuitCollectPanel()
      {
         super();
         this.createChildren();
         this.createActorPreview();
      }
      
      public function get newMc() : MovieClip
      {
         return this._newMC;
      }
      
      private function createChildren() : void
      {
         var i:int = 0;
         var cell:SuitCollectCell = null;
         var mainUI:suitCollectePanelUI = new suitCollectePanelUI();
         mainUI.x = 52;
         mainUI.y = 107;
         addChild(mainUI);
         this._suitNameTxt = mainUI["nameTxt"];
         this._newMC = mainUI["newMc"];
         this._newMC.visible = false;
         this._suitCellVec = new Vector.<SuitCollectCell>();
         for(i = 0; i < 5; )
         {
            cell = new SuitCollectCell();
            cell.x = 302;
            cell.y = 82 + 70 * i;
            addChild(cell);
            this._suitCellVec.push(cell);
            i++;
         }
      }
      
      private function createActorPreview() : void
      {
         this._actorPreview = new ActorPreview();
         this._actorPreview.scaleX = this._actorPreview.scaleY = 0.8;
         this._actorPreview.x = 155;
         this._actorPreview.y = 340;
         addChild(this._actorPreview);
      }
      
      private function updateActorPreview(equipVec:Vector.<int>) : void
      {
         var equipReferenceId:uint = 0;
         var equipItem:EquipItem = null;
         var info:UserInfo;
         (info = new UserInfo()).color = ActorManager.actorInfo.color;
         info.equipVec = new Vector.<EquipItem>();
         for each(equipReferenceId in equipVec)
         {
            equipItem = new EquipItem(equipReferenceId);
            info.equipVec.push(equipItem);
         }
         ActorEquipAssembler.mergeDefaultEquip(info.color,info.equipVec);
         this._actorPreview.setData(info);
      }
      
      public function setData(suitId:int) : void
      {
         var i:int = 0;
         this._suitVec = PetDictionaryConfig.getSuitRewardVec(suitId);
         var info:SuitInfo = PetDictionaryConfig.getSuitInfo(suitId);
         this.updateActorPreview(info.suitVec);
         this._suitNameTxt.text = info.suitName;
         for(i = 0; i < this._suitVec.length; )
         {
            this._suitCellVec[i].setData(this._suitVec[i]);
            i++;
         }
      }
      
      public function updateShine(vec:Vector.<int>) : void
      {
         var $suitVec:Vector.<SuitRewardInfo> = null;
         var i:uint = 0;
         var j:int = 0;
         var m:int = 0;
         var id:int = 0;
         var $collectCnt:int = 0;
         loop0:
         for(i = 0; i < vec.length; )
         {
            $suitVec = PetDictionaryConfig.getSuitRewardVec(vec[i]);
            for(j = 0; j < $suitVec.length; )
            {
               $collectCnt = 0;
               for(m = 0; m < 3; )
               {
                  id = $suitVec[j].neePetIconVec[m];
                  if(PetDictionaryDataServer.getPetFlag(id) == 2)
                  {
                     $collectCnt++;
                  }
                  m++;
               }
               if($collectCnt >= 3 && $suitVec[j].flag != 1)
               {
                  dispatchEvent(new PetDictionaryEvent("collectPetShine"));
                  break loop0;
               }
               j++;
            }
            i++;
         }
      }
      
      public function updata() : void
      {
         var i:int = 0;
         for(i = 0; i < this._suitCellVec.length; )
         {
            this._suitCellVec[i].updata();
            i++;
         }
      }
   }
}
