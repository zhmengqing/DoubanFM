package douban_format.display
{
    import flash.display.*;

    public class ProgressBar extends Shape
    {
        private var _barWidth:Number;
        private var _barHeight:Number;
        private var _bgColor:Number = 15066600;
        private var _fgColor:Number = 10344133;

        public function ProgressBar(param1:Number, param2:Number)
        {
            this._barWidth = param1;
            this._barHeight = param2;
            this.drawPercent(0);
            return;
        }// end function

        public function set percent(param1:Number) : void
        {
            this.drawPercent(param1);
            return;
        }// end function

        public function setColor(param1:Number, param2:Number) : void
        {
            this._fgColor = param2;
            this._bgColor = param1;
            return;
        }// end function

        private function drawPercent(param1:Number) : void
        {
            if (param1 < 0 || param1 > 1)
            {
                return;
            }
            graphics.clear();
            graphics.beginFill(this._bgColor);
            graphics.drawRect(0, 0, this._barWidth, this._barHeight);
            graphics.endFill();
            graphics.beginFill(this._fgColor);
            graphics.drawRect(0, 0, this._barWidth * param1, this._barHeight);
            graphics.endFill();
            return;
        }// end function

    }
}
