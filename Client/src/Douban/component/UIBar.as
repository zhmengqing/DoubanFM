package Douban.component 
{
	import flash.display.*;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author zhmq
	 */
	public class UIBar 
	{
		protected var FSubstrate:Sprite;
		protected var FBar:Sprite;
		protected var FOnClick:Function;
		protected var FOnOver:Function;
		protected var FOnOut:Function;
		
		protected var FIsInitialization:Boolean;
		
		public function UIBar() 
		{
			
		}
		
		protected function Initialization(): void
		{
			FIsInitialization = true;
			FSubstrate.mouseChildren = false;
			FSubstrate.tabEnabled = false;
			FSubstrate.buttonMode = true;
			
			FBar = FSubstrate["MC_Bar"];
			
			FSubstrate.addEventListener(MouseEvent.CLICK, BtbOnClick);
			FSubstrate.addEventListener(MouseEvent.MOUSE_MOVE, BtbOnOver);
			FSubstrate.addEventListener(MouseEvent.MOUSE_OUT, BtbOnOut);
		}
		
		private function BtbOnOut(e:MouseEvent):void 
		{
			if (FOnOut != null)
			{
				FOnOut(
					this,
					e);
			}
		}
		
		private function BtbOnOver(e:MouseEvent):void 
		{
			if (FOnOver != null)
			{
				FOnOver(
					this,
					e);
			}
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
		
		public function SetBar(Scale:Number):void
		{
			FBar.scaleX = Scale;
		}
		
		public function get Substrate():Sprite 
		{
			return FSubstrate;
		}
		
		public function set Substrate(value:Sprite):void 
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
		
		public function get OnOver():Function 
		{
			return FOnOver;
		}
		
		public function set OnOver(value:Function):void 
		{
			FOnOver = value;
		}
		
		public function get OnOut():Function 
		{
			return FOnOut;
		}
		
		public function set OnOut(value:Function):void 
		{
			FOnOut = value;
		}
		
	}

}