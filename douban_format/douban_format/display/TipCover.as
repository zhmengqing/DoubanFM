package douban_format.display
{
    import flash.display.*;

    public class TipCover extends RadioCover
    {

        public function TipCover(param1:Number)
        {
            super(param1);
            return;
        }// end function

        override protected function makeHoverTip() : Sprite
        {
            var _loc_1:* = new Sprite();
            _loc_1.graphics.beginFill(0, 0.2);
            _loc_1.graphics.drawRect(0, 0, size, size);
            _loc_1.graphics.endFill();
            var _loc_2:* = new CoverTip();
            _loc_1.addChild(_loc_2);
            return _loc_1;
        }// end function

    }
}
