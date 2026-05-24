package org.taomee.ds
{
   import flash.utils.Dictionary;
   
   public class HashSet implements ICollection
   {
      
      private var _length:int;
      
      private var _weakKeys:Boolean;
      
      private var _content:Dictionary;
      
      public function HashSet(weakKeys:Boolean = false)
      {
         super();
         _weakKeys = weakKeys;
         _content = new Dictionary(weakKeys);
         _length = 0;
      }
      
      public function addAll(arr:Array) : void
      {
         var i:* = undefined;
         for each(i in arr)
         {
            add(i);
         }
      }
      
      public function add(o:*) : void
      {
         if(o === undefined)
         {
            return;
         }
         if(!(o in _content))
         {
            ++_length;
         }
         _content[o] = o;
      }
      
      public function containsAll(arr:Array) : Boolean
      {
         var i:int = 0;
         var len:int = int(arr.length);
         for(i = 0; i < len; i++)
         {
            if(!(arr[i] in _content))
            {
               return false;
            }
         }
         return true;
      }
      
      public function isEmpty() : Boolean
      {
         return _length == 0;
      }
      
      public function remove(o:*) : Boolean
      {
         if(o in _content)
         {
            delete _content[o];
            --_length;
            return true;
         }
         return false;
      }
      
      public function get length() : int
      {
         return _length;
      }
      
      public function every(func:Function) : Boolean
      {
         var i:* = undefined;
         for each(i in _content)
         {
            if(!func(i))
            {
               return false;
            }
         }
         return true;
      }
      
      public function clone() : HashSet
      {
         var o:* = undefined;
         var csd:HashSet = new HashSet(_weakKeys);
         for each(o in _content)
         {
            csd.add(o);
         }
         return csd;
      }
      
      public function forEach(func:Function) : void
      {
         var i:* = undefined;
         for each(i in _content)
         {
            func(i);
         }
      }
      
      public function some(func:Function) : Boolean
      {
         var i:* = undefined;
         for each(i in _content)
         {
            if(func(i))
            {
               return true;
            }
         }
         return false;
      }
      
      public function clear() : void
      {
         _content = new Dictionary(_weakKeys);
         _length = 0;
      }
      
      public function removeAll(arr:Array) : void
      {
         var i:* = undefined;
         for each(i in arr)
         {
            remove(i);
         }
      }
      
      public function toArray() : Array
      {
         var i:* = undefined;
         var arr:Array = new Array(_length);
         var index:int = 0;
         for each(i in _content)
         {
            arr[index] = i;
            index++;
         }
         return arr;
      }
      
      public function contains(o:*) : Boolean
      {
         return o in _content;
      }
   }
}

