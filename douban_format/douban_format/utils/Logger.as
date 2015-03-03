package douban_format.utils
{
    import com.adobe.serialization.json.*;
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class Logger extends Sprite
    {
        private var extLogger:String;
        private var HOST:String;
        private var repLoader:URLLoader;
        private var startTime:Number;

        public function Logger(... args)
        {
            this.startTime = getTimer();
            this.extLogger = args.length > 0 ? (args[0]) : ("console.log");
            this.HOST = args.length > 1 ? (args[1]) : ("");
            this.log("Logger init, host =", this.HOST, "ext =", this.extLogger, "ver =", Format.RADIO_VER);
            this.repLoader = new URLLoader();
            this.repLoader.addEventListener(IOErrorEvent.IO_ERROR, this.loader_ioError);
            return;
        }// end function

        public function log(... args) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            args = "";
            for (_loc_3 in args)
            {
                
                _loc_4 = args[_loc_3];
                if ("string" == "object")
                {
                    try
                    {
                        _loc_4 = JSON.encode(_loc_4);
                    }
                    catch (e)
                    {
                    }
                }
                args = args + (" " + String(_loc_4));
            }
            trace((getTimer() - this.startTime) / 1000 + "> " + args);
            ExternalInterface.call(this.extLogger, args);
            return;
        }// end function

        public function report(param1:String, param2:String) : void
        {
            var reason:* = param1;
            var kind:* = param2;
            if (!this.HOST)
            {
                return;
            }
            this.log("report for reason: " + reason + " kind: " + kind);
            var env:* = ExternalInterface.call("function(){return navigator.userAgent}");
            env = env + (" V:" + Capabilities.version);
            env = env + (" SV:" + Format.RADIO_VER);
            var rurl:* = this.HOST + "/j/except_report";
            rurl = rurl + "?kind=" + kind + "&reason=" + encodeURIComponent(reason) + "&env=" + encodeURIComponent(env);
            try
            {
                this.repLoader.load(new URLRequest(rurl));
            }
            catch (e)
            {
                loader_ioError(e);
            }
            return;
        }// end function

        public function count(param1:String) : void
        {
            var type:* = param1;
            try
            {
                this.repLoader.load(new URLRequest(this.HOST + "/j/misc/count?type=" + type));
                this.log("report " + type);
            }
            catch (e)
            {
                loader_ioError(e);
            }
            return;
        }// end function

        private function loader_ioError(event:IOErrorEvent) : void
        {
            this.log("report loader failed.");
            return;
        }// end function

    }
}
