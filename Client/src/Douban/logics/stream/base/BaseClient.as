package Douban.logics.stream.base 
{
	/**
	 * ...
	 * @author zhmq
	 */
	public class BaseClient 
	{
		
		public function BaseClient() 
		{
			
		}
		
		//当播放 FLV 文件时，在到达嵌入的提示点时调用
		public function onCuePoint(info:Object):void 
		{
			trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
		}
		
		//以字节数组形式接收到正在播放的媒体文件中嵌入的图像数据时建立侦听器进行响应
		public function onImageData(info:Object):void
		{
			trace("imageData length: " + info.data.length);
		}
		
		//接收到正在播放的视频中嵌入的描述性信息时建立侦听器进行响应
		public function onMetaData(info:Object):void 
		{
			trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
		}
		
		//在 NetStream 对象已完全播放流时建立侦听器进行响应
		public function onPlayStatus(info:Object):void
		{
			trace("status: " + info.code);
		}
		
		//遇到可搜索的点（例如，视频关键帧）时从 appendBytes() 同步调用
		public function onSeekPoint(info:Object):void
		{
			trace("seek");
		}
		
		//接收到正在播放的媒体文件中嵌入的文本数据时建立侦听器进行响应
		public function onTextData(info:Object):void
		{
			var key:String;
			for (key in info) 
			{
                trace(key + ": " + info[key]);
            }
		}
		
		//建立一个侦听器，以便在 Flash Player 接收到特定于正在播放的视频中嵌入的 Adobe 可扩展元数据平台 (XMP) 的信息时进行响应
		public function onXMPData(info:Object):void
		{
			
		}
	}

}