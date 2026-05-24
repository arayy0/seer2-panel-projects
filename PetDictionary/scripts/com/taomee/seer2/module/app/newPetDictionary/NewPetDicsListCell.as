package com.taomee.seer2.module.app.newPetDictionary
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.core.effects.MotionEffects;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.core.utils.Util;
   import com.taomee.seer2.module.app.petDictionary.data.PetDictionaryDataServer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class NewPetDicsListCell extends Sprite
   {
       
      
      private var _cell:NewPetDicsListCellUI;
      
      private var _iconHolder:Sprite;
      
      private var _icon:IconDisplayer;
      
      private var _isOpenMC:Sprite;
      
      private var _isGainedMC:MovieClip;
      
      private var _isNewMC:Sprite;
      
      private var _petIdTxt:TextField;
      
      private var _petNameTxt:TextField;
      
      private var _textFormat:TextFormat;
      
      private var _hotArea:Sprite;
      
      public var resourceID:uint;
      
      private var _isSpeak:Boolean;
      
      public function NewPetDicsListCell()
      {
         super();
         this.createChildren();
      }
      
      private function createChildren() : void
      {
         this._cell = new NewPetDicsListCellUI();
         addChild(this._cell);
         this._iconHolder = this._cell["iconHolder"];
         this._isGainedMC = this._cell["isGained"];
         this._isNewMC = this._cell["isNew"];
         this._petIdTxt = this._cell["petNumber"];
         this._isOpenMC = this._cell["isOpen"];
         this._petNameTxt = this._cell["petName"];
         this._textFormat = new TextFormat();
         this._textFormat.color = 16777113;
         this._petIdTxt.defaultTextFormat = this._textFormat;
         this._icon = new IconDisplayer();
         this._icon.scaleX = this._icon.scaleY = 1.5;
         this._icon.x = (this._iconHolder.width - 80) / 2;
         this._icon.y = (this._iconHolder.height - 80) / 2;
         this._iconHolder.addChild(this._icon);
         this.buttonMode = true;
         this._isGainedMC.visible = false;
         this._isNewMC.visible = false;
         this._isOpenMC.visible = false;
         this._hotArea = DisplayObjectUtil.createHotArea(85,85);
         this._hotArea.x = -42.5;
         this._hotArea.y = -42.5;
         addChild(this._hotArea);
         this._hotArea.addEventListener("rollOver",this.onHotOver);
         this._hotArea.addEventListener("rollOut",this.onHotOut);
      }
      
      private function onHotOver(evt:MouseEvent) : void
      {
         MotionEffects.execElastic(this._cell);
      }
      
      private function onHotOut(evt:MouseEvent) : void
      {
         MotionEffects.resetScale(this._cell);
      }
      
      public function setData(resourceID:uint, isSpeak:Boolean) : void
      {
         var flag:int = 0;
         var id:int = resourceID;
         this.resourceID = resourceID;
         if(resourceID == 0)
         {
            return;
         }
         this._petIdTxt.text = Util.pad(id.toString(),"0",4,false);
         this._petNameTxt.text = PetConfig.getPetDefinition(resourceID) == null ? "" : String(PetConfig.getPetDefinition(resourceID).name);
         if(PetConfig.getPetDefinition(resourceID) == null)
         {
            this._isOpenMC.visible = true;
            return;
         }
         this._icon.setIconUrl(URLUtil.getPetIcon(resourceID));
         flag = PetDictionaryDataServer.getPetFlag(resourceID);
         if(flag == 0 || flag == 1)
         {
            this._textFormat.color = 65535;
            this._petIdTxt.setTextFormat(this._textFormat);
            this._isGainedMC.visible = true;
            this._isGainedMC.gotoAndStop(2);
         }
         else
         {
            DisplayObjectUtil.recoverDisplayObject(this._icon);
            if(flag == 2)
            {
               this._isGainedMC.visible = true;
               this._isGainedMC.gotoAndStop(1);
            }
         }
         if(resourceID > 10000)
         {
            this._isGainedMC.visible = false;
         }
         else
         {
            this._isGainedMC.visible = true;
         }
         if(PetConfig.isPetNew(resourceID))
         {
            this._isNewMC.visible = true;
         }
      }
      
      public function clear() : void
      {
         this._icon.dispose();
         this._isGainedMC.visible = false;
         this._isNewMC.visible = false;
         this._isOpenMC.visible = false;
         this._petIdTxt.text = "";
         this._petNameTxt.text = "";
      }
   }
}
