package org.taomee.media
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   
   [Event(name="soundComplete",type="flash.events.Event")]
   public class SoundPlayer extends EventDispatcher
   {
      
      private var _sound:Sound;
      
      private var _soundChannel:SoundChannel;
      
      private var _autoStart:Boolean;
      
      private var _cyc:Boolean;
      
      private var _position:Number = 0;
      
      private var _soundState:int = SoundPlayerState.NOTLOADED;
      
      private var _url:String = "";
      
      private var _volume:Number = 1;
      
      public function SoundPlayer(url:String = "", autoStart:Boolean = false, cyc:Boolean = false)
      {
         super();
         this.load(url,autoStart,cyc);
      }
      
      public function get leftPeak() : Number
      {
         if(Boolean(this._soundChannel))
         {
            return this._soundChannel.leftPeak;
         }
         return NaN;
      }
      
      public function get rightPeak() : Number
      {
         if(Boolean(this._soundChannel))
         {
            return this._soundChannel.rightPeak;
         }
         return NaN;
      }
      
      public function get position() : Number
      {
         if(Boolean(this._soundChannel))
         {
            return this._soundChannel.position;
         }
         return NaN;
      }
      
      public function set position(value:Number) : void
      {
         var wasPlaying:Boolean = this._soundState == SoundPlayerState.PLAYING;
         this.pause();
         this._position = value;
         if(wasPlaying)
         {
            this.play();
         }
      }
      
      public function get duration() : Number
      {
         return this._sound.length;
      }
      
      public function get volume() : Number
      {
         return this._volume;
      }
      
      public function set volume(value:Number) : void
      {
         var transform:SoundTransform = null;
         this._volume = value;
         if(Boolean(this._soundChannel))
         {
            transform = this._soundChannel.soundTransform;
            transform.volume = value;
            this._soundChannel.soundTransform = transform;
         }
      }
      
      public function set autoStart(v:Boolean) : void
      {
         this._autoStart = v;
      }
      
      public function get autoStart() : Boolean
      {
         return this._autoStart;
      }
      
      public function set cyc(v:Boolean) : void
      {
         this._cyc = v;
      }
      
      public function get cyc() : Boolean
      {
         return this._cyc;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function get state() : int
      {
         return this._soundState;
      }
      
      public function load(url:String, autoStart:Boolean = false, cyc:Boolean = false) : void
      {
         if(url == null || url == "")
         {
            return;
         }
         if(this._url == url)
         {
            this.play();
            return;
         }
         this._url = url;
         this._sound = new Sound();
         this._sound.addEventListener(Event.OPEN,this.onLoadOpen);
         this._sound.addEventListener(ProgressEvent.PROGRESS,this.onLoadProgress);
         this._sound.addEventListener(Event.COMPLETE,this.onLoadComplete);
         this._sound.addEventListener(IOErrorEvent.IO_ERROR,this.onIoError);
         this._sound.load(new URLRequest(url));
         this._autoStart = autoStart;
         this._cyc = cyc;
      }
      
      public function play() : void
      {
         if(this._url == "")
         {
            return;
         }
         if(this._soundState == SoundPlayerState.NOTLOADED)
         {
            return;
         }
         if(this._soundState == SoundPlayerState.PLAYING)
         {
            return;
         }
         this.clearSoundChannel();
         this._soundChannel = this._sound.play(this._position);
         this.volume = this._volume;
         if(Boolean(this._soundChannel))
         {
            this._soundChannel.addEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
            this._soundState = SoundPlayerState.PLAYING;
         }
      }
      
      public function pause() : void
      {
         if(this._soundState == SoundPlayerState.NOTLOADED)
         {
            return;
         }
         if(this._soundChannel == null)
         {
            this._soundState = SoundPlayerState.PAUSED;
            return;
         }
         if(this._soundState == SoundPlayerState.PAUSED)
         {
            return;
         }
         this._position = this._soundChannel.position;
         this.clearSoundChannel();
         this._soundState = SoundPlayerState.PAUSED;
      }
      
      public function stop() : void
      {
         this.removeEvent();
         if(this._soundState == SoundPlayerState.NOTLOADED)
         {
            return;
         }
         if(this._soundChannel == null)
         {
            this._soundState = SoundPlayerState.STOPPED;
            return;
         }
         this._position = 0;
         this.clearSoundChannel();
         this._soundState = SoundPlayerState.STOPPED;
      }
      
      public function destroy() : void
      {
         this.stop();
         this._sound = null;
         this._soundChannel = null;
      }
      
      private function clearSoundChannel() : void
      {
         if(Boolean(this._soundChannel))
         {
            this._soundChannel.stop();
            this._soundChannel.removeEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
            this._soundChannel = null;
         }
      }
      
      private function onLoadOpen(e:Event) : void
      {
         this._sound.removeEventListener(Event.OPEN,this.onLoadOpen);
         this._sound.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoError);
         dispatchEvent(e);
         if(this._autoStart)
         {
            if(this._soundState == SoundPlayerState.PAUSED)
            {
               return;
            }
            this._soundState = SoundPlayerState.LOADED;
            this._position = 0;
            this.play();
         }
      }
      
      private function onLoadProgress(e:ProgressEvent) : void
      {
         dispatchEvent(e);
      }
      
      private function onLoadComplete(e:Event) : void
      {
         this._sound.removeEventListener(ProgressEvent.PROGRESS,this.onLoadProgress);
         this._sound.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         dispatchEvent(e);
      }
      
      private function onSoundComplete(e:Event) : void
      {
         this.stop();
         dispatchEvent(e);
         if(this._cyc)
         {
            this.play();
         }
      }
      
      private function onIoError(e:IOErrorEvent) : void
      {
         this.removeEvent();
         trace("SoundPlayer:IoError",this._url);
         this._soundState = SoundPlayerState.NOTLOADED;
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._sound))
         {
            this._sound.removeEventListener(Event.OPEN,this.onLoadOpen);
            this._sound.removeEventListener(IOErrorEvent.IO_ERROR,this.onIoError);
            this._sound.removeEventListener(ProgressEvent.PROGRESS,this.onLoadProgress);
            this._sound.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         }
      }
   }
}

