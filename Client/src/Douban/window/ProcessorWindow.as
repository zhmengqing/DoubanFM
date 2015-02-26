package Douban.window 
{
	import Douban.component.UIComponent;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author zhmq
	 */
	public class ProcessorWindow extends UIComponent 
	{
		
		
		public function ProcessorWindow(
			Parent:UIComponent) 
		{
			super(Parent);
			Parent.addChild(this);
			
			
		}
		
		override public function Update():void 
		{
			var Index:int;
			var Count:int;
			var Child:UIComponent;
			
			super.Update();
			Count = this.numChildren;
			for (Index = 0; Index < Count; Index ++)
			{
				Child = this.getChildAt(Index) as UIComponent;
				if (Child != null)
				{
					Child.Update();
				}
			}
			
		}
		
	}

}