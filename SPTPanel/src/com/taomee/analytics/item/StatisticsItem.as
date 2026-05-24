package com.taomee.analytics.item
{
   public class StatisticsItem
   {
      
      private var _submitLimit:int;
      
      private var _data:int;
      
      private var _label:String;
      
      public function StatisticsItem(label:String, data:int, submitLimit:int = 1)
      {
         super();
         _label = label;
         _data = data;
         _submitLimit = submitLimit;
      }
      
      public function get submitLimit() : int
      {
         return _submitLimit;
      }
      
      public function set submitLimit(value:int) : void
      {
         _submitLimit = value;
      }
      
      public function get data() : int
      {
         return _data;
      }
      
      public function set label(value:String) : void
      {
         _label = value;
      }
      
      public function set data(value:int) : void
      {
         _data = value;
      }
      
      public function get label() : String
      {
         return _label;
      }
   }
}

