package Douban.component 
{
	import flash.display.*;
	import flash.events.MouseEvent;
	/**
	 * 进度条
	 * @author zhmq
	 * 
	 * @param 进度条中的Bar个数
	 * @param 是否全部置为零
	 * Substrate 进度条资源赋值，里面每个bar分别赋值为MC_Bar0，MC_Bar1
	 * 可响应click，over，out的鼠标事件
	 * wheel事件要WheelEnabled为true的时候
	 * BarScale是当前上层的bar
	 */
	public class UIBar 
	{
		//滚动的时候bar进度
		protected static const Wheel_Offset:Number = 0.05;
		
		public var BarScale:Number;
		protected var FSubstrate:Sprite;
		protected var FBars:Vector.<Sprite>;
		protected var FBarNum:int;
		protected var FIsZero:Boolean;
		protected var FOnClick:Function;
		protected var FOnOver:Function;
		protected var FOnOut:Function;
		protected var FWheelEnabled:Boolean;
		
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
			
			FSubstrate.addEventListener(MouseEvent.MOUSE_DOWN, BarOnClick);
			FSubstrate.addEventListener(MouseEvent.MOUSE_MOVE, BarOnOver);
			FSubstrate.addEventListener(MouseEvent.MOUSE_OUT, BarOnOut);
			FSubstrate.addEventListener(MouseEvent.MOUSE_WHEEL, BarOnWheel);
		}
		
		//有缺陷，只会设置第零个bar
		private function BarOnWheel(e:MouseEvent):void 
		{
			if (!FWheelEnabled) return;
			if (e.delta > 0)
			{
				BarScale += Wheel_Offset;
				BarScale = BarScale > 1?1:BarScale;				
			}
			else
			{
				BarScale -= Wheel_Offset;
				BarScale = BarScale < 0?0:BarScale;				
			}
			
			if (FOnClick != null)
			{
				FOnClick(
					this,
					e);
			}
		}
		
		private function BarOnOut(e:MouseEvent):void 
		{
			//e.stopImmediatePropagation();
			e.stopPropagation();
			if (FOnOut != null)
			{
				FOnOut(
					this,
					e);
			}
		}
		
		private function BarOnOver(e:MouseEvent):void 
		{
			//e.stopImmediatePropagation();
			e.stopPropagation();
			BarScale = FSubstrate.mouseX / FSubstrate.width;
			if (FOnOver != null)
			{
				FOnOver(
					this,
					e);
			}
		}
		
		private function BarOnClick(e:MouseEvent):void 
		{
			BarScale = FSubstrate.mouseX / FSubstrate.width;
			BarScale = Number(BarScale.toFixed(2));
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
		
		public function get WheelEnabled():Boolean 
		{
			return FWheelEnabled;
		}
		
		public function set WheelEnabled(value:Boolean):void 
		{
			FWheelEnabled = value;
		}
		
	}

}