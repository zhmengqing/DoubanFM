package Douban.module.hall.hiddenLists 
{
	import Douban.component.*;
	import Douban.component.list.UIListRenderer;
	import Douban.component.list.UIListV;
	import Douban.logics.hiddenLists.IListData;
	import Douban.logics.song.VO.SongVO;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 单个标签的隐藏列表
	 * @author zhmq
	 */
	public class HiddenList extends UIComponent 
	{
		//---- Constants -------------------------------------------------------
		
		//---- Protected Fields ------------------------------------------------
		
		protected var FData:IListData;
		protected var FMainUI:MovieClip;
		protected var FBtnTab:UIButtton;
		protected var FListPannel:UIListV;
		protected var FIsShow:Boolean;
		
		//---- Property Fields -------------------------------------------------		
		
		protected var FOnSelect:Function;
		protected var FOnShow:Function;
		
		//---- Constructor -----------------------------------------------------
		
		public function HiddenList(
			Parent:UIComponent,
			MainUI:MovieClip) 
		{
			super(Parent);
			FMainUI = MainUI;
			
			FBtnTab = new UIButtton();
			FBtnTab.Substrate = FMainUI["MC_Tab"];
			FBtnTab.OnClick = OnPingpong;
			
			FListPannel = new UIListV(
				this,
				FMainUI["MC_List"]);
			FListPannel.OnSelect = OnListSelect;
			FMainUI.gotoAndStop(1);
			FIsShow = false;
		}
		
		//---- Protected Methods -----------------------------------------------
		
		//---- Event Handling Methods ------------------------------------------
		
		protected function OnPingpong(
			Sender:Object,
			E:MouseEvent):void
		{
			FIsShow = !FIsShow;
			if (FIsShow)
			{
				FMainUI.gotoAndPlay(1);
				FOnShow();
			}
		}
		
		protected function OnListSelect(Data:Object):void
		{
			FOnSelect(Data);
		}
		
		//---- Property Accessing Methods --------------------------------------
		
		//---- Public Methods ----------------------------------------------------
		
		public function SetData(
			Data:IListData):void
		{
			var Index:int;
			var Count:int;
			var CurY:int;
			
			FData = Data;
			if (Data == null) return;
			
			FListPannel.Clear();
			Count = FData.Count;
			for (Index = 0; Index < Count; Index ++)
			{
				FListPannel.AddItem(
					FData.GetDataByIndex(Index) as SongVO);
				
			}
			
			FListPannel.SetScroll(
				240,
				FListPannel.Height);
		}
		
		override public function Update():void 
		{
			super.Update();
			FListPannel.Update();
		}
		
		public function get Renderer():Class 
		{
			return FListPannel.Renderer;
		}
		
		public function set Renderer(value:Class):void 
		{
			FListPannel.Renderer = value;
		}
		
		public function get OnSelect():Function 
		{
			return FOnSelect;
		}
		
		public function set OnSelect(value:Function):void 
		{
			FOnSelect = value;
		}
		
		public function get OnShow():Function 
		{
			return FOnShow;
		}
		
		public function set OnShow(value:Function):void 
		{
			FOnShow = value;
		}
	}

}