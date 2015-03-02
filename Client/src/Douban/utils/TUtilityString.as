package Douban.utils 
{
	/**
	 * ...
	 * @author zhmq
	 */
	public class TUtilityString 
	{
		protected static var FFormatExpression: RegExp =/\%(\d+)/g;
		protected static var FFormatParameters: *;
		
		public function TUtilityString() 
		{
			throw new Error("UtilityString Class Is Static Container Only");
		}
		
		protected static function FormatRoutine(): String
		{
			var Index: int;
			
			Index = parseInt(
				arguments[1]);
			
			return FFormatParameters[Index];
		}
		
		public static function Format(
			Format: String,
			... Parameters): String
		{
			var Result: String;
			
			FFormatParameters = Parameters;
			
			Result = Format.replace(
				FFormatExpression,
				FormatRoutine);
			
			FFormatParameters = null;
			
			return Result;
		}
		
	}

}