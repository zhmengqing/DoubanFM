package Douban.component 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author zhmq
	 */
	public class UIButtton
	{
		
		protected var FSubstrate:MovieClip;
		protected var FOnClick:Function;
		
		protected var FIsInitialization:Boolean;
		
		public function UIButtton() 
		{
			
		}
		
		protected function Initialization(): void
		{
			FIsInitialization = true;
			FSubstrate.stop();
			FSubstrate.mouseChildren = false;
			FSubstrate.tabEnabled = false;
			FSubstrate.buttonMode = true;
			
			FSubstrate.addEventListener(MouseEvent.CLICK, BtbOnClick);
		}
		
		private function BtbOnClick(e:MouseEvent):void 
		{
			if (FOnClick != null)
			{
				FOnClick(
					this,
					e);
			}
		}
		
		public function get Substrate():MovieClip 
		{
			return FSubstrate;
		}
		
		public function set Substrate(value:MovieClip):void 
		{
			FSubstrate = value;
			
			if (value == null)
			{
				return;
			}
			
			if (value != FSubstrate)
			{
				FSubstrate = value;
			}
			
			if (!FIsInitialization) 
			{
				Initialization();
			}
		}
		
		public function get OnClick():Function 
		{
			return FOnClick;
		}
		
		public function set OnClick(value:Function):void 
		{
			FOnClick = value;
		}
		
	}

}