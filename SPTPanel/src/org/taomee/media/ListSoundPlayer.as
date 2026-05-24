package org.taomee.media
{
   import flash.events.Event;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class ListSoundPlayer
   {
      
      private var _player:SoundPlayer;
      
      private var _enabled:Boolean = true;
      
      private var _list:Array = [];
      
      private var _index:int;
      
      private var _cyc:Boolean = true;
      
      private var _invID:uint;
      
      public function ListSoundPlayer()
      {
         super();
         this._player = new SoundPlayer();
         this._player.addEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
      }
      
      public function destroy() : void
      {
         this._player.removeEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
         this._player.destroy();
         this._player = null;
         this._list = null;
      }
      
      public function set volume(v:Number) : void
      {
         this._player.volume = v;
      }
      
      public function get volume() : Number
      {
         return this._player.volume;
      }
      
      public function set cyc(v:Boolean) : void
      {
         this._cyc = v;
      }
      
      public function get cyc() : Boolean
      {
         return this._cyc;
      }
      
      public function set enabled(b:Boolean) : void
      {
         this._enabled = b;
         if(this._enabled)
         {
            this.play2();
         }
         else
         {
            this.stop();
         }
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function hasURL(url:String) : Boolean
      {
         var info:SoundInfo = null;
         for each(info in this._list)
         {
            if(info.url == url)
            {
               return true;
            }
         }
         return false;
      }
      
      public function upDateRepInterval(url:String, repInv:Number) : void
      {
         var info:SoundInfo = null;
         for each(info in this._list)
         {
            if(info.url == url)
            {
               info.repInterval = repInv;
            }
         }
      }
      
      public function addPlay(url:String, repInv:Number) : void
      {
         var info:SoundInfo = new SoundInfo();
         info.url = url;
         info.repInterval = repInv;
         this._list.push(info);
      }
      
      public function clear() : void
      {
         clearTimeout(this._invID);
         this._list.length = 0;
      }
      
      public function play() : void
      {
         if(this._list.length == 0)
         {
            this.stop();
         }
         if(this._enabled)
         {
            this._index = 0;
            clearTimeout(this._invID);
            this.play2();
         }
      }
      
      public function stop() : void
      {
         clearTimeout(this._invID);
         this._player.stop();
      }
      
      private function play2() : void
      {
         var info:SoundInfo = this._list[this._index];
         if(Boolean(info))
         {
            if(info.url == this._player.url)
            {
               this._player.play();
            }
            else
            {
               this._player.load(info.url,true);
            }
         }
      }
      
      private function onSoundComplete(e:Event) : void
      {
         if(!this._enabled)
         {
            return;
         }
         var info:SoundInfo = this._list[this._index];
         if(Boolean(info))
         {
            if(info.repInterval > 0)
            {
               this._invID = setTimeout(this.onInvFunc,info.repInterval);
            }
            else
            {
               this.onInvFunc();
            }
         }
         else if(this._list.length > 0)
         {
            this.onInvFunc();
         }
      }
      
      private function onInvFunc() : void
      {
         ++this._index;
         if(this._index >= this._list.length)
         {
            this._index = 0;
            if(!this._cyc)
            {
               return;
            }
         }
         this.play2();
      }
   }
}

class SoundInfo
{
   
   public var url:String = "";
   
   public var repInterval:Number = 0;
   
   public function SoundInfo()
   {
      super();
   }
}
