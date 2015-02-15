package douban_format.media
{
    import com.adobe.serialization.json.*;
    import com.douban.event.*;
    import com.douban.utils.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;
    import flash.utils.*;

    public class DBRadio extends EventDispatcher
    {
        private var currSong:Object;
        private var lg:Object;
        private var player:Object;
        private var vplayer:Object;
        private var mp3player:AudioPlayer;
        private var mp4player:Mp4AudioPlayer;
        private var listLoader:Object;
        private var playoutLoader:Object;
        private var repLoader:URLLoader;
        private var _start:String = "";
        private var _fromStr:String = "";
        private var playList:Array;
        private var startNewList:Boolean = true;
        private var reportedId:String;
        private var _channel:String = "1";
        private var HOST:String;
        private var LISTURL:String;
        private var timeToWait:int = 0;
        private var requrl:String;
        private var context:String;
        private var pauseTime:Number = 0;
        private var _started:Boolean = false;
        private var _playMode:String = "Pr";
        private var _kbps:String = "";
        private var _tags:String = "";
        private var _artist_id:String = "";
        private var playListEmptyTime:Number = 0;
        private var _muted:Boolean = false;
        private var _vol:Number = 1;
        public static const PLAYOUT:Object = "p";
        public static const PLAYED:Object = "e";
        public static const LIKE:Object = "r";
        public static const BAN:Object = "b";
        public static const UNLIKE:Object = "u";
        public static const NEW:Object = "n";
        public static const SKIP:Object = "s";
        public static const SUBTYPE_AD:Object = "T";
        public static const ADTYPE_AUDIO:Object = "3";
        public static const ADTYPE_VIDEO:Object = "4";
        public static const START:Object = "start";
        public static const NEW_LIST:Object = "nl";
        public static const LIST_ZERO_ERROR:Object = "lze";
        public static const LIST_PARSE_ERROR:Object = "lpe";
        public static const LIST_SERVER_ERROR:Object = "lse";
        public static const LIST_SERVER_WARN:Object = "lsw";
        public static const LIST_IOERROR:Object = "lioe";
        public static const CHANNEL_OFFLINE_ERROR:Object = "2";
        public static const PERSONAL_CHANNEL:Object = "0";
        public static const RED_HEART_CHANNEL:Object = "-3";
        public static const PERSONAL_HIGH_CHANNEL:Object = "-4";
        public static const PERSONAL_EASY_CHANNEL:Object = "-5";
        public static const RED_HEART_HIGH_CHANNEL:Object = "-6";
        public static const RED_HEART_EASY_CHANNEL:Object = "-7";
        public static const RED_HEART_TAGS_CHANNEL:Object = "-8";
        public static const PERSONAL_TAGS_CHANNEL:Object = "-9";
        public static const RAND:Object = "Pr";
        public static const SESSION:Object = "Ps";

        public function DBRadio(param1:Object)
        {
            this.playList = [];
            this.HOST = param1.host;
            this.context = param1.context || "";
            this._start = param1.start || "";
            this._fromStr = param1.from || "";
            this.lg = param1.logger;
            this.LISTURL = this.HOST + "/j/mine/playlist";
            this.init();
            return;
        }// end function

        private function init() : void
        {
            this.mp3player = new AudioPlayer({log:this.lg.log, report:this.lg.report});
            this.mp3player.addEventListener(CompleteEvent.COMPLETE, this.onComplete);
            this.mp3player.addEventListener(CompleteEvent.LOAD_COMPLETE, this.onLoadComplete);
            this.mp3player.addEventListener(PlayErrorEvent.PLAY_ERROR, this.onPlayError);
            this.mp3player.addEventListener(PositionEvent.ON_POSITION, this.onPosition);
            this.mp4player = new Mp4AudioPlayer({log:this.lg.log, report:this.lg.report});
            this.mp4player.addEventListener(CompleteEvent.COMPLETE, this.onComplete);
            this.mp4player.addEventListener(CompleteEvent.LOAD_COMPLETE, this.onLoadComplete);
            this.mp4player.addEventListener(PlayErrorEvent.PLAY_ERROR, this.onPlayError);
            this.mp4player.addEventListener(PositionEvent.ON_POSITION, this.onPosition);
            this.vplayer = new ExtVideoPlayer(this.lg);
            this.vplayer.addEventListener(CompleteEvent.COMPLETE, this.onComplete);
            this.vplayer.addEventListener(PlayErrorEvent.PLAY_ERROR, this.onPlayError);
            this.player = this.mp3player;
            this.listLoader = new URLLoader();
            this.playoutLoader = new URLLoader();
            this.listLoader.addEventListener(IOErrorEvent.IO_ERROR, this.loaderIOError);
            this.playoutLoader.addEventListener(IOErrorEvent.IO_ERROR, this.loaderIOError);
            this.listLoader.addEventListener(Event.COMPLETE, this.onListLoad);
            this.playoutLoader.addEventListener(Event.COMPLETE, this.onListLoad);
            this.repLoader = new URLLoader();
            this.repLoader.addEventListener(IOErrorEvent.IO_ERROR, this.onReportIoError);
            ExternalInterface.addCallback("list_onload", this.onJsListload);
            ExternalInterface.addCallback("list_onerror", this.loaderIOError);
            return;
        }// end function

        public function onKbpsShouldChange(event:KbpsEvent) : void
        {
            this.lg.log("DBRadio received kbps_should_change event -> " + event.value);
            if (event.doChange)
            {
                this._kbps = event.value;
                if (this._started)
                {
                    this.playList = [];
                    this.requireList(NEW);
                }
            }
            else
            {
                this.lg.log("DBRadio suggest js too slow:", event.value);
                ExternalInterface.call("DBR.suggest_kbps", event.value);
            }
            return;
        }// end function

        public function start() : void
        {
            if (!this._started)
            {
                this.requireList(NEW);
                this._started = true;
            }
            return;
        }// end function

        public function pause() : void
        {
            this.pauseTime = getTimer();
            this.player.pause();
            return;
        }// end function

        public function resume() : void
        {
            if (this.player.status != AudioPlayer.PAUSE)
            {
                return;
            }
            this.player.play();
            if ((getTimer() - this.pauseTime) / 1000 > 60 * 30)
            {
                this.playList = [];
                this.requireList(NEW);
            }
            return;
        }// end function

        public function like() : void
        {
            this.currSong.like = true;
            this.startNewList = false;
            this.onStatus(LIKE);
            return;
        }// end function

        public function unlike() : void
        {
            this.currSong.like = false;
            this.startNewList = false;
            this.onStatus(UNLIKE);
            return;
        }// end function

        public function get isLiked() : Boolean
        {
            return this.currSong && this.currSong.like;
        }// end function

        public function ban() : void
        {
            this.onStatus(BAN);
            this.playNext();
            return;
        }// end function

        public function skip() : void
        {
            this.onStatus(SKIP);
            this.playNext();
            return;
        }// end function

        public function onAdjustVolume(param1) : void
        {
            this._vol = param1.percent;
            if (!this._muted)
            {
                this.player.volume = param1.percent;
            }
            return;
        }// end function

        public function set volume(param1) : void
        {
            this._vol = param1;
            if (!this._muted)
            {
                this.player.volume = param1;
            }
            return;
        }// end function

        public function get volume() : Number
        {
            return this.player.volume;
        }// end function

        public function mute() : void
        {
            this.player.volume = 0;
            this._muted = true;
            return;
        }// end function

        public function unmute() : void
        {
            if (this._muted)
            {
                this._muted = false;
                this.player.volume = this._vol;
            }
            return;
        }// end function

        public function get isMuted() : Boolean
        {
            return this._muted;
        }// end function

        public function setChannel(param1:String, param2:String = "", param3:String = "", param4:Boolean = false, param5:String = "") : void
        {
            if (param1 === this._channel && param2 === this._tags && param3 === this._artist_id)
            {
                return;
            }
            this._channel = param1;
            this._tags = param2;
            this._artist_id = param3;
            this._start = param5;
            if (param4)
            {
                this.playList = [];
                this.requireList(NEW);
            }
            else if (this._started)
            {
                this.playList = [];
                this.requireList(NEW);
                this.playNext();
            }
            return;
        }// end function

        public function get channel() : String
        {
            return this._channel;
        }// end function

        public function get soundLength() : Number
        {
            return this.player.soundLength;
        }// end function

        public function get sid() : String
        {
            return this.currSong.sid;
        }// end function

        private function onStatus(param1:String) : void
        {
            var playObj:*;
            var repurl:String;
            var type:* = param1;
            var songEv:* = new SongEvent();
            songEv.data = {type:type, song:this.currSong, channel:this._channel};
            dispatchEvent(songEv);
            if (type == PLAYED)
            {
                playObj = this.currSong.adtype == ADTYPE_VIDEO ? (this.vplayer) : (this.player);
                repurl = this.LISTURL + "?type=e&sid=" + this.currSong.sid + "&channel=" + this._channel + "&pt=" + (playObj.progress / 1000).toFixed(1) + "&pb=" + this.currSong.kbps;
                repurl = repurl + (this._fromStr ? ("&from=" + this._fromStr) : (""));
                repurl = Format.signUrl(repurl);
                try
                {
                    this.repLoader.load(new URLRequest(repurl));
                }
                catch (e)
                {
                    onReportIoError(e);
                }
            }
            else
            {
                this.requireList(type);
            }
            if ([LIKE, UNLIKE, BAN, SKIP].indexOf(type) != -1 && this._playMode != SESSION)
            {
                this.playList = [];
            }
            return;
        }// end function

        private function playCurrSong() : void
        {
            if (this.currSong.adtype == ADTYPE_VIDEO)
            {
                this.vplayer.play(this.currSong);
            }
            else
            {
                if (true)
                {
                    this.player = /.*\.mp3$"".*\.mp3$/i.test(this.currSong.url) ? (this.mp3player) : (this.mp4player);
                }
                this.player.play(this.currSong.url, this.currSong.len);
            }
            return;
        }// end function

        private function playNext() : void
        {
            var _loc_1:* = null;
            this.player.stop();
            if (this.playList.length >= 1)
            {
                this.currSong = this.playList.shift();
                this.lg.log("now start to play:", this.currSong.title, this.currSong.artist, this.currSong.sid, this.currSong.url, this.currSong.extrainfo);
                if (this.playList.length === 0)
                {
                    this.onPlayListEmpty();
                }
                _loc_1 = new SongEvent();
                _loc_1.data = {type:START, song:this.currSong, channel:this._channel};
                dispatchEvent(_loc_1);
                this.playCurrSong();
            }
            else
            {
                this.startNewList = true;
            }
            return;
        }// end function

        private function onPlayListEmpty() : void
        {
            var delayTime:Number;
            var nowTime:* = getTimer();
            if (this.playListEmptyTime && nowTime - this.playListEmptyTime < 2000)
            {
                this.lg.log("warning: too many PLAYOUT, delay 3 seconds.");
                delayTime;
            }
            this.playListEmptyTime = nowTime;
            setTimeout(function ()
            {
                requireList(PLAYOUT);
                return;
            }// end function
            , delayTime);
            return;
        }// end function

        private function requireList(param1:String) : void
        {
            var _loc_2:* = this.currSong ? (this.currSong.sid) : ("");
            this.requrl = this.LISTURL + "?type=" + param1 + "&sid=" + _loc_2 + "&pt=" + (this.player.progress / 1000).toFixed(1) + "&channel=" + this._channel;
            var _loc_3:* = [];
            if (this._tags && (this._channel === RED_HEART_TAGS_CHANNEL || this._channel === PERSONAL_TAGS_CHANNEL || this._channel === PERSONAL_CHANNEL))
            {
                _loc_3.push("tags:" + this._tags);
            }
            if (this._channel === PERSONAL_CHANNEL && this._artist_id !== "")
            {
                _loc_3.push("artist_id:" + this._artist_id);
            }
            if (this.context !== "")
            {
                _loc_3.push(this.context);
                this.context = "";
            }
            if (_loc_3.length)
            {
                this.requrl = this.requrl + ("&context=" + _loc_3.join("|"));
            }
            if (this.currSong)
            {
                this.requrl = this.requrl + ("&pb=" + this.currSong.kbps);
            }
            if (this._start != "")
            {
                this.requrl = this.requrl + ("&start=" + this._start);
                this._start = "";
            }
            this.requrl = this.requrl + (this._fromStr ? ("&from=" + this._fromStr) : (""));
            if (this._kbps != "")
            {
                this.requrl = this.requrl + ("&kbps=" + this._kbps);
            }
            this.requrl = Format.signUrl(this.requrl);
            this.lg.log("DBRadio loading:", this.requrl);
            var _loc_4:* = param1 === PLAYOUT ? (this.playoutLoader) : (this.listLoader);
            try
            {
                _loc_4.close();
            }
            catch (e)
            {
            }
            _loc_4.load(new URLRequest(this.requrl));
            return;
        }// end function

        private function waitTime() : int
        {
            this.timeToWait = this.timeToWait * 2 + 1;
            return this.timeToWait;
        }// end function

        private function loaderIOError(param1) : void
        {
            var e:* = param1;
            var ev:* = new ListEvent();
            ev.message = {error:LIST_IOERROR, msg:""};
            dispatchEvent(ev);
            var wTime:* = this.waitTime();
            if (wTime == 5)
            {
                this.lg.report("always_load_fail ", "ra005");
                if (ExternalInterface.call("DBR.radio_getlist", this.requrl) != 0)
                {
                    this.lg.log("now use js to try");
                    return;
                }
                this.lg.log("js not avail");
            }
            this.lg.log("IOError, retry in " + wTime + " secs");
            var f:* = function () : void
            {
                try
                {
                    listLoader.close();
                }
                catch (e)
                {
                }
                listLoader.load(new URLRequest(requrl));
                return;
            }// end function
            ;
            setTimeout(f, wTime * 1000);
            return;
        }// end function

        private function onListLoad(event:Event)
        {
            this.processList(event.target.data);
            return;
        }// end function

        public function onJsListload(param1:String) : void
        {
            this.processList(param1);
            return;
        }// end function

        private function processList(param1:String) : void
        {
            var ev:ListEvent;
            var songJson:Object;
            var song:Object;
            var listData:* = param1;
            ev = new ListEvent();
            try
            {
                songJson = JSON.decode(listData);
                if (typeof(songJson) != "object")
                {
                    throw new Error();
                }
            }
            catch (e)
            {
                lg.log("json parse error:" + e, listData, requrl);
                loaderIOError("json_parse_error");
                ev.message = {error:LIST_PARSE_ERROR, msg:"Playlist parse error"};
                dispatchEvent(ev);
                return;
            }
            var isLogout:* = songJson["logout"];
            if (isLogout == 1)
            {
                dispatchEvent(new LogoutEvent());
            }
            var error:* = songJson["err"];
            if (error != null)
            {
                this.lg.log("service return error:", error);
                ev.message = {error:LIST_SERVER_ERROR, msg:error};
                dispatchEvent(ev);
                return;
            }
            var warning:* = songJson["warning"];
            if (warning != null)
            {
                this.lg.log("service return warning:", warning);
                ev.message = {warning:LIST_SERVER_WARN, msg:warning};
                dispatchEvent(ev);
            }
            this._playMode = songJson.kind == "session" ? (SESSION) : (RAND);
            var i:int;
            while (i < songJson.song.length)
            {
                
                song = songJson.song[i];
                this.lg.log("[" + song["title"] + " / " + song["artist"] + " / " + song["sid"] + " / " + (song["kbps"] || "(no kbps)") + "]");
                this.playList.push({sid:song["sid"], url:song["url"], ssid:song["ssid"], artist:song["artist"] || "", title:song["title"], picture:song["picture"].replace("/mpic/", "/lpic/").replace("//otho.", "//img3."), album:song["album"], album_id:song["aid"], albumtitle:song["albumtitle"], like:song["like"] == "1", subtype:song["subtype"], adtype:song["adtype"], len:int(song["length"]), kbps:song["kbps"] || "", monitor_url:song["monitor_url"] || "", pubtime:song["public_time"] || "", extrainfo:song["alg_info"] || "", songlists_count:song["songlists_count"] || 0});
                i = (i + 1);
            }
            var songEv:* = new SongEvent();
            songEv.data = {r:songJson.r, type:NEW_LIST, playlist:this.playList, channel:this._channel, is_show_quick_start:songJson["is_show_quick_start"]};
            dispatchEvent(songEv);
            if (this.playList.length > 0)
            {
                this.timeToWait = 0;
                if (this.startNewList)
                {
                    this.startNewList = false;
                    this.playNext();
                }
            }
            return;
        }// end function

        private function onComplete(event:CompleteEvent) : void
        {
            this.onStatus(PLAYED);
            this.playNext();
            return;
        }// end function

        private function onLoadComplete(event:CompleteEvent) : void
        {
            var _loc_2:* = new CompleteEvent(CompleteEvent.LOAD_COMPLETE);
            _loc_2.value = event.value;
            dispatchEvent(_loc_2);
            return;
        }// end function

        private function onPlayError(event:PlayErrorEvent) : void
        {
            switch(event.error)
            {
                case PlayErrorEvent.ERROR_IOERROR:
                {
                    if (this.playList.lenth <= 1)
                    {
                        this.requireList(PLAYOUT);
                    }
                    this.playNext();
                    break;
                }
                case PlayErrorEvent.ERROR_LOAD_TIMEOUT:
                {
                    if (this.playList.lenth <= 1)
                    {
                        this.requireList(PLAYOUT);
                    }
                    this.playNext();
                    break;
                }
                case PlayErrorEvent.ERROR_BUFFERING:
                {
                    if (this.reportedId != this.currSong.sid && event.position !== 0)
                    {
                        this.lg.report("play_slow " + this.currSong.url, "ra008");
                        this.reportedId = this.currSong.sid;
                    }
                    break;
                }
                default:
                {
                    if (this.playList.lenth <= 1)
                    {
                        this.requireList(PLAYOUT);
                    }
                    this.playNext();
                    break;
                }
            }
            var _loc_2:* = new PlayErrorEvent();
            _loc_2.error = event.error;
            _loc_2.value = event.value;
            dispatchEvent(_loc_2);
            return;
        }// end function

        private function onReportIoError(event:IOErrorEvent) : void
        {
            this.lg.log("fail when reporting:" + event.toString());
            return;
        }// end function

        private function onPosition(event:PositionEvent) : void
        {
            var _loc_2:* = new PositionEvent();
            _loc_2.position = event.position;
            if (this._muted)
            {
                this.player.volume = 0;
            }
            dispatchEvent(_loc_2);
            return;
        }// end function

        public function getPlayList() : Array
        {
            return this.playList;
        }// end function

        public function set kbps(param1:String) : void
        {
            this._kbps = param1;
            return;
        }// end function

    }
}
