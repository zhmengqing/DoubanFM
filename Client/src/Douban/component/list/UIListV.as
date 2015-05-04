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
			super(
				Parent,
				MainUI);
			FDataCollection = new UIListDataCollection();
		}
		//---- Protected Methods -----------------------------------------------
		
		//---- Event Handling Methods ------------------------------------------
		
		//---- Property Accessing Methods --------------------------------------
		
		//---- Public Methods ----------------------------------------------------		
		
		public function AddItem(...args):void
		{
			var Index:int;
			var YOffset:int;
			var Item:UIListRenderer;
			
			YOffset = FDataCollection.YOffset - FDataCollection.Gap;
			
			for (Index = 0; Index < args.length; Index++)
			{
				Item = new FRenderer(this);	
				FMountPoint.addChild(Item);
				Item.x = FDataCollection.XOffset;
				Item.y = YOffset + FDataCollection.Gap + Item.height;
				Item.UpdateData(args[Index]);
				Item.OnSelect = OnRenderSelect;
				FItemVec.push(Item);
				FDataCollection.AddData(args[Index]);
				FDataCollection.YOffset = Item.y;
				FHeight = FDataCollection.YOffset + FDataCollection.Gap + Item.height;
			}
			
		}
		
		public function SetScroll(
			DisplayLength:int,
			TotalLength:int):void
		{
			FScroller.SetScroll(
				DisplayLength,
				TotalLength);
		}
		
		public function Clear():void
		{
			FMountPoint.removeChildren();
			FItemVec.length = 0;
			FDataCollection.Clear();
		}
		
		override public function Update():void 
		{
			super.Update();
			
			FScroller.Update();
		}
		
		/*public function Render():void
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
		}*/
		
		
	}

}