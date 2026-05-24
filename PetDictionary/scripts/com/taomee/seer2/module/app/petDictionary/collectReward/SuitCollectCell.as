package com.taomee.seer2.module.app.petDictionary.collectReward
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.config.ItemConfig;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.info.PetDictionaryInfo;
   import com.taomee.seer2.app.config.item.EquipItemDefinition;
   import com.taomee.seer2.app.config.pet.PetDefinition;
   import com.taomee.seer2.app.manager.OnlyFlagManager;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.utils.ActsHelperUtil;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.module.app.petDictionary.config.configInfo.SuitRewardInfo;
   import com.taomee.seer2.module.app.petDictionary.data.PetDictionaryDataServer;
   import com.taomee.seer2.module.app.petDictionary.suitCollecteCellUI;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class SuitCollectCell extends Sprite
   {
       
      
      private var _info:SuitRewardInfo;
      
      private var _getRewardBtn:SimpleButton;
      
      private var _receivedBtn:MovieClip;
      
      private var _iconVec:Vector.<IconDisplayer>;
      
      private var _txtVec:Vector.<TextField>;
      
      private var _rewardIcon:IconDisplayer;
      
      private var _collectCnt:int;
      
      private var _shineMC:MovieClip;
      
      public function SuitCollectCell()
      {
         super();
         this.createChildren();
         this.initEventListener();
      }
      
      private function createChildren() : void
      {
         var i:int = 0;
         var mainUI:suitCollecteCellUI = null;
         var icon:IconDisplayer = null;
         mainUI = new suitCollecteCellUI();
         addChild(mainUI);
         this._getRewardBtn = mainUI["getRewardBtn"];
         this._receivedBtn = mainUI["receivedBtn"];
         this._shineMC = mainUI["shineMC"];
         this._shineMC.mouseEnabled = false;
         this._shineMC.visible = false;
         this._shineMC.stop();
         this._rewardIcon = new IconDisplayer();
         TooltipManager.addItemTip(this._rewardIcon,null);
         this._rewardIcon.scaleX = this._rewardIcon.scaleY = 0.7538461538461538;
         mainUI["rewardIcon"].addChild(this._rewardIcon);
         this._iconVec = new Vector.<IconDisplayer>();
         this._txtVec = new Vector.<TextField>();
         for(i = 0; i < 3; )
         {
            icon = new IconDisplayer();
            icon.scaleX = icon.scaleY = 1.4912280701754386;
            mainUI["icon_" + i].addChild(icon);
            this._iconVec.push(icon);
            this._txtVec.push(mainUI["petIdTxt_" + i]);
            TooltipManager.addMultipleTip(icon,"");
            i++;
         }
      }
      
      private function initEventListener() : void
      {
         this._getRewardBtn.addEventListener("click",this.onGerReward);
      }
      
      private function onGerReward(evt:MouseEvent) : void
      {
         PetDictionaryDataServer.getRewardByIndex(this._info.index,function():void
         {
            _info.flag = 1;
            OnlyFlagManager.updataFlag(_info.onlyFlagIndex,1);
            _getRewardBtn.removeEventListener("click",onGerReward);
            updata();
         });
      }
      
      public function setData(info:SuitRewardInfo) : void
      {
         var i:int = 0;
         var iconId:int = 0;
         var petDefinition:PetDefinition = null;
         var tip:String = null;
         this._info = info;
         this._rewardIcon.setIconUrl(URLUtil.getEquipIcon(info.rewardId));
         var definition:EquipItemDefinition = ItemConfig.getEquipDefinition(info.rewardId);
         TooltipManager.setData(this._rewardIcon,{
            "name":definition.name,
            "description":definition.tip
         });
         for(i = 0; i < 3; )
         {
            iconId = info.neePetIconVec[i];
            this._iconVec[i].setIconUrl(URLUtil.getPetIcon(iconId));
            petDefinition = PetConfig.getPetDefinition(iconId);
            tip = "名称：" + petDefinition.name + "\n" + "分布：" + petDefinition.foundPlace;
            this._iconVec[i].name = petDefinition.foundPlace + "_" + iconId;
            this._iconVec[i].buttonMode = true;
            this._iconVec[i].addEventListener("click",this.onCell);
            TooltipManager.changeTip(this._iconVec[i],tip);
            i++;
         }
         this.updata();
      }
      
      private function onCell(e:MouseEvent) : void
      {
         var $Btn:IconDisplayer = e.currentTarget as IconDisplayer;
         var resId:int = int($Btn.name.split("_")[1]);
         var info:PetDictionaryInfo;
         if(Boolean(info = PetConfig.getPetDefinitionInfo(resId)))
         {
            if(int(info.getWay) != 0)
            {
               ModuleManager.closeForInstance(this);
               ActsHelperUtil.goHandle(int(info.getWay));
            }
            else if(info.getWay != "")
            {
               if(info.isClose == 1)
               {
                  AlertManager.showAlert("精灵获得路径已下架!");
               }
               else
               {
                  ModuleManager.closeForInstance(this);
                  ActsHelperUtil.goHandle(info.getWay);
               }
            }
            else
            {
               AlertManager.showAlert("精灵没有配置获得途径哦!");
            }
         }
      }
      
      public function updata() : void
      {
         this.updataStatus();
         this.updataBtn();
      }
      
      private function updataStatus() : void
      {
         var i:int = 0;
         var id:int = 0;
         this._collectCnt = 0;
         for(i = 0; i < 3; )
         {
            id = this._info.neePetIconVec[i];
            if(PetDictionaryDataServer.getPetFlag(id) == 2)
            {
               ++this._collectCnt;
               DisplayObjectUtil.recoverDisplayObject(this._iconVec[i]);
            }
            else
            {
               DisplayObjectUtil.grayDisplayObject(this._iconVec[i]);
            }
            i++;
         }
         if(this._collectCnt < 3)
         {
            DisplayObjectUtil.disableButton(this._getRewardBtn);
            this._shineMC.stop();
            this._shineMC.visible = false;
         }
         else
         {
            DisplayObjectUtil.enableButton(this._getRewardBtn);
            this._shineMC.play();
            this._shineMC.visible = true;
         }
      }
      
      private function updataBtn() : void
      {
         if(this._info.flag == 1)
         {
            this._receivedBtn.visible = true;
            this._getRewardBtn.visible = false;
            this._shineMC.stop();
            this._shineMC.visible = false;
         }
         else
         {
            this._receivedBtn.visible = false;
            this._getRewardBtn.visible = true;
         }
      }
   }
}
