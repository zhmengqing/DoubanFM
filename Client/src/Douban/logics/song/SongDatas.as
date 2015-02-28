package Douban.logics.song 
{
	import Douban.consts.*;
	import Douban.logics.song.VO.SongVO;
	/**
	 * ...
	 * @author zhmq
	 */
	public class SongDatas 
	{
		protected var FRType:int;//不知道是什么
		protected var FIsShowQuickStart:Boolean;//不知道是什么
		protected var FCurSongIndex:int;
		protected var FCurChannel:String;
		
		//音乐列表
		protected var FSongVec:Vector.<SongVO>;
		
		public function SongDatas() 
		{
			FSongVec = new Vector.<SongVO>;
			FCurChannel = CONST_SONGINFO.PERSONAL_CHANNEL;
		}
		
		public function GetSongByIndex(Index:int):SongVO
		{
			if (FSongVec.length <= Index)
			{
				return null;
			}
			return FSongVec[Index];
		}
		
		public function GetCurSong():SongVO
		{
			return GetSongByIndex(FCurSongIndex);
		}
		
		public function Add(Song:SongVO):void
		{
			var Index:int;
			Index = FSongVec.indexOf(Song);
			if (Index == -1)
			{
				FSongVec.push(Song);
			}
		}
		
		public function Remove(Song:SongVO):void
		{
			var Index:int;
			Index = FSongVec.indexOf(Song);
			if (Index != -1)
			{
				FSongVec.splice(Index,1);;
			}
		}
		
		public function SetData(Obj:Object):void
		{
			var Arr:Array;
			var Index:int;
			var Song:SongVO;
			var SongObj:Object;
			
			FCurSongIndex = 0;
			Arr = Obj as Array;
			FSongVec.length = 0;
			for (Index = 0; Index < Arr.length; Index++)
			{
				SongObj = Arr[Index];
				Song = new SongVO();
				Song.Album = SongObj.album;
				Song.PictureUrl = SongObj.picture;
				Song.Ssid = SongObj.ssid;
				Song.Artist = SongObj.artist;
				Song.SongUrl = SongObj.url;
				Song.Company = SongObj.company;
				Song.Title = SongObj.title;
				Song.RatingAvg = SongObj.rating_avg;
				Song.Length = SongObj.length;
				Song.Subtype = SongObj.subtype;
				Song.PublicTime = SongObj.public_time;
				Song.SonglistsCount = SongObj.songlists_count;
				Song.Sid = SongObj.sid;
				Song.Aid = SongObj.aid;
				Song.Sha = SongObj.sha256;
				Song.Kbps = SongObj.kbps;
				Song.Albumtitle = SongObj.albumtitle;
				Song.Like = SongObj.like;
				Song.AdType = SongObj.adtype;
				Add(Song);
			}
		}
		
		public function Reset():void
		{
			FSongVec.length = 0;
			FIsShowQuickStart = false;
			FRType = 0;
		}
		
		public function get RType():int 
		{
			return FRType;
		}
		
		public function set RType(value:int):void 
		{
			FRType = value;
		}
		
		public function get IsShowQuickStart():Boolean 
		{
			return FIsShowQuickStart;
		}
		
		public function set IsShowQuickStart(value:Boolean):void 
		{
			FIsShowQuickStart = value;
		}
		
		public function get Count():int 
		{
			return FSongVec.length;
		}
		
		public function get CurSongIndex():int 
		{
			return FCurSongIndex;
		}
		
		public function set CurSongIndex(value:int):void 
		{
			FCurSongIndex = value;
		}
		
		public function get CurChannel():String 
		{
			return FCurChannel;
		}
		
		public function set CurChannel(value:String):void 
		{
			FCurChannel = value;
		}
		
	}

}