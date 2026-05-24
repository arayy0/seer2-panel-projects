package com.taomee.seer2.module.app.winterSignPanel.item
{
   import com.taomee.seer2.app.config.WinterSignConfig;
   import com.taomee.seer2.app.config.info.WinterSignInfo;
   import com.taomee.seer2.app.event.LogicEvent;
   import com.taomee.seer2.app.swap.SwapManager;
   import com.taomee.seer2.app.swap.info.SwapInfo;
   import com.taomee.seer2.app.swap.special.SpecialInfo;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.events.ModelLocator;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.IDataInput;
   import org.taomee.utils.BitUtil;
   import org.taomee.utils.DisplayUtil;
   
   public class WinSignForItem extends Sprite
   {
      private var _mc:MovieClip;
      
      private var _nameTxt:TextField;
      
      private var _getedMark:MovieClip;
      
      private var _getBtn:SimpleButton;
      
      private var _petInfo:SimpleButton;
      
      private var _awardItem:MovieClip;
      
      private var _iconList:Vector.<WinSignIcon>;
      
      private var _petId:int;
      
      private var _info:WinterSignInfo;
      
      public function WinSignForItem()
      {
         super();
         this._mc = new ForSignItemUI();
         this._petId = -1;
         addChild(this._mc);
         this.initSet();
         this.initEvent();
      }
      
      private function initSet() : void
      {
         this._nameTxt = this._mc["nameTxt"];
         this._iconList = Vector.<WinSignIcon>([]);
         this._getedMark = this._mc["getedMark"];
         this._getBtn = this._mc["getBtn"];
         this._petInfo = this._mc["petInfo"];
         this._awardItem = this._mc["awardItem"];
      }
      
      public function setAwardIndex(index:int) : void
      {
         this._awardItem.gotoAndStop(index);
         if(index == 2)
         {
            TooltipManager.addCommonTip(this._awardItem,"有概率获得:魔炎煞、冥雷煞、宙斯、陶神、魔神库贝萨、观星者、圣灵天尊、\n奎尔斯之影、王伊特、魔尊左使、魔尊右使、不灭炎凰、哈迪斯、恶灵兽、\n小开元、开元大帝、小混沌、混沌大帝、小创世、创世大帝");
         }
      }
      
      private function initEvent() : void
      {
         this._getBtn.addEventListener("click",this.onFuncBtn);
         this._petInfo.addEventListener("click",this.onPetInfo);
      }
      
      private function onPetInfo(evt:MouseEvent) : void
      {
         if(this._petId == -1)
         {
            return;
         }
         ModuleManager.showAppModule("PetDetailInfoPanel",{"resId":this._petId});
      }
      
      private function onFuncBtn(evt:MouseEvent) : void
      {
         var swapId:int = 0;
         if(Boolean(this._info))
         {
            if(this._info.type == "day")
            {
               swapId = int(WinterSignConfig.swapList[0]);
            }
            else
            {
               swapId = int(WinterSignConfig.swapList[1]);
            }
            SwapManager.swapItem(swapId,1,function(data:IDataInput):void
            {
               new SwapInfo(data);
               ModelLocator.getInstance().dispatchEvent(new LogicEvent("winterSignGetAward"));
            },null,new SpecialInfo(1,_info.totalWin));
         }
      }
      
      private function setFuncDisable() : void
      {
         DisplayObjectUtil.disableButton(this._getBtn);
      }
      
      public function setData(petMeleeWinInfo:WinterSignInfo, curTaskNum:int, getState:int) : void
      {
         var icon:WinSignIcon = null;
         var iconc:WinSignIcon = null;
         var i:int = 0;
         this.visible = true;
         this.setFuncDisable();
         this._info = petMeleeWinInfo;
         this._nameTxt.text = petMeleeWinInfo.tip;
         this._getBtn.filters = [];
         if(curTaskNum >= petMeleeWinInfo.totalWin)
         {
            if(BitUtil.getBit(getState,this._info.index - 1))
            {
               this._getedMark.visible = true;
               DisplayObjectUtil.disableButton(this._getBtn);
            }
            else
            {
               this._getedMark.visible = false;
               DisplayObjectUtil.enableButton(this._getBtn);
            }
         }
         else
         {
            this._getedMark.visible = false;
            DisplayObjectUtil.disableButton(this._getBtn);
         }
         for each(icon in this._iconList)
         {
            icon.dispose();
            DisplayUtil.removeForParent(icon);
         }
         this._iconList = Vector.<WinSignIcon>([]);
         this._petInfo.visible = false;
         for(i = 0; i < petMeleeWinInfo.itemList.length; )
         {
            if(petMeleeWinInfo.itemList[i] != 0)
            {
               iconc = new WinSignIcon(petMeleeWinInfo.itemList[i],petMeleeWinInfo.countList[i]);
               iconc.scaleX = iconc.scaleY = 2;
               iconc.x = -55 + 76 * i;
               iconc.y = -59;
               this._mc.addChild(iconc);
               this._iconList.push(iconc);
               if(petMeleeWinInfo.itemList[i] > 1000000)
               {
                  this._petInfo.visible = true;
                  this._petId = petMeleeWinInfo.itemList[i] - 1000000;
               }
            }
            i++;
         }
      }
      
      public function dispose() : void
      {
         this.visible = false;
      }
   }
}

