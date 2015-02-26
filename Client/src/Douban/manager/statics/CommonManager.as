package Douban.manager.statics 
{
	/**
	 * ...
	 * @author zhmq
	 */
	public class CommonManager 
	{
		
		public function CommonManager() 
		{
			
		}
		
		/**秒数变成 02:56 格式*/
		public static function GetTimeStrBySeconds(
			Seconds:int):String
		{
			var Min:int;
			var Sec:int;
			
			Min = Seconds / 60;
			Sec = Seconds - Min * 60;
			
			return GetDoubleNumStr(Min) + ":" + GetDoubleNumStr(Sec);
		}
		
		/**单位加个零变成双位*/
		public static function GetDoubleNumStr(
			Num:int):String
		{
			if (Num < 10)
			{
				return "0" + Num;
			}
			
			return "" + Num;
		}
		
	}

}