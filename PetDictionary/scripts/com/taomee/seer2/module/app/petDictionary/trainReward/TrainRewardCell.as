package com.taomee.seer2.module.app.petDictionary.trainReward
{
   import com.taomee.seer2.app.manager.OnlyFlagManager;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.module.app.petDictionary.PetTrainRewardCell;
   import com.taomee.seer2.module.app.petDictionary.TipUI_1;
   import com.taomee.seer2.module.app.petDictionary.TipUI_10;
   import com.taomee.seer2.module.app.petDictionary.TipUI_2;
   import com.taomee.seer2.module.app.petDictionary.TipUI_3;
   import com.taomee.seer2.module.app.petDictionary.TipUI_4;
   import com.taomee.seer2.module.app.petDictionary.TipUI_5;
   import com.taomee.seer2.module.app.petDictionary.TipUI_6;
   import com.taomee.seer2.module.app.petDictionary.TipUI_7;
   import com.taomee.seer2.module.app.petDictionary.TipUI_8;
   import com.taomee.seer2.module.app.petDictionary.TipUI_9;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.TrainRewardInfo;
   import com.taomee.seer2.module.app.petDictionary.data.PetDictionaryDataServer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TrainRewardCell extends Sprite
   {
       
      
      private var _info:TrainRewardInfo;
      
      private var _cellUI:PetTrainRewardCell;
      
      private var _nameMC:MovieClip;
      
      private var tipVec:Vector.<MovieClip>;
      
      private var _shineMC:MovieClip;
      
      public function TrainRewardCell()
      {
         this.tipVec = Vector.<MovieClip>([new TipUI_1(),new TipUI_2(),new TipUI_3(),new TipUI_4(),new TipUI_5(),new TipUI_6(),new TipUI_7(),new TipUI_8(),new TipUI_9(),new TipUI_10()]);
         super();
         this._cellUI = new PetTrainRewardCell();
         this._cellUI.gotoAndStop(1);
         this._nameMC = this._cellUI["nameMC"];
         this._shineMC = this._cellUI["shineMC"];
         this._shineMC.mouseEnabled = false;
         this._shineMC.stop();
         this._shineMC.visible = false;
         this._nameMC.gotoAndStop(1);
         addChild(this._cellUI);
      }
      
      private function openEventListener() : void
      {
         if(!this._cellUI.hasEventListener("click"))
         {
            this._cellUI.buttonMode = true;
            this._cellUI.addEventListener("click",this.onClick);
            this._cellUI.addEventListener("rollOver",this.onOver);
            this._cellUI.addEventListener("rollOut",this.onOut);
         }
      }
      
      private function closeEventListener() : void
      {
         if(this._cellUI.hasEventListener("click"))
         {
            this._cellUI.buttonMode = false;
            this._cellUI.removeEventListener("click",this.onClick);
            this._cellUI.removeEventListener("rollOver",this.onOver);
            this._cellUI.removeEventListener("rollOut",this.onOut);
         }
      }
      
      private function onOver(evt:MouseEvent) : void
      {
         this._cellUI.gotoAndStop(2);
      }
      
      private function onOut(evt:MouseEvent) : void
      {
         this._cellUI.gotoAndStop(1);
      }
      
      private function onClick(evt:MouseEvent) : void
      {
         PetDictionaryDataServer.getRewardByIndex(this._info.index,function():void
         {
            OnlyFlagManager.updataFlag(_info.onlyFlagIndex,1);
            _info.flag = 1;
            updata();
         });
      }
      
      public function setData(info:TrainRewardInfo) : void
      {
         this._info = info;
         if(this._info.index >= 9 && this._info.index <= 16)
         {
            this._nameMC.gotoAndStop(this._info.index - 8);
            TooltipManager.remove(this);
            TooltipManager.addExternalTip(this,this.tipVec[this._info.index - 9]);
         }
         if(this._info.index >= 40 && this._info.index <= 41)
         {
            this._nameMC.gotoAndStop(this._info.index - 31);
            TooltipManager.remove(this);
            TooltipManager.addExternalTip(this,this.tipVec[this._info.index - 32]);
         }
      }
      
      public function updata() : void
      {
         if(this._info.flag == 1)
         {
            this._cellUI.gotoAndStop(3);
            this.closeEventListener();
            DisplayObjectUtil.recoverDisplayObject(this._cellUI);
            this._nameMC.visible = false;
            this._shineMC.visible = false;
            this._shineMC.stop();
         }
         else
         {
            if(this._info.status == 1)
            {
               DisplayObjectUtil.recoverDisplayObject(this._cellUI);
               this.openEventListener();
               this._shineMC.visible = true;
               this._shineMC.play();
            }
            else
            {
               DisplayObjectUtil.grayDisplayObject(this._cellUI);
               this.closeEventListener();
               this._shineMC.visible = false;
               this._shineMC.stop();
            }
            this._nameMC.visible = true;
         }
      }
   }
}
