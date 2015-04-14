package Douban.logics.hiddenLists 
{
	import Douban.logics.song.VO.SongVO;
	
	/**
	 * ...
	 * @author zhmq
	 */
	public interface IListData 
	{
		function GetDataByIndex(Index:int):Object;
		function get Count():int;
	}
	
}