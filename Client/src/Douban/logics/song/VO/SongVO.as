package Douban.logics.song.VO 
{
	/**
	 * ...
	 * @author zhmq
	 */
	public class SongVO 
	{
		public var Album:String;
		public var PictureUrl:String;
		public var Ssid:String;
		public var Artist:String;
		public var SongUrl:String;
		public var Company:String;
		public var Title:String;		
		public var RatingAvg:Number;
		public var Length:int;
		public var Subtype:String;
		public var PublicTime:int;
		public var SonglistsCount:int;
		public var Sid:String;
		public var Aid:int;
		public var Sha:String;
		public var Kbps:int;
		public var Albumtitle:String;
		public var Like:int;
		public var AdType:int;
		
		public var Obj:Object;
		
		public function SongVO() 
		{
			
		}
		
		public function Format(SongObj:Object):void
		{
			Album = SongObj.album;
			PictureUrl = SongObj.picture;
			Ssid = SongObj.ssid;
			Artist = SongObj.artist;
			SongUrl = SongObj.url;
			Company = SongObj.company;
			Title = SongObj.title;
			RatingAvg = SongObj.rating_avg;
			Length = SongObj.length;
			Subtype = SongObj.subtype;
			PublicTime = SongObj.public_time;
			SonglistsCount = SongObj.songlists_count;
			Sid = SongObj.sid;
			Aid = SongObj.aid;
			Sha = SongObj.sha256;
			Kbps = SongObj.kbps;
			Albumtitle = SongObj.albumtitle;
			Like = SongObj.like;
			AdType = SongObj.adtype;
			Obj = SongObj;
		}
		
	}

}