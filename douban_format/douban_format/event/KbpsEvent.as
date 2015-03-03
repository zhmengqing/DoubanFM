package douban_format.event
{
    import flash.events.*;

    public class KbpsEvent extends Event
    {
        private var _value:String;
        private var _kbps:String;
        private var _change:Boolean;
        public static const KBPS_SHOULD_CHANGE:String = "kbps_should_change";

        public function KbpsEvent(param1:String)
        {
            super(param1);
            return;
        }// end function

        public function set value(param1:String) : void
        {
            this._value = param1;
            return;
        }// end function

        public function get value() : String
        {
            return this._value;
        }// end function

        public function set kbps(param1:String) : void
        {
            this._kbps = this.kbps;
            return;
        }// end function

        public function get kbps() : String
        {
            return this._kbps;
        }// end function

        public function set doChange(param1:Boolean) : void
        {
            this._change = param1;
            return;
        }// end function

        public function get doChange() : Boolean
        {
            return this._change;
        }// end function

    }
}
