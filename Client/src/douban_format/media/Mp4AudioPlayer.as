package douban_format.media
{
    import com.douban.event.*;
    import flash.events.*;
    import flash.media.*;
    import flash.net.*;
    import flash.utils.*;

    public class Mp4AudioPlayer extends EventDispatcher
    {
        public var soundLength:Number = 0;
        public var percentBuffered:Number = 0;
        private var infoLength:int = 0;
        private var soundUrl:String;
        private var nc:NetConnection;
        private var ns:NetStream;
        private var _status:String = "2";
        private var vol:Number = 1;
        private var myTransform:SoundTransform;
        private var timer:Timer;
        private var lg:Object;
        private var loadedEventSent:Boolean = false;
        private var recentPlayed:Number;
        private var holdTime:int = 0;
        public static const PLAY:String = "0";
        public static const PAUSE:String = "1";
        public static const STOP:String = "2";

        public function Mp4AudioPlayer(... args)
        {
            args = new activation;
            var args:* = args;
            this.myTransform = new SoundTransform();
            this.timer = new Timer(40);
            var nfunc:* = function (... args) : void
            {
                return;
            }// end function
            ;
            this.lg = length > 0 ? ([0]) : ({log:});
            this.lg.report = this.lg.report || ;
            this.nc = new NetConnection();
            this.nc.addEventListener(NetStatusEvent.NET_STATUS, this.netStatusHandler);
            this.nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
            this.timer.addEventListener(TimerEvent.TIMER, this.onTimeUpdate);
            return;
        }// end function

        private function netStatusHandler(event:NetStatusEvent) : void
        {
            switch(event.info.code)
            {
                case "NetConnection.Connect.Success":
                {
                    this.connectStream();
                    break;
                }
                case "NetStream.Play.Stop":
                {
                    if (Math.abs(this.soundLength - this.getCurrentTime()) < 150)
                    {
                        this.onComplete();
                    }
                    break;
                }
                case "NetStream.Play.StreamNotFound":
                {
                    this.lg.report("sound_ioerror " + this.soundUrl, "ra009");
                    this.lg.log("load sound io error:" + event.info);
                    this.onError(PlayErrorEvent.ERROR_IOERROR);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function set url(param1:String) : void
        {
            this.play(param1);
            return;
        }// end function

        public function get url() : String
        {
            return this.soundUrl;
        }// end function

        private function securityErrorHandler(event:SecurityErrorEvent) : void
        {
            this.onError(PlayErrorEvent.ERROR_SECURITY_ERROR);
            return;
        }// end function

        private function connectStream() : void
        {
            this.timer.start();
            var _loc_1:* = new Object();
            _loc_1.onMetaData = this.onMetaDataHandler;
            this.ns = new NetStream(this.nc);
            this.ns.addEventListener(NetStatusEvent.NET_STATUS, this.netStatusHandler);
            this.ns.client = _loc_1;
            this.setVolume(this.vol);
            this.ns.play(this.soundUrl);
            this._status = PLAY;
            this.loadedEventSent = false;
            return;
        }// end function

        public function stop() : void
        {
            if (this.ns != null)
            {
                this.ns.close();
                this.timer.stop();
                this._status = STOP;
                this.soundUrl = null;
            }
            return;
        }// end function

        public function play(param1:String = null, param2:int = 0) : void
        {
            this.timer.start();
            if (this._status == PAUSE)
            {
                this.ns.resume();
                this._status = PLAY;
            }
            else if (param1 != null)
            {
                if (this.ns != null)
                {
                    this.ns.close();
                }
                this.soundUrl = param1;
                this.nc.connect(null);
                this.infoLength = int(param2);
            }
            return;
        }// end function

        public function pause() : void
        {
            if (this.ns != null)
            {
                this.ns.pause();
                this._status = PAUSE;
                this.timer.stop();
            }
            return;
        }// end function

        private function onComplete() : void
        {
            this.timer.stop();
            this._status = STOP;
            var _loc_1:* = new CompleteEvent(CompleteEvent.COMPLETE);
            dispatchEvent(_loc_1);
            return;
        }// end function

        public function set volume(param1:Number) : void
        {
            this.setVolume(param1);
            return;
        }// end function

        public function get volume() : Number
        {
            return this.vol;
        }// end function

        public function get status() : String
        {
            return this._status;
        }// end function

        private function setVolume(param1:Number) : void
        {
            this.vol = param1;
            this.myTransform.volume = param1;
            if (this.ns != null)
            {
                this.ns.soundTransform = this.myTransform;
            }
            return;
        }// end function

        private function onTimeUpdate(param1) : void
        {
            var _loc_4:* = null;
            var _loc_2:* = this.getCurrentTime();
            this.percentBuffered = this.ns.bytesTotal > 0 ? (this.ns.bytesLoaded / this.ns.bytesTotal) : (0);
            var _loc_3:* = new PositionEvent();
            _loc_3.position = _loc_2;
            dispatchEvent(_loc_3);
            if (!this.loadedEventSent && this.percentBuffered == 1)
            {
                _loc_4 = new CompleteEvent(CompleteEvent.LOAD_COMPLETE);
                _loc_4.value = this.ns.bytesLoaded;
                dispatchEvent(_loc_4);
                this.loadedEventSent = true;
            }
            if (this._status == PLAY && _loc_2 === this.recentPlayed)
            {
                var _loc_5:* = this;
                var _loc_6:* = this.holdTime + 1;
                _loc_5.holdTime = _loc_6;
            }
            else
            {
                this.holdTime = 0;
            }
            this.recentPlayed = _loc_2;
            if (this.holdTime > 25 * 13)
            {
                this.holdTime = 0;
                this.lg.report("not_play pos:" + this.ns.bytesLoaded + "/" + this.ns.bytesTotal + " " + this.soundUrl, "ra000");
                this.onError(PlayErrorEvent.ERROR_LOAD_TIMEOUT);
            }
            return;
        }// end function

        public function get progress() : Number
        {
            return this.getCurrentTime();
        }// end function

        public function getCurrentTime() : Number
        {
            return this.ns != null ? (this.ns.time * 1000) : (0);
        }// end function

        public function onMetaDataHandler(param1:Object) : void
        {
            this.soundLength = param1.duration * 1000;
            return;
        }// end function

        private function onError(param1:String, param2:Number = 0) : void
        {
            var _loc_3:* = new PlayErrorEvent();
            _loc_3.error = param1;
            _loc_3.value = param2;
            dispatchEvent(_loc_3);
            return;
        }// end function

    }
}
