package com.taomee.seer2.module.app
{
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

public class childPanel extends Sprite
{
    protected var _mc:MovieClip;

    protected var _warningMc:MovieClip;
    public function childPanel()
    {
        super();
    }

    public function initialize():void
    {
        addChild(this._mc);
        this._warningMc = this._mc["warningCircle"];
        this._warningMc.gotoAndStop(1);
        this._mc["closeBtn"].addEventListener("click",function (e:MouseEvent):void
        {
            setVisible(false);
        });
    }

    public function setVisible(b:Boolean = true):void
    {
        if(this._mc)
        {
            this._mc.visible = b;
        }
    }

    public function initWarningEvent(btn:SimpleButton,str:String):void
    {
        btn.addEventListener(MouseEvent.MOUSE_OVER,function(e:MouseEvent):void
        {
            _warningMc.gotoAndStop(2);
            (_warningMc["tipTxt"] as TextField).text = str;
        });
        btn.addEventListener(MouseEvent.MOUSE_OUT,function(e:MouseEvent):void
        {
            _warningMc.gotoAndStop(1);
        })
    }
}
}
