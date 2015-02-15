package douban_format.display
{
    import com.douban.event.*;
    import com.douban.utils.*;
    import fl.transitions.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;

    public class VolumeControl extends MovieClip
    {
        public var laba:MovieClip;
        public var onLaba:MovieClip;
        public var m:MovieClip;
        public var volume:Object;
        protected var maxWidth:Object;
        protected var mySo:SharedObject;
        private var isDragging:Object = false;
        private var showControl:Object = false;
        private var hideTimeout:Object;
        private var timer:Object;

        public function VolumeControl()
        {
            this.m.controller.addEventListener(MouseEvent.MOUSE_DOWN, this.controllerDown);
            this.m.controller.addEventListener(MouseEvent.MOUSE_UP, this.controllerUp);
            this.m.controller.buttonMode = true;
            this.maxWidth = this.m.volStick.width;
            this.mySo = SharedObject.getLocal("mp3player", "/");
            if (this.mySo.data.volume != undefined)
            {
                this.setVolume(this.mySo.data.volume);
            }
            else
            {
                this.setVolume(1);
            }
            this.m.volHandler.addEventListener(MouseEvent.MOUSE_DOWN, this.onStartDrag);
            this.m.volHandler.addEventListener(MouseEvent.MOUSE_UP, this.onStopDrag);
            this.m.volHandler.buttonMode = true;
            this.onLaba.addEventListener(MouseEvent.MOUSE_UP, this.onLabaClick);
            this.onLaba.buttonMode = true;
            this.timer = new Timer(40);
            this.timer.addEventListener(TimerEvent.TIMER, this.onTimer);
            return;
        }// end function

        private function onLabaClick(param1)
        {
            param1.stopPropagation();
            if (this.showControl)
            {
                this.hideMain();
            }
            else
            {
                this.laba.gotoAndStop(102 + int(this.volume * 100));
                this.m.x = -70;
                this.m.alpha = 1;
                this.delayToHide();
                this.showControl = true;
            }
            return;
        }// end function

        public function hideMain()
        {
            if (!this.showControl)
            {
                return;
            }
            if (this.isDragging)
            {
                this.delayToHide();
                return;
            }
            this.laba.gotoAndStop(1 + int(this.volume * 100));
            new Motion(this.m, "alpha", Regular.easeOut, 1, 0, 10).play(function ()
            {
                m.x = 300;
                return;
            }// end function
            );
            this.showControl = false;
            return;
        }// end function

        private function delayToHide()
        {
            if (this.hideTimeout)
            {
                clearTimeout(this.hideTimeout);
            }
            this.hideTimeout = setTimeout(this.hideMain, 5000);
            return;
        }// end function

        private function onStartDrag(param1)
        {
            this.delayToHide();
            if (this.isDragging)
            {
                return;
            }
            var _loc_2:* = new Rectangle(this.m.volStick.x, this.m.volStick.y + 2, this.m.volStick.width, 0);
            this.m.volHandler.startDrag(false, _loc_2);
            this.isDragging = true;
            this.timer.start();
            return;
        }// end function

        private function onTimer(param1)
        {
            if (this.m.controller.mouseX <= 0 || this.m.controller.mouseX >= this.m.controller.width || this.m.controller.mouseY <= 0 || this.m.controller.mouseY >= this.m.controller.height)
            {
                trace("stop drag");
                this.onStopDrag(param1);
                this.timer.stop();
            }
            else
            {
                this.setVolume((this.m.volHandler.x - this.m.volStick.x) / this.maxWidth);
            }
            return;
        }// end function

        private function onStopDrag(param1)
        {
            param1.stopPropagation();
            this.delayToHide();
            this.m.volHandler.stopDrag();
            this.setVolume((this.m.volHandler.x - this.m.volStick.x) / this.maxWidth);
            this.isDragging = false;
            return;
        }// end function

        private function controllerDown(param1)
        {
            this.setVolume((this.m.controller.x - this.m.volStick.x + this.m.controller.mouseX) / this.maxWidth);
            return;
        }// end function

        private function controllerUp(param1)
        {
            this.onStopDrag(param1);
            return;
        }// end function

        public function setVolume(param1)
        {
            if (param1 > 1)
            {
                param1 = 1;
            }
            if (param1 < 0)
            {
                param1 = 0;
            }
            var _loc_2:* = new SeekEvent();
            _loc_2.percent = param1;
            dispatchEvent(_loc_2);
            this.volume = param1;
            this.m.volHandler.x = this.m.volStick.x + this.maxWidth * param1;
            this.laba.gotoAndStop((this.showControl ? (102) : (1)) + int(param1 * 100));
            this.mySo.data.volume = param1;
            this.mySo.flush();
            return;
        }// end function

    }
}
