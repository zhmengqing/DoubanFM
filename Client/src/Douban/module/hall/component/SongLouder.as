package Douban.module.hall.component 
{
	import Douban.component.UIBar;
	import Douban.consts.CONST_SHAREDOBJECT;
	import Douban.manager.statics.ShareObjectManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author zhmq
	 */
	public class SongLouder 
	{
		protected var FMainUI:MovieClip;
		protected var FLaba:Sprite;
		protected var FLoudBar:UIBar;
		protected var FCurFrame:int;
		protected var FIsPlayBack:Boolean;//动画往回播
		protected var FIsOnBar:Boolean;//在bar上
		
		protected var FOnLouderOver:Function;
		protected var FOnLouderOut:Function;
		protected var FOnVolumeChange:Function;
		public function SongLouder(
			MainUI:MovieClip) 
		{
			FMainUI = MainUI;
			InitView();
		}
		
		protected function InitView():void
		{
			FMainUI.addEventListener(MouseEvent.MOUSE_MOVE, OnOver);
			FMainUI.addEventListener(MouseEvent.MOUSE_OUT, OnOut);
			
			FMainUI.gotoAndStop(1);
			FMainUI.addFrameScript(
				FMainUI.totalFrames - 1,
				FMainUI.stop);
			FLaba = FMainUI["MC_Laba"];
			FLaba.mouseEnabled = false;
			FLoudBar = new UIBar();
			FLoudBar.Substrate = FMainUI["MC_LoudBar"];
			FLoudBar.OnOver = OnBarOver;
			FLoudBar.OnOut = OnBarOut;
			FLoudBar.OnClick = OnLoudClick;
			FLoudBar.WheelEnabled = true;
			FLoudBar.SetBar(
				ShareObjectManager.GetData(CONST_SHAREDOBJECT.VOLUME));
			
			FCurFrame = 0;
			FIsPlayBack = false;
		}
		
		private function OnBarOver(
			Sender:Object,
			E:MouseEvent):void 
		{
			FIsOnBar = true;
		}
		
		private function OnBarOut(
			Sender:Object,
			E:MouseEvent):void 
		{
			FIsOnBar = false;
		}
		
		private function OnOut(e:MouseEvent):void 
		{
			if (FIsOnBar) return;
			FIsPlayBack = true;
			FCurFrame = FMainUI.currentFrame;
			FOnLouderOut();
		}
		
		private function OnOver(e:MouseEvent):void 
		{
			if (FMainUI.currentFrame != FMainUI.totalFrames)
			{
				FMainUI.play();
				FOnLouderOver();
			}
		}
		
		private function OnLoudClick(
			Sender:Object,
			E:MouseEvent):void 
		{
			FLoudBar.SetBar(FLoudBar.BarScale);
			FOnVolumeChange(FLoudBar.BarScale);
		}
		
		public function Update():void
		{
			if (FIsPlayBack)	
			{				
				if (FCurFrame <= 1)
				{
					FIsPlayBack = false;					
				}
				FMainUI.gotoAndStop(FCurFrame--);
			}
		}
		
		public function get OnLouderOver():Function 
		{
			return FOnLouderOver;
		}
		
		public function set OnLouderOver(value:Function):void 
		{
			FOnLouderOver = value;
		}
		
		public function get OnLouderOut():Function 
		{
			return FOnLouderOut;
		}
		
		public function set OnLouderOut(value:Function):void 
		{
			FOnLouderOut = value;
		}
		
		public function get OnVolumeChange():Function 
		{
			return FOnVolumeChange;
		}
		
		public function set OnVolumeChange(value:Function):void 
		{
			FOnVolumeChange = value;
		}
		
	}

}