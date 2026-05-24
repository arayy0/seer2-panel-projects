package com.taomee.seer2.module.app.newPetDictionary
{
   import com.taomee.seer2.core.sound.SoundManager;
   import com.taomee.seer2.core.utils.URLUtil;
   import flash.display.Sprite;
   
   public class NewPetDicsListAndDetailPanel extends Sprite
   {
       
      
      private var _listPanel:NewPetDicsPetListPanel;
      
      private var _detailPanel:NewPetDicsPetDetailPanel;
      
      private var _data:Vector.<int>;
      
      public function NewPetDicsListAndDetailPanel()
      {
         super();
         this.createChildren();
         this.initEventListener();
      }
      
      private function createChildren() : void
      {
         this._listPanel = new NewPetDicsPetListPanel();
         addChild(this._listPanel);
         this._detailPanel = new NewPetDicsPetDetailPanel();
         addChild(this._detailPanel);
         this._detailPanel.x = 452;
         this._detailPanel.y = -51;
      }
      
      private function initEventListener() : void
      {
         this._listPanel.addEventListener("showPetDetail",this.onShowPetDetailPanel);
      }
      
      private function onShowPetDetailPanel(e:NewPetDicsEvent) : void
      {
         var resourceID:int = int(e.getPetResourceId());
         if(resourceID != this._detailPanel.petResourceId)
         {
            this._detailPanel.setData(resourceID);
            SoundManager.play(URLUtil.getPetSound(resourceID));
         }
      }
      
      public function get detailPanel() : NewPetDicsPetDetailPanel
      {
         return this._detailPanel;
      }
      
      public function setData(data:Vector.<int>) : void
      {
         this._data = data;
         this._listPanel.setData(data);
         if(Boolean(data) && data.length >= 2)
         {
            this._detailPanel.setData(data[1]);
         }
      }
      
      public function dispose() : void
      {
         this._listPanel.dispose();
      }
   }
}
