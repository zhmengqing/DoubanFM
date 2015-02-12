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
		
	}

}