package Douban.logics.hiddenLists 
{
	import Douban.consts.CONST_SHAREDOBJECT;
	import Douban.logics.song.VO.SongVO;
	/**
	 * ...
	 * @author zhmq
	 */
	public class MusicList implements IListData
	{
		//---- Constants -------------------------------------------------------
		
		//---- Protected Fields ------------------------------------------------
		
		protected var FSongVec:Vector.<SongVO>;
		//---- Property Fields -------------------------------------------------
		
		//---- Constructor -----------------------------------------------------
		
		public function MusicList() 
		{
			FSongVec = new Vector.<SongVO>;
		}
		
		//---- Protected Methods -----------------------------------------------
		
		//---- Event Handling Methods ------------------------------------------
		
		//---- Property Accessing Methods --------------------------------------
		
		public function get Count():int
		{
			return FSongVec.length;
		}
		//---- Public Methods ----------------------------------------------------
		
		public function Format(Obj:Object):void
		{
			var Arr:Array;
			var Index:int;
			var Count:int;
			var Song:SongVO;
			
			Arr = Obj[CONST_SHAREDOBJECT.Music_List] as Array;
			FSongVec.length = 0;
			Count = Arr.length;
			for (Index = 0; Index < Count; Index++)
			{
				Song = new SongVO();
				Song.Format(Arr[Index]);
				FSongVec.push(Song);
			}
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
				FSongVec.splice(Index,1);
			}
		}
		
		public function GetDataByIndex(Index:int):Object
		{
			if (FSongVec.length <= Index)
			{
				return null;
			}
			return FSongVec[Index];
		}
		
		
	}

}