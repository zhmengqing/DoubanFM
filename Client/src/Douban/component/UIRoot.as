package Douban.component 
{
	import flash.display.Stage;
	/**
	 * ...
	 * @author zhmq
	 */
	public class UIRoot extends UIComponent 
	{
		
		public function UIRoot(UIStage:Stage) 
		{
			super(null);
			UIStage.addChild(this);
		}
		
	}

}