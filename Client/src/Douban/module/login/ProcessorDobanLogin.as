package Douban.module.login 
{
	import Douban.component.UIComponent;
	import Douban.consts.CONST_RESOURCE;
	import Douban.loader.DisplayLoader;
	import Douban.manager.SResourceManager;
	import Douban.window.ProcessorWindow;
	
	/**
	 * ...
	 * @author zhmq
	 */
	public class ProcessorDobanLogin extends ProcessorWindow 
	{
		protected var FLoader:DisplayLoader;
		public function ProcessorDobanLogin(Parent:UIComponent) 
		{
			super(Parent);
			
			SResourceManager.RegisterLoadResource(
				CONST_RESOURCE.RESOURCEID_MAIN,
				InitWindow);
				
			SResourceManager.Load(CONST_RESOURCE.RESOURCEID_MAIN);
		}
		
		override protected function InitWindow():void 
		{
			super.InitWindow();
			
			
		}
	}

}