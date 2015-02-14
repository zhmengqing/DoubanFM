package Douban.module.login 
{
	import Douban.component.UIComponent;
	import Douban.consts.CONST_RESOURCE;
	import Douban.consts.CONST_SERVERID;
	import Douban.loader.HttpLoader;
	import Douban.manager.DomainManager;
	import Douban.manager.SResourceManager;
	import Douban.manager.SServerManager;
	import Douban.window.ProcessorWindow;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	
	/**
	 * ...
	 * @author zhmq
	 */
	public class ProcessorDobanLogin extends ProcessorWindow 
	{
		protected var FLoginView:ProcessorLoginView;
		
		public function ProcessorDobanLogin(
			Parent:UIComponent) 
		{
			super(Parent);
			
			SResourceManager.RegisterLoadResource(
				CONST_RESOURCE.RESOURCEID_MAIN,
				MainLoadComplete);
				
			SResourceManager.Load(CONST_RESOURCE.RESOURCEID_MAIN);
			
			FLoginView = new ProcessorLoginView(this);
			
			SServerManager.OnComplete = ServerOnComplete;
		}
		
		protected function MainLoadComplete():void 
		{	
			FLoginView.InitView();			
		}
		
		protected function ServerOnComplete(
			ServerData:String):void
		{
			var Obj:Object;
			Obj = JSON.parse(ServerData);
			
			switch(SServerManager.CurServerId)
			{
				case CONST_SERVERID.SERVERID_CAPTCHA:
					//获取到验证码，要加载图片
					break;
			}
		}
	}

}