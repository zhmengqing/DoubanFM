package Douban.module.hall.hiddenLists 
{
	import Douban.component.UIComponent;
	import Douban.consts.CONST_SHAREDOBJECT;
	import Douban.logics.common.DoubanDatas;
	import Douban.logics.hiddenLists.IListData;
	import Douban.logics.hiddenLists.UnstreamizerHiddenLists;
	import Douban.logics.song.VO.SongVO;
	import Douban.manager.statics.ShareObjectManager;
	import Douban.module.hall.hiddenLists.channelList.ChannelRenderer;
	import Douban.module.hall.hiddenLists.musicList.MusicRenderer;
	import Douban.module.hall.musicPlayer.SongConnection;
	import flash.display.Sprite;
	
	/**
	 * 左边的所有隐藏列表，数据处理也放这里
	 * @author zhmq
	 */
	public class ProcessorHallHidden extends UIComponent 
	{
		//---- Constants -------------------------------------------------------
		
		protected static const List_Num:int = 2;
		
		//---- Protected Fields ------------------------------------------------
		
		protected var FDoubanDatas:DoubanDatas;
		protected var FMainUI:Sprite;
		protected var FHiddenLists:Vector.<HiddenList>;
		protected var FHiddenDatas:Vector.<IListData>;
		protected var FUnstreamizer:UnstreamizerHiddenLists;
		protected var FListRenderers:Vector.<Class>;
		
		protected var FSongManager:SongConnection;
		
		protected var FCurMusicIndex:int;
		
		//---- Property Fields -------------------------------------------------
		
		//---- Constructor -----------------------------------------------------
		
		public function ProcessorHallHidden(
			Parent:UIComponent,
			MainUI:Sprite) 
		{
			var Index:int;
			var Hidden:HiddenList;
			
			super(Parent);
			FMainUI = MainUI;
			FHiddenLists = new Vector.<HiddenList>;
			FHiddenDatas = new Vector.<IListData>;
			
			FListRenderers = Vector.<Class>([
				ChannelRenderer,
				MusicRenderer]);
			
			for (Index = 0; Index < List_Num; Index++)
			{
				Hidden = new HiddenList(
					this,
					FMainUI["MC_List_" + Index]);
				Hidden.Renderer = FListRenderers[Index];
				Hidden.OnSelect = OnListSelect;
				Hidden.OnShow = OnListShow;
				FHiddenLists.push(Hidden);
			}
			FUnstreamizer = new UnstreamizerHiddenLists();
		}
		
		//---- Protected Methods -----------------------------------------------
		
		//---- Event Handling Methods ------------------------------------------
		
		protected function OnListSelect(
			Data:Object):void
		{
			var Song:SongVO;
			
			Song = Data.song as SongVO;
			FCurMusicIndex = Data.index;
			FSongManager.Load(
				Song.SongUrl,
				OnMusicSelectNext);
				
			FSongManager.RefreshSong(
				Song);
		}
		
		protected function OnMusicSelectNext():void
		{
			var Song:SongVO;
			FCurMusicIndex ++;
			Song = FDoubanDatas.Musics.GetDataByIndex(FCurMusicIndex) as SongVO;
			if (Song == null)
			{
				FCurMusicIndex = -1;
				OnMusicSelectNext();
				return;
			}
			FSongManager.Load(
				Song.SongUrl,
				OnMusicSelectNext);
			
			FSongManager.RefreshSong(
				Song);
		}
		
		protected function OnListShow():void
		{
			var Obj:Object;
			if (FDoubanDatas == null)
			{
				FDoubanDatas = new DoubanDatas();
				Obj = ShareObjectManager.GetData(
					CONST_SHAREDOBJECT.Save_Lists);
					
				FDoubanDatas.Musics.Format(Obj);
				SetData(FDoubanDatas);
			}
		}
		
		//---- Property Accessing Methods --------------------------------------
		
		//---- Public Methods ----------------------------------------------------
		
		public function SetData(
			DoubanData:DoubanDatas):void
		{
			var Index:int;
			FDoubanDatas = DoubanData;
			if (FDoubanDatas == null) return;
			for (Index = 0; Index < List_Num; Index++)
			{
				FHiddenLists[Index].SetData(
					FDoubanDatas.Lists[Index]);
			}
		}
		
		public function UpdateData(
			DoubanData:DoubanDatas,
			Index:int):void
		{
			FDoubanDatas = DoubanData;
			FHiddenLists[Index].SetData(
				FDoubanDatas.Lists[Index]);
		}
		
		override public function Update():void 
		{
			var Index:int;
			super.Update();
			
			for (Index = 0; Index < List_Num; Index++)
			{
				FHiddenLists[Index].Update();
			}
		}
		
		public function get SongManager():SongConnection 
		{
			return FSongManager;
		}
		
		public function set SongManager(value:SongConnection):void 
		{
			FSongManager = value;
		}
	}

}