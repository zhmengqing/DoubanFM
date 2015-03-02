package douban_format.display
{
    import com.douban.utils.*;
    import fl.transitions.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.filters.*;
    import flash.net.*;
    import flash.system.*;

    public class RadioCover extends Sprite
    {
        public var dropShadow:Boolean = true;
        protected var _clickUrl:String = "";
        protected var picUrl:String;
        protected var oldLoader:Loader;
        protected var workingLoader:Loader;
        protected var picture:Sprite;
        protected var picMask:Shape;
        protected var workingPic:Sprite;
        protected var oldPic:Sprite;
        protected var hoverTip:Sprite;
        protected var status:String;
        protected var size:Number;
        protected var bleed:Number = 2;
        static const DONE:String = "0";
        static const LOADING:String = "1";
        static const FADING:String = "2";

        public function RadioCover(param1:Number)
        {
            this.size = param1;
            this.status = DONE;
            this.picture = new Sprite();
            this.workingPic = new Sprite();
            this.picMask = new Shape();
            addChild(this.picture);
            this.picture.addChild(this.workingPic);
            this.hoverTip = this.makeHoverTip();
            this.hoverTip.alpha = 0;
            addChild(this.hoverTip);
            this.picMask.graphics.beginFill(0);
            this.picMask.graphics.drawRect(0, 0, this.size, this.size);
            addChild(this.picMask);
            this.picture.mask = this.picMask;
            addEventListener(MouseEvent.CLICK, this.onClick);
            addEventListener(MouseEvent.MOUSE_OVER, this.onOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.onOut);
            return;
        }// end function

        protected function makeHoverTip() : Sprite
        {
            var _loc_1:* = new Sprite();
            _loc_1.graphics.beginFill(0, 0.2);
            _loc_1.graphics.drawRect(0, 0, this.size, this.size);
            _loc_1.graphics.endFill();
            return _loc_1;
        }// end function

        private function onOver(event:MouseEvent) : void
        {
            new Motion(this.hoverTip, "alpha", Regular.easeOut, 0, 1, 6).play();
            return;
        }// end function

        private function onOut(event:MouseEvent) : void
        {
            new Motion(this.hoverTip, "alpha", Regular.easeOut, 1, 0, 6).play();
            return;
        }// end function

        public function set clickUrl(param1:String) : void
        {
            buttonMode = param1;
            param1 = param1 ? (/^http:""^http:/.test(param1) ? (param1) : ("http://music.douban.com" + param1)) : ("");
            this._clickUrl = param1;
            return;
        }// end function

        public function get clickUrl() : String
        {
            return this._clickUrl;
        }// end function

        private function onClick(event:MouseEvent) : void
        {
            if (this._clickUrl)
            {
                ExternalInterface.call("ropen", this._clickUrl, "RadioCover");
            }
            return;
        }// end function

        public function showPicture(param1:String) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (param1 != this.picUrl)
            {
                this.picUrl = param1;
                if (this.status == LOADING)
                {
                    try
                    {
                        this.workingLoader.close();
                        this.workingLoader.unload();
                    }
                    catch (e)
                    {
                    }
                }
                else
                {
                    if (this.status == FADING)
                    {
                        this.onFadeInDone();
                    }
                    this.workingPic = new Sprite();
                    this.workingLoader = new Loader();
                    this.picture.addChild(this.workingPic);
                    this.workingPic.addChild(this.workingLoader);
                    this.workingLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.pic_ioError);
                    this.workingLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onComplete);
                }
                _loc_2 = new LoaderContext(true);
                this.workingLoader.load(new URLRequest(param1), _loc_2);
                this.status = LOADING;
                if (this.dropShadow)
                {
                    _loc_3 = new DropShadowFilter(2, 45, 0, 0.7, 4, 4, 0.7, BitmapFilterQuality.HIGH, false, false);
                    filters = [_loc_3];
                }
            }
            return;
        }// end function

        private function pic_ioError(event:IOErrorEvent) : void
        {
            this.status = DONE;
            dispatchEvent(event);
            return;
        }// end function

        private function onComplete(event:Event) : void
        {
            var _loc_4:* = null;
            var _loc_2:* = event.target;
            if (this.workingLoader.content is Bitmap)
            {
                _loc_4 = this.workingLoader.content as Bitmap;
                _loc_4.smoothing = true;
            }
            if (_loc_2.height >= _loc_2.width)
            {
                this.workingPic.height = (this.size + this.bleed * 2) * _loc_2.height / _loc_2.width;
                this.workingPic.width = this.size + this.bleed * 2;
                this.workingPic.x = -this.bleed;
                this.workingPic.y = -this.bleed;
            }
            else
            {
                this.workingPic.height = this.size + this.bleed * 2;
                this.workingPic.width = (this.size + this.bleed * 2) * _loc_2.width / _loc_2.height;
                this.workingPic.x = -(this.workingPic.width - this.size) / 2 - this.bleed;
                this.workingPic.y = -this.bleed;
            }
            var _loc_3:* = new Motion(this.workingLoader, "alpha", Regular.easeOut, 0, 1, 24);
            _loc_3.play(this.onFadeInDone);
            this.workingLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.pic_ioError);
            if (this.workingLoader.contentLoaderInfo)
            {
                this.workingLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onComplete);
            }
            this.status = FADING;
            return;
        }// end function

        private function onFadeInDone() : void
        {
            if (this.status == FADING)
            {
                if (this.oldLoader)
                {
                    this.oldLoader.unload();
                    this.oldLoader.parent.removeChild(this.oldLoader);
                }
                if (this.oldPic)
                {
                    this.picture.removeChild(this.oldPic);
                    this.oldPic = null;
                }
                this.oldPic = this.workingPic;
                this.oldLoader = this.workingLoader;
                this.status = DONE;
            }
            return;
        }// end function

    }
}
