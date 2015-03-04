package Douban.component 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author zhmq
	 */
	public class UIToggleButton 
	{
		protected static const STATE_NOMAL:int = 1;
		protected static const STATE_OVER:int = 2;
		protected static const STATE_SELECT:int = 3;
		protected var FSubstrate:MovieClip;
		protected var FIsInitialization:Boolean;
		protected var FOnClick:Function;
		protected var FIsSelected:Boolean;
		
		public function UIToggleButton() 
		{
			
		}
		
		protected function Initialization():void
		{
			FIsInitialization = true;
			FSubstrate.mouseChildren = false;
			FSubstrate.tabEnabled = false;
			FSubstrate.buttonMode = true;
			FSubstrate.gotoAndStop(STATE_NOMAL);
			FSubstrate.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
			FSubstrate.addEventListener(MouseEvent.MOUSE_OVER, OnMouseOver);
			FSubstrate.addEventListener(MouseEvent.MOUSE_OUT, OnMouseOut);
		}
		
		private function OnMouseOut(e:MouseEvent):void 
		{
			if (!FIsSelected)
			{
				FSubstrate.gotoAndStop(STATE_NOMAL);
			}
		}
		
		private function OnMouseOver(e:MouseEvent):void 
		{
			if (!FIsSelected)
			{
				FSubstrate.gotoAndStop(STATE_OVER);
			}
		}
		
		private function OnMouseDown(e:MouseEvent):void 
		{
			IsSelected = !IsSelected;
			
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
		
		public function get IsSelected():Boolean 
		{
			return FIsSelected;
		}
		
		public function set IsSelected(value:Boolean):void 
		{
			FIsSelected = value;
			
			if (!FIsSelected)
			{
				FSubstrate.gotoAndStop(STATE_NOMAL);
			}
			else
			{
				FSubstrate.gotoAndStop(STATE_SELECT);
			}
		}
		
		
	}

}