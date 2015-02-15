package douban_format.display
{
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;

    public class ScrollText extends Sprite
    {
        private var txt:TextField;
        private var _text:String = "";
        private var _link:String = "";
        private var txtMask:Shape;
        private var showWidth:Number;
        private var timer:Timer;
        private var origWidth:Number;
        private var doubleWidth:Number;
        private var style:StyleSheet;

        public function ScrollText(param1)
        {
            this.showWidth = param1;
            this.txt = new TextField();
            this.txt.autoSize = TextFieldAutoSize.LEFT;
            this.txt.selectable = false;
            this.txt.addEventListener("link", this.clickHandler);
            this.style = new StyleSheet();
            var _loc_2:* = "Microsoft Yahei,_sans";
            if (Capabilities.os.indexOf("Mac OS") != -1)
            {
                _loc_2 = "_sans";
            }
            this.style.parseCSS(".all {font-size: 23; font-family:" + _loc_2 + "; color:#333333}");
            this.txt.styleSheet = this.style;
            this.txtMask = new Shape();
            addChild(this.txt);
            addChild(this.txtMask);
            this.txtMask.graphics.beginFill(0);
            this.txtMask.graphics.drawRect(0, 0, this.showWidth, 30);
            this.txt.mask = this.txtMask;
            this.timer = new Timer(45);
            this.timer.addEventListener(TimerEvent.TIMER, this.onTimer);
            this.resetScroll();
            return;
        }// end function

        public function setStyle(param1:Object, param2:Object = null) : void
        {
            var obj:* = param1;
            var overObj:* = param2;
            this.style.setStyle(".all", obj);
            if (overObj !== null)
            {
                this.txt.addEventListener(MouseEvent.MOUSE_OVER, function (event:MouseEvent) : void
            {
                style.setStyle(".all", overObj);
                return;
            }// end function
            );
                this.txt.addEventListener(MouseEvent.MOUSE_OUT, function (event:MouseEvent) : void
            {
                style.setStyle(".all", obj);
                return;
            }// end function
            );
            }
            return;
        }// end function

        public function setCSS(param1:String, param2:String = null) : void
        {
            var css:* = param1;
            var overcss:* = param2;
            this.style.parseCSS(".all " + css);
            if (overcss != null)
            {
                this.txt.addEventListener(MouseEvent.MOUSE_OVER, function (event:MouseEvent) : void
            {
                style.parseCSS(".all" + overcss);
                return;
            }// end function
            );
                this.txt.addEventListener(MouseEvent.MOUSE_OUT, function (event:MouseEvent) : void
            {
                style.parseCSS(".all" + css);
                return;
            }// end function
            );
            }
            return;
        }// end function

        private function resetScroll() : void
        {
            this.txt.htmlText = "<span class=\"all\">" + this._text + "</span>";
            if (this._link != "")
            {
                this.txt.htmlText = "<a href=\"event:clickTxt\" target=\"_blank\">" + this.txt.htmlText + "</a>";
            }
            this.txt.x = 0;
            this.origWidth = this.txt.textWidth;
            if (this.origWidth > this.showWidth)
            {
                this.txt.htmlText = "<span class=\"all\">" + this._text + "     " + this._text + "</span>";
                if (this._link != "")
                {
                    this.txt.htmlText = "<a href=\"event:clickTxt\" target=\"_blank\">" + this.txt.htmlText + "</a>";
                }
                this.doubleWidth = this.txt.textWidth;
                this.timer.start();
            }
            else
            {
                this.timer.stop();
            }
            return;
        }// end function

        private function clickHandler(event:TextEvent)
        {
            if (this._link != "" && event.type == "link" && event.text == "clickTxt")
            {
                ExternalInterface.call("ropen", this._link, "ScrollText");
            }
            return;
        }// end function

        private function onTimer(event:TimerEvent) : void
        {
            (this.txt.x - 1);
            if (this.txt.x + this.doubleWidth <= this.origWidth)
            {
                this.txt.x = 0;
            }
            return;
        }// end function

        public function get text() : String
        {
            return this._text;
        }// end function

        public function set text(param1) : void
        {
            this._text = param1;
            this.resetScroll();
            return;
        }// end function

        public function set link(param1:String) : void
        {
            param1 = /^http:""^http:/.test(param1) ? (param1) : ("http://music.douban.com" + param1);
            this._link = param1;
            this.resetScroll();
            return;
        }// end function

        public function get textWidth() : Number
        {
            return Math.min(this.txt.textWidth, this.showWidth);
        }// end function

        public function get maxWidth() : Number
        {
            return this.showWidth;
        }// end function

    }
}
