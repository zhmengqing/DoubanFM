package Douban.logics.stream 
{
	import Douban.logics.stream.base.BaseClient;
	
	/**
	 * ...
	 * @author zhmq
	 */
	public class StreamClient
	{
		protected var FOnCuePoint:Function;
		protected var FOnImageData:Function;
		protected var FOnMetaData:Function;
		protected var FOnPlayStatus:Function;
		protected var FOnSeekPoint:Function;
		protected var FOnTextData:Function;
		protected var FOnXMPData:Function;
		public function StreamClient() 
		{
			
			
		}
		
		//当播放 FLV 文件时，在到达嵌入的提示点时调用
		public function onCuePoint(info:Object):void 
		{
			trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
			
			if (FOnCuePoint != null)
			{
				FOnCuePoint(info);
			}
		}
		
		//以字节数组形式接收到正在播放的媒体文件中嵌入的图像数据时建立侦听器进行响应
		public function onImageData(info:Object):void
		{
			trace("imageData length: " + info.data.length);
			
			if (FOnImageData != null)
			{
				FOnImageData(info);
			}
		}
		
		//接收到正在播放的视频中嵌入的描述性信息时建立侦听器进行响应
		public function onMetaData(info:Object):void 
		{
			trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
			
			if (FOnMetaData != null)
			{
				FOnMetaData(info);
			}
		}
		
		//在 NetStream 对象已完全播放流时建立侦听器进行响应
		public function onPlayStatus(info:Object):void
		{
			trace("status: " + info.code);
			
			if (FOnPlayStatus != null)
			{
				FOnPlayStatus(info);
			}
		}
		
		//遇到可搜索的点（例如，视频关键帧）时从 appendBytes() 同步调用
		public function onSeekPoint(info:Object):void
		{
			if (FOnSeekPoint != null)
			{
				FOnSeekPoint(info);
			}
		}
		
		//接收到正在播放的媒体文件中嵌入的文本数据时建立侦听器进行响应
		public function onTextData(info:Object):void
		{
			var key:String;
			for (key in info) 
			{
                trace(key + ": " + info[key]);
            }
			
			if (FOnTextData != null)
			{
				FOnTextData(info);
			}
		}
		
		//建立一个侦听器，以便在 Flash Player 接收到特定于正在播放的视频中嵌入的 Adobe 可扩展元数据平台 (XMP) 的信息时进行响应
		public function onXMPData(info:Object):void
		{
			if (FOnXMPData != null)
			{
				FOnXMPData(info);
			}
		}
		
		public function OnSendStream(info:Object):void
		{
			trace(info);
		}
		
		public function get OnCuePoint():Function 
		{
			return FOnCuePoint;
		}
		
		public function set OnCuePoint(value:Function):void 
		{
			FOnCuePoint = value;
		}
		
		public function get OnImageData():Function 
		{
			return FOnImageData;
		}
		
		public function set OnImageData(value:Function):void 
		{
			FOnImageData = value;
		}
		
		public function get OnMetaData():Function 
		{
			return FOnMetaData;
		}
		
		public function set OnMetaData(value:Function):void 
		{
			FOnMetaData = value;
		}
		
		public function get OnPlayStatus():Function 
		{
			return FOnPlayStatus;
		}
		
		public function set OnPlayStatus(value:Function):void 
		{
			FOnPlayStatus = value;
		}
		
		public function get OnSeekPoint():Function 
		{
			return FOnSeekPoint;
		}
		
		public function set OnSeekPoint(value:Function):void 
		{
			FOnSeekPoint = value;
		}
		
		public function get OnTextData():Function 
		{
			return FOnTextData;
		}
		
		public function set OnTextData(value:Function):void 
		{
			FOnTextData = value;
		}
		
		public function get OnXMPData():Function 
		{
			return FOnXMPData;
		}
		
		public function set OnXMPData(value:Function):void 
		{
			FOnXMPData = value;
		}
		
	}

}