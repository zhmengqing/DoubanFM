package Douban.component.list 
{
	import Douban.component.UIComponent;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author zhmq
	 */
	public class UIListV extends UIBaseList 
	{
		//---- Constants -------------------------------------------------------
		
		//---- Protected Fields ------------------------------------------------
		
		//---- Property Fields -------------------------------------------------
		
		//---- Constructor -----------------------------------------------------
		
		public function UIListV(
			Parent:UIComponent,
			MainUI:Sprite) 
		{
			super(Parent);
			
		}
		//---- Protected Methods -----------------------------------------------
		
		protected function AddItem(...args):void
		{
			var Index:int;
			var YOffset:int;
			var Item:UIListRenderer;
			
			YOffset = FDataCollection.YOffset - FDataCollection.Gap;
			
			for (Index = 0; Index < args.length; Index++)
			{
				Item = new UIListRenderer(this);	
				FMountPoint.addChild(Item);
				Item.x = FDataCollection.XOffset;
				Item.y = YOffset + FDataCollection.Gap + Item.height;
				
				FItemVec.push(Item);
			}
		}
		//---- Event Handling Methods ------------------------------------------
		
		//---- Property Accessing Methods --------------------------------------
		
		//---- Public Methods ----------------------------------------------------		
		
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
		
		
	}

}