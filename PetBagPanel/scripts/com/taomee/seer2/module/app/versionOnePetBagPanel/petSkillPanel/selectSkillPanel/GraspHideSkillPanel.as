package com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel.selectSkillPanel
{
   import com.taomee.seer2.app.actor.ActorManager;
   import com.taomee.seer2.app.config.PetConfig;
   import com.taomee.seer2.app.config.SkillConfig;
   import com.taomee.seer2.app.config.skill.PetSkillSettingDefinition;
   import com.taomee.seer2.app.info.BuyPropInfo;
   import com.taomee.seer2.app.inventory.ItemManager;
   import com.taomee.seer2.app.manager.StatisticsManager;
   import com.taomee.seer2.app.net.CommandSet;
   import com.taomee.seer2.app.net.Connection;
   import com.taomee.seer2.app.pet.data.PetInfo;
   import com.taomee.seer2.app.pet.data.SkillInfo;
   import com.taomee.seer2.app.popup.AlertManager;
   import com.taomee.seer2.app.shopManager.ShopManager;
   import com.taomee.seer2.app.vip.VipManager;
   import com.taomee.seer2.core.loader.ContentInfo;
   import com.taomee.seer2.core.net.LittleEndianByteArray;
   import com.taomee.seer2.core.net.MessageEvent;
   import com.taomee.seer2.core.scene.LayerManager;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel.SelectSkillPanel;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.petSkillPanel.selectSkillPanel.graspHideSkillPanel.HideSkillAlertPanel;
   import com.taomee.seer2.module.app.versionOnePetBagPanel.util.skill.GraspSkillCell;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.IDataInput;
   import org.taomee.utils.DisplayUtil;
   
   public class GraspHideSkillPanel extends Sprite
   {
      
      public static var newGuideOpen:Boolean = false;
      
      private static var _notBuySkill:Vector.<uint> = Vector.<uint>([16077,16078,16079,17163]);
       
      
      private var _mainUI:MovieClip;
      
      private var _mc:MovieClip;
      
      private var _petInfo:PetInfo;
      
      private var _skillVec:Vector.<GraspSkillCell>;
      
      private var _currSelectSkillInfo:SkillInfo;
      
      private var _loadInfo:ContentInfo;
      
      private var _buySkillpanel:HideSkillAlertPanel;
      
      private var _thisParent:SelectSkillPanel;
      
      public function GraspHideSkillPanel(thisParent:SelectSkillPanel)
      {
         super();
         this.setup();
         this._thisParent = thisParent;
      }
      
      private function setup() : void
      {
         this._mainUI = new GraspHideSkillUI();
         this.initMC();
      }
      
      private function initMC() : void
      {
         this._skillVec = Vector.<GraspSkillCell>([]);
      }
      
      public function setPetInfoData(petInfo:PetInfo) : void
      {
         this._petInfo = petInfo;
         this.updatePetInfo();
      }
      
      public function setLoadInfo(value:ContentInfo) : void
      {
         this._loadInfo = value;
      }
      
      private function updatePetInfo() : void
      {
         var skill:PetSkillSettingDefinition = null;
         var skillCell:GraspSkillCell = null;
         var skillInfo:SkillInfo = null;
         this.clear();
         var petSkillSettingDefinition:Vector.<PetSkillSettingDefinition> = PetConfig.getPetSkillSettingDefinitionVec(this._petInfo.getPetDefinition().bunchId);
         petSkillSettingDefinition = HideSkillCheck.hideSkillCoveredRepair(this._petInfo.resourceId,petSkillSettingDefinition);
         for each(skill in petSkillSettingDefinition)
         {
            if(skill.learningLv > 100)
            {
               if(this._skillVec.length < 6)
               {
                  if(HideSkillCheck.checkSkillHideable(this._petInfo.resourceId,skill.id))
                  {
                     if(_notBuySkill.indexOf(skill.id) == -1)
                     {
                        skillCell = new GraspSkillCell(this._petInfo,this.clickBtn,this._mainUI);
                        skillInfo = new SkillInfo(skill.id);
                        skillInfo.isHideSkill = true;
                        skillCell.setSkillCellData(skillInfo,true);
                        this._skillVec.push(skillCell);
                     }
                  }
               }
            }
         }
         this.showSkillCell();
      }
      
      private function clickBtn(skillInfo:SkillInfo) : void
      {
         this._currSelectSkillInfo = skillInfo;
         if(Boolean(ItemManager.getSpecialItem(603035)) && ItemManager.getSpecialItem(603035).quantity > 0)
         {
            AlertManager.showConfirm("确定学习此隐藏技能吗？",function():void
            {
               Connection.addCommandListener(CommandSet.GRASP_SKILL_1246,onGraspSkill);
               var byte:LittleEndianByteArray = new LittleEndianByteArray();
               byte.writeUnsignedInt(1);
               byte.writeUnsignedInt(_currSelectSkillInfo.id);
               Connection.send(CommandSet.GRASP_SKILL_1246,_petInfo.catchTime,byte);
            });
            return;
         }
         StatisticsManager.sendNovice("0x1003373E");
         if(this._buySkillpanel == null)
         {
            this._buySkillpanel = new HideSkillAlertPanel(this.buyOneFunc,this.buyAllFunc,this.buyPanelClose);
            LayerManager.topLayer.addChild(this._buySkillpanel);
            DisplayUtil.align(this._buySkillpanel);
         }
      }
      
      private function buyOneFunc() : void
      {
         this.buySkill(1);
      }
      
      private function buyAllFunc() : void
      {
         var cell:GraspSkillCell = null;
         var count:int = 0;
         for each(cell in this._skillVec)
         {
            if(cell.checkHasSkill() == 1)
            {
               count++;
            }
         }
         if(count > 0)
         {
            this.buySkill(count);
         }
      }
      
      private function buySkill(count:int) : void
      {
         var info:BuyPropInfo;
         if(ActorManager.actorInfo.moneyCount < count * 30)
         {
            AlertManager.showAlert("星钻不足",function():void
            {
               VipManager.openVip();
            });
            return;
         }
         info = new BuyPropInfo();
         info.itemId = 603035;
         info.buyNum = count;
         info.buyComplete = function(data:*):void
         {
            updateCell();
         };
         ShopManager.buyVirtualItem(info);
      }
      
      private function buyPanelClose() : void
      {
         if(Boolean(this._buySkillpanel))
         {
            DisplayObjectUtil.removeFromParent(this._buySkillpanel);
            this._buySkillpanel = null;
         }
      }
      
      private function updateCell() : void
      {
         var cell:GraspSkillCell = null;
         for each(cell in this._skillVec)
         {
            cell.checkHasSkill();
         }
      }
      
      private function onGraspSkill(event:MessageEvent) : void
      {
         var i:int = 0;
         Connection.removeCommandListener(CommandSet.GRASP_SKILL_1246,this.onGraspSkill);
         var data:IDataInput = event.message.getRawData();
         var length:uint = uint(data.readUnsignedInt());
         var skillId:Array = [];
         var alertString:String = "";
         for(i = 0; i < length; )
         {
            skillId.push(data.readUnsignedInt());
            this._petInfo.skillInfo.candidateSkillInfoVec.push(new SkillInfo(skillId[i]));
            alertString += SkillConfig.getSkillDefinition(skillId[i]).name + " ";
            i++;
         }
         this._thisParent.changePetInfoData(null);
         ItemManager.reduceSpecialItem(603035,length);
         this.show();
         AlertManager.showAlert("恭喜\n" + this._petInfo.name + "学会了" + alertString);
      }
      
      private function showSkillCell() : void
      {
         var i:int = 0;
         var cell:GraspSkillCell = null;
         for(i = 0; i < this._skillVec.length; )
         {
            cell = this._skillVec[i];
            cell.x = 25 + i * cell.width;
            cell.y = 45;
            cell.setBtnX(25 + i * cell.width + 21);
            this._mainUI.addChild(cell);
            i++;
         }
      }
      
      public function show() : void
      {
         this.updateCell();
         addChild(this._mainUI);
         this.updateNewGraspPlay();
      }
      
      private function updateNewGraspPlay() : void
      {
         if(GraspHideSkillPanel.newGuideOpen)
         {
         }
      }
      
      private function clear() : void
      {
         var cell:GraspSkillCell = null;
         for each(cell in this._skillVec)
         {
            cell.dispose();
            DisplayUtil.removeForParent(cell);
         }
         this._skillVec = Vector.<GraspSkillCell>([]);
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this._mainUI);
      }
   }
}
