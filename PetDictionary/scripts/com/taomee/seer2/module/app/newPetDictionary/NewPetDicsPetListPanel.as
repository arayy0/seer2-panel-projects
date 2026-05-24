package com.taomee.seer2.module.app.newPetDictionary
{
import com.taomee.seer2.app.popup.AlertManager;
import com.taomee.seer2.module.app.moduleCommon.PageBar;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class NewPetDicsPetListPanel extends Sprite
   {
       
      
      private var _listPanel:NewPetDicsListPanel;
      
      private var _changePageBtnMC:PetListChangePageUI;
      
      private var _pageBar:PageBar;
      
      private var _selectPetID:int;
      
      private const PAGE_SIZE:uint = 12;
      
      private var _data:Vector.<int>;

      private var _quickTurnTxt:TextField;

      private var _goBtn:SimpleButton;

      private var _totalPage:uint;
      
      public function NewPetDicsPetListPanel()
      {
         super();
         this.createChildren();
         this.initEventListener();
      }
      
      public function reset() : void
      {
      }
      
      public function setData(data:Vector.<int>) : void
      {
         this._data = data;
         this.initPageBar();
         this.changePage();
      }
      
      private function initPageBar() : void
      {
         var preBtn:SimpleButton = this._changePageBtnMC["preBtn"];
         var nextBtn:SimpleButton = this._changePageBtnMC["nextBtn"];
         this._totalPage = uint(Math.ceil(this._data.length / 12) == 0 ? 1 : uint(Math.ceil((this._data.length - 1) / 12)));
         var currentPageTxt:TextField = this._changePageBtnMC["currentPageTxt"];
         var totalPageTxt:TextField = this._changePageBtnMC["totalPageTxt"];
         if(!this._pageBar)
         {
            this._pageBar = new PageBar(preBtn,nextBtn,this._totalPage,currentPageTxt,totalPageTxt);
            this._pageBar.addEventListener("pageChange",this.onPageChange);
         }
      }
      
      private function initEventListener() : void
      {
         this._listPanel.addEventListener("showPetDetail",this.onShowPetDetail);
         this._goBtn.addEventListener("click",this.onQuickChange);
         this._quickTurnTxt.addEventListener("focusIn",function (e:Event):void
         {
            _quickTurnTxt.text = "";
         })
         this._quickTurnTxt.addEventListener("focusOut",function (e:Event):void
         {
            if(_quickTurnTxt.text == "")
            {
               _quickTurnTxt.text = "快捷跳转";
            }
         })
      }
      
      private function createChildren() : void
      {
         this._changePageBtnMC = new PetListChangePageUI();
         addChild(this._changePageBtnMC);
         this._changePageBtnMC.x = 140;
         this._changePageBtnMC.y = 330;
         this._listPanel = new NewPetDicsListPanel();
         this._listPanel.x = 62;
         this._listPanel.y = -11;
         addChild(this._listPanel);
         this._quickTurnTxt = this._changePageBtnMC["quickTurnTxt"];
         this._goBtn = this._changePageBtnMC["goBtn"];
      }
      
      private function onPageChange(evt:Event) : void
      {
         trace("[_pageBar.currentPage===" + this._pageBar.currentPage + "]","[_pageBar.totalPage===" + this._pageBar.totalPage + "]");
         this.changePage();
      }

      private function onQuickChange(e:Event) : void
      {
         if(this._quickTurnTxt.text == "" || this._quickTurnTxt.text == "快捷跳转")
         {
            AlertManager.showAlert("请输入页数");
         }
         else if(int(this._quickTurnTxt.text) > this._totalPage || int(this._quickTurnTxt.text) < 1)
         {
            AlertManager.showAlert("页数超出范围");
         }
         else
         {
            var resourceVec:Vector.<int> = new Vector.<int>();
            resourceVec = this.getPageData(int(this._quickTurnTxt.text));
            this._listPanel.setData(resourceVec);
            this._pageBar.currentPage = int(this._quickTurnTxt.text);
         }
      }
      
      private function changePage() : void
      {
         var resouceVec:Vector.<int> = new Vector.<int>();
         trace("[currentPage-----" + this._pageBar.currentPage + "]");
         resouceVec = this.getPageData(this._pageBar.currentPage);
         this._listPanel.setData(resouceVec);
      }
      
      private function onShowPetDetail(evt:NewPetDicsEvent) : void
      {
         this._selectPetID = evt.getPetResourceId();
         this.showPetDetail();
      }
      
      private function showPetDetail() : void
      {
         dispatchEvent(new NewPetDicsEvent("showPetDetail",this._selectPetID));
      }
      
      private function getPageData(page:int) : Vector.<int>
      {
         var offset:int = 0;
         var petResouceVec:Vector.<int> = null;
         var i:* = 0;
         if(Boolean(this._data))
         {
            offset = (page - 1) * 12 + 1;
            petResouceVec = new Vector.<int>();
            i = offset;
            while(i < offset + 12)
            {
               if(i < this._data.length)
               {
                  petResouceVec.push(this._data[i]);
               }
               else
               {
                  petResouceVec.push(0);
               }
               i++;
            }
            return petResouceVec;
         }
         return null;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._pageBar))
         {
            this._pageBar.removeEventListener("pageChange",this.onPageChange);
            this._pageBar.dispose();
            this._pageBar = null;
         }
      }
   }
}
