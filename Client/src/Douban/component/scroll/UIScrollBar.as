package Douban.component.scroll 
{
	import Douban.component.UIButtton;
	import Douban.component.UIComponent;
	import Douban.consts.*;
	import Douban.manager.statics.DomainManager;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * new的时候传入一个textfield初始化长度和位置
	 * update方法放在逐帧事件中
	 * SetScroll 方法传入显示长度和总长度
	 * 要滚动的元件的位置为 Locate
	 * 
	 * (若已传入textfield则以下的都不需要设置)
	 * 手动横向纵向只需设置Direction
	 * 手动调整长度设置 Length
	 * @author zhmq
	 */
	public class UIScrollBar extends UIComponent 
	{
		//---- Constants -------------------------------------------------------
		
		//bar除以bg的百分比
		protected const Bar_Percent:Number = 0.8;
		//bar与按钮的距离
		protected const Bar_Offset:int = 2;
		//移动一次间隔长度
		protected const Bar_MoveInterval:int = 15;
		
		//---- Protected Fields ------------------------------------------------
		
		protected var FMainUI:Sprite;
		protected var FBtnUp:UIButtton;
		protected var FBtnDown:UIButtton;
		protected var FBtnBar:UIButtton;
		protected var FMCBg:Sprite;
		//滚动条的可活动范围
		protected var FBarHeight:int;
		//上下两个按钮的总高度
		protected var FBtnHeight:int;
		//显示区域与条长度的比例
		protected var FDisplayPerBar:Number;
		protected var FIsDisplay:Boolean;
		//移动方向
		protected var FMoveDirection:int;
		protected var FBarStartPos:int;
		protected var FBarEndPos:int;
		
		//---- Property Fields -------------------------------------------------
		
		protected var FDirection:int;
		protected var FLength:int;
		//滚动条对应显示对象的位置
		protected var FLocate:int;
		
		//---- Constructor -----------------------------------------------------
		/**
		 ** 滚动条组件
		 * @param	Parent
		 * @param	Position 确定滚动条位置跟长度等状态的元件，一般用一个TextField
		 */
		public function UIScrollBar(
			Parent:UIComponent,
			Position:DisplayObject = null) 
		{
			super(Parent);
			
			FMainUI = DomainManager.CreateDisplayByName(
				CONST_RESOURCE.RESOURCE_COMPONENT_ScrollBar) as Sprite;
				
			Position.parent.addChild(FMainUI);
			FMainUI.x = Position.x;
			FMainUI.y = Position.y;
			
			FBtnUp = new UIButtton();
			FBtnUp.Substrate = FMainUI["Btn_Up"];
			//FBtnUp.OnClick = BtnOnClick;
			FBtnUp.OnMouseDown = BtnOnMouseDown;
			FBtnUp.OnMouseUp = BtnOnMouseUp;
			
			FBtnDown = new UIButtton();
			FBtnDown.Substrate = FMainUI["Btn_Down"];
			//FBtnDown.OnClick = BtnOnClick;
			FBtnDown.OnMouseDown = BtnOnMouseDown;
			FBtnDown.OnMouseUp = BtnOnMouseUp;
			
			FBtnBar = new UIButtton();
			FBtnBar.Substrate = FMainUI["Btn_Bar"];
			FBtnBar.OnMouseDown = BarOnDown;
			UICore.addEventListener(MouseEvent.MOUSE_UP, BarOnUp);
			
			FMCBg = FMainUI["MC_Bg"];
			
			FBtnHeight = FBtnUp.Height + FBtnDown.Height + Bar_Offset + Bar_Offset;
			
			if (Position == null) return;
			if (Position.height > Position.width)
			{
				Direction = CONST_COMMON.SCROLL_VERTICLE;
				Length = Position.height;
			}
			else
			{
				Direction = CONST_COMMON.SCROLL_HORIZONTAL;
				Length = Position.width;
			}
		}
		
		//---- Protected Methods -----------------------------------------------
		
		//---- Event Handling Methods ------------------------------------------
		
		protected function BtnOnMouseDown(
			Sender:Object,
			E:MouseEvent):void
		{
			var Btn:UIButtton;
			
			Btn = Sender as UIButtton;
			switch(Btn)
			{
				case FBtnUp:
					FMoveDirection = -1;
					break;
				case FBtnDown:
					FMoveDirection = 1;
					break;
			}
			FIsDisplay = true;
		}
		
		protected function BtnOnMouseUp(
			Sender:Object,
			E:MouseEvent):void
		{
			FIsDisplay = false;
		}
		
		/*protected function BtnOnClick(
			Sender:Object,
			E:MouseEvent):void
		{
			
			
		}*/
		
		protected function BarOnDown(
			Sender:Object,
			E:MouseEvent):void
		{
			var Rect:Rectangle;
			
			Rect = new Rectangle(
				0,
				FBtnUp.Height + Bar_Offset,
				0,
				FLength - FBtnHeight - FBtnBar.Height);
			FBtnBar.Substrate.startDrag(
				false,
				Rect);
			FIsDisplay = true;
			FMoveDirection = 0;
		}
		
		protected function BarOnUp(
			E:MouseEvent):void
		{
			FBtnBar.Substrate.stopDrag();
			FIsDisplay = false;
		}
		
		//---- Property Accessing Methods --------------------------------------
		/**滚动条的长度*/
		public function get Length():int 
		{
			return FLength;
		}
		
		public function set Length(value:int):void 
		{
			FLength = value;
			
			FMCBg.height = FLength;
			FBtnDown.Y = FLength;
			FBarHeight = FLength - FBtnHeight;
			FBarStartPos = FBtnUp.Height + Bar_Offset;
			FBarEndPos = FLength - Bar_Offset - FBtnDown.Height - FBtnBar.Height;
			
			
		}
		/**默认CONST_COMMON.SCROLL_VERTICLE**/
		public function get Direction():int 
		{
			return FDirection;
		}
		
		public function set Direction(value:int):void 
		{
			FDirection = value;
			if (FDirection == CONST_COMMON.SCROLL_HORIZONTAL)
			{
				FMainUI.rotation = -90;
				FMainUI.scaleX = -1;
			}
			else
			{
				FMainUI.rotation = 0;
				FMainUI.scaleX = 1;
			}
		}
		
		public function get Locate():int
		{
			return FLocate;
		}
		
		//---- Public Methods ----------------------------------------------------
		
		/**
		 * 设滚动条的bar长度
		 * @param	DisplayLength  展示区域长度
		 * @param	TotalLength   包括隐藏区域总长度
		 */
		public function SetScroll(
			DisplayLength:int,
			TotalLength:int):void
		{
			var Per:Number;
			
			Per = DisplayLength / TotalLength;
			Per = Per > 1 ? 1 : Per;
			FBtnBar.Height = FBarHeight * Bar_Percent * Per;
			
			FDisplayPerBar = (TotalLength - DisplayLength) / (FBarHeight - FBtnBar.Height);
			
		}
		
		//逐帧运行
		override public function Update():void
		{
			super.Update();
			if (!FIsDisplay) return;
			if (FMoveDirection != 0)
			{
				FBtnBar.Y += FMoveDirection * Bar_MoveInterval;
			}
			
			if (FBtnBar.Y < FBarStartPos)
			{
				FBtnBar.Y = FBarStartPos;
				FIsDisplay = false;
			}
			else if (FBtnBar.Y > FBarEndPos)
			{
				FBtnBar.Y = FBarEndPos;
				FIsDisplay = false;
			}
			FLocate = -FDisplayPerBar * (FBtnBar.Y - FBtnUp.Height - Bar_Offset);
		}
	}

}