package Douban.manager 
{
	import Douban.consts.*;
	import Douban.logics.song.SongDatas;
	import Douban.logics.song.VO.SongVO;
	import Douban.manager.singelar.SServerManager;
	import Douban.utils.TMD5;
	/**
	 * ...
	 * @author zhmq
	 */
	public class SongPlayer 
	{
		protected var FCurSongIndex:int;
		protected var FCurSongVO:SongVO;
		protected var FSongList:SongDatas;
		
		protected var FSongType:String;
		protected var FSid:String;
		protected var FPt:String;
		protected var FChannel:int;
		protected var FPb:int;
		protected var FFrom:String;
		protected var FKbps:int;
		protected var FMd5:String;
		
		public function SongPlayer() 
		{
			FSongList = new SongDatas();
			ResetData();
		}
		
		public function PlayNext():void
		{
			var ReqUrl:String;
			var Md5Req:String;
			
			ReqUrl = CONST_URL.MUSIC_URL + "?";
			ReqUrl += "type=" + FSongType;
			ReqUrl += "&sid=" + FSid;
			ReqUrl += "&pt=" + FPt;
			ReqUrl += "&channel=" + FChannel;
			//中间还有tags，artist_id，context，暂时不研究
			if (FPb != 0)
			{
				ReqUrl += "&pb=" + FPb;
			}
			//这中间有个start，还不知道是什么
			ReqUrl += "&from=" + FFrom;
			if (FKbps != 0)
			{
				ReqUrl += "&kbps=" + FKbps;
			}
			
			Md5Req = TMD5.Hash(ReqUrl + CONST_SONGINFO.MD5_KEY).substr(-10)
			ReqUrl += "&r=" + Md5Req;
			
			SServerManager.Load(
				CONST_SERVERID.SERVERID_SONG,
				ReqUrl);
		}
		
		public function ResetData():void
		{
			FSongType = CONST_SONGINFO.TYPE_NEW;
			FCurSongIndex = 0;
			FSid = "";
			FPt = "0.0";
			FFrom = CONST_SONGINFO.FROM_MAINSITE;
			FChannel = 0;
		}
		
		public function get SongType():String 
		{
			return FSongType;
		}
		
		public function set SongType(value:String):void 
		{
			FSongType = value;
		}
		
		public function get SongList():SongDatas 
		{
			return FSongList;
		}
		
	}

}