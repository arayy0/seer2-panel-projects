package com.taomee.seer2.module.app.versionOnePetBagPanel.petItemPanel {
import com.taomee.seer2.app.component.IconDisplayer;
import com.taomee.seer2.app.config.PetConfig;
import com.taomee.seer2.app.inventory.ItemManager;
import com.taomee.seer2.app.net.CommandSet;
import com.taomee.seer2.app.net.Connection;
import com.taomee.seer2.app.pet.data.PetInfo;
import com.taomee.seer2.app.popup.AlertManager;
import com.taomee.seer2.core.inventory.Item;
import com.taomee.seer2.core.net.MessageEvent;
import com.taomee.seer2.core.utils.DisplayObjectUtil;
import com.taomee.seer2.core.utils.URLUtil;
import com.taomee.seer2.module.app.versionOnePetBagPanel.PetBagPanel;
import com.taomee.seer2.module.app.versionOnePetBagPanel.PetItemBagPanel;
import com.taomee.seer2.module.app.versionOnePetBagPanel.PetTabPanel;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.utils.ByteArray;

public class CvntUseCharaMedicPanel extends Sprite {
    private var _mainUI:CvntUseCharaMedicUI;
    private var _petBagPanel:PetBagPanel;
    private var _petTabPanel:PetTabPanel;
    private var _itemBagPanel:PetItemBagPanel;
    private var _petIcon:IconDisplayer;
    private var _itemIcon:IconDisplayer;
    private var _closeBtn:SimpleButton;
    private var _useBtn:SimpleButton;
    private var _petCell:MovieClip;
    private var _itemCell:MovieClip;
    private var _petNameTxt:TextField;
    private var _petCharaTxt:TextField;
    private var _itemNameTxt:TextField;
    private var _itemQuantityTxt:TextField;
    private var _petInfo:PetInfo;
    private var _itemInfo:Item;
    public function CvntUseCharaMedicPanel() {
        super();
        this.initChild();
        this.initEvent();
    }

    private function initChild() : void {
        this._mainUI = new CvntUseCharaMedicUI();
        this.addChild(this._mainUI);
        this._closeBtn = this._mainUI["closeBtn"];
        this._useBtn = this._mainUI["useBtn"];
        this._petCell = this._mainUI["petCell"];
        this._itemCell = this._mainUI["itemCell"];
        this._petNameTxt = this._mainUI["petNameTxt"];
        this._petCharaTxt = this._mainUI["petCharaTxt"];
        this._itemNameTxt = this._mainUI["itemNameTxt"];
        this._itemQuantityTxt = this._mainUI["itemQuantityTxt"];
        this._petIcon = new IconDisplayer();
        this._petIcon.scaleX = this._petIcon.scaleY = 60 / 54;
        this._petCell.addChildAt(this._petIcon,0);
        this._itemIcon = new IconDisplayer();
        this._itemIcon.scaleX = this._itemIcon.scaleY = 1;
        this._itemCell.addChildAt(this._itemIcon,0);
    }

    public function setData(petInfo:PetInfo, item:Item):void {
        this.reset();
        this.petInfo = petInfo;
        this.itemInfo = item;
    }

    private function initEvent() : void {
        this._closeBtn.addEventListener("click", this.onClose);
        this._useBtn.addEventListener("click", this.onUse);
    }

    private function onUse(e:MouseEvent = null) : void {
        Connection.addCommandListener(CommandSet.CHANGE_CHARECTER_1169,this.onChangeCharacter);
        Connection.addErrorHandler(CommandSet.CHANGE_CHARECTER_1169,this.onError1169);
        Connection.send(CommandSet.CHANGE_CHARECTER_1169,this._petInfo.catchTime,_itemInfo.referenceId);
    }

    private function onError1169(e:MessageEvent) : void {
        Connection.removeCommandListener(CommandSet.CHANGE_CHARECTER_1169,this.onChangeCharacter);
        Connection.removeErrorHandler(CommandSet.CHANGE_CHARECTER_1169,this.onError1169);
        if(e.message.statusCode == 200020) {
            AlertManager.showAlert("此精灵不能使用这个物品!");
        }
    }

    private function onChangeCharacter(evt:MessageEvent) : void {
        var data:ByteArray;
        var itemId:*;
        Connection.removeErrorHandler(CommandSet.CHANGE_CHARECTER_1169,this.onError1169);
        Connection.removeCommandListener(CommandSet.CHANGE_CHARECTER_1169,this.onChangeCharacter);
        data = evt.message.getRawDataCopy();
        PetInfo.readBaseInfo(this._petInfo,data);
        this.petInfo = this._petInfo
        itemId = data.readUnsignedInt();

        this._itemBagPanel.reducePetItem(itemId);
        var item:Item = ItemManager.getItemByReferenceId(itemId);
        this.itemInfo = item;

        if(Boolean(this._petBagPanel)) {
            this._petBagPanel.updateSelectedPet();
        }
        if(Boolean(this._petTabPanel)) {
            this._petTabPanel.updatePet();
        }
    }

    public function set petBagPanel(param:PetBagPanel) : void {
        this._petBagPanel = param;
    }

    public function set petTabPanel(param:PetTabPanel) : void {
        this._petTabPanel = param;
    }

    public function set itemBagPanel(param:PetItemBagPanel) : void {
        this._itemBagPanel = param;
    }

    public function set petInfo(info:PetInfo) : void {
        this._petInfo = info;
        if (this._petInfo) {
            var url:String = String(URLUtil.getPetIcon(this._petInfo.resourceId))
            this._petIcon.setIconUrl(url);
            this.setPetNameTxt(PetConfig.getPetDefinition(this._petInfo.resourceId).name);
            this.setPetCharaTxt(this._petInfo.characterName);
        }
    }

    public function set itemInfo(info:Item) : void {
        this._itemInfo = info;
        if (this._itemInfo) {
            var url:String = String(this._itemInfo.iconUrl);
            this._itemIcon.setIconUrl(url);
            this.setItemNameTxt(this._itemInfo.name);
            this.setItemQuantityTxt(String(this._itemInfo.quantity));
        }
    }

    private function reset() : void {
        this._petIcon.removeIcon();
        this._itemIcon.removeIcon();
        this.setPetNameTxt(null);
        this.setPetCharaTxt(null);
        this.setItemNameTxt(null);
        this.setItemQuantityTxt(null);
    }

    private function setPetNameTxt(param:String) : void {
        var str:String = (param == null) ? "" : param;
        this._petNameTxt.text = "当前精灵: " + str;
    }

    private function setPetCharaTxt(param:String) : void {
        var str:String = (param == null) ? "" : param;
        this._petCharaTxt.text = "当前性格: " + str;
    }

    private function setItemNameTxt(param:String) : void {
        var str:String = (param == null) ? "" : param;
        this._itemNameTxt.text = "当前药剂: " + str;
    }

    private function setItemQuantityTxt(param:String) : void {
        var str:String = (param == null) ? "" : param;
        this._itemQuantityTxt.text = "剩余数量: " + str;
    }

    public function show(e:MouseEvent = null) : void {
        if (this._petBagPanel) {
            this.x = (960 - 310) / 2;
            this.y = (540 - 215) / 2;
            this._petBagPanel.addChild(this);
        }
    }

    public function onClose(e:MouseEvent = null) : void {
        DisplayObjectUtil.removeFromParent(this);
    }
}
}
