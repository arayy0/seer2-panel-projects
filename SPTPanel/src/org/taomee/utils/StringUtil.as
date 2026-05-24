package org.taomee.utils
{
   import flash.utils.ByteArray;
   
   public class StringUtil
   {
      
      private static const HEX_Head:String = "0x";
      
      private static const DOT:String = ".";
      
      public function StringUtil()
      {
         super();
      }
      
      public static function uintToIp(v:uint) : String
      {
         var str:String = v.toString(16);
         var ip1:String = uint(HEX_Head + str.slice(0,2)).toString();
         var ip2:String = uint(HEX_Head + str.slice(2,4)).toString();
         var ip3:String = uint(HEX_Head + str.slice(4,6)).toString();
         var ip4:String = uint(HEX_Head + str.slice(6)).toString();
         return ip1 + DOT + ip2 + DOT + ip3 + DOT + ip4;
      }
      
      public static function remove(input:String, remove:String) : String
      {
         return StringUtil.replace(input,remove,"");
      }
      
      public static function isWhitespace(character:String) : Boolean
      {
         switch(character)
         {
            case " ":
            case "\t":
            case "\r":
            case "\n":
            case "\f":
               return true;
            default:
               return false;
         }
      }
      
      public static function ipToBytes(i:String, endian:String = null) : ByteArray
      {
         var item:String = null;
         var arr:Array = i.split(".");
         var bytes:ByteArray = new ByteArray();
         if(endian != null && endian != "")
         {
            bytes.endian = endian;
         }
         for each(item in arr)
         {
            bytes.writeByte(uint(item));
         }
         return bytes;
      }
      
      public static function beginsWith(input:String, prefix:String) : Boolean
      {
         return prefix == input.substring(0,prefix.length);
      }
      
      public static function isDoubleChar(char:String) : Boolean
      {
         if(char == null)
         {
            return false;
         }
         char = trim(char);
         var pattern:RegExp = /^[^\x00-\xff]+$/;
         var result:Object = pattern.exec(char);
         if(result == null)
         {
            return false;
         }
         return true;
      }
      
      public static function isNumber(char:String) : Boolean
      {
         if(char == null)
         {
            return false;
         }
         return !isNaN(Number(char));
      }
      
      public static function renewZero(str:String, len:int) : String
      {
         var i:int = 0;
         var bul:String = "";
         var strLen:int = str.length;
         if(strLen < len)
         {
            for(i = 0; i < len - strLen; i++)
            {
               bul += "0";
            }
            return bul + str;
         }
         return str;
      }
      
      public static function leftTrim(char:String) : String
      {
         if(char == null)
         {
            return "";
         }
         var pattern:RegExp = /^\s*/;
         return char.replace(pattern,"");
      }
      
      public static function isEmail(char:String) : Boolean
      {
         if(char == null)
         {
            return false;
         }
         char = trim(char);
         var pattern:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
         var result:Object = pattern.exec(char);
         if(result == null)
         {
            return false;
         }
         return true;
      }
      
      public static function isDouble(char:String) : Boolean
      {
         char = trim(char);
         var pattern:RegExp = /^[-\+]?\d+(\.\d+)?$/;
         var result:Object = pattern.exec(char);
         if(result == null)
         {
            return false;
         }
         return true;
      }
      
      public static function endsWith(input:String, suffix:String) : Boolean
      {
         return suffix == input.substring(input.length - suffix.length);
      }
      
      public static function utf16to8(char:String) : String
      {
         var c:int = 0;
         var out:Array = new Array();
         var len:uint = uint(char.length);
         for(var i:uint = 0; i < len; i++)
         {
            c = int(char.charCodeAt(i));
            if(c >= 1 && c <= 127)
            {
               out[i] = char.charAt(i);
            }
            else if(c > 2047)
            {
               out[i] = String.fromCharCode(0xE0 | c >> 12 & 0x0F,0x80 | c >> 6 & 0x3F,0x80 | c >> 0 & 0x3F);
            }
            else
            {
               out[i] = String.fromCharCode(0xC0 | c >> 6 & 0x1F,0x80 | c >> 0 & 0x3F);
            }
         }
         return out.join("");
      }
      
      public static function isChinese(char:String) : Boolean
      {
         if(char == null)
         {
            return false;
         }
         char = trim(char);
         var pattern:RegExp = /^[Α-￥]+$/;
         var result:Object = pattern.exec(char);
         if(result == null)
         {
            return false;
         }
         return true;
      }
      
      public static function timeFormat(value:int, sm:String = "-") : String
      {
         var t:Date = new Date(value * 1000);
         return t.getFullYear().toString() + sm + (t.getMonth() + 1).toString() + sm + t.getDate().toString();
      }
      
      public static function rightTrim(char:String) : String
      {
         if(char == null)
         {
            return "";
         }
         var pattern:RegExp = /\s*$/;
         return char.replace(pattern,"");
      }
      
      public static function isEnglish(char:String) : Boolean
      {
         if(char == null)
         {
            return false;
         }
         char = trim(char);
         var pattern:RegExp = /^[A-Za-z]+$/;
         var result:Object = pattern.exec(char);
         if(result == null)
         {
            return false;
         }
         return true;
      }
      
      public static function stringHasValue(s:String) : Boolean
      {
         return s != null && s.length > 0;
      }
      
      public static function stopwatchFormat(value:int) : String
      {
         var minute:int = value / 60;
         var second:int = value % 60;
         var strM:String = minute < 10 ? "0" + minute.toString() : minute.toString();
         var strS:String = second < 10 ? "0" + second.toString() : second.toString();
         return strM + ":" + strS;
      }
      
      public static function isURL(char:String) : Boolean
      {
         if(char == null)
         {
            return false;
         }
         char = trim(char).toLowerCase();
         var pattern:RegExp = /^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/;
         var result:Object = pattern.exec(char);
         if(result == null)
         {
            return false;
         }
         return true;
      }
      
      public static function hasChineseChar(char:String) : Boolean
      {
         if(char == null)
         {
            return false;
         }
         char = trim(char);
         var pattern:RegExp = /[^\x00-\xff]/;
         var result:Object = pattern.exec(char);
         if(result == null)
         {
            return false;
         }
         return true;
      }
      
      public static function stringsAreEqual(s1:String, s2:String, caseSensitive:Boolean) : Boolean
      {
         if(caseSensitive)
         {
            return s1 == s2;
         }
         return s1.toUpperCase() == s2.toUpperCase();
      }
      
      public static function utf8to16(char:String) : String
      {
         var c:int = 0;
         var char1:int = 0;
         var char2:int = 0;
         var char3:int = 0;
         var out:Array = new Array();
         var len:uint = uint(char.length);
         var i:uint = 0;
         while(i < len)
         {
            c = int(char.charCodeAt(i++));
            switch(c >> 4)
            {
               case 0:
               case 1:
               case 2:
               case 3:
               case 4:
               case 5:
               case 6:
               case 7:
                  out[out.length] = char.charAt(i - 1);
                  break;
               case 12:
               case 13:
                  char1 = int(char.charCodeAt(i++));
                  out[out.length] = String.fromCharCode((c & 0x1F) << 6 | char1 & 0x3F);
                  break;
               case 14:
                  char2 = int(char.charCodeAt(i++));
                  char3 = int(char.charCodeAt(i++));
                  out[out.length] = String.fromCharCode((c & 0x0F) << 12 | (char2 & 0x3F) << 6 | (char3 & 0x3F) << 0);
            }
         }
         return out.join("");
      }
      
      public static function replace(input:String, replace:String, replaceWith:String) : String
      {
         return input.split(replace).join(replaceWith);
      }
      
      public static function toByteArray(s:String, length:uint) : ByteArray
      {
         var bytes:ByteArray = new ByteArray();
         bytes.writeUTFBytes(s);
         bytes.length = length;
         bytes.position = 0;
         return bytes;
      }
      
      public static function substituteStr(str:String, ... rest) : String
      {
         var args:Array = null;
         if(str == null)
         {
            return "";
         }
         var len:uint = uint(rest.length);
         if(len == 1 && rest[0] is Array)
         {
            args = rest[0] as Array;
            len = args.length;
         }
         else
         {
            args = rest;
         }
         for(var i:int = 0; i < len; i++)
         {
            str = str.replace(new RegExp("\\{" + i + "\\}","g"),args[i]);
         }
         return str;
      }
      
      public static function hasAccountChar(char:String, len:uint = 15) : Boolean
      {
         if(char == null)
         {
            return false;
         }
         if(len < 10)
         {
            len = 15;
         }
         char = trim(char);
         var pattern:RegExp = new RegExp("^[a-zA-Z0-9][a-zA-Z0-9_-]{0," + len + "}$","");
         var result:Object = pattern.exec(char);
         if(result == null)
         {
            return false;
         }
         return true;
      }
      
      public static function trim(char:String) : String
      {
         if(char == null)
         {
            return "";
         }
         return rightTrim(leftTrim(char));
      }
      
      public static function isInteger(char:String) : Boolean
      {
         if(char == null)
         {
            return false;
         }
         char = trim(char);
         var pattern:RegExp = /^[-\+]?\d+$/;
         var result:Object = pattern.exec(char);
         if(result == null)
         {
            return false;
         }
         return true;
      }
      
      public static function ipToUint(i:String) : uint
      {
         var item:String = null;
         var arr:Array = i.split(DOT);
         var str:String = HEX_Head;
         for each(item in arr)
         {
            str += uint(item).toString(16);
         }
         return uint(str);
      }
      
      public static function hexToIp(a:uint) : String
      {
         var bytes:ByteArray = new ByteArray();
         bytes.writeUnsignedInt(a);
         bytes.position = 0;
         var str:String = "";
         for(var i:uint = 0; i < 4; i++)
         {
            str += bytes.readUnsignedByte().toString() + DOT;
         }
         return str.substr(0,str.length - 1);
      }
   }
}

