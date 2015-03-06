package Douban.component.list 
{
	import Douban.component.UIComponent;
	/**
	 * ...
	 * @author zhmq
	 */
	public class UIListV extends UIBaseList 
	{
		protected var FDataCollection:UIListDataCollection;
		protected var FItemVec:Vector.<UIListRenderer>;
		public function UIListV(Parent:UIComponent) 
		{
			super(Parent);
			FItemVec = new Vector.<UIListRenderer>;
		}
		
		protected function RemoveItem(
			ItemIndex:int,
			RemoveCount:int = 1):void
		{			
			var Index:int;			
			
			for (Index = ItemIndex; Index < RemoveCount; Index++)
			{	
				this.removeChild(
					FItemVec[ItemIndex]);
				FItemVec.splice(
					ItemIndex, 
					1);				
			}			
		}
		
		protected function AddItem():void
		{
			var Index:int;
			var YOffset:int;
			var Item:UIListRenderer;
			
			YOffset = FDataCollection.YOffset - FDataCollection.Gap;
			
			for (Index = 0; Index < args.length; Index++)
			{
				Item = new UIListRenderer();	
				Item.x = FDataCollection.XOffset;
				Item.y = YOffset + FDataCollection.Gap + Item.height;
				
				FItemVec.push(Item);
			}
		}
		
		public function Render():void
		{
			var Index:int;
			var Count:int;
			var DataIsLonger:Boolean;
			
			DataIsLonger = FDataCollection.Count > FItemVec.length;
			Count = FItemVec.length;
			for (Index = 0; Index < Count; Index++)
			{				
				if (Index < FDataCollection.Count)
				{
					FItemVec[Index].UpdateData(
						FDataCollection.GetDataByIndex(Index));
				}
				else
				{
					RemoveItem(Index);
				}
			}
			Count = FDataCollection.Count;
			for (Index; Index < Count; Index++)
			{
				AddItem();
			}
		}
		
		public function get DataCollection():UIListDataCollection 
		{
			return FDataCollection;
		}
		
		public function set DataCollection(value:UIListDataCollection):void 
		{
			FDataCollection = value;
		}
		
	}

}