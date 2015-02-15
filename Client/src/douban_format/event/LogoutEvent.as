package douban_format.event
{
    import flash.events.*;

    public class LogoutEvent extends Event
    {
        public static const ONLOGOUT:String = "onLogout";

        public function LogoutEvent()
        {
            super(ONLOGOUT);
            return;
        }// end function

    }
}
