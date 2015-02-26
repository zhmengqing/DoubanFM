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
		public var BarScale:Number;
		protected var FSubstrate:Sprite;
		protected var FBars:Vector.<Sprite>;
		protected var FBarNum:int;
		protected var FIsZero:Boolean;
		protected var FOnClick:Function;
		protected var FOnOver:Function;
		protected var FOnOut:Function;
		
		protected var FIsInitialization:Boolean;
		
		public function UIBar(
			BarNum:int = 1,
			IsZero:Boolean = true)		
		{
			FBarNum = BarNum;
			FIsZero = IsZero;
		}
		
		protected function Initialization(): void
		{
			var Index:int;
			
			FIsInitialization = true;
			FSubstrate.mouseChildren = false;
			FSubstrate.tabEnabled = false;
			FSubstrate.buttonMode = true;
			
			FBars = new Vector.<Sprite>;
			for (Index = 0; Index < FBarNum; Index ++)
			{
				FBars.push(FSubstrate["MC_Bar" + Index]);
				if (FIsZero)
				{
					SetBar(0, Index);
				}
				
			}		
			
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
			BarScale = FSubstrate.mouseX / FSubstrate.width;
			if (FOnOver != null)
			{
				FOnOver(
					this,
					e);
			}
		}
		
		private function BtbOnClick(e:MouseEvent):void 
		{
			BarScale = FSubstrate.mouseX / FSubstrate.width;
			if (FOnClick != null)
			{
				FOnClick(
					this,
					e);
			}
		}
		
		public function SetBar(
			Scale:Number,
			Index:int = 0):void
		{
			FBars[Index].scaleX = Scale;
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