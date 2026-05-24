package org.taomee.utils
{
   public class Delegate
   {
      
      public function Delegate()
      {
         super();
      }
      
      public static function create(func:Function, ... args) : Function
      {
         var f:Function = function():*
         {
            var func:Function = arguments.callee.func;
            var pat:Array = arguments.concat(args);
            return func.apply(null,pat);
         };
         f["func"] = func;
         return f;
      }
   }
}

