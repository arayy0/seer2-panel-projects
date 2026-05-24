package com.taomee.seer2.module.app.starMagic
{
import com.taomee.seer2.app.config.ItemDictionaryConfig;
import com.taomee.seer2.app.starMagic.StarInfo;
import com.taomee.seer2.app.starMagic.StarMagicIconDisplayer;

import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class StarMagicPicPanel extends Sprite
   {
      private var _mc:MovieClip;
      
      private var curpage:int = 0;
      
      private var allpage:int = 0;
      
      private var _icon:Vector.<StarMagicIconDisplayer>;
      
      private var _info:Array;
      
      public function StarMagicPicPanel()
      {
         super();
         this._mc = new StarPicture();
         this.addChild(this._mc);
         this.init();
         this._mc["arrow1"].addEventListener("click",this.onClick);
         this._mc["arrow2"].addEventListener("click",this.onClick);
         this._mc["closeBtn"].addEventListener("click",this.onClick);
         this.updateAllPage();
         this.resetInfo();
      }
      
      public function resetInfo() : void
      {
         this.curpage = 0;
         this.update();
      }
      
      private function init() : void
      {
         var i:int = 0;
         this._icon = new Vector.<StarMagicIconDisplayer>(8);
         for(i = 0; i < this._icon.length; )
         {
            this._icon[i] = new StarMagicIconDisplayer(0,0,true);
            this._icon[i].x = this._icon[i].y = 0;
            this._icon[i].scaleX = this._icon[i].scaleY = 44 / 60;
            this._mc["mc" + i]["iconMc"].addChild(this._icon[i]);
            i++;
         }
      }
      
      private function onClick(e:MouseEvent) : void
      {
         if(e.target == this._mc["arrow1"])
         {
            --this.curpage;
            if(this.curpage <= 0)
            {
               this.curpage = 0;
            }
            this.update();
         }
         else if(e.target == this._mc["arrow2"])
         {
            ++this.curpage;
            if(this.curpage >= this.allpage - 1)
            {
               this.curpage = this.allpage - 1;
            }
            this.update();
         }
         else if(e.target == this._mc["closeBtn"])
         {
            this.visible = false;
         }
      }
      
      private function updateAllPage() : void
      {
         var i:int = 0;
         if(!this._info)
         {
            this._info = [];
         }
         i = 0;
         var infoVec:Vector.<StarInfo> = ItemDictionaryConfig.getStarInfoVec();
         while(i < infoVec.length)
         {
            if(infoVec[i].id > 0)
            {
               this._info.push(infoVec[i]);
            }
            i++;
         }
         this.allpage = this._info.length / 8;
         if(Boolean(this._info.length % 8))
         {
            ++this.allpage;
         }
      }
      
      public function update() : void
      {
         var i:int = 0;
         for(i = 0; i < 8; )
         {
            if(i + this.curpage * 8 < this._info.length)
            {
               this.addMc(this._mc["mc" + i],this._info[i + this.curpage * 8],i);
            }
            else
            {
               this.clearMc(this._mc["mc" + i]);
            }
            i++;
         }
         this._mc["pageText"].text = "" + (this.curpage + 1) + "/" + this.allpage;
      }
      
      private function clearMc(mc:MovieClip) : void
      {
         mc["nameT"].text = "";
         mc["level"].text = "";
         mc["desc"].text = "";
         mc["iconMc"].visible = false;
      }
      
      private function addMc(mc:MovieClip, info:StarInfo, i:int) : void
      {
         mc["nameT"].text = "" + info.nameT;
         mc["level"].text = "Lv." + info.maxLevel;
         mc["desc"].text = "" + info.desc.join("\n");
         mc["iconMc"].visible = true;
         this._icon[i].updateDateInfo(info);
      }
   }
}

