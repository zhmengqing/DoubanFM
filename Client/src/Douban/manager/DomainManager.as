package Douban.manager 
{
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	/**
	 * ...
	 * @author zhmq
	 */
	public class DomainManager 
	{
		
		public function DomainManager() 
		{
			
		}
		
		public static function CreateDisplayByName(
			ClassName:String,
			AppDomain:ApplicationDomain = null):*
		{
			var AppClass:Class;
			
			AppClass = GetClass(
				ClassName,
				AppDomain);
			
			if (AppClass != null)
			{
				return new AppClass();
			}
			return null;
		}
		
		protected static function GetClass(
			ClassName:String,
			AppDomain:ApplicationDomain = null):Class
		{
			var AppClass:Class;
			
			if (AppDomain == null)
			{
				AppDomain = ApplicationDomain.currentDomain;
			}			
			
			if (AppDomain.hasDefinition(ClassName))
			{
				AppClass = AppDomain.getDefinition(
					ClassName) as Class;
					
				return AppClass;
			}
			return null;
		}
		
	}

}