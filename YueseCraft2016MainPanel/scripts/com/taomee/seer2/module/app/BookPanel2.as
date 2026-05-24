package com.taomee.seer2.module.app
{
import com.taomee.seer2.app.activeCount.ActiveCountManager;
import com.taomee.seer2.app.config.pet.PetDefinition;
import com.taomee.seer2.app.config.PetConfig;
import com.taomee.seer2.app.swap.SwapManager;
import com.taomee.seer2.app.swap.special.SpecialInfo;
import com.taomee.seer2.app.swap.info.SwapInfo;
import com.taomee.seer2.app.inventory.ItemManager;
import com.taomee.seer2.app.inventory.events.ItemEvent;
import com.taomee.seer2.app.popup.AlertManager;
import com.taomee.seer2.app.popup.ServerMessager;
import com.taomee.seer2.app.net.parser.Parser_1142;
import com.taomee.seer2.app.pet.data.PetInfo;
import com.taomee.seer2.app.pet.data.PetInfoManager;
import com.taomee.seer2.app.pet.data.SkillInfo;
import com.taomee.seer2.app.utils.PetUtil;
import com.taomee.seer2.core.utils.DisplayObjectUtil;
import com.taomee.seer2.core.scene.SceneManager;
import com.taomee.seer2.core.scene.SceneType;
import com.taomee.seer2.core.net.MessageEvent;
import flash.text.TextField;
import org.taomee.utils.BitUtil;
import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.display.SimpleButton;
import flash.utils.IDataInput;
public class BookPanel2 extends BookBase
{
    private var _mc:MovieClip;

    private var _getBtnVec:Vector.<SimpleButton>;

    private var _swapBtnVec:Vector.<SimpleButton>;

    private var _lightTxt:TextField;

    private const SWAP_ID_VEC:Array = [4544,4545,4546,4549,4550,4553,4554,4555];

    private const SWAP_SKILL_VEC:Array=[18450,18451,18452,18453];
    public function BookPanel2()
    {
        super();
        this._mc = new BookUI2;
        this.initialize();
        this.initEvent();
        this.resetData();
    }

    private function initialize():void
    {
        var i:int = 0;
        addChild(this._mc);
        this._getBtnVec = new Vector.<SimpleButton>();
        this._swapBtnVec = new Vector.<SimpleButton>();
        for(i = 0;i < 5;i++)
        {
            this._getBtnVec.push(this._mc["getbtn"+i]);
        }
        for(i = 0;i < 12;i++)
        {
            this._swapBtnVec.push(this._mc["swapbtn"+i]);
        }
        this._lightTxt = this._mc["lightTxt"];
    }

    private function initEvent():void
    {
        var i:int = 0;
        for(i = 0;i < 5;i++)
        {
            this._getBtnVec[i].addEventListener("click",this.lightGet);
        }
        for(i = 0;i < 12;i++)
        {
            this._swapBtnVec[i].addEventListener("click",this.lightSwap);
        }
    }

    private function lightGet(e:MouseEvent = null):void
    {
        var i:int = 0;
        if(e.target == this._getBtnVec[0])
        {
            SceneManager.changeScene(SceneType.LOBBY,3858);
            return;
        }
        for(i = 1;i < 5;i++)
        {
            if(e.target == this._getBtnVec[i])
            {
                SwapManager.swapItem(4556,1,function success(data:IDataInput):void
                {
                    resetData();
                    new SwapInfo(data);
                },function failed(errCode:uint):void
                {
                    if(errCode == 2)
                    {
                        AlertManager.showAlert("不符合领取条件！");
                    }
                },new SpecialInfo(1,i));
                break;
            }
        }
    }

    private function lightSwap(e:MouseEvent = null):void
    {
        var i:int = 0;
        for(i = 0;i < this._swapBtnVec.length;i++)
        {
            if(e.target == this._swapBtnVec[i])
            {
                if(i < 8)
                {
                    SwapManager.swapItem(SWAP_ID_VEC[i],1,function success(data:IDataInput):void
                    {
                        new SwapInfo(data);
                    },function failed(errCode:uint):void
                    {
                        if(errCode == 10 || errCode == 6)
                        {
                            AlertManager.showAlert("所需物品数量不足!");
                        }
                        else if(errCode == 66)
                        {
                            AlertManager.showAlert("今天的次数已经用完了明天再来吧!");
                        }
                    });
                    break;
                }
                else if (i >= 8 && i <= 11)
                {
                    PetUtil.exchangePetSkill(2560,this.SWAP_SKILL_VEC[i - 8],function(catchTime:uint):void
                    {
                        SwapManager.swapItem(4565,1,function success(data:IDataInput):void
                        {
                            new SwapInfo(data);
                            ServerMessager.addMessage("【" + (PetConfig.getPetDefinition(2560)).name + "】成功获得【" + (new SkillInfo(SWAP_SKILL_VEC[i - 8])).name + "】");
                            var petInfo:PetInfo = PetInfoManager.getPetInfoFromMap(catchTime);
                            PetUtil.putinAndGetoutOfStorage(petInfo);
                        },function failed(errCode:uint):void
                        {
                            if(errCode == 10)
                            {
                                AlertManager.showAlert(" 所需物品数量不足!");
                            }
                        },new SpecialInfo(2,catchTime,(i + 6)));
                    });
                    break;
                }
            }
        }
    }

    override public function resetData(e:MessageEvent = null):void
    {
        ActiveCountManager.requestActiveCountList([206359],function(par:Parser_1142):void
        {
            var flag:int = int(par.infoVec[0]);
            for(var i:int = 1; i < 5; i++)
            {
                if(BitUtil.getBit(flag,(i - 1)) != 0)
                {
                    DisplayObjectUtil.disableButton(_getBtnVec[i]);
                }
            }
            ItemManager.addEventListener1(ItemEvent.REQUEST_SPECIAL_ITEM_SUCCESS,function requestSuccess(event:ItemEvent):void
            {
                var itemNum:int = 0;
                ItemManager.removeEventListener1(ItemEvent.REQUEST_SPECIAL_ITEM_SUCCESS,requestSuccess);
                if(Boolean(ItemManager.getSpecialItem(606937)))
                {
                    itemNum = int(ItemManager.getSpecialItem(606937).quantity);
                    _lightTxt.text = (itemNum).toString();
                }
                else
                {
                    _lightTxt.text = "0";
                }
            });
            ItemManager.requestSpecialItemList();
        });

    }
}
}
