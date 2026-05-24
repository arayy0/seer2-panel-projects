package org.taomee.bean
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   
   public class BeanManager
   {
      
      private static var _currentList:Array;
      
      private static var _currentID:String;
      
      private static var _beanMap:Dictionary;
      
      private static var _map:Object;
      
      private static var _playering:Boolean;
      
      private static const ID_NODE:String = "id";
      
      private static const CLASS_NODE:String = "class";
      
      private static var _ed:EventDispatcher = new EventDispatcher();
      
      public function BeanManager()
      {
         super();
      }
      
      public static function config(xml:XML) : void
      {
         var group:XML = null;
         var nodeArray:Array = null;
         var nodeList:XMLList = null;
         var node:XML = null;
         var info:BeanNodeInfo = null;
         _map = {};
         var groupList:XMLList = xml.elements();
         for each(group in groupList)
         {
            nodeArray = [];
            nodeList = group.elements();
            for each(node in nodeList)
            {
               info = new BeanNodeInfo();
               info.id = node.attribute(ID_NODE).toString();
               info.className = node.attribute(CLASS_NODE).toString();
               nodeArray.push(info);
            }
            _map[String(group.@id)] = nodeArray;
         }
      }
      
      public static function start(id:String) : void
      {
         if(_playering)
         {
            throw new Error("processoring");
         }
         _beanMap = new Dictionary(true);
         if(id in _map)
         {
            _playering = true;
            _currentID = id;
            dispatchEvent(new BeanEvent(BeanEvent.OPEN,_currentID));
            _currentList = _map[_currentID];
            initClasses();
            return;
         }
         throw new Error("id error");
      }
      
      public static function getBeanInstance(name:String) : *
      {
         return _beanMap[name];
      }
      
      internal static function initClasses() : void
      {
         var info:BeanNodeInfo = null;
         var cls:Class = null;
         var instance:* = undefined;
         if(_currentList.length > 0)
         {
            info = _currentList.shift();
            cls = getDefinitionByName(info.className) as Class;
            instance = new cls();
            _beanMap[info.id] = instance;
            trace(instance,"实例化完成");
            instance.start();
         }
         else
         {
            _currentList = null;
            _playering = false;
            dispatchEvent(new BeanEvent(BeanEvent.COMPLETE,_currentID));
         }
      }
      
      public static function addEventListener(type:String, listener:Function) : void
      {
         _ed.addEventListener(type,listener);
      }
      
      public static function removeEventListener(type:String, listener:Function) : void
      {
         _ed.removeEventListener(type,listener);
      }
      
      public static function dispatchEvent(e:Event) : void
      {
         if(hasEventListener(e.type))
         {
            _ed.dispatchEvent(e);
         }
      }
      
      public static function hasEventListener(type:String) : Boolean
      {
         return _ed.hasEventListener(type);
      }
      
      public static function willTrigger(type:String) : Boolean
      {
         return _ed.willTrigger(type);
      }
   }
}

