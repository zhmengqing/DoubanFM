package douban_format.event
{
    import flash.events.*;

    public class PlayErrorEvent extends Event
    {
        private var _err:String;
        private var _val:Number;
        private var _pos:Number = 1.#INF;
        public static const PLAY_ERROR:String = "playError";
        public static const ERROR_LOAD_TIMEOUT:String = "errorLoadTimeout";
        public static const ERROR_BUFFERING:String = "errorBuffering";
        public static const ERROR_IOERROR:String = "errorIOError";
        public static const ERROR_SECURITY_ERROR:String = "errorSecurityError";

        public function PlayErrorEvent()
        {
            super(PLAY_ERROR);
            return;
        }// end function

        public function set error(param1:String) : void
        {
            this._err = param1;
            return;
        }// end function

        public function get error() : String
        {
            return this._err;
        }// end function

        public function set value(param1:int) : void
        {
            this._val = param1;
            return;
        }// end function

        public function get value() : int
        {
            return this._val;
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
