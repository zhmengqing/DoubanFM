package douban_format.utils
{
    import flash.display.*;
    import flash.events.*;

    public class Motion extends EventDispatcher
    {
        private var _target:DisplayObject;
        private var proNum:Number;
        private var startNum:Number;
        private var endNum:Number;
        private var actionStr:String;
        private var num1:uint;
        private var num2:uint;
        private var func:Function;
        private var cbfunc:Object;

        public function Motion(param1:DisplayObject, param2:String, param3:Function, param4:Number = 0, param5:Number = 1, param6:Number = 4)
        {
            this.actionStr = param2;
            this._target = param1;
            this.proNum = param6;
            this.startNum = param4;
            this.endNum = param5;
            this.func = param3;
            return;
        }// end function

        public function play(param1 = null)
        {
            this.stop();
            this.num1 = 0;
            this._target[this.actionStr] = this.startNum;
            this.cbfunc = param1;
            this._target.addEventListener(Event.ENTER_FRAME, this.fun1);
            return;
        }// end function

        private function fun1(event:Event)
        {
            var _loc_6:* = this;
            _loc_6.num1 = this.num1 + 1;
            var _loc_2:* = this.num1 + 1;
            var _loc_3:* = this.proNum;
            var _loc_4:* = this.startNum;
            var _loc_5:* = this.endNum - this.startNum;
            this._target[this.actionStr] = this.func(_loc_2, _loc_4, _loc_5, _loc_3);
            if (_loc_2 > _loc_3)
            {
                this.stop();
                this._target[this.actionStr] = this.endNum;
            }
            return;
        }// end function

        public function back(param1 = null)
        {
            this.stop();
            this.num2 = 0;
            this._target[this.actionStr] = this.endNum;
            this.cbfunc = param1;
            this._target.addEventListener(Event.ENTER_FRAME, this.fun2);
            return;
        }// end function

        private function fun2(event:Event)
        {
            var _loc_6:* = this;
            _loc_6.num2 = this.num2 + 1;
            var _loc_2:* = this.num2 + 1;
            var _loc_3:* = this.proNum;
            var _loc_4:* = this.endNum;
            var _loc_5:* = this.startNum - this.endNum;
            this._target[this.actionStr] = this.func(_loc_2, _loc_4, _loc_5, _loc_3);
            if (_loc_2 > _loc_3)
            {
                this.stop();
                this._target[this.actionStr] = this.startNum;
            }
            return;
        }// end function

        public function stop()
        {
            this._target.removeEventListener(Event.ENTER_FRAME, this.fun1);
            this._target.removeEventListener(Event.ENTER_FRAME, this.fun2);
            dispatchEvent(new Event("stop"));
            if (this.cbfunc)
            {
                this.cbfunc();
                this.cbfunc = undefined;
            }
            return;
        }// end function

    }
}
