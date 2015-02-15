package douban_format.event
{
    import flash.events.*;

    public class SeekEvent extends Event
    {
        private var _where:Number;
        public static const ONSEEK:String = "onSeek";

        public function SeekEvent()
        {
            super(ONSEEK);
            return;
        }// end function

        public function set percent(param1:Number) : void
        {
            this._where = param1;
            return;
        }// end function

        public function get percent() : Number
        {
            return this._where;
        }// end function

    }
}
