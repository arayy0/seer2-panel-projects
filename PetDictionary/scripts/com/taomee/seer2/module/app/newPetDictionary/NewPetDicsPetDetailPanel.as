package com.taomee.seer2.module.app.newPetDictionary
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.arena.util.SkillFieldTable;
   import com.taomee.seer2.app.component.PetDemoDisplayer;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.info.PetDictionaryInfo;
   import com.taomee.seer2.app.config.pet.PetDefinition;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.utils.ActsHelperUtil;
   import com.taomee.seer2.core.module.ModuleManager;
   import com.taomee.seer2.core.scene.SceneManager;
   import com.taomee.seer2.core.ui.UINumberGenerator;
   import com.taomee.seer2.core.ui.toolTip.TooltipManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.core.utils.URLUtil;
   import com.taomee.seer2.core.utils.Util;
   import com.taomee.seer2.module.app.moduleCommon.PetDecorationIcon;
   import com.taomee.seer2.module.app.moduleCommon.PetEmblemIcon;
   import com.taomee.seer2.module.app.moduleCommon.PetFeatureIcon;
   import com.taomee.seer2.module.app.petDictionary.data.PetDictionaryDataServer;
   import com.taomee.seer2.module.app.petDictionary.parser.PetAttributeParser;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.text.TextField;

import org.taomee.utils.DisplayUtil;

public class NewPetDicsPetDetailPanel extends Sprite
   {
       
      
      private var _descriptUI:NewPetDicsDetailUI;
      
      private var _petNameTxt:TextField;
      
      private var _numContainer:Sprite;
      
      private var _petFeatureIcon:PetFeatureIcon;
      
      private var _petEmblemIcon:PetEmblemIcon;

      private var _petDecorationIcon:PetDecorationIcon;
      
      private var _petResourceID:uint;
      
      private var _petFlag:int;
      
      private var _petDefinition:PetDefinition;
      
      private var _petHeightTxt:TextField;
      
      private var _petWeightTxt:TextField;
      
      private var _petBornAreaTxt:TextField;
      
      private var _petIntroTxt:TextField;
      
      private var _charaTxt:TextField;
      
      private const SPACESTRING:String = "   ";
      
      private var _petDemoDisplayer:PetDemoDisplayer;
      
      private var _goBtn:SimpleButton;
      
      private var _starLevel:MovieClip;
      
      private var _changPetBtn:SimpleButton;
      
      private var _prevPetId:uint;
      
      private var _currResId:int;
      
      private var _isChangePet:Boolean;
      
      public function NewPetDicsPetDetailPanel()
      {
         super();
         this.createChildren();
      }
      
      private function createChildren() : void
      {
         this._descriptUI = new NewPetDicsDetailUI();
         addChild(this._descriptUI);
         this._petNameTxt = this._descriptUI["nameTxt"];
         this._petHeightTxt = this._descriptUI["heightTxt"];
         this._petWeightTxt = this._descriptUI["weightTxt"];
         this._petBornAreaTxt = this._descriptUI["bornAreaTxt"];
         this._petIntroTxt = this._descriptUI["introTxt"];
         this._charaTxt = this._descriptUI["charaTxt"];
         this._goBtn = this._descriptUI["goBtn"];
         this._starLevel = this._descriptUI["starLevel"];
         this._changPetBtn = this._descriptUI["changPetBtn"];
         this._changPetBtn.addEventListener("click",this.onChangPet);
         this._numContainer = new Sprite();
         this._numContainer.x = 10;
         this._numContainer.y = 26;
         this._descriptUI.addChild(this._numContainer);
         this._petFeatureIcon = new PetFeatureIcon();
         this._petFeatureIcon.x = 290;
         this._petFeatureIcon.y = 118;
         this._petFeatureIcon.visible = false;
         addChild(this._petFeatureIcon);
         this._petEmblemIcon = new PetEmblemIcon();
         this._petEmblemIcon.x = 320;
         this._petEmblemIcon.y = 140;
         this._petEmblemIcon.visible = false;
         addChild(this._petEmblemIcon);
         this._petDecorationIcon = new PetDecorationIcon();
         this._petDecorationIcon.x = 355;
         this._petDecorationIcon.y = 140;
         this._petDecorationIcon.visible = false;
         addChild(this._petDecorationIcon);
         this._petDemoDisplayer = new PetDemoDisplayer();
         addChild(this._petDemoDisplayer);
         //下面这两行让变身按钮图层在最上
         DisplayUtil.removeForParent(this._descriptUI["changPetBtn"]);
         addChild(this._changPetBtn);
      }
      
      private function onChangPet(event:MouseEvent) : void
      {
         if(this._isChangePet)
         {
            this._currResId = this._prevPetId;
            this.changePetDemo();
         }
         else
         {
            this._prevPetId = this._currResId;
            this._currResId = PetConfig.getPetDefinition(this._prevPetId).chgMonId;
            this.changePetDemo();
         }
         this._isChangePet = !this._isChangePet;
      }
      
      public function setData(petResourceID:uint) : void
      {
         this._petResourceID = petResourceID;
         this._petFlag = PetDictionaryDataServer.getPetFlag(petResourceID);
         this._petFeatureIcon.visible = false;
         this._petEmblemIcon.visible = false;
         this._petDecorationIcon.visible = false;
         this._petDefinition = PetConfig.getPetDefinition(this._petResourceID);
         DisplayObjectUtil.removeAllChildren(this._numContainer);
         this._petFeatureIcon.visible = true;
         this._petEmblemIcon.visible = true;
         this._petBornAreaTxt.addEventListener("link",this.linkHandler);
         this.updata();
         this._currResId = this._petResourceID;
         this.changePetDemo();
         this.onGoStateFilter();
         this._goBtn.addEventListener("click",this.onGoBtn);
      }
      
      private function changePetDemo() : void
      {
         var url:String = String(URLUtil.getPetOriginDemo(this._currResId));
         this._petDemoDisplayer.newSetUrl(url,199,198,this.onLoadDemo);
      }
      
      private function onLoadDemo() : void
      {
         this._petDemoDisplayer.x = 117;
         this._petDemoDisplayer.y = 149;
      }
      
      public function get petResourceId() : int
      {
         return int(this._petResourceID);
      }
      
      private function updateDes(s:String) : void
      {
         var str:* = null;
         var mapName:* = s;
         str = mapName;
         this._petBornAreaTxt.htmlText = str;
      }
      
      private function updata() : void
      {
         var i:int = 0;
         var num:int = 0;
         var numSprite:Sprite = null;
         this._petNameTxt.text = SkillFieldTable.getTypeName(this._petDefinition.type) + "   " + this._petDefinition.name;
         this._starLevel.gotoAndStop(PetConfig.getPetDefinition(this._petResourceID).starLevel);
         if(PetConfig.getPetDefinition(this._petResourceID).chgMonId != 0)
         {
            this._changPetBtn.visible = true;
            TooltipManager.addCommonTip(this._changPetBtn,PetConfig.getPetDefinitionInfo(this._petResourceID).changeTip);
         }
         else
         {
            this._changPetBtn.visible = false;
         }
         var idNum:int = this._petResourceID;
         while(idNum > 10000)
         {
            idNum -= 10000;
         }
         var idStr:String = String(Util.pad(idNum.toString(),"0",4,false));
         for(i = 0; i < 4; )
         {
            num = int(idStr.charAt(i));
            numSprite = UINumberGenerator.generateLoaderNumber(num);
            numSprite.x = i * numSprite.width;
            this._numContainer.addChild(numSprite);
            i++;
         }
         this.updateDes(this._petDefinition.foundPlace);
         this._petHeightTxt.text = PetAttributeParser.parseHeightRange(this._petDefinition.heightRange);
         this._petWeightTxt.text = PetAttributeParser.parseWeightRange(this._petDefinition.weightRange);
         this._petFeatureIcon.setFeature(this._petDefinition.featureId,this._petDefinition.featureDescription);
         this._petEmblemIcon.id = this._petDefinition.emblemId;
         if(this._petDefinition.emblem2Id != 0)
         {
            this._petDecorationIcon.visible = true;
            this._petDecorationIcon.id = this._petDefinition.emblem2Id;
         }
         this._charaTxt.text = this._petDefinition.chara;
         this._petIntroTxt.text = "   " + this._petDefinition.description;
         if(this._petDefinition.featureId == 0)
         {
            this._petFeatureIcon.visible = false;
         }
         else
         {
            this._petFeatureIcon.visible = true;
         }
      }
      
      private function linkHandler(event:TextEvent) : void
      {
         var resId:int = int(event.text);
         this.onGoBtn(null);
      }
      
      private function onGoBtn(evt:MouseEvent) : void
      {
         var info:PetDictionaryInfo = null;
         if(Boolean(this._petDefinition))
         {
            info = PetConfig.getPetDefinitionInfo(this._petResourceID);
            if(Boolean(info))
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
                     AlertManager.showAlert("精灵获得途径已下架!");
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
      }
      
      private function onGoStateFilter() : void
      {
         var info:PetDictionaryInfo = null;
         if(Boolean(this._petDefinition))
         {
            info = PetConfig.getPetDefinitionInfo(this._petResourceID);
            if(Boolean(info))
            {
               if(int(info.getWay) != 0)
               {
                  DisplayObjectUtil.enableButton(this._goBtn);
               }
               else if(info.getWay != "")
               {
                  if(info.isClose == 1)
                  {
                     DisplayObjectUtil.disableButton(this._goBtn);
                     trace("精灵id:" + info.id + "活动已下架!");
                  }
                  else
                  {
                     DisplayObjectUtil.enableButton(this._goBtn);
                  }
               }
               else
               {
                  DisplayObjectUtil.disableButton(this._goBtn);
                  trace("精灵id:" + info.id + "没有配置免费获得路径!");
               }
            }
         }
      }
      
      private function changeMap($mapId:int) : void
      {
         if($mapId > 0 && $mapId != 981)
         {
            if($mapId == 50000)
            {
               if(SceneManager.active.mapID == ActorManager.getActor().id)
               {
                  AlertManager.showAlert("你已经在此地图了！");
               }
               else
               {
                  SceneManager.changeScene(3,ActorManager.getActor().id);
               }
            }
            else if(SceneManager.active.mapID == $mapId)
            {
               AlertManager.showAlert("你已经在此地图了！");
            }
            else
            {
               SceneManager.changeScene(1,$mapId);
            }
         }
         else
         {
            AlertManager.showAlert("当前地图不可传送！");
         }
         ModuleManager.closeForName("PetDictionary");
      }
      
      public function hide() : void
      {
         if(Boolean(this._petDemoDisplayer))
         {
            removeChild(this._petDemoDisplayer);
         }
      }
   }
}
