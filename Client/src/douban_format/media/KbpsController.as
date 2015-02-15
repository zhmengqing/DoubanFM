package douban_format.media
{
    import com.douban.event.*;
    import com.douban.utils.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;
    import flash.utils.*;

    public class KbpsController extends EventDispatcher
    {
        var conn:LocalConnection;
        var playSong:Object;
        var lagTimes:int = 0;
        var lagDuration:Number = 0;
        var startDownloadTime:Number;
        var lg:Logger;
        var so:SharedObject;
        var downloadSpeed:Number;
        public static const KBPS:Array = ["64", "128", "192"];
        public static const DEF_K:int = 1;
        static const LAG_DURA_TO_DECR:Number = 10;
        static const LAG_TIMES_TO_DECR:int = 3;
        static const KEEP_SAFE_TIME:int = 300000;
        static const AVAIL_SPEED:Array = [0, 128 / 8 * 1.5, 192 / 8 * 1.5];

        public function KbpsController(param1:Object)
        {
            this.lg = param1.logger || new Logger();
            this.conn = new LocalConnection();
            this.conn.client = this;
            this.startListening();
            this.so = SharedObject.getLocal("douban_radio", "/");
            ExternalInterface.addCallback("setAutoKbps", this.setAutoKbps);
            ExternalInterface.addCallback("getAutoKbps", this.getAutoKbps);
            ExternalInterface.addCallback("setKbpsManually", this.setKbpsManually);
            ExternalInterface.addCallback("getKbps", this.getKbps);
            return;
        }// end function

        public function getKbps() : String
        {
            return this.so.data.kbps;
        }// end function

        public function setKbpsManuallyByRemote(param1:String) : void
        {
            ExternalInterface.call("on_set_kbps_by_remote", param1);
            return this.setKbpsManually(param1);
        }// end function

        private function startListening() : void
        {
            try
            {
                this.conn.connect("KbpsController");
                return;
            }
            catch (e)
            {
            }
            this.lg.log("other KC is listening, shut it down");
            try
            {
                this.conn.send("KbpsController", "stopListening");
                setTimeout(this.startListening, 500);
            }
            catch (e)
            {
            }
            return;
        }// end function

        public function stopListening() : void
        {
            this.conn.close();
            this.lg.log("KC stopped listening to the kbps settings");
            return;
        }// end function

        public function init() : void
        {
            this.setDefaultKbps();
            this.setKbps(this.so.data.kbps);
            return;
        }// end function

        public function setDefaultKbps() : void
        {
            if (!this.so.data.kbps || !this.so.data.autoKbps)
            {
                this.so.data.kbps = this.so.data.kbps || KBPS[DEF_K];
                this.so.data.autoKbps = this.so.data.autoKbps === false ? (false) : (true);
                this.so.flush();
            }
            this.lg.log("kbps init, kbps=" + this.so.data.kbps, "auto_kbps=" + this.so.data.autoKbps);
            return;
        }// end function

        public function onSongEvent(event:SongEvent) : void
        {
            var _loc_2:* = event.data;
            var _loc_3:* = _loc_2["song"];
            if (_loc_2["type"] == DBRadio.START)
            {
                if (!this.playSong || this.playSong.sid !== _loc_3.sid)
                {
                    this.playSong = _loc_3;
                    var _loc_4:* = 0;
                    this.downloadSpeed = 0;
                    this.lagTimes = _loc_4;
                    this.lagDuration = _loc_4;
                    this.startDownloadTime = getTimer();
                }
            }
            return;
        }// end function

        public function onLoadComplete(event:CompleteEvent) : void
        {
            if (this.so.data.autoKbps !== true)
            {
                this.lg.log("load complete, do nothing because autoKbps is false");
                return;
            }
            var _loc_2:* = getTimer() - this.startDownloadTime;
            if (_loc_2 > 0)
            {
                this.downloadSpeed = event.value / _loc_2;
                this.checkIfShouldGoUp();
            }
            return;
        }// end function

        private function checkIfShouldGoUp() : void
        {
            var _loc_3:* = null;
            var _loc_4:* = NaN;
            var _loc_1:* = KBPS.indexOf(this.so.data.kbps || KBPS[DEF_K]);
            var _loc_2:* = this.downloadSpeed < AVAIL_SPEED[1] ? (0) : (this.downloadSpeed < AVAIL_SPEED[2] ? (1) : (2));
            this.lg.log("load complete, downloadSpeed=", this.downloadSpeed.toFixed(1), "k/s", "kbps now:", KBPS[_loc_1], ", kbps can use:", KBPS[_loc_2]);
            if (_loc_1 < _loc_2)
            {
                this.lg.log("Network is fast, should go higher from", KBPS[_loc_1], "to", KBPS[_loc_2]);
                _loc_3 = this.so.data.badLog || {};
                _loc_4 = _loc_3["bad_at_" + KBPS[_loc_2]];
                this.lg.log("dt:", new Date().getTime() - _loc_4);
                if (_loc_4 && new Date().getTime() - _loc_4 < KEEP_SAFE_TIME)
                {
                    this.lg.log("but", KBPS[_loc_2], " went bad recently. Do nothing");
                    return;
                }
                this.kbpsShouldChange(_loc_2 - _loc_1);
            }
            return;
        }// end function

        public function setAutoKbps(param1:Boolean) : void
        {
            this.so.data.autoKbps = param1;
            this.so.flush();
            this.lg.log("kC set autoKbps to", param1);
            if (param1 && this.playSong && !this.playSong.changed)
            {
                this.lg.log("auto set to true, perform recheck");
                if (this.lagDuration >= LAG_DURA_TO_DECR)
                {
                    this.lg.log("[recheck] buffering too long, should get lower");
                    this.kbpsShouldChange(-1);
                }
                else if (this.lagTimes >= LAG_TIMES_TO_DECR)
                {
                    this.lg.log("[recheck] buffering too many times, should get lower");
                    this.kbpsShouldChange(-1);
                }
                else
                {
                    this.checkIfShouldGoUp();
                }
            }
            return;
        }// end function

        public function getAutoKbps() : Boolean
        {
            return this.so.data.autoKbps;
        }// end function

        public function setKbpsManually(param1:String) : void
        {
            this.lg.log("Externally set kbps=" + param1, " and autoKbps=false");
            if (KBPS.indexOf(param1) != -1)
            {
                this.setKbps(param1);
            }
            this.so.data.autoKbps = false;
            this.so.flush();
            return;
        }// end function

        private function setKbps(param1:String) : void
        {
            var _loc_2:* = new KbpsEvent(KbpsEvent.KBPS_SHOULD_CHANGE);
            _loc_2.doChange = true;
            var _loc_3:* = param1;
            _loc_2.value = param1;
            this.so.data.kbps = _loc_3;
            this.so.flush();
            this.lg.log("kbps is set to:", param1, " dispatch the setting!");
            dispatchEvent(_loc_2);
            return;
        }// end function

        private function suggestKbps(param1:String) : void
        {
            var _loc_2:* = new KbpsEvent(KbpsEvent.KBPS_SHOULD_CHANGE);
            _loc_2.doChange = false;
            _loc_2.value = this.so.data.kbps;
            this.lg.log("kbps", this.so.data.kbps, "seems too slow, dispatch the suggestion!");
            dispatchEvent(_loc_2);
            return;
        }// end function

        private function kbpsShouldChange(param1) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            if (param1 < 0)
            {
                _loc_3 = this.so.data.badLog || {};
                _loc_3["bad_at_" + this.so.data.kbps] = new Date().getTime();
                this.so.data.badLog = _loc_3;
                this.so.flush();
            }
            if (this.playSong.changed)
            {
                return;
            }
            this.playSong.changed = true;
            this.lg.log("kbps should change by", param1, "if possible.");
            var _loc_2:* = KBPS.indexOf(this.so.data.kbps || KBPS[DEF_K]);
            if (_loc_2 + param1 <= (KBPS.length - 1) && _loc_2 + param1 >= 0)
            {
                _loc_4 = KBPS[_loc_2 + param1];
                if (this.so.data.autoKbps)
                {
                    this.setKbps(_loc_4);
                }
                else
                {
                    this.suggestKbps(_loc_4);
                }
            }
            return;
        }// end function

        public function onPlayErrorEvent(event:PlayErrorEvent) : void
        {
            switch(event.error)
            {
                case PlayErrorEvent.ERROR_IOERROR:
                {
                    this.lg.log("kC found ioerror, ignore");
                    break;
                }
                case PlayErrorEvent.ERROR_LOAD_TIMEOUT:
                {
                    this.lg.log("kC found error_load_timeout, should get lower");
                    this.kbpsShouldChange(-1);
                    break;
                }
                case PlayErrorEvent.ERROR_BUFFERING:
                {
                    this.lagDuration = this.lagDuration + event.value / 1000;
                    this.lg.log("kC found buffer time=", event.value, ", sum time=", this.lagDuration);
                    if (event.value != AudioPlayer.REPORT_BUFF_INTERVAL)
                    {
                        var _loc_2:* = this;
                        var _loc_3:* = this.lagTimes + 1;
                        _loc_2.lagTimes = _loc_3;
                    }
                    if (this.lagDuration >= LAG_DURA_TO_DECR)
                    {
                        this.lg.log("buffering too long, should get lower");
                        this.kbpsShouldChange(-1);
                    }
                    else if (this.lagTimes >= LAG_TIMES_TO_DECR)
                    {
                        this.lg.log("buffering too many times, should get lower");
                        this.kbpsShouldChange(-1);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

    }
}
