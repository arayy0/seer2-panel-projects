package com.taomee.seer2.module.app.newPetStorage.view.storage
{
   import com.taomee.seer2.app.pet.data.PetInfo;
import com.taomee.seer2.core.ui.toolTip.TooltipManager;
import com.taomee.seer2.module.app.newPetStorage.view.StorageSubView;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class StorageMainPanel extends StorageSubView
   {
       
      
      private const SORT_CONFIG:* = {
         "sortByTime":0,
         "sortByLevel":2
      };
      
      private const PAGE_SIZE:int = 20;
      
      private var _cellList:Array;
      
      private var _currentPage:int = 0;
      
      private var _petList:Vector.<PetInfo>;
      
      private var _typeLimit:int = -1;
      
      public function StorageMainPanel(ui:MovieClip)
      {
         this._cellList = [];
         super(ui);
         this.init();
         moduleData.listenTo("pet_list",function():void
         {
            resetList();
         });
      }
      
      private function init() : void
      {
         var i:int;
         var petCell:PetCell = null;
         for(i = 0; i < 20; )
         {
            petCell = new PetCell(_ui["cell" + i],i);
            addSubPanel(petCell);
            this._cellList.push(petCell);
            i++;
         }
         addSubPanel(new PetTypeIconsPanel(_ui["typeIcons"]));
         for(i = 0; i < 6; )
         {
            _ui["star_" + i].mouseChildren = false;
            _ui["star_" + i].buttonMode = true;
            _ui["star_" + i].gotoAndStop(1);
            i++;
         }
         this.resetList();
         eventListenerMgr.addEventListener(_ui,"click",this.onClick);
         _ui["sortMc"]["optionMc"].visible = false;
         eventListenerMgr.addEventListener(_ui["sortMc"],"rollOver",function(e:*):void
         {
            _ui["sortMc"]["optionMc"].visible = true;
         });
         eventListenerMgr.addEventListener(_ui["sortMc"],"rollOut",function(e:*):void
         {
            _ui["sortMc"]["optionMc"].visible = false;
         });
         eventListenerMgr.addEventListener(_ui["search"],"focusIn",function(e:*):void
         {
            _ui["search"].text = "";
         });
         eventListenerMgr.addEventListener(_ui["search"],"focusOut",function(e:*):void
         {
            if(_ui["search"].text == "")
            {
               _ui["search"].text = "搜索名字或ID";
            }
         });
         moduleData.listenTo("query",function():void
         {
            _currentPage = 0;
            clearStarLimit();
            resetList();
         });
         TooltipManager.addCommonTip(this._ui["tips"],"持有精灵数量达到800时就可能会触发吞精灵的bug 请注意控制精灵数量");
      }
      
      private function onClick(e:MouseEvent) : void
      {
         var btnName:String = null;
         var targetType:int = 0;
         var str:String = null;
         btnName = String(e.target.name);
         var index:int = parseInt(btnName.split("_")[1]);
         switch(btnName)
         {
            case "freeBtn":
               moduleData.query.dataType = 1;
               moduleData.query.filterType = 3;
               TooltipManager.remove(this._ui["tips"]);
               TooltipManager.addCommonTip(this._ui["tips"],"按精灵获取时间排序 超过1000时之后放生的精灵会直接消失");
               this.resetList();
               break;
            case "storageBtn":
               moduleData.query.dataType = 0;
               moduleData.query.filterType = 3;
               this.resetList();
               break;
            case "next":
               this.setPage(this._currentPage + 1);
               break;
            case "pre":
               this.setPage(this._currentPage - 1);
               break;
            case "sortByTime":
            case "sortByLevel":
               this._currentPage = 0;
               if((targetType = int(this.SORT_CONFIG[btnName])) == moduleData.query.sortType)
               {
                  moduleData.query.isAscending = !moduleData.query.isAscending;
               }
               moduleData.query.sortType = targetType;
               this.resetList();
               _ui["sortMc"]["sortTxt"].text = btnName == "sortByTime" ? "时间" : "等级";
               break;
            case "allBtn":
               this.clearStarLimit();
               moduleData.query.filterType = 3;
               this._currentPage = 0;
               this.resetList();
               break;
            case "star_" + index:
               this.setStarLimit(index);
               break;
            case "zuoQiBtn":
               moduleData.query.filterType = 10000;
               this.resetList();
               break;
            case "find":
               this.clearStarLimit();
               str = String(_ui["search"].text);
               if(str == "")
               {
                  return;
               }
               if(parseInt(str) > 0)
               {
                  moduleData.query.filterType = 1;
                  moduleData.query.filterContent = parseInt(str);
               }
               else
               {
                  moduleData.query.filterType = 2;
                  moduleData.query.filterContent = str;
               }
               this._currentPage = 0;
               this.resetList();
               break;
         }
      }
      
      private function clearStarLimit() : void
      {
         var i:int = 0;
         for(i = 0; i < 6; )
         {
            _ui["star_" + i].gotoAndStop(1);
            i++;
         }
      }
      
      private function setStarLimit(limit:int) : void
      {
         var i:int;
         for(i = 0; i < 6; )
         {
            _ui["star_" + i].gotoAndStop(1);
            if(i <= limit)
            {
               _ui["star_" + i].gotoAndStop(2);
            }
            i++;
         }
         moduleData.query.filterType = 4;
         moduleData.listDataService.setCustomFilter(function(petInfo:PetInfo):Boolean
         {
            var result:* = petInfo.getPetDefinition().starLevel != limit + 1;
            if(_typeLimit == -1)
            {
               return result;
            }
            return result || petInfo.getPetDefinition().type != _typeLimit;
         });
         this._currentPage = 0;
         this.resetList();
      }
      
      private function resetList() : void
      {
         var btn:DisplayObject = moduleData.query.dataType == 1 ? _ui["freeBtn"] : _ui["storageBtn"];
         _ui["maskMc"].x = btn.x;
         _ui["maskMc"].y = btn.y;
         if(moduleData.query.filterType != 1 && moduleData.query.filterType != 2)
         {
            _ui["search"].text = "搜索名字或ID";
         }
         if(moduleData.query.filterType == 0)
         {
            this.clearStarLimit();
            this._typeLimit = moduleData.query.filterContent;
         }
         if(moduleData.query.filterType != 0 && moduleData.query.filterType != 4)
         {
            this._typeLimit = -1;
         }
         moduleData.listDataService.queryPetList(moduleData.query,function(list:Vector.<PetInfo>):void
         {
            _petList = list;
            setPage(_currentPage);
            if(moduleData.query.dataType == 0)
            {
               _ui["totalCount"].text = String(moduleData.listDataService.storageLength) + "/2999";
            }
            else
            {
               _ui["totalCount"].text = String(moduleData.listDataService.freeLength) + "/1000";
            }
         });
      }
      
      private function setPage(page:int) : void
      {
         var i:int = 0;
         var index:int = 0;
         var petCell:PetCell = null;
         if(this._petList == null)
         {
            return;
         }
         if(page >= this.allPageNum)
         {
            page = this.allPageNum - 1;
         }
         if(page < 0)
         {
            page = 0;
         }
         var startIndex:int = 20 * page;
         for(i = 0; i < 20; )
         {
            index = startIndex + i;
            petCell = this._cellList[i];
            if(index >= this._petList.length)
            {
               petCell.setPetInfo(null);
            }
            else
            {
               petCell.setPetInfo(this._petList[index]);
            }
            i++;
         }
         this._currentPage = page;
         _ui["page"].text = this._currentPage + 1 + "/" + this.allPageNum;
      }
      
      private function get allPageNum() : int
      {
         var result:int = Math.ceil(this._petList.length / 20);
         if(result == 0)
         {
            result = 1;
         }
         return result;
      }
   }
}
