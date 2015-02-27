package Douban.consts 
{
	/**
	 * ...
	 * @author zhmq
	 */
	public class CONST_SONGINFO 
	{
		public static const TYPE_PLAYOUT:String = "p";	//列表的音乐播完
        public static const TYPE_PLAYED:String = "e";	//自然跳转下一首，就是列表里轮播
        public static const TYPE_LIKE:String = "r";		//喜欢
        public static const TYPE_BAN:String = "b";		//垃圾箱
        public static const TYPE_UNLIKE:String = "u";	//取消喜欢
        public static const TYPE_NEW:String = "n";		//列表跳转
        public static const TYPE_SKIP:String = "s";		//下一首
		
		public static const CHANNEL_OFFLINE_ERROR:String = "2";
        public static const PERSONAL_CHANNEL:String = "0";
        public static const RED_HEART_CHANNEL:String = "-3";
        public static const PERSONAL_HIGH_CHANNEL:String = "-4";
        public static const PERSONAL_EASY_CHANNEL:String = "-5";
        public static const RED_HEART_HIGH_CHANNEL:String = "-6";
        public static const RED_HEART_EASY_CHANNEL:String = "-7";
        public static const RED_HEART_TAGS_CHANNEL:String = "-8";
        public static const PERSONAL_TAGS_CHANNEL:String = "-9";
		
		public static const FROM_MAINSITE:String = "mainsite";
		
		public static const MD5_KEY:String = "fr0d0";
		
	}

}