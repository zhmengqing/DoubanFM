package Douban.logics.common 
{
	import Douban.consts.CONST_LISTS;
	import Douban.logics.hiddenLists.IListData;
	import Douban.logics.hiddenLists.MusicList;
	/**
	 * ...
	 * @author zhmq
	 */
	public class DoubanDatas 
	{
		//---- Constants -------------------------------------------------------
		
		//---- Protected Fields ------------------------------------------------
		
		protected var FLists:Vector.<IListData>;
		protected var FMusicList:MusicList;
		
		//---- Property Fields -------------------------------------------------
		
		//---- Constructor -----------------------------------------------------
		
		public function DoubanDatas() 
		{
			FLists = new Vector.<IListData>;
			FMusicList = new MusicList();
			FLists.push(null);
			FLists.push(FMusicList);
		}
		
		//---- Protected Methods -----------------------------------------------
		
		//---- Event Handling Methods ------------------------------------------
		
		//---- Property Accessing Methods --------------------------------------
		
		public function get Musics():MusicList
		{
			return FLists[CONST_LISTS.LIST_Music] as MusicList;
		}
		
		public function get Lists():Vector.<IListData>
		{
			return FLists;
		}
		
		//---- Public Methods ----------------------------------------------------
		
		
	}

}