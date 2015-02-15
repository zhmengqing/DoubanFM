package douban_format.event
{
    import flash.events.*;

    public class CompleteEvent extends Event
    {
        private var _value:Object;
        public static const COMPLETE:String = "complete";
        public static const LOAD_COMPLETE:String = "load_complete";

        public function CompleteEvent(param1:String)
        {
            super(param1);
            return;
        }// end function

        public function set value(param1) : void
        {
            this._value = param1;
            return;
        }// end function

        public function get value()
        {
            return this._value;
        }// end function

    }
}
