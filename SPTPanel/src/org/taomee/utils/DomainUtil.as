package org.taomee.utils
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.media.Sound;
   import flash.system.ApplicationDomain;
   import flash.utils.ByteArray;
   import flash.utils.getDefinitionByName;
   
   public class DomainUtil
   {
      
      public function DomainUtil()
      {
         super();
      }
      
      public static function getSimpleButton(name:String, domain:ApplicationDomain) : SimpleButton
      {
         var o:DisplayObject = getDisplayObject(name,domain);
         return o == null ? null : o as SimpleButton;
      }
      
      public static function getDisplayObject(name:String, domain:ApplicationDomain) : DisplayObject
      {
         var classReference:Class = getClass(name,domain);
         if(classReference == null)
         {
            return null;
         }
         try
         {
            return new classReference() as DisplayObject;
         }
         catch(e:Error)
         {
            trace("DomainUtil getDisplayObject error:" + e.toString());
            return null;
         }
      }
      
      public static function getClass(name:String, domain:ApplicationDomain) : Class
      {
         if(domain == null)
         {
            trace("DomainUtil getClass domain=null");
            return null;
         }
         if(domain.hasDefinition(name))
         {
            return domain.getDefinition(name) as Class;
         }
         trace("DomainUtil getClass not hasDefinition:" + name);
         return null;
      }
      
      public static function getCurrentDomainClass(name:String) : Class
      {
         var classReference:Class = null;
         try
         {
            classReference = getDefinitionByName(name) as Class;
         }
         catch(e:Error)
         {
            trace("DomainUtil getCurrentDomainClass " + name + "error" + e.message);
            return null;
         }
         return classReference;
      }
      
      public static function getSound(name:String, domain:ApplicationDomain) : Sound
      {
         var classReference:Class = getClass(name,domain);
         if(Boolean(classReference))
         {
            try
            {
               return new classReference() as Sound;
            }
            catch(e:Error)
            {
               trace("DomainUtil getSound error:" + e.toString());
            }
         }
         return null;
      }
      
      public static function getMovieClip(name:String, domain:ApplicationDomain) : MovieClip
      {
         var o:DisplayObject = getDisplayObject(name,domain);
         return o == null ? null : o as MovieClip;
      }
      
      public static function getSprite(name:String, domain:ApplicationDomain) : Sprite
      {
         var o:DisplayObject = getDisplayObject(name,domain);
         return o == null ? null : o as Sprite;
      }
      
      public static function getByteArray(name:String, domain:ApplicationDomain) : ByteArray
      {
         var classReference:Class = getClass(name,domain);
         if(classReference == null)
         {
            return null;
         }
         try
         {
            return new classReference() as ByteArray;
         }
         catch(e:Error)
         {
            trace("DomainUtil getByteArray error:" + e.toString());
            return null;
         }
      }
      
      public static function getBitmapData(name:String, domain:ApplicationDomain) : BitmapData
      {
         var classReference:Class = getClass(name,domain);
         if(Boolean(classReference))
         {
            try
            {
               return new classReference(0,0) as BitmapData;
            }
            catch(e:Error)
            {
               trace("DomainUtil getBitmapData error:" + e.toString());
            }
         }
         return null;
      }
   }
}

