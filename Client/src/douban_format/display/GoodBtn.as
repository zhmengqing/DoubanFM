package douban_format.display
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class GoodBtn extends MovieClip
    {
        public var maskMc:MovieClip;
        public var nameTxt:TextField;
        private var _isSelected:Object = false;
        private var _disable:Object = false;

        public function GoodBtn()
        {
            stop();
            buttonMode = true;
            addEventListener(MouseEvent.MOUSE_OVER, this.onOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.onNorm);
            addEventListener(MouseEvent.MOUSE_UP, this.onOver);
            return;
        }// end function

        private function onOver(param1)
        {
            if (!this._disable)
            {
                if (this._isSelected)
                {
                    gotoAndStop("selected_hover");
                }
                else
                {
                    gotoAndStop("norm_hover");
                }
            }
            return;
        }// end function

        private function onNorm(param1)
        {
            if (!this._disable)
            {
                if (this._isSelected)
                {
                    gotoAndStop("selected");
                }
                else
                {
                    gotoAndStop("norm");
                }
            }
            return;
        }// end function

        public function set selected(param1)
        {
            this._isSelected = param1;
            if (!this._disable)
            {
                this.onNorm(0);
            }
            return;
        }// end function

        public function get selected()
        {
            return this._isSelected;
        }// end function

        public function set disabled(param1)
        {
            this._disable = param1;
            if (this._disable)
            {
                gotoAndStop("disabled");
            }
            else if (this._isSelected)
            {
                gotoAndStop("selected");
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
