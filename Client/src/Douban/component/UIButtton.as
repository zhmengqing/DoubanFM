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
		protected var FOnDown:Function;
		protected var FOnUp:Function;
		
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
			
			FSubstrate.addEventListener(MouseEvent.CLICK, BtnOnClick);
			FSubstrate.addEventListener(MouseEvent.MOUSE_DOWN, BtnOnDown);
			FSubstrate.addEventListener(MouseEvent.MOUSE_UP, BtnOnUp);
		}
		
		protected function BtnOnClick(e:MouseEvent):void 
		{
			if (FOnClick != null)
			{
				FOnClick(
					this,
					e);
			}
		}
		
		protected function BtnOnDown(e:MouseEvent):void
		{
			if (FOnDown != null)
			{
				FOnDown(
					this,
					e);
			}
		}
		
		protected function BtnOnUp(e:MouseEvent):void
		{
			if (FOnUp != null)
			{
				FOnUp(
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
		
		public function get Visible():Boolean 
		{
			return FSubstrate.visible;
		}
		
		public function set Visible(value:Boolean):void 
		{
			FSubstrate.visible = value;
		}
		
		public function get X():int 
		{
			return FSubstrate.x;
		}
		
		public function set X(value:int):void 
		{
			FSubstrate.x = value;
		}
		
		public function get Y():int 
		{
			return FSubstrate.y;
		}
		
		public function set Y(value:int):void 
		{
			FSubstrate.y = value;
		}
		
		public function get Height():int 
		{
			return FSubstrate.height;
		}
		
		public function set Height(value:int):void 
		{
			FSubstrate.height = value;
		}
		
		public function get Width():int 
		{
			return FSubstrate.width;
		}
		
		public function set Width(value:int):void 
		{
			FSubstrate.width = value;
		}
		
		public function get OnMouseDown():Function 
		{
			return FOnDown;
		}
		
		public function set OnMouseDown(value:Function):void 
		{
			FOnDown = value;
		}
		
		public function get OnMouseUp():Function 
		{
			return FOnUp;
		}
		
		public function set OnMouseUp(value:Function):void 
		{
			FOnUp = value;
		}
		
	}

}