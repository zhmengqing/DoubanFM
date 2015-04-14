package Douban.component 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	
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
		
		public function get Parent():UIComponent
		{
			return FParent;
		}
		
		public function get UICore():Stage 
		{
			var Core:UIComponent;
			Core = FParent;
			while (Core.Parent is UIComponent)
			{
				Core = Core.Parent;
				if (Core is UIRoot)
				{
					break;
				}
			}
			return Core.UICore;
			
		}
		
		
		
	}

}