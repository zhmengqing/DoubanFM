package Douban.module.hall.hiddenLists 
{
	import Douban.component.*;
	import Douban.component.list.UIListV;
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
		
		protected var FMainUI:MovieClip;
		protected var FBtnTab:UIButtton;
		protected var FListPannel:UIListV;
		
		//---- Property Fields -------------------------------------------------
		
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
			FMainUI.gotoAndStop(1);
		}
		
		//---- Protected Methods -----------------------------------------------
		
		//---- Event Handling Methods ------------------------------------------
		
		protected function OnPingpong(
			Sender:Object,
			E:MouseEvent):void
		{
			
		}
		
		//---- Property Accessing Methods --------------------------------------
		
		//---- Public Methods ----------------------------------------------------
		
		public function SetData():void
		{
			
		}
	}

}