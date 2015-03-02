package douban_format.media
{
    import com.douban.event.*;
    import com.douban.utils.*;
    import flash.events.*;
    import flash.external.*;

    public class ExtVideoPlayer extends EventDispatcher
    {
        private var lg:Logger;
        public var progress:Number = 0;

        public function ExtVideoPlayer(param1:Logger)
        {
            this.lg = param1;
            ExternalInterface.addCallback("video_complete", this.videoComplete);
            return;
        }// end function

        public function play(param1:Object) : void
        {
            var _loc_2:* = ExternalInterface.call("DBR.play_video", param1);
            if (!_loc_2)
            {
                this.lg.log("no video hander");
                this.videoComplete(0);
            }
            return;
        }// end function

        public function videoComplete(param1) : void
        {
            var playTime:* = param1;
            try
            {
                this.progress = parseFloat(playTime);
            }
            catch (e:Error)
            {
                lg.log("parse play time error", e);
                progress = 0;
            }
            var ev:* = new CompleteEvent(CompleteEvent.COMPLETE);
            dispatchEvent(ev);
            return;
        }// end function

    }
}
