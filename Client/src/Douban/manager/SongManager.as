package Douban.manager 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author zhmq
	 */
	public class SongManager 
	{
		protected var FSound:Sound;
		protected var FUrlRequest:URLRequest;
		public function SongManager() 
		{
			FSound = new Sound();
			FUrlRequest = new URLRequest();
			FSound.addEventListener(Event.SOUND_COMPLETE, SoundOnComplete);
		}
		
		private function SoundOnComplete(e:Event):void 
		{
			trace("sound load succ");
		}
		
		public function Load(Url:String):void
		{
			FUrlRequest.url = Url;
			FSound.load(FUrlRequest);
		}
		
	}

}