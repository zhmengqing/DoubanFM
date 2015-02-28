package Douban.module.hall.musicPlayer
{
	import Douban.consts.CONST_NETSTREAM;
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
	public class SongConnection
	{
		protected var FConnection:NetConnection;
		protected var FStream:NetStream;
		protected var FUrl:String;
		protected var FStreamClient:StreamClient;
		
		protected var FSongComplete:Function;
		protected var FOnMetaData:Function;
		
		public function SongConnection()
		{
			FConnection = new NetConnection();
			FConnection.addEventListener(NetStatusEvent.NET_STATUS, OnNetStatus);
			FConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, OnSecurityError);	
			
			FStreamClient = new StreamClient();
			FStreamClient.OnPlayStatus = OnPlayStatus;
			FStreamClient.OnMetaData = SongOnMetaData;
		}
		
		private function SongOnMetaData(Info:Object):void 
		{
			if (FOnMetaData != null)
			{
				FOnMetaData(Info);
			}
		}
		
		private function OnPlayStatus(Info:Object):void 
		{
			if (Info.code == CONST_NETSTREAM.NetStream_Play_Complete)
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
		
		private function OnNetStatus(e:NetStatusEvent):void 
		{
			switch (e.info.code) 
			{	
				case CONST_NETSTREAM.NetConnection_Connect_Success:
                    ConnectStream();
                    break;
                case CONST_NETSTREAM.NetStream_Play_StreamNotFound:
                    trace("Stream not found: " + FUrl);
					if (FSongComplete != null)
					{
						FSongComplete();
					}
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
		
		public function Seek(Offset:Number):void
		{
			FStream.seek(Offset);
			Resume();
		}
		
		public function Resume():void
		{
			FStream.resume();
		}
		
		public function Pause():void
		{
			FStream.pause();
		}
		
		public function get Stream():NetStream
		{
			return FStream;
		}
		
		public function get OnMetaData():Function 
		{
			return FOnMetaData;
		}
		
		public function set OnMetaData(value:Function):void 
		{
			FOnMetaData = value;
		}
		
	}
}
