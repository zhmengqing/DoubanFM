package Douban.manager 
{
	import Douban.consts.CONST_RESOURCE;
	import Douban.loader.*;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	/**
	 * swf资源加载管理器
	 * @author zhmq
	 */
	public class ResourceManager 
	{
		protected var FResourceLoader:ResourceLoader;
		protected var FResourceIds:Vector.<String>;
		protected var FResourceBacks:Vector.<Function>;
		protected var FIsLoading:Boolean;
		protected var FCurResource:String;
		protected var FLoadingResourceIds:Vector.<String>;
		protected var FLoadingTypes:Vector.<String>;
		protected var FLoaderContext:LoaderContext;
		
		public function ResourceManager() 
		{
			FResourceIds = new Vector.<String>;
			FResourceBacks = new Vector.<Function>;
			FLoadingResourceIds = new Vector.<String>;
			FLoadingTypes = new Vector.<String>;
			FResourceLoader = new ResourceLoader();
			FResourceLoader.OnComplete = ResourceOnComplete;
			FResourceLoader.OnError = ResourceOnError;
			
			FLoaderContext = new LoaderContext(
				false, 
				ApplicationDomain.currentDomain);
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
			
			FLoadingResourceIds.push(ResourceId);
			FLoadingTypes.push(Type);
			
			if (FIsLoading) return;
			FCurResource = ResourceId;
			LoadNext();
			
			FIsLoading = true;
		}
		
		protected function LoadNext():void
		{
			var Index:int;
			var Type:String;
			
			Index = FLoadingResourceIds.indexOf(FCurResource);
			
			Type = FLoadingTypes[Index];
			if (Type == "")
			{
				Type = CONST_RESOURCE.RESOURCE_TYPE_SWF;
			}
			FResourceLoader.loadResource(
				CONST_RESOURCE.RESOURCE_URL_BASE + FCurResource + Type,
				FLoaderContext);
			
			FIsLoading = true;
			
		}
		
		private function ResourceOnError(e:ErrorEvent):void 
		{
			ResourceNext();
		}
		
		private function ResourceOnComplete(Sender:Loader):void 
		{
			ResourceNext(Sender);
		}
		
		protected function ResourceNext(
			Sender:Loader = null):void
		{
			var Index:int;
			var FuncIndex:int;
			
			Index = FLoadingResourceIds.indexOf(FCurResource);
			
			if (Index > 0 && Index < FLoadingResourceIds.length - 1)
			{
				FCurResource = FLoadingResourceIds[Index + 1];
				LoadNext();
			}
			FIsLoading = false;
			
			if (Sender != null)			
			{
				FuncIndex = FResourceIds.indexOf(FCurResource);
				FResourceBacks[FuncIndex]();
				FResourceIds.splice(FuncIndex, 1);
				FResourceBacks.splice(FuncIndex, 1);
				FLoadingResourceIds.splice(FuncIndex, 1);
				FLoadingTypes.splice(FuncIndex, 1);
			}
			else
			{
				trace("ResourceId: " + FCurResource + " load fail");
			}			
			
		}
		
	}

}