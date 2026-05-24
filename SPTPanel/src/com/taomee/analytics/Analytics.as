package com.taomee.analytics
{
   import com.taomee.analytics.info.ErrorInfoBox;
   import com.taomee.analytics.item.ErrorItem;
   import com.taomee.analytics.item.StatisticsItem;
   import flash.display.Stage;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.net.sendToURL;
   import flash.system.Capabilities;
   import flash.system.Security;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   
   public class Analytics
   {
      
      private static var _webAddr:String;
      
      public static var dataBinding:Function;
      
      private static var _stage:Stage;
      
      public static var enabledSubmit:Boolean = true;
      
      private static var _productID:int = 0;
      
      private static var errorObj:Object = {};
      
      private static var errorLimit:Object = {};
      
      private static var statisticObj:Object = {};
      
      private static var statisticLimit:Object = {};
      
      private static var _stats:Stats = new Stats();
      
      public function Analytics()
      {
         super();
      }
      
      private static function checkErrorType(item:ErrorItem) : Boolean
      {
         var errorID:int = item.id;
         if(!errorObj[errorID])
         {
            errorObj[errorID] = 0;
         }
         if(!errorLimit[errorID])
         {
            errorLimit[errorID] = item.submitLimit;
         }
         if(errorObj[errorID] >= errorLimit[errorID])
         {
            return false;
         }
         return true;
      }
      
      public static function hide() : void
      {
         _stats.hide();
      }
      
      public static function recordTagCommand(cmdID:int, tagType:String) : void
      {
         RecordSocketHistory.pushInTagHistory(cmdID,tagType);
      }
      
      public static function init(productID:int, webAddr:String, stage:Stage, _dataBinding:Function = null) : void
      {
         var url:String = URLUitl.reviseURL(webAddr + "/crossdomain.xml");
         Security.loadPolicyFile(url);
         _productID = productID;
         _webAddr = webAddr;
         _stage = stage;
         _stats.start(_stage);
         if(_dataBinding != null)
         {
            dataBinding = _dataBinding;
         }
         else
         {
            dataBinding = function(item:ErrorItem):void
            {
               throw "没有绑定信息收集函数！\n请参考Analytics.dataBinding方法";
            };
         }
      }
      
      private static function checkStatistics(item:StatisticsItem) : Boolean
      {
         var errorID:int = item.data;
         if(!statisticObj[errorID])
         {
            statisticObj[errorID] = 0;
         }
         if(!statisticLimit[errorID])
         {
            statisticLimit[errorID] = item.submitLimit;
         }
         if(statisticObj[errorID] >= statisticLimit[errorID])
         {
            return false;
         }
         return true;
      }
      
      public static function submitErrorInfo(item:ErrorItem, description:String = "") : void
      {
         var info:ErrorInfoBox = null;
         var errstr:String = null;
         var request:URLRequest = null;
         var variables:URLVariables = null;
         var i:String = null;
         var actionHistory:Array = null;
         var lastArr:Array = null;
         var k:int = 0;
         var isLogin:uint = 0;
         var webAdds:Array = null;
         var exBytes:ByteArray = null;
         var tcmd:int = 0;
         if(!enabledSubmit)
         {
            return;
         }
         if(checkErrorType(item))
         {
            if(dataBinding != null)
            {
               info = dataBinding(item);
            }
            if(Boolean(info))
            {
               errstr = new Error("#Analytics#").getStackTrace();
               if(Boolean(errstr))
               {
                  description = description + "\n" + errstr;
               }
               ++errorObj[item.id];
               request = new URLRequest();
               request.method = URLRequestMethod.POST;
               variables = new URLVariables();
               for(i in info)
               {
                  variables[i] = info[i];
               }
               variables.errorDes = item.label;
               variables.errorType = item.id;
               variables.language = Capabilities.language;
               variables.flashVersion = Capabilities.version;
               variables.os = Capabilities.os;
               variables.playerType = Capabilities.playerType;
               variables.clientTime = uint(new Date().time / 1000);
               variables.playerStartTime = getTimer();
               actionHistory = RecordSocketHistory.actionHistory;
               variables.lastAction = actionHistory.length > 0 ? String(actionHistory) : "";
               variables.lastWriteCmd = 0;
               variables.performance = _stats.getEqualityFps();
               variables.performanceMap = ByteUtil.toString(_stats.getFpsBytes());
               lastArr = actionHistory.splice(0);
               for(k = 0; k < lastArr.length; k++)
               {
                  tcmd = int(lastArr[k].split(":")[0]);
                  if(lastArr[k].split("/")[1] == "write")
                  {
                     variables.lastWriteCmd = tcmd;
                  }
                  lastArr[k] = tcmd;
               }
               lastArr = lastArr.reverse();
               try
               {
                  if(lastArr.length >= 3)
                  {
                     variables.lastCmd3 = lastArr[2];
                     variables.lastCmd2 = lastArr[1];
                     variables.lastCmd1 = lastArr[0];
                     isLogin = 1;
                  }
                  else if(lastArr.length == 2)
                  {
                     variables.lastCmd3 = 0;
                     variables.lastCmd2 = lastArr[1];
                     variables.lastCmd1 = lastArr[0];
                     isLogin = 1;
                  }
                  else if(lastArr.length == 1)
                  {
                     variables.lastCmd3 = 0;
                     variables.lastCmd2 = 0;
                     variables.lastCmd1 = lastArr[0];
                     isLogin = 1;
                  }
                  else
                  {
                     variables.lastCmd3 = 0;
                     variables.lastCmd2 = 0;
                     variables.lastCmd1 = 0;
                     isLogin = 1;
                  }
               }
               catch(e:Error)
               {
               }
               variables.isLogin = isLogin;
               variables.isDebugger = Capabilities.isDebugger ? 1 : 0;
               variables.isAutoReport = 1;
               variables.photo = "";
               webAdds = String(_stage.loaderInfo.url.split(".swf")[0]).split("/");
               webAdds.pop();
               variables.webServer = webAdds.join("/");
               variables.webServer = String(variables.webServer).split("|").join("/");
               exBytes = new ByteArray();
               exBytes.writeUTFBytes(description);
               exBytes.compress();
               exBytes.position = 0;
               variables.ex_data = ByteUtil.toString(exBytes);
               variables.mem_use = ByteUtil.toString(_stats.getMemoryBytes());
               request.data = variables;
               request.url = URLUitl.reviseURL(_webAddr + "/error_report/report.php?gameid=" + _productID);
               try
               {
                  sendToURL(request);
               }
               catch(error:Error)
               {
                  trace("错误报告提交失败！！");
               }
               trace(request.url);
            }
         }
      }
      
      public static function reset() : void
      {
         RecordSocketHistory.actionHistory.length = 0;
      }
      
      public static function recordCommand(cmdID:int, type:int) : void
      {
         if(type == 1)
         {
            RecordSocketHistory.pushInActionHistory(cmdID,RecordSocketHistory.ACTION_WRITE);
         }
         else if(type == 0)
         {
            RecordSocketHistory.pushInActionHistory(cmdID,RecordSocketHistory.ACTION_READ);
         }
      }
      
      public static function show(x:Number = 0, y:Number = 0) : void
      {
         _stats.x = x;
         _stats.y = y;
         _stats.show(_stage);
      }
      
      public function submitStatisticsInfo(item:StatisticsItem, value:Number) : void
      {
         var request:URLRequest = null;
         var variables:URLVariables = null;
         if(!enabledSubmit)
         {
            return;
         }
         if(checkStatistics(item))
         {
            ++statisticObj[item.data];
            request = new URLRequest();
            request.method = URLRequestMethod.POST;
            variables = new URLVariables();
            variables.typeDes = item.label;
            variables.type = item.data;
            variables.value = value;
            request.data = variables;
            request.url = URLUitl.reviseURL(_webAddr + "/error_report/statistics.php?gameid=" + _productID);
            try
            {
               sendToURL(request);
            }
            catch(error:Error)
            {
               trace("错误报告提交失败！！");
            }
            trace(request.url);
         }
      }
   }
}

