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
		protected var FTFCurTime:TextField;//时间tip
		protected var FTFLeftTime:TextField;//剩余时间
		protected var FTFArtist:TextField;
		protected var FTFAlbumtitle:TextField;
		protected var FTFTitle:TextField;
		
		protected var FIsInit:Boolean;
		protected var FUnstreamizerSong:UnstreamizerSong;
		protected var FSongData:SongDatas;
		protected var FCurSong:SongVO;
		protected var FSongManager:SongConnection;
		protected var FDuration:Number;//音乐总时间：秒
		
		protected var FSongPlayer:SongPlayer;
		protected var FBarCurTime:Number;//当前音乐走到的时间：秒
		
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
			
			FSongPlayer = new SongPlayer();
		}
		
		private function OnShare(
			Sender:Object,
			E:MouseEvent):void 
		{
			FUnstreamizerSong.UnstreamizerSongShare(
				FSongPlayer.SongList);
			
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
		
		//下一首
		private function OnNextSong(
			Sender:Object,
			E:MouseEvent):void 
		{			
			FSongPlayer.SongType = CONST_SONGINFO.TYPE_SKIP;
			NextSong();
		}
		
		//自然播放
		private function OnSongComplete():void
		{
			FSongPlayer.SongType = CONST_SONGINFO.TYPE_PLAYED;
			NextSong();
		}
		
		public function SetData(
			SongObj:Object):void
		{
			FUnstreamizerSong.UnstreamizerPerform(
				FSongPlayer.SongList,
				SongObj);
				
			FSongData = FSongPlayer.SongList;
		}
		
		public function NextSong():void
		{
			FSongPlayer.Pt = FBarCurTime.toFixed(1);
			FSongPlayer.PlayNext();			
		}
		
		//播放音乐
		public function LoadSong():void
		{
			FCurSong = FSongPlayer.SongList.GetCurSong();
			FSongManager.Load(
				FCurSong.SongUrl,
				OnSongComplete);
				
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
				FBarCurTime = FDuration * BarScare;
				FTFLeftTime.text = "-" + CommonManager.GetTimeStrBySeconds(
					FDuration - FBarCurTime);
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