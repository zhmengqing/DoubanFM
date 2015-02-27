package Douban.logics.song 
{
	import Douban.logics.song.VO.SongVO;
	import Douban.logics.Unstreamizer;
	
	/**
	 * ...
	 * @author zhmq
	 */
	public class UnstreamizerSong extends Unstreamizer 
	{
		protected var FSongData:SongDatas;
		public function UnstreamizerSong() 
		{
			super();
			
		}
		
		override public function UnstreamizerPerform(
			Destination:Object,
			Correlator:Object = null):void 
		{
			FSongData = Destination as SongDatas;
			FSongData.RType = int(Correlator.r);
			if (Correlator.is_show_quick_start == undefined) 
			{
				trace("空列表");
				FSongData.CurSongIndex++;
				return;
			}			
			FSongData.IsShowQuickStart = Correlator.is_show_quick_start == 1;
			FSongData.SetData(Correlator.song);
		}
		
	}

}