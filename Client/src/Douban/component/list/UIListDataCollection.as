package Douban.component.list 
{
	/**
	 * list的数据
	 * @author zhmq
	 */
	public class UIListDataCollection 
	{
		protected var FXOffset:int;
		protected var FYOffset:int;
		protected var FGap:int;
		
		protected var FDataList:Array;
		
		public function UIListDataCollection() 
		{
			FDataList = new Array();
		}
		
		public function GetDataByIndex(
			Index:int):void
		{
			return FDataList[Index];
		}
		
		/**把数据添加到某个位置，每个数据只能出现一次*/
		public function AddData(
			Data:*):void
		{
			var Index:int;
			
			Index = FDataList.indexOf(Data);
			
			if (Index == -1)
			{
				FDataList.push(Data);
			}			
		}
		
		public function RemoveData(
			Data:*):void
		{
			var Index:int;
			
			Index = FDataList.indexOf(Data);
			
			if (Index != -1)
			{
				FDataList.splice(Index, 1);
			}	
		}
		
		public function ExchangeData(
			Data:*,
			PrePos:int,
			CurPos:int):void
		{
			if (PrePos == CurPos || PrePos == CurPos - 1) return;
			if (PrePos > CurPos)
			{
				FDataList.splice(PrePos, 1);
				FDataList.splice(CurPos, 0, Data);
			}
			else
			{
				FDataList.splice(CurPos, 0, Data);
				FDataList.splice(PrePos, 1);
			}
		}
		
		public function get Count():int 
		{
			return FDataList.length;
		}
		
		public function get XOffset():int 
		{
			return FXOffset;
		}
		
		public function set XOffset(value:int):void 
		{
			FXOffset = value;
		}
		
		public function get YOffset():int 
		{
			return FYOffset;
		}
		
		public function set YOffset(value:int):void 
		{
			FYOffset = value;
		}
		
		public function get Gap():int 
		{
			return FGap;
		}
		
		public function set Gap(value:int):void 
		{
			FGap = value;
		}
		
	}

}