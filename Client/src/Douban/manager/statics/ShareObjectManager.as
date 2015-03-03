package Douban.manager.statics 
{
	import Douban.consts.*;
	import flash.net.SharedObject;
	/**
	 * ShareObject处理类
	 * @author zhmq
	 */
	public class ShareObjectManager 
	{
		protected static const Obj_Name:String = "douban_radio";
		protected static const Data_Name:String = "snowzeroClient";
		protected static var FShareData:SharedObject;
		protected static var FShareObj:Object;
		public function ShareObjectManager() 
		{
			
		}
		
		public static function Init():void
		{
			FShareData = SharedObject.getLocal(Obj_Name, "/");
			if (FShareData.data[Data_Name] == undefined)
			{
				FShareObj = new Object();
				FShareObj[CONST_SHAREDOBJECT.VOLUME] = 0.8;
				FShareObj[CONST_SHAREDOBJECT.CHANNEL] = CONST_SONGINFO.PERSONAL_CHANNEL;
				FShareObj[CONST_SHAREDOBJECT.USER_CACHE] = "";
				FShareData.data[Data_Name] = FShareObj;
				return;
			}
			FShareObj = FShareData.data;
		}
		
		public static function GetData(Key:String):*
		{
			return FShareObj[Key];
		}
		
		public static function SetData(
			Key:String,
			Value:*):void
		{
			FShareObj[Key] = Value;
		}
		
		public static function Save():void
		{
			FShareData.data[Data_Name] = FShareObj;
			FShareData.flush();
		}
		
	}

}