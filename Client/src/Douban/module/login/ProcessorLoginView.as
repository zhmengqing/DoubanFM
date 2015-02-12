package Douban.module.login 
{
	import Douban.component.UIComponent;
	import Douban.consts.CONST_RESOURCE;
	import Douban.manager.DomainManager;
	import flash.display.Sprite;
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
		
		public function ProcessorLoginView(
			Parent:UIComponent) 
		{
			super(Parent);
			
		}
		
		public function InitView():void
		{
			FMainUI = DomainManager.CreateDisplayByName(
				CONST_RESOURCE.RESOURCE_VIEW_Login) as Sprite;
				
			this.addChild(FMainUI);
			
			FTFName = FMainUI["TF_Name"];
			FTFPassword = FMainUI["TF_Password"];
			FTFCaptcha = FMainUI["TF_Captcha"];
		}
		
	}

}