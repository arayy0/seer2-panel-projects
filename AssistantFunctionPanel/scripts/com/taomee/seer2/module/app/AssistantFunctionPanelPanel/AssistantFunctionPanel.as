package com.taomee.seer2.module.app.AssistantFunctionPanelPanel
{
import com.taomee.seer2.app.net.Command;
import com.taomee.seer2.app.net.CommandSet;
import com.taomee.seer2.app.net.Connection;
import com.taomee.seer2.app.popup.AlertManager;
import com.taomee.seer2.app.swap.info.SwapInfo;
import com.taomee.seer2.core.module.Module;
import com.taomee.seer2.core.net.MessageEvent;
import com.taomee.seer2.core.net.LittleEndianByteArray;
import com.taomee.seer2.core.ui.toolTip.TooltipManager;
import com.taomee.seer2.module.app.AssistantFunctionUI;
import com.taomee.seer2.core.utils.DisplayObjectUtil;

import flash.display.SimpleButton;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.text.TextField;
import flash.utils.Timer;
import flash.utils.IDataInput;

public class AssistantFunctionPanel extends Module
   {
      
      private var _swapList:Vector.<SimpleButton>;

      private var _Times:int = 0;

      private var _targetTimes:int = 0;

      private var _sendType: uint = 0;

      private var _command0:Command;

      private var _command1:Command;

      private var _command2:Command;

      private var _command3:Command;

      private var _paramArray0:LittleEndianByteArray;

      private var _paramArray1:LittleEndianByteArray;

      private var _paramArray2:LittleEndianByteArray;

      private var _paramArray3:LittleEndianByteArray;

      private var _endFunc:Function;

      private var _errFunc:Function;

      private var _sendRound:int;

      private var _foodTimer:Timer;


      private var _fb0Txt:TextField;

      private var _fb1Txt:TextField;


      public function AssistantFunctionPanel()
      {
         super();
      }
      
      override public function setup() : void
      {
         setMainUI(new AssistantFunctionUI());
         this.initSet();
         this.initEvent();
      }
      
      private function initSet() : void
      {
         var i:int = 0;
         this._swapList = new Vector.<SimpleButton>();
         for(i = 0; i < 14; i++)
         {
            this._swapList.push(_mainUI["swap" + i]);
         }
         this._sendRound = 0;
         this._foodTimer = new Timer(500,1);
         this._fb0Txt = _mainUI["fb0Txt"];
         this._fb1Txt =_mainUI["fb1Txt"];
         this._fb0Txt.visible = true;
         this._fb1Txt.visible = true;
         //this._fb0Txt.text = this._fb1Txt.text = "";
         TooltipManager.addCommonTip(this._swapList[1],"点一次刷50次,随机出六种碎片,只点一次不一定够用");
         for(i = 2; i < 8; i++)
         {
            TooltipManager.addCommonTip(this._swapList[i],"点一次刷30次,需要有足够的星屑,没有先去前面刷,只点一次不一定够用");
         }
         TooltipManager.addCommonTip(this._swapList[9],"点一次刷19瓶或者少一点,想多刷就多点几次,\n不要刷的太多,刷到999上限之后领其他奖励容易吞");
         TooltipManager.addCommonTip(this._swapList[10],"一天一次,多点无效");
         TooltipManager.addCommonTip(this._swapList[11],"点一次刷100次,随机出精元晶石、神迹米卡技能石");
         this.reset();
      }
      
      private function initEvent() : void
      {
         for(var i:int = 0; i < this._swapList.length; i++)
         {
            this._swapList[i].addEventListener(MouseEvent.CLICK,this.onSwap);
         }
         this._foodTimer.addEventListener("timer",this.manyFood);
         this._fb0Txt.addEventListener("focusIn",function (e:*):void{
            _fb0Txt.text = "";
         });
         this._fb0Txt.addEventListener("focusOut",function (e:*):void{
            if(_fb0Txt.text == "")
            {
               _fb0Txt.text = "引导包(没有可以不填)";
            }
         });
         this._fb1Txt.addEventListener("focusIn",function (e:*):void{
            _fb1Txt.text = "";
         });
         this._fb1Txt.addEventListener("focusOut",function (e:*):void{
            if(_fb1Txt.text == "")
            {
               _fb1Txt.text = "封包(主包)";
            }
         });
      }
      
      private function onSwap(evt:MouseEvent) : void
      {
         this.reset();
         var index:int;
         this.enabledAllBtn(false);
         index = this._swapList.indexOf(evt.currentTarget as SimpleButton);
         if(index == 0)
         {//发送封包
            if(this._fb1Txt.text != "" && this._fb1Txt.text != "封包(主包)")
            {
               if(this._fb0Txt.text != "" && this._fb0Txt.text != "引导包(没有可以不填)")
               {
                  this.onFbSend(this._fb0Txt);
               }
               this.onFbSend(this._fb1Txt);
            }
            else
            {
               AlertManager.showAlert("主封包为空");
               this.enabledAllBtn(true);
            }
         }
         else if(index == 1)
         {//星屑
            this.setCommand(1055);
            this.setParam(new <uint>[4659,1,0],new <uint>[4,4,4]);
            this.Step1Swap(50,this.defaultEndFunc,this.defaultErrFunc);
         }
         else if(index == 2)
         {//腰子
            this.setCommand(1055,1055,1055);
            this.setParam(new <uint>[4603,1,2,1,0],new<uint>[4,4,4,4,4],new <uint>[4604,1,0],new <uint>[4,4,4],new <uint>[4605,1,0],new <uint>[4,4,4]);
            this.Step25Swap(30,this.defaultEndFunc,this.defaultErrFunc);
         }
         else if(index == 3)
         {//背徒
            this.setCommand(1055,1055,1055);
            this.setParam(new <uint>[4662,1,2,1,0],new<uint>[4,4,4,4,4],new <uint>[4663,1,0],new <uint>[4,4,4],new <uint>[4664,1,0],new <uint>[4,4,4]);
            this.Step25Swap(30,this.defaultEndFunc,this.defaultErrFunc);
         }
         else if(index == 4)
         {//头徒
            this.setCommand(1055,1055,1055);
            this.setParam(new <uint>[4592,1,2,1,0],new<uint>[4,4,4,4,4],new <uint>[4593,1,0],new <uint>[4,4,4],new <uint>[4594,1,0],new <uint>[4,4,4]);
            this.Step25Swap(30,this.defaultEndFunc,this.defaultErrFunc);
         }
         else if(index == 5)
         {//臂徒
            this.setCommand(1055,1055,1055);
            this.setParam(new <uint>[4619,1,2,1,0],new<uint>[4,4,4,4,4],new <uint>[4620,1,0],new <uint>[4,4,4],new <uint>[4621,1,0],new <uint>[4,4,4]);
            this.Step25Swap(30,this.defaultEndFunc,this.defaultErrFunc);
         }
         else if(index == 6)
         {//足徒
            this.setCommand(1055,1055,1055);
            this.setParam(new <uint>[4627,1,2,1,0],new<uint>[4,4,4,4,4],new <uint>[4628,1,0],new <uint>[4,4,4],new <uint>[4629,1,0],new <uint>[4,4,4]);
            this.Step25Swap(30,this.defaultEndFunc,this.defaultErrFunc);
         }
         else if(index == 7)
         {//心徒
            this.setCommand(1055,1055,1055);
            this.setParam(new <uint>[4670,1,2,1,0],new<uint>[4,4,4,4,4],new <uint>[4671,1,0],new <uint>[4,4,4],new <uint>[4672,1,0],new <uint>[4,4,4]);
            this.Step25Swap(30,this.defaultEndFunc,this.defaultErrFunc);
         }
         else if(index == 8)
         {//满汉全席
            this._sendRound = 0;
            AlertManager.showConfirm("大量刷取道具中，所需时间较长(3.7测试版：约需要7分钟)，请耐心等待，中途不要点击其他按钮，否则后果自负",null);
            this.manyFood();
         }
         else if(index == 9)
         {//350体力药
            this.setCommand(1006);
            this.setParam(new <uint>[601527,950],new<uint>[4,2]);
            Connection.send(this._command0,this._paramArray0);
            this.setCommand(1055);
            this.setParam(new <uint>[2022,1,0],new <uint>[4,4,4]);
            this.Step1Swap(19,function():void{
               enabledAllBtn(true);
            },function():void{
               enabledAllBtn(true);
            });
         }
         else if(index == 10)
         {//赛尔豆
            this.setCommand(1006);
            this.setParam(new <uint>[601580,999],new <uint>[4,2]);
            Connection.send(this._command0,this._paramArray0);
            this.setCommand(1055);
            this.setParam(new <uint>[3113,1,2,0,999],new<uint>[4,4,4,4,4]);
            Connection.send(this._command0,this._paramArray0);
            this.enabledAllBtn(true);
         }
         else if(index == 11)
         {//3915精元晶石
            this.setCommand(1055);
            this.setParam(new <uint>[3915,1,0],new <uint>[4,4,4]);
            this.Step1Swap(100,function():void{
               enabledAllBtn(true);
            },function():void{
               enabledAllBtn(true);
            });
         }
         else if(index == 12)
         {
            //神迹精华
            this.setCommand(1055,1055);
            this.setParam(new <uint>[3907,1,3,0,3,0],new<uint>[4,4,4,4,4,4],new <uint>[3908,1,0],new <uint>[4,4,4]);
            this.Step25Swap(100,this.defaultEndFunc,this.defaultErrFunc);
         }
         else if(index == 13)
         {
            //敬请期待
         }
      }

      private function onFbSend(_fbxTxt:TextField):void
      {
         var fb0Cmd:int = 0;
         var fb0Param:LittleEndianByteArray = new LittleEndianByteArray();
         var fb0Arr:Array;
         var fbbyte:int = 0;
            fb0Arr = _fbxTxt.text.split("");
            for(var i:int =0;i<fb0Arr.length;i++)
            {
               if(fb0Arr[i]==" "||fb0Arr[i]== "\n")
               {
                  fb0Arr.splice(i,1);
               }
               if(!((fb0Arr[i]>="0"&&fb0Arr[i]<="9")||(fb0Arr[i]>="A"&&fb0Arr[i]<="F")))
               {
                  AlertManager.showAlert("封包输入有误，请检查封包");
                  _fbxTxt.text = "";
                  this.enabledAllBtn(true);
                  return;
               }
               else if(fb0Arr[i]>="A"&&fb0Arr[i]<="F")
               {
                  if(fb0Arr[i]=="A")
                  {
                     fb0Arr[i] = 10;
                  }
                  if(fb0Arr[i]=="B")
                  {
                     fb0Arr[i] = 11;
                  }
                  if(fb0Arr[i]=="C")
                  {
                     fb0Arr[i] = 12;
                  }
                  if(fb0Arr[i]=="D")
                  {
                     fb0Arr[i] = 13;
                  }
                  if(fb0Arr[i]=="E")
                  {
                     fb0Arr[i] = 14;
                  }
                  if(fb0Arr[i]=="F")
                  {
                     fb0Arr[i] = 15;
                  }
               }
               if(i>=8 && i<=11)
               {
                  if(i == 8)
                  {
                     fb0Cmd+=int(fb0Arr[i])*16;
                  }
                  if(i == 9)
                  {
                     fb0Cmd+=int(fb0Arr[i]);
                  }
                  if(i == 10)
                  {
                     fb0Cmd+=int(fb0Arr[i])*16*16*16;
                  }
                  if(i == 11)
                  {
                     fb0Cmd+=int(fb0Arr[i])*16*16;
                  }
               }
               else if(i>=36)
               {
                  if(i%2==0)
                  {
                     fbbyte+=int(fb0Arr[i])*16;
                  }
                  else if(i%2 == 1)
                  {
                     fbbyte+=int(fb0Arr[i]);
                     fb0Param.writeByte(uint(fbbyte));
                     fbbyte = 0;
                  }
               }
            }
         if(Command.getCommand(uint(fb0Cmd))==null||fb0Cmd == 0)
         {
            AlertManager.showAlert("协议不存在");
            _fbxTxt.text = "";
            this.enabledAllBtn(true);
            return;
         }
         if(uint(fb0Cmd)==1055)
         {
            Connection.addCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.on1055);
         }
         Connection.send(Command.getCommand(uint(fb0Cmd)),fb0Param);
         this.enabledAllBtn(true);
      }

      private function on1055(e:MessageEvent):void
      {
         Connection.removeCommandListener(CommandSet.ITEM_EXCHANGE_1055,this.on1055);
         var datas:IDataInput = e.message.getRawDataCopy();
         new SwapInfo(datas);
      }

      private function setCommand(cmd0:uint,cmd1:uint = 0,cmd2:uint = 0,cmd3:uint =0):void
      {
         if(cmd0)
         {
            this._command0 = Command.getCommand(cmd0);
         }
         if(cmd1)
         {
            this._command1 = Command.getCommand(cmd1);
         }
         if(cmd2)
         {
            this._command2 = Command.getCommand(cmd2);
         }
         if(cmd3)
         {
            this._command3 = Command.getCommand(cmd3);
         }
      }

      private function setParam(param0:Vector.<uint>,paramLen0:Vector.<uint>,param1:Vector.<uint> = null,paramLen1:Vector.<uint> = null,param2:Vector.<uint> = null,paramLen2:Vector.<uint> = null,param3:Vector.<uint> = null,paramLen3:Vector.<uint> = null):void
      {
         var i:int = 0;
         this._paramArray0 = new LittleEndianByteArray;
         for(i = 0;i<param0.length;i++)
         {
            if(paramLen0[i]==4)
            {
               this._paramArray0.writeUnsignedInt(param0[i]);
            }
            else if(paramLen0[i]==2)
            {
               this._paramArray0.writeShort(param0[i]);
            }
            else if(paramLen0[i]==1)
            {
               this._paramArray0.writeByte(param0[i]);
            }
         }
         if(param1)
         {
            this._paramArray1 = new LittleEndianByteArray;
            for(i = 0;i<param1.length;i++)
            {
               if(paramLen1[i]==4)
               {
                  this._paramArray1.writeUnsignedInt(param1[i]);
               }
               else if(paramLen1[i]==2)
               {
                  this._paramArray1.writeShort(param1[i]);
               }
               else if(paramLen1[i]==1)
               {
                  this._paramArray1.writeByte(param1[i]);
               }
            }
         }
         if(param2)
         {
            this._paramArray2 = new LittleEndianByteArray;
            for(i = 0;i<param2.length;i++)
            {
               if(paramLen2[i]==4)
               {
                  this._paramArray2.writeUnsignedInt(param2[i]);
               }
               else if(paramLen2[i]==2)
               {
                  this._paramArray2.writeShort(param2[i]);
               }
               else if(paramLen2[i]==1)
               {
                  this._paramArray2.writeByte(param2[i]);
               }
            }
         }
      }

      private function Step1Swap(time:uint,sfunc:Function,efunc:Function):void
      {
         this._targetTimes = time;
         this._Times = 1;
         this._endFunc = sfunc;
         this._errFunc = efunc;
         if(this._command0 != null && this._paramArray0 != null)
         {
            Connection.addCommandListener(this._command0,this.Step1Swap1);
            Connection.addErrorHandler(this._command0,this.Step1Err1);
            Connection.send(this._command0,this._paramArray0);
         }
         else
         {
            AlertManager.showConfirm("error",null);
         }
      }

      private function Step1Swap1(evt:MessageEvent):void
      {
         if(this._Times < this._targetTimes)
         {
            this._Times++;
            Connection.send(this._command0,this._paramArray0);
         }
         else
         {
            Connection.removeCommandListener(this._command0,this.Step1Swap1);
            Connection.removeErrorHandler(this._command0,this.Step1Err1);
            if(this._endFunc != null)
            {
               this._endFunc();
            }
            this._Times = 0;
            this.reset();
         }
      }

      private function Step1Err1(evt:MessageEvent):void
      {
         Connection.removeCommandListener(this._command0,this.Step1Swap1);
         Connection.removeErrorHandler(this._command0,this.Step1Err1);
         if(this._errFunc != null)
         {
            this._errFunc();
         }
         this.reset();
      }

      private function Step25Swap(time:uint,sfunc:Function,efunc:Function):void
      {
         this._targetTimes = time;
         this._Times = 0;
         this._sendType = 0;
         this._endFunc = sfunc;
         this._errFunc = efunc;
         if(this._command0 != null && this._command1 != null)
         {
            this.Step25Swap1();
         }
      }

      private function Step25Swap1(evt:MessageEvent = null):void
      {
         if(this._sendType == 1)
         {
            Connection.removeCommandListener(this._command1,this.Step25Swap1);
            Connection.removeErrorHandler(this._command1,this.Step25Err2);
         }
         else if(this._sendType == 2)
         {
            Connection.removeCommandListener(this._command2,this.Step25Swap1);
            Connection.removeErrorHandler(this._command2,this.Step25Err3);
         }
         if(this._Times < this._targetTimes)
         {
            this._Times++;
            Connection.addCommandListener(this._command0,this.Step25Swap2);
            Connection.addErrorHandler(this._command0,this.Step25Err1);
            Connection.send(this._command0,this._paramArray0);
         }
         else
         {
            if(this._endFunc != null)
            {
               this._endFunc();
            }
            this.reset();
         }
      }

      private function Step25Swap2(evt:MessageEvent = null):void
      {
         this._sendType = 1;
         Connection.removeCommandListener(this._command0,this.Step25Swap2);
         Connection.removeErrorHandler(this._command0,this.Step25Err1);
         Connection.addCommandListener(this._command1,this.Step25Swap1);
         Connection.addErrorHandler(this._command1,this.Step25Err2);
         Connection.send(this._command1,this._paramArray1);
      }

      private function Step25Err1(evt:MessageEvent = null): void
      {
         Connection.removeCommandListener(this._command0,this.Step25Swap2);
         Connection.removeErrorHandler(this._command0,this.Step25Err1);
         AlertManager.showConfirm("刷取中止，可能是物品数量达到上限或所需物品数量不足，请检查背包",null);
         this.reset();
      }

      private function Step25Err2(evt:MessageEvent = null): void
      {
         if(this._command2 != null)
         {
            this._sendType = 2;
            Connection.removeCommandListener(this._command1,this.Step25Swap1);
            Connection.removeErrorHandler(this._command1,this.Step25Err2);
            Connection.addCommandListener(this._command2,this.Step25Swap1);
            Connection.addErrorHandler(this._command2,this.Step25Err3);
            Connection.send(this._command2,this._paramArray2);
         }
         else
         {
            Connection.removeCommandListener(this._command1,this.Step25Swap1);
            Connection.removeErrorHandler(this._command1,this.Step25Err2);
            if(this._errFunc != null)
            {
               this._errFunc();
            }
            this.reset();
         }

      }

      private function Step25Err3(evt:MessageEvent = null):void
      {
         Connection.removeCommandListener(this._command2,this.Step25Swap1);
         Connection.removeErrorHandler(this._command2,this.Step25Err3);
         if(this._errFunc != null)
         {
            this._errFunc();
         }
         this.reset();
      }

      private function Step3Swap(time:uint,sfunc:Function,efunc:Function):void
      {
         this._targetTimes = time;
         this._Times = 0;
         this._endFunc = sfunc;
         this._errFunc = efunc;
         if(this._command0 != null && this._command1 != null && this._command2 != null)
         {
            Connection.addCommandListener(this._command2,this.Step3Swap1);
            Connection.addErrorHandler(this._command2,this.Step3Err3);
            this.Step3Swap1();
         }
      }

      private function Step3Swap1(evt:MessageEvent = null):void
      {
         Connection.removeCommandListener(this._command2,this.Step3Swap1);
         Connection.removeErrorHandler(this._command2,this.Step3Err3);
         if(this._Times < this._targetTimes)
         {
            this._Times++;
            Connection.addCommandListener(this._command0,this.Step3Swap2);
            Connection.addErrorHandler(this._command0,this.Step3Err1);
            Connection.send(this._command0,this._paramArray0);
         }
         else
         {
            if(this._endFunc)
            {
               this._endFunc();
            }
            this.reset();
         }
      }

      private function Step3Swap2(evt:MessageEvent = null):void
      {
         Connection.removeCommandListener(this._command0,this.Step3Swap2);
         Connection.removeErrorHandler(this._command0,this.Step3Err1);
         Connection.addCommandListener(this._command1,this.Step3Swap3);
         Connection.addErrorHandler(this._command1,this.Step3Err2);
         Connection.send(this._command1,this._paramArray1);
      }

      private function Step3Swap3(evt:MessageEvent = null):void
      {
         Connection.removeCommandListener(this._command1,this.Step3Swap3);
         Connection.removeErrorHandler(this._command1,this.Step3Err1);
         Connection.addCommandListener(this._command2,this.Step3Swap1);
         Connection.addErrorHandler(this._command2,this.Step3Err3);
         Connection.send(this._command2,this._paramArray2);
      }

      private function Step3Err1(evt:MessageEvent = null): void
      {
         Connection.removeCommandListener(this._command0,this.Step3Swap2);
         Connection.removeErrorHandler(this._command0,this.Step3Err1);
         AlertManager.showConfirm("刷取中止，可能是物品数量达到上限或所需物品数量不足，请检查背包",null);
         this.reset();
      }

      private function Step3Err2(evt:MessageEvent = null): void
      {
         Connection.removeCommandListener(this._command1,this.Step3Swap3);
         Connection.removeErrorHandler(this._command1,this.Step3Err2);
         AlertManager.showConfirm("刷取中止，可能是物品数量达到上限或所需物品数量不足，请检查背包",null);
         this.reset();
      }

      private function Step3Err3(evt:MessageEvent = null):void
      {
         Connection.removeCommandListener(this._command2,this.Step3Swap1);
         Connection.removeErrorHandler(this._command2,this.Step3Err3);
         if(this._errFunc)
         {
            this._errFunc();
         }
         this.reset();
      }

      private function manyFoodTimer():void
      {
         this._foodTimer.reset();
         this._foodTimer.start();
      }

      private function manyFood(evt:TimerEvent = null):void
      {
         this.reset();
         this._sendRound++;
         if(this._sendRound == 1)
         {
            this.setCommand(1144);
            this.setParam(new <uint>[0,15,0],new <uint>[1,4,4]);
            this.Step1Swap(999,this.manyFoodTimer,this.manyFoodTimer);
         }
         else if(this._sendRound >= 2 && this._sendRound < 19)
         {
            this.setCommand(1006);
            this.setParam(new <uint>[601584,900],new<uint>[4,2]);
            Connection.send(this._command0,this._paramArray0);
            this.setCommand(1144);
            this.setParam(new <uint>[0,15,0],new <uint>[1,4,4]);
            this.Step1Swap(60,this.manyFoodTimer,this.manyFoodTimer);
         }
         else if(this._sendRound == 19)
         {
            AlertManager.showConfirm("‘月饼’刷取完毕，正在刷取下一道具，请耐心等待",null);
            this.setCommand(1144);
            this.setParam(new <uint>[0,12,0],new <uint>[1,4,4]);
            this.Step1Swap(999,this.manyFoodTimer,this.manyFoodTimer);
         }
         else if(this._sendRound >= 20 && this._sendRound < 30)
         {
            this.setCommand(1006,1006);
            this.setParam(new <uint>[601532,200],new<uint>[4,2],new <uint>[601536,500],new<uint>[4,2],new <uint>[0,12,0],new <uint>[1,4,4]);
            Connection.send(this._command0,this._paramArray0);
            Connection.send(this._command1,this._paramArray1);
            this.setCommand(1144);
            this.setParam(new <uint>[0,12,0],new <uint>[1,4,4]);
            this.Step1Swap(100,this.manyFoodTimer,this.manyFoodTimer);
         }
         else if(this._sendRound == 30)
         {
            AlertManager.showConfirm("‘葫芦瓜’刷取完毕，正在刷取下一道具，请耐心等待",null);
            this.setCommand(1144);
            this.setParam(new <uint>[0,11,0],new <uint>[1,4,4]);
            this.Step1Swap(999,this.manyFoodTimer,this.manyFoodTimer);
         }
         else if(this._sendRound >= 31 && this._sendRound < 43)
         {
            this.setCommand(1006,1006);
            this.setParam(new <uint>[601520,900],new<uint>[4,2],new <uint>[601522,900],new<uint>[4,2]);
            Connection.send(this._command0,this._paramArray0);
            Connection.send(this._command1,this._paramArray1);
            this.setCommand(1144);
            this.setParam(new <uint>[0,11,0],new <uint>[1,4,4]);
            this.Step1Swap(90,this.manyFoodTimer,this.manyFoodTimer);
         }
         else if(this._sendRound == 43)
         {
            AlertManager.showConfirm("‘清蒸蘑菇’刷取完毕，正在刷取下一道具，请耐心等待",null);
            this.setCommand(1055);
            this.setParam(new <uint>[2009,1,0],new <uint>[4,4,4]);
            this.Step1Swap(999,this.manyFoodTimer,this.manyFoodTimer);
         }
         else if(this._sendRound >= 44 && this._sendRound < 111)
         {
            this.setCommand(1006,1006);
            this.setParam(new <uint>[601563,900],new<uint>[4,2],new <uint>[601565,300],new<uint>[4,2]);
            Connection.send(this._command0,this._paramArray0);
            Connection.send(this._command1,this._paramArray1);
            this.setCommand(1055);
            this.setParam(new <uint>[2009,1,0],new <uint>[4,4,4]);
            this.Step1Swap(15,this.manyFoodTimer,this.manyFoodTimer);
         }
         else if(this._sendRound == 111)
         {
            AlertManager.showConfirm("‘桂花糕’刷取完毕，正在刷取下一道具，请耐心等待",null);
            this.setCommand(1055);
            this.setParam(new <uint>[624,1,0],new <uint>[4,4,4]);
            this.Step1Swap(999,this.manyFoodTimer,this.manyFoodTimer);
         }
         else if(this._sendRound >= 112 && this._sendRound < 162)
         {
            this.setCommand(1006);
            this.setParam(new <uint>[601510,700],new<uint>[4,2]);
            Connection.send(this._command0,this._paramArray0);
            this.setCommand(1055);
            this.setParam(new <uint>[624,1,0],new <uint>[4,4,4]);
            this.Step1Swap(20,this.manyFoodTimer,this.manyFoodTimer);
         }
         else if(this._sendRound == 162)
         {
            AlertManager.showConfirm("‘成长果实’刷取完毕，正在刷取下一道具，请耐心等待",null);
            this.setCommand(1055);
            this.setParam(new <uint>[991,1,0],new <uint>[4,4,4]);
            this.Step1Swap(999,this.manyFoodTimer,this.manyFoodTimer);
         }
         else if(this._sendRound >= 163 && this._sendRound < 175)
         {
            this.setCommand(1006);
            this.setParam(new <uint>[601545,900],new<uint>[4,2]);
            Connection.send(this._command0,this._paramArray0);
            this.setCommand(1055);
            this.setParam(new <uint>[991,1,0],new <uint>[4,4,4]);
            this.Step1Swap(90,this.manyFoodTimer,this.manyFoodTimer);
         }
         else if(this._sendRound == 175)
         {
            AlertManager.showConfirm("‘竹笋’刷取完毕，正在刷取下一道具，请耐心等待",null);
            this.setCommand(1055);
            this.setParam(new <uint>[933,1,0],new <uint>[4,4,4]);
            this.Step1Swap(999,this.manyFoodTimer,this.manyFoodTimer);
         }
         else if(this._sendRound >= 175 && this._sendRound < 242)
         {
            this.setCommand(1006,1006,1006);
            this.setParam(new <uint>[601544,300],new<uint>[4,2],new <uint>[601542,750],new<uint>[4,2],new <uint>[601534,750],new<uint>[4,2]);
            Connection.send(this._command0,this._paramArray0);
            Connection.send(this._command1,this._paramArray1);
            Connection.send(this._command2,this._paramArray2);
            this.setCommand(1055);
            this.setParam(new <uint>[933,1,0],new <uint>[4,4,4]);
            this.Step1Swap(15,this.manyFoodTimer,this.manyFoodTimer);
         }
         else
         {
            AlertManager.showConfirm("经验道具刷取完毕，请刷新游戏",function():void{
               enabledAllBtn(true);
            });
            this._sendRound = 0;
            this.reset();
         }
      }

      private function defaultEndFunc():void
      {
         AlertManager.showConfirm("刷取完成，共"+(this._Times).toString()+"次。物品数目可能依旧不满足需求，请查看背包",function ():void{
            enabledAllBtn(true);
         });
      }

      private function defaultErrFunc():void
      {
         AlertManager.showConfirm("刷取中止，可能是物品数量达到上限或所需物品数量不足，请检查背包",function():void{
            enabledAllBtn(true);
         });
      }

      private function enabledAllBtn(bool:Boolean):void
      {
         var btn:SimpleButton;
         for each (btn in this._swapList)
         {
            if(bool)
            {
               DisplayObjectUtil.enableButton(btn);
            }
            else
            {
               DisplayObjectUtil.disableButton(btn);
            }
         }
      }

      private function reset() : void
      {
         this._Times = 0;
         this._targetTimes = 0;
         this._sendType = 0;
         this._command0 = null;
         this._command1 = null;
         this._command2 = null;
         this._command3 = null;
         this._paramArray0=null;
         this._paramArray1=null;
         this._paramArray2=null;
         this._paramArray3 = null;
         this._endFunc = null;
         this._errFunc = null;
         this.enabledAllBtn(true);
      }
      
      override public function dispose() : void
      {
         for(var i:int = 0; i < this._swapList.length; i++)
         {
            this._swapList[i].removeEventListener(MouseEvent.CLICK,this.onSwap);
         }
         this._foodTimer.removeEventListener("timer",this.manyFood);
         this._swapList = null;
         this._sendRound = 0;
         this.reset();
         super.dispose();
      }
   }
}
