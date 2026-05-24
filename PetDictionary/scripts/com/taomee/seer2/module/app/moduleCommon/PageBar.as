package com.taomee.seer2.module.app.moduleCommon
{
   import com.taomee.seer2.core.utils.DisplayObjectUtil;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class PageBar extends EventDispatcher
   {
      
      public static const PAGE_CHANGE:String = "pageChange";
       
      
      private var _preBtn:SimpleButton;
      
      private var _nextBtn:SimpleButton;
      
      private var _currentPage:int;
      
      private var _totalPage:int;
      
      private var _currentPageTxt:TextField;
      
      private var _totalPageTxt:TextField;
      
      public function PageBar(preBtn:SimpleButton, nextbtn:SimpleButton, totalPage:int = 0, currentPageTxt:TextField = null, totalPageTxt:TextField = null)
      {
         super();
         this._preBtn = preBtn;
         this._nextBtn = nextbtn;
         this._totalPage = totalPage;
         this._currentPageTxt = currentPageTxt;
         this._totalPageTxt = totalPageTxt;
         this._currentPage = 1;
         this.initEventListener();
         this.setStatus();
         this.updataTxt();
      }
      
      public function set totalPage(totalPage:int) : void
      {
         this._totalPage = totalPage;
         this._currentPage = 1;
         this.setStatus();
         this.updataTxt();
      }
      
      public function get totalPage() : int
      {
         return this._totalPage;
      }
      
      private function initEventListener() : void
      {
         this._preBtn.addEventListener("click",this.onPre);
         this._nextBtn.addEventListener("click",this.onNext);
      }
      
      private function onPre(evt:MouseEvent) : void
      {
         --this._currentPage;
         this.setStatus();
         this.updataTxt();
         dispatchEvent(new Event("pageChange"));
      }
      
      private function onNext(evt:MouseEvent) : void
      {
         ++this._currentPage;
         this.setStatus();
         this.updataTxt();
         dispatchEvent(new Event("pageChange"));
      }
      
      private function setStatus() : void
      {
         DisplayObjectUtil.enableButton(this._preBtn);
         DisplayObjectUtil.enableButton(this._nextBtn);
         if(this._currentPage <= 1)
         {
            DisplayObjectUtil.disableButton(this._preBtn);
         }
         if(this._currentPage >= this._totalPage)
         {
            DisplayObjectUtil.disableButton(this._nextBtn);
         }
      }
      
      private function updataTxt() : void
      {
         if(Boolean(this._currentPageTxt))
         {
            this._currentPageTxt.text = this._currentPage.toString();
         }
         if(Boolean(this._totalPageTxt))
         {
            this._totalPageTxt.text = this._totalPage.toString();
         }
         if(this._totalPage == 0 && this._currentPageTxt && Boolean(this._totalPageTxt))
         {
            this._currentPageTxt.text = "0";
            this._totalPageTxt.text = "0";
         }
      }
      
      public function set currentPage(currentPage:int) : void
      {
         this._currentPage = currentPage;
         this.setStatus();
         this.updataTxt();
         dispatchEvent(new Event("pageChange"));
      }
      
      public function get currentPage() : int
      {
         return this._currentPage;
      }
      
      public function dispose() : void
      {
         this._preBtn.removeEventListener("click",this.onPre);
         this._nextBtn.removeEventListener("click",this.onNext);
      }
   }
}
