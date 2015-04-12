package Douban.module.hall.hiddenLists 
{
	import Douban.component.UIComponent;
	import Douban.logics.hiddenLists.UnstreamizerHiddenLists;
	import flash.display.Sprite;
	
	/**
	 * 左边的所有隐藏列表，数据处理也放这里
	 * @author zhmq
	 */
	public class ProcessorHallHidden extends UIComponent 
	{
		//---- Constants -------------------------------------------------------
		
		protected static const List_Num:int = 2;
		
		//---- Protected Fields ------------------------------------------------
		
		protected var FMainUI:Sprite;
		protected var FHiddenLists:Vector.<HiddenList>;
		protected var FUnstreamizer:UnstreamizerHiddenLists;
		
		//---- Property Fields -------------------------------------------------
		
		//---- Constructor -----------------------------------------------------
		
		public function ProcessorHallHidden(
			Parent:UIComponent,
			MainUI:Sprite) 
		{
			var Index:int;
			
			super(Parent);
			FMainUI = MainUI;
			FHiddenLists = new Vector.<HiddenList>;
			
			for (Index = 0; Index < List_Num; Index++)
			{
				FHiddenLists[Index] = new HiddenList(
					this,
					FMainUI["MC_List_" + Index]);
			}
			FUnstreamizer = new UnstreamizerHiddenLists();
		}
		
		//---- Protected Methods -----------------------------------------------
		
		//---- Event Handling Methods ------------------------------------------
		
		//---- Property Accessing Methods --------------------------------------
		
		//---- Public Methods ----------------------------------------------------
		
		public function SetData():void
		{
			var Index:int;
			
			for (Index = 0; Index < List_Num; Index++)
			{
				FHiddenLists[Index].SetData();
			}
		}
	}

}