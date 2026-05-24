package com.taomee.seer2.module.app
{
    import com.taomee.seer2.app.utils.ActsHelperUtil;

    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    public class MapList extends Sprite
    {
        public var _name:String;

        public var _id:uint;

        public var _detail:String;

        public var _goBtn:SimpleButton;

        private var _ui:MovieClip;

        public function MapList()
        {
            super();
            this._name = "初始化地图名字";
            this._id = 1;
            this._detail = "";
            this._ui = new mapListUI();
            this._goBtn = this._ui["goBtn"];
            this._goBtn.addEventListener("click",this.onGo);
            this._ui["nameTxt"].text = this._name;
            addChild(this._ui);
        }

        public function setData(name:String, id:uint, detail:String):void
        {
            this._name = name;
            this._id = id;
            this._detail = detail;
            this._ui["nameTxt"].text = name;
        }

        private function onGo(e:MouseEvent):void
        {
            if(this._id > 0)
            {
                ActsHelperUtil.goHandle(this._id);
            }
        }
    }
}
