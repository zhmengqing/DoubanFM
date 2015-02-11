package Douban.manager 
{
	import Douban.consts.CONST_RESOURCE;
	import Douban.loader.*;
	import 
	import flash.display.Loader;
	/**
	 * ...
	 * @author zhmq
	 */
	public class ResourceManager 
	{
		protected var FResourceLoader:ResourceLoader;
		protected var FResourceIds:Vector.<String>;
		protected var FResourceBacks:Vector.<Function>;
		
		public function ResourceManager() 
		{
			FResourceLoader = new ResourceLoader()
			FResourceIds = new Vector.<String>;
			FResourceBacks = new Vector.<Function>;
		}
		
		public function RegisterLoadResource(
			ResourceId:String,
			Func:Function = null):void
		{
			FResourceIds.push(ResourceId);
			FResourceBacks.push(Func);
		}
		
		public function Load(
			ResourceId:String,
			Type:String = ""):void
		{
			var Index:int;
			
			if (Type == "")
			{
				Type = CONST_RESOURCE.RESOURCE_TYPE_SWF;
			}
			Index = FResourceIds.indexOf(ResourceId);
			FResourceLoader.loadResource(
				CONST_RESOURCE.RESOURCE_URL_BASE + ResourceId + Type);
			FResourceLoader.OnComplete = ResourceOnComplete;
		}
		
		private function ResourceOnComplete(Sender:Loader):void 
		{
			
		}
		
	}

}