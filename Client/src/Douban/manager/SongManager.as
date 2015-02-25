package Douban.manager
{
	import Douban.logics.stream.StreamClient;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author zhmq
	 */
	public class SongManager
	{
		protected var FConnection:NetConnection;
		protected var FStream:NetStream;
		protected var FUrl:String;
		protected var FStreamClient:StreamClient;
		
		protected var FSongComplete:Function;
		
		public function SongManager()
		{
			FConnection = new NetConnection();
			FConnection.addEventListener(NetStatusEvent.NET_STATUS, OnNetStatus);
			FConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, OnSecurityError);	
			
			FStreamClient = new StreamClient();
			FStreamClient.OnPlayStatus = OnPlayStatus;
		}
		
		private function OnPlayStatus(Info:Object):void 
		{
			if (Info.code == "NetStream.Play.Complete")
			{
				FStream.close();
				FStream.removeEventListener(NetStatusEvent.NET_STATUS, OnNetStatus);
				FStream = null;
				
				if (FSongComplete != null)
				{
					FSongComplete();
				}
			}
		}
		
		private function OnStreamStatus(e:NetStatusEvent):void 
		{
			
		}
		
		private function OnNetStatus(e:NetStatusEvent):void 
		{
			switch (e.info.code) 
			{	
				case "NetConnection.Connect.Success":
                    ConnectStream();
                    break;
                case "NetStream.Play.StreamNotFound":
                    trace("Stream not found: " + FUrl);
                    break;
            }
		}
		
		private function ConnectStream():void 
		{
			FStream = new NetStream(FConnection);
			FStream.addEventListener(NetStatusEvent.NET_STATUS, OnNetStatus);
			FStream.client = FStreamClient;
			FStream.play(FUrl);
		}
		
		private function OnSecurityError(e:SecurityErrorEvent):void 
		{
			
		}		
		
		public function Load(
			Url:String,
			SongComplete:Function = null):void
		{
			FUrl = Url;
			FSongComplete = SongComplete;
			FConnection.connect(null);
		}	
		
	}
}
