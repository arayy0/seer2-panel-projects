package org.taomee.manager
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Mouse;
   import org.taomee.utils.DisplayUtil;
   
   public class CursorManager
   {
      
      private static var _cursor:DisplayObject;
      
      private static var _offset:Point;
      
      public static var container:DisplayObjectContainer = TaomeeManager.stage;
      
      public function CursorManager()
      {
         super();
      }
      
      public static function removeCursor() : void
      {
         if(!_cursor)
         {
            return;
         }
         container.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
         DisplayUtil.removeForParent(_cursor);
         _cursor = null;
         Mouse.show();
      }
      
      public static function bringToFront() : void
      {
         if(Boolean(_cursor))
         {
            container.addChild(_cursor);
         }
      }
      
      private static function onMouseMove(e:MouseEvent) : void
      {
         _cursor.x = container.mouseX + _offset.x;
         _cursor.y = container.mouseY + _offset.y;
         e.updateAfterEvent();
      }
      
      public static function setCursor(pCursor:DisplayObject, offset:Point = null, isHide:Boolean = true) : void
      {
         if(Boolean(_cursor))
         {
            removeCursor();
         }
         if(isHide)
         {
            Mouse.hide();
         }
         _cursor = pCursor;
         if(_cursor is InteractiveObject)
         {
            InteractiveObject(_cursor).mouseEnabled = false;
            if(_cursor is DisplayObjectContainer)
            {
               DisplayObjectContainer(_cursor).mouseChildren = false;
            }
         }
         if(offset == null)
         {
            offset = new Point();
         }
         _offset = offset;
         _cursor.x = container.mouseX + _offset.x;
         _cursor.y = container.mouseY + _offset.y;
         container.addChild(_cursor);
         container.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
      }
   }
}

