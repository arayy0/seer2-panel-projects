package com.taomee.seer2.module.app
{
    import com.taomee.seer2.app.component.PetDemoDisplayer;
    import com.taomee.seer2.app.config.PetConfig;
    import com.taomee.seer2.app.config.PetSkinConfig;
    import com.taomee.seer2.app.config.PetSkinDefineConfig;
import com.taomee.seer2.app.config.pet.PetDefinition;
import com.taomee.seer2.app.inventory.ItemManager;
    import com.taomee.seer2.app.inventory.events.ItemEvent;
    import com.taomee.seer2.app.pet.data.PetInfo;
    import com.taomee.seer2.app.pet.data.PetInfoManager;
    import com.taomee.seer2.app.popup.AlertManager;
    import com.taomee.seer2.core.module.Module;
    import com.taomee.seer2.core.utils.DisplayObjectUtil;
    import com.taomee.seer2.core.utils.URLUtil;
    import com.taomee.seer2.module.app.UI.PetSkinPanelUI;

    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;
    import flash.text.TextField;

import org.taomee.utils.DisplayUtil;
import org.taomee.utils.StringUtil;

public class PetSkinPanel extends Module
    {
        private var _petName:TextField;

        private var _skinName:TextField;

        private var _ruleBtn:SimpleButton;

        private var _useBtn:SimpleButton;

        private var _preBtn:SimpleButton;

        private var _nextBtn:SimpleButton;

        private var _searchBtn:SimpleButton;

        private var _newSearchBtn:SimpleButton;

        private var _changeBtn:SimpleButton;

        private var _searchTxt:TextField;

        private var _searchBg:MovieClip;

        private var _noSkinTip:MovieClip;

        private var _rulePanel:MovieClip;

        private var _petDisplayer:PetDemoDisplayer;

        private var _skinDisplayer:PetDemoDisplayer;

        private var _currPetInfo:PetInfo;

        private var _currSkinId:uint;

        private var _petCellVec:Vector.<PetCell>;

        private var _skinCellVec:Vector.<PetCell>;

        private var _skinVec:Vector.<uint>;

        private var _skinPage:uint;

        public function PetSkinPanel()
        {
            super();
            _lifecycleType = "global";
        }

        override public function setup() : void
        {
            setMainUI(new PetSkinPanelUI());
            this.initMC();
            this.initEvent();
        }

        /*override public function init(data:Object) : void
        {
            if(data == undefined)
            {

            }
            else
            {

            }
        }
        */

        private function initMC():void
        {
            this._petName = _mainUI["petName"];
            this._skinName = _mainUI["skinName"];
            this._ruleBtn = _mainUI["ruleBtn"];
            this._useBtn = _mainUI["useBtn"];
            this._preBtn = _mainUI["preBtn"];
            this._nextBtn = _mainUI["nextBtn"];
            this._searchBtn = _mainUI["searchBtn"];
            this._newSearchBtn = _mainUI["newSearchBtn"];
            this._changeBtn = _mainUI["changeBtn"];
            this._searchTxt = _mainUI["searchTxt"];
            this._searchBg = _mainUI["searchBg"];
            this._noSkinTip = _mainUI["noSkinTip"];
            this._rulePanel = _mainUI["rulePanel"];
            this.setSearchVisible(false);
            this._searchTxt.text = "精灵/皮肤序号";
            this._petDisplayer = new PetDemoDisplayer();
            this._petDisplayer.x = 180;
            this._petDisplayer.y = 200;
            this._skinDisplayer = new PetDemoDisplayer();
            this._skinDisplayer.x = 520;
            this._skinDisplayer.y = 200;
            this._currPetInfo = null;
            this._currSkinId = 0;
            this._petCellVec = new Vector.<PetCell>();
            var i:int, cell: PetCell;
            for(i = 0, cell = null; i < 6; i++)
            {
                (cell = new PetCell()).x = 21 + 120 * i;
                cell.y = 395;
                addChild(cell);
                this._petCellVec.push(cell);
            }
            this._skinCellVec = new Vector.<PetCell>();
            for(i = 0, cell = null; i < 4; i++)
            {
                (cell = new PetCell()).x = 755;
                cell.y = 35 + 110 * i ;
                addChild(cell);
                this._skinCellVec.push(cell);
            }
            DisplayObjectUtil.removeFromParent(_mainUI["rulePanel"]);
        }

        private function initEvent():void
        {
            this._ruleBtn.addEventListener("click",function(e:MouseEvent):void {addChild(_rulePanel);});
            this._rulePanel["closeBtn"].addEventListener("click",function(e:MouseEvent):void {DisplayObjectUtil.removeFromParent(_rulePanel);});
            this._useBtn.addEventListener("click",this.onUse);
            this._preBtn.addEventListener("click",function(e:MouseEvent):void
            {
                _skinPage = (_skinPage == 0) ? 0 : (_skinPage - 1);
                updateSkinCell();
            });
            this._nextBtn.addEventListener("click",function(e:MouseEvent):void
            {
                _skinPage = (_skinPage * 4 + 4 > _skinVec.length) ? _skinPage : (_skinPage + 1);
                updateSkinCell();
            });
            this._changeBtn.addEventListener("click",this.onChange);
            this._searchBtn.addEventListener("click",this.onSearch);
            this._searchTxt.addEventListener("focusIn",function (e:*):void{
                _searchTxt.text = "";
            });
            this._searchTxt.addEventListener("focusOut",function (e:*):void{
                if(_searchTxt.text == "")
                {
                    _searchTxt.text = "精灵/皮肤序号";
                }
            });
            this._newSearchBtn.addEventListener("click",function(e:MouseEvent):void
            {
                AlertManager.showConfirm("实验功能:开启后通过搜索序号使用任意皮肤,但皮肤未做适配可能出现卡机bug,一切后果自行承担",function():void{setSearchVisible(true)});
            });
            var i:uint, cell:PetCell;
            for(i = 0; i < this._petCellVec.length; i++)
            {
                cell = this._petCellVec[i];
                cell.addEventListener("click",this.selectPet);
            }
            for(i = 0; i < this._skinCellVec.length; i++)
            {
                cell = this._skinCellVec[i];
                cell.addEventListener("click",this.selectSkin);
            }
        }

        private function updatePetVec(e:ItemEvent):void
        {
            var petInfoVec:Vector.<PetInfo> = PetInfoManager.getAllBagPetInfo();
            var i:int, cell: PetCell;
            for(i = 0, cell = null; i < this._petCellVec.length; i++)
            {
                cell = this._petCellVec[i];
                cell.selected = false;
                if(i < petInfoVec.length)
                {
                    cell.setPetInfo(petInfoVec[i]);
                }
                else
                {
                    cell.reset();
                }
            }
            this._currPetInfo = PetInfoManager.getFirstPetInfo();
            this._petCellVec[0].dispatchEvent(new MouseEvent("click"));
        }

        private function updateSkinVec():void
        {
            this._skinVec = new Vector.<uint>();
            this._skinPage = 0;
            var skinList:Array;
            if(PetSkinDefineConfig.getPetSkinDefine(uint(this._currPetInfo.resourceId)))
            {
                skinList = PetSkinDefineConfig.getPetSkinDefine(uint(this._currPetInfo.resourceId));
                if(skinList.length > 0)
                {
                    var _skinId:uint = PetSkinConfig.getSkinId(uint(this._currPetInfo.resourceId));
                    if(_skinId == 0)
                    {
                        _skinId = uint(this._currPetInfo.resourceId);
                    }
                    for(var i:int = 0; i < skinList.length; i++)
                    {
                        if(skinList[i] != _skinId)
                        {
                            this._skinVec.push(skinList[i]);
                        }
                    }
                }
                this.updateSkinCell();
            }
            else
            {
                AlertManager.showAlert("皮肤配置拉取出错");
            }
        }

        private function updateSkinCell():void
        {
            this._currSkinId = 0;
            DisplayObjectUtil.disableButton(this._nextBtn);
            DisplayObjectUtil.disableButton(this._preBtn);
            var i:int, cell: PetCell;
            for(i = 0, cell = null; i < this._skinCellVec.length; i++)
            {
                cell = this._skinCellVec[i];
                cell.reset();
            }
            if(this._skinVec.length > 0)
            {
                for(i = 0, cell = null; i < 4 && (i + this._skinPage * 4) < this._skinVec.length; i++)
                {
                    cell = this._skinCellVec[i];
                    cell.setSkinInfo(this._currPetInfo, this._skinVec[i + this._skinPage * 4]);
                    cell.selected = false;
                }
                this._currSkinId = this._skinCellVec[0].skinId;
                this._skinCellVec[0].dispatchEvent(new MouseEvent("click"));
            }
            else
            {
                this.updateSkinDisplay();
            }
            if((this._skinPage * 4 + 4) < this._skinVec.length)
            {
                DisplayObjectUtil.enableButton(this._nextBtn);
            }
            if(this._skinPage > 0)
            {
                DisplayObjectUtil.enableButton(this._preBtn);
            }
        }

        private function selectSkin(e:MouseEvent):void
        {
            var i:int, cell: PetCell;
            for(i = 0, cell = null; i < this._skinCellVec.length; i++)
            {
                cell = this._skinCellVec[i];
                cell.selected = false;
            }
            cell = e.currentTarget as PetCell;
            cell.selected = true;
            this._currSkinId = cell.skinId;
            this.updateSkinDisplay();
        }

        private function selectPet(e:MouseEvent):void
        {
            var i:int, cell: PetCell;
            for(i = 0, cell = null; i < this._petCellVec.length; i++)
            {
                cell = this._petCellVec[i];
                cell.selected = false;
            }
            cell = e.currentTarget as PetCell;
            cell.selected = true;
            this._currPetInfo = cell.petInfo;
            this.updateSkinVec();
            this.updatePetDisplay();
        }

        private function updatePetDisplay():void
        {
            this._petName.text = PetConfig.getPetDefinition(uint(this._currPetInfo.resourceId)).name;
            DisplayObjectUtil.removeFromParent(this._petDisplayer);
            var url:String = String(URLUtil.getPetDemo(uint(this._currPetInfo.resourceId)));
            this._petDisplayer.newSetUrl(url,248,240,function():void
            {
                _mainUI.addChildAt(_petDisplayer,_mainUI.numChildren - 2);
            });
            this._changeBtn.visible = !!(this._currPetInfo.getPetDefinition() && this._currPetInfo.getPetDefinition().chgMonId != 0);
            this._changeBtn.mouseEnabled = this._changeBtn.visible;
        }

        private function updateSkinDisplay():void
        {
            this._skinName.visible = false;
            this._noSkinTip.visible = true;
            DisplayObjectUtil.removeFromParent(this._skinDisplayer);
            DisplayObjectUtil.disableButton(this._useBtn);
            if(this._currSkinId)
            {
                this._skinName.visible = true;
                this._noSkinTip.visible = false;
                DisplayObjectUtil.enableButton(this._useBtn);
                this._skinName.text = PetConfig.getPetDefinition(uint(this._currSkinId)).name;
                var url:String;
                //if(this._currSkinId == uint(this._currPetInfo.resourceId) || this._currSkinId == this._currPetInfo.getPetDefinition().chgMonId)
                if(true)
                {
                    url = String(URLUtil.getPetOriginDemo(uint(this._currSkinId)));
                }
                else
                {
                    url = String(URLUtil.getPetDemo(uint(this._currSkinId)));
                }
                this._skinDisplayer.newSetUrl(url,248,240,function():void
                {
                    _mainUI.addChildAt(_skinDisplayer,_mainUI.numChildren - 2);
                });
            }
            DisplayObjectUtil.removeFromParent(this._useBtn);
            this.addChild(this._useBtn);
        }

        private function onUse(e:MouseEvent):void
        {
            PetSkinConfig.setPetSkin(this._currPetInfo.resourceId,this._currSkinId);
            this.updatePetDisplay();
            this.updateSkinVec();
        }

        private function onSearch(e:MouseEvent):void
        {
            var idStr:String = String(StringUtil.trim(this._searchTxt.text));
            var skinId:uint;
            if(this._searchTxt.text != "" && this._searchTxt.text != "精灵/皮肤序号")
            {
                if(StringUtil.isInteger(idStr))
                {
                    skinId = int(idStr);
                }
                else
                {
                    AlertManager.showAlert("输入的不是数字或输入格式非法!");
                }
                var skinDef:PetDefinition = PetConfig.getPetDefinition(skinId);
                if(skinDef)
                {
                    var i:int, cell: PetCell;
                    for(i = 0, cell = null; i < this._skinCellVec.length; i++)
                    {
                        cell = this._skinCellVec[i];
                        cell.selected = false;
                    }
                    this._currSkinId = skinId;
                    this.updateSkinDisplay();
                }
                else
                {
                    AlertManager.showAlert("未找到该序号的精灵/皮肤,请前往精灵图鉴查询");
                }
            }
        }

        private function onChange(e:MouseEvent):void
        {
            var chgId:uint = this._currPetInfo.getPetDefinition().chgMonId;
            if(chgId != 0)
            {
                this._currPetInfo.resourceId = chgId;
            }
            this.updateSkinVec();
            this.updatePetDisplay();
        }

        private function setSearchVisible(v:Boolean):void
        {
            this._searchBtn.visible = v;
            this._searchBtn.mouseEnabled = v;
            this._searchTxt.visible = v;
            this._searchTxt.mouseEnabled = v;
            this._searchBg.visible = v;
            this._newSearchBtn.visible = !v;
            this._newSearchBtn.mouseEnabled = !v;
        }

        override public function show() : void
        {
            super.show();
            ItemManager.addEventListener1("requestSpecialItemSuccess",this.updatePetVec);
            ItemManager.requestSpecialItemList();
        }

    }
}