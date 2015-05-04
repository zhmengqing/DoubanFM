package Douban.module.hall 
{
	import Douban.component.*;
	import Douban.consts.*;
	import Douban.logics.common.DoubanDatas;
	import Douban.logics.login.VO.LoginVO;
	import Douban.logics.song.*;
	import Douban.logics.song.VO.SongVO;
	import Douban.manager.*;
	import Douban.manager.singelar.*;
	import Douban.manager.statics.*;
	import Douban.module.hall.hiddenLists.channelList.ChannelList;
	import Douban.module.hall.component.SongHeart;
	import Douban.module.hall.component.SongLouder;
	import Douban.module.hall.hiddenLists.ProcessorHallHidden;
	import Douban.module.hall.musicPlayer.*;
	import Douban.utils.TUtilityString;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.media.SoundTransform;
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
		
		/**进度条个数*/
		protected static const BAR_NUM:int = 2;
		
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
		protected var FTFLogin:TextField;
		protected var FTFSongCount:TextField;
		protected var FSongHeart:UIToggleButton;
		protected var FBtnBin:UIButtton;
		protected var FBtnPause:UIButtton;
		protected var FBtnMask:UIButtton;
		protected var FBtnSave:UIButtton;
		protected var FSongLouder:SongLouder;
		
		protected var FIsInit:Boolean;
		protected var FUnstreamizerSong:UnstreamizerSong;
		protected var FSongData:SongDatas;
		protected var FCurSong:SongVO;
		protected var FSongManager:SongConnection;
		protected var FDuration:Number;//音乐总时间：秒
		
		protected var FDoubanDatas:DoubanDatas;
		
		protected var FSongPlayer:SongPlayer;
		protected var FBarCurTime:Number;//当前音乐走到的时间：秒
		
		protected var FNeedSkip:Boolean;//直接跳下一首
		protected var FLastSid:String;//上一首的sid
		
		protected var FSwitchView:Function;
		protected var FImage:Bitmap;
		protected var FLoginData:LoginVO;
		
		protected var FVolumeTrainsform:SoundTransform;
		
		//频道列表、音乐列表
		protected var FHallHidden:ProcessorHallHidden;
		
		public function ProcessorHallView(
			Parent:UIComponent) 
		{
			super(Parent);
			Visible = false;
			FNeedSkip = true;
			FBarCurTime = 0;
		}
		
		public function InitView():void
		{
			if (FIsInit)
			{
				NextSong();
				return;
			}
			FIsInit = true;
			FMainUI = DomainManager.CreateDisplayByName(
				CONST_RESOURCE.RESOURCE_VIEW_Hall) as Sprite;
				
			this.addChild(FMainUI);
			
			FMountPoint = FMainUI["MC_MountPoint"];
			FImage = new Bitmap();
			
			FMountPoint.addChild(FImage);
			
			FBtnNext = new UIButtton();
			FBtnNext.Substrate = FMainUI["Btn_Next"];
			FBtnNext.OnClick = OnNextSong;
			
			FBarSong = new UIBar(BAR_NUM);
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
			
			FTFLogin = FMainUI["TF_Login"];
			FTFLogin.htmlText = CONST_STRING.String_Hall_01;
			FTFLogin.addEventListener(TextEvent.LINK, OnLoginLink);
			
			FTFSongCount = FMainUI["TF_SongCount"];
			FTFSongCount.text = "";
			
			FBtnShare = new UIButtton();
			FBtnShare.Substrate = FMainUI["Btn_Share"];
			FBtnShare.OnClick = OnShare;
			
			FBtnBin = new UIButtton();
			FBtnBin.Substrate = FMainUI["Btn_Bin"];
			FBtnBin.OnClick = OnDustbin;
			
			FBtnPause = new UIButtton();
			FBtnPause.Substrate = FMainUI["Btn_Pause"];
			FBtnPause.OnClick = OnPause;
			
			FSongHeart = new UIToggleButton();
			FSongHeart.Substrate = FMainUI["SP_Heart"];
			FSongHeart.OnClick = OnHeartClick;
			
			FBtnMask = new UIButtton();
			FBtnMask.Substrate = FMainUI["MC_Mask"];
			FBtnMask.OnClick = OnResume;
			FBtnMask.Visible = false;
			
			FBtnSave = new UIButtton();
			FBtnSave.Substrate = FMainUI["Btn_Save"];
			FBtnSave.OnClick = OnSave;
			
			FSongLouder = new SongLouder(FMainUI["MC_Loud"]);
			FSongLouder.OnLouderOver = OnLouderOver;
			FSongLouder.OnLouderOut = OnLouderOut;
			FSongLouder.OnVolumeChange = OnVolumeChange;
			
			FSongManager = new SongConnection();
			FSongManager.OnMetaData = OnMetaData;
			
			
			FUnstreamizerSong = new UnstreamizerSong();
			
			FDoubanDatas = new DoubanDatas();
			
			FSongPlayer = new SongPlayer();	
			FLoginData = new LoginVO();
			
			FVolumeTrainsform = new SoundTransform();
			FVolumeTrainsform.volume = 
				ShareObjectManager.GetData(CONST_SHAREDOBJECT.VOLUME);
			NextSong();
			
			FHallHidden = new ProcessorHallHidden(
				this,
				FMainUI["MC_List"]);
			FHallHidden.SongManager = FSongManager;
		}
		
		
		//音量
		private function OnVolumeChange(Scale:Number):void 
		{
			FVolumeTrainsform.volume = Scale;
			FSongManager.Stream.soundTransform = FVolumeTrainsform;
			ShareObjectManager.SetData(
				CONST_SHAREDOBJECT.VOLUME,
				Scale);
			ShareObjectManager.Save();
		}
		
		private function OnLouderOver():void 
		{
			FTFLeftTime.visible = false;
		}
		
		private function OnLouderOut():void 
		{
			FTFLeftTime.visible = true;
		}
		
		public function LoginInfo(
			LoginObj:Object):void
		{
			FUnstreamizerSong.UnstreamizerLoginInfo(
				FLoginData,
				LoginObj.user_info);
			FTFLogin.text = FLoginData.Name;
			FTFSongCount.text = TUtilityString.Format(
				CONST_STRING.String_Hall_02,
				FLoginData.Played);
		}
		
		private function OnLoginLink(
			e:TextEvent):void 
		{
			FSwitchView(this);
		}
		
		private function OnSave(
			Sender:Object,
			E:MouseEvent):void
		{
			var Obj:Object;
			
			Obj = ShareObjectManager.GetData(
				CONST_SHAREDOBJECT.Save_Lists);
				
			if (Obj == null)
			{
				Obj = new Object();
				Obj[CONST_SHAREDOBJECT.Music_List] = [];
			}
			Obj[CONST_SHAREDOBJECT.Music_List].push(FCurSong.Obj);
			FDoubanDatas.Musics.Format(Obj);
			//FDoubanDatas.Musics.Add(FCurSong);
			ShareObjectManager.SetData(
				CONST_SHAREDOBJECT.Save_Lists,
				Obj);
			ShareObjectManager.Save();
			FHallHidden.UpdateData(
				FDoubanDatas,
				CONST_LISTS.LIST_Music);
		}
		
		private function OnResume(
			Sender:Object,
			E:MouseEvent):void 
		{
			FSongManager.Resume();
			FBtnPause.Visible = true;
			FBtnMask.Visible = false;
		}
		
		private function OnPause(
			Sender:Object,
			E:MouseEvent):void 
		{
			FSongManager.Pause();
			FBtnPause.Visible = false;
			FBtnMask.Visible = true;
		}
		
		private function OnHeartClick(
			Sender:Object,
			E:MouseEvent):void 
		{
			if (!FSongHeart.IsSelected)
			{
				FSongPlayer.SongType = CONST_SONGINFO.TYPE_UNLIKE;
			}
			else
			{
				FSongPlayer.SongType = CONST_SONGINFO.TYPE_LIKE;
			}
			FNeedSkip = false;
			NextSong();
		}		
		
		private function OnDustbin(
			Sender:Object,
			E:MouseEvent):void 
		{
			FSongPlayer.SongType = CONST_SONGINFO.TYPE_BAN;
			FNeedSkip = true;
			NextSong();
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
			FNeedSkip = true;
			NextSong();
		}
		
		//自然播放
		private function OnSongComplete():void
		{
			FSongPlayer.SongType = CONST_SONGINFO.TYPE_PLAYED;
			if (!FNeedSkip)//喜欢与否的情况，列表被更改
			{
				FSongData.CurSongIndex = 0;				
				FNeedSkip = true;
			}
			NextSong();
		}
		
		//列表播完
		protected function SongPlayOut():void
		{
			FSongPlayer.SongType = CONST_SONGINFO.TYPE_PLAYOUT;
			FSongPlayer.PlayNext(
				"",
				FLastSid);
			FSongHeart.IsSelected = false;
			//FSongHeart.ShowHeart(SongHeart.Type_Black);
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
			FSongPlayer.PlayNext(FBarCurTime.toFixed(1));		
			if (FNeedSkip)
			{
				FSongHeart.IsSelected = false;
				//FSongHeart.ShowHeart(SongHeart.Type_Black);
			}
		}
		
		//播放音乐
		public function LoadSong():void
		{
			var CurIndex:int;
			
			FCurSong = FSongPlayer.SongList.GetCurSong();
			if (FCurSong == null)
			{
				SongPlayOut();
				return;
			}
			//过滤广告
			if (FCurSong.AdType > 0)
			{
				CurIndex = FSongPlayer.SongList.CurSongIndex;
				if (CurIndex >= FSongPlayer.SongList.Count)
				{
					//处理广告在音乐列表最后一个的情况
					SongPlayOut();
					return;
				}
				FCurSong = FSongPlayer.SongList.GetSongByIndex(CurIndex);
			}
			
			FLastSid = CurSong.Sid;
			
			FSongManager.Load(
				FCurSong.SongUrl,
				OnSongComplete);
				
			FTFArtist.text = FCurSong.Artist;
			FTFAlbumtitle.text = "<" + FCurSong.Albumtitle + "> " + FCurSong.PublicTime;
			FTFTitle.text = FCurSong.Title;
			FSongHeart.IsSelected = FCurSong.Like == 1;
			//FSongHeart.ShowHeart(FCurSong.Like);
		}
		
		override public function Update():void 
		{
			var Stream:NetStream;
			var BarScare:Number;
			
			super.Update();
			
			if (FHallHidden != null)
			{
				FHallHidden.Update();			
			}
			
			if (FSongLouder != null)
			{
				FSongLouder.Update();
			}
			
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
				FImage.bitmapData = (Image.content as Bitmap).bitmapData;
				FImage.smoothing = true;
				FImage.width = Pic_Width;
				FImage.height = ImageH / ImageW * Pic_Width;
			}
		}
		
		public function get CurSong():SongVO
		{
			return FCurSong;
		}
		
		public function get NeedSkip():Boolean
		{
			return FNeedSkip;
		}
		
		public function get OnSwitchView():Function 
		{
			return FSwitchView;
		}
		
		public function set OnSwitchView(value:Function):void 
		{
			FSwitchView = value;
		}
		
	}

}