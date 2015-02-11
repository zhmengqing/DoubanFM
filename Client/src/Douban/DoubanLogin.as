package Douban 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.*;
	/**
	 * ...
	 * @author zhmq
	 */
	public class DoubanLogin extends Sprite
	{
		protected const Captcha_Url:String = "http://douban.fm/j/new_captcha";
		protected const Captcha_Pic:String = "http://douban.fm/misc/captcha?size=m&id=";
		
		protected const Login_Url:String = "http://douban.fm/j/login";
		
		protected var FPicLoader:PicLoader;
		
		protected var FHttpLoader:HttpLoader;
		
		protected var FTFName:TextField;
		protected var FTFPassword:TextField;
		protected var FTFCaptcha:TextField;
		protected var FTFLogin:TextField;
		
		protected var FCaptchaId:String;
		 
		public function DoubanLogin() 
		{
			FHttpLoader = new HttpLoader();
			FHttpLoader.Load(Captcha_Url);					
			FHttpLoader.OnComplete = OnCompleteHandler; 
			
			FTFName = new TextField();
			FTFName.type = TextFieldType.INPUT;
			FTFName.border = true;
			FTFName.wordWrap = false;
			FTFName.width = 200;
			FTFName.height = 20;
			addChild(FTFName);
			
			FTFPassword = new TextField();
			FTFPassword.type = TextFieldType.INPUT;
			FTFPassword.border = true;
			FTFPassword.wordWrap = false;
			FTFPassword.width = 200;
			FTFPassword.height = 20;
			FTFPassword.displayAsPassword = true;
			addChild(FTFPassword);
			FTFPassword.y = FTFName.y + FTFName.height;
			
			FTFCaptcha = new TextField();
			FTFCaptcha.type = TextFieldType.INPUT;
			FTFCaptcha.border = true;
			FTFCaptcha.wordWrap = false;
			FTFCaptcha.width = 200;
			FTFCaptcha.height = 20;
			addChild(FTFCaptcha);
			FTFCaptcha.y = FTFPassword.y + FTFPassword.height;
			
			FPicLoader = new PicLoader();
			FPicLoader.OnComplete = OnPicComplete;
			addChild(FPicLoader);
			FPicLoader.y = FTFCaptcha.y + FTFCaptcha.height + 10;
			
			FTFLogin = new TextField();
			FTFLogin.autoSize = TextFieldAutoSize.LEFT;
			FTFLogin.selectable = false;
			FTFLogin.htmlText = "<font><a href='event:login'><u>Login</u></a></font>";
			FTFLogin.addEventListener(TextEvent.LINK, OnLogin)
			addChild(FTFLogin);
			FTFLogin.visible = false;
		}
		
		private function OnLogin(e:TextEvent):void 
		{
			var vars:URLVariables = new URLVariables();
			if (e.text == "login")
			{
				trace("login");
			 
				vars.source = "radio";
				vars.alias = "zhmengqing@126.com";// FTFName.text;
				vars.form_password = "jgegqq";// FTFPassword.text;
				vars.captcha_solution = FTFCaptcha.text;
				vars.captcha_id = FCaptchaId;
				vars.task = "sync_channel_list";
				
				FHttpLoader.Load(
					Login_Url, 
					URLRequestMethod.POST,
					vars);
			}
		}
		
		protected function OnCompleteHandler(Obj:Object):void
		{
			var Url:String;
			var Pic:String;
			
			if(Obj is String)
			{
				Pic = Obj as String;
				
				FCaptchaId = Pic.split("\"")[1];
				Url = Captcha_Pic + FCaptchaId;
				FPicLoader.Load(Url);
			}
		}
		
		protected function OnPicComplete(
			Sender:Loader):void
		{
			FTFLogin.visible = true;
			FTFLogin.y = FPicLoader.y + FPicLoader.height;
		}
		
	}

}