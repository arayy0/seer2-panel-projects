package org.taomee.bean
{
   import flash.events.Event;
   import flash.events.ProgressEvent;
   
   public class BeanEvent extends Event
   {
      
      public static const OPEN:String = Event.OPEN;
      
      public static const COMPLETE:String = Event.COMPLETE;
      
      public static const PROGRESS:String = ProgressEvent.PROGRESS;
      
      private var _id:String;
      
      public function BeanEvent(type:String, id:String)
      {
         super(type);
         this._id = id;
      }
      
      public function get id() : String
      {
         return this._id;
      }
   }
}

