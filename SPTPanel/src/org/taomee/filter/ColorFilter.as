package org.taomee.filter
{
   import flash.display.DisplayObject;
   import flash.filters.BitmapFilter;
   import flash.filters.ColorMatrixFilter;
   
   public class ColorFilter
   {
      
      private static const RED:Number = 0.3086;
      
      private static const GREEN:Number = 0.6094;
      
      private static const BLUE:Number = 0.082;
      
      private static const DELTA_INDEX:Array = [0,0.01,0.02,0.04,0.05,0.06,0.07,0.08,0.1,0.11,0.12,0.14,0.15,0.16,0.17,0.18,0.2,0.21,0.22,0.24,0.25,0.27,0.28,0.3,0.32,0.34,0.36,0.38,0.4,0.42,0.44,0.46,0.48,0.5,0.53,0.56,0.59,0.62,0.65,0.68,0.71,0.74,0.77,0.8,0.83,0.86,0.89,0.92,0.95,0.98,1,1.06,1.12,1.18,1.24,1.3,1.36,1.42,1.48,1.54,1.6,1.66,1.72,1.78,1.84,1.9,1.96,2,2.12,2.25,2.37,2.5,2.62,2.75,2.87,3,3.2,3.4,3.6,3.8,4,4.3,4.7,4.9,5,5.5,6,6.5,6.8,7,7.3,7.5,7.8,8,8.4,8.7,9,9.4,9.6,9.8,10];
      
      public function ColorFilter()
      {
         super();
      }
      
      public static function setContrast(obj:DisplayObject, offset:Number) : void
      {
         var x:Number = NaN;
         offset = Number(ColorFilter.cleanValue(offset,100));
         if(offset == 0 || isNaN(offset))
         {
            return;
         }
         if(offset < 0)
         {
            x = 127 + offset / 100 * 127;
         }
         else
         {
            x = offset % 1;
            if(x == 0)
            {
               x = Number(DELTA_INDEX[offset]);
            }
            else
            {
               x = DELTA_INDEX[offset << 0] * (1 - x) + DELTA_INDEX[(offset << 0) + 1] * x;
            }
            x = x * 127 + 127;
         }
         var filter:ColorMatrixFilter = new ColorMatrixFilter([x / 127,0,0,0,0.5 * (127 - x),0,x / 127,0,0,0.5 * (127 - x),0,0,x / 127,0,0.5 * (127 - x),0,0,0,1,0,0,0,0,0,1]);
         setDisplayObject(obj,filter);
      }
      
      public static function setGrayscale(obj:DisplayObject) : void
      {
         var filter:ColorMatrixFilter = new ColorMatrixFilter([ColorFilter.RED,ColorFilter.GREEN,ColorFilter.BLUE,0,0,ColorFilter.RED,ColorFilter.GREEN,ColorFilter.BLUE,0,0,ColorFilter.RED,ColorFilter.GREEN,ColorFilter.BLUE,0,0,0,0,0,1,0]);
         setDisplayObject(obj,filter);
      }
      
      private static function cleanValue(p_val:Number, p_limit:Number) : Number
      {
         return Math.min(p_limit,Math.max(-p_limit,p_val));
      }
      
      public static function setBrightness(obj:DisplayObject, offset:Number) : void
      {
         offset = Number(ColorFilter.cleanValue(offset,100));
         if(offset == 0 || isNaN(offset))
         {
            return;
         }
         var filter:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,offset,0,1,0,0,offset,0,0,1,0,offset,0,0,0,1,0,0,0,0,0,1]);
         setDisplayObject(obj,filter);
      }
      
      public static function setHue(obj:DisplayObject, offset:Number) : void
      {
         offset = ColorFilter.cleanValue(offset,180) / 180 * Math.PI;
         if(offset == 0 || isNaN(offset))
         {
            return;
         }
         var cosVal:Number = Math.cos(offset);
         var sinVal:Number = Math.sin(offset);
         var lumR:Number = 0.213;
         var lumG:Number = 0.715;
         var lumB:Number = 0.072;
         var filter:ColorMatrixFilter = new ColorMatrixFilter([lumR + cosVal * (1 - lumR) + sinVal * -lumR,lumG + cosVal * -lumG + sinVal * -lumG,lumB + cosVal * -lumB + sinVal * (1 - lumB),0,0,lumR + cosVal * -lumR + sinVal * 0.143,lumG + cosVal * (1 - lumG) + sinVal * 0.14,lumB + cosVal * -lumB + sinVal * -0.283,0,0,lumR + cosVal * -lumR + sinVal * -(1 - lumR),lumG + cosVal * -lumG + sinVal * lumG,lumB + cosVal * (1 - lumB) + sinVal * lumB,0,0,0,0,0,1,0,0,0,0,0,1]);
         setDisplayObject(obj,filter);
      }
      
      public static function setInvert(obj:DisplayObject) : void
      {
         var filter:ColorMatrixFilter = new ColorMatrixFilter([-1,0,0,0,255,0,-1,0,0,255,0,0,-1,0,255,0,0,0,1,0]);
         setDisplayObject(obj,filter);
      }
      
      public static function setSaturation(obj:DisplayObject, offset:Number) : void
      {
         offset = Number(ColorFilter.cleanValue(offset,100));
         if(offset == 0 || isNaN(offset))
         {
            return;
         }
         var x:Number = 1 + (offset > 0 ? 3 * offset / 100 : offset / 100);
         var filter:ColorMatrixFilter = new ColorMatrixFilter([ColorFilter.RED * (1 - x) + x,ColorFilter.GREEN * (1 - x),ColorFilter.BLUE * (1 - x),0,0,ColorFilter.RED * (1 - x),ColorFilter.GREEN * (1 - x) + x,ColorFilter.BLUE * (1 - x),0,0,ColorFilter.RED * (1 - x),ColorFilter.GREEN * (1 - x),ColorFilter.BLUE * (1 - x) + x,0,0,0,0,0,1,0,0,0,0,0,1]);
         setDisplayObject(obj,filter);
      }
      
      private static function setDisplayObject(obj:DisplayObject, f:BitmapFilter) : void
      {
         var filters:Array = obj.filters;
         filters.push(f);
         obj.filters = filters;
      }
   }
}

