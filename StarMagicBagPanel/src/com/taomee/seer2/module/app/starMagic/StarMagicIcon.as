package com.taomee.seer2.module.app.starMagic
{
   import com.taomee.seer2.app.component.IconDisplayer;
   import com.taomee.seer2.app.starMagic.StarInfo;
   import com.taomee.seer2.app.starMagic.StarMagicConfig;
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
import com.taomee.seer2.core.utils.URLUtil;

import flash.display.DisplayObject;

import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;

public class StarMagicIcon extends Sprite
   {
      public static var m_fliters:GlowFilter = new GlowFilter(0,1,4,4);
      
      public var index:int;
      
      private var _mc:MovieClip;
      
      public var _mc2:MovieClip;
      
      private var _id:int;
      
      private var _type:int;
      
      private var _power:int;
      
      private var _moveState:int = 0;
      
      private var _tx:int;
      
      private var _ty:int;
      
      private var _info:StarInfo;
      
      private var _tip:MovieClip;
      
      private var _textField:TextField;
      
      private var _levelField:TextField;

      private var _displayer:IconDisplayer;
      
      public function StarMagicIcon(id:int, Type:int)
      {
         super();
         this.buttonMode = true;
         this._id = id;
         this._type = Type;
         this._info = new StarInfo();
         var format:TextFormat = new TextFormat();
         format.align = TextFormatAlign.CENTER;
         format.font = "_sans";
         format.size = 14;
         this._textField = new TextField();
         this._textField.x = 0;
         this._textField.y = 0;
         this._textField.width = 60;
         this._textField.height = 18;
         this._textField.filters = [m_fliters];
         this._textField.setTextFormat(format);
         this._textField.defaultTextFormat = format;
         this.addChild(this._textField);
         this._levelField = new TextField();
         this._levelField.x = 0;
         this._levelField.y = 42;
         this._levelField.width = 60;
         this._levelField.height = 18;
         this._levelField.filters = [m_fliters];
         this._levelField.setTextFormat(format);
         this._levelField.defaultTextFormat = format;
         this.addChild(this._levelField);
         this._displayer = new IconDisplayer();
         this.addChild(this._displayer);
         this.showIcon();
         this.mouseChildren = false;
      }
      
      public function updateDateInfo(info:StarInfo) : void
      {
         if(Boolean(info))
         {
            this._id = info.buffId;
            this._type = info.type;
            StarInfo.updateStarInfo(info,this._info);
            this._info.nameT = (info.nameT != null) ? info.nameT : StarMagicConfig.getInfoById(this._id).nameT;
         }
         else
         {
            this._id = 0;
         }
         this.showIcon();
      }
      
      private function onMouseDown(e:MouseEvent) : void
      {
         this.startDrag();
         this._moveState = 1;
      }
      
      private function onMouseUp(e:MouseEvent) : void
      {
         this.stopDrag();
         this._moveState = 2;
      }
      
      private function setTextColor() : void
      {
         if(this._id == 1)
         {
            this._textField.textColor = 16777215;
            this._levelField.textColor = 16777215;
         }
         else if(this._id == 2)
         {
            this._textField.textColor = 16777215;
            this._levelField.textColor = 16777215;
         }
         else if(this._type == 0)
         {
            this._textField.textColor = 16777215;
            this._levelField.textColor = 16777215;
         }
         else if(this._type == 1)
         {
            this._textField.textColor = 65433;
            this._levelField.textColor = 16777215;
         }
         else if(this._type == 2)
         {
            this._textField.textColor = 776186;
            this._levelField.textColor = 16777215;
         }
         else if(this._type == 3)
         {
            this._textField.textColor = 14105826;
            this._levelField.textColor = 16777215;
         }
         else if(this._type == 4)
         {
            this._textField.textColor = 14153011;
            this._levelField.textColor = 16777215;
         }
      }
      
      private function showIcon() : void
      {
         /*if(Boolean(this._mc) && this.contains(this._mc))
         {
            this._mc.gotoAndStop(1);
            this.removeChild(this._mc);
            this._mc = null;
         }
         if(this._id == 0)
         {
            this._mc = new staricon0();
            this._mc.alpha = 0;
         }
         else
         {
            this._mc = this.getMovieClip();
            this._mc.alpha = 1;
            this._mc.gotoAndStop(1);
         }
         this._mc.x = 22;
         this._mc.y = 22;
         if(!this._mc2)
         {
            this._mc2 = new staricon0();
            this._mc2.x = 22;
            this._mc2.y = 22;
            this._mc2.alpha = 0;
            this.addChild(this._mc2);
         }
         if(this._id >= 3)
         {
            this._mc.x = 22;
            this._mc.y = 22;
         }
         this.addChild(this._mc);
         this._mc.gotoAndStop(1);
         */
         this._displayer.removeIcon();
         this._displayer.mouseEnabled = false;
         var resId:uint = 0;
         resId = this.getStarItemId();
         if(resId != 0)
         {
            this._displayer.mouseEnabled = true;
            this._displayer.visible = true;
         }
         else
         {
            this._displayer.mouseEnabled = false;
            this._displayer.visible = false;
            resId = 202098;
         }
         this._displayer.setIconUrl(URLUtil.getPetRelateIcon(resId),function():void
         {
            _displayer.x = _displayer.y = 0;
         });

         this.setTextColor();
         if(this._info && this._id != 0)
         {
            this._textField.text = "" + this._info.nameT;
            this._levelField.text = "LV." + this._info.level;
            this._textField.visible = true;
            this._levelField.visible = true;
            if(this._info.level == 0)
            {
               this._levelField.text = "LV." + this._info.maxLevel;
            }
            this.setChildIndex(this._levelField,this.numChildren - 1);
            this.setChildIndex(this._textField,this.numChildren - 1);
         }
         else
         {
            this._textField.text = "";
            this._levelField.text = "";
            this._textField.visible = false;
            this._levelField.visible = false;
         }
         DisplayObjectUtil.removeFromParent(this._textField);
         DisplayObjectUtil.removeFromParent(this._levelField);
         this.addChild(this._textField);
         this.addChild(this._levelField);
      }
      
      private function getMoveState() : int
      {
         return this._moveState;
      }
      
      public function moveState() : int
      {
         return this._moveState;
      }
      
      public function setmoveState(state:int) : void
      {
         this._moveState = state;
         if(!this._mc)
         {
            return;
         }
         if(this._moveState == 0)
         {
            this._mc.gotoAndStop(1);
         }
         else
         {
            this._mc.gotoAndStop(1);
         }
      }
      
      public function getInfo() : StarInfo
      {
         return this._info;
      }
      
      public function toPath(tx:int, ty:int) : void
      {
         this.setmoveState(3);
         this._tx = tx;
         this._ty = ty;
      }
      
      public function move() : void
      {
         var p:Point = null;
         if(this._moveState == 3)
         {
            p = this.toPosition(this.x,this.y,this._tx,this._ty,25);
            this.x = p.x;
            this.y = p.y;
            if(Math.abs(this.x - this._tx) < 20 && Math.abs(this.y - this._ty) < 20)
            {
               this.alpha = 0;
               this._moveState = -1;
            }
         }
      }
      
      private function initTip() : void
      {
      }
      
      private function toPosition(sx:Number, sy:Number, tx:Number, ty:Number, speed:uint) : Point
      {
         var p:Point = new Point(sx,sy);
         var p2:Point = new Point(tx,ty);
         var p3:Point = new Point();
         var radian:Number = Math.atan2(p2.y - p.y,p2.x - p.x);
         var angel:Number = radian * 180 / 3.141592653589793;
         var spx:int = int(speed);
         var spy:int = int(speed);
         if(Math.abs(sx - p2.x) <= speed)
         {
            spx = Math.abs(sx - p2.x);
         }
         if(Math.abs(sy - p2.y) <= speed)
         {
            spy = Math.abs(sy - p2.y);
         }
         p3.x = sx + spx * Math.cos(radian);
         p3.y = sy + spy * Math.sin(radian);
         return p3;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function get indexId() : int
      {
         return this._id;
      }

      public function get icon():DisplayObject
      {
         return this._displayer.icon;
      }
      
      public function getMovieClip() : MovieClip
      {
         var m:MovieClip = null;
         var info:StarInfo = StarMagicConfig.getInfoById(this._id);
         if(!info)
         {
            return new dsp();
         }
         if(this._id == 0)
         {
            m = new staricon0();
            m.alpha = 0;
         }
         else if(this._id == 1)
         {
            m = new ssp();
         }
         else if(this._id == 2)
         {
            m = new dsp();
         }
         else if(this._type == 1)
         {
            if(info.buffSwf == 1)
            {
               m = new wg_1();
            }
            else if(info.buffSwf == 2)
            {
               m = new tg_1();
            }
            else if(info.buffSwf == 3)
            {
               m = new wf_1();
            }
            else if(info.buffSwf == 4)
            {
               m = new tf_1();
            }
            else if(info.buffSwf == 5)
            {
               m = new bj_1();
            }
            else if(info.buffSwf == 6)
            {
               m = new mz_1();
            }
            else if(info.buffSwf == 7)
            {
               m = new sb_1();
            }
            else if(info.buffSwf == 8)
            {
               m = new sm_1();
            }
            else if(info.buffSwf == 9)
            {
               m = new pf_1();
            }
         }
         else if(this._type == 2)
         {
            if(info.buffSwf == 1)
            {
               m = new wg_2();
            }
            else if(info.buffSwf == 2)
            {
               m = new tg_2();
            }
            else if(info.buffSwf == 3)
            {
               m = new wf_2();
            }
            else if(info.buffSwf == 4)
            {
               m = new tf_2();
            }
            else if(info.buffSwf == 5)
            {
               m = new bj_2();
            }
            else if(info.buffSwf == 6)
            {
               m = new mz_2();
            }
            else if(info.buffSwf == 7)
            {
               m = new sb_2();
            }
            else if(info.buffSwf == 8)
            {
               m = new sm_2();
            }
            else if(info.buffSwf == 9)
            {
               m = new kb_9();
            }
         }
         else if(this._type == 3)
         {
            if(info.buffSwf == 1)
            {
               m = new wg_3();
            }
            else if(info.buffSwf == 2)
            {
               m = new tg_3();
            }
            else if(info.buffSwf == 3)
            {
               m = new wf_3();
            }
            else if(info.buffSwf == 4)
            {
               m = new tf_3();
            }
            else if(info.buffSwf == 5)
            {
               m = new bj_3();
            }
            else if(info.buffSwf == 6)
            {
               m = new mz_3();
            }
            else if(info.buffSwf == 7)
            {
               m = new sb_3();
            }
            else if(info.buffSwf == 8)
            {
               m = new sm_3();
            }
            else if(info.buffSwf == 9)
            {
               m = new sm_5();
            }
            else if(info.buffSwf == 10)
            {
               m = new sm_6();
            }
         }
         else if(this._type == 4)
         {
            if(info.buffSwf == 1)
            {
               m = new wg_4();
            }
            else if(info.buffSwf == 2)
            {
               m = new tg_4();
            }
            else if(info.buffSwf == 3)
            {
               m = new wf_4();
            }
            else if(info.buffSwf == 4)
            {
               m = new tf_4();
            }
            else if(info.buffSwf == 5)
            {
               m = new bj_4();
            }
            else if(info.buffSwf == 6)
            {
               m = new mz_4();
            }
            else if(info.buffSwf == 7)
            {
               m = new sb_4();
            }
            else if(info.buffSwf == 8)
            {
               m = new sm_4();
            }
            else if(info.buffSwf == 9)
            {
               m = new pf_4();
            }
            else if(info.buffSwf == 100)
            {
               m = new qdzy_4();
            }
            else if(info.buffSwf == 101)
            {
               m = new js_4();
            }
            else if(info.buffSwf == 102)
            {
               m = new qdzy_102();
            }
            else if(info.buffSwf == 103)
            {
               m = new jg_103();
            }
         }
         return m;
      }

      public function getStarItemId():uint
      {
         if(!this._info || this._id == 0)
         {
            return 0;
         }
         var info:StarInfo = StarMagicConfig.getInfoById(this._id);
         var ret:int = (this._info.itemIcon != 0) ? this._info.itemIcon : info.itemIcon;
         return ret;
         /*var result:int = 0;
         if(!info || this._id == 0 || this._id == 1 || this._id == 2)
         {
            result = 0;
         }
         else
         {
            if(info.buffSwf < 100)
            {
               var offset:int;
               if(info.buffSwf == 1)
               {
                  offset = 0;
               }
               else if(info.buffSwf == 2)
               {
                  offset = 1;
               }
               else if(info.buffSwf == 3)
               {
                  offset = 2;
               }
               else if(info.buffSwf == 4)
               {
                  offset = 3;
               }
               else if(info.buffSwf == 5)
               {
                  offset = 4;
               }
               else if(info.buffSwf == 6)
               {
                  offset = 7;
               }
               else if(info.buffSwf == 7)
               {
                  offset = 6;
               }
               else if(info.buffSwf == 8)
               {
                  offset = 8;
               }
               else if(info.buffSwf == 9)
               {
                  offset = 5;
               }
               else if(info.buffSwf == 10)
               {
                  offset = 9;
               }
               result = 202028 + (this._type - 1) + offset * 5;
            }
            else
            {
               if(info.buffSwf == 100)
               {
                  result = 202118;
               }
               else if(info.buffSwf == 101)
               {
                  result = 202104;
               }
               else if(info.buffSwf == 102)
               {
                  result = 202109;
               }
               else if(info.buffSwf == 103)
               {
                  result = 202121;
               }
               else if (info.buffSwf == 114)
               {
                  result = 202001;
               }
            }
         }
         */
      }
   }
}

