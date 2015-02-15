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
		public function UIComponent(Parent:UIComponent) 
		{
			super();
			FParent = Parent;
			if (FParent != null)
			{
				FParent.addChild(this);
			}
		}
		
		public function get Visible():Boolean 
		{
			return this.visible;
		}
		
		public function set Visible(value:Boolean):void 
		{
			this.visible = value;
		}
		
		
	}

}