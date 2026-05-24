package org.taomee.utils
{
   import flash.display.Shape;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class InvalidateCallback
   {
      
      private static var _mc:Shape = new Shape();
      
      private static var _map:Dictionary = new Dictionary();
      
      public function InvalidateCallback()
      {
         super();
      }
      
      private static function onEnterFrame(event:Event) : void
      {
         var args:Object = null;
         var f:* = undefined;
         _mc.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
         for(f in _map)
         {
            args = _map[f];
            if(Boolean(args))
            {
               f(args);
            }
            else
            {
               f();
            }
         }
         _map = new Dictionary();
      }
      
      public static function removeFunc(f:Function) : void
      {
         if(f in _map)
         {
            delete _map[f];
         }
      }
      
      public static function addFunc(f:Function, args:Object = null) : void
      {
         _map[f] = args;
         _mc.addEventListener(Event.ENTER_FRAME,onEnterFrame);
      }
   }
}

