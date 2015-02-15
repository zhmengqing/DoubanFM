package douban_format.display
{
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;

    public class GetProTip extends Sprite
    {
        private static const WIDTH:Number = 106;
        private static const HEIGHT:Number = 21;

        public function GetProTip()
        {
            var style:StyleSheet;
            var css:String;
            var overcss:String;
            var back:* = new Shape();
            back.graphics.beginFill(0, 0.7);
            back.graphics.drawRect(0, 0, WIDTH, HEIGHT);
            back.graphics.endFill();
            addChild(back);
            var txt:* = new TextField();
            style = new StyleSheet();
            var fontFamily:String;
            if (Capabilities.os.indexOf("Mac OS") != -1)
            {
                fontFamily;
            }
            css = "{text-align:center; font-size: 12; " + "font-family:" + fontFamily + "; color:#ffffff}";
            overcss = "{text-align:center; font-size: 12; " + "font-family:" + fontFamily + "; color:#55bb99}";
            style.parseCSS(".all" + css);
            txt.styleSheet = style;
            txt.htmlText = "<a class=\"all\">付费后，去广告</a>";
            txt.selectable = false;
            txt.width = WIDTH;
            txt.height = HEIGHT;
            addChild(txt);
            var clickMask:* = new Sprite();
            clickMask.graphics.beginFill(0, 0);
            clickMask.graphics.drawRect(0, 0, WIDTH, HEIGHT);
            clickMask.graphics.endFill();
            addChild(clickMask);
            clickMask.buttonMode = true;
            clickMask.addEventListener(MouseEvent.CLICK, function (event:MouseEvent) : void
            {
                navigateToURL(new URLRequest("/upgrade"));
                return;
            }// end function
            );
            clickMask.addEventListener(MouseEvent.MOUSE_OVER, function (event:MouseEvent) : void
            {
                style.parseCSS(".all" + overcss);
                return;
            }// end function
            );
            clickMask.addEventListener(MouseEvent.MOUSE_OUT, function (event:MouseEvent) : void
            {
                style.parseCSS(".all" + css);
                return;
            }// end function
            );
            return;
        }// end function

    }
}
