package Douban.module.hall 
{
	import Douban.component.*;
	import Douban.consts.*;
	import Douban.logics.song.*;
	import Douban.logics.song.VO.SongVO;
	import Douban.manager.*;
	import Douban.manager.singelar.*;
	import Douban.manager.statics.*;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.*;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author zhmq
	 */
	public class ProcessorHallView extends UIComponent 
	{
		//音乐进度条
		protected static const Bar_Song:int = 1;
		//加载进度条
		protected static const Bar_Load:int = 0;
		
		protected static const Pic_Width:int = 250;
		protected static const Pic_Height:int = 250;
		
		protected var FMainUI:Sprite;
		protected var FMountPoint:Sprite;
		protected var FBtnNext:UIButtton;
		protected var FBtnShare:UIButtton;
		protected var FBarSong:UIBar;
		protected var FTFCurTime:TextField;
		protected var FTFLeftTime:TextField;
		protected var FTFArtist:TextField;
		protected var FTFAlbumtitle:TextField;
		protected var FTFTitle:TextField;
		
		protected var FIsInit:Boolean;
		protected var FUnstreamizerSong:UnstreamizerSong;
		protected var FSongData:SongDatas;
		protected var FCurSong:SongVO;
		protected var FSongManager:SongConnection;
		protected var FDuration:Number;
		
		public function ProcessorHallView(
			Parent:UIComponent) 
		{
			super(Parent);
			Visible = false;
		}
		
		public function InitView():void
		{
			if (FIsInit)
			{
				return;
			}
			FIsInit = true;
			FMainUI = DomainManager.CreateDisplayByName(
				CONST_RESOURCE.RESOURCE_VIEW_Hall) as Sprite;
				
			this.addChild(FMainUI);
			
			FMountPoint = FMainUI["MC_MountPoint"];
			
			FBtnNext = new UIButtton();
			FBtnNext.Substrate = FMainUI["Btn_Next"];
			FBtnNext.OnClick = OnNextSong;
			
			FBarSong = new UIBar(CONST_HALL.BAR_NUM);
			FBarSong.OnOver = OnSongBarOver;
			FBarSong.OnOut = OnSongBarOut;
			FBarSong.OnClick = OnSongBarClick;
			FBarSong.Substrate = FMainUI["MC_SongBar"];
			
			FTFCurTime = FMainUI["TF_CurTime"];
			FTFCurTime.text = "";
			FTFCurTime.visible = false;
			FTFCurTime.mouseEnabled = false;
			FTFLeftTime = FMainUI["TF_TotalTime"];
			FTFLeftTime.text = "";
			
			FTFArtist = FMainUI["TF_Artist"];
			FTFArtist.text = "";
			FTFAlbumtitle = FMainUI["TF_Albumtitle"];
			FTFAlbumtitle.text = "";
			FTFTitle = FMainUI["TF_Title"];
			FTFTitle.text = "";
			
			FBtnShare = new UIButtton();
			FBtnShare.Substrate = FMainUI["Btn_Share"];
			FBtnShare.OnClick = OnShare;
			
			FSongManager = new SongConnection();
			FSongManager.OnMetaData = OnMetaData;
			
			FUnstreamizerSong = new UnstreamizerSong();
			FSongData = new SongDatas();
		}
		
		private function OnShare(
			Sender:Object,
			E:MouseEvent):void 
		{
			var Vars:URLVariables;
			var Record:Object;
			var Arr:Array;
			var CurDate:Date;
			
			Vars = new URLVariables();
			Record = new Object();			
			CurDate = new Date();
			Record.fm_song_id = FCurSong.Sid;
			Record.datetime = CurDate.getTime();
			Record.source = "fm";
			Record.terminal = "sina";
			Record.platform = "web";
			Record.channel_id = "0";
			
			Arr = [Record];
			
			Vars.ck = null;
			Vars.records = "[{fm_song_id:\"1395046\",datetime:1424942737371,source:\"fm\",terminal:\"sina\",platform:\"web\",channel_id:0}]";
			/*"[{" +
				"\"fm_song_id\":" + "\"" + FCurSong.Sid + "\"" + "," +
				"\"datetime\":" + CurDate.getTime() + "," +
				"\"source\":\"fm\"" + "," +
				"\"terminal\":\"sina\"" + "," +
				"\"platform\":\"web\"" + "," +
				"\"channel_id\":" + "\"" + 0 + "\"" +
				"}]";*/
			
			SServerManager.Load(
				CONST_SERVERID.SERVERID_SHARE,
				Vars);
		}
		
		private function OnSongBarClick(
			Sender:Object,
			E:MouseEvent):void 
		{
			var Bar:UIBar;
			
			Bar = Sender as UIBar;
			
			FSongManager.Seek(FDuration * Bar.BarScale);
		}
		
		private function OnSongBarOut(
			Sender:Object,
			E:MouseEvent):void 
		{
			FTFCurTime.visible = false;
		}
		
		private function OnSongBarOver(
			Sender:Object,
			E:MouseEvent):void 
		{
			var Bar:UIBar;
			
			Bar = Sender as UIBar;
			FTFCurTime.visible = true;
			FTFCurTime.text = CommonManager.GetTimeStrBySeconds(
				FDuration * Bar.BarScale);
			FTFCurTime.x = mouseX - FTFCurTime.width / 2;
		}
		
		private function OnMetaData(Info:Object):void 
		{
			FDuration = Info.duration;			
		}
		
		private function OnNextSong(
			Sender:Object,
			E:MouseEvent):void 
		{
			NextSong();
		}
		
		public function SetData(
			SongObj:Object):void
		{
			FUnstreamizerSong.UnstreamizerPerform(
				FSongData,
				SongObj);
		}
		
		public function NextSong(
			Sid:String = ""):void
		{
			var Url:String = "http://douban.fm/j/mine/playlist?type=n&sid=289954&pt=2.3&channel=-3&pb=64&from=mainsite&r=a0bdc8eb6a";
			var Vars:URLVariables = new URLVariables();
			//return;
			Vars.type = "n";
			Vars.sid = "289954";
			Vars.pt = "2.3";
			Vars.channel = "-3";
			Vars.pb = "64";
			Vars.from = "mainsite";
			Vars.r = "a0bdc8eb6a";
			SServerManager.Load(
				CONST_SERVERID.SERVERID_SONG,
				Vars);
		}
		
		public function LoadSong():void
		{
			var Radom:int;
			
			Radom = FSongData.Count * Math.random();
			FCurSong = FSongData.GetSongByIndex(Radom);
			FSongManager.Load(
				FCurSong.SongUrl,
				NextSong);
				
			FTFArtist.text = FCurSong.Artist;
			FTFAlbumtitle.text = "<" + FCurSong.Albumtitle + "> " + FCurSong.PublicTime;
			FTFTitle.text = FCurSong.Title;
		}
		
		override public function Update():void 
		{
			var Stream:NetStream;
			var BarScare:Number;
			
			super.Update();
			
			if (FSongManager == null) return;
			
			Stream = FSongManager.Stream;
			
			if (Stream == null) return;
			
			if (Stream.bytesLoaded != Stream.bytesTotal)
			{
				FBarSong.SetBar(
					Stream.bytesLoaded/Stream.bytesTotal)
			}
			if (Stream.time != FDuration)
			{
				BarScare = Stream.time / FDuration;
				FBarSong.SetBar(
					BarScare,
					Bar_Song);
				FTFLeftTime.text = "-" + CommonManager.GetTimeStrBySeconds(
					FDuration * (1 - BarScare));
			}
			
		}
		
		public function AddPicture(Image:Loader):void
		{
			var ImageH:int;
			var ImageW:int;
			if(Visible)
			{
				ImageH = Image.height;
				ImageW = Image.width;
				Image.width = Pic_Width;
				Image.height = ImageH / ImageW * Pic_Width;
				FMountPoint.addChild(Image);
			}
		}
		
		public function get CurSong():SongVO
		{
			return FCurSong;
		}
		
	}

}