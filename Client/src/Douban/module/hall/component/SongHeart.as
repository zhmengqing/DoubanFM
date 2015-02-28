package Douban.module.hall.component 
{
	import Douban.component.UIButtton;
	import flash.display.*;
	import flash.events.MouseEvent;
	/**
	 * 红心的切换
	 * @author zhmq
	 */
	public class SongHeart 
	{
		public static const Type_Red:int = 1;
		public static const Type_Black:int = 0;
		
		protected var FMainUI:Sprite;
		protected var FBtnRed:UIButtton;
		protected var FBtnBlack:UIButtton;
		
		protected var FOnRedClick:Function;
		protected var FOnBlackClick:Function;
		
		public function SongHeart(MainUI:Sprite) 
		{
			FMainUI = MainUI;
			FBtnRed = new UIButtton();
			FBtnRed.Substrate = FMainUI["Btn_Red"];
			FBtnRed.OnClick = RedOnClick;
			FBtnRed.Visible = false;
			FBtnBlack = new UIButtton();
			FBtnBlack.Substrate = FMainUI["Btn_Black"];
			FBtnBlack.OnClick = BlackOnClick;
		}
		
		private function RedOnClick(
			Sender:Object,
			E:MouseEvent):void 
		{
			if (OnRedClick != null)
			{
				OnRedClick(
					Sender,
					E)
			}
		}
		
		private function BlackOnClick(
			Sender:Object,
			E:MouseEvent):void 
		{
			if (OnBlackClick != null)
			{
				OnBlackClick(
					Sender,
					E)
			}
		}
		
		public function ShowHeart(Type:int):void
		{
			switch(Type)
			{
				case Type_Red:
					FBtnBlack.Visible = false;
					FBtnRed.Visible = true;
					break;
				case Type_Black:
					FBtnBlack.Visible = true;
					FBtnRed.Visible = false;
					break;
			}
		}
		
		public function get OnRedClick():Function 
		{
			return FOnRedClick;
		}
		
		public function set OnRedClick(value:Function):void 
		{
			FOnRedClick = value;
		}
		
		public function get OnBlackClick():Function 
		{
			return FOnBlackClick;
		}
		
		public function set OnBlackClick(value:Function):void 
		{
			FOnBlackClick = value;
		}
		
	}

}