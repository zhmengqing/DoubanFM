package douban_format.event
{
    import flash.events.*;

    public class SongEvent extends Event
    {
        private var songData:Object;
        public static const SONG_EVENT:String = "songEvent";

        public function SongEvent()
        {
            super(SONG_EVENT);
            return;
        }// end function

        public function set data(param1) : void
        {
            this.songData = param1;
            return;
        }// end function

        public function get data()
        {
            return this.songData;
        }// end function

    }
}
