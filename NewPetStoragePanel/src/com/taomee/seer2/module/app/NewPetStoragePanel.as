package com.taomee.seer2.module.app
{
import com.taomee.seer2.core.module.Module;
import com.taomee.seer2.module.app.ui.NewPetStorageMainUI;

import flash.display.MovieClip;

public class NewPetStoragePanel extends Module
{

    private var _petBagPage:int;

    private var _petDetailPage:int;

    private var _petStoragePage:int;

    public function NewPetStoragePanel()
    {
        super();
        _lifecycleType = "global";
    }

    override public function setup() : void
    {
        setMainUI(new NewPetStorageMainUI);
        this.createChildren();
        this.initEventListener();
    }
}
}
