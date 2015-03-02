package Douban.manager.singelar 
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
			RegisterServer(CONST_SERVERID.SERVERID_SHARE, LoadShare);
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
		
		//这里加载，返回在Module类里
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
				URLRequestMethod.GET,
				args[0]);
				//"http://douban.fm/j/login?source=radio&alias=zhmengqing%40126.com&form_password=jgegqq&captcha_solution="+ args[0].solution +"&captcha_id="+ args[0].id +"%3Aen&remember=on&task=sync_channel_list",
				//URLRequestMethod.POST);
		}
		
		//下一首
		protected function LoadSong(...args):void
		{
			FCurServerId = CONST_SERVERID.SERVERID_SONG;
			ServerLoader.Load(
				args[0]);
		}
		
		protected function LoadShare(...args):void
		{
			
		}
		
		private function OnServerComplete(Str:String):void 
		{
			trace("收到返回 " + Str);
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