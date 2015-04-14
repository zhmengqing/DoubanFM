package Douban.module.hall.hiddenLists.musicList 
{
	import Douban.component.list.UIListRenderer;
	import Douban.component.UIButtton;
	import Douban.component.UIComponent;
	import Douban.consts.CONST_RESOURCE;
	import Douban.logics.song.VO.SongVO;
	import Douban.manager.statics.DomainManager;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author zhmq
	 */
	public class MusicRenderer extends UIListRenderer 
	{
		//---- Constants -------------------------------------------------------
		
		//---- Protected Fields ------------------------------------------------		
		
		protected var FMainUI:Sprite;
		protected var FTFIndex:TextField;
		protected var FTFMusic:TextField;
		protected var FTFTime:TextField;
		protected var FBtnRender:UIButtton;
		protected var FSongVO:SongVO;
		
		//---- Property Fields -------------------------------------------------
		
		
		//---- Constructor -----------------------------------------------------
		
		public function MusicRenderer(
			Parent:UIComponent) 
		{
			super(Parent);
			
			FMainUI = DomainManager.CreateDisplayByName(
				CONST_RESOURCE.RESOURCE_Render_Music) as Sprite;
				
			this.addChild(FMainUI);
			
			FTFIndex = FMainUI["TF_Index"];
			FTFMusic = FMainUI["TF_Music"];
			FTFTime = FMainUI["TF_Time"];
			FTFIndex.mouseEnabled = false;
			FTFMusic.mouseEnabled = false;
			FTFTime.mouseEnabled = false;
			
			FBtnRender = new UIButtton();
			FBtnRender.Substrate = FMainUI["Btn_Render"];
			FBtnRender.OnClick = OnRenderClick;
		}
		
		
		//---- Protected Methods -----------------------------------------------
		
		protected function OnRenderClick(
			Sender:Object,
			E:MouseEvent):void
		{
			
			FOnSelect(FSongVO);
		}
		
		//---- Event Handling Methods ------------------------------------------
		
		//---- Property Accessing Methods --------------------------------------
		
		//---- Public Methods ----------------------------------------------------
		
		override public function UpdateData(
			Data:Object):void 
		{
			super.UpdateData(Data);
			
			FSongVO = Data as SongVO;
			FTFMusic.text = FSongVO.Artist + " - " + FSongVO.Title;
		}
		
	}

}