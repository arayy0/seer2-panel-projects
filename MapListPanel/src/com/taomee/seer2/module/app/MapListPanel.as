package com.taomee.seer2.module.app
{
    import com.taomee.seer2.app.popup.AlertManager;
    import com.taomee.seer2.core.module.Module;

    import flash.display.SimpleButton;
    import flash.events.MouseEvent;
    import flash.text.TextField;

public class MapListPanel extends Module
    {
        private var _preBtn:SimpleButton;

        private var _nextBtn:SimpleButton;

        private var _pageTxt:TextField;

        private var _mapListVec:Vector.<MapList>;

        private var _detailTip:detailTipUI;

        private var _mapDataVec:Vector.<Array>

        private var _page:uint;

        public function MapListPanel()
        {
            super();
            _lifecycleType = "global";
        }

        override public function setup() : void
        {
            setMainUI(new mainPanel());
            this.initData();
            this.initMC();
            this.initEvent();
            this.update();
        }

        private function initMC():void
        {
            var i:int;
            var mapList:MapList;
            this._page = 1;
            this._preBtn = _mainUI["preBtn"];
            this._nextBtn = _mainUI["nextBtn"];
            this._pageTxt = _mainUI["pageTxt"];
            this._detailTip = new detailTipUI();
            this._detailTip.gotoAndStop(1);
            this._detailTip.x = 475;
            this._detailTip["nameTxt"].text = "初始化地图名字"
            this._detailTip["detailTxt"].text = "初始化地图介绍"
            this._detailTip.visible = false;
            if (this._mapListVec == null)
            {
                this._mapListVec = new Vector.<MapList>();
            }
            for(i = 0; i < 10; i++)
            {
                mapList = new MapList();
                mapList.x = 475;
                mapList.y = 210 + i * 35;
                mapList.visible = false;
                this._mapListVec.push(mapList);
                addChild(mapList);
            }
            addChild(this._detailTip);
        }

        private function initEvent():void
        {
            var i:int;
            for(i = 0; i < this._mapListVec.length; i++)
            {
                this._mapListVec[i].addEventListener("rollOver",this.onTipShow);
                this._mapListVec[i].addEventListener("rollOut",this.onTipHide);
            }
            this._preBtn.addEventListener("click",this.onPageChange);
            this._nextBtn.addEventListener("click",this.onPageChange);
        }

        private function initData():void
        {
            var dataArr:Array;
            this._mapDataVec = new Vector.<Array>()
            dataArr = ["经典地图70", 70, "十分经典"];
            this._mapDataVec.push(dataArr);
            dataArr = ["另一个地图10", 10, ""];
            this._mapDataVec.push(dataArr);
            var i:int;
            for(i = 0; i < 10; i++)
            {
                dataArr = ["测试70:" + i.toString(), 70, ""];
                this._mapDataVec.push(dataArr);
            }
        }

        private function onTipShow(e:MouseEvent):void
        {
            var i:int;
            for(i = 0; i < this._mapListVec.length; i++)
            {
                if(this._mapListVec[i] == e.target)
                {
                    this._detailTip.y = e.target.y + 30;
                    if(this._mapListVec[i]._detail != "")
                    {
                        this._detailTip.gotoAndStop(1);
                        this._detailTip["detailTxt"].text = this._mapListVec[i]._detail;
                    }
                    else
                    {
                        this._detailTip.gotoAndStop(2);
                    }
                    this._detailTip["nameTxt"].text = this._mapListVec[i]._name + '(' + this._mapListVec[i]._id.toString() + ')';
                    this._detailTip.visible = true;
                    break;
                }
            }
        }

        private function onTipHide(e:MouseEvent):void
        {
            this._detailTip.y = 0;
            this._detailTip.gotoAndStop(1);
            this._detailTip["detailTxt"].text = "";
            this._detailTip.gotoAndStop(2);
            this._detailTip["nameTxt"].text = "";
            this._detailTip.visible = false;
        }

        private function onPageChange(e:MouseEvent):void
        {
            if(e.target == this._preBtn)
            {
                this._page -= 1;
            }
            else if(e.target == this._nextBtn)
            {
                this._page += 1;
            }
            if(this._page == 0)
            {
                this._page = 1;
            }
            else if(this._page > (this._mapDataVec.length / 10) + 1)
            {
                this._page -= 1;
            }
            this.update();
        }

        private function update():void
        {
            var i:int;
            for(i = 0; i < this._mapListVec.length; i++)
            {
                if((this._page == int(this._mapDataVec.length / 10) + 1) && this._mapDataVec.length % 10 != 0 && (i + 1) > this._mapDataVec.length % 10)
                {
                    this._mapListVec[i].visible = false;
                }
                else
                {
                    this._mapListVec[i].visible = true;
                    this._mapListVec[i].setData(this._mapDataVec[(this._page - 1) * 10 + i][0], this._mapDataVec[(this._page - 1) * 10 + i][1], this._mapDataVec[(this._page - 1) * 10 + i][2]);
                }
            }
            this._pageTxt.text = this._page.toString() + "/" + (int(this._mapDataVec.length / 10) + 1).toString();
        }
    }
}
