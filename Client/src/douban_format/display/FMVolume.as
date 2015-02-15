package douban_format.display
{
    import com.douban.event.*;
    import com.douban.utils.*;
    import fl.transitions.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class FMVolume extends MovieClip
    {
        public var laba:MovieClip;
        public var back:MovieClip;
        private var so:SharedObject;
        private var _vol:Number;
        private var bar:Shape;
        private var clickBar:Sprite;
        private var backArea:Shape;
        private var barLength:Number = 48;
        private var _x:Number;
        private var outTime:Number;
        private var timer:Timer;
        private var busy:Boolean = false;

        public function FMVolume()
        {
            this._x = this.laba.x;
            addEventListener(MouseEvent.MOUSE_OVER, this.onOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.onOut);
            this.bar = new Shape();
            this.bar.x = -1000;
            addChildAt(this.bar, 1);
            this.clickBar = new Sprite();
            this.clickBar.x = -1000;
            this.clickBar.graphics.beginFill(0);
            this.clickBar.graphics.drawRect(0, 0, this.barLength + 10, 23);
            this.clickBar.graphics.endFill();
            this.clickBar.buttonMode = true;
            this.clickBar.alpha = 0;
            addChildAt(this.clickBar, 1);
            this.backArea = new Shape();
            this.backArea.x = -1000;
            this.backArea.graphics.beginFill(16777215);
            this.backArea.graphics.drawRect(0, -4, this.barLength, 11);
            this.backArea.graphics.endFill();
            setChildIndex(this.laba, 1);
            addChildAt(this.backArea, 1);
            setChildIndex(this.back, 1);
            this.clickBar.addEventListener(MouseEvent.MOUSE_DOWN, this.onDragStart);
            this.clickBar.addEventListener(MouseEvent.MOUSE_UP, this.onDragStop);
            this.timer = new Timer(30);
            this.timer.addEventListener(TimerEvent.TIMER, this.onTimer);
            this.so = SharedObject.getLocal("mp3player", "/");
            this.setVolume(this.so.data.volume || 1);
            return;
        }// end function

        private function onDragStart(event:MouseEvent) : void
        {
            event.stopPropagation();
            this.timer.start();
            return;
        }// end function

        private function onDragStop(param1) : void
        {
            param1.stopPropagation();
            this.timer.stop();
            return;
        }// end function

        private function onTimer(event:TimerEvent) : void
        {
            if (this.clickBar.mouseX <= 0 || this.clickBar.mouseX >= this.clickBar.width || this.clickBar.mouseY <= 0 || this.clickBar.mouseY >= this.clickBar.height)
            {
                this.onDragStop(event);
                this.timer.stop();
            }
            else
            {
                this.setVolume((this.clickBar.mouseX - 2) / this.barLength);
            }
            return;
        }// end function

        public function setVolume(param1:Number) : void
        {
            param1 = param1 > 1 ? (1) : (param1 < 0 ? (0) : (param1));
            var _loc_2:* = new SeekEvent();
            _loc_2.percent = param1;
            dispatchEvent(_loc_2);
            this.so.data.volume = param1;
            this.so.flush();
            this._vol = param1;
            this.laba.gotoAndStop(0);
            this.bar.graphics.clear();
            this.bar.graphics.beginFill(15066600);
            this.bar.graphics.drawRect(this.barLength * param1, 0, this.barLength * (1 - param1), 3);
            this.bar.graphics.endFill();
            this.bar.graphics.beginFill(3355443);
            this.bar.graphics.drawRect(0, 0, this.barLength * param1, 3);
            this.bar.graphics.endFill();
            this.bar.graphics.beginFill(16777215);
            this.bar.graphics.drawRect(this.barLength * param1 - 1, 0, 2, 3);
            this.bar.graphics.endFill();
            return;
        }// end function

        public function get volume() : Number
        {
            return this._vol;
        }// end function

        private function onOver(event:MouseEvent) : void
        {
            if (this.outTime)
            {
                clearTimeout(this.outTime);
            }
            if (this.bar.x == -1000)
            {
                this.showMain();
            }
            return;
        }// end function

        private function onOut(event:MouseEvent) : void
        {
            this.outTime = setTimeout(this.hideMain, 50);
            return;
        }// end function

        public function hideMain() : void
        {
            if (this.busy)
            {
                return;
            }
            this.busy = true;
            setChildIndex(this.laba, 1);
            setChildIndex(this.back, 1);
            new Motion(this.laba, "x", Regular.easeOut, this.laba.x, this._x, 10).play();
            new Motion(this.bar, "alpha", Regular.easeOut, 1, 0, 10).play(function () : void
            {
                busy = false;
                var _loc_1:* = -1000;
                bar.x = -1000;
                backArea.x = _loc_1;
                return;
            }// end function
            );
            this.clickBar.x = -1000;
            return;
        }// end function

        private function showMain() : void
        {
            if (this.busy)
            {
                return;
            }
            this.busy = true;
            new Motion(this.laba, "x", Regular.easeOut, this.laba.x, this._x - this.barLength - 7, 10).play();
            var _loc_2:* = this._x - this.barLength + 2;
            this.bar.x = this._x - this.barLength + 2;
            this.backArea.x = _loc_2;
            this.bar.y = this.laba.y - 1;
            this.backArea.y = this.laba.y - 1;
            this.clickBar.x = this.bar.x - 6;
            this.clickBar.y = this.bar.y - 10;
            new Motion(this.bar, "alpha", Regular.easeOut, 0, 1, 10).play(function () : void
            {
                busy = false;
                if (back.mouseX <= 0 || back.mouseX >= back.width || back.mouseY <= 0 || back.mouseY >= back.height)
                {
                    hideMain();
                }
                return;
            }// end function
            );
            return;
        }// end function

    }
}
