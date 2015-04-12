package Douban.component.list 
{
	import Douban.component.scroll.UIScrollBar;
	import Douban.component.UIComponent;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author zhmq
	 */
	public class UIBaseList extends UIComponent 
	{
		//---- Constants -------------------------------------------------------
		
		//---- Protected Fields ------------------------------------------------
		
		protected var FDataCollection:UIListDataCollection;
		protected var FItemVec:Vector.<UIListRenderer>;
		protected var FScroller:UIScrollBar;
		protected var FMainUI:Sprite;
		protected var FMountPoint:Sprite;
		
		//---- Property Fields -------------------------------------------------
		
		//---- Constructor -----------------------------------------------------
		
		public function UIBaseList(
			Parent:UIComponent,
			MainUI:Sprite) 
		{
			super(Parent);
			FMainUI = MainUI;
			FItemVec = new Vector.<UIListRenderer>;
			FScroller = new UIScrollBar(
				this,
				FMainUI["TF_Scroll"]);
			FMountPoint = FMainUI["MC_MountPoint"];
		}
		
		//---- Protected Methods -----------------------------------------------		
		
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
		
		//---- Event Handling Methods ------------------------------------------
		
		//---- Property Accessing Methods --------------------------------------
		
		public function get DataCollection():UIListDataCollection 
		{
			return FDataCollection;
		}
		
		public function set DataCollection(value:UIListDataCollection):void 
		{
			FDataCollection = value;
		}
		
		//---- Public Methods ----------------------------------------------------
		
		
	}

}