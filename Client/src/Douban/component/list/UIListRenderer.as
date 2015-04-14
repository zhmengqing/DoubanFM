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
		
		
	}

}