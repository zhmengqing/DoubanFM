package douban_format.event
{
    import flash.events.*;

    public class PositionEvent extends Event
    {
        private var _pos:Number;
        public static const ON_POSITION:String = "on_position";

        public function PositionEvent()
        {
            super(ON_POSITION);
            return;
        }// end function

        public function set position(param1:Number) : void
        {
            this._pos = param1;
            return;
        }// end function

        public function get position() : Number
        {
            return this._pos;
        }// end function

    }
}
