package douban_format.media
{
    import douban_format.event.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class AudioPlayer extends EventDispatcher
    {
        public var soundLength:Number;
        public var percentBuffered:Number;
        private var _status:String;
        private var soundUrl:String;
        private var sound:Sound;
        private var channel:SoundChannel;
        private var tryTimes:int = 0;
        private var lg:Object;
        private var timer:Timer;
        private var idleTime:int = 0;
        private var holdTime:int = 0;
        private var recentPlayed:Number;
        private var position:Number;
        private var bufferStartTime:Number;
        private var bufferStartPos:Number;
        private var vol:Number = 1;
        private var infoLength:int = 0;
        public static const PLAY:String = "0";
        public static const PAUSE:String = "1";
        public static const STOP:String = "2";
        public static const REPORT_BUFF_INTERVAL:int = 1000;

        public function AudioPlayer(... args)
        {
            args = new activation;
            var args:* = args;
            this._status = STOP;
            var nfunc:* = function (... args) : void
            {
                return;
            }// end function
            ;
            this.lg = length > 0 ? ([0]) : ({log:});
            this.lg.report = this.lg.report || ;
            this.sound = new Sound();
            this.sound.addEventListener(IOErrorEvent.IO_ERROR, this.onSoundIOError);
            this.sound.addEventListener(ProgressEvent.PROGRESS, this.onSoundProgress);
            this.timer = new Timer(40);
            this.timer.addEventListener(TimerEvent.TIMER, this.onTimer);
            this.loadSound(this.url);
            return;
        }// end function

        private function onSoundProgress(event:ProgressEvent) : void
        {
            var _loc_2:* = null;
            if (event.bytesLoaded > 0 && event.bytesLoaded === event.bytesTotal)
            {
                _loc_2 = new CompleteEvent(CompleteEvent.LOAD_COMPLETE);
                _loc_2.value = event.bytesLoaded;
                dispatchEvent(_loc_2);
            }
            return;
        }// end function

        public function set url(param1:String) : void
        {
            this.loadSound(param1);
            return;
        }// end function

        public function get url() : String
        {
            return this.soundUrl;
        }// end function

        public function set volume(param1:Number) : void
        {
            this.vol = param1;
            if (this.channel)
            {
                this.channel.soundTransform = new SoundTransform(param1);
            }
            return;
        }// end function

        public function get volume() : Number
        {
            return this.vol;
        }// end function

        public function play(param1:String = null, param2:int = 0) : void
        {
            var url:* = param1;
            var len:* = param2;
            if (url && url != this.soundUrl)
            {
                this.loadSound(url);
                this.infoLength = int(len);
            }
            if (this._status != PAUSE)
            {
                this.position = 0;
            }
            if (this.channel)
            {
                this.channel.removeEventListener(Event.SOUND_COMPLETE, this.onComplete);
            }
            try
            {
                this.channel = this.sound.play(this.position);
            }
            catch (e:IOErrorEvent)
            {
                onSoundIOError(e);
            }
            this.channel.addEventListener(Event.SOUND_COMPLETE, this.onComplete);
            this.channel.soundTransform = new SoundTransform(this.vol);
            this._status = PLAY;
            this.timer.start();
            return;
        }// end function

        public function stop() : void
        {
            if (this.channel)
            {
                this.channel.stop();
            }
            this._status = STOP;
            this.timer.stop();
            return;
        }// end function

        public function pause() : void
        {
            if (this.channel)
            {
                this.channel.stop();
                this._status = PAUSE;
                this.timer.stop();
            }
            return;
        }// end function

        public function get status() : String
        {
            return this._status;
        }// end function

        public function seek(param1:Number) : void
        {
            if (this._status == PLAY && this.channel)
            {
                this.channel.stop();
                this.channel = this.sound.play(this.soundLength * param1);
            }
            else
            {
                this.channel = this.sound.play(this.soundLength * param1);
                this.position = this.channel.position;
                this.channel.stop();
            }
            this.channel.soundTransform = new SoundTransform(this.vol);
            return;
        }// end function

        private function loadSound(param1:String = null) : void
        {
            var url:* = param1;
            if (url)
            {
                if (this.channel)
                {
                    this.channel.stop();
                }
                try
                {
                    this.sound.close();
                    this.sound.removeEventListener(IOErrorEvent.IO_ERROR, this.onSoundIOError);
                    this.sound.removeEventListener(ProgressEvent.PROGRESS, this.onSoundProgress);
                }
                catch (e:Error)
                {
                }
                this.soundUrl = url;
                this.sound = new Sound();
                this.sound.addEventListener(IOErrorEvent.IO_ERROR, this.onSoundIOError);
                this.sound.addEventListener(ProgressEvent.PROGRESS, this.onSoundProgress);
                try
                {
                    this.sound.load(new URLRequest(this.soundUrl));
                }
                catch (e:IOErrorEvent)
                {
                    onSoundIOError(e);
                }
            }
            return;
        }// end function

        public function get progress() : Number
        {
            var pos:Number;
            if (this.channel)
            {
                try
                {
                    pos = this.channel.position;
                }
                catch (e:Error)
                {
                    pos;
                }
            }
            return pos;
        }// end function

        private function onTimer(event:TimerEvent) : void
        {
            var dt:int;
            var loaded:Number;
            var total:Number;
            var percentPlayed:Number;
            var event:* = event;
            try
            {
                loaded = this.sound.bytesLoaded;
                total = this.sound.bytesTotal;
                this.position = this.channel.position;
                this.percentBuffered = loaded / total;
                if (this.infoLength)
                {
                    this.soundLength = this.infoLength * 1000;
                }
                else
                {
                    this.soundLength = this.sound.length;
                    this.soundLength = this.soundLength / this.percentBuffered;
                }
                percentPlayed = this.position / this.soundLength;
            }
            catch (e:Error)
            {
                lg.log(e.message);
                return;
            }
            if (this.idleTime > 25 * 2)
            {
                this.idleTime = 0;
                this.onComplete();
                return;
            }
            if (this.holdTime > 25 * 13)
            {
                this.holdTime = 0;
                this.lg.report("not_play pos:" + loaded + "/" + total + " percent played:" + percentPlayed + " " + this.soundUrl, "ra000");
                this.onError(PlayErrorEvent.ERROR_LOAD_TIMEOUT);
            }
            if (this.sound.isBuffering)
            {
                if (this.bufferStartTime)
                {
                    dt = getTimer() - this.bufferStartTime;
                    if (dt > REPORT_BUFF_INTERVAL)
                    {
                        this.onError(PlayErrorEvent.ERROR_BUFFERING, REPORT_BUFF_INTERVAL);
                        this.bufferStartTime = getTimer();
                    }
                }
                else
                {
                    this.bufferStartTime = getTimer();
                    this.bufferStartPos = this.position;
                }
            }
            else if (this.bufferStartTime)
            {
                dt = getTimer() - this.bufferStartTime;
                if (dt < REPORT_BUFF_INTERVAL)
                {
                    this.onError(PlayErrorEvent.ERROR_BUFFERING, dt);
                }
                this.bufferStartTime = 0;
            }
            if (this.sound.isBuffering && this.position == 0)
            {
                this.onPosition(0);
            }
            else if (this._status == PLAY)
            {
                this.onPosition(this.position);
            }
            if (this._status == PLAY && (percentPlayed === this.recentPlayed || isNaN(percentPlayed)))
            {
                var _loc_3:* = this;
                var _loc_4:* = this.holdTime + 1;
                _loc_3.holdTime = _loc_4;
            }
            else
            {
                this.holdTime = 0;
            }
            if (percentPlayed === this.recentPlayed && percentPlayed > 0.5 && !this.sound.isBuffering && this._status == PLAY && this.position > 0)
            {
                if (this.infoLength && this.position / 1000 >= this.infoLength || percentPlayed >= 1)
                {
                    this.onComplete();
                    return;
                }
                var _loc_3:* = this;
                var _loc_4:* = this.idleTime + 1;
                _loc_3.idleTime = _loc_4;
            }
            else
            {
                this.idleTime = 0;
            }
            if (percentPlayed > this.recentPlayed)
            {
                this.tryTimes = 0;
            }
            this.recentPlayed = percentPlayed;
            return;
        }// end function

        private function onSoundIOError(event:IOErrorEvent) : void
        {
            var f:Function;
            var e:* = event;
            this.lg.report("sound_ioerror " + this.soundUrl + " " + (this.tryTimes + 1) + " times. " + e.text, "ra009");
            this.lg.log("load sound io error:" + e.toString() + " retry in 2 secs");
            if (this.tryTimes >= 2)
            {
                this.tryTimes = 0;
                this.onError(PlayErrorEvent.ERROR_IOERROR);
                this.timer.stop();
            }
            else
            {
                var _loc_3:* = this;
                var _loc_4:* = this.tryTimes + 1;
                _loc_3.tryTimes = _loc_4;
                f = function () : void
            {
                sound.close();
                sound.load(new URLRequest(soundUrl));
                return;
            }// end function
            ;
                setTimeout(this.loadSound, 2000, this.soundUrl);
            }
            return;
        }// end function

        private function onError(param1:String, param2:Number = 0) : void
        {
            var _loc_3:* = new PlayErrorEvent();
            _loc_3.error = param1;
            _loc_3.value = param2;
            if (_loc_3.error == PlayErrorEvent.ERROR_BUFFERING)
            {
                _loc_3.position = this.bufferStartPos;
            }
            dispatchEvent(_loc_3);
            return;
        }// end function

        private function onComplete(... args) : void
        {
            args = new activation;
            var e:* = args;
            this.timer.stop();
            if (this.channel)
            {
                try
                {
                    this.channel.stop();
                }
                catch (e:Error)
                {
                    lg.log(e.message);
                }
            }
            this._status = STOP;
            var _loc_3:* = 0;
            this.idleTime = 0;
            this.holdTime = _loc_3;
            var ev:* = new CompleteEvent(CompleteEvent.COMPLETE);
            dispatchEvent();
            return;
        }// end function

        private function onPosition(param1:Number) : void
        {
            var _loc_2:* = new PositionEvent();
            _loc_2.position = param1;
            dispatchEvent(_loc_2);
            return;
        }// end function

    }
}
