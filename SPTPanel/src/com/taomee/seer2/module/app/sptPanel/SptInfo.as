package com.taomee.seer2.module.app.sptPanel
{
   import com.taomee.seer2.app.gameRule.spt.support.SptConfigInfoManager;
   import org.taomee.utils.StringUtil;
   
   public class SptInfo
   {
      
      public var bossId:uint;
      
      public var petLevel:uint;
      
      public var openTip:String;
      
      public var bossTip:Vector.<String>;
      
      public var panelClass:Class;
      
      public var initX:Number;
      
      public var initY:Number;
      
      public var targetMapId:uint;
      
      public function SptInfo(bossId:uint, panelClass:Class, openTip:String, bossTip:Vector.<String>, initX:Number, initY:Number, targetMapId:Number)
      {
         super();
         this.bossId = bossId;
         this.petLevel = SptConfigInfoManager.getSptBossLevel(bossId);
         this.panelClass = panelClass;
         this.openTip = StringUtil.replace(openTip,"{0}",String(this.petLevel));
         this.bossTip = bossTip;
         this.initX = initX;
         this.initY = initY;
         this.targetMapId = targetMapId;
      }
   }
}

