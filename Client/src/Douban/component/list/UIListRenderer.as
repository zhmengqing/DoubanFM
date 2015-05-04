package Douban.component.list 
{
	import Douban.component.UIComponent;
	/**
	 * ...
	 * @author zhmq
	 */
	public class UIListRenderer extends UIComponent 
	{
		
		protected var FOnSelect:Function;
		protected var FCurIndex:int;//当前序号
		
		public function UIListRenderer(Parent:UIComponent) 
		{
			super(Parent);
			
		}
		
		public function UpdateData(
			Data:Object):void
		{
			
		}
		
		
		public function get OnSelect():Function 
		{
			return FOnSelect;
		}
		
		public function set OnSelect(value:Function):void 
		{
			FOnSelect = value;
		}
		
		public function get CurIndex():int
		{
			return FCurIndex;
		}
		
		public function set CurIndex(value:int):void
		{
			FCurIndex = value;
		}
		
	}

}