package com.taomee.analytics.item
{
   public class ErrorItem
   {
      
      private var _submitLimit:int;
      
      private var _label:String;
      
      private var _id:int;
      
      public function ErrorItem(id:int, label:String, submitLimit:int = 1)
      {
         super();
         _id = id;
         _label = label;
         _submitLimit = submitLimit;
      }
      
      public function get submitLimit() : int
      {
         return _submitLimit;
      }
      
      public function get label() : String
      {
         return _label;
      }
      
      public function get id() : int
      {
         return _id;
      }
   }
}

