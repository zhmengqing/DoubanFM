package Douban.component.list 
{
	import Douban.component.scroll.UIScrollBar;
	import Douban.component.UIComponent;
	import Douban.consts.CONST_COMMON;
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
		
		protected var FRenderer:Class;
		protected var FOnSelect:Function;
		
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
		
		//---- Event Handling Methods ------------------------------------------
		
		protected function OnRenderSelect(Data:Object):void
		{
			if (FOnSelect != null)
			{
				FOnSelect(
					Data);
			}
		}
		
		//---- Property Accessing Methods --------------------------------------
		
		public function get DataCollection():UIListDataCollection 
		{
			return FDataCollection;
		}
		
		public function set DataCollection(value:UIListDataCollection):void 
		{
			FDataCollection = value;
		}
		
		public function get Renderer():Class 
		{
			return FRenderer;
		}
		
		public function set Renderer(value:Class):void 
		{
			FRenderer = value;
		}
		
		public function get OnSelect():Function 
		{
			return FOnSelect;
		}
		
		public function set OnSelect(value:Function):void 
		{
			FOnSelect = value;
		}
		
		//---- Public Methods ----------------------------------------------------
		
		public function RemoveItem(
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
		
		override public function Update():void 
		{
			super.Update();
			if (FScroller.Direction == CONST_COMMON.SCROLL_VERTICLE)
			{
				FMountPoint.y = FScroller.Locate;
			}
		}
		
		
	}

}