package com.taomee.seer2.module.app
{
import com.taomee.seer2.app.starMagic.StarInfo;
import com.taomee.seer2.app.starMagic.StarMagicConfig;
import com.taomee.seer2.module.app.ui.StarTip;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.text.TextField;

public class StarMagicTip extends Sprite
{
    private var _mc:MovieClip;

    private var starInfo:StarInfo;

    public function StarMagicTip()
    {
        super();
        this._mc = new StarTip();
        this.addChild(this._mc);
    }

    public function update(info:StarInfo) : void
    {
        this.starInfo = info;
        if(this.starInfo == null)
        {
            return;
        }
        var infoConfig:StarInfo = StarMagicConfig.getInfo(info.buffId,info.type);
        if(Boolean(infoConfig))
        {
            if(info.buffId > 2)
            {
                this._mc.gotoAndStop(1);
                this._mc["shuxing"].text = infoConfig.effdesc + ":";
                if(this.starInfo.level < infoConfig.maxLevel)
                {
                    this._mc["exp"].text = "" + info.exp + "/" + infoConfig.nextExpArr[this.starInfo.level];
                }
                else
                {
                    this._mc["exp"].text = "满级";
                }
                if(infoConfig.buffSwf <= 4 || infoConfig.buffSwf == 8)
                {
                    this._mc["value"].text = "" + infoConfig.effvalue[0][this.starInfo.level];
                }
                else
                {
                    this._mc["value"].text = "" + infoConfig.effvalue[0][this.starInfo.level] + "%";
                }
                this._mc["sell"].text = "" + infoConfig.sell_exp;
                this._mc["level"].text = "LV." + this.starInfo.level;
            }
            else
            {
                this._mc.gotoAndStop(2);
            }
            this._mc["nameT"].text = "" + infoConfig.nameT;
        }
    }
}
}

