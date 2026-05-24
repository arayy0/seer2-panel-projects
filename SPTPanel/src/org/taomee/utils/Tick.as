package org.taomee.utils
{
   import flash.display.Shape;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class Tick
   {
      
      private static var _instance:Tick;
      
      public static var timeScaleAll:Number = 1;
      
      private static var _o:Shape = new Shape();
      
      private var _running:Boolean;
      
      private var _renderoutLength:int;
      
      private var _nextTime:Number;
      
      private var _timeoutMap:Dictionary = new Dictionary();
      
      private var _renderoutMap:Dictionary = new Dictionary();
      
      private var _valueTime:uint;
      
      private var _renderMap:Dictionary = new Dictionary();
      
      private var _timeoutLength:int;
      
      private var _renderLength:int;
      
      public var timeScale:Number = 1;
      
      private var _prevTime:Number;
      
      public function Tick()
      {
         super();
      }
      
      public static function get instance() : Tick
      {
         if(_instance == null)
         {
            _instance = new Tick();
            _instance.start();
         }
         return _instance;
      }
      
      public function removeRender(fun:Function) : void
      {
         if(fun in _renderMap)
         {
            delete _renderMap[fun];
            --_renderLength;
         }
      }
      
      public function stop() : void
      {
         _o.removeEventListener(Event.ENTER_FRAME,onEnter);
      }
      
      public function removeTimeout(fun:Function) : void
      {
         if(fun in _timeoutMap)
         {
            delete _timeoutMap[fun];
            --_timeoutLength;
         }
      }
      
      public function hasRenderAndOut(fun:Function) : Boolean
      {
         return fun in _renderoutMap;
      }
      
      public function addTimeout(delay:uint, fun:Function) : void
      {
         if(fun in _timeoutMap == false)
         {
            _timeoutMap[fun] = new TimeoutInfo(delay);
            ++_timeoutLength;
         }
      }
      
      public function removeRenderAndOut(fun:Function) : void
      {
         if(fun in _renderoutMap)
         {
            delete _renderoutMap[fun];
            --_renderoutLength;
         }
      }
      
      public function hasTimeout(fun:Function) : Boolean
      {
         return fun in _timeoutMap;
      }
      
      private function onRender() : void
      {
         var info:TimeoutInfo = null;
         var fun:* = undefined;
         if(_renderLength > 0)
         {
            for(fun in _renderMap)
            {
               info = _renderMap[fun];
               if(info.delay > 0)
               {
                  if(info.count >= info.delay)
                  {
                     fun(info.count);
                     info.count = 0;
                  }
               }
               else
               {
                  fun(_valueTime);
               }
               info.count += _valueTime;
            }
         }
      }
      
      public function addRender(fun:Function, interval:int = 0) : void
      {
         if(fun in _renderMap == false)
         {
            _renderMap[fun] = new TimeoutInfo(interval);
            ++_renderLength;
         }
      }
      
      public function dispose() : void
      {
         stop();
         _renderMap = null;
         _timeoutMap = null;
         _renderoutMap = null;
      }
      
      public function start() : void
      {
         _o.addEventListener(Event.ENTER_FRAME,onEnter);
      }
      
      private function onTimeout() : void
      {
         var info:TimeoutInfo = null;
         var fun:* = undefined;
         if(_timeoutLength > 0)
         {
            for(fun in _timeoutMap)
            {
               info = _timeoutMap[fun];
               if(info.count >= info.delay)
               {
                  delete _timeoutMap[fun];
                  --_timeoutLength;
                  fun();
               }
               else
               {
                  info.count += _valueTime;
               }
            }
         }
      }
      
      private function onRenderAndOut() : void
      {
         var info:TimeoutInfo = null;
         var fun:* = undefined;
         if(_renderoutLength > 0)
         {
            for(fun in _renderoutMap)
            {
               info = _renderoutMap[fun];
               if(info.count >= info.delay)
               {
                  delete _renderoutMap[fun];
                  --_renderoutLength;
                  fun(true);
               }
               else
               {
                  fun(false);
                  info.count += _valueTime;
               }
            }
         }
      }
      
      public function addRenderAndOut(duration:uint, fun:Function) : void
      {
         if(fun in _renderoutMap == false)
         {
            _renderoutMap[fun] = new TimeoutInfo(duration);
            ++_renderoutLength;
         }
      }
      
      public function hasRender(fun:Function) : Boolean
      {
         return fun in _renderMap;
      }
      
      private function onEnter(event:Event) : void
      {
         _nextTime = new Date().getTime();
         if(_prevTime > 0)
         {
            _valueTime = (_nextTime - _prevTime) * timeScale * timeScaleAll;
            onRender();
            onTimeout();
            onRenderAndOut();
         }
         _prevTime = _nextTime;
      }
   }
}

class TimeoutInfo
{
   
   public var delay:uint;
   
   public var count:uint;
   
   public function TimeoutInfo(delay:uint)
   {
      super();
      this.delay = delay;
   }
}
