package Douban.module 
{
	import Douban.component.UIComponent;
	import Douban.consts.CONST_RESOURCE;
	import Douban.consts.CONST_SERVERID;
	import Douban.consts.CONST_URL;
	import Douban.loader.HttpLoader;
	import Douban.loader.ResourceLoader;
	import Douban.logics.song.UnstreamizerSong;
	import Douban.manager.statics.DomainManager;
	import Douban.manager.singelar.SResourceManager;
	import Douban.manager.singelar.SServerManager;
	import Douban.module.hall.ProcessorHallView;
	import Douban.module.login.ProcessorLoginView;
	import Douban.window.ProcessorWindow;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	
	/**
	 * ...
	 * @author zhmq
	 */
	public class ProcessorDoubanModule extends ProcessorWindow 
	{
		protected var FLoginView:ProcessorLoginView;
		protected var FHallView:ProcessorHallView;
		protected var FProcessorViews:Vector.<UIComponent>;
		protected var FImageLoader:ResourceLoader;
		
		
		public function ProcessorDoubanModule(
			Parent:UIComponent) 
		{
			super(Parent);
			
			SResourceManager.RegisterLoadResource(
				CONST_RESOURCE.RESOURCEID_MAIN,
				MainLoadComplete);
				
			SResourceManager.Load(
				CONST_RESOURCE.RESOURCEID_MAIN);
			
			FLoginView = new ProcessorLoginView(this);
			FLoginView.OnSwitchView = OnSwitchView;
			FHallView = new ProcessorHallView(this);
			FHallView.OnSwitchView = OnSwitchView;
			
			SServerManager.OnComplete = ServerOnComplete;
			
			FImageLoader = new ResourceLoader();
			FImageLoader.OnComplete = ImageOnComplete;
			
			FProcessorViews = Vector.<UIComponent>([
				FLoginView,
				FHallView]);
				
			
		}
		
		private function OnSwitchView(
			Sender:Object):void 
		{
			var View:UIComponent;
			
			View = Sender as UIComponent;
			switch(View)
			{
				case FHallView:
					SwitchView(FLoginView);
					FLoginView.InitView();
					break;
				case FLoginView:
					SwitchView(FHallView);
					break;
			}
		}
		
		private function ImageOnComplete(
			Image:Loader):void 
		{
			FLoginView.AddCaptcha(
				Image);
			FHallView.AddPicture(
				Image);
		}
		
		protected function MainLoadComplete():void 
		{	
			SwitchView(FHallView);
			//FLoginView.InitView(SwitchView);
			FHallView.InitView();			
		}
		
		protected function ServerOnComplete(
			ServerData:String):void
		{
			var Obj:Object;
			var Str:String;
			
			Obj = JSON.parse(ServerData);
			
			switch(SServerManager.CurServerId)
			{
				//获取到验证码，要加载图片
				case CONST_SERVERID.SERVERID_CAPTCHA:
					Str = Obj as String;
					FImageLoader.loadResource(
						CONST_URL.LOGIN_CAPTCHA_PIC + Str);
					FLoginView.CaptchaId = Str;
					break;
				//请求登录
				case CONST_SERVERID.SERVERID_LOGIN:
					if (Obj.err_msg != null)
					{
						FLoginView.ShowErrorInfo(Obj);
						trace("Login fail");
						break;
					}
					trace("Login succ");
					SwitchView(FHallView);
					FHallView.InitView();
					break;
				//下一首
				case CONST_SERVERID.SERVERID_SONG:
					trace("music");
					FHallView.SetData(Obj);
					if(FHallView.NeedSkip)
					{
						FHallView.LoadSong();
						if (FHallView.CurSong == null) break;
						FImageLoader.loadResource(
							FHallView.CurSong.PictureUrl);
					}
					break;
			}
		}
		
		protected function SwitchView(
			View:UIComponent):void
		{
			var Index:int;
			var Count:int;
			
			Count = FProcessorViews.length;
			for (Index = 0; Index < Count; Index++)
			{
				FProcessorViews[Index].Visible = false;
			}
			View.Visible = true;
		}
	}

}