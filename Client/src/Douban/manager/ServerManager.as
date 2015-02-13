package Douban.manager 
{
	import Douban.loader.HttpLoader;
	/**
	 * ...
	 * @author zhmq
	 */
	public class ServerManager 
	{
		protected var ServerLoader:HttpLoader;
		
		public function ServerManager() 
		{
			ServerLoader = new HttpLoader();
			ServerLoader.OnComplete = OnServerComplete;
		}
		
		private function OnServerComplete(Str:String):void 
		{
			trace(Str);
		}
		
	}

}