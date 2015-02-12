package Douban.module.login 
{
	import Douban.component.UIComponent;
	import Douban.consts.CONST_RESOURCE;
	import Douban.loader.DisplayLoader;
	import Douban.manager.DomainManager;
	import Douban.manager.SResourceManager;
	import Douban.window.ProcessorWindow;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	
	/**
	 * ...
	 * @author zhmq
	 */
	public class ProcessorDobanLogin extends ProcessorWindow 
	{
		protected var FLoader:DisplayLoader;
		protected var FMainUI:Sprite;
		
		public function ProcessorDobanLogin(Parent:UIComponent) 
		{
			super(Parent);
			
			SResourceManager.RegisterLoadResource(
				CONST_RESOURCE.RESOURCEID_MAIN,
				InitWindow);
				
			SResourceManager.Load(CONST_RESOURCE.RESOURCEID_MAIN);
		}
		
		protected function InitWindow():void 
		{			
			FMainUI = DomainManager.CreateDisplayByName(
				CONST_RESOURCE.RESOURCE_VIEW_Login) as Sprite;
		}
	}

}