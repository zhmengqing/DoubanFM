package douban_format.utils
{

    public class Format extends Object
    {
        public static var RADIO_VER:String = "2.2.1";

        public function Format()
        {
            return;
        }// end function

        public static function msFormat(param1:Number, param2:Boolean = true) : String
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            if (!param1)
            {
                param1 = 0;
            }
            var _loc_3:* = param1 / 60000;
            var _loc_4:* = param1 / 1000 - _loc_3 * 60;
            _loc_5 = param2 && _loc_3 < 10 ? ("0" + String(_loc_3)) : (String(_loc_3));
            _loc_6 = _loc_4 < 10 ? ("0" + String(_loc_4)) : (String(_loc_4));
            return _loc_5 + ":" + _loc_6;
        }// end function

        public static function signUrl(param1:String) : String
        {
            return param1 + (param1.indexOf("?") == -1 ? ("?") : ("&")) + "r=" + Format.MD5(param1 + "fr0d0").substr(-10);
        }// end function

        public static function MD5(param1)
        {
            var k:*;
            var AA:*;
            var BB:*;
            var CC:*;
            var DD:*;
            var a:*;
            var b:*;
            var c:*;
            var d:*;
            var string:* = param1;
            var RotateLeft:* = function (param1, param2)
            {
                return param1 << param2 | param1 >>> 32 - param2;
            }// end function
            ;
            var AddUnsigned:* = function (param1, param2)
            {
                var _loc_3:* = undefined;
                var _loc_4:* = undefined;
                var _loc_5:* = undefined;
                var _loc_6:* = undefined;
                var _loc_7:* = undefined;
                _loc_5 = param1 & 2147483648;
                _loc_6 = param2 & 2147483648;
                _loc_3 = param1 & 1073741824;
                _loc_4 = param2 & 1073741824;
                _loc_7 = (param1 & 1073741823) + (param2 & 1073741823);
                if (_loc_3 & _loc_4)
                {
                    return _loc_7 ^ 2147483648 ^ _loc_5 ^ _loc_6;
                }
                if (_loc_3 | _loc_4)
                {
                    if (_loc_7 & 1073741824)
                    {
                        return _loc_7 ^ 3221225472 ^ _loc_5 ^ _loc_6;
                    }
                    return _loc_7 ^ 1073741824 ^ _loc_5 ^ _loc_6;
                }
                else
                {
                    return _loc_7 ^ _loc_5 ^ _loc_6;
                }
            }// end function
            ;
            var F:* = function (param1, param2, param3)
            {
                return param1 & param2 | ~param1 & param3;
            }// end function
            ;
            var G:* = function (param1, param2, param3)
            {
                return param1 & param3 | param2 & ~param3;
            }// end function
            ;
            var H:* = function (param1, param2, param3)
            {
                return param1 ^ param2 ^ param3;
            }// end function
            ;
            var I:* = function (param1, param2, param3)
            {
                return param2 ^ (param1 | ~param3);
            }// end function
            ;
            var FF:* = function (param1, param2, param3, param4, param5, param6, param7)
            {
                param1 = AddUnsigned(param1, AddUnsigned(AddUnsigned(F(param2, param3, param4), param5), param7));
                return AddUnsigned(RotateLeft(param1, param6), param2);
            }// end function
            ;
            var GG:* = function (param1, param2, param3, param4, param5, param6, param7)
            {
                param1 = AddUnsigned(param1, AddUnsigned(AddUnsigned(G(param2, param3, param4), param5), param7));
                return AddUnsigned(RotateLeft(param1, param6), param2);
            }// end function
            ;
            var HH:* = function (param1, param2, param3, param4, param5, param6, param7)
            {
                param1 = AddUnsigned(param1, AddUnsigned(AddUnsigned(H(param2, param3, param4), param5), param7));
                return AddUnsigned(RotateLeft(param1, param6), param2);
            }// end function
            ;
            var II:* = function (param1, param2, param3, param4, param5, param6, param7)
            {
                param1 = AddUnsigned(param1, AddUnsigned(AddUnsigned(I(param2, param3, param4), param5), param7));
                return AddUnsigned(RotateLeft(param1, param6), param2);
            }// end function
            ;
            var ConvertToWordArray:* = function (param1)
            {
                var _loc_2:* = undefined;
                var _loc_3:* = param1.length;
                var _loc_4:* = _loc_3 + 8;
                var _loc_5:* = (_loc_4 - _loc_4 % 64) / 64;
                var _loc_6:* = (_loc_5 + 1) * 16;
                var _loc_7:* = new Array((_loc_6 - 1));
                var _loc_8:* = 0;
                var _loc_9:* = 0;
                while (_loc_9 < _loc_3)
                {
                    
                    _loc_2 = (_loc_9 - _loc_9 % 4) / 4;
                    _loc_8 = _loc_9 % 4 * 8;
                    _loc_7[_loc_2] = _loc_7[_loc_2] | param1.charCodeAt(_loc_9) << _loc_8;
                    _loc_9 = _loc_9 + 1;
                }
                _loc_2 = (_loc_9 - _loc_9 % 4) / 4;
                _loc_8 = _loc_9 % 4 * 8;
                _loc_7[_loc_2] = _loc_7[_loc_2] | 128 << _loc_8;
                _loc_7[_loc_6 - 2] = _loc_3 << 3;
                _loc_7[(_loc_6 - 1)] = _loc_3 >>> 29;
                return _loc_7;
            }// end function
            ;
            var WordToHex:* = function (param1)
            {
                var _loc_4:* = undefined;
                var _loc_5:* = undefined;
                var _loc_2:* = "";
                var _loc_3:* = "";
                _loc_5 = 0;
                while (_loc_5 <= 3)
                {
                    
                    _loc_4 = param1 >>> _loc_5 * 8 & 255;
                    _loc_3 = "0" + _loc_4.toString(16);
                    _loc_2 = _loc_2 + _loc_3.substr(_loc_3.length - 2, 2);
                    _loc_5 = _loc_5 + 1;
                }
                return _loc_2;
            }// end function
            ;
            var Utf8Encode:* = function (param1)
            {
                var _loc_4:* = undefined;
                var _loc_2:* = "";
                var _loc_3:* = 0;
                while (_loc_3 < param1.length)
                {
                    
                    _loc_4 = param1.charCodeAt(_loc_3);
                    if (_loc_4 < 128)
                    {
                        _loc_2 = _loc_2 + String.fromCharCode(_loc_4);
                    }
                    else if (_loc_4 > 127 && _loc_4 < 2048)
                    {
                        _loc_2 = _loc_2 + String.fromCharCode(_loc_4 >> 6 | 192);
                        _loc_2 = _loc_2 + String.fromCharCode(_loc_4 & 63 | 128);
                    }
                    else
                    {
                        _loc_2 = _loc_2 + String.fromCharCode(_loc_4 >> 12 | 224);
                        _loc_2 = _loc_2 + String.fromCharCode(_loc_4 >> 6 & 63 | 128);
                        _loc_2 = _loc_2 + String.fromCharCode(_loc_4 & 63 | 128);
                    }
                    _loc_3 = _loc_3 + 1;
                }
                return _loc_2;
            }// end function
            ;
            var x:*;
            var S11:*;
            var S12:*;
            var S13:*;
            var S14:*;
            var S21:*;
            var S22:*;
            var S23:*;
            var S24:*;
            var S31:*;
            var S32:*;
            var S33:*;
            var S34:*;
            var S41:*;
            var S42:*;
            var S43:*;
            var S44:*;
            string = Format.Utf8Encode(string);
            x = Format.ConvertToWordArray(string);
            a;
            b;
            c;
            d;
            k;
            while (k < x.length)
            {
                
                AA = a;
                BB = b;
                CC = c;
                DD = d;
                a = Format.FF(a, b, c, d, x[k + 0], S11, 3614090360);
                d = Format.FF(d, a, b, c, x[(k + 1)], S12, 3905402710);
                c = Format.FF(c, d, a, b, x[k + 2], S13, 606105819);
                b = Format.FF(b, c, d, a, x[k + 3], S14, 3250441966);
                a = Format.FF(a, b, c, d, x[k + 4], S11, 4118548399);
                d = Format.FF(d, a, b, c, x[k + 5], S12, 1200080426);
                c = Format.FF(c, d, a, b, x[k + 6], S13, 2821735955);
                b = Format.FF(b, c, d, a, x[k + 7], S14, 4249261313);
                a = Format.FF(a, b, c, d, x[k + 8], S11, 1770035416);
                d = Format.FF(d, a, b, c, x[k + 9], S12, 2336552879);
                c = Format.FF(c, d, a, b, x[k + 10], S13, 4294925233);
                b = Format.FF(b, c, d, a, x[k + 11], S14, 2304563134);
                a = Format.FF(a, b, c, d, x[k + 12], S11, 1804603682);
                d = Format.FF(d, a, b, c, x[k + 13], S12, 4254626195);
                c = Format.FF(c, d, a, b, x[k + 14], S13, 2792965006);
                b = Format.FF(b, c, d, a, x[k + 15], S14, 1236535329);
                a = Format.GG(a, b, c, d, x[(k + 1)], S21, 4129170786);
                d = Format.GG(d, a, b, c, x[k + 6], S22, 3225465664);
                c = Format.GG(c, d, a, b, x[k + 11], S23, 643717713);
                b = Format.GG(b, c, d, a, x[k + 0], S24, 3921069994);
                a = Format.GG(a, b, c, d, x[k + 5], S21, 3593408605);
                d = Format.GG(d, a, b, c, x[k + 10], S22, 38016083);
                c = Format.GG(c, d, a, b, x[k + 15], S23, 3634488961);
                b = Format.GG(b, c, d, a, x[k + 4], S24, 3889429448);
                a = Format.GG(a, b, c, d, x[k + 9], S21, 568446438);
                d = Format.GG(d, a, b, c, x[k + 14], S22, 3275163606);
                c = Format.GG(c, d, a, b, x[k + 3], S23, 4107603335);
                b = Format.GG(b, c, d, a, x[k + 8], S24, 1163531501);
                a = Format.GG(a, b, c, d, x[k + 13], S21, 2850285829);
                d = Format.GG(d, a, b, c, x[k + 2], S22, 4243563512);
                c = Format.GG(c, d, a, b, x[k + 7], S23, 1735328473);
                b = Format.GG(b, c, d, a, x[k + 12], S24, 2368359562);
                a = Format.HH(a, b, c, d, x[k + 5], S31, 4294588738);
                d = Format.HH(d, a, b, c, x[k + 8], S32, 2272392833);
                c = Format.HH(c, d, a, b, x[k + 11], S33, 1839030562);
                b = Format.HH(b, c, d, a, x[k + 14], S34, 4259657740);
                a = Format.HH(a, b, c, d, x[(k + 1)], S31, 2763975236);
                d = Format.HH(d, a, b, c, x[k + 4], S32, 1272893353);
                c = Format.HH(c, d, a, b, x[k + 7], S33, 4139469664);
                b = Format.HH(b, c, d, a, x[k + 10], S34, 3200236656);
                a = Format.HH(a, b, c, d, x[k + 13], S31, 681279174);
                d = Format.HH(d, a, b, c, x[k + 0], S32, 3936430074);
                c = Format.HH(c, d, a, b, x[k + 3], S33, 3572445317);
                b = Format.HH(b, c, d, a, x[k + 6], S34, 76029189);
                a = Format.HH(a, b, c, d, x[k + 9], S31, 3654602809);
                d = Format.HH(d, a, b, c, x[k + 12], S32, 3873151461);
                c = Format.HH(c, d, a, b, x[k + 15], S33, 530742520);
                b = Format.HH(b, c, d, a, x[k + 2], S34, 3299628645);
                a = Format.II(a, b, c, d, x[k + 0], S41, 4096336452);
                d = Format.II(d, a, b, c, x[k + 7], S42, 1126891415);
                c = Format.II(c, d, a, b, x[k + 14], S43, 2878612391);
                b = Format.II(b, c, d, a, x[k + 5], S44, 4237533241);
                a = Format.II(a, b, c, d, x[k + 12], S41, 1700485571);
                d = Format.II(d, a, b, c, x[k + 3], S42, 2399980690);
                c = Format.II(c, d, a, b, x[k + 10], S43, 4293915773);
                b = Format.II(b, c, d, a, x[(k + 1)], S44, 2240044497);
                a = Format.II(a, b, c, d, x[k + 8], S41, 1873313359);
                d = Format.II(d, a, b, c, x[k + 15], S42, 4264355552);
                c = Format.II(c, d, a, b, x[k + 6], S43, 2734768916);
                b = Format.II(b, c, d, a, x[k + 13], S44, 1309151649);
                a = Format.II(a, b, c, d, x[k + 4], S41, 4149444226);
                d = Format.II(d, a, b, c, x[k + 11], S42, 3174756917);
                c = Format.II(c, d, a, b, x[k + 2], S43, 718787259);
                b = Format.II(b, c, d, a, x[k + 9], S44, 3951481745);
                a = Format.AddUnsigned(a, AA);
                b = Format.AddUnsigned(b, BB);
                c = Format.AddUnsigned(c, CC);
                d = Format.AddUnsigned(d, DD);
                k = k + 16;
            }
            var temp:* = Format.WordToHex(a) + Format.WordToHex(b) + Format.WordToHex(c) + Format.WordToHex(d);
            return temp.toLowerCase();
        }// end function

    }
}
