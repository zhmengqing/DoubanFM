package douban_format.display
{
    import flash.display.*;
    import flash.events.*;

    public class SimBtn extends MovieClip
    {
        private var _disable:Object = false;

        public function SimBtn()
        {
            stop();
            buttonMode = true;
            addEventListener(MouseEvent.MOUSE_OVER, this.onOver);
            addEventListener(MouseEvent.MOUSE_DOWN, this.onDown);
            addEventListener(MouseEvent.MOUSE_OUT, this.onNorm);
            addEventListener(MouseEvent.MOUSE_UP, this.onOver);
            return;
        }// end function

        public function onOver(param1)
        {
            if (this._disable)
            {
                return;
            }
            gotoAndStop("over");
            return;
        }// end function

        public function onDown(param1)
        {
            if (this._disable)
            {
                return;
            }
            gotoAndStop("down");
            return;
        }// end function

        public function onNorm(param1)
        {
            if (this._disable)
            {
                return;
            }
            gotoAndStop("norm");
            return;
        }// end function

        public function set disabled(param1)
        {
            this._disable = param1;
            if (param1)
            {
                gotoAndStop("disabled");
            }
            else
            {
                gotoAndStop("norm");
            }
            return;
        }// end function

        public function get disabled()
        {
            return this._disable;
        }// end function

    }
}
