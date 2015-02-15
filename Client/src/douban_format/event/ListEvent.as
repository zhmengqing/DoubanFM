package douban_format.event
{
    import flash.events.*;

    public class ListEvent extends Event
    {
        private var msg:Object;
        public static const LISTEVENT:String = "onlistevent";

        public function ListEvent()
        {
            super(LISTEVENT);
            return;
        }// end function

        public function set message(param1) : void
        {
            this.msg = param1;
            return;
        }// end function

        public function get message()
        {
            return this.msg;
        }// end function

    }
}
