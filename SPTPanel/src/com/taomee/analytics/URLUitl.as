package com.taomee.analytics
{
   internal class URLUitl
   {
      
      public function URLUitl()
      {
         super();
      }
      
      public static function reviseURL(url:String) : String
      {
         url = String(url).split("://").join(":||");
         url = String(url).split("//").join("/");
         return String(url).split(":||").join("://");
      }
   }
}

