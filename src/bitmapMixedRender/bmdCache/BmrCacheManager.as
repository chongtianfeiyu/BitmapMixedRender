package bitmapMixedRender.bmdCache 
{
	import flash.utils.Dictionary;
	/**
	 * 位图动画缓存管理器
	 * @author Alex
	 */
	public class BmrCacheManager
	{
		private var items:Dictionary;
		private static var _instance:BmrCacheManager;
		
		public function BmrCacheManager(param_singletonblocker:SingletonBlocker):void
		{
			if (param_singletonblocker == null) 
			{
				throw new Error("Singleton -> use getinstance instead!");
			}			
			items = new Dictionary();
		}
		
		public static function getInstance():BmrCacheManager 
		{
			if (_instance == null) 
			{
				_instance = new BmrCacheManager(new SingletonBlocker());
			}
			return _instance;
		}
		
		/**
		 * 判断是否存在
		 * @param	link
		 * @return
		 */
		public function isCacheAnimationExist(link:String):Boolean 
		{
			if (getCacheAnimation(link)) 
			{
				return true;
			}
			else 
			{
				return false;
			}
		}
		
		/**
		 * 得到缓存动画
		 * @param	link
		 * @return
		 */
		public function getCacheAnimation(link:String):BmrCacheAnimation
		{
			var cacheAnimation:BmrCacheAnimation = items[link];
			if (cacheAnimation == null)
			{
				cacheAnimation = BmrCacheUtil.createBmrCacheAnimation(link);
			}
			return cacheAnimation;
		}
		
		/**
		 * 添加缓存动画
		 * @param	bmrCacheAnimation
		 */
		public function addCacheAnimation(bmrCacheAnimation:BmrCacheAnimation):void
		{
			items[bmrCacheAnimation.link] = bmrCacheAnimation;
		}
		
		/**
		 * 删除缓存动画
		 * @param	link
		 */
		public function deleteCacheAnimation(link:String):void
		{
			var bmrCacheAnimation:BmrCacheAnimation = items[link];
			if (bmrCacheAnimation) 
			{
				bmrCacheAnimation.dispose();
			}
			delete items[link];
		}
		
		/**
		 * 清除所有缓存动画
		 */
		public function clearCacheAnimations():void
		{
			for each (var bmrCacheAnimation:BmrCacheAnimation in items)
			{
				bmrCacheAnimation.dispose();
				delete items[bmrCacheAnimation.link];
			}
		}		
	}
}
internal class SingletonBlocker{}