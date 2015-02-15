package douban_format.app
{
    import com.adobe.serialization.json.*;
    import douban_format.display.*;
    import douban_format.event.*;
    import douban_format.media.*;
    import douban_format.utils.*;
	import douban_format.media.DBRadio;
    import fl.transitions.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;

    public class FMPlayer extends Sprite
    {
        public var albumTxt:TextField;
        public var timeTxt:TextField;
        public var likeBtn:GoodBtn;
        public var volControl:FMVolume;
        public var fwdBtn:btn_skipBtn;
        public var badBtn:btn_banBtn;
        public var pauseArea:pauseArea_btn;
        public var tipAnonyLove:MovieClip;
        public var pubTimeTxt:TextField;
        public var btnTip:MovieClip;
        public var artistTxt:TextField;
        var fpt:FirstPersonalTip;
        var radio:DBRadio;
        var kControl:KbpsController;
        var lg:Logger;
        var cover:TipCover;
        var canAct:Boolean = false;
        var so:SharedObject;
        var context:String;
        var songTxt:ScrollText;
        var playingAd:Boolean = false;
        var conn:LocalConnection;
        var proBar:ProgressBar;
        var artistY:Number = 59;
        var anonyMode:Boolean;
        var _lastLike:String = "";
        var chanDefault:String;
        var btnTipTimeout:int;
        var getProTip:GetProTip;
        var isPro:Boolean = false;
        static const PRIV_CH:Object = "0";
        static const ANONY_UID:Object = "0";
        static const RED_CH:Object = "-3";

        public function FMPlayer()
        {
            Security.allowDomain("*");
            stage.scaleMode = StageScaleMode.SHOW_ALL;
            stage.align = StageAlign.TOP_LEFT;
            setTimeout(this.init, 0);
            return;
        }// end function

        private function init() : void
        {
            stage.addEventListener(MouseEvent.MOUSE_UP, this.cleanTips);
            ExternalInterface.addCallback("act", this.extControl);
            ExternalInterface.addCallback("selectedLike", this.selectedLike);
            ExternalInterface.addCallback("isPaused", this.isPaused);
            this.conn = new LocalConnection();
            this.conn.client = this;
            this.so = SharedObject.getLocal("douban_radio", "/");
            var param:* = root.loaderInfo.parameters;
            var host:* = param["host"];
            var from:* = param["fromname"] || "";
            this.isPro = param["userType"] === "pro";
            host = param["host"] || "http://douban.fm";
            this.context = param["context"] || "";
            this.lg = new Logger("DBR.rlog", host);
            var config:Object;
            this.radio = new DBRadio(config);
            this.radio.addEventListener(PositionEvent.ON_POSITION, this.onPosition);
            this.radio.addEventListener(SongEvent.SONG_EVENT, this.onSongEvent);
            this.radio.addEventListener(ListEvent.LISTEVENT, this.onListEvent);
            this.radio.addEventListener(LogoutEvent.ONLOGOUT, this.onLogout);
            this.anonyMode = !(param["uid"] && param["uid"] != ANONY_UID);
            if (this.isPro)
            {
                this.lg.log("pro, init KC");
                this.initKbpsControl(config);
                this.radio.kbps = this.kControl.getKbps();
            }
            this.fwdBtn.addEventListener(MouseEvent.CLICK, this.onSkipClick);
            this.likeBtn.addEventListener(MouseEvent.CLICK, this.onLikeClick);
            this.badBtn.addEventListener(MouseEvent.CLICK, this.onBanClick);
            this.pauseArea.addEventListener(MouseEvent.CLICK, this.onPauseClick);
            this.tipAnonyLove.closeBtn.buttonMode = true;
            this.tipAnonyLove.closeBtn.addEventListener(MouseEvent.MOUSE_UP, function () : void
            {
                tipAnonyLove.y = -300;
                return;
            }// end function
            );
            this.tipAnonyLove.loginBtn.addEventListener(MouseEvent.MOUSE_UP, this.showLogin);
            this.tipAnonyLove.loginBtn.buttonMode = true;
            this.btnTip.visible = false;
            this.likeBtn.addEventListener(MouseEvent.MOUSE_OVER, function ()
            {
                showBtnTip(likeBtn.x + 13, likeBtn.selected ? ("unlike") : ("like"));
                return;
            }// end function
            );
            this.badBtn.addEventListener(MouseEvent.MOUSE_OVER, function ()
            {
                showBtnTip(badBtn.x + 10, badBtn.disabled ? ("cannot_ban") : ("ban"));
                return;
            }// end function
            );
            this.fwdBtn.addEventListener(MouseEvent.MOUSE_OVER, function ()
            {
                showBtnTip(fwdBtn.x + 14, "skip");
                return;
            }// end function
            );
            this.likeBtn.addEventListener(MouseEvent.MOUSE_OUT, this.hideBtnTip);
            this.fwdBtn.addEventListener(MouseEvent.MOUSE_OUT, this.hideBtnTip);
            this.badBtn.addEventListener(MouseEvent.MOUSE_OUT, this.hideBtnTip);
            this.volControl.addEventListener(SeekEvent.ONSEEK, this.radio.onAdjustVolume);
            this.cover = new TipCover(245);
            this.cover.x = 0;
            this.cover.y = 0;
            this.cover.dropShadow = false;
            addChildAt(this.cover, 2);
            this.getProTip = new GetProTip();
            this.getProTip.x = this.cover.width - this.getProTip.width - 7;
            this.getProTip.y = -100;
            addChildAt(this.getProTip, 3);
            var blackBack:* = new Shape();
            blackBack.graphics.beginFill(16777215);
            blackBack.graphics.drawRect(0, 0, 245, 245);
            blackBack.graphics.endFill();
            addChildAt(blackBack, 1);
            this.songTxt = new ScrollText(225);
            addChildAt(this.songTxt, 2);
            this.songTxt.x = 264;
            this.songTxt.y = 91;
            var style:* = new StyleSheet();
            var fontFamily:*;
            if (Capabilities.os.indexOf("Mac OS") != -1)
            {
                fontFamily;
            }
            style.parseCSS(".artist {font-size: 23; font-family:" + fontFamily + "; color:#333333}");
            style.parseCSS(".mhz {font-size: 14; font-family:" + fontFamily + "; color:#333333}");
            style.parseCSS(".album {font-size: 12; font-family:" + fontFamily + "; color:#333333}");
            style.parseCSS(".time {font-size: 11; font-family:" + fontFamily + "; color:#6C7172}");
            style.parseCSS(".pubtime {font-size: 12; font-family:" + fontFamily + "; color:#6C7172}");
            this.songTxt.setCSS("{fontSize:13; font-family:_sans; color:#009966}", "{fontSize:13; font-family:_sans; color:#33ad85}");
            this.albumTxt.autoSize = TextFieldAutoSize.LEFT;
            this.albumTxt.styleSheet = style;
            this.timeTxt.styleSheet = style;
            this.pubTimeTxt.styleSheet = style;
            this.artistTxt.styleSheet = style;
            this.proBar = new ProgressBar(225, 2);
            this.proBar.x = 265;
            this.proBar.y = 114;
            addChildAt(this.proBar, 2);
            var chan:* = root.loaderInfo.parameters["channel"];
            var redDisabled:* = root.loaderInfo.parameters["redChanDisabled"];
            this.chanDefault = root.loaderInfo.parameters["defaultChannel"] || PRIV_CH;
            var chanSo:* = this.so.data.channel;
            var isNewUser:* = !chanSo;
            chan = chan ? (chan) : (!chanSo ? (this.chanDefault) : (chanSo != RED_CH ? (chanSo) : (!redDisabled ? (RED_CH) : (PRIV_CH))));
            if (chan === DBRadio.RED_HEART_TAGS_CHANNEL || chan === DBRadio.PERSONAL_TAGS_CHANNEL || chan === DBRadio.PERSONAL_CHANNEL)
            {
                this.channelSwitch(chan, this.so.data.tags);
            }
            else
            {
                this.channelSwitch(chan);
            }
            this.sendEventOut({type:"init", is_new:isNewUser, channel:this.radio.channel});
            this.pauseOthers();
            this.radio.start();
            return;
        }// end function

        private function initKbpsControl(param1:Object) : void
        {
            if (this.kControl)
            {
                return;
            }
            this.kControl = new KbpsController(param1);
            this.kControl.addEventListener(KbpsEvent.KBPS_SHOULD_CHANGE, this.radio.onKbpsShouldChange);
            this.radio.addEventListener(SongEvent.SONG_EVENT, this.kControl.onSongEvent);
            this.radio.addEventListener(PlayErrorEvent.PLAY_ERROR, this.kControl.onPlayErrorEvent);
            this.radio.addEventListener(CompleteEvent.LOAD_COMPLETE, this.kControl.onLoadComplete);
            this.kControl.init();
            return;
        }// end function

        private function showBtnTip(param1:Number, param2:String) : void
        {
            var xPos:* = param1;
            var tip:* = param2;
            if (this.btnTipTimeout)
            {
                clearTimeout(this.btnTipTimeout);
            }
            this.btnTipTimeout = setTimeout(function ()
            {
                btnTip.visible = true;
                btnTip.gotoAndStop(tip);
                btnTip.x = xPos;
                new Motion(btnTip, "alpha", Regular.easeOut, 0, 1, 5).play();
                return;
            }// end function
            , 500);
            return;
        }// end function

        private function hideBtnTip(event:MouseEvent) : void
        {
            if (this.btnTipTimeout)
            {
                clearTimeout(this.btnTipTimeout);
            }
            this.btnTip.visible = false;
            return;
        }// end function

        private function sendEventOut(param1:Object)
        {
            ExternalInterface.call("extStatusHandler", JSON.encode(param1).split("\\\"").join("\\\\\""));
            return;
        }// end function

        private function pauseOthers() : void
        {
            try
            {
                this.conn.connect("DoubanRadio");
                return;
            }
            catch (e)
            {
            }
            this.lg.log("other radio is playing");
            try
            {
                this.conn.send("DoubanRadio", "onPauseClick");
                setTimeout(this.pauseOthers, 1000);
            }
            catch (e)
            {
            }
            return;
        }// end function

        private function extControl(... args) : void
        {
            var _loc_3:* = null;
            args = args.length > 0 ? (args[0]) : ("");
            switch(args)
            {
                case "pause":
                {
                    this.onPauseClick();
                    break;
                }
                case "skip":
                {
                    this.onSkipClick();
                    break;
                }
                case "love":
                {
                    this.onLikeClick();
                    break;
                }
                case "ban":
                {
                    this.onBanClick();
                    break;
                }
                case "switch":
                {
                    if (args.length > 1)
                    {
                        _loc_3 = args[2] || {};
                        this.channelSwitch(args[1], _loc_3["tags"] || "", _loc_3["artist_id"] || "", _loc_3["only_change_chan"] || false, _loc_3["start"] || "");
                    }
                    break;
                }
                case "login":
                {
                    this.login(args.length > 1 ? (args[1]) : (ANONY_UID), args.length > 2 ? (args[2]) : (false));
                    break;
                }
                case "deactivate":
                {
                    this.onDeactivate();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function login(param1:String, param2:Boolean) : void
        {
            this.cleanTips();
            this.anonyMode = param1 == ANONY_UID;
            this.isPro = param2 === true;
            if (!this.anonyMode && this._lastLike == this.radio.sid && this.radio.isLiked)
            {
                this.radio.like();
                this._lastLike = "";
            }
            if (this.isPro)
            {
                this.lg.log("login pro, init KC");
                this.initKbpsControl({logger:this.lg});
            }
            return;
        }// end function

        private function onLogout(event:LogoutEvent) : void
        {
            this.lg.log("User logged out");
            this.isPro = false;
            this.anonyMode = true;
            ExternalInterface.call("DBR.logout");
            event.stopPropagation();
            return;
        }// end function

        public function setPro() : void
        {
            if (!this.anonyMode)
            {
                this.lg.log("LC set to pro.");
                this.initKbpsControl({Logger:this.lg});
            }
            else
            {
                this.lg.log("LC set to pro, but anonymous shall ignore.");
            }
            return;
        }// end function

        private function channelSwitch(param1:String, param2:String = "", param3:String = "", param4:Boolean = false, param5:String = "") : void
        {
            if (this.pauseArea.selected)
            {
                this.onPauseClick();
            }
            this.so.data.channel = param1;
            this.so.data.tags = param2;
            this.so.data.artist_id = param3;
            this.so.flush();
            var _loc_6:* = param2;
            param2 = param2;
            var _loc_6:* = param3;
            param3 = param3;
            var _loc_6:* = param4;
            param4 = param4;
            var _loc_6:* = param5;
            param5 = param5;
            this.radio.setChannel(param1, _loc_6, _loc_6, _loc_6, _loc_6);
            this.sendEventOut({type:"fixchannel", channel:param1});
            if (param1 === PRIV_CH && !this.so.data.showed_personal_tip && !(this.fpt && contains(this.fpt)))
            {
                this.showPersonalTip();
            }
            return;
        }// end function

        private function showPersonalTip() : void
        {
            this.fpt = new FirstPersonalTip();
            this.fpt.hideTimeout = setTimeout(this.hidePersonalTip, 5000, null);
            this.fpt.closeBtn.buttonMode = true;
            this.fpt.closeBtn.addEventListener(MouseEvent.MOUSE_UP, this.hidePersonalTip);
            this.fpt.addEventListener(MouseEvent.MOUSE_OVER, function (param1) : void
            {
                clearTimeout(fpt.hideTimeout);
                return;
            }// end function
            );
            this.fpt.addEventListener(MouseEvent.MOUSE_OUT, function (param1) : void
            {
                if (fpt !== null)
                {
                    clearTimeout(fpt.hideTimeout);
                    fpt.hideTimeout = setTimeout(hidePersonalTip, 2000, null);
                }
                return;
            }// end function
            );
            this.so.data.showed_personal_tip = true;
            this.so.flush();
            this.fpt.alpha = 0;
            addChild(this.fpt);
            new Motion(this.fpt, "alpha", Regular.easeOut, 0, 1, 15).play();
            return;
        }// end function

        private function hidePersonalTip(param1) : void
        {
            var e:* = param1;
            new Motion(this.fpt, "alpha", Regular.easeOut, 1, 0, 10).play(function () : void
            {
                removeChild(fpt);
                fpt = null;
                return;
            }// end function
            );
            return;
        }// end function

        private function onSkipClick(... args) : void
        {
            if (this.fwdBtn.disabled)
            {
                return;
            }
            if (this.pauseArea.selected)
            {
                this.onPauseClick();
            }
            if (this.canAct)
            {
                this.canAct = false;
            }
            else
            {
                return;
            }
            this.radio.skip();
            return;
        }// end function

        public function onPauseClick(... args) : void
        {
            if (!this.canAct)
            {
                return;
            }
            args = "gotoplay";
            if (this.pauseArea.selected)
            {
                if (this.pauseArea.maskMc.resumeActiveTxt.alpha == 1)
                {
                    this.lg.count("reactivate");
                }
                args = "gotoplay";
                this.radio.resume();
                this.pauseArea.selected = false;
                this.pauseOthers();
            }
            else
            {
                args = "pause";
                this.radio.pause();
                this.pauseArea.selected = true;
                this.pauseArea.maskMc.resumeActiveTxt.alpha = 0;
                this.pauseArea.maskMc.resumeTxt.alpha = 1;
                this.conn.close();
            }
            this.sendEventOut({type:args, channel:this.radio.channel});
            return;
        }// end function

        public function selectedLike() : Boolean
        {
            return this.likeBtn.selected;
        }// end function

        public function isPaused() : Boolean
        {
            return this.pauseArea.selected;
        }// end function

        private function onDeactivate() : void
        {
            if (!this.pauseArea.selected)
            {
                this.lg.count("deactivate");
                this.radio.pause();
                this.pauseArea.selected = true;
                this.pauseArea.maskMc.resumeActiveTxt.alpha = 1;
                this.pauseArea.maskMc.resumeTxt.alpha = 0;
                this.conn.close();
            }
            this.sendEventOut({type:"pause", channel:this.radio.channel});
            return;
        }// end function

        private function onLikeClick(... args) : void
        {
            if (this.likeBtn.disabled || this.playingAd)
            {
                return;
            }
            if (this.radio.isLiked)
            {
                this.radio.unlike();
                this.likeBtn.selected = false;
            }
            else
            {
                this.radio.like();
                this.likeBtn.selected = true;
            }
            if (this.anonyMode)
            {
                this._lastLike = this.radio.sid;
                this.tipAnonyLove.y = 145;
                new Motion(this.tipAnonyLove, "alpha", Regular.easeOut, 0, 1, 8).play();
            }
            return;
        }// end function

        private function onBanClick(... args) : void
        {
            if (this.badBtn.disabled || this.playingAd)
            {
                return;
            }
            if (this.canAct)
            {
                this.canAct = false;
            }
            else
            {
                return;
            }
            if (this.pauseArea.selected)
            {
                this.onPauseClick();
            }
            this.radio.ban();
            return;
        }// end function

        private function onPosition(param1) : void
        {
            this.timeTxt.text = "-" + Format.msFormat(this.radio.soundLength - param1.position, false);
            this.proBar.percent = this.radio.soundLength ? (param1.position / this.radio.soundLength) : (0);
            return;
        }// end function

        private function showLogin(param1) : void
        {
            ExternalInterface.call("DBR.show_login");
            param1.stopPropagation();
            return;
        }// end function

        private function onSongEvent(event:SongEvent) : void
        {
            var _loc_2:* = event.data;
            var _loc_3:* = _loc_2["song"];
            if (_loc_2["type"] == DBRadio.START)
            {
                this.radio.volume = this.volControl.volume;
                this.songTxt.text = this.escapeHtml(_loc_3["title"]);
                this.songTxt.link = _loc_3["album"];
                this.artistTxt.htmlText = "<span class=\"artist\">" + this.escapeHtml(_loc_3["artist"]) + "</span>";
                this.artistTxt.y = this.artistY - this.artistTxt.textHeight;
                this.playingAd = _loc_3["subtype"] === DBRadio.SUBTYPE_AD;
                this.getProTip.y = this.playingAd && !this.isPro ? (7) : (-100);
                this.cover.showPicture(_loc_3["picture"]);
                this.cover.clickUrl = _loc_3["album"];
                this.albumTxt.htmlText = "<span class=\"album\">&lt; " + this.escapeHtml(_loc_3["albumtitle"]) + " &gt;</span>";
                this.pubTimeTxt.x = this.albumTxt.x + this.albumTxt.textWidth + 5;
                this.pubTimeTxt.htmlText = "<span class=\"pubtime\">" + _loc_3["pubtime"] + "</span>";
                this.likeBtn.selected = _loc_3["like"];
            }
            if (_loc_2["type"] == DBRadio.NEW_LIST)
            {
                this.canAct = true;
                if (_loc_2.playlist.length == 0 && _loc_2.channel != DBRadio.RED_HEART_CHANNEL && _loc_2.r != DBRadio.CHANNEL_OFFLINE_ERROR)
                {
                    return;
                }
            }
            this.sendEventOut(_loc_2);
            return;
        }// end function

        private function onListEvent(event:ListEvent) : void
        {
            if (event.message["error"])
            {
                this.canAct = true;
                delete this.so.data.channel;
                this.so.flush();
            }
            if (event.message["warning"])
            {
                if (event.message["msg"] == "user_is_ananymous")
                {
                    this.lg.log("warning! should reload page");
                    ExternalInterface.call("function(){location.reload()}");
                }
            }
            return;
        }// end function

        private function cleanTips(event:MouseEvent = null) : void
        {
            this.tipAnonyLove.y = -300;
            this.volControl.hideMain();
            return;
        }// end function

        private function escapeHtml(param1:String) : String
        {
            return param1.split("&").join("&amp;").split(">").join("&gt;").split("<").join("&lt;").split("\"").join("&quot;").split("\'").join("&apos;");
        }// end function

    }
}
