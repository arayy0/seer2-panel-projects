package com.taomee.seer2.module.app {
import com.taomee.seer2.app.component.PetDemoDisplayer;
import com.taomee.seer2.core.module.Module;
import com.taomee.seer2.core.utils.URLUtil;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.FrameLabel;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.IOErrorEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.SecurityErrorEvent;
import flash.filters.BevelFilter;
import flash.filters.GlowFilter;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;

import flash.display.MovieClip;
import flash.filters.BitmapFilter;
import flash.filters.BlurFilter;
import flash.geom.Rectangle;
import flash.ui.Keyboard;

public class TestPanel extends Module
{
    private var _iconCover:MovieClip;

    private var _outerMc:MovieClip;
    private var _innerMc:MovieClip;
    private var _childMc:MovieClip;

    private var _labelIndex:int = 0;
    private var _childFrame:int = 1;

    private var _costDisplay:TextField;
    private var _urlInput:TextField;
    private var _loading:Boolean = false;

    /** 低于此值的滤镜忽略不计 */
    public var blurIgnore:int = 8;
    public function TestPanel() {
        super();
        _lifecycleType = "global";
    }

    override public function setup() : void {
        setMainUI(new TestPanelUI());
        this.initSet();
    }

    private function initSet() : void {
        this._iconCover = this._mainUI["cover"];

        buildUI();
        _showStatus("输入 SWF URL 后点击 Load 加载");
    }

    // ── UI构建 ──────────────────────────────────────────

    private function buildUI():void {
        var baseY:int = 0;

        var bg:Sprite = new Sprite();
        bg.graphics.beginFill(0x000000);
        bg.graphics.drawRoundRect(0, 0, 1200, 660, 4);
        bg.graphics.endFill();
        bg.alpha = 0.3
        addChild(bg);
        bg.mouseEnabled = false;



        // ── URL 输入行 ──
        var inputBg:Sprite = new Sprite();
        inputBg.x = 0; inputBg.y = baseY;
        inputBg.graphics.beginFill(0xFFFFFF);
        inputBg.graphics.drawRoundRect(0, 0, 210, 28, 4);
        inputBg.graphics.endFill();
        addChild(inputBg);

        _urlInput = new TextField();
        _urlInput.type = TextFieldType.INPUT;
        _urlInput.x = 4; _urlInput.y = baseY + 5;
        _urlInput.width = 202; _urlInput.height = 20;
        _urlInput.defaultTextFormat = new TextFormat("_sans", 13, 0x000000);
        _urlInput.addEventListener(FocusEvent.FOCUS_IN, function(e:FocusEvent):void {
            if (_urlInput.text == "输入 SWF URL...") _urlInput.text = "";
        });
        _urlInput.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
            if (e.keyCode == Keyboard.ENTER) _doLoad();
        });
        addChild(_urlInput);

        var loadBtn:Sprite = _makeButton("Load", 216, 60, baseY);
        loadBtn.addEventListener(MouseEvent.CLICK, onLoad);
        addChild(loadBtn);

        baseY += 34;

        // ── 导航按钮行 ──
        var btnX:int = 0;

        var labelBtn:Sprite = _makeButton("Label", btnX, 120, baseY);
        labelBtn.addEventListener(MouseEvent.CLICK, onLabel);
        addChild(labelBtn);
        btnX += 126;

        var prevBtn:Sprite = _makeButton("◀ Prev", btnX, 74, baseY);
        prevBtn.addEventListener(MouseEvent.CLICK, onPrev);
        addChild(prevBtn);
        btnX += 80;

        var nextBtn:Sprite = _makeButton("Next ▶", btnX, 74, baseY);
        nextBtn.addEventListener(MouseEvent.CLICK, onNext);
        addChild(nextBtn);

        baseY += 34;

        // ── 信息显示区 ──
        _costDisplay = new TextField();
        _costDisplay.x = 4; _costDisplay.y = baseY;
        _costDisplay.width = 320; _costDisplay.height = 200;
        _costDisplay.autoSize = TextFieldAutoSize.LEFT;
        _costDisplay.background = true;
        _costDisplay.backgroundColor = 0x222222;
        _costDisplay.defaultTextFormat = new TextFormat("_sans", 13, 0xFFFFFF);
        _costDisplay.selectable = false;
        _costDisplay.multiline = true;
        _costDisplay.wordWrap = false;
        addChild(_costDisplay);
    }

    private function _makeButton(label:String, x:Number, w:int, y:int = 0):Sprite {
        var btn:Sprite = new Sprite();
        btn.x = x; btn.y = y;
        btn.buttonMode = true;
        btn.useHandCursor = true;
        btn.mouseChildren = false;

        btn.graphics.beginFill(0x555555);
        btn.graphics.drawRoundRect(0, 0, w, 28, 6);
        btn.graphics.endFill();

        var tf:TextField = new TextField();
        tf.defaultTextFormat = new TextFormat("_sans", 12, 0xFFFFFF, true);
        tf.text = label;
        tf.selectable = false;
        tf.mouseEnabled = false;
        tf.width = w; tf.height = 28;
        tf.x = 0; tf.y = 5;
        btn.addChild(tf);

        btn.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {
            btn.graphics.clear();
            btn.graphics.beginFill(0x777777);
            btn.graphics.drawRoundRect(0, 0, w, 28, 6);
        });
        btn.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {
            btn.graphics.clear();
            btn.graphics.beginFill(0x555555);
            btn.graphics.drawRoundRect(0, 0, w, 28, 6);
        });

        return btn;
    }

    // ── 加载逻辑（独立实现，不依赖项目 Loader/Cache 类） ──

    private function onLoad(e:MouseEvent):void {
        _doLoad();
    }

    private function _doLoad():void {
        var url:String = _urlInput.text;
        if (!url || url == "输入 SWF URL..." || _loading) return;
        url = "/seer2/res/pet/fight/" + url + ".swf";

        _loading = true;
        _showStatus("Loading: " + url + "\n请稍候...");

        var loader:Loader = new Loader();
        var info:LoaderInfo = loader.contentLoaderInfo;

        info.addEventListener(Event.COMPLETE, function(e:Event):void {
            _loading = false;
            try {
                var clazz:Class = info.applicationDomain.getDefinition("pet") as Class;
                var mc:MovieClip = new clazz() as MovieClip;
                if (!mc) {
                    _showStatus("加载失败：获取的类不是 MovieClip\nURL: " + url);
                    return;
                }
                _initMc(mc);
                _urlInput.text = url;
                refresh();
            } catch (err:Error) {
                _showStatus("加载失败：无法获取 'pet' 类定义\n" + err.message);
            }
        });

        info.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void {
            _loading = false;
            _showStatus("加载失败：IO 错误\nURL: " + url);
        });

        info.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(e:SecurityErrorEvent):void {
            _loading = false;
            _showStatus("加载失败：安全沙箱错误\nURL: " + url);
        });

        loader.load(new URLRequest(url));
    }

    // ── 初始化 MC ───────────────────────────────────────

    private function _initMc(mc:MovieClip):void {
        // 移除旧动画
        if (_innerMc && _innerMc.parent) {
            _innerMc.parent.removeChild(_innerMc);
        }

        _innerMc = mc;
        _innerMc.stop();
        _innerMc.x = 0;
        _innerMc.y = 120;   // UI 下方
        _innerMc.mouseEnabled = false;   // 不拦截按钮的鼠标事件
        _innerMc.mouseChildren = false;

        addChild(_innerMc);

        var labels:Array = _innerMc.currentLabels;
        if (labels && labels.length > 0) {
            _labelIndex = 0;
            _innerMc.gotoAndStop(labels[0].frame);
        }
        _resolveChild();
    }

    private function _resolveChild():void {
        _childMc = null;
        _childFrame = 1;
        if (_innerMc.numChildren > 0) {
            var child:DisplayObject = _innerMc.getChildAt(0);
            if (child is MovieClip) {
                _childMc = child as MovieClip;
                _childMc.stop();
                _childMc.gotoAndStop(1);
            }
        }
    }

    // ── 按钮事件 ─────────────────────────────────────────

    private function onLabel(e:MouseEvent):void {
        if (!_innerMc || _loading) return;
        var labels:Array = _innerMc.currentLabels;
        if (!labels || labels.length == 0) return;

        _labelIndex = (_labelIndex + 1) % (labels.length - 1);
        var fl:FrameLabel = labels[_labelIndex] as FrameLabel;
        _innerMc.gotoAndStop(fl.frame);
        _resolveChild();
        refresh();
    }

    private function onPrev(e:MouseEvent):void {
        if (!_childMc || _loading) return;
        if (_childFrame > 1) {
            _childFrame--;
            _childMc.gotoAndStop(_childFrame);
            refresh();
        }
    }

    private function onNext(e:MouseEvent):void {
        if (!_childMc || _loading) return;
        if (_childFrame < _childMc.totalFrames) {
            _childFrame++;
            _childMc.gotoAndStop(_childFrame);
            refresh();
        }
    }

    // ── 刷新显示 ────────────────────────────────────────

    private function refresh():void {
        if (!_innerMc) { _showStatus("无动画"); return; }

        var labels:Array = _innerMc.currentLabels;
        var curLabel:FrameLabel = (labels && labels.length > 0)
                ? (labels[_labelIndex] as FrameLabel) : null;

        var labelName:String = curLabel ? curLabel.name : "(无标签)";
        var cost:int = _childMc ? _calculateCost(_childMc) : 0;

        _costDisplay.text =
                "Label:   " + labelName + "\n" +
                "Inner:   " + _innerMc.currentFrame + " / " + _innerMc.totalFrames + "\n" +
                "Child:   " + (_childMc ? (_childFrame + " / " + _childMc.totalFrames) : "—") + "\n" +
                "Cost:    " + cost + "\n";
    }

    private function _showStatus(msg:String):void {
        _costDisplay.text = msg;
    }

    // ── 滤镜开销递归计算 ────────────────────────────────

    private function _calculateCost(mc:DisplayObject, depth:int = 0):int {
        if (depth > 5) return 0;
        if (!mc.visible) return 0;

        var isContainer:Boolean = mc is DisplayObjectContainer;
        if (!isContainer) {
            return (!mc.filters || mc.filters.length == 0) ? 0 : _computeNodeCost(mc);
        }

        var total:int = _computeNodeCost(mc);

        if (!mc.cacheAsBitmap) {
            for (var i:int = 0; i < (mc as DisplayObjectContainer).numChildren; i++) {
                total += _calculateCost((mc as DisplayObjectContainer).getChildAt(i), depth + 1);
            }
        }
        return total;
    }

    private function _computeNodeCost(mc:DisplayObject):int {
        if (!mc.filters || mc.filters.length == 0) return 0;

        var bounds:Rectangle = mc.getBounds(mc);
        if (bounds.width <= 0 || bounds.height <= 0) return 0;

        var curW:Number = bounds.width;
        var curH:Number = bounds.height;
        var totalCost:int = 0;

        for (var fi:int = 0; fi < mc.filters.length; fi++) {
            var f:BitmapFilter = mc.filters[fi];
            var blurX:Number = 0;
            var blurY:Number = 0;
            var quality:int = 1;
            var strength:int = 1;
            var layers:int = 1;
            if (f is BlurFilter) {
                var bf:BlurFilter = f as BlurFilter;
                blurX = bf.blurX;
                blurY = bf.blurY;
                quality = bf.quality;
            } else if (f is GlowFilter) {
                var gf:GlowFilter = f as GlowFilter;
                blurX = gf.blurX;
                blurY = gf.blurY;
                quality = gf.quality;
                strength = gf.strength;
            } else if (f is BevelFilter) {
                var bvf:BevelFilter = f as BevelFilter;
                blurX = bvf.blurX;
                blurY = bvf.blurY;
                quality = bvf.quality;
                strength = bvf.strength;
                layers = (bvf.type == "full") ? 3 : 2;
            } else {
                continue;
            }
            if (blurX <= 1 && blurY <= 1) continue;

            var expandX:Number = blurX << 1;
            var expandY:Number = blurY << 1;
            var qualityPasses:int = quality * 2 + 1;
            var outputArea:int = int((curW + expandX) * (curH + expandY));
            totalCost += outputArea * qualityPasses * (1 + (strength - 1) / 32) * layers * (1 + (blurX + blurY - 2) / 128);

            // 当前滤镜的输出面积 = 下一滤镜的输入面积
            curW += expandX;
            curH += expandY;
        }
        return totalCost;
    }
}
}
