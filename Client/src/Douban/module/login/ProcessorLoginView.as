package Douban.module.login 
{
	import Douban.component.UIButtton;
	import Douban.component.UIComponent;
	import Douban.consts.CONST_RESOURCE;
	import Douban.consts.CONST_SERVERID;
	import Douban.consts.CONST_URL;
	import Douban.manager.statics.DomainManager;
	import Douban.manager.singelar.SServerManager;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author zhmq
	 */
	public class ProcessorLoginView extends UIComponent 
	{
		protected var FMainUI:Sprite;
		protected var FTFName:TextField;
		protected var FTFPassword:TextField;
		protected var FTFCaptcha:TextField;
		protected var FTFInfo:TextField;
		protected var FMountPoint:Sprite;
		protected var FBtnLogin:UIButtton;
		protected var FCaptchaId:String;
		
		public function ProcessorLoginView(
			Parent:UIComponent) 
		{
			super(Parent);
			Visible = false;
		}
		
		public function InitView():void
		{
			FMainUI = DomainManager.CreateDisplayByName(
				CONST_RESOURCE.RESOURCE_VIEW_Login) as Sprite;
				
			this.addChild(FMainUI);
			
			FTFName = FMainUI["TF_Name"];
			FTFPassword = FMainUI["TF_Password"];
			FTFCaptcha = FMainUI["TF_Captcha"];			
			FTFInfo = FMainUI["TF_Info"];
			FBtnLogin = new UIButtton();
			FBtnLogin.Substrate = FMainUI["Btn_Login"];
			FBtnLogin.OnClick = LoginOnClick;
			FMountPoint = FMainUI["MC_Mount"];
			FMountPoint.addEventListener(MouseEvent.CLICK, CapchaOnClick);
			
			LoadCaptcha();
		}
		
		private function LoginOnClick(
			Sender:Object,
			E:MouseEvent):void 
		{
			var Vars:URLVariables = new URLVariables();
			
			Vars.source = "radio";
			Vars.alias = "zhmengqing@126.com";// FTFName.text;
			Vars.form_password = "jgegqq";// FTFPassword.text;
			Vars.captcha_solution = FTFCaptcha.text;
			Vars.captcha_id = FCaptchaId;
			Vars.task = "sync_channel_list";
			
			SServerManager.Load(
				CONST_SERVERID.SERVERID_LOGIN,
				Vars);
		}
		
		private function CapchaOnClick(e:MouseEvent):void 
		{
			FMountPoint.removeChildren();
			LoadCaptcha();
		}
		
		protected function LoadCaptcha():void
		{
			SServerManager.Load(
				CONST_SERVERID.SERVERID_CAPTCHA);
			FTFInfo.text = "";
		}
		
		public function AddCaptcha(
			Image:Loader):void
		{
			if(Visible)
			{
				FMountPoint.addChild(Image);
			}
		}
		
		public function ShowErrorInfo(
			Json:Object):void
		{
			FTFInfo.text = Json.err_msg;
		}
		
		public function get CaptchaId():String 
		{
			return FCaptchaId;
		}
		
		public function set CaptchaId(value:String):void 
		{
			FCaptchaId = value;
		}
		
	}

}