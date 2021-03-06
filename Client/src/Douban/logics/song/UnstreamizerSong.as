package Douban.logics.song 
{
	import Douban.consts.*;
	import Douban.logics.login.VO.LoginVO;
	import Douban.logics.song.VO.SongVO;
	import Douban.logics.Unstreamizer;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.System;
	
	/**
	 * ...
	 * @author zhmq
	 */
	public class UnstreamizerSong extends Unstreamizer 
	{
		public function UnstreamizerSong() 
		{
			super();
			
		}
		
		override public function UnstreamizerPerform(
			Destination:Object,
			Correlator:Object = null):void 
		{
			var SongData:SongDatas;
			
			SongData = Destination as SongDatas;
			SongData.RType = int(Correlator.r);
			if (Correlator.song == null) 
			{
				//音乐列表进入下一首
				SongData.CurSongIndex++;
				return;
			}			
			SongData.IsShowQuickStart = Correlator.is_show_quick_start == 1;
			SongData.SetData(Correlator.song);
		}
		
		//构造登录信息
		public function UnstreamizerLoginInfo(
			Destination:Object,
			Correlator:Object):void
		{
			var LoginData:LoginVO;
			
			LoginData = Destination as LoginVO;
			LoginData.Ck = Correlator.ck;
			LoginData.Collects = Correlator.play_record.fav_chls_count;
			LoginData.Liked = Correlator.play_record.liked;
			LoginData.Banned = Correlator.play_record.banned;
			LoginData.Played = Correlator.play_record.played;
			LoginData.Uid = Correlator.uid;
			LoginData.Id = Correlator.id;
			LoginData.Name = Correlator.name;
		}
		
		//构造分享链接
		public function UnstreamizerSongShare(
			Destination:Object):void
		{
			var SongData:SongDatas;
			var CurSong:SongVO;
			var ShareUrl:String;	
			var SongUrl:String;
			var Cid:int;
			var Vars:URLVariables;
			
			SongData = Destination as SongDatas;
			CurSong = SongData.GetCurSong();
			if (CurSong == null) return;
			
			Vars = new URLVariables();
			if (int(CurSong.Sid) > CONST_SONGINFO.SHARE_CID_OFFSET)
			{
				Cid = int(CurSong.Sid);
			}
			else
			{
				Cid = int(CurSong.Sid) + CONST_SONGINFO.SHARE_CID_OFFSET;
			}		
			
			SongUrl = CONST_URL.DOUBAN_URL;
			SongUrl += "?start=" + CurSong.Sid + "g" + CurSong.Ssid + "g" + SongData.CurChannel;
			SongUrl += "&cid=" + Cid;
			ShareUrl = CONST_URL.SHARE_URL;
			
			Vars.appkey = CONST_SONGINFO.APP_KEY;
			Vars.url = SongUrl;
			Vars.title = "分享 " + CurSong.Artist + " 的单曲《" + CurSong.Title + "》";
			Vars.ralatedUid = CONST_SONGINFO.ID_DOUBAN_SINA;
			Vars.source = "";
			Vars.sourceUrl = "";
			Vars.content = "utf-8";
			Vars.pic = CurSong.PictureUrl;
			
			System.setClipboard(SongUrl);
			trace("分享链接 " + ShareUrl + Vars);
			//navigateToURL(new URLRequest(ShareUrl + "?" + Vars), "_blank");
		}		
	}

}