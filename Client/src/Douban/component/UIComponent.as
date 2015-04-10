package Douban.component 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author zhmq
	 */
	public class UIComponent extends Sprite 
	{
		protected var FParent:UIComponent;
		protected var FHeight:int;
		protected var FWidth:int;
		
		public function UIComponent(Parent:UIComponent) 
		{
			super();
			FParent = Parent;
			if (FParent != null)
			{
				FParent.addChild(this);
			}
		}
		
		public function Update():void
		{
			
		}
		
		public function get Visible():Boolean 
		{
			return this.visible;
		}
		
		public function set Visible(value:Boolean):void 
		{
			this.visible = value;
		}
		
		public function get Height():int 
		{
			return FHeight;
		}
		
		public function set Height(value:int):void 
		{
			FHeight = value;
		}
		
		public function get Width():int 
		{
			return FWidth;
		}
		
		public function set Width(value:int):void 
		{
			FWidth = value;
		}
		
		
	}

}