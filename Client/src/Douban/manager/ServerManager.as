package Douban.manager 
{
	import Douban.consts.CONST_SERVERID;
	import Douban.consts.CONST_URL;
	import Douban.loader.HttpLoader;
	import flash.net.URLRequestMethod;
	/**
	 * ...
	 * @author zhmq
	 */
	public class ServerManager 
	{
		protected var ServerLoader:HttpLoader;
		protected var FOnComplete:Function;
		
		protected var FServerFuncs:Vector.<Function>;
		protected var FServerIds:Vector.<uint>;
		
		protected var FCurServerId:uint;
		
		public function ServerManager() 
		{
			ServerLoader = new HttpLoader();
			ServerLoader.OnComplete = OnServerComplete;
			
			FServerIds = new Vector.<uint>;
			FServerFuncs = new Vector.<Function>;
			
			Registers();
		}
		
		protected function Registers():void
		{
			RegisterServer(CONST_SERVERID.SERVERID_CAPTCHA, LoadCaptcha);
			RegisterServer(CONST_SERVERID.SERVERID_LOGIN, LoadLogin);
			RegisterServer(CONST_SERVERID.SERVERID_SONG, LoadSong);
		}
		
		protected function RegisterServer(
			ServerId:uint,
			ServerFunc:Function):void
		{
			var Index:int;
			Index = FServerIds.indexOf(ServerId);
			if (Index != -1)
			{
				FServerFuncs[Index] = ServerFunc;
			}
			FServerIds.push(ServerId);
			FServerFuncs.push(ServerFunc);
		}
		
		public function Load(
			ServerId:uint,
			SData:* = null):void
		{
			var Index:int;
			Index = FServerIds.indexOf(ServerId);
			if (Index != -1)
			{
				FServerFuncs[Index](SData);				
			}
			else
			{
				trace("ServerId：" + ServerId +" has no register function");
			}
		}
		
		//获取验证码
		protected function LoadCaptcha(...args):void
		{
			FCurServerId = CONST_SERVERID.SERVERID_CAPTCHA;
			ServerLoader.Load(
				CONST_URL.LOGIN_CAPTCHA_URL);
		}
		
		//登录
		protected function LoadLogin(...args):void
		{
			FCurServerId = CONST_SERVERID.SERVERID_LOGIN;
			ServerLoader.Load(
				CONST_URL.LOGIN_URL,
				URLRequestMethod.POST,
				args[0]);
		}
		
		//下一首
		protected function LoadSong(...args):void
		{
			FCurServerId = CONST_SERVERID.SERVERID_SONG;
			ServerLoader.Load(
				CONST_URL.LOGIN_URL,
				"",
				args[0]);
		}
		
		private function OnServerComplete(Str:String):void 
		{
			trace(Str);
			if (FOnComplete != null)
			{
				FOnComplete(Str);
			}
		}
		
		public function get OnComplete():Function 
		{
			return FOnComplete;
		}
		
		public function set OnComplete(value:Function):void 
		{
			FOnComplete = value;
		}
		
		public function get CurServerId():uint 
		{
			return FCurServerId;
		}
		
	}

}