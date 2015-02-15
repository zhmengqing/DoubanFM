package Douban.module.hall 
{
	import Douban.component.UIComponent;
	import Douban.consts.CONST_RESOURCE;
	import Douban.manager.DomainManager;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author zhmq
	 */
	public class ProcessorHallView extends UIComponent 
	{
		protected var FMainUI:Sprite;
		protected var FMountPoint:Sprite;
		
		public function ProcessorHallView(
			Parent:UIComponent) 
		{
			super(Parent);
			
		}
		
		public function InitView():void
		{
			FMainUI = DomainManager.CreateDisplayByName(
				CONST_RESOURCE.RESOURCE_VIEW_Login) as Sprite;
				
			this.addChild(FMainUI);
			
			FMountPoint = FMainUI["MC_MountPoint"];
		}
	}

}